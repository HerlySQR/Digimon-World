Debug.beginFile("PressSaveOrLoad")
OnInit("PressSaveOrLoad", function ()
    Require "Player Data"
    Require "Timed"
    Require "Menu"
    Require "GameStatus"
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GetSyncedData"
    Require "Cosmetic"

    local MAX_DIGIMONS = udg_MAX_DIGIMONS
    local MAX_SAVED = udg_MAX_SAVED_DIGIMONS
    local MAX_QUESTS = udg_MAX_QUESTS

    local NormalColor = "FCD20D"
    local DisabledColor = "FFFFFF"
    local LocalPlayer = GetLocalPlayer()

    local Pressed = __jarray(0) ---@type table<player, integer>
    local SaveButton = nil ---@type framehandle
    local LoadButton = nil ---@type framehandle
    local SaveLoadMenu = nil ---@type framehandle
    local SaveSlotT = {} ---@type framehandle[]
    local Information = nil ---@type framehandle
    local TooltipName = nil ---@type framehandle
    local TooltipDate = nil ---@type framehandle
    local TooltipGold = nil ---@type framehandle
    local TooltipLumber = nil ---@type framehandle
    local TooltipFood = nil ---@type framehandle
    local TooltipDigimonT = {} ---@type framehandle[]
    local TooltipDigimonIconT = {} ---@type framehandle[]
    local TooltipDigimonItemsT = {} ---@type framehandle[]
    local TooltipDigimonLevelT = {} ---@type framehandle[]
    local TooltipDigimonStamina = {} ---@type framehandle[] 
    local TooltipDigimonDexterity = {} ---@type framehandle[] 
    local TooltipDigimonWisdom = {} ---@type framehandle[] 
    local TooltipUsing = nil ---@type framehandle
    local TooltipSaved = nil ---@type framehandle
    local TooltipBackpack = nil ---@type framehandle
    local TooltipSavedItems = nil ---@type framehandle
    local TooltipQuests = nil ---@type framehandle
    local TooltipQuestsArea = nil ---@type FrameList
    local TooltipQuestsName = {} ---@type framehandle[]
    local AbsoluteSave = nil ---@type framehandle
    local AbsoluteLoad = nil ---@type framehandle
    local Exit = nil ---@type framehandle

    local NotOnline = false
    local QuestsAdded = {}

    OnInit.final(function ()
        NotOnline = GameStatus.get() ~= GameStatus.ONLINE and not udg_SaveOnSinglePlayer

        PolledWait(1.)

        if NotOnline then
            print("You are in single player, save data is disabled.")
            BlzFrameSetEnable(AbsoluteSave, false)
        end
    end)

    ---This function always should be in a "if player == GetLocalPlayer() then" block
    local function UpdateMenu()
        local list = PlayerDatas[LocalPlayer]
        for i = 1, 5 do
            if list[i] then
                BlzFrameSetText(SaveSlotT[i-1], "|cffFCD20DSaved Slot " .. i .. "|r")
            else
                BlzFrameSetText(SaveSlotT[i-1], "|cffFCD20DEmpty|r")
            end
        end
    end

    -- I'm afraid of using the ConvertItemType function
    local function GetItemClass(id)
        if id == 0 then
            return ITEM_TYPE_PERMANENT
        elseif id == 1 then
            return ITEM_TYPE_CHARGED
        elseif id == 2 then
            return ITEM_TYPE_POWERUP
        elseif id == 3 then
            return ITEM_TYPE_ARTIFACT
        elseif id == 4 then
            return ITEM_TYPE_PURCHASABLE
        elseif id == 5 then
            return ITEM_TYPE_CAMPAIGN
        elseif id == 6 then
            return ITEM_TYPE_MISCELLANEOUS
        elseif id == 7 then
            return ITEM_TYPE_UNKNOWN
        elseif id == 8 then
            return ITEM_TYPE_ANY
        end
        return nil
    end

    -- This function always should be in a "if player == GetLocalPlayer() then" block
    local function UpdateInformation()
        local data = PlayerDatas[LocalPlayer][Pressed[LocalPlayer]]

        for i = 1, #QuestsAdded do
            TooltipQuestsArea:remove(TooltipQuestsName[QuestsAdded[i]])
        end
        QuestsAdded = {}

        if data then
            BlzFrameSetText(TooltipName, "|cffff6600Information|r")
            BlzFrameSetText(TooltipDate, os.date("\x25c", os.time(data.date)))
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits: |r" .. data.gold)
            BlzFrameSetText(TooltipLumber, "|cffc882c8DigiCrystal: |r" .. data.lumber)
            BlzFrameSetText(TooltipFood, "|cff8080ffTamer Rank: |r" .. data.food)
            local currentUsing = 0
            local currentSaved = MAX_DIGIMONS
            for i = 1, MAX_DIGIMONS + MAX_SAVED do
                if data.digimons[i] and data.digimons[i] ~= 0 then
                    local s = ""
                    local inv = data.inventories[i]
                    for j = 0, 5 do
                        if inv.items[j] then
                            s = s .. GetObjectName(inv.items[j]) -- Thank you guys
                            if GetItemClass(inv.classes[j]) == ITEM_TYPE_CHARGED then
                                s = s .. "(" .. inv.charges[j] .. ")"
                            end
                            if j ~= 5 then
                                s = s .. ", "
                            end
                        end
                    end
                    local index
                    if data.isSaved[i] == 1 then
                        index = currentSaved
                        currentSaved = currentSaved + 1
                    else
                        index = currentUsing
                        currentUsing = currentUsing + 1
                    end
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r" .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[index], BlzGetAbilityIcon(data.digimons[i]), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level " .. I2S(data.levels[i]) .. "|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r" .. data.strLevels[i] .. " (+" .. data.IVsta[i] .. ")")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r" .. data.agiLevels[i] .. " (+" .. data.IVdex[i] .. ")")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r" .. data.intLevels[i] .. " (+" .. data.IVwis[i] .. ")")
                else
                    local index
                    if currentUsing < MAX_DIGIMONS then
                        index = currentUsing
                        currentUsing = currentUsing + 1
                    else
                        index = currentSaved
                        currentSaved = currentSaved + 1
                    end
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r")
                    BlzFrameSetTexture(TooltipDigimonIconT[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level 0|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r")
                end
            end
            BlzFrameSetText(TooltipSaved, "|cff00eeffSaved:|r |cffffff00Max. " .. data.bankDigimonsMaxStock .. "|r")

            local result = ""
            for i = 1, #data.backpackItems do
                result = result .. GetObjectName(data.backpackItems[i]) .. "(" .. data.backpackItemCharges[i] .. "), "
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r\n" .. result:sub(1, result:len() - 2))

            result = ""
            for i = 1, #data.bankItems do
                result = result .. GetObjectName(data.bankItems[i])
                if data.bankItemCharges[i] > 1 then
                    result = result .. "(" .. data.bankItemCharges[i] .. ")"
                end
                if i ~= #data.bankItems then
                    result = result .. ", "
                end
            end
            BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r |cffffff00Max. " .. data.bankItemsMaxStock .. "|r\n" .. result)

            for i = 1, #data.questsIds do
                if not IsQuestARequirement(i) then
                    local id = data.questsIds[i]
                    local s = GetQuestName(id)
                    if data.questsIsCompleted[i] then
                        s = "|cffFFCC00" .. s .. "|r"
                    else
                        local max = GetQuestMaxProgress(id)
                        if max > 1 then
                            s = s .. " " .. ((max == data.questsProgresses[i]) and "|cff00ff00" or "|cffffffff") .. "(" .. data.questsProgresses[i] .. "/" .. max .. ")|r"
                        end
                    end
                    BlzFrameSetText(TooltipQuestsName[id], s)
                    TooltipQuestsArea:add(TooltipQuestsName[id])
                    table.insert(QuestsAdded, id)
                end
            end
        else
            BlzFrameSetText(TooltipName, "|cffff6600Empty|r")
            BlzFrameSetText(TooltipDate, "Date")
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits:|r")
            BlzFrameSetText(TooltipLumber, "|cffc882c8DigiCrystal:|r")
            BlzFrameSetText(TooltipFood, "|cff8080ffTamer Rank:|r")
            for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
                BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
                BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
            BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r")
        end
    end

    local function SaveLoadActions(slot)
        local p = GetTriggerPlayer()
        local oldSlot = Pressed[p] - 1
        Pressed[p] = slot + 1
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[oldSlot], true)
            BlzFrameSetEnable(SaveSlotT[slot], false)
            BlzFrameSetVisible(Information, true)
            BlzFrameSetEnable(AbsoluteSave, BlzFrameIsVisible(AbsoluteSave) and not NotOnline)
            BlzFrameSetEnable(AbsoluteLoad, BlzFrameIsVisible(AbsoluteLoad))
            UpdateInformation()
        end
    end

    local function ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[Pressed[LocalPlayer] - 1], true)
            BlzFrameSetVisible(Information, false)
            BlzFrameSetVisible(SaveLoadMenu, false)
            RemoveButtonFromEscStack(Exit)
        end
    end

    local function SaveFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, true)
            BlzFrameSetEnable(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, false)
            UpdateMenu()
        end
    end

    local function LoadFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, true)
            BlzFrameSetEnable(AbsoluteLoad, false)
            UpdateMenu()
        end
    end

    local function AbsoluteSaveFunc()
        local p = GetTriggerPlayer()
        udg_SaveLoadEvent_Player = p
        udg_SaveLoadSlot = Pressed[udg_SaveLoadEvent_Player]
        TriggerExecute(gg_trg_Save_GUI)
        WaitLastSync()
        if p == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end

    local function AbsoluteLoadFunc()
        local p = GetTriggerPlayer()
        TriggerExecute(gg_trg_Absolute_Load)
        UseData(p, Pressed[p])
        ExitFunc()
    end

    local function InitFrames()
        local t = nil ---@type trigger

        BlzLoadTOCFile("ButtonsTOC.toc")
        BlzLoadTOCFile("war3mapImported\\slider.toc")

        -- Save Button

        SaveButton = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SaveButton, FRAMEPOINT_TOPLEFT, 0.680000, 0.570000)
        BlzFrameSetAbsPoint(SaveButton, FRAMEPOINT_BOTTOMRIGHT, 0.740000, 0.540000)
        BlzFrameSetText(SaveButton, "|cff" .. NormalColor .. "Save|r")
        BlzFrameSetScale(SaveButton, 1.00)
        BlzFrameSetVisible(SaveButton, false)
        AddFrameToMenu(SaveButton)

        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SaveButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SaveFunc)

        -- Load Button

        LoadButton = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(LoadButton, FRAMEPOINT_TOPLEFT, 0.740000, 0.570000)
        BlzFrameSetAbsPoint(LoadButton, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.540000)
        BlzFrameSetText(LoadButton, "|cff" .. NormalColor .. "Load|r")
        BlzFrameSetScale(LoadButton, 1.00)
        BlzFrameSetVisible(LoadButton, false)
        AddFrameToMenu(LoadButton)

        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, LoadButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, LoadFunc)

        -- Menu

        SaveLoadMenu = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.580000, 0.540000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.320000)
        BlzFrameSetVisible(SaveLoadMenu, false)
        AddFrameToMenu(SaveLoadMenu)

        for i = 0, 4 do
            SaveSlotT[i] = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.01000 - i * 0.035)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.18000 - i * 0.035)
            BlzFrameSetText(SaveSlotT[i], "|cffFCD20DEmpty|r")
            BlzFrameSetScale(SaveSlotT[i], 1.00)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, SaveSlotT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () SaveLoadActions(i) end) -- :D
        end

        AbsoluteSave = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.18000)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteSave, "|cffFCD20DSave|r")
        BlzFrameSetScale(AbsoluteSave, 1.00)
        BlzFrameSetVisible(AbsoluteSave, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteSave, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteSaveFunc)

        AbsoluteLoad = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.18000)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteLoad, "|cffFCD20DLoad|r")
        BlzFrameSetScale(AbsoluteLoad, 1.00)
        BlzFrameSetVisible(AbsoluteLoad, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteLoad, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteLoadFunc)

        Exit = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.12000, -0.18000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.010000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetScale(Exit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)

        -- Tooltip

        Information = BlzCreateFrame("CheckListBox", SaveLoadMenu, 0, 0)
        BlzFrameSetPoint(Information, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, -0.50000, 0.0000)
        BlzFrameSetPoint(Information, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.22000, -0.30000)

        TooltipName = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipName, "|cffff6600Name|r")
        BlzFrameSetEnable(TooltipName, false)
        BlzFrameSetScale(TooltipName, 1.00)
        BlzFrameSetTextAlignment(TooltipName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipDate = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.25000, -0.010000)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipDate, "Date")
        BlzFrameSetEnable(TooltipDate, false)
        BlzFrameSetScale(TooltipDate, 1.00)
        BlzFrameSetTextAlignment(TooltipDate, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

        TooltipGold = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.33000, 0.47000)
        BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r")
        BlzFrameSetEnable(TooltipGold, false)
        BlzFrameSetScale(TooltipGold, 1.00)
        BlzFrameSetTextAlignment(TooltipGold, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipLumber = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17000, -0.030000)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17000, 0.47000)
        BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r")
        BlzFrameSetEnable(TooltipLumber, false)
        BlzFrameSetScale(TooltipLumber, 1.00)
        BlzFrameSetTextAlignment(TooltipLumber, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipFood = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.33000, -0.030000)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.47000)
        BlzFrameSetText(TooltipFood, "|cffa34f00Food: |r")
        BlzFrameSetEnable(TooltipFood, false)
        BlzFrameSetScale(TooltipFood, 1.00)
        BlzFrameSetTextAlignment(TooltipFood, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        local div = math.ceil(MAX_DIGIMONS / 3)
        for i = 0, 2 do
            for j = 0, div - 1 do
                local id = i*div + j
                if id >= MAX_DIGIMONS then break end
                x1[id] = 0.015000 + i * 0.16
                y1[id] = -0.071750 - j * 0.06075
                x2[id] = -0.33500 + i * 0.16
                y2[id] = 0.39250 - j * 0.06075
            end
        end

        div = math.ceil(MAX_SAVED / 3)
        for i = 0, 2 do
            for j = 0, div - 1 do
                local id = i*div + j
                if id >= MAX_SAVED then break end
                id = id + MAX_DIGIMONS
                x1[id] = 0.015000 + i * 0.16
                y1[id] = -0.27050 - j * 0.06075
                x2[id] = -0.33500 + i * 0.16
                y2[id] = 0.19375 - j * 0.06075
            end
        end

        for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
            TooltipDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", Information, "", 1)
            BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            BlzFrameSetTexture(TooltipDigimonT[i], "war3mapImported\\EmptyBTN.blp", 0, true)

            TooltipDigimonIconT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", TooltipDigimonT[i], "", 1)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0017500)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10750, 0.016500)
            BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            TooltipDigimonItemsT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.0032500)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.010000)
            BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
            BlzFrameSetEnable(TooltipDigimonItemsT[i], false)
            BlzFrameSetScale(TooltipDigimonItemsT[i], 1.00)
            BlzFrameSetTextAlignment(TooltipDigimonItemsT[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            TooltipDigimonLevelT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0037500, -0.040750)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10625, 0.0000)
            BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            BlzFrameSetEnable(TooltipDigimonLevelT[i], false)
            BlzFrameSetScale(TooltipDigimonLevelT[i], 1.00)
            BlzFrameSetTextAlignment(TooltipDigimonLevelT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            TooltipDigimonStamina[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonStamina[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.045750)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.071500, 0.0000)
            BlzFrameSetText(TooltipDigimonStamina[i], "")
            BlzFrameSetEnable(TooltipDigimonStamina[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonDexterity[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonDexterity[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.078500, -0.045750)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.038000, 0.0000)
            BlzFrameSetText(TooltipDigimonDexterity[i], "")
            BlzFrameSetEnable(TooltipDigimonDexterity[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonWisdom[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonWisdom[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.11200, -0.045750)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.0000)
            BlzFrameSetText(TooltipDigimonWisdom[i], "")
            BlzFrameSetEnable(TooltipDigimonWisdom[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        TooltipUsing = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.45000)
        BlzFrameSetText(TooltipUsing, "|cff00eeffUsing:|r")
        BlzFrameSetEnable(TooltipUsing, false)
        BlzFrameSetScale(TooltipUsing, 1.00)
        BlzFrameSetTextAlignment(TooltipUsing, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipSaved = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.25000)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.25000)
        BlzFrameSetText(TooltipSaved, "|cff00eeffSaved:|r")
        BlzFrameSetEnable(TooltipSaved, false)
        BlzFrameSetScale(TooltipSaved, 1.00)
        BlzFrameSetTextAlignment(TooltipSaved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipBackpack = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
        BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
        BlzFrameSetEnable(TooltipBackpack, false)
        BlzFrameSetScale(TooltipBackpack, 1.00)
        BlzFrameSetTextAlignment(TooltipBackpack, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipSavedItems = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17500, -0.39000)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.010000)
        BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r")
        BlzFrameSetEnable(TooltipSavedItems, false)
        BlzFrameSetScale(TooltipSavedItems, 1.00)
        BlzFrameSetTextAlignment(TooltipSavedItems, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuests = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.34000, -0.39000)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(TooltipQuests, "|cff5257ffCompleted Unique Quests:|r")
        BlzFrameSetEnable(TooltipQuests, false)
        BlzFrameSetScale(TooltipQuests, 1.00)
        BlzFrameSetTextAlignment(TooltipQuests, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuestsArea = FrameList.create(false, TooltipQuests)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_TOPLEFT, TooltipQuests, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_BOTTOMRIGHT, TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
        TooltipQuestsArea:setSize(BlzFrameGetWidth(TooltipQuestsArea.Frame), BlzFrameGetHeight(TooltipQuestsArea.Frame))

        Timed.call(function ()
            for i = 0, MAX_QUESTS do
                TooltipQuestsName[i] = BlzCreateFrameByType("TEXT", "name", TooltipQuests, "", 0)
                BlzFrameSetSize(TooltipQuestsName[i], 0.13, 0.015)
                BlzFrameSetText(TooltipQuestsName[i], GetQuestName(i))
                BlzFrameSetEnable(TooltipQuestsName[i], false)
                BlzFrameSetScale(TooltipQuestsName[i], 1.00)
                BlzFrameSetTextAlignment(TooltipQuestsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
                BlzFrameSetVisible(TooltipQuestsName[i], false)
            end
        end)
    end

    FrameLoaderAdd(InitFrames)

    -- Functions to use

    ---@param p player
    ---@param flag boolean
    function ShowSave(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SaveButton, flag)
        end
    end

    ---@param p player
    ---@param flag boolean
    function ShowLoad(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(LoadButton, flag)
        end
    end

    ---@param p player
    function UpdateSaveLoad(p)
        if p == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end
end)
Debug.endFile()