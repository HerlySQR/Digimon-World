Debug.beginFile("DigimonBank")
OnInit("DigimonBank", function ()
    Require "AFK"
    Require "Menu"
    Require "Hotkeys"
    Require "EventListener"
    Require "Clear Items"
    Require "PressSaveOrLoad"
    Require "Serializable"
    Require "Digimon"
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
    local REVIVE_ITEM = udg_REVIVE_ITEM
    local REVIVE_COOLDOWN = 90.

    local OriginFrame = BlzGetFrameByName("ConsoleUIBackdrop", 0)

    -- Bank
    local SummonADigimon = nil ---@type framehandle
    local BackdropSummonADigimon = nil ---@type framehandle
    local StockedDigimonsMenu = nil ---@type framehandle
    local DigimonT = {} ---@type framehandle[]
    local BackdropDigimonT = {} ---@type framehandle[]
    local DigimonTUsed = {} ---@type framehandle[]
    local DigimonTDead = {} ---@type framehandle[]
    local DigimonTSelected = {} ---@type framehandle[]
    local DigimonTIsMain = {} ---@type framehandle[]
    local DigimonTTooltip = {} ---@type framehandle[]
    local DigimonTTooltipText = {} ---@type framehandle[]
    local Text = nil ---@type framehandle
    local Summon = nil ---@type framehandle
    local Store = nil ---@type framehandle
    local Revive = nil ---@type framehandle
    local Free = nil ---@type framehandle
    local Warning = nil ---@type framehandle
    local AreYouSure = nil ---@type framehandle
    local Yes = nil ---@type framehandle
    local No = nil ---@type framehandle
    local ReviveItems = nil ---@type framehandle
    local ReviveItemsChargesBackdrop = nil ---@type framehandle
    local ReviveItemsCharges = nil ---@type framehandle
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
    --local SaveItem = nil ---@type framehandle
    --local BackdropSaveItem = nil ---@type framehandle
    local SaveItemTooltip = {} ---@type framehandle[]
    local SaveItemTooltipText = {} ---@type framehandle[]
    --local SellItem = nil ---@type framehandle
    --local BackdropSellItem = nil ---@type framehandle

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

    local CENTAURMON = gg_unit_N004_0002
    local REVIVE_DIGIMONS = FourCC('I05Z')
    local CENTAURMON_REVIVE_EFF_1 = "war3mapImported\\WhHealGreen.mdl"
    local CENTAURMON_REVIVE_EFF_2 = "war3mapImported\\FirstAidV2.mdl"

    IgnoreCommandButton(ITEM_BANK_CASTER)
    IgnoreCommandButton(ITEM_BANK_SELLER)
    IgnoreCommandButton(ITEM_BANK_BUYER)

    local MinRange = 300.

    ---@class Bank
    ---@field stocked Digimon[]
    ---@field inUse Digimon[]
    ---@field saved Digimon[]
    ---@field pressed integer
    ---@field usingClicked integer
    ---@field maxUsable integer
    ---@field savedClicked integer
    ---@field savedDigimonsStock integer
    ---@field wantDigimonSlot boolean
    ---@field p player
    ---@field main Digimon
    ---@field spawnPoint {x: number, y: number}
    ---@field allDead boolean
    ---@field allDeadTimer timer
    ---@field allDeadWindow timerdialog
    ---@field savedItems item[]
    ---@field savedItemsStock integer
    ---@field wantItemSlot boolean
    ---@field itemClicked integer
    ---@field customer Digimon
    ---@field caster unit
    ---@field usingCaster boolean
    ---@field buyer unit
    ---@field seller unit
    ---@field priorities Digimon[]
    ---@field punish boolean
    ---@field reviveItems integer
    ---@field reviveCooldown number
    local Bank = {}
    Bank.__index = Bank

    local LocalPlayer = GetLocalPlayer() ---@type player

    local digimonUpdateEvent = EventListener.create()

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        Bank[i] = setmetatable({
            stocked = {},
            inUse = {},
            saved = {},
            pressed = -1,
            usingClicked = -1,
            maxUsable = MAX_USED,
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
            allDeadTimer = CreateTimer(),
            savedItemsStock = MIN_SAVED_ITEMS,
            wantItemSlot = false,
            savedItems = {},
            itemClicked = -1,
            customer = nil,
            caster = nil,
            buyer = nil,
            seller = nil,
            priorities = {},
            punish = true,
            reviveItems = 0,
            reviveCooldown = 0.
        }, Bank)
    end

    ---@class BankData: Serializable
    ---@field stocked DigimonData[]
    ---@field maxSaved integer
    ---@field saved DigimonData[]
    ---@field sItmsSto integer
    ---@field sItms integer[]
    ---@field sItmsCha integer[]
    ---@field rItms integer
    ---@field rCd number
    ---@field slot integer
    BankData = setmetatable({}, Serializable)
    BankData.__index = BankData

    ---@param main? Bank
    ---@param slot integer
    ---@return BankData|Serializable
    function BankData.create(main, slot)
        local self = {
            stocked = {},
            maxSaved = 0,
            saved = {},
            sItmsSto = MIN_SAVED_ITEMS,
            sItms = {},
            sItmsCha = {},
            rItms = 0,
            rCd = 0.,
        }
        if type(main) == "number" then
            slot = main
            main = nil
        end
        self.slot = slot
        if main then
            for i = 0, MAX_STOCK - 1 do
                if main.stocked[i] then
                    self.stocked[i] = DigimonData.create(main.stocked[i])
                end
            end
            self.maxSaved = main.savedDigimonsStock
            for i = 0, self.maxSaved - 1 do
                if main.saved[i] then
                    self.saved[i] = DigimonData.create(main.saved[i])
                end
            end
            self.sItmsSto = main.savedItemsStock
            for i = 1, self.sItmsSto do
                if main.savedItems[i] then
                    self.sItms[i] = GetItemTypeId(main.savedItems[i])
                    self.sItmsCha[i] = GetItemCharges(main.savedItems[i])
                end
            end
            self.rItms = main.reviveItems
            self.rCd = main.reviveCooldown
        end
        return setmetatable(self, BankData)
    end

    function BankData:serializeProperties()
        for i = 0, MAX_STOCK - 1 do
            if self.stocked[i] then
                self:addProperty("stocked" .. i, self.stocked[i]:serialize())
            end
        end
        self:addProperty("maxSaved", self.maxSaved)
        for i = 0, self.maxSaved - 1 do
            if self.saved[i] then
                self:addProperty("saved" .. i, self.saved[i]:serialize())
            end
        end
        self:addProperty("sItmsSto", self.sItmsSto)
        for i = 1, self.sItmsSto do
            if self.sItms[i] then
                self:addProperty("sItms" .. i, self.sItms[i])
                self:addProperty("sItmsCha" .. i, self.sItmsCha[i])
            end
        end
        self:addProperty("rItms", self.rItms)
        self:addProperty("rCd", self.rCd)
        self:addProperty("slot", self.slot)
    end

    function BankData:deserializeProperties()
        if self.slot ~= self:getIntProperty("slot") then
            error("The slot is not the same.")
            return
        end
        for i = 0, MAX_STOCK - 1 do
            local stocked = self:getStringProperty("stocked" .. i)
            if stocked ~= "" then
                self.stocked[i] = DigimonData.create()
                self.stocked[i]:deserialize(stocked)
            end
        end
        self.maxSaved = self:getIntProperty("maxSaved")
        for i = 0, self.maxSaved - 1 do
            local saved = self:getStringProperty("saved" .. i)
            if saved ~= "" then
                self.saved[i] = DigimonData.create()
                self.saved[i]:deserialize(saved)
            end
        end
        self.sItmsSto = self:getIntProperty("sItmsSto")
        for i = 1, self.sItmsSto do
            local sItms = self:getIntProperty("sItms" .. i)
            if sItms ~= 0 then
                self.sItms[i] = sItms
                self.sItmsCha[i] = self:getIntProperty("sItmsCha" .. i)
            end
        end
        self.rItms = self:getIntProperty("rItms")
        self.rCd = self:getRealProperty("rCd")
    end

    -- Conditions

    ---@return integer
    function Bank:used()
        return #self.priorities
    end

    ---@return boolean
    function Bank:useDigimonConditions()
        if self.pressed == -1 then
            return false
        end
        return self.stocked[self.pressed]:isAlive() and self:used() < self.maxUsable
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
        local list = self.priorities

        for i = 1, #list do
            local d = list[i]
            centerX = centerX + d:getX()
            centerY = centerY + d:getY()
        end

        centerX = centerX / max
        centerY = centerY / max

        for i = 1, #list do
            local d = list[i]
            if math.sqrt((d:getX() - centerX)^2 + (d:getY() - centerY)^2) > 400. then
                return false
            end
        end

        return true
    end

    ---@return boolean
    function Bank:reviveDigimonConditions()
        if self.pressed == -1 or self.reviveItems <= 0 or self.reviveCooldown > 0 then
            return false
        end

        return not self.allDead and not self.stocked[self.pressed]:isAlive()
    end

    ---@return boolean
    function Bank:freeDigimonConditions()
        if self.pressed == -1 then
            return false
        end

        return self:used() > 1 and self.stocked[self.pressed]:isAlive()
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
            for i = #self.priorities, 1, -1 do
                if self.priorities[i] == d then
                    table.remove(self.priorities, i)
                    break
                else
                    BlzSetUnitRealField(self.priorities[i].root, UNIT_RF_PRIORITY, MAX_STOCK - i + 1)
                end
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
            return d:isAlive()
        end
        return false
    end

    ---Save a digimon in the bank
    ---@param d Digimon
    ---@return integer
    function Bank:saveDigimon(d)
        if not self:isSaved(d) then
            for i = 0, self.savedDigimonsStock - 1 do
                if not self.saved[i] then
                    self.saved[i] = d
                    d.saved = true
                    d:setOwner(Digimon.PASSIVE)
                    d:hideInTheCorner()
                    return i
                end
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
                old1.saved = true
            end
            if old2 then
                old2.saved = false
            end

            self.stocked[index1] = old2
            self.saved[index2] = old1

            if self.pressed == index1 then
                self.pressed = -1
            end
        end
    end

    ---@param m item
    ---@return boolean
    function Bank:saveItem(m)
        if #self.savedItems < self.savedItemsStock then
            table.insert(self.savedItems, m)
            SetItemVisible(m, false)
            SetItemPosition(m, WorldBounds.maxX, WorldBounds.maxY)
            SetItemLifeSpan(m, math.maxinteger)
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
        SetItemLifeSpan(m)
    end

    function Bank:discardItem()
        local m = table.remove(self.savedItems, self.itemClicked)
        if m then
            RemoveItem(m)
        end
    end

    function Bank:clearDigimons()
        for i = 0, MAX_STOCK - 1 do
            if self.stocked[i] then
                self.stocked[i]:destroy()
                self.stocked[i] = nil
            end
            if self.inUse[i] then
                self.inUse[i] = nil
            end
        end
        for i = 0, self.savedDigimonsStock - 1 do
            if self.saved[i] then
                self.saved[i]:destroy()
                self.saved[i] = nil
            end
        end
        self.main = nil
        self.pressed = -1
        self.usingClicked = -1
        self.savedClicked = -1
        self.wantDigimonSlot = false
        self.allDead = false
        self.savedDigimonsStock = 0
        self.priorities = {}
        self.spawnPoint.x = GetRectCenterX(gg_rct_Player_1_Spawn)
        self.spawnPoint.y = GetRectCenterY(gg_rct_Player_1_Spawn)
        self.reviveItems = 0
        self.punish = false
        self.maxUsable = MAX_USED
    end

    function Bank:clearItems()
        for i = #self.savedItems, 1, -1 do
            RemoveItem(self.savedItems[i])
            self.savedItems[i] = nil
        end
        self.wantItemSlot = false
        self.itemClicked = -1
    end

    --[[function Bank:resetCaster()
        SetUnitOwner(self.caster, Digimon.PASSIVE, false)
        if self.p == LocalPlayer then
            ClearSelection()
        end
        RestartSelectedUnits(self.p)
        self.usingCaster = false

        if self.p == LocalPlayer then
            BlzFrameSetEnable(SaveItem, true)
            BlzFrameSetEnable(SellItem, true)
        end
    end]]

    ---@param d Digimon
    ---@return boolean
    function Bank:isStocked(d)
        for i = 0, MAX_STOCK - 1 do
            if self.stocked[i] == d then
                return true
            end
        end
        return false
    end

    ---@param d Digimon
    ---@return boolean
    function Bank:isSaved(d)
        for i = 0, MAX_STOCK - 1 do
            if self.saved[i] == d then
                return true
            end
        end
        return false
    end

    -- Store all the digimon in case of AFK
    AFKEvent:register(function (p)
        local bank = Bank[GetPlayerId(p)]
        for i = 0, MAX_STOCK - 1 do
            bank:storeDigimon(i, true)
        end
        DisplayTextToPlayer(LocalPlayer, 0, 0, GetPlayerName(p) .. " was afk for too long, all its digimons were stored.")
    end)

    --[[local dummyHeros = {} ---@type unit[]
    local heroGlows = {} ---@type framehandle[]

    for i = 1, 3 do
        dummyHeros[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('Hpal'), WorldBounds.maxX, WorldBounds.maxY, 0)
    end]]

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            local p = GetEnumPlayer()
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            bank.caster = CreateUnit(Digimon.PASSIVE, ITEM_BANK_CASTER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.seller = CreateUnit(Digimon.PASSIVE, ITEM_BANK_SELLER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.buyer = CreateUnit(Digimon.PASSIVE, ITEM_BANK_BUYER, WorldBounds.maxX, WorldBounds.maxY, 0)
            bank.allDeadWindow = CreateTimerDialog(bank.allDeadTimer)
            TimerDialogSetTitle(bank.allDeadWindow, "Your digimon revive in:")
            --[[for i = 1, 3 do
                SetUnitOwner(dummyHeros[i], p, false)
            end]]
        end)
        AddItemToStock(CENTAURMON, REVIVE_DIGIMONS, 1, 1)
        --[[for i = 0, 2 do
            heroGlows[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)
        end
        for i = 1, 3 do
            RemoveUnit(dummyHeros[i])
        end]]
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

    Digimon.createEvent:register(function (d)
        if IsPlayerInGame(d.owner) then
            d:addAbility(SAVE_ITEM)
            d:addAbility(SELL_ITEM)
        end
    end)

    Digimon.capturedEvent:register(function (info)
        info.target:addAbility(SAVE_ITEM)
        info.target:addAbility(SELL_ITEM)
    end)

    Digimon.evolutionEvent:register(function (d)
        d:addAbility(SAVE_ITEM)
        d:addAbility(SELL_ITEM)
    end)

    local trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddCondition(trig, Condition(function () return GetSpellAbilityId() == SAVE_ITEM or GetSpellAbilityId() == SELL_ITEM end))
    TriggerAddAction(trig, function ()
        local caster = GetSpellAbilityUnit()
        local p = GetOwningPlayer(caster)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local target = GetSpellTargetItem()
        local x, y = GetItemX(target), GetItemY(target)

        --[[if not GetRandomUnitOnRange(x, y, MinRange, function (u2) return GetOwningPlayer(u2) == p and Digimon.getInstance(u2) ~= nil end) then
            ErrorMessage("A digimon should be nearby the item", p)
        else]]if GetPlayerController(GetItemPlayer(target)) == MAP_CONTROL_USER and GetItemPlayer(target) ~= p then
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
                Timed.call(function ()
                    SetUnitOwner(bank.seller, Digimon.PASSIVE)
                end)
            end
        end

        --bank:resetCaster()
    end)

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
    end

    local function ExitSaveFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank.wantDigimonSlot = false
        if p == LocalPlayer then
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

    -- Update frames

    local function UpdateButtons()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        BlzFrameSetEnable(Summon, bank:useDigimonConditions() and bank:avaible(bank.pressed))
        BlzFrameSetEnable(Store, bank:storeDigimonConditions() and bank.inUse[bank.pressed] ~= nil)
        BlzFrameSetEnable(Free, bank:freeDigimonConditions() and bank.inUse[bank.pressed] ~= nil)
        BlzFrameSetEnable(Revive, bank:reviveDigimonConditions())
    end

    Timed.echo(0.1, UpdateButtons)

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
                    BlzFrameSetVisible(DigimonTDead[i], false)
                else
                    if d:isAlive() then
                        text = text .. "|cff00ff00Stored|r"
                        BlzFrameSetVisible(DigimonTDead[i], false)
                    else
                        text = text .. "|cffff0000Dead|r"
                        BlzFrameSetVisible(DigimonTDead[i], true)
                        BlzFrameSetAlpha(DigimonTDead[i], 127)
                    end
                    BlzFrameSetVisible(DigimonTUsed[i], false)
                end
                BlzFrameSetText(DigimonTTooltipText[i], text)
                BlzFrameSetSize(DigimonTTooltipText[i], 0.2, 0)

                BlzFrameSetVisible(DigimonTIsMain[i], bank.main == d)

                BlzFrameSetText(Revive, (bank.reviveCooldown > 0 and ("[" .. math.floor(bank.reviveCooldown) .. "] ") or "") .. "|cffFCD20DRevive|r")

                if bank.reviveItems > 0 then
                    BlzFrameSetVisible(ReviveItems, true)
                    BlzFrameSetText(ReviveItemsCharges, tostring(bank.reviveItems))
                else
                    BlzFrameSetVisible(ReviveItems, false)
                end
            else
                -- Button
                BlzFrameSetEnable(DigimonT[i], false)
                BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                -- Tooltip
                BlzFrameSetText(DigimonTTooltipText[i], "Empty slot")
                BlzFrameSetSize(DigimonTTooltipText[i], 0, 0.01)
                -- Hide
                BlzFrameSetVisible(DigimonTUsed[i], false)
                BlzFrameSetVisible(DigimonTIsMain[i], false)
            end
            if bank.pressed ~= i then
                BlzFrameSetVisible(DigimonTSelected[i], false)
            end
            -- Re-size
            BlzFrameClearAllPoints(DigimonTTooltip[i])
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonTTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
        if bank.pressed ~= -1 and BlzFrameGetEnable(DigimonT[bank.pressed]) then
            BlzFrameClick(DigimonT[bank.pressed])
        end
        UpdateButtons()
    end

    -- When the digimon evolves
    Digimon.evolutionEvent:register(function (evolve)
        if evolve:getOwner() == LocalPlayer then
            UpdateMenu()
            UpdateSave()
        end
    end)

    --[[---@param p player
    ---@param key string
    local function UseCaster(p, key)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        SetUnitOwner(bank.caster, p, false)
        SaveSelectedUnits(p)

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
        end, function ()
            SyncSelections()
            if not IsUnitSelected(bank.caster, p) then
                bank:resetCaster()
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
    end)]]

    local function SaveItemDropFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank:dropItem()
        if p == LocalPlayer then
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            UpdateItems()
            -- Disable
            BlzFrameSetEnable(SaveItemDiscard, false)
            BlzFrameSetEnable(SaveItemDrop, false)
        end
        bank.itemClicked = -1
    end

    local function SaveItemDiscardFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank:discardItem()
        if p == LocalPlayer then
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            UpdateItems()
            -- Disable
            BlzFrameSetEnable(SaveItemDiscard, false)
            BlzFrameSetEnable(SaveItemDrop, false)
        end
        bank.itemClicked = -1
    end

    local function SavedItemTFunc(p, i)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        if i <= bank.savedItemsStock then
            if p == LocalPlayer then
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
            if p == LocalPlayer then
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

    local function ExitItemFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank.wantItemSlot = false
        if p == LocalPlayer then
            BlzFrameSetVisible(BuySlotMenu, false)
            BlzFrameSetVisible(ItemMenu, false)
            BlzFrameSetVisible(SavedItemTSelected[bank.itemClicked], false)
            RemoveButtonFromEscStack(ExitItem)
            UpdateItems()
        end
        bank.itemClicked = -1
    end

    local function BuySlotYesFunc(p)
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

    local function BuySlotNoFunc(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(BuySlotMenu, false)
            if BlzFrameIsVisible(SavedDigimons) then
                UpdateSave()
            end
            if BlzFrameIsVisible(ItemMenu) then
                UpdateItems()
            end
        end
    end

    local function SwapFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank:sawpSave()
        if p == LocalPlayer then
            UpdateMenu()
            UpdateSave()
        end
    end

    local function PressedUsing(p, i)
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

    local function PressedSaved(p, i)
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
            if p == LocalPlayer then
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

    local function PressedActions(p, i)
        local bank = Bank[GetPlayerId(p)] ---@type Bank

        if p == LocalPlayer then
            -- Refresh the last pressed button
            BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            BlzFrameSetEnable(DigimonT[bank.pressed], true)
            -- Updates the new pressed button
            BlzFrameSetVisible(DigimonTSelected[i], true)
            BlzFrameSetEnable(DigimonT[i], false)
            -- Other changes
            if bank.stocked[i] then -- Error proof
                if bank.stocked[i]:isAlive() then
                    BlzFrameSetVisible(Revive, false)
                else
                    BlzFrameSetVisible(Revive, true)
                    BlzFrameSetVisible(Summon, false)
                    BlzFrameSetVisible(Store, false)
                end
            else
                BlzFrameSetVisible(Revive, false)
                BlzFrameSetVisible(Summon, true)
                BlzFrameSetVisible(Store, false)
            end
            if bank.inUse[i] then
                BlzFrameSetVisible(Summon, false)
                BlzFrameSetVisible(Store, true)
            else
                BlzFrameSetVisible(Summon, true)
                BlzFrameSetVisible(Store, false)
            end
        end

        if bank.stocked[i] then
            bank.pressed = i
        else
            bank.pressed = -1
        end

        if p == LocalPlayer then
            UpdateButtons()
        end
    end

    local function SummonADigimonFunc(p)
        local bank = Bank[GetPlayerId(p)]
        local oldPressed = bank.pressed
        bank.pressed = -1
        if p == LocalPlayer then
            if not BlzFrameIsVisible(StockedDigimonsMenu) then
                BlzFrameSetVisible(StockedDigimonsMenu, true)
                AddButtonToEscStack(SummonADigimon)
            else
                BlzFrameSetVisible(StockedDigimonsMenu, false)
                RemoveButtonFromEscStack(SummonADigimon)
            end
            BlzFrameSetVisible(DigimonTUsed[oldPressed], false)
            BlzFrameSetVisible(DigimonTSelected[oldPressed], false)
            UpdateMenu()
        end
    end

    local function SummonFunc(p)
        SummonDigimon(p, Bank[GetPlayerId(p)].pressed)
        if p == LocalPlayer then
            BlzFrameSetVisible(Summon, false)
            BlzFrameSetVisible(Store, true)
            UpdateButtons()
        end
    end

    local function StoreFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank:storeDigimon(bank.pressed, true)
        if p == LocalPlayer then
            BlzFrameSetVisible(Summon, true)
            BlzFrameSetVisible(Store, false)
            UpdateMenu()
        end
    end

    Timed.echo(1., function ()
        ForForce(FORCE_PLAYING, function ()
            local p = GetEnumPlayer()
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            if bank.reviveCooldown > 0 then
                bank.reviveCooldown = bank.reviveCooldown - 1.
                if p == LocalPlayer then
                    UpdateMenu()
                end
            end
        end)
    end)

    local function ReviveFunc(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank

        local d = bank.stocked[bank.pressed]
        d:revive(d:getPos())
        SetUnitLifePercentBJ(d.root, 5)
        SetUnitManaPercentBJ(d.root, 5)

        bank.reviveItems = bank.reviveItems - 1
        bank.reviveCooldown = REVIVE_COOLDOWN

        if bank.main then
            DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_1, bank.main:getPos()), 1.)
            DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_2, bank.main:getPos()), 1.)
        end
        if p == LocalPlayer then
            BlzFrameSetVisible(Revive, false)
            BlzFrameSetVisible(Summon, true)
            UpdateMenu()
        end
    end

    local function FreeFunc(p)
        if p == LocalPlayer then
            BlzFrameSetFocus(StockedDigimonsMenu, false)
            BlzFrameSetFocus(Warning, true)
            BlzFrameSetVisible(Warning, true)
            BlzFrameCageMouse(Warning, true)
        end
    end

    local function YesFunc(p)
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

    local function NoFunc(p)
        if p == LocalPlayer then
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
            ExitSaveFunc(p)
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
            ExitItemFunc(p)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == REVIVE_ITEM end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            bank.reviveItems = bank.reviveItems + 1
            if p == LocalPlayer then
                UpdateMenu()
            end
        end)
    end

    local function InitFrames()
        -- Bank
        local t = nil ---@type trigger

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        local part = MAX_STOCK // 4
        for i = 0, part - 1 do
            for j = 0, 3 do
                local index = i + part * j
                x1[index] = 0.020000 + i * 0.05
                y1[index] = -0.040000 - j * 0.05
                x2[index] = -0.070000 + i * 0.05
                y2[index] = 0.19000 - j * 0.05
            end
        end

        SummonADigimon = BlzCreateFrame("IconButtonTemplate", OriginFrame,0,0)
        AddButtonToTheRight(SummonADigimon, 0)
        SetFrameHotkey(SummonADigimon, "D")
        AddDefaultTooltip(SummonADigimon, "Your digimons", "Look your stored digimons.")
        AssignFrame(SummonADigimon, 20)

        BackdropSummonADigimon = BlzCreateFrameByType("BACKDROP", "BackdropSummonADigimon", SummonADigimon, "", 0)
        BlzFrameSetAllPoints(BackdropSummonADigimon, SummonADigimon)
        BlzFrameSetTexture(BackdropSummonADigimon, "ReplaceableTextures\\CommandButtons\\BTNDigi.blp", 0, true)

        OnClickEvent(SummonADigimon, SummonADigimonFunc)
        BlzFrameSetVisible(SummonADigimon, false)
        AddFrameToMenu(SummonADigimon)

        StockedDigimonsMenu = BlzCreateFrame("EscMenuBackdrop", OriginFrame,0,0)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, GetMinScreenX(), 0.44000)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, GetMinScreenX() + 0.13000, 0.17000)
        BlzFrameSetVisible(StockedDigimonsMenu, false)
        AddFrameToMenu(StockedDigimonsMenu)
        BlzFrameSetLevel(StockedDigimonsMenu, 20)

        local indexes = {[0] = 21, 22, 23, 24, 25, 26, 27, 28}

        for i = 0, MAX_STOCK - 1 do
            DigimonT[i] = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu, 0, 0)
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            BackdropDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT[" .. i .. "]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(BackdropDigimonT[i], DigimonT[i])
            BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            BlzFrameSetLevel(BackdropDigimonT[i], 1)
            OnClickEvent(DigimonT[i], function (p) PressedActions(p, i) end) -- :D
            AssignFrame(DigimonT[i], indexes[i])

            DigimonTUsed[i] = BlzCreateFrameByType("BACKDROP", "DigimonTUsed[" .. i .."]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(DigimonTUsed[i], DigimonT[i])
            BlzFrameSetTexture(DigimonTUsed[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(DigimonTUsed[i], 127)
            BlzFrameSetLevel(DigimonTUsed[i], 2)
            BlzFrameSetVisible(DigimonTUsed[i], false)

            DigimonTDead[i] = BlzCreateFrameByType("BACKDROP", "Dead[" .. i .."]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(DigimonTDead[i], DigimonT[i])
            BlzFrameSetTexture(DigimonTDead[i], "war3mapImported\\red.blp", 0, true)
            BlzFrameSetAlpha(DigimonTDead[i], 127)
            BlzFrameSetLevel(DigimonTDead[i], 3)
            BlzFrameSetVisible(DigimonTDead[i], false)

            DigimonTSelected[i] = BlzCreateFrameByType("BACKDROP", "Selected[" .. i .."]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(DigimonTSelected[i], DigimonT[i])
            BlzFrameSetTexture(DigimonTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(DigimonTSelected[i], 4)
            BlzFrameSetVisible(DigimonTSelected[i], false)

            DigimonTIsMain[i] = BlzCreateFrameByType("TEXT", "name", DigimonT[i], "", 0)
            BlzFrameSetScale(DigimonTIsMain[i], 1.5)
            BlzFrameSetPoint(DigimonTIsMain[i], FRAMEPOINT_TOPRIGHT, DigimonT[i], FRAMEPOINT_TOPRIGHT, 0.0000, 0.0000)
            BlzFrameSetPoint(DigimonTIsMain[i], FRAMEPOINT_BOTTOMLEFT, DigimonT[i], FRAMEPOINT_BOTTOMLEFT, -0.01, -0.01)
            BlzFrameSetText(DigimonTIsMain[i], "|cff00ff00§|r")
            BlzFrameSetEnable(DigimonTIsMain[i], false)
            BlzFrameSetTextAlignment(DigimonTIsMain[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_RIGHT)
            BlzFrameSetLevel(DigimonTIsMain[i], 3)
            BlzFrameSetVisible(DigimonTIsMain[i], false)

            DigimonTTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", DigimonT[i],0,0)

            DigimonTTooltipText[i] = BlzCreateFrameByType("TEXT", "DigimonTTooltipText[" .. i .."]", DigimonTTooltip[i], "", 0)
            BlzFrameSetScale(DigimonTTooltipText[i], 1.14)
            BlzFrameSetPoint(DigimonTTooltipText[i], FRAMEPOINT_BOTTOMLEFT, DigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(DigimonTTooltipText[i], "Empty slot")
            BlzFrameSetTextAlignment(DigimonTTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(DigimonTTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonTTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(DigimonT[i], DigimonTTooltip[i])
        end

        Text = BlzCreateFrameByType("TEXT", "name", StockedDigimonsMenu, "", 0)
        BlzFrameSetScale(Text, 1.00)
        BlzFrameSetPoint(Text, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.015000)
        BlzFrameSetPoint(Text, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.23500)
        BlzFrameSetText(Text, "|cffFFCC00Choose a Digimon|r")
        BlzFrameSetEnable(Text, false)
        BlzFrameSetTextAlignment(Text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Summon = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetScale(Summon, 0.80)
        BlzFrameSetPoint(Summon, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
        BlzFrameSetPoint(Summon, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.065000, 0.010000)
        BlzFrameSetText(Summon, "|cffFCD20DSummon|r")
        OnClickEvent(Summon, SummonFunc)
        AssignFrame(Summon, 29)

        Store = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetScale(Store, 0.80)
        BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
        BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.065000, 0.010000)
        BlzFrameSetText(Store, "|cffFCD20DStore|r")
        BlzFrameSetVisible(Store, false)
        OnClickEvent(Store, StoreFunc)
        AssignFrame(Store, 30)

        Revive = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetScale(Revive, 0.80)
        BlzFrameSetPoint(Revive, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
        BlzFrameSetPoint(Revive, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.065000, 0.010000)
        BlzFrameSetText(Revive, "|cffFCD20DRevive|r")
        BlzFrameSetVisible(Revive, false)
        OnClickEvent(Revive, ReviveFunc)
        AssignFrame(Revive, 42)

        Free = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetScale(Free, 0.80)
        BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.065000, -0.23500)
        BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.010000)
        BlzFrameSetText(Free, "|cffFCD20DFree|r")
        BlzFrameSetEnable(Free, false)
        OnClickEvent(Free, FreeFunc)
        AssignFrame(Free, 31)

        Warning = BlzCreateFrame("QuestButtonBaseTemplate", Free,0,0)
        BlzFrameSetPoint(Warning, FRAMEPOINT_TOPLEFT, Free, FRAMEPOINT_TOPLEFT, -0.020000, 0.025000)
        BlzFrameSetPoint(Warning, FRAMEPOINT_BOTTOMRIGHT, Free, FRAMEPOINT_BOTTOMRIGHT, 0.030000, -0.010000)
        BlzFrameSetVisible(Warning, false)

        AreYouSure = BlzCreateFrameByType("TEXT", "name", Warning, "", 0)
        BlzFrameSetScale(AreYouSure, 1.00)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.025000)
        BlzFrameSetText(AreYouSure, "|cffFFCC00Are you sure you wanna free this digimon?|r")
        BlzFrameSetEnable(AreYouSure, false)
        BlzFrameSetTextAlignment(AreYouSure, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Yes = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetScale(Yes, 1.00)
        BlzFrameSetPoint(Yes, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.010000, -0.035000)
        BlzFrameSetPoint(Yes, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.0050000)
        BlzFrameSetText(Yes, "|cffFCD20DYes|r")
        OnClickEvent(Yes, YesFunc)
        AssignFrame(Yes, 32)

        No = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetScale(No, 1.00)
        BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
        BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
        BlzFrameSetText(No, "|cffFCD20DNo|r")
        OnClickEvent(No, NoFunc)
        AssignFrame(No, 33)

        ReviveItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", StockedDigimonsMenu, "", 1)
        BlzFrameSetPoint(ReviveItems, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.23250)
        BlzFrameSetPoint(ReviveItems, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.030000, 0.0075000)
        BlzFrameSetTexture(ReviveItems, "ReplaceableTextures\\CommandButtons\\BTNHealButton.blp", 0, true)
        BlzFrameSetVisible(ReviveItems, false)

        ReviveItemsChargesBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", ReviveItems, "", 1)
        BlzFrameSetPoint(ReviveItemsChargesBackdrop, FRAMEPOINT_TOPLEFT, ReviveItems, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(ReviveItemsChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, ReviveItems, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
        BlzFrameSetTexture(ReviveItemsChargesBackdrop, "UI\\Widgets\\EscMenu\\Human\\blank-background.blp", 0, true)

        ReviveItemsCharges = BlzCreateFrameByType("TEXT", "name", ReviveItemsChargesBackdrop, "", 0)
        BlzFrameSetPoint(ReviveItemsCharges, FRAMEPOINT_TOPLEFT, ReviveItemsChargesBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        BlzFrameSetPoint(ReviveItemsCharges, FRAMEPOINT_BOTTOMRIGHT, ReviveItemsChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0010000, 0.0000)
        BlzFrameSetText(ReviveItemsCharges, "99")
        BlzFrameSetTextAlignment(ReviveItemsCharges, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

        -- Saved

        --[[SaveItem = BlzCreateFrame("IconButtonTemplate", OriginFrame, 0, 0)
        AddButtonToTheRight(SaveItem, 6)
        SetFrameHotkey(SaveItem, "C")
        AddDefaultTooltip(SaveItem, "Save item", "Saves the selected item in the bank (you have to go to the bank to see it).")
        AddFrameToMenu(SaveItem)
        BlzFrameSetVisible(SaveItem, false)

        BackdropSaveItem = BlzCreateFrameByType("BACKDROP", "BackdropSaveItem", SaveItem, "", 0)
        BlzFrameSetAllPoints(BackdropSaveItem, SaveItem)
        BlzFrameSetTexture(BackdropSaveItem, "ReplaceableTextures\\CommandButtons\\BTNStore.blp", 0, true)
        OnClickEvent(SaveItem, function (p) UseCaster(p, "Z") end)]]

        SavedDigimons = BlzCreateFrame("EscMenuBackdrop", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_TOPLEFT, 0.195000, 0.510000)
        BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, 0.605000, 0.180000)
        BlzFrameSetVisible(SavedDigimons, false)
        AddFrameToMenu(SavedDigimons)

        Using = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
        BlzFrameSetScale(Using, 1.29)
        BlzFrameSetPoint(Using, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.030000)
        BlzFrameSetPoint(Using, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.27500, 0.28000)
        BlzFrameSetText(Using, "|cffFFCC00Using|r")
        BlzFrameSetEnable(Using, false)
        BlzFrameSetTextAlignment(Using, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        part = MAX_STOCK // 2
        for i = 0, part - 1 do
            for j = 0, 1 do
                local index = i + part * j
                x1[index] = 0.035000 + j * 0.05000
                y1[index] = -0.070000 - i * 0.05000
                x2[index] = -0.32500 + j * 0.05000
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

            OnClickEvent(UsingDigimonT[i], function (p) PressedUsing(p, i) end)

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
            BlzFrameSetScale(UsingTCooldownT[i], 2.14)
            BlzFrameSetAllPoints(UsingTCooldownT[i], UsingDigimonT[i])
            BlzFrameSetText(UsingTCooldownT[i], "60")
            BlzFrameSetEnable(UsingTCooldownT[i], false)
            BlzFrameSetTextAlignment(UsingTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(UsingTCooldownT[i], 4)
            BlzFrameSetVisible(UsingTCooldownT[i], false)

            UsingTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", UsingDigimonT[i],0,0)

            UsingTooltipText[i] = BlzCreateFrameByType("TEXT", "UsingTooltipText[" .. i .."]", UsingTooltip[i], "", 0)
            BlzFrameSetScale(UsingTooltipText[i], 1.14)
            BlzFrameSetPoint(UsingTooltipText[i], FRAMEPOINT_BOTTOMLEFT, UsingDigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(UsingTooltipText[i], "Empty slot")
            BlzFrameSetTextAlignment(UsingTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(UsingTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_TOPLEFT, UsingTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(UsingTooltip[i], FRAMEPOINT_BOTTOMRIGHT, UsingTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(UsingDigimonT[i], UsingTooltip[i])
        end

        Saved = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
        BlzFrameSetScale(Saved, 1.29)
        BlzFrameSetPoint(Saved, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.22500, -0.030000)
        BlzFrameSetPoint(Saved, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.28000)
        BlzFrameSetText(Saved, "|cffFFCC00Saved|r")
        BlzFrameSetEnable(Saved, false)
        BlzFrameSetTextAlignment(Saved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        part = MAX_SAVED // 4
        for i = 0, part - 1 do
            for j = 0, 3 do
                local index = i + part * j
                x1[index] = 0.17500 + j * 0.05000
                y1[index] = -0.070000 - i * 0.05000
                x2[index] = -0.18500 + j * 0.05000
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

            OnClickEvent(SavedDigimonT[i], function (p) PressedSaved(p, i) end)

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

            SavedTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", SavedDigimonT[i],0,0)

            SavedTooltipText[i] = BlzCreateFrameByType("TEXT", "SavedTooltipText[" .. i .."]", SavedTooltip[i], "", 0)
            BlzFrameSetScale(SavedTooltipText[i], 1.14)
            BlzFrameSetPoint(SavedTooltipText[i], FRAMEPOINT_BOTTOMLEFT, SavedDigimonT[i], FRAMEPOINT_BOTTOMLEFT, 0.025000, 0.025000)
            BlzFrameSetText(SavedTooltipText[i], "Empty slot")
            BlzFrameSetTextAlignment(SavedTooltipText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(SavedTooltipText[i], 0, 0.005)

            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_TOPLEFT, SavedTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(SavedTooltip[i], FRAMEPOINT_BOTTOMRIGHT, SavedTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            BlzFrameSetTooltip(SavedDigimonT[i], SavedTooltip[i])
        end

        Swap = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
        BlzFrameSetScale(Swap, 1.29)
        BlzFrameSetPoint(Swap, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.16000, -0.28000)
        BlzFrameSetPoint(Swap, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.17000, 0.020000)
        BlzFrameSetText(Swap, "|cffFCD20DSwap|r")
        BlzFrameSetEnable(Swap, false)
        OnClickEvent(Swap, SwapFunc)

        ExitSave = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
        BlzFrameSetScale(ExitSave, 1.00)
        BlzFrameSetPoint(ExitSave, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.37500, -0.0050000)
        BlzFrameSetPoint(ExitSave, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.30000)
        BlzFrameSetText(ExitSave, "|cffFCD20DX|r")
        OnClickEvent(ExitSave, ExitSaveFunc)

        -- Item

        ItemMenu = BlzCreateFrame("EscMenuBackdrop", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_TOPLEFT, 0.210000, 0.500000)
        BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_BOTTOMRIGHT, 0.570000, 0.200000)
        BlzFrameSetVisible(ItemMenu, false)

        ExitItem = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetScale(ExitItem, 1.00)
        BlzFrameSetPoint(ExitItem, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.33000, -0.0050000)
        BlzFrameSetPoint(ExitItem, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.27000)
        BlzFrameSetText(ExitItem, "|cffFCD20DX|r")
        OnClickEvent(ExitItem, ExitItemFunc)

        SaveItemDrop = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetScale(SaveItemDrop, 1.00)
        BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.25000)
        BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.19000, 0.020000)
        BlzFrameSetText(SaveItemDrop, "|cffFCD20DDrop|r")
        OnClickEvent(SaveItemDrop, SaveItemDropFunc)

        SaveItemDiscard = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
        BlzFrameSetScale(SaveItemDiscard, 1.00)
        BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.19000, -0.25000)
        BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.020000)
        BlzFrameSetText(SaveItemDiscard, "|cffFCD20DDiscard|r")
        OnClickEvent(SaveItemDiscard, SaveItemDiscardFunc)

        part = MAX_SAVED_ITEMS // 6
        for i = 0, part - 1 do
            for j = 0, 5 do
                local index = i + part * j + 1
                x1[index] = 0.030000 + j * 0.05
                y1[index] = -0.040000 - i * 0.05
                x2[index] = -0.28000 + j * 0.05
                y2[index] = 0.21000 - i * 0.05
            end
        end

        for i = 1, MAX_SAVED_ITEMS do
            SavedItemT[i] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
            BlzFrameSetPoint(SavedItemT[i], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(SavedItemT[i], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])

            BackdropSavedItemT[i] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[" .. i .. "]", SavedItemT[i], "", 0)
            BlzFrameSetAllPoints(BackdropSavedItemT[i], SavedItemT[i])
            BlzFrameSetTexture(BackdropSavedItemT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            OnClickEvent(SavedItemT[i], function (p) SavedItemTFunc(p, i) end)

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

        BuySlotMenu = BlzCreateFrame("QuestButtonBaseTemplate", OriginFrame, 0, 0)
        BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.300000, 0.420000)
        BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, 0.480000, 0.300000)
        BlzFrameSetVisible(BuySlotMenu, false)

        BuySlotMessage = BlzCreateFrameByType("TEXT", "name", BuySlotMenu, "", 0)
        BlzFrameSetScale(BuySlotMessage, 1.43)
        BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.035000)
        BlzFrameSetText(BuySlotMessage, "|cffffffffDo you want to buy a new item slot for 0 digibits?|r")
        BlzFrameSetEnable(BuySlotMessage, false)
        BlzFrameSetTextAlignment(BuySlotMessage, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        BuySlotYes = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
        BlzFrameSetScale(BuySlotYes, 1.00)
        BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.025000, -0.087500)
        BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10500, 0.0025000)
        BlzFrameSetText(BuySlotYes, "|cffFCD20DYes|r")
        OnClickEvent(BuySlotYes, BuySlotYesFunc)

        BuySlotNo = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
        BlzFrameSetScale(BuySlotNo, 1.00)
        BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.10500, -0.087500)
        BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.0025000)
        BlzFrameSetText(BuySlotNo, "|cffFCD20DNo|r")
        OnClickEvent(BuySlotNo, BuySlotNoFunc)

        --[[SellItem = BlzCreateFrame("IconButtonTemplate", OriginFrame, 0, 0)
        AddButtonToTheRight(SellItem, 4)
        SetFrameHotkey(SellItem, "F")
        AddDefaultTooltip(SellItem, "Sell item", "Sells the selected item of yours.")
        AddFrameToMenu(SellItem)
        BlzFrameSetVisible(SellItem, false)

        BackdropSellItem = BlzCreateFrameByType("BACKDROP", "BackdropSellItem", SellItem, "", 0)
        BlzFrameSetAllPoints(BackdropSellItem, SellItem)
        BlzFrameSetTexture(BackdropSellItem, "ReplaceableTextures\\CommandButtons\\BTNSell.blp", 0, true)
        OnClickEvent(SellItem, function (p) UseCaster(p, "A") end)]]
    end

    FrameLoaderAdd(InitFrames)

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(StockedDigimonsMenu)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, GetMinScreenX(), 0.430000)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, GetMinScreenX() + 0.130000, 0.160000)
    end)

    OnLeaderboard(function ()
        --BlzFrameSetParent(StockedDigimonsMenu, BlzGetFrameByName("Leaderboard", 0))
        BlzFrameSetParent(SavedDigimons, BlzGetFrameByName("Leaderboard", 0))
        BlzFrameSetParent(ItemMenu, BlzGetFrameByName("Leaderboard", 0))
        BlzFrameSetParent(BuySlotMenu, BlzGetFrameByName("Leaderboard", 0))
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

        if not bank:isStocked(d) then
            for i = 0, MAX_STOCK - 1 do
                if not bank.stocked[i] then
                    bank.stocked[i] = d
                    index = i
                    break
                end
            end
        else
            index = GetBankIndex(p, d)
        end

        d.owner = p
        d:setOwner(Digimon.PASSIVE)
        d:hideInTheCorner()
        if bank.main == d then
            bank:searchMain()
        end

        digimonUpdateEvent:run(p, d)

        if p == LocalPlayer then
            SelectUnit(d.root, false)
            UpdateMenu()
        end
        return index
    end

    ---@param p player
    ---@param d Digimon
    ---@param hide boolean
    ---@return boolean
    function StoreToBank(p, d, hide)
        local result = Bank[GetPlayerId(p)]:storeDigimon(GetBankIndex(p, d), hide)

        if p == LocalPlayer then
            UpdateMenu()
        end

        return result
    end

    ---@param p player
    ---@param hide boolean
    ---@param except Digimon?
    function StoreAllDigimons(p, hide, except)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        for i = #bank.priorities, 1, -1 do
            if bank.priorities[i] ~= except then
                StoreToBank(p, bank.priorities[i], hide)
            end
        end
    end

    ---@param p player
    ---@param index integer
    ---@param holdEnv boolean?
    ---@return boolean
    function SummonDigimon(p, index, holdEnv)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        if bank:used() >= bank.maxUsable then
            return false
        end

        --[[if index == 1 then
            local count = 0
            Timed.echo(0.02, function ()
                count = count + 0.02
                print(count)
                if count > 0.4 then
                    return true
                end
            end)
        end]]

        local d = bank.stocked[index] ---@type Digimon
        local b = false

        if d then
            d:setOwner(p)

            --[[local orders = GetHeroButtonPos(p)
            local syncedOrders = GetSyncedData(p, function ()
                return orders
            end)
            while true do
                if not table.remove(bank.priorities) then
                    break
                end
            end
            for i = 0, MAX_STOCK - 1 do
                if syncedOrders[i] then
                    table.insert(bank.priorities, Digimon.getInstance(syncedOrders[i]))
                end
            end]]
            local noAdded = true
            for i = 1, #bank.priorities do
                if bank.priorities[i] == d then
                    noAdded = false
                    break
                end
            end
            if noAdded then
                table.insert(bank.priorities, d)
            end
            for i = 1, #bank.priorities do
                BlzSetUnitRealField(bank.priorities[i].root, UNIT_RF_PRIORITY, MAX_STOCK - i)
            end
            if not bank.main or bank.main == d then
                bank.main = d
                d:showFromTheCorner(bank.spawnPoint.x, bank.spawnPoint.y)
                if not holdEnv then
                    if d.environment:apply(p, false) and p == LocalPlayer then
                        PanCameraToTimed(bank.spawnPoint.x, bank.spawnPoint.y, 0)
                    end
                end
            else
                d:showFromTheCorner(bank.main:getX(), bank.main:getY())
                d.environment = bank.main.environment
            end
            bank.inUse[index] = d
            b = true
        end
        if p == LocalPlayer then
            if d then
                SelectUnit(d.root, true)
            end
            UpdateMenu()
        end
        if d then
            digimonUpdateEvent:run(p, d)
        end
        Timed.call(function ()
            local count = 0
            ForUnitsOfPlayer(p, function (u)
                if IsUnitType(u, UNIT_TYPE_HERO) then
                    count = count + 1
                end
            end)
            if count > MAX_USED then
                DisplayTextToPlayer(p, 0, 0, "|cffff0000Warning:|r You are using more digimons than the " .. MAX_USED .. " allowed, so to prevent further bugs your digimons will be 'outlived'.\n We recommend to reload or restart the game and report it to the Discord server.")
                ForUnitsOfPlayer(p, function (u)
                    if IsUnitType(u, UNIT_TYPE_HERO) and not IsMainDigimon(p, Digimon.getInstance(u)) then
                        KillUnit(u)
                    end
                end)
            end
        end)
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
            d:setOwner(Digimon.PASSIVE)
            for i = 0, 5 do
                local m = UnitItemInSlot(d.root, i)
                if m then
                    UnitRemoveItem(d.root, m)
                end
            end
            if bank.inUse[index] then
                bank.inUse[index] = nil
                for i = #bank.priorities, 1, -1 do
                    if bank.priorities[i] == d then
                        table.remove(bank.priorities, i)
                        break
                    else
                        BlzSetUnitRealField(bank.priorities[i].root, UNIT_RF_PRIORITY, MAX_STOCK - i + 1)
                    end
                end
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

            digimonUpdateEvent:run(p, d)
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
    local isDead = __jarray(false) ---@type table<unit, boolean>

    local oldUnitAlive
    oldUnitAlive = AddHook("UnitAlive", function (u)
        if isDead[u] then
            return false
        end
        return oldUnitAlive(u)
    end)

    local oldReviveHero
    oldReviveHero = AddHook("ReviveHero", function (whichHero, x, y, doEyecandy)
        isDead[whichHero] = false
        return oldReviveHero(whichHero, x, y, doEyecandy)
    end)

    local oldReviveHeroLoc
    oldReviveHeroLoc = AddHook("ReviveHeroLoc", function (whichHero, loc, doEyecandy)
        isDead[whichHero] = false
        return oldReviveHeroLoc(whichHero, loc, doEyecandy)
    end)

    Digimon.killEvent:register(function (info)
        local dead = info.target ---@type Digimon
        local p = dead:getOwner()
        if not Digimon.isNeutral(p) then
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            local allDead = true
            local index = -1
            local deads = 0
            for i = 0, MAX_STOCK - 1 do
                local d = bank.stocked[i]
                if d then
                    if dead == d then
                        index = i
                    end
                    if not d:isAlive() then
                        deads = deads + 1
                    else
                        allDead = false
                    end
                end
            end

            Timed.call(function () dead:setOwner(Digimon.PASSIVE) end)
            -- Hide after 2 seconds to not do it automatically
            Timed.call(2., function ()
                dead:hideInTheCorner()
                -- Hero gets deleted if there are more than 7 dead heros
                isDead[dead.root] = true
                oldReviveHero(dead.root, dead:getX(), dead:getY(), false)
            end)

            if index == -1 then
                return
            end

            bank.allDead = allDead

            bank:storeDigimon(index, false)

            if p == LocalPlayer then
                UpdateMenu()
            end

            -- If all the digimons died then the spawnpoint will be the clinic
            if allDead then
                DisplayTextToPlayer(p, 0, 0, "All your digimons are death, they will respawn in the clinic")

                if bank.punish then
                    SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, math.floor(0.95 * GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)))
                end

                bank.spawnPoint.x = GetRectCenterX(gg_rct_Hospital)
                bank.spawnPoint.y = GetRectCenterY(gg_rct_Hospital)

                TimerStart(bank.allDeadTimer, 15., false, function ()
                    if p == LocalPlayer then
                        TimerDialogDisplay(bank.allDeadWindow, false)
                    end
                end)
                if p == LocalPlayer then
                    TimerDialogDisplay(bank.allDeadWindow, true)
                end

                Timed.echo(1., 15., function ()
                    for _, d in ipairs(bank.priorities) do
                        if d:isAlive() and not d:isHidden() then
                            bank.allDead = false
                            PauseTimer(bank.allDeadTimer)
                            TimerDialogDisplay(bank.allDeadWindow, false)
                            return true
                        end
                    end
                end, function ()
                    if dead:getTypeId() == 0 then
                        return
                    end
                    bank.spawnPoint.x = GetRectCenterX(gg_rct_Hospital)
                    bank.spawnPoint.y = GetRectCenterY(gg_rct_Hospital)
                    for i = 0, MAX_STOCK - 1 do
                        local d = bank.stocked[i]
                        if d then
                            d.environment = Environment.hospital
                            ReviveHero(d.root, d:getX(), d:getY(), false)
                            SetUnitLifePercentBJ(d.root, 5)
                        end
                    end
                    SummonDigimon(p, index)
                    DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_1, dead:getPos()), 1.)
                    DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_2, dead:getPos()), 1.)
                    bank.allDead = false
                end)
            else
                bank.spawnPoint.x = GetRectCenterX(gg_rct_Player_1_Spawn)
                bank.spawnPoint.y = GetRectCenterY(gg_rct_Player_1_Spawn)
            end
        end
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, CENTAURMON, EVENT_UNIT_SELL_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetSoldItem()) == REVIVE_DIGIMONS end))
        TriggerAddAction(t, function ()
            local u = GetBuyingUnit()
            local p = GetOwningPlayer(u)
            local bank = Bank[GetPlayerId(p)] ---@type Bank
            local noDead = true

            for i = 0, MAX_STOCK - 1 do
                local d = bank.stocked[i]
                if d and not d:isAlive() then
                    noDead = false
                    d:revive(d:getPos())
                end
            end

            if noDead then
                udg_TalkId = udg_ReviveDigimonsTalk
                udg_TalkTo = u
                udg_TalkToForce = Force(p)
                TriggerExecute(udg_TalkRun)
            else
                DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_1, GetUnitX(CENTAURMON), GetUnitY(CENTAURMON)), 1.)
                DestroyEffectTimed(AddSpecialEffect(CENTAURMON_REVIVE_EFF_2, GetUnitX(CENTAURMON), GetUnitY(CENTAURMON)), 1.)
            end

            if p == LocalPlayer then
                UpdateMenu()
            end
        end)
    end

    ---@param p player
    ---@param flag boolean
    function PunishPlayer(p, flag)
        Bank[GetPlayerId(p)].punish = flag
    end

    ---@param p player
    ---@return Digimon[]
    function GetUsedDigimons(p)
        return Bank[GetPlayerId(p)].priorities
    end

    ---@param p player
    ---@return integer
    function GetUsedDigimonCount(p)
        return Bank[GetPlayerId(p)]:used()
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

    --[[---@param p player
    ---@param flag boolean
    function ShowSellItem(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SellItem, flag)
        end
    end

    ---@param p player
    ---@param flag boolean
    function ShowSaveItem(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SaveItem, flag)
        end
    end]]

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
    function CanStockDigimons(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            if not bank.stocked[i] then
                return true
            end
        end
        return false
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
    ---@return boolean
    function SearchNewMainDigimon(p)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local prevMain = bank.main

        if prevMain then
            for i = 0, MAX_STOCK - 1 do
                if bank.inUse[i] and prevMain ~= bank.inUse[i] then
                    bank.main = bank.inUse[i]
                    return true
                end
            end
        end

        return false
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
        for _, d in ipairs(bank.priorities) do
            stucked = stucked and d:isPaused()
        end
        return stucked
    end

    ---@param p player
    ---@param u unit | Digimon
    function AddToBank(p, u)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = (Debug.wc3Type(u) == "unit") and Digimon.getInstance(u) or u
        if d and not bank:isStocked(d) then
            if bank:used() >= MAX_USED then
                SendToBank(p, d)
            else
                for i = 0, MAX_STOCK - 1 do
                    if not bank.stocked[i] then
                        bank.stocked[i] = d
                        bank.inUse[i] = d
                        table.insert(bank.priorities, d)
                        d.owner = p
                        if not bank.main then
                            bank:searchMain()
                        end
                        break
                    end
                end
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    -- Replace if for whatever reason a player hero gets deleted
    --[[OnUnitLeave(function (u)
        local d = Digimon.getInstance(u)
        if d and d.owner and IsPlayerInGame(d.owner) then
            ShowUnitHide(u)
            local new = CreateUnit(d.owner, GetUnitTypeId(u), GetUnitX(u), GetUnitY(u), GetUnitFacing(u))
            d.root = new
            d:setExp(GetHeroXP(u))
            d:setIV(d.IVsta, d.IVdex, d.IVwis)
            for i = 0, 5 do
                local m = UnitItemInSlot(u, i)
                if m then
                    UnitRemoveItem(u, m)
                    UnitAddItem(new, m)
                    UnitDropItemSlot(new, m, i)
                end
            end
            for _ = 1, GetUnitAbilityLevel(u, udg_STAMINA_TRAINING) do
                SelectHeroSkill(new, udg_STAMINA_TRAINING)
            end
            for _ = 1, GetUnitAbilityLevel(u, udg_STAMINA_TRAINING) do
                SelectHeroSkill(new, udg_DEXTERITY_TRAINING)
            end
            for _ = 1, GetUnitAbilityLevel(u, udg_STAMINA_TRAINING) do
                SelectHeroSkill(new, udg_WISDOM_TRAINING)
            end
            for _, id in ipairs(d.cosmetics) do
                ApplyCosmetic(d.owner, id, d)
            end
        end
    end)]]

    GlobalRemap("udg_AddToBank", nil, function (value)
        AddToBank(Player(0), value)
    end)

    ---@param func fun(p: player, d: Digimon)
    function OnBankUpdated(func)
        digimonUpdateEvent:register(func)
    end

    ---If n is ausent, just set the default value
    ---@param p player
    ---@param n integer?
    function SetMaxUsableDigimons(p, n)
        Bank[GetPlayerId(p)].maxUsable = n or MAX_USED
    end

    ---@param owner player
    ---@return Digimon[]
    function GetAllDigimons(owner)
        local bank = Bank[GetPlayerId(owner)] ---@type Bank
        local list = {}
        for i = 0, MAX_STOCK - 1 do
            if bank.stocked[i] then
                table.insert(list, bank.stocked[i])
            end
        end
        for i = 0, bank.savedDigimonsStock - 1 do
            if bank.saved[i] then
                table.insert(list, bank.saved[i])
            end
        end
        return list
    end

    ---@param owner player
    ---@return integer
    function GetAllDigimonCount(owner)
        local bank = Bank[GetPlayerId(owner)] ---@type Bank
        local count = 0
        for i = 0, MAX_STOCK - 1 do
            if bank.stocked[i] then
                count = count + 1
            end
        end
        for i = 0, bank.savedDigimonsStock - 1 do
            if bank.saved[i] then
                count = count + 1
            end
        end
        return count
    end

    ---@param owner player
    ---@param d Digimon
    ---@return integer
    function GetDigimonPosition(owner, d)
        local bank = Bank[GetPlayerId(owner)] ---@type Bank
        for i = 1, #bank.priorities do
            if bank.priorities[i] == d then
                return i
            end
        end
        return -1
    end

    ---@param p player
    ---@param slot integer
    ---@return BankData
    function SaveDigimons(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_DIGIMON_BANK_ROOT)
        local data = BankData.create(Bank[GetPlayerId(p)], slot)
        local code = EncodeString(p, data:serialize())

        if p == LocalPlayer then
            FileIO.Write(fileRoot, code)
        end

        return data
    end

    ---@param p player
    ---@param slot integer
    ---@return BankData?
    function LoadDigimons(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_DIGIMON_BANK_ROOT)
        local data = BankData.create(slot)
        local code = GetSyncedData(p, FileIO.Read, fileRoot)

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode or not xpcall(data.deserialize, print, data, decode) then
                DisplayTextToPlayer(p, 0, 0, "The file " .. fileRoot .. " has invalid data.")
                return
            end
        end

        return data
    end

    ---@param p player
    ---@param data BankData
    function SetBank(p, data)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        bank:clearDigimons()
        bank:clearItems()

        for i = 0, MAX_STOCK - 1 do
            if data.stocked[i] then
                local d = Digimon.recreate(p, data.stocked[i])
                bank.stocked[i] = d
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
                digimonUpdateEvent:run(p, d)
            end
        end

        bank.savedDigimonsStock = data.maxSaved
        for i = 0, bank.savedDigimonsStock - 1 do
            if data.saved[i] then
                local d = Digimon.recreate(p, data.saved[i])
                bank.saved[i] = d
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
            end
        end

        bank.savedItemsStock = data.sItmsSto
        for i = 1, bank.savedItemsStock do
            if data.sItms[i] then
                local m = CreateItem(data.sItms[i], WorldBounds.maxX, WorldBounds.maxY)
                SetItemCharges(m, data.sItmsCha[i])
                bank:saveItem(m)
            end
        end

        bank.reviveItems = data.rItms
        bank.reviveCooldown = data.rCd

        if p == LocalPlayer then
            UpdateMenu()
            UpdateItems()
        end
    end

    --[=[
    ---@async
    ---Returns a table with indices from 0 to 2 with their respective hero if it exists, based on the hero button positions
    ---@param p player
    ---@return table<0|1|2, unit>
    function GetHeroButtonPos(p)
        local orders = {} ---@type table<0|1|2, unit>

        local heros = {} ---@type unit[]
        ForUnitsOfPlayer(p, function (u)
            if IsUnitType(u, UNIT_TYPE_HERO) then
                table.insert(heros, u)
            end
        end)

        -- To prevent crashes
        --[[for i = 0, #heros - 1 do
            if BlzFrameGetChildrenCount(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)) < 3 then
                return orders
            end
        end]]

        if #heros == 1 then -- The only 1
            if p == LocalPlayer then
                orders[0] = heros[1]
            end
        elseif #heros > 1 then
            local prevSkillPoints = __jarray(0) ---@type table<unit, integer>
            for i = 1, #heros do
                prevSkillPoints[heros[i]] = GetHeroSkillPoints(heros[i])
                UnitModifySkillPoints(heros[i], -prevSkillPoints[heros[i]])
            end

            if #heros == 2 then -- Check who has it visible or not
                UnitModifySkillPoints(heros[1], 1)

                if p == LocalPlayer then
                    if BlzFrameIsVisible(BlzFrameGetChild(heroGlows[0], 2)) then
                        orders[0] = heros[1]
                        orders[1] = heros[2]
                    else
                        orders[0] = heros[2]
                        orders[1] = heros[1]
                    end
                end

                UnitModifySkillPoints(heros[1], -1)
            elseif #heros == 3 then -- Make visible 2 and check who is the other one
                local indices = {0, 1, 2}

                UnitModifySkillPoints(heros[1], 1)
                UnitModifySkillPoints(heros[2], 1)

                local noVisible = -1

                if p == LocalPlayer then
                    for i = 0, 2 do
                        if not BlzFrameIsVisible(BlzFrameGetChild(heroGlows[i], 2)) then
                            noVisible = i
                        end
                    end

                    orders[noVisible] = heros[3]

                    for i = 3, 1, -1 do
                        if indices[i] == noVisible then
                            table.remove(indices, i)
                            break
                        end
                    end
                end

                -- Now repeat the same process of 2 with the rest of them
                UnitModifySkillPoints(heros[2], -1)

                local visible = -1

                if p == LocalPlayer then
                    for i = 1, 2 do
                        if not BlzFrameIsVisible(BlzFrameGetChild(heroGlows[indices[i]], 2)) then
                            noVisible = indices[i]
                        else
                            visible = indices[i]
                        end
                    end

                    orders[visible] = heros[1]
                    orders[noVisible] = heros[2]
                end

                UnitModifySkillPoints(heros[1], -1)
            end

            for i = 1, #heros do
                UnitModifySkillPoints(heros[i], prevSkillPoints[heros[i]])
            end
        end

        return orders
    end]=]
end)
Debug.endFile()