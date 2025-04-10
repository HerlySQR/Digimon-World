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
    Require "EventListener"
    Require "Stats"
    Require "PressSaveOrLoad"
    Require "Serializable"
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

    local onBackpackPick = EventListener.create()

    local DUMMY_CASTER = FourCC('n01B')

    IgnoreCommandButton(DUMMY_CASTER)

    ---@class ItemData
    ---@field id integer
    ---@field spell integer
    ---@field level integer
    ---@field charges integer
    ---@field description string
    ---@field spellCooldown integer
    ---@field slot integer
    ---@field stopped boolean
    ---@field noConsummable boolean

    ---@class Backpack
    ---@field owner player
    ---@field caster unit
    ---@field usingCaster boolean
    ---@field selectedUnits group
    ---@field items ItemData[]
    ---@field actualItemData ItemData
    ---@field cooldowns table<integer, number>
    ---@field discardMode boolean
    ---@field dropMode boolean

    ---@class BackpackData: Serializable
    ---@field amount integer
    ---@field id integer[]
    ---@field charges integer[]
    ---@field slot integer[]
    ---@field sslot integer
    BackpackData = setmetatable({}, Serializable)
    BackpackData.__index = BackpackData

    ---@param backpack? Backpack
    ---@param sslot integer
    ---@return Serializable
    function BackpackData.create(backpack, sslot)
        local self = setmetatable({
            amount = 0,
            id = {},
            charges = {},
            slot = {},
        }, BackpackData)

        if type(backpack) == "number" then
            sslot = backpack
            backpack = nil
        end
        self.sslot = sslot

        if backpack then
            for i, data in ipairs(backpack.items) do
                self.amount = self.amount + 1
                self.id[i] = data.id
                self.charges[i] = data.charges
                self.slot[i] = data.slot
            end
        end

        return self
    end

    function BackpackData:serializeProperties()
        self:addProperty("amount", self.amount)
        for i = 1, self.amount do
            self:addProperty("id" .. i, self.id[i])
            self:addProperty("charges" .. i, self.charges[i])
            self:addProperty("slot" .. i, self.slot[i])
        end
        self:addProperty("sslot", self.sslot)
    end

    function BackpackData:deserializeProperties()
        if self.sslot ~= self:getIntProperty("sslot") then
            error("The slot is not the same.")
            return
        end
        self.amount = self:getIntProperty("amount")
        for i = 1, self.amount do
            self.id[i] = self:getIntProperty("id" .. i)
            self.charges[i] = self:getIntProperty("charges" .. i)
            self.slot[i] = self:getIntProperty("slot" .. i)
        end
    end

    local Backpacks = {} ---@type table<player, Backpack>

    OnInit.final(function ()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            local p = Player(i)
            Backpacks[p] = {
                owner = p,
                caster = CreateUnit(Digimon.PASSIVE, DUMMY_CASTER, WorldBounds.maxX, WorldBounds.maxY, 0),
                usingCaster = false,
                items = {},
                actualItemData = nil,
                selectedUnits = CreateGroup(),
                cooldowns = __jarray(0),
                discardMode = false,
                dropMode = false
            }
        end
    end)

    local MinRange = 850. ---The minimun range a player's digimon should be to the target to cast the spell
    local MAX_STACK = udg_MAX_STACK ---The maximun number of items that you can have in every slot
    local MAX_ITEMS = udg_MAX_ITEMS

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
            stopped = false,
            noConsummable = AllowedItems[itemId].noConsummable
        }
        itemData.spellCooldown = math.floor(BlzGetAbilityCooldown(itemData.spell, itemData.level - 1))
        local i = itemData.description:find("|n|cffffff00This item will go to the backpack.|r")
        if i then
            itemData.description = itemData.description:sub(1, i - 1)
        end

        return itemData
    end

    local function UpdateCooldowns()
        local backpack = Backpacks[LocalPlayer]

        for i, itemData in ipairs(backpack.items) do
            if backpack.cooldowns[itemData.id] > 0 then
                BlzFrameSetVisible(BackpackItemCooldownT[i], true)
                BlzFrameSetText(BackpackItemCooldownT[i], tostring(backpack.cooldowns[itemData.id]))
            else
                BlzFrameSetVisible(BackpackItemCooldownT[i], false)
            end
        end
    end

    ---Always use this function in a `if player == GetLocalPlayer() then` block
    local function UpdateMenu()
        local backpack = Backpacks[LocalPlayer]

        for i = 1, MAX_ITEMS do
            BlzFrameSetVisible(BackpackItemT[i], false)
        end

        for i, itemData in ipairs(backpack.items) do
            BlzFrameSetTexture(BackdropBackpackItemT[i], BlzGetAbilityIcon(itemData.id), 0, true)
            BlzFrameSetText(BackPackItemCharges[i], tostring(itemData.charges))

            BlzFrameSetText(BackpackItemTooltipText[i], itemData.description)
            BlzFrameSetSize(BackpackItemTooltipText[i], 0.15, 0)
            BlzFrameClearAllPoints(BackpackItemTooltip[i])
            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_TOPLEFT, BackpackItemTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(BackpackItemTooltip[i], FRAMEPOINT_BOTTOMRIGHT, BackpackItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)

            BlzFrameSetVisible(BackpackItemT[i], true)
        end

        UpdateCooldowns()
    end

    local function BackpackFunc(p)
        Backpacks[p].discardMode = false
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

    local function UseItem(p, i)
        local backpack = Backpacks[p]
        if backpack.discardMode then
            backpack.discardMode = false
            table.remove(backpack.items, i)
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
                UpdateMenu()
            end
        elseif backpack.dropMode then
            backpack.dropMode = false
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
            local data = table.remove(backpack.items, i) ---@type ItemData

            local m = CreateItem(data.id, d:getPos())
            SetItemPlayer(m, p, false)
            SetItemCharges(m, data.charges)

            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
                UpdateMenu()
            end
        else
            local itemData = backpack.items[i]

            if itemData.noConsummable then
                return
            end

            if backpack.cooldowns[itemData.id] > 0 then
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
            local caster = backpack.caster
            SetUnitOwner(caster, p, false)
            SyncSelections()
            GroupEnumUnitsSelected(backpack.selectedUnits, p)
            UnitAddAbility(caster, itemData.spell)
            backpack.actualItemData = itemData

            itemData.stopped = true -- This will set to false if is casts

            if p == LocalPlayer then
                SelectUnitSingle(caster)
            end
            backpack.usingCaster = true

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

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELECTED)
        TriggerAddCondition(t, Condition(function () return GetUnitTypeId(GetTriggerUnit()) == DUMMY_CASTER end))
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                ForceUIKey("Z")
            end
        end)
    end

    ---@param backpack Backpack
    local function BackpackDummyCastEnd(backpack)
        UnitRemoveAbility(backpack.caster, backpack.actualItemData.spell)
        SetUnitOwner(backpack.caster, Digimon.PASSIVE, false)
        if backpack.owner == LocalPlayer then
            for i = 1, MAX_ITEMS do
                BlzFrameSetEnable(BackpackItemT[i], true)
            end
            BlzFrameSetEnable(BackpackDiscard, true)
            BlzFrameSetEnable(BackpackDrop, true)
            ClearSelection()
        end
        ForGroup(backpack.selectedUnits, function ()
            if backpack.owner == LocalPlayer then
                SelectUnit(GetEnumUnit(), true)
            end
        end)
        GroupClear(backpack.selectedUnits)
        backpack.usingCaster = false

        if backpack.owner == LocalPlayer then
            BlzFrameSetText(BackpackText, "Use an item")
        end
    end

    local trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CAST)
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        if not caster then
            return
        end
        local p = GetOwningPlayer(caster)
        local itemData = Backpacks[p].actualItemData

        if itemData and itemData.spell == GetSpellAbilityId() then
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
        if not GetSpellAbilityUnit() then -- why????
            return
        end
        local itemData = Backpacks[GetOwningPlayer(GetSpellAbilityUnit())].actualItemData

        if itemData and itemData.spell == GetSpellAbilityId() then
            itemData.stopped = false
        end
    end)

    trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local p = GetOwningPlayer(caster)
        local backpack = Backpacks[p]
        local itemData = backpack.actualItemData

        if itemData and itemData.spell == GetSpellAbilityId() then
            local i = itemData.slot

            if not itemData.stopped then
                itemData.charges = itemData.charges - 1

                if itemData.charges <= 0 then
                    table.remove(backpack.items, i)
                    for newSlot, otherData in ipairs(backpack.items) do
                        otherData.slot = newSlot
                    end
                else
                    if itemData.spellCooldown > 0 then
                        backpack.cooldowns[itemData.id] = itemData.spellCooldown
                        if p == LocalPlayer then
                            UpdateCooldowns()
                        end
                        Timed.echo(1., function ()
                            backpack.cooldowns[itemData.id] = backpack.cooldowns[itemData.id] - 1
                            if p == LocalPlayer then
                                UpdateCooldowns()
                            end
                            if backpack.cooldowns[itemData.id] <= 0 then
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

            BackpackDummyCastEnd(backpack)
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
                local backpack = Backpacks[GetTriggerPlayer()]
                if backpack.usingCaster then
                    BackpackDummyCastEnd(backpack)
                end
            end
        end)

        trig = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerUnitEvent(trig, GetEnumPlayer(), EVENT_PLAYER_UNIT_DESELECTED)
        end)
        TriggerAddAction(trig, function ()
            local backpack = Backpacks[GetTriggerPlayer()]
            if GetTriggerUnit() == backpack.caster then
                BackpackDummyCastEnd(backpack)
            end
        end)
    end)

    local function BackpackDiscardFunc(p)
        local backpack = Backpacks[p]
        if not backpack.discardMode then
            backpack.discardMode = true
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "|cffffcc00Select to discard an item.|r Press again to cancel")
            end
        else
            backpack.discardMode = false
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
            end
        end
    end

    local function BackpackDropFunc(p)
        local backpack = Backpacks[p]
        if not backpack.dropMode then
            backpack.dropMode = true
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "|cffffcc00Select to drop an item.|r Press again to cancel")
            end
        else
            backpack.dropMode = false
            if p == LocalPlayer then
                BlzFrameSetText(BackpackText, "Use an item")
            end
        end
    end

    local function InitFrames()
        Backpack = BlzCreateFrame("IconButtonTemplate", OriginFrame, 0, 0)
        AddButtonToTheRight(Backpack, 8)
        BlzFrameSetVisible(Backpack, false)
        AddFrameToMenu(Backpack)
        AssignFrame(Backpack, 0) -- 0
        SetFrameHotkey(Backpack, "B")
        AddDefaultTooltip(Backpack, "Backpack", "Look your stored consummable items.")

        BackdropBackpack = BlzCreateFrameByType("BACKDROP", "BackdropBackpack", Backpack, "", 0)
        BlzFrameSetAllPoints(BackdropBackpack, Backpack)
        BlzFrameSetTexture(BackdropBackpack, "ReplaceableTextures\\CommandButtons\\BTNBag.blp", 0, true)
        OnClickEvent(Backpack, BackpackFunc)

        BackpackSprite =  BlzCreateFrameByType("SPRITE", "BackpackSprite", Backpack, "", 0)
        BlzFrameSetModel(BackpackSprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameClearAllPoints(BackpackSprite)
        BlzFrameSetPoint(BackpackSprite, FRAMEPOINT_BOTTOMLEFT, Backpack, FRAMEPOINT_BOTTOMLEFT, -0.00125, -0.00375)
        BlzFrameSetSize(BackpackSprite, 0.00001, 0.00001)
        BlzFrameSetScale(BackpackSprite, 1.25)
        BlzFrameSetVisible(BackpackSprite, false)

        BackpackMenu = BlzCreateFrame("EscMenuBackdrop", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.205, 0.21000)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.01000)
        BlzFrameSetVisible(BackpackMenu, false)
        AddFrameToMenu(BackpackMenu)

        BackpackText = BlzCreateFrameByType("TEXT", "name", BackpackMenu, "", 0)
        BlzFrameSetPoint(BackpackText, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(BackpackText, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.16000)
        BlzFrameSetText(BackpackText, "Use an item for the focused digimon")
        BlzFrameSetEnable(BackpackText, false)
        BlzFrameSetScale(BackpackText, 1.00)
        BlzFrameSetTextAlignment(BackpackText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        BackpackDiscard = BlzCreateFrame("ScriptDialogButton", BackpackMenu, 0, 0)
        BlzFrameSetScale(BackpackDiscard, 0.858)
        BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.095000, -0.16000)
        BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.015000)
        BlzFrameSetText(BackpackDiscard, "|cffFCD20DDiscard|r")
        OnClickEvent(BackpackDiscard, BackpackDiscardFunc)
        AssignFrame(BackpackDiscard, 1)

        BackpackDrop = BlzCreateFrame("ScriptDialogButton", BackpackMenu, 0, 0)
        BlzFrameSetScale(BackpackDrop, 0.858)
        BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.16000)
        BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.015000)
        BlzFrameSetText(BackpackDrop, "|cffFCD20DDrop|r")
        OnClickEvent(BackpackDrop, BackpackDropFunc)
        AssignFrame(BackpackDrop, 2)

        BackpackItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", BackpackMenu, "", 1)
        BlzFrameSetPoint(BackpackItems, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.030000)
        BlzFrameSetPoint(BackpackItems, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.045000)
        BlzFrameSetTexture(BackpackItems, "war3mapImported\\EmptyBTN.blp", 0, true)

        local x, y = {}, {}
        local stepSize = 0.025

        local startY = 0
        for row = 1, 5 do
            local startX = 0
            for colum = 1, 5 do
                local index = 5 * (row - 1) + colum

                x[index] = startX
                y[index] = startY

                startX = startX + stepSize
            end
            startY = startY - stepSize
        end

        local indexes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 34, 35, 36, 37, 38, 39, 40, 41}
        for i = 1, MAX_ITEMS do
            BackpackItemT[i] = BlzCreateFrame("IconButtonTemplate", BackpackItems, 0, 0)
            BlzFrameSetPoint(BackpackItemT[i], FRAMEPOINT_TOPLEFT, BackpackItems, FRAMEPOINT_TOPLEFT, x[i], y[i])
            BlzFrameSetSize(BackpackItemT[i], stepSize, stepSize)
            BlzFrameSetVisible(BackpackItemT[i], false)
            AssignFrame(BackpackItemT[i], indexes[i])

            BackdropBackpackItemT[i] = BlzCreateFrameByType("BACKDROP", "BackdropBackpackItemT[" .. i .. "]", BackpackItemT[i], "", 0)
            BlzFrameSetAllPoints(BackdropBackpackItemT[i], BackpackItemT[i])
            BlzFrameSetTexture(BackdropBackpackItemT[i], "", 0, true)
            OnClickEvent(BackpackItemT[i], function (p) UseItem(p, i) end)

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

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(BackpackMenu)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.205, 0.21000)
        BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.01000)
    end)

    OnLeaderboard(function ()
        BlzFrameSetParent(BackpackMenu, BlzGetFrameByName("Leaderboard", 0))
    end)

    local gotItem = __jarray(false) ---@type table<player, boolean>

    FrameLoaderAdd(InitFrames)

    -- Store the charged items
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddCondition(t, Condition(function () return IsUnitType(GetManipulatingUnit(), UNIT_TYPE_HERO) end))
    TriggerAddAction(t, function ()
        local m = GetManipulatedItem()
        if AllowedItems[GetItemTypeId(m)] then
            local u = GetManipulatingUnit()
            local p = GetOwningPlayer(u)

            if GetPlayerController(GetItemPlayer(m)) == MAP_CONTROL_USER and GetItemPlayer(m) ~= p then
                UnitRemoveItem(u, m)
                ErrorMessage("This item belongs to another player", p)
                return
            end

            local items = Backpacks[p].items

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

            if itemData.charges > MAX_STACK then
                local newItem = CreateItem(id, GetUnitX(u), GetUnitY(u))
                SetItemCharges(newItem, itemData.charges - MAX_STACK)
                SetItemPlayer(newItem, p, true)
                itemData.charges = MAX_STACK
                UnitAddItem(u, newItem)
            end

            Timed.call(function () RemoveItem(m) end)

            if p == LocalPlayer then
                UpdateMenu()
            end

            onBackpackPick:run(u, id)
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
            local backpack = Backpacks[p]

            if #backpack.items < MAX_ITEMS then
                return
            end

            local id = GetItemTypeId(m)
            local itemData ---@type ItemData

            for _, v in ipairs(backpack.items) do
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
            noConsummable = udg_BackpackNoConsummable
        }

        udg_BackpackItem = 0
        udg_BackpackAbility = 0
        udg_BackpackLevel = 1
        udg_BackpackNoConsummable = false
    end)

    ---@param p any
    ---@param flag boolean
    ---@param bypass? boolean
    function ShowBackpack(p, flag, bypass)
        if gotItem[p] or bypass then
            if p == LocalPlayer then
                BlzFrameSetVisible(Backpack, flag)
                if not flag and BlzFrameIsVisible(BackpackMenu) then
                    BlzFrameSetVisible(BackpackMenu, false)
                    RemoveButtonFromEscStack(Backpack)
                end
            end
            if bypass then
                gotItem[p] = true
            end
        end
    end

    ---@param p any
    ---@return ItemData[]
    function GetBackpackItems(p)
        return Backpacks[p].items
    end

    ---@param p any
    ---@param items integer[] | nil
    ---@param charges? integer[]
    function SetBackpackItems(p, items, charges)
        local backpack = Backpacks[p]
        if not items then
            backpack.items = {}
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
            backpack.items[i] = CreateItemData(items[i])
            if charges then
                backpack.items[i].charges = charges[i]
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    ---@param p player
    ---@param itm integer
    ---@return integer
    function GetBackpackItemCharges(p, itm)
        if not AllowedItems[itm] then
            return 0
        end

        local backpack = Backpacks[p]
        local charges = 0
        for _, itemData in ipairs(backpack.items) do
            if itemData.id == itm then
                charges = charges + itemData.charges
            end
        end
        return charges
    end

    ---@param p player
    ---@param itm integer
    ---@param charges integer
    function SetBackpackItemCharges(p, itm, charges)
        if not AllowedItems[itm] then
            return 0
        end

        charges = math.max(0, charges)

        local backpack = Backpacks[p]
        local items = backpack.items
        local itemDatas = {} ---@type ItemData[]
        local count = 0

        for _, itemData in ipairs(items) do
            if itemData.id == itm then
                table.insert(itemDatas, itemData)
                count = count + itemData.charges
            end
        end

        local diff = charges - count

        if diff == 0 then
            return
        elseif diff > 0 then
            for _, itemData in ipairs(itemDatas) do
                if itemData.charges < MAX_STACK then
                    local left = math.min(diff, MAX_STACK - itemData.charges)
                    diff = diff - left
                    itemData.charges = itemData.charges + left
                end
                if diff <= 0 then
                    break
                end
            end

            while diff > 0 do
                local itemData = CreateItemData(itm)
                table.insert(items, itemData)
                itemData.slot = #items
                itemData.charges = math.min(diff, MAX_STACK)
                diff = diff - MAX_STACK
            end

            if diff > 0 then
                local d = GetMainDigimon(p)
                local x, y
                if d then
                    x, y = d:getPos()
                else
                    x, y = GetRectCenterX(gg_rct_Player_1_Spawn), GetRectCenterY(gg_rct_Player_1_Spawn)
                end
                local newItem = CreateItem(itm, x, y)
                SetItemCharges(newItem, diff)
                SetItemPlayer(newItem, p, true)
            end
        elseif diff < 0 then
            diff = -diff

            for _, itemData in ipairs(itemDatas) do
                local left = math.min(itemData.charges, diff)
                diff = diff - left
                itemData.charges = itemData.charges - left
                if itemData.charges <= 0 then
                    table.remove(items, itemData.slot)
                    for newSlot, otherData in ipairs(backpack.items) do
                        otherData.slot = newSlot
                    end
                end
                if diff <= 0 then
                    break
                end
            end
        end

        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    ---@param func fun(mu: unit, mi: integer)
    function OnBackpackPick(func)
        onBackpackPick:register(func)
    end

    ---@param p player
    ---@param slot integer
    ---@return BackpackData
    function SaveBackpack(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_BACKPACK_ROOT)
        local data = BackpackData.create(Backpacks[p], slot)
        local code = EncodeString(p, data:serialize())

        if p == LocalPlayer then
            FileIO.Write(fileRoot, code)
        end

        return data
    end

    ---@param p player
    ---@param slot integer
    ---@return BackpackData?
    function LoadBackpack(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_BACKPACK_ROOT)
        local data = BackpackData.create(slot)
        local code = GetSyncedData(p, FileIO.Read, fileRoot)

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode or not pcall(data.deserialize, data, decode) then
                DisplayTextToPlayer(p, 0, 0, "The file " .. fileRoot .. " has invalid data.")
                return
            end
        end

        return data
    end

    ---@param p player
    ---@param data BackpackData
    function SetBackpack(p, data)
        local backpack = Backpacks[p]
        SetBackpackItems(p)

        for i = 1, data.amount do
            backpack.items[i] = CreateItemData(data.id[i])
            backpack.items[i].slot = data.slot[i]
            backpack.items[i].charges = data.charges[i]
        end

        if p == LocalPlayer then
            UpdateMenu()
        end
    end
--[[
    do
        local tr = CreateTrigger()
        TriggerRegisterPlayerChatEvent(tr, Player(0), "b ", false)
        TriggerAddAction(tr, function ()
            local amount = tonumber(GetEventPlayerChatString():sub(3))
            local p = GetTriggerPlayer()
            SetBackpackItemCharges(p, Backpacks[p].items[1].id, amount)
        end)
    end
    do
        local tr = CreateTrigger()
        TriggerRegisterPlayerChatEvent(tr, Player(0), "p", false)
        TriggerAddAction(tr, function ()
            local p = GetTriggerPlayer()
            print(GetBackpackItemCharges(p, Backpacks[p].items[1].id))
        end)
    end
]]
end)
Debug.endFile()