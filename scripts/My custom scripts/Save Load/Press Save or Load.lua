Debug.beginFile("PressSaveOrLoad")
OnInit("PressSaveOrLoad", function ()
    Require "Player Data"
    Require "Timed"
    Require "Menu"

    local MAX_DIGIMONS = udg_MAX_DIGIMONS

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
    local TooltipGold = nil ---@type framehandle
    local TooltipLumber = nil ---@type framehandle
    local TooltipFood = nil ---@type framehandle
    local TooltipDigimonT = {} ---@type framehandle[]
    local TooltipDigimonIconT = {} ---@type framehandle[]
    local TooltipDigimonItemsT = {} ---@type framehandle[]
    local TooltipDigimonLevelT = {} ---@type framehandle[]
    local TooltipBackpack = nil ---@type framehandle
    local TooltipCompletedQuests = nil ---@type framehandle
    local TooltipCompletedQuestsArea = nil ---@type framehandle
    local AbsoluteSave = nil ---@type framehandle
    local AbsoluteLoad = nil ---@type framehandle
    local Exit = nil ---@type framehandle

    local NotOnline = false

    OnInit.final(function ()
        NotOnline = ReloadGameCachesFromDisk() and not udg_SaveOnSinglePlayer

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
        if data then
            BlzFrameSetText(TooltipName, "|cffff6600Information|r")
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits: |r" .. data.gold)
            BlzFrameSetText(TooltipLumber, "|cffc8c800DigiGold: |r" .. data.lumber)
            BlzFrameSetText(TooltipFood, "|cffc882c8DigiCrystal: |r" .. data.food)
            for i = 1, MAX_DIGIMONS do
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
                    BlzFrameSetText(TooltipDigimonItemsT[i-1], "|cff00ffffItems: |r" .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[i-1], BlzGetAbilityIcon(data.digimons[i]), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[i-1], "|cffFFCC00Level " .. I2S(data.levels[i]) .. "|r")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[i-1], "|cff00ffffItems: |r")
                    BlzFrameSetTexture(TooltipDigimonIconT[i-1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[i-1], "|cffFFCC00Level 0|r")
                end
            end
            local result = ""
            for i, itm in ipairs(data.backpackItems) do
                result = result .. GetObjectName(itm) .. "(" .. I2S(data.backpackItemCharges[i]) .. "), "
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r\n" .. result:sub(1, result:len() - 2))
            BlzFrameSetText(TooltipCompletedQuestsArea, GetCompletedQuestNames(data.completedQuests))
        else
            BlzFrameSetText(TooltipName, "|cffff6600Empty|r")
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits:|r")
            BlzFrameSetText(TooltipLumber, "|cffc8c800DigiGold:|r")
            BlzFrameSetText(TooltipFood, "|cffc882c8DigiCrystal:|r")
            for i = 0, MAX_DIGIMONS - 1 do
                BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
                BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
            BlzFrameSetText(TooltipCompletedQuestsArea, "")
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
        udg_SaveLoadEvent_Player = GetTriggerPlayer()
        udg_SaveLoadSlot = Pressed[udg_SaveLoadEvent_Player]
        TriggerExecute(gg_trg_Save_GUI)
        if udg_SaveLoadEvent_Player == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end

    local function AbsoluteLoadFunc()
        TriggerExecute(gg_trg_Absolute_Load)
        UseData(GetTriggerPlayer(), Pressed[GetTriggerPlayer()])
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
        BlzFrameSetPoint(Information, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, -0.34000, 0.0000)
        BlzFrameSetPoint(Information, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.22000, -0.25000)

        TooltipName = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.44000)
        BlzFrameSetText(TooltipName, "|cffff6600Name|r")
        BlzFrameSetEnable(TooltipName, false)
        BlzFrameSetScale(TooltipName, 1.00)
        BlzFrameSetTextAlignment(TooltipName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipGold = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.22500, 0.42000)
        BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r")
        BlzFrameSetEnable(TooltipGold, false)
        BlzFrameSetScale(TooltipGold, 1.00)
        BlzFrameSetTextAlignment(TooltipGold, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipLumber = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.11500, -0.030000)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.42000)
        BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r")
        BlzFrameSetEnable(TooltipLumber, false)
        BlzFrameSetScale(TooltipLumber, 1.00)
        BlzFrameSetTextAlignment(TooltipLumber, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipFood = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.22000, -0.030000)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.42000)
        BlzFrameSetText(TooltipFood, "|cffa34f00Food: |r")
        BlzFrameSetEnable(TooltipFood, false)
        BlzFrameSetScale(TooltipFood, 1.00)
        BlzFrameSetTextAlignment(TooltipFood, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        local div = MAX_DIGIMONS // 2
        for i = 0, 1 do
            for j = 0, div - 1 do
                local id = i*div + j
                x1[id] = 0.015000 + i * 0.1568
                y1[id] = -0.054250 - j * 0.05875
                x2[id] = -0.17500 + i * 0.1568
                y2[id] = 0.36000 - j * 0.05875
            end
        end

        for i = 0, MAX_DIGIMONS - 1 do
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
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.0000)
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
        end

        TooltipBackpack = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.015000, -0.29000)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.020000)
        BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
        BlzFrameSetEnable(TooltipBackpack, false)
        BlzFrameSetScale(TooltipBackpack, 1.00)
        BlzFrameSetTextAlignment(TooltipBackpack, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipCompletedQuests = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipCompletedQuests, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17250, -0.29000)
        BlzFrameSetPoint(TooltipCompletedQuests, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.017500, 0.020000)
        BlzFrameSetText(TooltipCompletedQuests, "|cff5257ffCompleted Main Quests:|r")
        BlzFrameSetEnable(TooltipCompletedQuests, false)
        BlzFrameSetScale(TooltipCompletedQuests, 1.00)
        BlzFrameSetTextAlignment(TooltipCompletedQuests, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipCompletedQuestsArea = BlzCreateFrameByType("TEXTAREA", "name", TooltipCompletedQuests, "", 0)
        BlzFrameSetPoint(TooltipCompletedQuestsArea, FRAMEPOINT_TOPLEFT, TooltipCompletedQuests, FRAMEPOINT_TOPLEFT, 0.0025000, -0.015000)
        BlzFrameSetPoint(TooltipCompletedQuestsArea, FRAMEPOINT_BOTTOMRIGHT, TooltipCompletedQuests, FRAMEPOINT_BOTTOMRIGHT, -0.0025000, 0.0000)
        BlzFrameSetText(TooltipCompletedQuestsArea, "|cffFFCC00Quest 0|r")
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
end)
Debug.endFile()