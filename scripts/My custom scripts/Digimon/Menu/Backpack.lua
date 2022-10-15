OnLibraryInit({name = "Backpack", "UnitEnum", "GetSyncedData", "GetMainSelectedUnit", "PlayerUtils"}, function ()
    local Backpack = nil ---@type framehandle
    local BackdropBackpack = nil ---@type framehandle
    local BackpackMenu = nil ---@type framehandle
    local BackpackText = nil ---@type framehandle
    local BackpackDiscard = nil ---@type framehandle
    local BackpackItems = nil ---@type framehandle
    local BackpackItemT = {} ---@type framehandle[]
    local BackdropBackpackItemT = {} ---@type framehandle[]
    local BackpackItemCooldownT = {} ---@type framehandle[]
    local BackPackItemChargesBackdrop = {} ---@type framehandle[]
    local BackPackItemCharges = {} ---@type framehandle[]
    local BackpackItemTooltip = {} ---@type framehandle[]
    local BackpackItemTooltipText = {} ---@type framehandle[]

    ---@class ItemData
    ---@field id integer
    ---@field spell integer
    ---@field order integer
    ---@field level integer
    ---@field charges integer
    ---@field description string
    ---@field cooldown integer
    ---@field spellCooldown integer

    local PlayerItems = {} ---@type table<player, ItemData[]>
    local MinRange = 700. ---The minimun range a player's digimon should be to the target to cast the spell
    local DiscardMode = __jarray(false) ---@type table<player, boolean>

    local AllowedItems = {}

    local LocalPlayer = nil ---@type player

    ---@param itemId integer
    ---@return ItemData
    local function CreateItemData(itemId)
        if not AllowedItems[itemId] then
            return nil
        end
        local itemData = {
            id = itemId,
            spell = AllowedItems[itemId].ability,
            order = AllowedItems[itemId].order,
            level = AllowedItems[itemId].level,
            charges = 0,
            description = GetObjectName(itemId) .. "\n" .. BlzGetAbilityExtendedTooltip(itemId, 0)
        }
        itemData.cooldown = 0
        itemData.spellCooldown = math.floor(BlzGetAbilityCooldown(itemData.spell, itemData.level - 1))

        return itemData
    end

    ---Always use this function in a `if player == GetLocalPlayer() then` block
    local function UpdateMenu()
        local items = PlayerItems[LocalPlayer]
        for i = 1, 16 do
            BlzFrameSetVisible(BackpackItemT[i], false)
        end

        for i, itemData in ipairs(items) do
            BlzFrameSetTexture(BackdropBackpackItemT[i], BlzGetAbilityIcon(itemData.id), 0, true)
            BlzFrameSetText(BackPackItemCharges[i], tostring(itemData.charges))

            BlzFrameSetText(BackpackItemTooltipText[i], itemData.description)
            BlzFrameSetSize(BackpackItemTooltipText[i], 0.15, 0)
            BlzFrameClearAllPoints(BackpackItemTooltip[i])
            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_TOPLEFT, BackpackItemTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_BOTTOMRIGHT, BackpackItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)

            BlzFrameSetVisible(BackpackItemT[i], true)
        end
    end

    local function BackpackFunc()
        local p = GetTriggerPlayer()
        DiscardMode[p] = false
        if p == LocalPlayer then
            if not BlzFrameIsVisible(BackpackMenu) then
                BlzFrameSetText(BackpackText, "Use an item for the focused unit")
                BlzFrameSetVisible(BackpackMenu, true)
                UpdateMenu()
            else
                BlzFrameSetVisible(BackpackMenu, false)
            end
        end
    end

    local function UseItem(i)
        local p = GetTriggerPlayer()
        if not DiscardMode[p] then
            local itemData = PlayerItems[p][i]
            if itemData.cooldown > 0 then
                BlzFrameSetText(BackpackText, "|cffffcc00Item is on cooldown|r")
                return
            end
            local u = GetSyncedData(p, GetMainSelectedUnitEx)
            if u then
                if GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), MinRange, function (u2) return GetOwningPlayer(u2) == p and Digimon.getInstance(u2) ~= nil end) then
                    if DummyCast(p, GetUnitX(u), GetUnitY(u), itemData.spell, itemData.order, itemData.level, CastType.TARGET, u) then
                        itemData.charges = itemData.charges - 1

                        if itemData.charges == 0 then
                            table.remove(PlayerItems[p], i)
                        else
                            if itemData.spellCooldown > 0 then
                                itemData.cooldown = itemData.spellCooldown
                                BlzFrameSetVisible(BackpackItemCooldownT[i], true)
                                BlzFrameSetText(BackpackItemCooldownT[i], tostring(itemData.cooldown))
                                Timed.echo(function ()
                                    itemData.cooldown = itemData.cooldown - 1
                                    if itemData.cooldown > 0 then
                                        BlzFrameSetText(BackpackItemCooldownT[i], tostring(itemData.cooldown))
                                    else
                                        BlzFrameSetVisible(BackpackItemCooldownT[i], false)
                                        return true
                                    end
                                end, 1.)
                            end
                        end

                        if p == LocalPlayer then
                            UpdateMenu()
                        end
                    else
                        if p == LocalPlayer then
                            BlzFrameSetText(BackpackText, "|cffffcc00Invalid target|r")
                        end
                    end
                else
                    if p == LocalPlayer then
                        BlzFrameSetText(BackpackText, "|cffffcc00A digimon should be nearby the target|r")
                    end
                end
            else
                if p == LocalPlayer then
                    BlzFrameSetText(BackpackText, "|cffff0000You don't have a unit focused|r")
                end
            end
            PolledWait(1.)
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item for the focused unit")
            end
        else
            table.remove(PlayerItems[p], i)
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item for the focused unit")
                UpdateMenu()
            end
        end
    end

    local function BackpackDiscardFunc()
        local p = GetTriggerPlayer()
        if not DiscardMode[p] then
            DiscardMode[p] = true
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "|cffffcc00Select to discard an item.|r Press again to cancel")
            end
        else
            DiscardMode[p] = false
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item for the focused unit")
            end
        end
    end

    local function InitFrames()
        local t = nil ---@type trigger

        Backpack = BlzCreateFrame("IconButtonTemplate", BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), 0, 0)
        BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_TOPLEFT, 0.760000, 0.195000)
        BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_BOTTOMRIGHT, 0.790000, 0.165000)
        BlzFrameSetVisible(Backpack, false)

        BackdropBackpack = BlzCreateFrameByType("BACKDROP", "BackdropBackpack", Backpack, "", 0)
        BlzFrameSetAllPoints(BackdropBackpack, Backpack)
        BlzFrameSetTexture(BackdropBackpack, "ReplaceableTextures\\CommandButtons\\BTNDustOfAppearance.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Backpack, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BackpackFunc)

        BackpackMenu = BlzCreateFrame("CheckListBox", BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), 0, 0)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_TOPLEFT, 0.680000, 0.345000)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.195000)
        BlzFrameSetVisible(BackpackMenu, false)

        BackpackText = BlzCreateFrameByType("TEXT", "name", BackpackMenu, "", 0)
        BlzFrameSetPoint(BackpackText, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.0050000)
        BlzFrameSetPoint(BackpackText, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.12000)
        BlzFrameSetText(BackpackText, "Use an item for the focused digimon")
        BlzFrameSetEnable(BackpackText, false)
        BlzFrameSetScale(BackpackText, 1.00)
        BlzFrameSetTextAlignment(BackpackText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        BackpackDiscard = BlzCreateFrame("ScriptDialogButton", BackpackMenu, 0, 0)
        BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.14245)
        BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0025500)
        BlzFrameSetText(BackpackDiscard, "|cffFCD20DDiscard|r")
        BlzFrameSetScale(BackpackDiscard, 0.858)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, BackpackDiscard, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BackpackDiscardFunc)

        BackpackItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", BackpackMenu, "", 1)
        BlzFrameSetPoint(BackpackItems, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(BackpackItems, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.020000)
        BlzFrameSetTexture(BackpackItems, "war3mapImported\\EmptyBTN.blp", 0, true)

        local x, y = {}, {}
        local stepSize = 0.025

        local startY = 0
        for row = 1, 4 do
            local startX = 0
            for colum = 1, 4 do
                local index = 4 * (row - 1) + colum

                x[index] = startX
                y[index] = startY

                startX = startX + stepSize
            end
            startY = startY - stepSize
        end

        for i = 1, 16 do
            BackpackItemT[i] = BlzCreateFrame("IconButtonTemplate", BackpackItems, 0, 0)
            BlzFrameSetPoint(BackpackItemT[i], FRAMEPOINT_TOPLEFT, BackpackItems, FRAMEPOINT_TOPLEFT, x[i], y[i])
            BlzFrameSetSize(BackpackItemT[i], stepSize, stepSize)
            BlzFrameSetVisible(BackpackItemT[i], false)

            BackdropBackpackItemT[i] = BlzCreateFrameByType("BACKDROP", "BackdropBackpackItemT[" .. i .. "]", BackpackItemT[i], "", 0)
            BlzFrameSetAllPoints(BackdropBackpackItemT[i], BackpackItemT[i])
            BlzFrameSetTexture(BackdropBackpackItemT[i], "", 0, true)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, BackpackItemT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () UseItem(i) end)

            BackPackItemChargesBackdrop[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", BackpackItemT[i], "", 1)
            BlzFrameSetPoint(BackPackItemChargesBackdrop[i], FRAMEPOINT_TOPLEFT, BackpackItemT[i], FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
            BlzFrameSetPoint(BackPackItemChargesBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, BackpackItemT[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetTexture(BackPackItemChargesBackdrop[i], "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp", 0, true)

            BackpackItemCooldownT[i] = BlzCreateFrameByType("TEXT", "name", BackdropBackpackItemT[i], "", 0)
            BlzFrameSetAllPoints(BackpackItemCooldownT[i], BackpackItemT[i])
            BlzFrameSetText(BackpackItemCooldownT[i], "0")
            BlzFrameSetEnable(BackpackItemCooldownT[i], false)
            BlzFrameSetScale(BackpackItemCooldownT[i], 1.5)
            BlzFrameSetTextAlignment(BackpackItemCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(BackpackItemCooldownT[i], 4)
            BlzFrameSetVisible(BackpackItemCooldownT[i], false)

            BackPackItemCharges[i] = BlzCreateFrameByType("TEXT", "name", BackPackItemChargesBackdrop[i], "", 0)
            BlzFrameSetPoint(BackPackItemCharges[i], FRAMEPOINT_TOPLEFT, BackPackItemChargesBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.0010000)
            BlzFrameSetPoint(BackPackItemCharges[i], FRAMEPOINT_BOTTOMRIGHT, BackPackItemChargesBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.0010000, 0.0010000)
            BlzFrameSetText(BackPackItemCharges[i], "99")
            BlzFrameSetEnable(BackPackItemCharges[i], false)
            BlzFrameSetScale(BackPackItemCharges[i], 0.572)
            BlzFrameSetTextAlignment(BackPackItemCharges[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_CENTER)

            BackpackItemTooltip[i] = BlzCreateFrame("QuestButtonBaseTemplate", BackpackItemT[i], 0, 0)

            BackpackItemTooltipText[i] = BlzCreateFrameByType("TEXT", "name", BackpackItemTooltip[i], "", 0)
            BlzFrameSetPoint(BackpackItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, BackpackItemT[i], FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.025000)
            BlzFrameSetText(BackpackItemTooltipText[i], "Empty")
            BlzFrameSetEnable(BackpackItemTooltipText[i], false)
            BlzFrameSetScale(BackpackItemTooltipText[i], 1.00)
            BlzFrameSetTextAlignment(BackpackItemTooltipText[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_TOPLEFT, BackpackItemTooltipText[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_BOTTOMRIGHT, BackpackItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)
            BlzFrameSetTooltip(BackpackItemT[i], BackpackItemTooltip[i])
        end

    end

    local gotItem = __jarray(false) ---@type table<player, boolean>

    OnTrigInit(function ()
        ForForce(FORCE_PLAYING, function ()
            PlayerItems[GetEnumPlayer()] = {}
        end)

        InitFrames()
        FrameLoaderAdd(InitFrames)

        LocalPlayer = GetLocalPlayer()

        -- Store the charged items
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddAction(t, function ()
            local m = GetManipulatedItem()
            if AllowedItems[GetItemTypeId(m)] then
                local p = GetOwningPlayer(GetManipulatingUnit())
                local items = PlayerItems[p]
                local id = GetItemTypeId(m)
                local itemData ---@type ItemData

                gotItem[p] = true
                ShowBackpack(p, true)

                for _, v in ipairs(items) do
                    if v.id == id then
                        itemData = v
                        break
                    end
                end

                if not itemData then
                    itemData = CreateItemData(id)
                    table.insert(items, itemData)
                end
                itemData.charges = itemData.charges + GetItemCharges(m)
                RemoveItem(m)
                if p == LocalPlayer then
                    UpdateMenu()
                end
            end
        end)

        -- For GUI

        udg_BackpackRun = CreateTrigger()
        TriggerAddAction(udg_BackpackRun, function ()
            AllowedItems[udg_BackpackItem] = {
                ability = udg_BackpackAbility,
                order = Orders[udg_BackpackOrder],
                level = udg_BackpackLevel,
            }

            udg_BackpackItem = 0
            udg_BackpackAbility = 0
            udg_BackpackOrder = ""
            udg_BackpackLevel = 1
        end)
    end)

    ---@param p any
    ---@param flag boolean
    ---@param bypass? boolean
    function ShowBackpack(p, flag, bypass)
        if gotItem[p] or bypass then
            if p == LocalPlayer then
                BlzFrameSetVisible(Backpack, flag)
            end
        end
    end

    ---@param p any
    ---@return ItemData[]
    function GetBackpackItems(p)
        return PlayerItems[p]
    end

    ---@param p any
    ---@param items integer[]
    ---@param charges? integer[]
    function SetBackpackItems(p, items, charges)
        for i = 1, #items do
            PlayerItems[p][i] = CreateItemData(items[i])
            if charges then
                PlayerItems[p][i].charges = charges[i]
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

end)
