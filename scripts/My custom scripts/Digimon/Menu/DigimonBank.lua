Debug.beginFile("DigimonBank")
OnInit("DigimonBank", function ()
    Require "PlayerDigimons"
    Require "AFK"
    Require "Menu"
    Require "Hotkeys"

    local MAX_STOCK = udg_MAX_DIGIMONS
    local MAX_SAVED = udg_MAX_SAVED_DIGIMONS
    local MAX_USED = udg_MAX_USED_DIGIMONS
    local MIN_SAVED_ITEMS = udg_MIN_SAVED_ITEMS
    local MAX_SAVED_ITEMS = udg_MAX_SAVED_ITEMS
    local NEW_ITEM_SLOT_COST_BITS = 1500
    local NEW_ITEM_SLOT_COST_CRYSTALS = 2
    local NEW_DIGIMON_SLOT_COST_BITS = 3500
    local NEW_DIGIMON_SLOT_COST_CRYSTALS = 4

    -- Bank
    local SummonADigimon = nil ---@type framehandle
    local BackdropSummonADigimon = nil ---@type framehandle
    local StockedDigimonsMenu = nil ---@type framehandle
    local DigimonT = {} ---@type framehandle[]
    local BackdropDigimonT = {} ---@type framehandle[]
    local DigimonTUsed = {} ---@type framehandle[]
    local DigimonTSelected = {} ---@type framehandle[]
    local DigimonTIsMain = {} ---@type framehandle[]
    local DigimonTCooldownT = {} ---@type framehandle[]
    local DigimonTTooltip = {} ---@type framehandle[]
    local DigimonTTooltipText = {} ---@type framehandle[]
    local Text = nil ---@type framehandle
    local Summon = nil ---@type framehandle
    local Store = nil ---@type framehandle
    local Free = nil ---@type framehandle
    local Warning = nil ---@type framehandle
    local AreYouSure = nil ---@type framehandle
    local Yes = nil ---@type framehandle
    local No = nil ---@type framehandle
    -- Saved
    local SavedDigimons = nil ---@type framehandle
    local Using = nil ---@type framehandle
    local UsedT = {} ---@type framehandle[]
    local UsingDigimonT = {} ---@type framehandle[]
    local BackdropUsingDigimonT = {} ---@type framehandle[]
    local UsingTSelected = {} ---@type framehandle[]
    local UsingTCooldownT = {} ---@type framehandle[]
    local UsingTooltip = {} ---@type framehandle[]
    local UsingTooltipText = {} ---@type framehandle[]
    local Saved = nil ---@type framehandle
    local SavedDigimonT = {} ---@type framehandle[]
    local BackdropSavedDigimonT = {} ---@type framehandle[]
    local SavedTSelected = {} ---@type framehandle[]
    local SavedDigimonLocked = {} ---@type framehandle[]
    local SavedTCooldownT = {} ---@type framehandle[]
    local SavedTooltip = {} ---@type framehandle[]
    local SavedTooltipText = {} ---@type framehandle[]
    local Swap = nil ---@type framehandle
    local ExitSave = nil ---@type framehandle
    -- Item
    local ItemMenu = nil ---@type framehandle
    local ExitItem = nil ---@type framehandle
    local SaveItemDrop = nil ---@type framehandle
    local SaveItemDiscard = nil ---@type framehandle
    local SavedItemT = {} ---@type framehandle[]
    local BackdropSavedItemT = {} ---@type framehandle[]
    local SavedItemTSelected = {} ---@type framehandle[]
    local SaveItemLocked = {} ---@type framehandle[]
    local SaveItem = nil ---@type framehandle
    local BackdropSaveItem = nil ---@type framehandle
    local SaveItemTooltip = {} ---@type framehandle[]
    local SaveItemTooltipText = {} ---@type framehandle[]
    local SellItem = nil ---@type framehandle
    local BackdropSellItem = nil ---@type framehandle

    local BuySlotMenu = nil ---@type framehandle
    local BuySlotMessage = nil ---@type framehandle
    local BuySlotYes = nil ---@type framehandle
    local BuySlotNo = nil ---@type framehandle

    local SEE_SAVED_DIGIMONS = FourCC('I03U')
    local SEE_SAVED_ITEMS = FourCC('I03V')
    local SAVE_ITEM = FourCC('A0C6')
    local SELL_ITEM = FourCC('A0F4')
    local ITEM_BANK_CASTER = FourCC('n01P')
    local ITEM_BANK_SELLER = FourCC('n01Y')
    local ITEM_BANK_BUYER = FourCC('n026')

    local MinRange = 300.

    ---@class Bank
    ---@field stocked Digimon[]
    ---@field inUse Digimon[]
    ---@field saved Digimon[]
    ---@field pressed integer
    ---@field usingClicked integer
    ---@field savedClicked integer
    ---@field savedDigimonsStock integer
    ---@field wantDigimonSlot boolean
    ---@field p player
    ---@field main Digimon
    ---@field spawnPoint {x: number, y: number}
    ---@field allDead boolean
    ---@field savedItems item[]
    ---@field savedItemsStock integer
    ---@field wantItemSlot boolean
    ---@field itemClicked integer
    ---@field customer Digimon
    ---@field caster unit
    ---@field usingCaster boolean
    ---@field selectedUnits group
    ---@field buyer unit
    ---@field seller unit
    local Bank = {}
    local LocalPlayer = GetLocalPlayer() ---@type player

    local cooldowns = __jarray(0) ---@type table<Digimon, number>
    local revivingSuspended = __jarray(false) ---@type table<player, boolean>

    Bank.__index = Bank

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        Bank[i] = setmetatable({
            stocked = {},
            inUse = {},
            saved = {},
            pressed = -1,
            usingClicked = -1,
            savedClicked = -1,
            savedDigimonsStock = 0,
            wantDigimonSlot = false,
            p = Player(i),
            main = nil,
            spawnPoint = {
                x = GetRectCenterX(gg_rct_Player_1_Spawn),
                y = GetRectCenterY(gg_rct_Player_1_Spawn)
            },
            allDead = false,
            savedItemsStock = MIN_SAVED_ITEMS,
            wantItemSlot = false,
            savedItems = {},
            itemClicked = -1,
            customer = nil,
            caster = nil,
            buyer = nil,
            seller = nil
        }, Bank)
    end

    -- Conditions

    ---@return integer
    function Bank:used()
        local max = 0
        for i = 0, MAX_STOCK - 1 do
            if self.inUse[i] then
                max = max + 1
            end
        end
        return max
    end

    ---@return boolean
    function Bank:useDigimonConditions()
        if self.pressed == -1 then
            return false
        end
        return GetDigimonCooldown(self.stocked[self.pressed]) <= 0 and self:used() < MAX_USED
    end

    ---@return Digimon[]
    function Bank:getUsedDigimons()
        local list = {}
        for i = 0, MAX_STOCK - 1 do
            if self.inUse[i] then
                table.insert(list, self.inUse[i])
            end
        end
        return list
    end

    ---@return boolean
    function Bank:storeDigimonConditions()
        if self.pressed == -1 then
            return false
        end

        if self.stocked[self.pressed].onCombat then
            return false
        end

        if IsUnitPaused(self.stocked[self.pressed].root) then
            return false
        end

        local max = self:used()
        if max <= 1 then
            return false
        end

        -- All should be together (already check there should be at least 2 used digimons)
        local centerX, centerY = 0, 0
        local list = self:getUsedDigimons()

        for _, d in ipairs(list) do
            centerX = centerX + d:getX()
            centerY = centerY + d:getY()
        end

        centerX = centerX / max
        centerY = centerY / max

        for _, d in ipairs(list) do
            if math.sqrt((d:getX() - centerX)^2 + (d:getY() -centerY)^2) > 400. then
                return false
            end
        end

        return true
    end

    ---@return boolean
    function Bank:freeDigimonConditions()
        return GetDigimonCount(self.p) > 1
    end

    ---@return boolean
    function Bank:swapConditions()
        return self.usingClicked ~= -1 and self.savedClicked ~= -1 and not self.inUse[self.usingClicked]
    end

    ---@return boolean
    function Bank:searchMain()
        for i = 0, MAX_STOCK - 1 do
            if self.inUse[i] then
                self.main = self.inUse[i]
                return true
            end
        end
        self.main = nil
        self.spawnPoint.x = GetRectCenterX(gg_rct_Player_1_Spawn)
        self.spawnPoint.y = GetRectCenterY(gg_rct_Player_1_Spawn)

        for i = 0, MAX_STOCK - 1 do
            if self.stocked[i] then
                self.stocked[i].environment = Environment.initial
            end
        end
        return false
    end

    ---Returns true if the player is using this Digimon
    ---@param index integer
    ---@param hide boolean
    ---@return boolean
    function Bank:storeDigimon(index, hide)
        local d = self.inUse[index] ---@type Digimon
        if d then
            self.inUse[index] = nil
            if self.main == d then
                self:searchMain()
            end
            if hide then
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
            end
            return true
        end
        return false
    end

    ---Returns true if the slot has a digimon avaible to summon
    ---@param index integer
    ---@return boolean
    function Bank:avaible(index)
        return index ~= -1 and self.stocked[index] ~= nil and self.inUse[index] == nil
    end

    ---Returns true if the digimon in the slot is alive
    ---@param index integer
    ---@return boolean
    function Bank:isAlive(index)
        local d = self.stocked[index]
        if d then
            return cooldowns[d] <= 0
        end
        return false
    end

    ---Save a digimon in the bank
    ---@param d Digimon
    ---@return integer
    function Bank:saveDigimon(d)
        for i = 0, self.savedDigimonsStock - 1 do
            if not self.saved[i] then
                self.saved[i] = d
                d.saved = true
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
                return i
            end
        end
        return -1
    end

    ---Replace a digimon slot that can be used to a saved slot
    function Bank:sawpSave()
        local index1 = self.usingClicked
        local index2 = self.savedClicked

        if index1 ~= -1 and index2 ~= -1 and not self.inUse[index1] then
            local old1 = self.stocked[index1]
            local old2 = self.saved[index2]

            if old1 then
                ReleaseDigimon(self.p, old1)
                old1.saved = true
            end
            if old2 then
                StoreDigimon(self.p, old2)
                old2.saved = false
            end

            self.stocked[index1] = old2
            self.saved[index2] = old1
        end
    end

    ---@param m item
    ---@return boolean
    function Bank:saveItem(m)
        if #self.savedItems < self.savedItemsStock then
            table.insert(self.savedItems, m)
            SetItemVisible(m, false)
            SetItemPosition(m, WorldBounds.maxX, WorldBounds.maxY)
            return true
        else
            ErrorMessage("Item bank is full.", self.p)
            return false
        end
    end

    function Bank:dropItem()
        if not self.customer then
            ErrorMessage("There are no customer.", self.p)
            return
        end
        local m = table.remove(self.savedItems, self.itemClicked)
        SetItemVisible(m, true)
        SetItemPosition(m, self.customer:getPos())
    end

    function Bank:discardItem()
        local m = table.remove(self.savedItems, self.itemClicked)
        if m then
            RemoveItem(m)
        end
    end

    function Bank:clearItems()
        for i = #self.savedItems, 1, -1 do
            RemoveItem(self.savedItems[i])
            self.savedItems[i] = nil
        end
    end

    function Bank:resetCaster()
        SetUnitOwner(self.caster, Digimon.PASSIVE, false)
        if self.p == LocalPlayer then
            ClearSelection()
        end
        ForGroup(self.selectedUnits, function ()
            if self.p == LocalPlayer then
                SelectUnit(GetEnumUnit(), true)
            end
        end)
        GroupClear(self.selectedUnits)
        self.usingCaster = false

        if self.p == LocalPlayer then
            BlzFrameSetEnable(SaveItem, true)
            BlzFrameSetEnable(SellItem, true)
        end
    end

    -- Store all the digimon in case of AFK
    AFKEvent:register(function (p)
        local bank = Bank[GetPlayerId(p)]
        for i = 0, MAX_STOCK - 1 do
            bank:storeDigimon(i, true)
        end
        DisplayTextToPlayer(LocalPlayer, 0, 0, GetPlayerName(p) .. " was afk for too long, all its digimons were stored.")
    end)

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            local p = GetEnumPlayer()
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            bank.caster = CreateUnit(Digimon.PASSIVE, ITEM_BANK_CASTER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.seller = CreateUnit(Digimon.PASSIVE, ITEM_BANK_SELLER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.buyer = CreateUnit(Digimon.PASSIVE, ITEM_BANK_BUYER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.selectedUnits = CreateGroup()
        end)
    end)

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateItems()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        for i = 1, MAX_SAVED_ITEMS do
            if i <= bank.savedItemsStock then
                local m = bank.savedItems[i]
                if m then
                    BlzFrameSetTexture(BackdropSavedItemT[i], BlzGetAbilityIcon(GetItemTypeId(m)), 0, true)
                    BlzFrameSetEnable(SavedItemT[i], not BlzFrameIsVisible(SavedItemTSelected[i]))

                    local charges = GetItemCharges(m)
                    BlzFrameSetText(SaveItemTooltipText[i], GetItemName(m) .. ((charges > 1) and ("(" .. charges .. ")") or "") .. "\n" .. BlzGetItemDescription(m))
                    BlzFrameSetSize(SaveItemTooltipText[i], 0.15, 0)
                else
                    BlzFrameSetTexture(BackdropSavedItemT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetEnable(SavedItemT[i], false)

                    BlzFrameSetText(SaveItemTooltipText[i], "Empty")
                    BlzFrameSetSize(SaveItemTooltipText[i], 0, 0.01)
                end
                BlzFrameSetVisible(SaveItemLocked[i], false)
            else
                BlzFrameSetTexture(BackdropSavedItemT[i], "ReplaceableTextures\\CommandButtons\\BTNLock.blp", 0, true)
                if i == bank.savedItemsStock + 1 then
                    BlzFrameSetEnable(SavedItemT[i], true)
                    BlzFrameSetVisible(SaveItemLocked[i], false)

                    BlzFrameSetText(SaveItemTooltipText[i], "Click to buy slot")
                    BlzFrameSetSize(SaveItemTooltipText[i], 0, 0.01)
                else
                    BlzFrameSetEnable(SavedItemT[i], false)
                    BlzFrameSetVisible(SaveItemLocked[i], true)
                    BlzFrameSetAlpha(SaveItemLocked[i], 127)

                    BlzFrameSetText(SaveItemTooltipText[i], "Locked")
                    BlzFrameSetSize(SaveItemTooltipText[i], 0, 0.01)
                end
            end

            BlzFrameClearAllPoints(SaveItemTooltip[i])
            BlzFrameSetPoint(SaveItemTooltip[i], FRAMEPOINT_TOPLEFT, SaveItemTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(SaveItemTooltip[i], FRAMEPOINT_BOTTOMRIGHT, SaveItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
        BlzFrameSetEnable(SaveItemDiscard, bank.itemClicked ~= -1)
        BlzFrameSetEnable(SaveItemDrop, bank.itemClicked ~= -1)
    end

    local trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddCondition(trig, Condition(function () return GetSpellAbilityId() == SAVE_ITEM or GetSpellAbilityId() == SELL_ITEM end))
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local p = GetOwningPlayer(caster)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local target = GetSpellTargetItem()
        local x, y = GetItemX(target), GetItemY(target)

        if not GetRandomUnitOnRange(x, y, MinRange, function (u2) return GetOwningPlayer(u2) == p and Digimon.getInstance(u2) ~= nil end) then
            ErrorMessage("A digimon should be nearby the item", p)
        elseif GetPlayerController(GetItemPlayer(target)) == MAP_CONTROL_USER and GetItemPlayer(target) ~= p then
            ErrorMessage("This item belongs to another player", p)
        else
            if GetSpellAbilityId() == SAVE_ITEM then
                SetItemPlayer(target, p, false)
                bank:saveItem(target)
                if p == LocalPlayer then
                    UpdateItems()
                end
            else
                SetUnitOwner(bank.seller, p)
                if GetItemType(target) == ITEM_TYPE_POWERUP then
                    BlzSetItemBooleanField(target, ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED, false)
                end
                UnitAddItem(bank.seller, target)
                SetUnitPosition(bank.seller, x, y)
                SetUnitPosition(bank.buyer,  x, y)
                UnitDropItemTarget(bank.seller, target, bank.buyer)
            end
        end

        bank:resetCaster()
    end)

    --[[do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELL_ITEM)
        TriggerAddCondition(t, Condition(function () return GetUnitTypeId(GetTriggerUnit()) == ITEM_BANK_SELLER end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetTriggerUnit())
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            SetUnitOwner(bank.seller, Digimon.PASSIVE)
            SetUnitX(bank.seller, WorldBounds.maxX)
            SetUnitY(bank.seller, WorldBounds.maxY)
            print("si")
        end)
    end]]

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateCooldowns()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            local d = bank.stocked[i] ---@type Digimon
            if d and cooldowns[d] > 0 then
                BlzFrameSetText(DigimonTCooldownT[i], tostring(math.floor(cooldowns[d])))
                BlzFrameSetText(UsingTCooldownT[i], tostring(math.floor(cooldowns[d])))
            else
                BlzFrameSetVisible(DigimonTCooldownT[i], false)
                BlzFrameSetVisible(UsingTCooldownT[i], false)
            end
        end
        for i = 0, MAX_SAVED - 1 do
            local d = bank.saved[i] ---@type Digimon
            if d and cooldowns[d] >= 0 then
                BlzFrameSetText(SavedTCooldownT[i], tostring(math.floor(cooldowns[d])))
            else
                BlzFrameSetVisible(SavedTCooldownT[i], false)
            end
        end
    end

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateSave()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            local d = bank.stocked[i]
            if d then
                local id = d:getTypeId()
                -- Button
                if not bank.inUse[i] then
                    BlzFrameSetVisible(UsedT[i], false)
                    BlzFrameSetEnable(UsingDigimonT[i], not BlzFrameIsVisible(UsingTSelected[i]))
                else
                    BlzFrameSetVisible(UsedT[i], true)
                    BlzFrameSetAlpha(UsedT[i], 127)
                    BlzFrameSetEnable(UsingDigimonT[i], false)
                end
                BlzFrameSetTexture(BackdropUsingDigimonT[i], BlzGetAbilityIcon(id), 0, true)

                -- Tooltip
                local text = GetHeroProperName(d.root) .. " |cffccff00Level " .. GetHeroLevel(d.root)
                          .. "|r\n\n|cffff4200Items: |r"

                for j = 0, 5 do
                    local m = UnitItemInSlot(d.root, j)
                    if m then
                        text = text .. GetItemName(m) .. ", "
                    end
                end

                text = text:sub(1, text:len() - 2) .. "\n\n"

                if bank.inUse[i] then
                    text = text .. "|cff0000ffIn use|r"
                else
                    text = text .. "|cff00ff00Stored|r"
                end
                BlzFrameSetText(UsingTooltipText[i], text)
                BlzFrameSetSize(UsingTooltipText[i], 0.2, 0)
            else
                -- Button
                BlzFrameSetEnable(UsingDigimonT[i], not BlzFrameIsVisible(UsingTSelected[i]))
                BlzFrameSetTexture(BackdropUsingDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

                -- Tooltip
                BlzFrameSetText(UsingTooltipText[i], "Empty slot")
                BlzFrameSetSize(UsingTooltipText[i], 0, 0.01)
            end
            -- Re-size
            BlzFrameClearAllPoints(UsingTooltip[i])
            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_TOPLEFT, UsingTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_BOTTOMRIGHT, UsingTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
        for i = 0, MAX_SAVED - 1 do
            if i < bank.savedDigimonsStock then
                local d = bank.saved[i] ---@type Digimon
                if d then
                    local id = d:getTypeId()
                    -- Button
                    BlzFrameSetTexture(BackdropSavedDigimonT[i], BlzGetAbilityIcon(id), 0, true)

                    -- Tooltip
                    local text = GetHeroProperName(d.root) .. " |cffccff00Level " .. GetHeroLevel(d.root)
                              .. "|r\n\n|cffff4200Items: |r"

                    for j = 0, 5 do
                        local m = UnitItemInSlot(d.root, j)
                        if m then
                            text = text .. GetItemName(m) .. ", "
                        end
                    end

                    text = text:sub(1, text:len() - 2)

                    BlzFrameSetText(SavedTooltipText[i], text)
                    BlzFrameSetSize(SavedTooltipText[i], 0.2, 0)
                else
                    -- Button
                    BlzFrameSetEnable(SavedDigimonT[i], false)
                    BlzFrameSetTexture(BackdropSavedDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

                    BlzFrameSetText(SavedTooltipText[i], "Empty slot")
                    BlzFrameSetSize(SavedTooltipText[i], 0, 0.01)
                end
                BlzFrameSetEnable(SavedDigimonT[i], not BlzFrameIsVisible(SavedTSelected[i]))
            else
                BlzFrameSetTexture(BackdropSavedDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNLock.blp", 0, true)
                if i == bank.savedDigimonsStock then
                    BlzFrameSetEnable(SavedDigimonT[i], true)
                    BlzFrameSetVisible(SavedDigimonLocked[i], false)

                    BlzFrameSetText(SavedTooltipText[i], "Click to buy slot")
                else
                    BlzFrameSetEnable(SavedDigimonT[i], false)
                    BlzFrameSetVisible(SavedDigimonLocked[i], true)
                    BlzFrameSetAlpha(SavedDigimonLocked[i], 127)

                    BlzFrameSetText(SavedTooltipText[i], "Locked")
                end
                BlzFrameSetSize(SavedTooltipText[i], 0, 0.01)
            end
            -- Re-size
            BlzFrameClearAllPoints(SavedTooltip[i])
            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_TOPLEFT, SavedTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_BOTTOMRIGHT, SavedTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
        UpdateCooldowns()
    end

    local function ExitSaveFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        bank.wantDigimonSlot = false
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SavedDigimons, false)
            BlzFrameSetVisible(UsingTSelected[bank.usingClicked], false)
            BlzFrameSetVisible(SavedTSelected[bank.savedClicked], false)
            BlzFrameSetVisible(BuySlotMenu, false)
            BlzFrameSetEnable(Swap, false)
            RemoveButtonFromEscStack(ExitSave)
        end
        bank.usingClicked = -1
        bank.savedClicked = -1
    end

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateMenu()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            local d = bank.stocked[i] ---@type Digimon
            if d then
                local id = d:getTypeId()
                -- Button
                BlzFrameSetEnable(DigimonT[i], true)
                BlzFrameSetTexture(BackdropDigimonT[i], BlzGetAbilityIcon(id), 0, true)
                -- Tooltip
                local text = GetHeroProperName(d.root) .. " |cffccff00Level " .. GetHeroLevel(d.root)
                          .. "|r\n\n|cffff4200Items: |r"

                for j = 0, 5 do
                    local m = UnitItemInSlot(d.root, j)
                    if m then
                        text = text .. GetItemName(m) .. ", "
                    end
                end

                text = text:sub(1, text:len() - 2) .. "\n\n"

                if bank.inUse[i] then
                    text = text .. "|cff0000ffIn use|r"
                    BlzFrameSetVisible(DigimonTUsed[i], true)
                    BlzFrameSetAlpha(DigimonTUsed[i], 127)
                else
                    text = text .. "|cff00ff00Stored|r"
                    BlzFrameSetVisible(DigimonTUsed[i], false)
                end
                BlzFrameSetText(DigimonTTooltipText[i], text)
                BlzFrameSetSize(DigimonTTooltipText[i], 0.2, 0)

                BlzFrameSetVisible(DigimonTIsMain[i], bank.main == d)
            else
                -- Button
                BlzFrameSetEnable(DigimonT[i], false)
                BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                -- Tooltip
                BlzFrameSetText(DigimonTTooltipText[i], "Empty slot")
                BlzFrameSetSize(DigimonTTooltipText[i], 0, 0.01)
                -- Hide
                BlzFrameSetVisible(DigimonTUsed[i], false)
                BlzFrameSetVisible(DigimonTSelected[i], false)
                BlzFrameSetVisible(DigimonTIsMain[i], false)
            end
            -- Re-size
            BlzFrameClearAllPoints(DigimonTTooltip[i])
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonTTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
        UpdateCooldowns()
    end

    -- When the digimon evolves
    Digimon.evolutionEvent:register(function (evolve)
        if evolve:getOwner() == LocalPlayer then
            UpdateMenu()
            UpdateSave()
        end
    end)

    ---@param key string
    local function UseCaster(key)
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        SetUnitOwner(bank.caster, p, false)
        SyncSelections()
        GroupEnumUnitsSelected(bank.selectedUnits, p)

        if p == LocalPlayer then
            BlzFrameSetEnable(SaveItem, false)
            BlzFrameSetEnable(SellItem, false)
            SelectUnitSingle(bank.caster)
        end
        Timed.echo(0.01, 1., function ()
            SyncSelections()
            if IsUnitSelected(bank.caster, p) then
                if p == LocalPlayer then
                    ForceUIKey(key)
                end
                return true
            end
        end)
        bank.usingCaster = true
    end

    OnInit.final(function ()
        trig = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerEvent(trig, GetEnumPlayer(), EVENT_PLAYER_MOUSE_DOWN)
            TriggerRegisterPlayerEvent(trig, GetEnumPlayer(), EVENT_PLAYER_END_CINEMATIC)
        end)
        TriggerAddAction(trig, function ()
            if GetTriggerEventId() ~= EVENT_PLAYER_MOUSE_DOWN or BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
                local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
                if bank.usingCaster then
                    bank:resetCaster()
                end
            end
        end)

        trig = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerUnitEvent(trig, GetEnumPlayer(), EVENT_PLAYER_UNIT_DESELECTED)
        end)
        TriggerAddAction(trig, function ()
            local p = GetTriggerPlayer()
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            if GetTriggerUnit() == bank.caster then
                bank:resetCaster()
            end
        end)
    end)

    local function SaveItemDropFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        bank:dropItem()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            UpdateItems()
            -- Disable
            BlzFrameSetEnable(SaveItemDiscard, false)
            BlzFrameSetEnable(SaveItemDrop, false)
        end
        bank.itemClicked = -1
    end

    local function SaveItemDiscardFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        bank:discardItem()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            UpdateItems()
            -- Disable
            BlzFrameSetEnable(SaveItemDiscard, false)
            BlzFrameSetEnable(SaveItemDrop, false)
        end
        bank.itemClicked = -1
    end

    local function SavedItemTFunc(i)
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        if i <= bank.savedItemsStock then
            if GetTriggerPlayer() == LocalPlayer then
                -- Refresh the last pressed button
                BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
                BlzFrameSetEnable(SavedItemT[bank.itemClicked], true)
                -- Updates the new pressed button
                BlzFrameSetVisible(SavedItemTSelected[i], true)
                BlzFrameSetEnable(SavedItemT[i], false)
                -- Enable
                BlzFrameSetEnable(SaveItemDiscard, true)
                BlzFrameSetEnable(SaveItemDrop, true)
            end
            bank.itemClicked = i
        else
            bank.wantItemSlot = true
            if GetTriggerPlayer() == LocalPlayer then
                local requiredGold = (bank.savedItemsStock - MIN_SAVED_ITEMS + 1) * NEW_ITEM_SLOT_COST_BITS
                local requiredLumber = (bank.savedItemsStock - MIN_SAVED_ITEMS + 1) * NEW_ITEM_SLOT_COST_CRYSTALS
                BlzFrameSetText(BuySlotMessage, "Do you want to buy a new item slot for |cff828282" .. requiredGold .. " digibits|r and |cffc882c8" ..requiredLumber .. " digiCrystals|r?")
                for j = 1, bank.savedItemsStock + 1 do
                    if SavedItemT[j] then
                        BlzFrameSetEnable(SavedItemT[j], false)
                    end
                end
                BlzFrameSetEnable(SaveItemDiscard, false)
                BlzFrameSetEnable(SaveItemDrop, false)
                BlzFrameSetVisible(BuySlotMenu, true)
            end
        end
    end

    local function ExitItemFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        bank.wantItemSlot = false
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(BuySlotMenu, false)
            BlzFrameSetVisible(ItemMenu, false)
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            RemoveButtonFromEscStack(ExitItem)
            UpdateItems()
        end
        bank.itemClicked = -1
    end

    local function BuySlotYesFunc()
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)] ---@type Bank

        if p == LocalPlayer then
            BlzFrameSetVisible(BuySlotMenu, false)
        end

        local playerGold = GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
        local playerLumber = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
        if bank.wantItemSlot then
            local requiredGold = (bank.savedItemsStock - MIN_SAVED_ITEMS + 1) * NEW_ITEM_SLOT_COST_BITS
            local requiredLumber = (bank.savedItemsStock - MIN_SAVED_ITEMS + 1) * NEW_ITEM_SLOT_COST_CRYSTALS
            if playerGold >= requiredGold and playerLumber >= requiredLumber then
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, playerGold - requiredGold)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, playerLumber - requiredLumber)
                bank.savedItemsStock = bank.savedItemsStock + 1
            else
                if playerGold < requiredGold then
                    ErrorMessage("You don't have enough digibits", p)
                else
                    ErrorMessage("You don't have enough digicrystals", p)
                end
            end
        elseif bank.wantDigimonSlot then
            local requiredGold = (bank.savedDigimonsStock + 1) * NEW_DIGIMON_SLOT_COST_BITS
            local requiredLumber = (bank.savedDigimonsStock + 1) * NEW_DIGIMON_SLOT_COST_CRYSTALS
            if playerGold >= requiredGold and playerLumber >= requiredLumber then
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, playerGold - requiredGold)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, playerLumber - requiredLumber)
                bank.savedDigimonsStock = bank.savedDigimonsStock + 1
            else
                if playerGold < requiredGold then
                    ErrorMessage("You don't have enough digibits", p)
                else
                    ErrorMessage("You don't have enough digicrystals", p)
                end
            end
        end

        if p == LocalPlayer then
            if BlzFrameIsVisible(SavedDigimons) then
                UpdateSave()
                BlzFrameSetEnable(Swap, bank:swapConditions())
            end
            if BlzFrameIsVisible(ItemMenu) then
                UpdateItems()
            end
        end
    end

    local function BuySlotNoFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(BuySlotMenu, false)
            if BlzFrameIsVisible(SavedDigimons) then
                UpdateSave()
            end
            if BlzFrameIsVisible(ItemMenu) then
                UpdateItems()
            end
        end
    end

    local function SwapFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        bank:sawpSave()
        if GetTriggerPlayer() == LocalPlayer then
            UpdateMenu()
            UpdateSave()
        end
    end

    local function PressedUsing(i)
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        if p == LocalPlayer then
            -- Refresh the last pressed button
            BlzFrameSetVisible(UsingTSelected[bank.usingClicked], false)
            BlzFrameSetEnable(UsingDigimonT[bank.usingClicked], true)
            -- Updates the new pressed button
            BlzFrameSetVisible(UsingTSelected[i], true)
            BlzFrameSetEnable(UsingDigimonT[i], false)
        end
        bank.usingClicked = i
        if p == LocalPlayer then
            BlzFrameSetEnable(Swap, bank:swapConditions())
        end
    end

    local function PressedSaved(i)
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        if i < bank.savedDigimonsStock then
            if p == LocalPlayer then
                -- Refresh the last pressed button
                BlzFrameSetVisible(SavedTSelected[bank.savedClicked], false)
                BlzFrameSetEnable(SavedDigimonT[bank.savedClicked], true)
                -- Updates the new pressed button
                BlzFrameSetVisible(SavedTSelected[i], true)
                BlzFrameSetEnable(SavedDigimonT[i], false)
            end
            bank.savedClicked = i
            if p == LocalPlayer then
                BlzFrameSetEnable(Swap, bank:swapConditions())
            end
        else
            bank.wantDigimonSlot = true
            if GetTriggerPlayer() == LocalPlayer then
                local requiredGold = (bank.savedDigimonsStock + 1) * NEW_DIGIMON_SLOT_COST_BITS
                local requiredLumber = (bank.savedDigimonsStock + 1) * NEW_DIGIMON_SLOT_COST_CRYSTALS
                BlzFrameSetText(BuySlotMessage, "Do you want to buy a new digimon slot for |cff828282" .. requiredGold .. " digibits|r and |cffc882c8" ..requiredLumber .. " digiCrystals|r?")
                for j = 0, bank.savedDigimonsStock do
                    if SavedDigimonT[j] then
                        BlzFrameSetEnable(SavedDigimonT[j], false)
                    end
                end
                for j = 0, MAX_STOCK - 1 do
                    BlzFrameSetEnable(UsingDigimonT[j], false)
                end
                BlzFrameSetEnable(Swap, false)
                BlzFrameSetVisible(BuySlotMenu, true)
            end
        end
    end

    local function PressedActions(i)
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        if GetTriggerPlayer() == LocalPlayer then
            -- Refresh the last pressed button
            BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            BlzFrameSetEnable(DigimonT[bank.pressed], true)
            -- Updates the new pressed button
            BlzFrameSetVisible(DigimonTSelected[i], true)
            BlzFrameSetEnable(DigimonT[i], false)
            -- Other changes
            if bank.inUse[i] then
                BlzFrameSetVisible(Summon, false)
                BlzFrameSetVisible(Store, true)
            else
                BlzFrameSetVisible(Summon, true)
                BlzFrameSetVisible(Store, false)
            end
        end
        bank.pressed = i
    end

    local function SummonADigimonFunc()
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)]
        if p == LocalPlayer then
            if not BlzFrameIsVisible(StockedDigimonsMenu) then
                BlzFrameSetVisible(StockedDigimonsMenu, true)
                UpdateMenu()
                AddButtonToEscStack(SummonADigimon)
            else
                BlzFrameSetVisible(StockedDigimonsMenu, false)
                BlzFrameSetVisible(DigimonTUsed[bank.pressed], false)
                BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
                RemoveButtonFromEscStack(SummonADigimon)
            end
        end
        bank.pressed = -1
    end

    local function SummonFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            BlzFrameSetVisible(Summon, false)
            BlzFrameSetVisible(Store, true)
        end
        SummonDigimon(p, Bank[GetPlayerId(p)].pressed)
    end

    local function StoreFunc()
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)]
        bank:storeDigimon(bank.pressed, true)
        if p == LocalPlayer then
            BlzFrameSetVisible(Summon, true)
            BlzFrameSetVisible(Store, false)
            UpdateMenu()
        end
    end

    local function FreeFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetFocus(StockedDigimonsMenu, false)
            BlzFrameSetFocus(Warning, true)
            BlzFrameSetVisible(Warning, true)
            BlzFrameCageMouse(Warning, true)
        end
    end

    local function YesFunc()
        local p = GetTriggerPlayer()
        local bank = Bank[GetPlayerId(p)]
        if p == LocalPlayer then
            BlzFrameSetEnable(Free, false)
            BlzFrameSetEnable(Summon, false)
            UpdateMenu()
            BlzFrameCageMouse(Warning, false)
            BlzFrameSetVisible(Warning, false)
            BlzFrameSetFocus(StockedDigimonsMenu, true)
            BlzFrameSetVisible(DigimonTUsed[bank.pressed], false)
            BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
        end
        RemoveFromBank(p, bank.pressed)
        bank.pressed = -1
    end

    local function NoFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameCageMouse(Warning, false)
            BlzFrameSetVisible(Warning, false)
            BlzFrameSetFocus(StockedDigimonsMenu, true)
        end
    end

    do
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerUnitEvent(t, GetEnumPlayer(), EVENT_PLAYER_UNIT_DESELECTED)
        end)
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                if BlzFrameIsVisible(SavedDigimons) then
                    BlzFrameClick(ExitSave)
                end
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == SEE_SAVED_ITEMS end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            Bank[GetPlayerId(p)].customer = Digimon.getInstance(GetManipulatingUnit())
            if p == LocalPlayer then
                if not BlzFrameIsVisible(ItemMenu) then
                    BlzFrameSetVisible(ItemMenu, true)
                    UpdateItems()
                    AddButtonToEscStack(ExitItem)
                end
            end
            ExitSaveFunc()
        end)
    end

    do
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerUnitEvent(t, GetEnumPlayer(), EVENT_PLAYER_UNIT_ISSUED_ORDER)
            TriggerRegisterPlayerUnitEvent(t, GetEnumPlayer(), EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
            TriggerRegisterPlayerUnitEvent(t, GetEnumPlayer(), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
            TriggerRegisterPlayerUnitEvent(t, GetEnumPlayer(), EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
        end)
        TriggerAddAction(t, function ()
            local u = GetOrderedUnit()
            if GetOwningPlayer(u) == LocalPlayer and BlzFrameIsVisible(ItemMenu) then
                local customer = Bank[GetPlayerId(LocalPlayer)].customer
                if customer and u == customer.root then
                    BlzFrameClick(ExitItem)
                end
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == SEE_SAVED_DIGIMONS end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            if p == LocalPlayer then
                if not BlzFrameIsVisible(SavedDigimons) then
                    BlzFrameSetVisible(SavedDigimons, true)
                    UpdateSave()
                    AddButtonToEscStack(ExitSave)
                end
            end
            ExitItemFunc()
        end)
    end

    local function InitFrames()
        -- Bank
        local t = nil ---@type trigger

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        local part = MAX_STOCK // 2
        for i = 0, part - 1 do
            for j = 0, 1 do
                local index = i + part * j
                x1[index] = 0.022500 + i * 0.045
                y1[index] = -0.05 - j * 0.045
                x2[index] = -0.022500 - (part - 1 - i) * 0.045
                y2[index] = 0.05 + (1 - j) * 0.045
            end
        end

        SummonADigimon = BlzCreateFrame("IconButtonTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_TOPLEFT, 0.220000, 0.180000)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_BOTTOMRIGHT, 0.255000, 0.145000)
        AddDefaultTooltip(SummonADigimon, "Your digimons", "Look your stored digimons.")
        AssignFrame(SummonADigimon, 20)

        BackdropSummonADigimon = BlzCreateFrameByType("BACKDROP", "BackdropSummonADigimon", SummonADigimon, "", 0)
        BlzFrameSetAllPoints(BackdropSummonADigimon, SummonADigimon)
        BlzFrameSetTexture(BackdropSummonADigimon, "ReplaceableTextures\\CommandButtons\\BTNDigimonsIcon.blp", 0, true)

        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SummonADigimon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SummonADigimonFunc)
        BlzFrameSetVisible(SummonADigimon, false)
        AddFrameToMenu(SummonADigimon)

        StockedDigimonsMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.00000, 0.340000)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.220000, 0.150000)
        BlzFrameSetVisible(StockedDigimonsMenu, false)
        AddFrameToMenu(StockedDigimonsMenu)

        local indexes = {[0] = 21, 22, 23, 24, 25, 26, 27, 28}

        for i = 0, MAX_STOCK - 1 do
            DigimonT[i] = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu, 0, 0)
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            BackdropDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT[" .. i .. "]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(BackdropDigimonT[i], DigimonT[i])
            BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            BlzFrameSetLevel(BackdropDigimonT[i], 1)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, DigimonT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () PressedActions(i) end) -- :D
            AssignFrame(DigimonT[i], indexes[i])

            DigimonTUsed[i] = BlzCreateFrameByType("BACKDROP", "DigimonTUsed[" .. i .."]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(DigimonTUsed[i], DigimonT[i])
            BlzFrameSetTexture(DigimonTUsed[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(DigimonTUsed[i], 127)
            BlzFrameSetLevel(DigimonTUsed[i], 2)
            BlzFrameSetVisible(DigimonTUsed[i], false)

            DigimonTSelected[i] = BlzCreateFrameByType("BACKDROP", "Selected[" .. i .."]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(DigimonTSelected[i], DigimonT[i])
            BlzFrameSetTexture(DigimonTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(DigimonTSelected[i], 3)
            BlzFrameSetVisible(DigimonTSelected[i], false)

            DigimonTIsMain[i] = BlzCreateFrameByType("TEXT", "name", DigimonT[i], "", 0)
            BlzFrameSetPoint(DigimonTIsMain[i], FRAMEPOINT_TOPRIGHT, DigimonT[i], FRAMEPOINT_TOPRIGHT, 0.0000, 0.0000)
            BlzFrameSetPoint(DigimonTIsMain[i], FRAMEPOINT_BOTTOMLEFT, DigimonT[i], FRAMEPOINT_BOTTOMLEFT, -0.01, -0.01)
            BlzFrameSetText(DigimonTIsMain[i], "|cff00ff00§|r")
            BlzFrameSetEnable(DigimonTIsMain[i], false)
            BlzFrameSetScale(DigimonTIsMain[i], 1.5)
            BlzFrameSetTextAlignment(DigimonTIsMain[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_RIGHT)
            BlzFrameSetLevel(DigimonTIsMain[i], 3)
            BlzFrameSetVisible(DigimonTIsMain[i], false)

            DigimonTCooldownT[i] = BlzCreateFrameByType("TEXT", "DigimonTCooldownT[" .. i .."]", DigimonT[i], "", 0)
            BlzFrameSetAllPoints(DigimonTCooldownT[i], DigimonT[i])
            BlzFrameSetText(DigimonTCooldownT[i], "60")
            BlzFrameSetEnable(DigimonTCooldownT[i], false)
            BlzFrameSetScale(DigimonTCooldownT[i], 2.14)
            BlzFrameSetTextAlignment(DigimonTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(DigimonTCooldownT[i], 4)
            BlzFrameSetVisible(DigimonTCooldownT[i], false)

            DigimonTTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", DigimonT[i],0,0)

            DigimonTTooltipText[i] = BlzCreateFrameByType("TEXT", "DigimonTTooltipText[" .. i .."]", DigimonTTooltip[i], "", 0)
            BlzFrameSetPoint(DigimonTTooltipText[i], FRAMEPOINT_BOTTOMLEFT, DigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(DigimonTTooltipText[i], "Empty slot")
            BlzFrameSetScale(DigimonTTooltipText[i], 1.14)
            BlzFrameSetTextAlignment(DigimonTTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(DigimonTTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonTTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(DigimonT[i], DigimonTTooltip[i])
        end

        Text = BlzCreateFrameByType("TEXT", "name", StockedDigimonsMenu, "", 0)
        BlzFrameSetPoint(Text, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.020000)
        BlzFrameSetPoint(Text, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.050000, 0.14000)
        BlzFrameSetText(Text, "|cffFFCC00Choose a Digimon|r")
        BlzFrameSetEnable(Text, false)
        BlzFrameSetScale(Text, 1.00)
        BlzFrameSetTextAlignment(Text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Summon = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Summon, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14500)
        BlzFrameSetPoint(Summon, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, 0.02000)
        BlzFrameSetText(Summon, "|cffFCD20DSummon|r")
        BlzFrameSetScale(Summon, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Summon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SummonFunc)
        AssignFrame(Summon, 29)

        Store = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14500)
        BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, 0.02000)
        BlzFrameSetText(Store, "|cffFCD20DStore|r")
        BlzFrameSetScale(Store, 1.00)
        BlzFrameSetVisible(Store, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Store, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, StoreFunc)
        AssignFrame(Store, 30)

        Free = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.11000, -0.14500)
        BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.02000)
        BlzFrameSetText(Free, "|cffFCD20DFree|r")
        BlzFrameSetScale(Free, 1.00)
        BlzFrameSetEnable(Free, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Free, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, FreeFunc)
        AssignFrame(Free, 31)

        Warning = BlzCreateFrame("QuestButtonBaseTemplate", Free,0,0)
        BlzFrameSetPoint(Warning, FRAMEPOINT_TOPLEFT, Free, FRAMEPOINT_TOPLEFT, -0.020000, 0.025000)
        BlzFrameSetPoint(Warning, FRAMEPOINT_BOTTOMRIGHT, Free, FRAMEPOINT_BOTTOMRIGHT, 0.030000, -0.010000)
        BlzFrameSetVisible(Warning, false)

        AreYouSure = BlzCreateFrameByType("TEXT", "name", Warning, "", 0)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.025000)
        BlzFrameSetText(AreYouSure, "|cffFFCC00Are you sure you wanna free this digimon?|r")
        BlzFrameSetEnable(AreYouSure, false)
        BlzFrameSetScale(AreYouSure, 1.00)
        BlzFrameSetTextAlignment(AreYouSure, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Yes = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetPoint(Yes, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.010000, -0.035000)
        BlzFrameSetPoint(Yes, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.0050000)
        BlzFrameSetText(Yes, "|cffFCD20DYes|r")
        BlzFrameSetScale(Yes, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Yes, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, YesFunc)
        AssignFrame(Yes, 32)

        No = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
        BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
        BlzFrameSetText(No, "|cffFCD20DNo|r")
        BlzFrameSetScale(No, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, No, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, NoFunc)
        AssignFrame(No, 33)

        -- Saved

        SaveItem = BlzCreateFrame("IconButtonTemplate", SummonADigimon, 0, 0)
        BlzFrameSetAbsPoint(SaveItem, FRAMEPOINT_TOPLEFT, 0.26000, 0.180000)
        BlzFrameSetAbsPoint(SaveItem, FRAMEPOINT_BOTTOMRIGHT, 0.29500, 0.145000)
        AddDefaultTooltip(SaveItem, "Save item", "Saves the selected item in the bank (you have to go to the bank to see it).")

        BackdropSaveItem = BlzCreateFrameByType("BACKDROP", "BackdropSaveItem", SaveItem, "", 0)
        BlzFrameSetAllPoints(BackdropSaveItem, SaveItem)
        BlzFrameSetTexture(BackdropSaveItem, "ReplaceableTextures\\CommandButtons\\BTNBankIcon.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SaveItem, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, function () UseCaster("Q") end)

        SavedDigimons = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_TOPLEFT, 0.230000, 0.510000)
        BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, 0.570000, 0.180000)
        BlzFrameSetVisible(SavedDigimons, false)
        AddFrameToMenu(SavedDigimons)

        Using = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
        BlzFrameSetPoint(Using, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.040000, -0.030000)
        BlzFrameSetPoint(Using, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.20000, 0.28000)
        BlzFrameSetText(Using, "|cffFFCC00Using|r")
        BlzFrameSetEnable(Using, false)
        BlzFrameSetTextAlignment(Using, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        part = MAX_STOCK // 2
        for i = 0, part - 1 do
            for j = 0, 1 do
                local index = i + part * j
                x1[index] = 0.040000 + j * 0.05000
                y1[index] = -0.070000 - i * 0.05000
                x2[index] = -0.25000 + j * 0.05000
                y2[index] = 0.21000 - i * 0.05000
            end
        end

        for i = 0, MAX_STOCK - 1 do
            UsingDigimonT[i] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
            BlzFrameSetPoint(UsingDigimonT[i], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(UsingDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])

            BackdropUsingDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT[" .. i .. "]", UsingDigimonT[i], "", 0)
            BlzFrameSetAllPoints(BackdropUsingDigimonT[i], UsingDigimonT[i])
            BlzFrameSetTexture(BackdropUsingDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, UsingDigimonT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () PressedUsing(i) end)

            UsingTSelected[i] = BlzCreateFrameByType("BACKDROP", "UsingTSelected[" .. i .."]", UsingDigimonT[i], "", 1)
            BlzFrameSetAllPoints(UsingTSelected[i], UsingDigimonT[i])
            BlzFrameSetTexture(UsingTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(UsingTSelected[i], 3)
            BlzFrameSetVisible(UsingTSelected[i], false)

            UsedT[i] = BlzCreateFrameByType("BACKDROP", "UsedT[" .. i .."]", UsingDigimonT[i], "", 1)
            BlzFrameSetAllPoints(UsedT[i], UsingDigimonT[i])
            BlzFrameSetTexture(UsedT[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(UsedT[i], 127)
            BlzFrameSetLevel(UsedT[i], 2)
            BlzFrameSetVisible(UsedT[i], false)

            UsingTCooldownT[i] = BlzCreateFrameByType("TEXT", "UsingTCooldownT[" .. i .."]", UsingDigimonT[i], "", 0)
            BlzFrameSetAllPoints(UsingTCooldownT[i], UsingDigimonT[i])
            BlzFrameSetText(UsingTCooldownT[i], "60")
            BlzFrameSetEnable(UsingTCooldownT[i], false)
            BlzFrameSetScale(UsingTCooldownT[i], 2.14)
            BlzFrameSetTextAlignment(UsingTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(UsingTCooldownT[i], 4)
            BlzFrameSetVisible(UsingTCooldownT[i], false)

            UsingTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", UsingDigimonT[i],0,0)

            UsingTooltipText[i] = BlzCreateFrameByType("TEXT", "UsingTooltipText[" .. i .."]", UsingTooltip[i], "", 0)
            BlzFrameSetPoint(UsingTooltipText[i], FRAMEPOINT_BOTTOMLEFT, UsingDigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(UsingTooltipText[i], "Empty slot")
            BlzFrameSetScale(UsingTooltipText[i], 1.14)
            BlzFrameSetTextAlignment(UsingTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(UsingTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_TOPLEFT, UsingTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_BOTTOMRIGHT, UsingTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(UsingDigimonT[i], UsingTooltip[i])
        end

        Saved = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
        BlzFrameSetPoint(Saved, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.20000, -0.030000)
        BlzFrameSetPoint(Saved, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.28000)
        BlzFrameSetText(Saved, "|cffFFCC00Saved|r")
        BlzFrameSetEnable(Saved, false)
        BlzFrameSetTextAlignment(Saved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        part = MAX_SAVED // 2
        for i = 0, part - 1 do
            for j = 0, 1 do
                local index = i + part * j
                x1[index] = 0.20000 + j * 0.05000
                y1[index] = -0.070000 - i * 0.05000
                x2[index] = -0.090000 + j * 0.05000
                y2[index] = 0.21000 - i * 0.05000
            end
        end

        for i = 0, MAX_SAVED - 1 do
            SavedDigimonT[i] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
            BlzFrameSetPoint(SavedDigimonT[i], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(SavedDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])

            BackdropSavedDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT[" .. i .. "]", SavedDigimonT[i], "", 0)
            BlzFrameSetAllPoints(BackdropSavedDigimonT[i], SavedDigimonT[i])
            BlzFrameSetTexture(BackdropSavedDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, SavedDigimonT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () PressedSaved(i) end)

            SavedTSelected[i] = BlzCreateFrameByType("BACKDROP", "SavedTSelected[" .. i .."]", SavedDigimonT[i], "", 1)
            BlzFrameSetAllPoints(SavedTSelected[i], SavedDigimonT[i])
            BlzFrameSetTexture(SavedTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(SavedTSelected[i], 3)
            BlzFrameSetVisible(SavedTSelected[i], false)

            SavedDigimonLocked[i] = BlzCreateFrameByType("BACKDROP", "SavedDigimonLocked[" .. i .."]", SavedDigimonT[i], "", 1)
            BlzFrameSetAllPoints(SavedDigimonLocked[i], SavedDigimonT[i])
            BlzFrameSetTexture(SavedDigimonLocked[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(SavedDigimonLocked[i], 127)
            BlzFrameSetLevel(SavedDigimonLocked[i], 2)
            BlzFrameSetVisible(SavedDigimonLocked[i], false)

            SavedTCooldownT[i] = BlzCreateFrameByType("TEXT", "SavedTCooldownT[" .. i .."]", SavedDigimonT[i], "", 0)
            BlzFrameSetAllPoints(SavedTCooldownT[i], SavedDigimonT[i])
            BlzFrameSetText(SavedTCooldownT[i], "60")
            BlzFrameSetEnable(SavedTCooldownT[i], false)
            BlzFrameSetScale(SavedTCooldownT[i], 2.14)
            BlzFrameSetTextAlignment(SavedTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(SavedTCooldownT[i], 4)
            BlzFrameSetVisible(SavedTCooldownT[i], false)

            SavedTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", SavedDigimonT[i],0,0)

            SavedTooltipText[i] = BlzCreateFrameByType("TEXT", "SavedTooltipText[" .. i .."]", SavedTooltip[i], "", 0)
            BlzFrameSetPoint(SavedTooltipText[i], FRAMEPOINT_BOTTOMLEFT, SavedDigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(SavedTooltipText[i], "Empty slot")
            BlzFrameSetScale(SavedTooltipText[i], 1.14)
            BlzFrameSetTextAlignment(SavedTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(SavedTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_TOPLEFT, SavedTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_BOTTOMRIGHT, SavedTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(SavedDigimonT[i], SavedTooltip[i])
        end

        Swap = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
        BlzFrameSetAbsPoint(Swap, FRAMEPOINT_TOPLEFT, 0.360000, 0.230000)
        BlzFrameSetAbsPoint(Swap, FRAMEPOINT_BOTTOMRIGHT, 0.440000, 0.200000)
        BlzFrameSetText(Swap, "|cffFCD20DSwap|r")
        BlzFrameSetScale(Swap, 1.29)
        BlzFrameSetEnable(Swap, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Swap, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SwapFunc)

        ExitSave = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
        BlzFrameSetPoint(ExitSave, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.31000, -0.0050000)
        BlzFrameSetPoint(ExitSave, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.30000)
        BlzFrameSetText(ExitSave, "|cffFCD20DX|r")
        BlzFrameSetScale(ExitSave, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, ExitSave, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitSaveFunc)

        -- Item

        ItemMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_TOPLEFT, 0.240000, 0.500000)
        BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_BOTTOMRIGHT, 0.540000, 0.200000)
        BlzFrameSetVisible(ItemMenu, false)

        ExitItem = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetPoint(ExitItem, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.27000, -0.0050000)
        BlzFrameSetPoint(ExitItem, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.27000)
        BlzFrameSetText(ExitItem, "|cffFCD20DX|r")
        BlzFrameSetScale(ExitItem, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, ExitItem, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitItemFunc)

        SaveItemDrop = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.040000, -0.25000)
        BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.16000, 0.020000)
        BlzFrameSetText(SaveItemDrop, "|cffFCD20DDrop|r")
        BlzFrameSetScale(SaveItemDrop, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SaveItemDrop, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SaveItemDropFunc)

        SaveItemDiscard = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.16000, -0.25000)
        BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.020000)
        BlzFrameSetText(SaveItemDiscard, "|cffFCD20DDiscard|r")
        BlzFrameSetScale(SaveItemDiscard, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SaveItemDiscard, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SaveItemDiscardFunc)

        part = MAX_SAVED_ITEMS // 4
        for i = 0, part - 1 do
            for j = 0, 3 do
                local index = i + part * j + 1
                x1[index] = 0.030000 + j * 0.0625
                y1[index] = -0.050000 - i * 0.0625
                x2[index] = -0.22000 + j * 0.0625
                y2[index] = 0.20000 - i * 0.0625
            end
        end

        for i = 1, MAX_SAVED_ITEMS do
            SavedItemT[i] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
            BlzFrameSetPoint(SavedItemT[i], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(SavedItemT[i], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])

            BackdropSavedItemT[i] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[" .. i .. "]", SavedItemT[i], "", 0)
            BlzFrameSetAllPoints(BackdropSavedItemT[i], SavedItemT[i])
            BlzFrameSetTexture(BackdropSavedItemT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, SavedItemT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () SavedItemTFunc(i) end)

            SaveItemLocked[i] = BlzCreateFrameByType("BACKDROP", "SaveItemLocked[" .. i .."]", SavedItemT[i], "", 1)
            BlzFrameSetAllPoints(SaveItemLocked[i], SavedItemT[i])
            BlzFrameSetTexture(SaveItemLocked[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(SaveItemLocked[i], 127)
            BlzFrameSetLevel(SaveItemLocked[i], 2)
            BlzFrameSetVisible(SaveItemLocked[i], false)

            SavedItemTSelected[i] = BlzCreateFrameByType("BACKDROP", "SavedItemTSelected[" .. i .."]", SavedItemT[i], "", 1)
            BlzFrameSetAllPoints(SavedItemTSelected[i], SavedItemT[i])
            BlzFrameSetTexture(SavedItemTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(SavedItemTSelected[i], 3)
            BlzFrameSetVisible(SavedItemTSelected[i], false)

            SaveItemTooltip[i] = BlzCreateFrame("QuestButtonBaseTemplate", SavedItemT[i], 0, 0)

            SaveItemTooltipText[i] = BlzCreateFrameByType("TEXT", "name", SaveItemTooltip[i], "", 0)
            BlzFrameSetPoint(SaveItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, SavedItemT[i], FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.025000)
            BlzFrameSetText(SaveItemTooltipText[i], "Empty")
            BlzFrameSetEnable(SaveItemTooltipText[i], false)
            BlzFrameSetScale(SaveItemTooltipText[i], 1.00)
            BlzFrameSetTextAlignment(SaveItemTooltipText[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            BlzFrameSetPoint(SaveItemTooltip[i], FRAMEPOINT_TOPLEFT, SaveItemTooltipText[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
            BlzFrameSetPoint(SaveItemTooltip[i], FRAMEPOINT_BOTTOMRIGHT, SaveItemTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)
            BlzFrameSetTooltip(SavedItemT[i], SaveItemTooltip[i])
        end


        BuySlotMenu = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.300000, 0.420000)
        BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, 0.480000, 0.300000)
        BlzFrameSetVisible(BuySlotMenu, false)

        BuySlotMessage = BlzCreateFrameByType("TEXT", "name", BuySlotMenu, "", 0)
        BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.035000)
        BlzFrameSetText(BuySlotMessage, "|cffffffffDo you want to buy a new item slot for 0 digibits?|r")
        BlzFrameSetEnable(BuySlotMessage, false)
        BlzFrameSetScale(BuySlotMessage, 1.43)
        BlzFrameSetTextAlignment(BuySlotMessage, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        BuySlotYes = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
        BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.025000, -0.087500)
        BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10500, 0.0025000)
        BlzFrameSetText(BuySlotYes, "|cffFCD20DYes|r")
        BlzFrameSetScale(BuySlotYes, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, BuySlotYes, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BuySlotYesFunc)

        BuySlotNo = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
        BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.10500, -0.087500)
        BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.0025000)
        BlzFrameSetText(BuySlotNo, "|cffFCD20DNo|r")
        BlzFrameSetScale(BuySlotNo, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, BuySlotNo, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BuySlotNoFunc)

        SellItem = BlzCreateFrame("IconButtonTemplate", SummonADigimon, 0, 0)
        BlzFrameSetAbsPoint(SellItem, FRAMEPOINT_TOPLEFT, 0.30000, 0.180000)
        BlzFrameSetAbsPoint(SellItem, FRAMEPOINT_BOTTOMRIGHT, 0.33500, 0.145000)
        AddDefaultTooltip(SellItem, "Sell item", "Sells the selected item of yours.")

        BackdropSellItem = BlzCreateFrameByType("BACKDROP", "BackdropSellItem", SellItem, "", 0)
        BlzFrameSetAllPoints(BackdropSellItem, SellItem)
        BlzFrameSetTexture(BackdropSellItem, "ReplaceableTextures\\CommandButtons\\BTNSellIcon.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SellItem, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, function () UseCaster("W") end)
    end

    FrameLoaderAdd(InitFrames)

    -- Update frames
    Timed.echo(0.1, function ()
        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            local bank = Bank[i] ---@type Bank
            if GetDigimonCount(bank.p) > 0 then
                if bank.p == LocalPlayer then
                    BlzFrameSetEnable(Summon, bank:useDigimonConditions() and bank:avaible(bank.pressed))
                    BlzFrameSetEnable(Store, bank:storeDigimonConditions() and bank.inUse[bank.pressed] ~= nil)
                    BlzFrameSetEnable(Free, bank:freeDigimonConditions() and bank.inUse[bank.pressed] ~= nil)
                end
            end
        end
    end)

    -- Functions to use

    ---@param p player
    ---@return Digimon?
    function GetMainDigimon(p)
        return Bank[GetPlayerId(p)].main
    end

    ---@param p player
    ---@param d Digimon
    ---@return boolean
    function IsMainDigimon(p, d)
        return Bank[GetPlayerId(p)].main == d
    end

    ---@param p player
    ---@param d Digimon
    ---@return integer
    function SendToBank(p, d)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local index = -1
        for i = 0, MAX_STOCK - 1 do
            if not bank.stocked[i] then
                bank.stocked[i] = d
                d.owner = p
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
                if bank.main == d then
                    bank:searchMain()
                end
                index = i
                break
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return index
    end

    ---@param p player
    ---@param d Digimon
    ---@param hide boolean
    ---@return integer
    function StoreToBank(p, d, hide)
        local result = Bank[GetPlayerId(p)]:storeDigimon(GetBankIndex(p, d), hide)

        if p == LocalPlayer then
            UpdateMenu()
        end

        return result
    end

    ---@param p player
    ---@param index integer
    ---@return boolean
    function SummonDigimon(p, index)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = bank.stocked[index] ---@type Digimon
        local b = false
        if d then
            bank.inUse[index] = d
            d:setOwner(p)
            if not bank.main then
                bank.main = d
                d:showFromTheCorner(bank.spawnPoint.x, bank.spawnPoint.y)
                d.environment:apply(p, false)
                if p == LocalPlayer then
                    PanCameraToTimed(bank.spawnPoint.x, bank.spawnPoint.y, 0)
                end
            else
                d:showFromTheCorner(bank.main:getX(), bank.main:getY())
                d.environment = bank.main.environment
            end
            b = true
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return b
    end

    ---@param p player
    ---@param index integer
    ---@param immediatly? boolean
    ---@return Digimon
    function RemoveFromBank(p, index, immediatly)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = bank.stocked[index] ---@type Digimon
        if d then
            bank.stocked[index] = nil
            d.owner = nil
            ReleaseDigimon(d:getOwner(), d)
            d:setOwner(Digimon.PASSIVE)
            if bank.inUse[index] then
                bank.inUse[index] = nil
            else
                d:showFromTheCorner(bank.main:getX(), bank.main:getY())
            end
            if bank.main == d then
                bank:searchMain()
            end
            if not immediatly then
                Timed.call(5 * math.random(), function ()
                    d:issueOrder(Orders.smart, MapBounds:getRandomX(), MapBounds:getRandomY())
                end)
                d:remove(30.)
            else
                d:destroy()
            end
            if bank.pressed == index then
                bank.pressed = -1
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return d
    end

    ---@param p player
    ---@param d Digimon
    ---@return integer
    function GetBankIndex(p, d)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            if bank.stocked[i] == d then
                return i
            end
        end
        return -1
    end

    ---@param p player
    ---@param index integer
    ---@return Digimon
    function GetBankDigimon(p, index)
        return Bank[GetPlayerId(p)].stocked[index]
    end

    -- When dies

    Digimon.killEvent:register(function (info)
        local dead = info.target ---@type Digimon
        local p = dead:getOwner()
        if not Digimon.isNeutral(p) then
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            local allDead = true
            local index = -1
            for i = 0, MAX_STOCK - 1 do
                local d = bank.stocked[i]
                if d then
                    if dead == d then
                        index = i
                    end
                    allDead = allDead and not d:isAlive()
                end
            end
            -- If all the digimons died then the spawnpoint will be the clinic
            if allDead then
                if not revivingSuspended[p] then
                    DisplayTextToPlayer(p, 0, 0, "All your digimons are death, they will respawn in the clinic")
                end
                bank.spawnPoint.x = GetRectCenterX(gg_rct_Hospital)
                bank.spawnPoint.y = GetRectCenterY(gg_rct_Hospital)
                -- The player can see all the map if all their digimons are dead
                -- Environment.allMap:apply(p, false)
            else
                bank.spawnPoint.x = GetRectCenterX(gg_rct_Player_1_Spawn)
                bank.spawnPoint.y = GetRectCenterY(gg_rct_Player_1_Spawn)
            end
            bank.allDead = allDead

            bank:storeDigimon(index, false)
            Timed.call(function () dead:setOwner(Digimon.PASSIVE) end) -- Just to not be detected by the auto-recycler
            -- Hide after 2 seconds to not do it automatically
            Timed.call(2., function ()
                dead:hideInTheCorner()
            end)

            -- Cooldown
            local lvl = dead:getLevel()
            if lvl > 0 and lvl <= 20 then
                cooldowns[dead] = 30
            elseif lvl > 20 and lvl <= 50 then
                cooldowns[dead] = 60
            elseif lvl > 50 and lvl <= 90 then
                cooldowns[dead] = 90
            else
                cooldowns[dead] = 120
            end
            if p == LocalPlayer then
                UpdateMenu()
                BlzFrameSetVisible(DigimonTCooldownT[index], true)
            end
            Timed.echo(1., function ()
                if revivingSuspended[p] then
                    return
                end

                -- In case the digimon revived by another method
                if dead:isAlive() then
                    cooldowns[dead] = 0
                    if p == LocalPlayer then
                        UpdateCooldowns()
                    end
                    bank.allDead = false
                    return true
                end

                local cd = cooldowns[dead] - 1
                cooldowns[dead] = cd
                if p == LocalPlayer then
                    UpdateCooldowns()
                end
                if cd <= 0 then
                    ReviveHero(dead.root, dead:getX(), dead:getY(), false)
                    SetUnitLifePercentBJ(dead.root, 5)
                    if bank.allDead then
                        bank.spawnPoint.x = GetRectCenterX(gg_rct_Hospital)
                        bank.spawnPoint.y = GetRectCenterY(gg_rct_Hospital)
                        for i = 0, MAX_STOCK - 1 do
                            if bank.stocked[i] then
                                bank.stocked[i].environment = Environment.hospital
                            end
                        end
                        SummonDigimon(p, index)
                    end
                    if p == LocalPlayer then
                        UpdateCooldowns()
                    end
                    bank.allDead = false
                    return true
                end
            end)
        end
    end)

    ---@param d Digimon
    ---@return number
    function GetDigimonCooldown(d)
        return cooldowns[d]
    end

    ---@param p player
    ---@return Digimon[]
    function GetUsedDigimons(p)
        return Bank[GetPlayerId(p)]:getUsedDigimons()
    end

    ---@param p player
    ---@param flag boolean
    function ShowBank(p, flag)
        if p == LocalPlayer then
            if flag then
                BlzFrameSetVisible(SummonADigimon, true)
            else
                BlzFrameSetVisible(SummonADigimon, false)
                BlzFrameSetVisible(StockedDigimonsMenu, false)
                RemoveButtonFromEscStack(SummonADigimon)
            end
        end
    end

    ---@param p player
    function SuspendRevive(p)
        revivingSuspended[p] = true
        if p == LocalPlayer then
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            for i = 0, MAX_STOCK - 1 do
                if bank.stocked[i] and not bank:isAlive(i) then
                    BlzFrameSetText(DigimonTCooldownT[i], "ll")
                end
            end
        end
    end

    ---@param p player
    function ResumeRevive(p)
        revivingSuspended[p] = false
    end

    ---@param p player
    ---@param x number
    ---@param y number
    function SetSpawnPoint(p, x, y)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank.spawnPoint.x = x
        bank.spawnPoint.y = y
    end

    ---@param p player
    ---@param d Digimon
    ---@return integer
    function SaveDigimon(p, d)
        local result = Bank[GetPlayerId(p)]:saveDigimon(d)

        if p == LocalPlayer then
            UpdateMenu()
        end

        return result
    end

    ---@param p player
    ---@return boolean
    function CanSaveDigimons(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        for i = 0, bank.savedDigimonsStock - 1 do
            if not bank.saved[i] then
                return true
            end
        end
        return false
    end

    ---@param p player
    ---@return Digimon[]
    function GetSavedDigimons(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local result = {}
        for i = 0, MAX_SAVED - 1 do
            if bank.saved[i] then
                table.insert(result, bank.saved[i])
            end
        end
        return result
    end

    ---@param p player
    ---@return integer
    function GetMaxSavedDigimons(p)
        return Bank[GetPlayerId(p)].savedDigimonsStock
    end

    ---@param p player
    ---@param max integer
    function SetMaxSavedDigimons(p, max)
        Bank[GetPlayerId(p)].savedDigimonsStock = max
    end

    ---@param p player
    ---@param index integer
    function RemoveSavedDigimon(p, index)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = bank.saved[index] ---@type Digimon
        if d then
            bank.saved[index] = nil
            d.owner = nil
            d:destroy()
        end
        if p == LocalPlayer then
            UpdateSave()
        end
    end

    ---@param p player
    ---@return integer[] items, integer[] charges, integer stock
    function GetBankItems(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local items = __jarray(0)
        local charges = __jarray(1)
        for i, v in ipairs(bank.savedItems) do
            items[i] = GetItemTypeId(v)
            charges[i] = GetItemCharges(v)
        end
        return items, charges, bank.savedItemsStock
    end

    ---@overload fun(p: player)
    ---@param p player
    ---@param items integer[]
    ---@param charges integer[]
    ---@param stock integer
    function SetBankItems(p, items, charges, stock)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        if items then
            bank.savedItemsStock = stock
            for i = 1, #items do
                local m = CreateItem(items[i], WorldBounds.maxX, WorldBounds.maxY)
                SetItemCharges(m, charges[i])
                bank:saveItem(m)
            end
        else
            bank:clearItems()
        end
        if p == LocalPlayer then
            UpdateItems()
        end
    end

    ---@param p player
    function PlayerIsStucked(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            if bank:avaible(i) and bank:isAlive(i) then
                return false
            end
        end
        local stucked = true
        for _, d in ipairs(bank:getUsedDigimons()) do
            stucked = stucked and d:isPaused()
        end
        return stucked
    end

    ---For debug
    ---@param p any
    ---@param u any
    local function AddToBank(p, u)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = Digimon.getInstance(u)
        for i = 0, MAX_STOCK - 1 do
            if not bank.stocked[i] then
                bank.stocked[i] = d
                bank.inUse[i] = d
                d.owner = p
                if bank.main == d then
                    bank:searchMain()
                end
                break
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    GlobalRemap("udg_AddToBank", nil, function (value)
        AddToBank(Player(0), value)
    end)

end)
Debug.endFile()