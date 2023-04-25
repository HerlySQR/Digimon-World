Debug.beginFile("DigimonBank")
OnInit("DigimonBank", function ()
    Require "PlayerDigimons"
    Require "AFK"
    Require "Menu"

    local MAX_STOCK = udg_MAX_DIGIMONS
    local MAX_SAVED = udg_MAX_SAVED_DIGIMONS

    ---@class Bank
    ---@field stocked Digimon[]
    ---@field inUse Digimon[]
    ---@field saved Digimon[]
    ---@field pressed integer
    ---@field usingClicked integer
    ---@field savedClicked integer
    ---@field p player
    ---@field main Digimon
    ---@field spawnPoint Vec2
    ---@field allDead boolean
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
            p = Player(i),
            main = nil,
            spawnPoint = {
                x = GetRectCenterX(gg_rct_Player_1_Spawn),
                y = GetRectCenterY(gg_rct_Player_1_Spawn)
            },
            allDead = false
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
        return GetDigimonCooldown(self.stocked[self.pressed]) <= 0 and self:used() < 3
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
        for i = 0, MAX_SAVED - 1 do
            if not self.saved[i] then
                self.saved[i] = d
                d.saved = true
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

    -- Store all the digimon in case of AFK
    AFKEvent:register(function (p)
        local bank = Bank[GetPlayerId(p)]
        for i = 0, MAX_STOCK - 1 do
            bank:storeDigimon(i, true)
        end
        DisplayTextToPlayer(LocalPlayer, 0, 0, GetPlayerName(p) .. " was afk for too long, all its digimons were stored.")
    end)

    -- Bank
    local SummonADigimon = nil ---@type framehandle
    local StockedDigimonsMenu = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local DigimonT = {} ---@type framehandle[]
    local BackdropDigimonT = {} ---@type framehandle[]
    local DigimonTUsed = {} ---@type framehandle[]
    local DigimonTSelected = {} ---@type framehandle[]
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
    local Saved = nil ---@type framehandle
    local SavedDigimonT = {} ---@type framehandle[]
    local BackdropSavedDigimonT = {} ---@type framehandle[]
    local SavedTSelected = {} ---@type framehandle[]
    local SavedTCooldownT = {} ---@type framehandle[]
    local Swap = nil ---@type framehandle
    local ExitSave = nil ---@type framehandle

    local SEE_SAVED_DIGIMONS = FourCC('I03U')

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateCooldowns()
        local bank = Bank[GetPlayerId(LocalPlayer)] ---@type Bank
        for i = 0, MAX_STOCK - 1 do
            local d = bank.stocked[i] ---@type Digimon
            if d and cooldowns[d] >= 0 then
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
            else
                -- Button
                BlzFrameSetEnable(UsingDigimonT[i], not BlzFrameIsVisible(UsingTSelected[i]))
                BlzFrameSetTexture(BackdropUsingDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            end
        end
        for i = 0, MAX_SAVED - 1 do
            local d = bank.saved[i] ---@type Digimon
            if d then
                local id = d:getTypeId()
                -- Button
                BlzFrameSetTexture(BackdropSavedDigimonT[i], BlzGetAbilityIcon(id), 0, true)
            else
                -- Button
                BlzFrameSetEnable(SavedDigimonT[i], false)
                BlzFrameSetTexture(BackdropSavedDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            end
            BlzFrameSetEnable(SavedDigimonT[i], not BlzFrameIsVisible(SavedTSelected[i]))
        end
    end

    local function ExitSaveFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())] ---@type Bank
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SavedDigimons, false)
            BlzFrameSetVisible(UsingTSelected[bank.usingClicked], false)
            BlzFrameSetVisible(SavedTSelected[bank.savedClicked], false)
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
                local text = GetHeroProperName(d.root) .. "\n\n" .. BlzGetAbilityExtendedTooltip(id, 0) .. "\n\n"
                if bank.inUse[i] then
                    text = text .. "|cff0000ffIn use|r"
                    BlzFrameSetVisible(DigimonTUsed[i], true)
                    BlzFrameSetAlpha(DigimonTUsed[i], 127)
                else
                    text = text .. "|cff00ff00Stored|r"
                    BlzFrameSetVisible(DigimonTUsed[i], false)
                end
                BlzFrameSetText(DigimonTTooltipText[i], text)
                BlzFrameSetSize(DigimonTTooltipText[i], 0.25, 0)
            else
                -- Button
                BlzFrameSetEnable(DigimonT[i], false)
                BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                -- Tooltip
                BlzFrameSetText(DigimonTTooltipText[i], "Empty slot")
                BlzFrameSetSize(DigimonTTooltipText[i], 0, 0.005)
            end
            -- Re-size
            BlzFrameClearAllPoints(DigimonTTooltip[i])
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonTTooltipText[i], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
        end
    end

    -- When the digimon evolves
    Digimon.evolutionEvent:register(function (evolve)
        if evolve:getOwner() == LocalPlayer then
            UpdateMenu()
        end
    end)

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
        if p == LocalPlayer then
            BlzFrameSetVisible(SummonADigimon, false)
            BlzFrameSetVisible(StockedDigimonsMenu, true)
            UpdateMenu()
            AddButtonToEscStack(Exit)
        end
    end

    local function ExitFunc()
        local bank = Bank[GetPlayerId(GetTriggerPlayer())]
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SummonADigimon, true)
            BlzFrameSetVisible(StockedDigimonsMenu, false)
            BlzFrameSetVisible(DigimonTUsed[bank.pressed], false)
            BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            RemoveButtonFromEscStack(Exit)
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
                BlzFrameSetVisible(SavedDigimons, false)
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

        SummonADigimon = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_TOPLEFT, 0.0100000, 0.205000)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_BOTTOMRIGHT, 0.140000, 0.170000)
        BlzFrameSetText(SummonADigimon, "|cffFCD20DSummon/Store a Digimon|r")
        BlzFrameSetScale(SummonADigimon, 0.90)
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

        Exit = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetAbsPoint(Exit, FRAMEPOINT_TOPLEFT, 0.190000, 0.330000)
        BlzFrameSetAbsPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, 0.210000, 0.310000)
        BlzFrameSetText(Exit, "|cffFCD20DX|r")
        BlzFrameSetScale(Exit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)

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
        BlzFrameSetAbsPoint(Text, FRAMEPOINT_TOPLEFT, 0.0500000, 0.320000)
        BlzFrameSetAbsPoint(Text, FRAMEPOINT_BOTTOMRIGHT, 0.170000, 0.290000)
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

        Store = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14500)
        BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, 0.02000)
        BlzFrameSetText(Store, "|cffFCD20DStore|r")
        BlzFrameSetScale(Store, 1.00)
        BlzFrameSetVisible(Store, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Store, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, StoreFunc)

        Free = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.11000, -0.14500)
        BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.02000)
        BlzFrameSetText(Free, "|cffFCD20DFree|r")
        BlzFrameSetScale(Free, 1.00)
        BlzFrameSetEnable(Free, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Free, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, FreeFunc)

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

        No = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
        BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
        BlzFrameSetText(No, "|cffFCD20DNo|r")
        BlzFrameSetScale(No, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, No, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, NoFunc)

        -- Saved

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

            SavedTCooldownT[i] = BlzCreateFrameByType("TEXT", "SavedTCooldownT[" .. i .."]", SavedDigimonT[i], "", 0)
            BlzFrameSetAllPoints(SavedTCooldownT[i], SavedDigimonT[i])
            BlzFrameSetText(SavedTCooldownT[i], "60")
            BlzFrameSetEnable(SavedTCooldownT[i], false)
            BlzFrameSetScale(SavedTCooldownT[i], 2.14)
            BlzFrameSetTextAlignment(SavedTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(SavedTCooldownT[i], 4)
            BlzFrameSetVisible(SavedTCooldownT[i], false)
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
    ---@return Digimon
    function RemoveFromBank(p, index)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = bank.stocked[index] ---@type Digimon
        if d then
            bank.stocked[index] = nil
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
            Timed.call(5 * math.random(), function ()
                d:issueOrder(Orders.smart, MapBounds:getRandomX(), MapBounds:getRandomY())
            end)
            d:remove(30.)
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
            BlzFrameSetVisible(SummonADigimon, flag)
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
        for i = 0, MAX_SAVED - 1 do
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
    ---@param index integer
    function RemoveSavedDigimon(p, index)
        local bank = Bank[GetPlayerId(p)] ---@type Bank
        local d = bank.saved[index] ---@type Digimon
        if d then
            bank.saved[index] = nil
            d:destroy()
        end
        if p == LocalPlayer then
            UpdateSave()
        end
    end

end)
Debug.endFile()