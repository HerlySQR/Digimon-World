OnInit("PressSaveOrLoad", function ()
    Require "Player Data"
    Require "Timed"

    local NormalColor = "FCD20D"
    local DisabledColor = "FFFFFF"
    local DEFAULT_AUTO_SAVE_INTERVAL = 3 -- minutes
    local LocalPlayer = GetLocalPlayer()

    local Pressed = __jarray(0) ---@type table<player, integer>
    local SaveButton = nil ---@type framehandle
    local LoadButton = nil ---@type framehandle
    local SaveLoadMenu = nil ---@type framehandle
    local SaveSlotT = {} ---@type framehandle[]
    local AutoSaveSlot = nil ---@type framehandle
    local AutoSaveText = nil ---@type framehandle
    local AutoSaveSlider = nil ---@type framehandle
    local Information = nil ---@type framehandle
    local TooltipName = nil ---@type framehandle
    local TooltipGold = nil ---@type framehandle
    local TooltipLumber = nil ---@type framehandle
    local TooltipDigimonItemsT = {} ---@type framehandle[]
    local TooltipDigimonIconT = {} ---@type framehandle[]
    local TextTooltipLevelT = {} ---@type framehandle[]
    local AbsoluteSave = nil ---@type framehandle
    local AbsoluteLoad = nil ---@type framehandle
    local Exit = nil ---@type framehandle

    local WarningMessage = nil ---@type dialog
    local WarningMessageReceived = __jarray(false) ---@type table<player, boolean>

    OnInit.final(function ()
        WarningMessage = DialogCreate()
        DialogSetMessage(WarningMessage, "|cffff0000WARNING|r\nTo properly save, you should\nrestart the Warcraft 3.")
        DialogAddButton(WarningMessage, "Understood", 0)
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
            BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r" .. data.gold)
            BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r" .. data.lumber)
            for i = 1, #data.digimons do
                if data.digimons[i] then
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
                    BlzFrameSetText(TextTooltipLevelT[i-1], "|cffFFCC00Level " .. data.levels[i] .. "|r")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[i-1], "|cff00ffffItems: |r")
                    BlzFrameSetTexture(TooltipDigimonIconT[i-1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TextTooltipLevelT[i-1], "|cffFFCC00Level 0|r")
                end
            end
        else
            BlzFrameSetText(TooltipName, "|cffff6600Empty|r")
            BlzFrameSetText(TooltipGold, "|cffFFCC00Gold:|r")
            BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber:|r")
            for i = 0, 5 do
                BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
                BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                BlzFrameSetText(TextTooltipLevelT[i], "|cffFFCC00Level 0|r")
            end
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
            BlzFrameSetEnable(AbsoluteSave, BlzFrameIsVisible(AbsoluteSave))
            BlzFrameSetEnable(AbsoluteLoad, BlzFrameIsVisible(AbsoluteLoad))
            UpdateInformation()
            if not WarningMessageReceived[p] then
                DialogDisplay(p, WarningMessage, true)
            end
        end
        if not WarningMessageReceived[p] then
            WarningMessageReceived[p] = true
        end
    end

    local function ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[Pressed[LocalPlayer] - 1], true)
            BlzFrameSetVisible(Information, false)
            BlzFrameSetVisible(SaveLoadMenu, false)
        end
    end

    local function SaveFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, true)
            BlzFrameSetEnable(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, false)
            BlzFrameSetVisible(AutoSaveSlot, false)
            BlzFrameSetVisible(AutoSaveText, true)
            BlzFrameSetVisible(AutoSaveSlider, true)
            UpdateMenu()
        end
    end

    local function LoadFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, true)
            BlzFrameSetEnable(AbsoluteLoad, false)
            BlzFrameSetVisible(AutoSaveSlot, true)
            BlzFrameSetVisible(AutoSaveText, false)
            BlzFrameSetVisible(AutoSaveSlider, false)
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
            BlzFrameSetEnable(AbsoluteSave, false)
        end
    end

    local function AbsoluteLoadFunc()
        xpcall(function ()
        TriggerExecute(gg_trg_Absolute_Load)
        UseData(GetTriggerPlayer(), Pressed[GetTriggerPlayer()])
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(AbsoluteLoad, false)
        end
        end, print)
    end

    -- AutoSave

    local AutoSaveTimers = {} ---@type table<player, function>
    local AutoSaveIntervals = __jarray(DEFAULT_AUTO_SAVE_INTERVAL) ---@type table<player, number>

    local function AutoSaveSliderFunc()
        local p = GetTriggerPlayer()
        local v = BlzGetTriggerFrameValue()

        AutoSaveIntervals[p] = v
        SetAutoSaveInterval(p, v)
    end

    -- --

    local function InitFrames()
        local t = nil ---@type trigger
        local y1 = {} ---@type number[]
        local y2 = {} ---@type number[]

        BlzLoadTOCFile("ButtonsTOC.toc")
        BlzLoadTOCFile("war3mapImported\\slider.toc")

        -- Save Button

        SaveButton = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SaveButton, FRAMEPOINT_TOPLEFT, 0.680000, 0.570000)
        BlzFrameSetAbsPoint(SaveButton, FRAMEPOINT_BOTTOMRIGHT, 0.740000, 0.540000)
        BlzFrameSetText(SaveButton, "|cff" .. NormalColor .. "Save|r")
        BlzFrameSetScale(SaveButton, 1.00)
        BlzFrameSetVisible(SaveButton, false)

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

        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, LoadButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, LoadFunc)

        -- Menu

        SaveLoadMenu = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.580000, 0.540000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.280000)
        BlzFrameSetVisible(SaveLoadMenu, false)

        y1[0] = -0.01000
        y2[0] = 0.22000

        y1[1] = -0.04500
        y2[1] = 0.18500

        y1[2] = -0.08000
        y2[2] = 0.15000

        y1[3] = -0.11500
        y2[3] = 0.11500

        y1[4] = -0.15000
        y2[4] = 0.08000

        for i = 0, 4 do
            SaveSlotT[i] = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, y1[i])
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, y2[i])
            BlzFrameSetText(SaveSlotT[i], "|cffFCD20DEmpty|r")
            BlzFrameSetScale(SaveSlotT[i], 1.00)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, SaveSlotT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () SaveLoadActions(i) end) -- :D
        end

        AutoSaveSlot = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu, 0, 0)
        BlzFrameSetPoint(AutoSaveSlot, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.18500)
        BlzFrameSetPoint(AutoSaveSlot, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.045000)
        BlzFrameSetText(AutoSaveSlot, "|cffFCD20DAuto-save|r")
        BlzFrameSetScale(AutoSaveSlot, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AutoSaveSlot, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, function () SaveLoadActions(5) end)

        AutoSaveText = BlzCreateFrameByType("TEXT", "name", SaveLoadMenu, "", 0)
        BlzFrameSetPoint(AutoSaveText, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.18313)
        BlzFrameSetPoint(AutoSaveText, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.061260)
        BlzFrameSetText(AutoSaveText, "Auto-save every |cffFFCC00" .. math.floor(DEFAULT_AUTO_SAVE_INTERVAL) .. "|r minutes.")
        BlzFrameSetEnable(AutoSaveText, false)
        BlzFrameSetScale(AutoSaveText, 1.00)
        BlzFrameSetTextAlignment(AutoSaveText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        AutoSaveSlider = BlzCreateFrame("EscMenuSliderTemplate", SaveLoadMenu, 0, 0)
        BlzFrameSetPoint(AutoSaveSlider, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.20000)
        BlzFrameSetSize(AutoSaveSlider, 0.20000, -0.24500)
        BlzFrameSetPoint(AutoSaveSlider, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.045000)
        BlzFrameSetMinMaxValue(AutoSaveSlider, 2, 10)
        BlzFrameSetStepSize(AutoSaveSlider, 1.)
        BlzFrameSetValue(AutoSaveSlider, DEFAULT_AUTO_SAVE_INTERVAL)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AutoSaveSlider, FRAMEEVENT_SLIDER_VALUE_CHANGED)
        TriggerAddAction(t, AutoSaveSliderFunc)

        AbsoluteSave = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.22000)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteSave, "|cffFCD20DSave|r")
        BlzFrameSetScale(AbsoluteSave, 1.00)
        BlzFrameSetVisible(AbsoluteSave, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteSave, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteSaveFunc)

        AbsoluteLoad = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.22000)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteLoad, "|cffFCD20DLoad|r")
        BlzFrameSetScale(AbsoluteLoad, 1.00)
        BlzFrameSetVisible(AbsoluteLoad, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteLoad, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteLoadFunc)

        Exit = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.12000, -0.22000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.010000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetScale(Exit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)

        -- Tooltip

        Information = BlzCreateFrame("CheckListBox", SaveLoadMenu,0,0)
        BlzFrameSetPoint(Information, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, -0.16706, 0.0067310)
        BlzFrameSetPoint(Information, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.21672, -0.20045)
        BlzFrameSetVisible(Information, false)

        TooltipName = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.0070600, -0.016731)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.013280, 0.43045)
        BlzFrameSetText(TooltipName, "|cffff6600Name|r")
        BlzFrameSetEnable(TooltipName, false)
        BlzFrameSetScale(TooltipName, 1.00)
        BlzFrameSetTextAlignment(TooltipName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipGold = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetAbsPoint(TooltipGold, FRAMEPOINT_TOPLEFT, 0.421110, 0.507466)
        BlzFrameSetAbsPoint(TooltipGold, FRAMEPOINT_BOTTOMRIGHT, 0.496110, 0.487660)
        BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r")
        BlzFrameSetEnable(TooltipGold, false)
        BlzFrameSetScale(TooltipGold, 1.00)
        BlzFrameSetTextAlignment(TooltipGold, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipLumber = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetAbsPoint(TooltipLumber, FRAMEPOINT_TOPLEFT, 0.495000, 0.505000)
        BlzFrameSetAbsPoint(TooltipLumber, FRAMEPOINT_BOTTOMRIGHT, 0.570000, 0.485000)
        BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r")
        BlzFrameSetEnable(TooltipLumber, false)
        BlzFrameSetScale(TooltipLumber, 1.00)
        BlzFrameSetTextAlignment(TooltipLumber, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        y1[0] = -0.06173
        y2[0] = 0.35545

        y1[1] = -0.12673
        y2[1] = 0.29045

        y1[2] = -0.19173
        y2[2] = 0.22545

        y1[3] = -0.25673
        y2[3] = 0.16045

        y1[4] = -0.32163
        y2[4] = 0.09545

        y1[5] = -0.38673
        y2[5] = 0.03045

        for i = 0, 5 do
            TooltipDigimonIconT[i] = BlzCreateFrameByType("BACKDROP", "TooltipDigimonIconT[" .. i .. "]", Information, "", 1)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.0081700, y1[i])
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.11217, y2[i])
            BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            TextTooltipLevelT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonIconT[i], "", 0)
            BlzFrameSetPoint(TextTooltipLevelT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(TextTooltipLevelT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, -0.01165)
            BlzFrameSetText(TextTooltipLevelT[i], "|cffFFCC00Level 0|r")
            BlzFrameSetEnable(TextTooltipLevelT[i], false)
            BlzFrameSetScale(TextTooltipLevelT[i], 0.858)
            BlzFrameSetTextAlignment(TextTooltipLevelT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            TooltipDigimonItemsT[i] = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.063610, y1[i])
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.0067300, y2[i] - 0.01165)
            BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
            BlzFrameSetEnable(TooltipDigimonItemsT[i], false)
            BlzFrameSetScale(TooltipDigimonItemsT[i], 1.00)
            BlzFrameSetTextAlignment(TooltipDigimonItemsT[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        end
    end

    InitFrames()
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
    ---@return integer
    function GetAutoSaveInterval(p)
        return AutoSaveIntervals[p]
    end

    ---@param p player
    ---@param i integer
    function SetAutoSaveInterval(p, i)
        i = i < 2 and DEFAULT_AUTO_SAVE_INTERVAL or i
        AutoSaveIntervals[p] = i
        Timed.call(AutoSaveTimers[p] and AutoSaveTimers[p]() or 0, function ()
            local function callback()
                udg_SaveLoadSlot = 6
                udg_SaveLoadEvent_Player = p
                TriggerExecute(gg_trg_Save_GUI)
                if p == LocalPlayer then
                    UpdateInformation()
                end
            end
            callback()
            AutoSaveTimers[p] = Timed.echo(callback, i * 60)
        end)
        if p == LocalPlayer then
            BlzFrameSetValue(AutoSaveSlider, i)
            BlzFrameSetText(AutoSaveText, "Auto-save every |cffFFCC00" .. math.floor(i) .. "|r minutes.")
        end
    end

    ---@param p player
    ---@return integer
    function IsWarningMessageReceived(p)
        return WarningMessageReceived[p] and 1 or 0
    end

    ---@param p player
    ---@param flag integer
    function SetWarningMessageReceived(p, flag)
        WarningMessageReceived[p] = flag == 1
    end
end)