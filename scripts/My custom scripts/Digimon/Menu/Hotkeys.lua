Debug.beginFile("Hotkeys")
OnInit("Hotkeys", function ()
    Require "PlayerUtils"
    Require "FrameLoader"
    Require "Menu"
    Require "SaveHelper"

    local OskeyMeta = {
        [0] = "",
        "SHIFT",
        "CTRL",
        "CTRL + SHIFT",
        "ALT",
        "ALT + SHIFT",
        "ALT + CTRL",
        "ALT + SHIFT + CTRL",
        "META",
        "META + SHIFT",
        "META + CTRL",
        "META + CTRL + SHIFT",
        "META + ALT",
        "META + ALT + SHIFT",
        "META + ALT + CTRL",
        "META + ALT + SHIFT + CTRL"
    }

    local MAX_KEYS = 0xFF

    local oskeyName = {} ---@type table<oskeytype, string>
    local oskeyConverted = {} ---@type table<integer, oskeytype>
    local oskeyFromName = {} ---@type table<string, oskeytype>
    local frameHotkeys = {} ---@type table<framehandle, string>
    local oskeyIsUsed = {} ---@type table<oskeytype, boolean>

    ---@param key oskeytype
    ---@return boolean
    local function IsBannedKey(key)
        if key == OSKEY_LALT then
            return true
        elseif key == OSKEY_RALT then
            return true
        elseif key == OSKEY_RCONTROL then
            return true
        elseif key == OSKEY_LCONTROL then
            return true
        elseif key == OSKEY_RSHIFT then
            return true
        elseif key == OSKEY_LSHIFT then
            return true
        elseif key == OSKEY_RMETA then
            return true
        elseif key == OSKEY_LMETA then
            return true
        elseif oskeyIsUsed[key] then
            return true
        end
        return false
    end

    -- These values are different for each player
    local LocalPlayer = GetLocalPlayer()
    local selectingKey = false
    local frames = {} ---@type table<integer, framehandle>
    --local referenceFrame = {} ---@type table<framehandle, integer>
    local hotkeyText = {} ---@type table<integer, framehandle>
    local frameSelected = -1
    local frameWithKey = {} ---@type table<oskeytype, table<integer, integer>>
    local edits = {} ---@type table<oskeytype, table<integer, integer>>
    local referencePair = {} ---@type table<integer, {[1]: oskeytype, [2]: integer}>

    local HotkeyButton = nil ---@type framehandle
    local BackdropHotkeyButton = nil ---@type framehandle
    local HotkeyMenu = nil ---@type framehandle
    local HotkeyMessage = nil ---@type framehandle
    local HotkeyBackpackSubMenu = nil ---@type framehandle
    local HotkeyBackpack = nil ---@type framehandle
    local HotkeyExit = nil ---@type framehandle
    local HotkeySave = nil ---@type framehandle
    local HotkeyYourDigimons = nil ---@type framehandle
    local HotkeyYourDigimonsSubMenu = nil ---@type framehandle

    local visibleMenu = nil ---@type framehandle

    ---@param frame framehandle
    ---@param hotkey string
    function SetFrameHotkey(frame, hotkey)
        frameHotkeys[frame] = hotkey
        Timed.call(0.02, function ()
            local t = CreateTrigger()
            ForForce(FORCE_PLAYING, function ()
                BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), oskeyFromName[hotkey], 0, true)
            end)
            TriggerAddAction(t, function ()
                if GetTriggerPlayer() == LocalPlayer and BlzFrameIsVisible(frame) and BlzFrameGetEnable(frame) then
                    BlzFrameClick(frame)
                end
            end)
            oskeyIsUsed[oskeyFromName[hotkey]] = true

            local hotkeyFrame = BlzCreateFrameByType("BACKDROP", "BACKDROP", frame, "", 1)
            BlzFrameSetPoint(hotkeyFrame, FRAMEPOINT_TOPLEFT, frame, FRAMEPOINT_TOPLEFT, 0.0025000, -0.0025000)
            BlzFrameSetPoint(hotkeyFrame, FRAMEPOINT_BOTTOMRIGHT, frame, FRAMEPOINT_BOTTOMRIGHT, -0.032500, 0.027500)
            BlzFrameSetTexture(hotkeyFrame, "war3mapImported\\BlackBackdrop.blp", 0, true)

            local text = BlzCreateFrameByType("TEXT", "name", hotkeyFrame, "", 0)
            BlzFrameSetScale(text, 0.858)
            BlzFrameSetAllPoints(text, hotkeyFrame)
            BlzFrameSetText(text, hotkey)
            BlzFrameSetEnable(text, false)
            BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        end)
    end

    ---@param frame framehandle
    ---@return string
    function GetFrameHotkey(frame)
        return frameHotkeys[frame]
    end

    local function UpdateHotkeys()
        for _, v in pairs(hotkeyText) do
            BlzFrameSetText(v, "")
        end
        for key, list in pairs(frameWithKey) do
            for meta, id in pairs(list) do
                BlzFrameSetText(hotkeyText[id], ((meta ~= 0) and (OskeyMeta[meta] .. " + ") or "") .. oskeyName[key])
            end
        end
    end

    ---@param frame framehandle
    ---@param id integer
    local function AsingHotkey(frame, id)
        OnClickEvent(frame, function (p)
            if p == LocalPlayer then
                if frames[id] then
                    selectingKey = true
                    frameSelected = id
                    BlzFrameSetText(HotkeyMessage, "|cffFFCC00Press a key to set the hotkey|r")
                else
                    BlzFrameSetText(HotkeyMessage, "|cffFF0000Error|r")
                end
            end
        end)

        --referenceFrame[frame] = id

        local text = BlzCreateFrameByType("TEXT", "name", frame, "", 0)
        BlzFrameSetAllPoints(text, frame)
        BlzFrameSetText(text, "")
        BlzFrameSetScale(text, 1)
        BlzFrameSetEnable(text, false)
        BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetLevel(text, 4)
        hotkeyText[id] = text
    end

    local function HotkeyBackpackFunc(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(visibleMenu, false)
            BlzFrameSetVisible(HotkeyBackpackSubMenu, true)
            visibleMenu = HotkeyBackpackSubMenu
        end
    end

    local function HotkeyYourDigimonsFunc(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(visibleMenu, false)
            BlzFrameSetVisible(HotkeyYourDigimonsSubMenu, true)
            visibleMenu = HotkeyYourDigimonsSubMenu
        end
    end

    local function HotkeyExitFunc(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(HotkeyMenu, false)
            BlzFrameSetVisible(visibleMenu, false)
            BlzFrameSetEnable(HotkeyButton, true)
            RemoveButtonFromEscStack(HotkeyExit)
            selectingKey = false
            frameSelected = -1
            BlzFrameSetText(HotkeyMessage, "")
            edits = {}
        end
    end

    local function HotkeySaveFunc(p)
        if p == LocalPlayer then
            for key, list in pairs(edits) do
                for meta, id in pairs(list) do
                    local pair = referencePair[id]
                    if pair then
                        frameWithKey[pair[1]][pair[2]] = nil
                    end
                    referencePair[id] = {key, meta}
                end
                frameWithKey[key] = list
            end
            edits = {}
            BlzFrameSetText(HotkeyMessage, "|cff00FF00Hotkeys saved|r")
        end
        SaveHotkeys(p)
    end

    local function ShowMenu(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(HotkeyMenu, true)
            BlzFrameSetEnable(HotkeyButton, false)
            AddButtonToEscStack(HotkeyExit)
            UpdateHotkeys()
        end
    end

    local function InitFrames()
        HotkeyButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(HotkeyButton, 3)
        OnClickEvent(HotkeyButton, ShowMenu)
        BlzFrameSetVisible(HotkeyButton, false)
        AddFrameToMenu(HotkeyButton)
        SetFrameHotkey(HotkeyButton, udg_HOTKEYS_HOTKEY)
        AddDefaultTooltip(HotkeyButton, "Hotkeys", "Edit the hotkeys of the UI.")

        BackdropHotkeyButton = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyButton", HotkeyButton, "", 0)
        BlzFrameSetAllPoints(BackdropHotkeyButton, HotkeyButton)
        BlzFrameSetTexture(BackdropHotkeyButton, udg_HOTKEY_BUTTON, 0, true)

        HotkeyMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.140000, 0.530000)
        BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, 0.660000, 0.190000)
        BlzFrameSetVisible(HotkeyMenu, false)

        HotkeyMessage = BlzCreateFrameByType("TEXT", "name", HotkeyMenu, "", 0)
        BlzFrameSetScale(HotkeyMessage, 1.00)
        BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.020000)
        BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.29000)
        BlzFrameSetText(HotkeyMessage, "")
        BlzFrameSetTextAlignment(HotkeyMessage, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        -- Backpack

        HotkeyBackpack = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.080000)
        BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.30000, 0.22000)
        BlzFrameSetText(HotkeyBackpack, "|cffFCD20DBackpack|r")
        OnClickEvent(HotkeyBackpack, HotkeyBackpackFunc)

        HotkeyBackpackSubMenu = BlzCreateFrameByType("BACKDROP", "BACKDROP", HotkeyMenu, "", 1)
        BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.030000)
        BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.050000)
        BlzFrameSetTexture(HotkeyBackpackSubMenu, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(HotkeyBackpackSubMenu, false)

        local HotkeyBackpackSubMenuBackdrop = BlzCreateFrame("EscMenuBackdrop", HotkeyBackpackSubMenu, 0, 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, 0.08500, -0.0100)
        BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.00500, 0.0100)

        local HotkeyBackpackSubMenuText = BlzCreateFrameByType("TEXT", "name", HotkeyBackpackSubMenuBackdrop, "", 0)
        BlzFrameSetScale(HotkeyBackpackSubMenuText, 1.00)
        BlzFrameSetPoint(HotkeyBackpackSubMenuText, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(HotkeyBackpackSubMenuText, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.18500)
        BlzFrameSetText(HotkeyBackpackSubMenuText, "Use an item")
        BlzFrameSetEnable(HotkeyBackpackSubMenuText, false)
        BlzFrameSetTextAlignment(HotkeyBackpackSubMenuText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        local HotkeyBackpackSubMenuDiscard = BlzCreateFrame("ScriptDialogButton", HotkeyBackpackSubMenuBackdrop, 0, 0)
        BlzFrameSetScale(HotkeyBackpackSubMenuDiscard, 0.858)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDiscard, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.095000, -0.19500)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDiscard, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.015000)
        BlzFrameSetText(HotkeyBackpackSubMenuDiscard, "|cffFCD20DDiscard|r")

        AsingHotkey(HotkeyBackpackSubMenuDiscard, 1)

        local HotkeyBackpackSubMenuDrop = BlzCreateFrame("ScriptDialogButton", HotkeyBackpackSubMenuBackdrop, 0, 0)
        BlzFrameSetScale(HotkeyBackpackSubMenuDrop, 0.858)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDrop, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.015000, -0.19500)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.015000)
        BlzFrameSetText(HotkeyBackpackSubMenuDrop, "|cffFCD20DDrop|r")

        AsingHotkey(HotkeyBackpackSubMenuDrop, 2)

        local x, y = {}, {}
        local stepSize = 0.0275

        local startY = -0.030000
        for row = 1, 6 do
            local startX = 0.015000
            for colum = 1, 5 do
                local index = 5 * (row - 1) + colum

                x[index] = startX
                y[index] = startY

                startX = startX + stepSize
            end
            startY = startY - stepSize
        end

        local indexes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47}
        for i = 1, udg_MAX_ITEMS do
            local HotkeyBackpackSubMenuItem = BlzCreateFrame("IconButtonTemplate", HotkeyBackpackSubMenuBackdrop, 0, 0)
            BlzFrameSetPoint(HotkeyBackpackSubMenuItem, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, x[i], y[i])
            BlzFrameSetSize(HotkeyBackpackSubMenuItem, stepSize, stepSize)

            local BackdropHotkeyBackpackSubMenuItem = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyBackpackSubMenuItem[" .. i .. "]", HotkeyBackpackSubMenuItem, "", 0)
            BlzFrameSetAllPoints(BackdropHotkeyBackpackSubMenuItem, HotkeyBackpackSubMenuItem)
            BlzFrameSetTexture(BackdropHotkeyBackpackSubMenuItem, udg_BACKPACK_EMPTY, 0, true)
            AsingHotkey(HotkeyBackpackSubMenuItem, indexes[i]) -- start in 3 and end in 19, then 34 to 41, then 43 to 47
        end

        -- Your digimons

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        for i = 0, 1 do
            for j = 0, 3 do
                local index = i + 2 * j
                x1[index] = 0.020000 + i * 0.05
                y1[index] = -0.040000 - j * 0.05
                x2[index] = -0.070000 + i * 0.05
                y2[index] = 0.19000 - j * 0.05
            end
        end

        HotkeyYourDigimons = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetPoint(HotkeyYourDigimons, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.040000)
        BlzFrameSetPoint(HotkeyYourDigimons, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.30000, 0.26000)
        BlzFrameSetText(HotkeyYourDigimons, "|cffFCD20DYour digimons|r")
        OnClickEvent(HotkeyYourDigimons, HotkeyYourDigimonsFunc)

        HotkeyYourDigimonsSubMenu = BlzCreateFrameByType("BACKDROP", "BACKDROP", HotkeyMenu, "", 1)
        BlzFrameSetPoint(HotkeyYourDigimonsSubMenu, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.030000)
        BlzFrameSetPoint(HotkeyYourDigimonsSubMenu, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.050000)
        BlzFrameSetTexture(HotkeyYourDigimonsSubMenu, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(HotkeyYourDigimonsSubMenu, false)

        local HotkeyYourDigimonsSubMenuBackdrop = BlzCreateFrame("EscMenuBackdrop", HotkeyYourDigimonsSubMenu, 0, 0)
        BlzFrameSetPoint(HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenu, FRAMEPOINT_TOPLEFT, 0.020000, 0.0000)
        BlzFrameSetSize(HotkeyYourDigimonsSubMenuBackdrop, 0.13, 0.27)

        indexes = {[0] = 21, 22, 23, 24, 25, 26, 27, 28}

        for i = 0, 7 do
            local DigimonT = BlzCreateFrame("ScriptDialogButton", HotkeyYourDigimonsSubMenuBackdrop, 0, 0)
            BlzFrameSetPoint(DigimonT, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(DigimonT, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            local BackdropDigimonT = BlzCreateFrameByType("BACKDROP", "HotkeyBackdropDigimonT[" .. i .. "]", DigimonT, "", 1)
            BlzFrameSetAllPoints(BackdropDigimonT, DigimonT)
            BlzFrameSetTexture(BackdropDigimonT, udg_BANK_EMPTY_BUTTON, 0, true)
            BlzFrameSetLevel(BackdropDigimonT, 1)
            --BlzFrameSetScale(DigimonT, 0.8)
            AsingHotkey(DigimonT, indexes[i])
        end

        local Text = BlzCreateFrameByType("TEXT", "name", HotkeyYourDigimonsSubMenuBackdrop, "", 0)
        BlzFrameSetPoint(Text, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.015000)
        BlzFrameSetPoint(Text, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.23500)
        BlzFrameSetText(Text, "|cffFFCC00Choose a Digimon|r")
        BlzFrameSetEnable(Text, false)
        BlzFrameSetTextAlignment(Text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        local Summon = BlzCreateFrame("ScriptDialogButton", HotkeyYourDigimonsSubMenuBackdrop,0,0)
        BlzFrameSetPoint(Summon, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
        BlzFrameSetPoint(Summon, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.065000, 0.010000)
        BlzFrameSetText(Summon, "|cffFCD20DSummon|r")
        AsingHotkey(Summon, 29)

        local Store = BlzCreateFrame("ScriptDialogButton", HotkeyYourDigimonsSubMenuBackdrop,0,0)
        BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.23500)
        BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.010000)
        BlzFrameSetText(Store, "|cffFCD20DStore|r")
        AsingHotkey(Store, 30)

        local Free = BlzCreateFrame("ScriptDialogButton", HotkeyYourDigimonsSubMenuBackdrop,0,0)
        BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.2600)
        BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.065000, -0.015000)
        BlzFrameSetText(Free, "|cffFCD20DFree|r")
        AsingHotkey(Free, 31)

        local Revive = BlzCreateFrame("ScriptDialogButton", HotkeyYourDigimonsSubMenuBackdrop,0,0)
        BlzFrameSetPoint(Revive, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.2600)
        BlzFrameSetPoint(Revive, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, -0.015000)
        BlzFrameSetText(Revive, "|cffFCD20DRevive|r")
        AsingHotkey(Revive, 42)

        local Warning = BlzCreateFrame("QuestButtonBaseTemplate", Free,0,0)
        BlzFrameSetPoint(Warning, FRAMEPOINT_TOPLEFT, Revive, FRAMEPOINT_TOPLEFT, 0.050000, 0.025000)
        BlzFrameSetPoint(Warning, FRAMEPOINT_BOTTOMRIGHT, Revive, FRAMEPOINT_BOTTOMRIGHT, 0.10000, -0.010000)

        local AreYouSure = BlzCreateFrameByType("TEXT", "name", Warning, "", 0)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.025000)
        BlzFrameSetText(AreYouSure, "|cffFFCC00Are you sure you wanna free this digimon?|r")
        BlzFrameSetTextAlignment(AreYouSure, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        local Yes = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetPoint(Yes, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.010000, -0.035000)
        BlzFrameSetPoint(Yes, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.0050000)
        BlzFrameSetText(Yes, "|cffFCD20DYes|r")
        AsingHotkey(Yes, 32)

        local No = BlzCreateFrame("ScriptDialogButton", Warning,0,0)
        BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
        BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
        BlzFrameSetText(No, "|cffFCD20DNo|r")
        AsingHotkey(No, 33)

        BlzFrameSetScale(HotkeyYourDigimonsSubMenuBackdrop, 0.9)


        HotkeyExit = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetScale(HotkeyExit, 1.00)
        BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.34000, -0.30000)
        BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.010000)
        BlzFrameSetText(HotkeyExit, "|cffFCD20DExit|r")
        OnClickEvent(HotkeyExit, HotkeyExitFunc)

        HotkeySave = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetScale(HotkeySave, 1.00)
        BlzFrameSetPoint(HotkeySave, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.10000, -0.30000)
        BlzFrameSetPoint(HotkeySave, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
        BlzFrameSetText(HotkeySave, "|cffFCD20DSave|r")
        OnClickEvent(HotkeySave, HotkeySaveFunc)
    end

    FrameLoaderAdd(InitFrames)

    OnInit.final(function ()
        local t = CreateTrigger()
        for k, v in pairs(_G) do
            if Debug.wc3Type(v) == "oskeytype" then
                ForForce(FORCE_PLAYING, function ()
                    if IsBannedKey(v) then
                        BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), v, 0, true)
                    else
                        for meta = 0, 15 do
                            BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), v, meta, true)
                        end
                    end
                end)
                oskeyName[v] = string.sub(k, 7)
                oskeyConverted[GetHandleId(v)] = v
                oskeyFromName[oskeyName[v]] = v
            end
        end
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                local key = BlzGetTriggerPlayerKey()
                local meta = BlzGetTriggerPlayerMetaKey()
                if selectingKey then
                    if IsBannedKey(key) then
                        BlzFrameSetText(HotkeyMessage, "|cffff0000Invalid key|r")
                    else
                        local frame = frames[frameSelected]
                        if frame then
                            selectingKey = false
                            if not edits[key] then
                                edits[key] = {}
                            end

                            local index = edits[key][meta] or (frameWithKey[key] and frameWithKey[key][meta])
                            if index then
                                BlzFrameSetText(hotkeyText[index], "")
                            end

                            edits[key][meta] = frameSelected

                            BlzFrameSetText(hotkeyText[frameSelected], ((meta ~= 0) and (OskeyMeta[meta] .. " + ") or "") .. oskeyName[key])
                            BlzFrameSetText(HotkeyMessage, "")
                        end
                        frameSelected = -1
                    end
                else
                    local id = frameWithKey[key] and frameWithKey[key][meta]
                    if id and frames[id] and BlzFrameIsVisible(frames[id]) and BlzFrameGetEnable(frames[id]) then
                        BlzFrameClick(frames[id])
                    end
                end
            end
        end)
    end)

    ---@param frame framehandle
    ---@param id integer
    function AssignFrame(frame, id)
        frames[id] = frame
        --referenceFrame[frame] = id
    end

    ---@param p player
    ---@param flag boolean
    function ShowHotkeys(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(HotkeyButton, flag)
        end
    end

    ---@param p player
    function SaveHotkeys(p)
        local savecode = Savecode.create()
        local length1 = 0
        for key, list in pairs(frameWithKey) do
            local length2 = 0
            for meta, id in pairs(list) do
                savecode:Encode(id, MAX_KEYS) -- save the id
                savecode:Encode(meta, 15) -- save the metakey
                length2 = length2 + 1
            end
            savecode:Encode(length2, 16) -- save the length of the metakey list
            savecode:Encode(GetHandleId(key), MAX_KEYS) -- save the key
            length1 = length1 + 1
        end
        savecode:Encode(length1, MAX_KEYS) -- save the length of the key list
        local save = savecode:Save(LocalPlayer, 1)

        if p == LocalPlayer then
            FileIO.Write(SaveFile.getPath2(p, "Hotkeys"), save)
        end
        savecode:destroy()
    end

    ---@param p player
    function LoadHotkeys(p)
        local loaded, code = pcall(GetSyncedData, p, FileIO.Read, SaveFile.getPath2(p, "Hotkeys"))

        if not loaded then
            print(GetPlayerName(p) .. " can't load its data.")
            return
        end

        if code:len() > 1 then
            local savecode = Savecode.create()
            if savecode:Load(p, code, 1) then
                local length1 = savecode:Decode(MAX_KEYS) -- load the length of the key list
                for _ = 1, length1 do
                    local key = oskeyConverted[savecode:Decode(MAX_KEYS)] -- load the key
                    if p == LocalPlayer then
                        frameWithKey[key] = {}
                    end
                    local length2 = savecode:Decode(16) -- load the length of the metakey list
                    for _ = 1, length2 do
                        local meta = savecode:Decode(15) -- load the metakey
                        local id  = savecode:Decode(MAX_KEYS) -- load the id
                        if p == LocalPlayer then
                            frameWithKey[key][meta] = id
                            referencePair[id] = {key, meta}
                        end
                    end
                end
                if p == LocalPlayer then
                    UpdateHotkeys()
                end
            end
            savecode:destroy()
        end
    end
end)
Debug.endFile()