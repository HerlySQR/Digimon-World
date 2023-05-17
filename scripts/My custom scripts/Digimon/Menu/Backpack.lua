Debug.beginFile("Backpack")
OnInit("Backpack", function ()
    Require "UnitEnum"
    Require "PlayerUtils"
    Require "GlobalRemap"
    Require "WorldBounds"
    Require "Orders"
    Require "Timed"
    Require "ErrorMessage"
    Require "Menu"
    Require "Hotkeys"

    local OriginFrame = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local Backpack = nil ---@type framehandle
    local BackdropBackpack = nil ---@type framehandle
    local BackpackSprite = nil ---@type framehandle
    local BackpackMenu = nil ---@type framehandle
    local BackpackText = nil ---@type framehandle
    local BackpackDiscard = nil ---@type framehandle
    local BackpackDrop = nil ---@type framehandle
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
    ---@field level integer
    ---@field charges integer
    ---@field description string
    ---@field spellCooldown integer
    ---@field slot integer
    ---@field stopped boolean

    local dummyCaster = FourCC('n01B')
    local dummyCasters = {} ---@type table<player, unit>
    local usingDummyCaster = __jarray(false) ---@type table<player, boolean>
    local selectedUnits = {} ---@type table<player, group>
    local itemDatas = {} ---@type table<unit, ItemData>
    local cooldowns = __jarray(0) ---@type table<integer, number>

    local PlayerItems = {} ---@type table<player, ItemData[]>
    local MinRange = 700. ---The minimun range a player's digimon should be to the target to cast the spell
    local MAX_STACK = udg_MAX_STACK ---The maximun number of items that you can have in every slot
    local MAX_ITEMS = udg_MAX_ITEMS
    local DiscardMode = __jarray(false) ---@type table<player, boolean>
    local DropMode = __jarray(false) ---@type table<player, boolean>

    local AllowedItems = {}

    GlobalRemap("udg_GoesToBackpack", function () return AllowedItems[udg_BackpackItem] ~= nil end, nil)

    local LocalPlayer = GetLocalPlayer() ---@type player

    ---@param itemId integer
    ---@return ItemData
    local function CreateItemData(itemId)
        if not AllowedItems[itemId] then
            return nil
        end
        local itemData = {
            id = itemId,
            spell = AllowedItems[itemId].ability,
            level = AllowedItems[itemId].level,
            charges = 0,
            description = GetObjectName(itemId) .. "\n" .. BlzGetAbilityExtendedTooltip(itemId, 0),
            stopped = false
        }
        itemData.spellCooldown = math.floor(BlzGetAbilityCooldown(itemData.spell, itemData.level - 1))

        return itemData
    end

    local function UpdateCooldowns()
        local items = PlayerItems[LocalPlayer]

        for i, itemData in ipairs(items) do
            if cooldowns[itemData.id] > 0 then
                BlzFrameSetVisible(BackpackItemCooldownT[i], true)
                BlzFrameSetText(BackpackItemCooldownT[i], tostring(cooldowns[itemData.id]))
            else
                BlzFrameSetVisible(BackpackItemCooldownT[i], false)
            end
        end
    end

    ---Always use this function in a `if player == GetLocalPlayer() then` block
    local function UpdateMenu()
        local items = PlayerItems[LocalPlayer]
        for i = 1, MAX_ITEMS do
            BlzFrameSetVisible(BackpackItemT[i], false)
        end

        for i, itemData in ipairs(items) do
            BlzFrameSetTexture(BackdropBackpackItemT[i], BlzGetAbilityIcon(itemData.id), 0, true)
            BlzFrameSetText(BackPackItemCharges[i], I2S(itemData.charges))

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
            -- To unfocus the button
            BlzFrameSetEnable(Backpack, false)
            BlzFrameSetEnable(Backpack, true)

            if not BlzFrameIsVisible(BackpackMenu) then
                BlzFrameSetText(BackpackText, "Use an item")
                BlzFrameSetVisible(BackpackMenu, true)
                AddButtonToEscStack(Backpack)
                UpdateMenu()
            else
                BlzFrameSetVisible(BackpackMenu, false)
                RemoveButtonFromEscStack(Backpack)
            end
        end
    end

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            local p = GetEnumPlayer()
            dummyCasters[p] = CreateUnit(Digimon.PASSIVE, dummyCaster, WorldBounds.maxX, WorldBounds.maxY, 0)
            selectedUnits[p] = CreateGroup()
        end)
    end)

    local function UseItem(i)
        local p = GetTriggerPlayer()
        if DiscardMode[p] then
            DiscardMode[p] = false
            table.remove(PlayerItems[p], i)
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
                UpdateMenu()
            end
        elseif DropMode[p] then
            DropMode[p] = false
            local d = GetMainDigimon(p)
            if not d then
                if p == LocalPlayer then
                    BlzFrameSetText(BackpackText, "|cffffcc00There is no a main digimon|r")
                end
                Timed.call(2., function ()
                    if p == LocalPlayer then
                        if BlzFrameGetText(BackpackText) == "|cffffcc00There is no a main digimon|r" then
                            BlzFrameSetText(BackpackText, "Use an item")
                        end
                    end
                end)
                return
            end
            local data = table.remove(PlayerItems[p], i) ---@type ItemData

            SetItemCharges(CreateItem(data.id, d:getPos()), data.charges)

            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
                UpdateMenu()
            end
        else
            local itemData = PlayerItems[p][i]
            if cooldowns[itemData.id] > 0 then
                if p == LocalPlayer then
                    BlzFrameSetText(BackpackText, "|cffffcc00Item is on cooldown|r")
                end
                Timed.call(2., function ()
                    if p == LocalPlayer then
                        if BlzFrameGetText(BackpackText) == "|cffffcc00Item is on cooldown|r" then
                            BlzFrameSetText(BackpackText, "Use an item")
                        end
                    end
                end)
                return
            end
            local caster = dummyCasters[p]
            SetUnitOwner(caster, p, false)
            SyncSelections()
            GroupEnumUnitsSelected(selectedUnits[p], p)
            UnitAddAbility(caster, itemData.spell)
            itemDatas[caster] = itemData

            if p == LocalPlayer then
                SelectUnitSingle(caster)
            end
            Timed.call(0.04, function ()
                if p == LocalPlayer then
                    ForceUIKey("Q")
                end
            end)
            usingDummyCaster[p] = true

            if p == LocalPlayer then
                for j = 1, MAX_ITEMS do
                    BlzFrameSetEnable(BackpackItemT[j], false)
                end
                BlzFrameSetEnable(BackpackDiscard, false)
                BlzFrameSetEnable(BackpackDrop, false)
                BlzFrameSetText(BackpackText, "|cff00ff00Select a target|r")
            end
        end
    end

    ---@param p player
    local function BackpackDummyCastEnd(p)
        UnitRemoveAbility(dummyCasters[p], itemDatas[dummyCasters[p]].spell)
        SetUnitOwner(dummyCasters[p], Digimon.PASSIVE, false)
        if p == LocalPlayer then
            for i = 1, MAX_ITEMS do
                BlzFrameSetEnable(BackpackItemT[i], true)
            end
            BlzFrameSetEnable(BackpackDiscard, true)
            BlzFrameSetEnable(BackpackDrop, true)
            ClearSelection()
        end
        ForGroup(selectedUnits[p], function ()
            if p == LocalPlayer then
                SelectUnit(GetEnumUnit(), true)
            end
        end)
        GroupClear(selectedUnits[p])
        usingDummyCaster[p] = false

        if p == LocalPlayer then
            BlzFrameSetText(BackpackText, "Use an item")
        end
    end

    local trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CAST)
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local itemData = itemDatas[caster]

        if itemData and itemData.spell == GetSpellAbilityId() then

            itemData.stopped = true -- This will set to false if is casts

            local p = GetOwningPlayer(caster)
            local target = GetSpellTargetUnit()
            local x = target and GetUnitX(target) or GetSpellTargetX()
            local y = target and GetUnitY(target) or GetSpellTargetY()

            if not GetRandomUnitOnRange(x, y, MinRange, function (u2) return GetOwningPlayer(u2) == p and Digimon.getInstance(u2) ~= nil end) then
                UnitAbortCurrentOrder(caster)
                ErrorMessage("A digimon should be nearby the target", p)
            end
        end
    end)

    trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local itemData = itemDatas[caster]

        if itemData and itemData.spell == GetSpellAbilityId() then
            itemData.stopped = false
        end
    end)

    trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local itemData = itemDatas[caster]

        if itemData and itemData.spell == GetSpellAbilityId() then
            local p = GetOwningPlayer(caster)
            local i = itemData.slot

            if not itemData.stopped then
                itemData.charges = itemData.charges - 1

                if itemData.charges <= 0 then
                    table.remove(PlayerItems[p], i)
                    for newSlot, otherData in ipairs(PlayerItems[p]) do
                        otherData.slot = newSlot
                    end
                else
                    if itemData.spellCooldown > 0 then
                        cooldowns[itemData.id] = itemData.spellCooldown
                        if p == LocalPlayer then
                            UpdateCooldowns()
                        end
                        Timed.echo(1., function ()
                            cooldowns[itemData.id] = cooldowns[itemData.id] - 1
                            if p == LocalPlayer then
                                UpdateCooldowns()
                            end
                            if cooldowns[itemData.id] <= 0 then
                                return true
                            end
                        end)
                    end
                end
            else
                itemData.stopped = false
            end

            if p == LocalPlayer then
                UpdateMenu()
            end

            BackpackDummyCastEnd(p)
        end
    end)

    OnInit.final(function ()
        trig = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerEvent(trig, GetEnumPlayer(), EVENT_PLAYER_MOUSE_DOWN)
            TriggerRegisterPlayerEvent(trig, GetEnumPlayer(), EVENT_PLAYER_END_CINEMATIC)
        end)
        TriggerAddAction(trig, function ()
            if GetTriggerEventId() ~= EVENT_PLAYER_MOUSE_DOWN or BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
                local p = GetTriggerPlayer()
                if usingDummyCaster[p] then
                    BackpackDummyCastEnd(p)
                end
            end
        end)

        trig = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerUnitEvent(trig, GetEnumPlayer(), EVENT_PLAYER_UNIT_DESELECTED)
        end)
        TriggerAddAction(trig, function ()
            local p = GetTriggerPlayer()
            if GetTriggerUnit() == dummyCasters[p] then
                BackpackDummyCastEnd(p)
            end
        end)
    end)

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
                BlzFrameSetText(BackpackText, "Use an item")
            end
        end
    end

    local function BackpackDropFunc()
        local p = GetTriggerPlayer()
        if not DropMode[p] then
            DropMode[p] = true
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "|cffffcc00Select to drop an item.|r Press again to cancel")
            end
        else
            DropMode[p] = false
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
            end
        end
    end

    local function InitFrames()
        local t = nil ---@type trigger
        local start = 0

        Backpack = BlzCreateFrame("IconButtonTemplate", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_TOPLEFT, 0.555000, 0.180000)
        BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_BOTTOMRIGHT, 0.590000, 0.145000)
        BlzFrameSetVisible(Backpack, false)
        AddFrameToMenu(Backpack)
        AssignFrame(Backpack, start) -- 0

        BackdropBackpack = BlzCreateFrameByType("BACKDROP", "BackdropBackpack", Backpack, "", 0)
        BlzFrameSetAllPoints(BackdropBackpack, Backpack)
        BlzFrameSetTexture(BackdropBackpack, "ReplaceableTextures\\CommandButtons\\BTNBackpackIcon.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Backpack, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BackpackFunc)

        BackpackSprite =  BlzCreateFrameByType("SPRITE", "BackpackSprite", Backpack, "", 0)
        BlzFrameSetAllPoints(BackpackSprite, Backpack)
        BlzFrameSetModel(BackpackSprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameSetScale(BackpackSprite, BlzFrameGetWidth(BackpackSprite)/0.039)
        BlzFrameSetVisible(BackpackSprite, false)

        BackpackMenu = BlzCreateFrame("CheckListBox", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_TOPLEFT, 0.590000, 0.32000)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, 0.71000, 0.17000)
        BlzFrameSetVisible(BackpackMenu, false)
        AddFrameToMenu(BackpackMenu)

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
        start = start + 1
        AssignFrame(BackpackDiscard, start) -- 1

        BackpackDrop = BlzCreateFrame("ScriptDialogButton", BackpackMenu, 0, 0)
        BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.14245)
        BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.0025500)
        BlzFrameSetText(BackpackDrop, "|cffFCD20DDrop|r")
        BlzFrameSetScale(BackpackDrop, 0.858)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, BackpackDrop, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BackpackDropFunc)
        start = start + 1
        AssignFrame(BackpackDrop, start) -- 2

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

        for i = 1, MAX_ITEMS do
            BackpackItemT[i] = BlzCreateFrame("IconButtonTemplate", BackpackItems, 0, 0)
            BlzFrameSetPoint(BackpackItemT[i], FRAMEPOINT_TOPLEFT, BackpackItems, FRAMEPOINT_TOPLEFT, x[i], y[i])
            BlzFrameSetSize(BackpackItemT[i], stepSize, stepSize)
            BlzFrameSetVisible(BackpackItemT[i], false)
            start = start + 1
            AssignFrame(BackpackItemT[i], start) -- start in 3 and end in 19

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

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        PlayerItems[Player(i)] = {}
    end

    FrameLoaderAdd(InitFrames)

    -- Store the charged items
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local m = GetManipulatedItem()
        if AllowedItems[GetItemTypeId(m)] then
            local u = GetManipulatingUnit()
            local p = GetOwningPlayer(u)
            local items = PlayerItems[p]

            local id = GetItemTypeId(m)
            local itemData ---@type ItemData

            if not gotItem[p] then
                if p == LocalPlayer then
                    BlzFrameSetVisible(BackpackSprite, true)
                    BlzFrameSetSpriteAnimate(BackpackSprite, 1, 0)
                end
                Timed.call(8., function ()
                    if p == LocalPlayer then
                        BlzFrameSetVisible(BackpackSprite, false)
                    end
                end)
            end

            gotItem[p] = true
            ShowBackpack(p, true)

            for _, v in ipairs(items) do
                if v.id == id and v.charges < MAX_STACK then
                    itemData = v
                    break
                end
            end

            if not itemData then
                if #items >= MAX_ITEMS then
                    UnitRemoveItem(u, m)
                    ErrorMessage("Backpack is full", p)
                    return
                end
                itemData = CreateItemData(id)
                table.insert(items, itemData)
                itemData.slot = #items
            end
            itemData.charges = itemData.charges + GetItemCharges(m)
            RemoveItem(m)
            if p == LocalPlayer then
                UpdateMenu()
            end
        end
    end)

    --Prevent to get more than the max items
    t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerAddAction(t, function ()
        local m = GetOrderTargetItem()
        if AllowedItems[GetItemTypeId(m)] and GetIssuedOrderId() == Orders.smart then
            local u = GetOrderedUnit()
            local p = GetOwningPlayer(u)
            local items = PlayerItems[p]

            if #items < MAX_ITEMS then
                return
            end

            local id = GetItemTypeId(m)
            local itemData ---@type ItemData

            for _, v in ipairs(items) do
                if v.id == id and v.charges < MAX_STACK then
                    itemData = v
                    break
                end
            end

            if itemData then
                return
            end

            IssueTargetOrderById(u, Orders.attack, u)
            ErrorMessage("Backpack is full", p)
        end
    end)

    -- For GUI

    udg_BackpackRun = CreateTrigger()
    TriggerAddAction(udg_BackpackRun, function ()
        AllowedItems[udg_BackpackItem] = {
            ability = udg_BackpackAbility,
            level = udg_BackpackLevel,
        }

        udg_BackpackItem = 0
        udg_BackpackAbility = 0
        udg_BackpackLevel = 1
    end)

    ---@param p any
    ---@param flag boolean
    ---@param bypass? boolean
    function ShowBackpack(p, flag, bypass)
        if gotItem[p] or bypass then
            if p == LocalPlayer then
                BlzFrameSetVisible(Backpack, flag)
            end
            if bypass then
                gotItem[p] = true
            end
        end
    end

    ---@param p any
    ---@return ItemData[]
    function GetBackpackItems(p)
        return PlayerItems[p]
    end

    ---@param p any
    ---@param items integer[] | nil
    ---@param charges? integer[]
    function SetBackpackItems(p, items, charges)
        if not items then
            PlayerItems[p] = {}
            return
        end

        for i = #items, 1, -1 do
            if items[i] == 0 then
                DisplayTextToPlayer(p, 0, 0, "You loaded an invalid object in the backpack.")
                table.remove(items, i)
                if charges then
                    table.remove(charges, i)
                end
            end
        end
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
Debug.endFile()