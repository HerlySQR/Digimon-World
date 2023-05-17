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
        end
        return false
    end

    local oskeyName = {} ---@type table<oskeytype, string>

    -- These values are different for each player
    local LocalPlayer = GetLocalPlayer()
    local selectingKey = false
    local frames = {} ---@type table<integer, framehandle>
    local referenceFrame = {} ---@type table<framehandle, integer>
    local hotkeyText = {} ---@type table<integer, framehandle>
    local frameSelected = -1
    local frameWithKey = {} ---@type table<oskeytype, table<integer, integer>>
    local edits = {} ---@type table<oskeytype, table<integer, integer>>

    local HotkeyMenu = nil ---@type framehandle
    local HotkeyMessage = nil ---@type framehandle
    local HotkeyBackpackSubMenu = nil ---@type framehandle
    local HotkeyBackpack = nil ---@type framehandle
    local HotkeyExit = nil ---@type framehandle
    local HotkeySave = nil ---@type framehandle
    local HotkeyBackpackSubMenuBackdrop = nil ---@type framehandle
    local HotkeyBackpackSubMenuText = nil ---@type framehandle
    local HotkeyBackpackSubMenuDiscard = nil ---@type framehandle
    local HotkeyBackpackSubMenuDrop = nil ---@type framehandle
    local HotkeyBackpackSubMenuItem = {} ---@type framehandle
    local BackdropHotkeyBackpackSubMenuItem = {} ---@type framehandle
    local HotkeyBackpackSubMenuButton = nil ---@type framehandle
    local BackdropHotkeyBackpackSubMenuButton = nil ---@type framehandle

    local visibleMenu = nil ---@type framehandle

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

    local function SetHotkey()
        if GetTriggerPlayer() == LocalPlayer then
            local frame = BlzGetTriggerFrame()
            local id = referenceFrame[frame]
            if id and frames[id] then
                selectingKey = true
                frameSelected = id
                BlzFrameSetText(HotkeyMessage, "|cffFFCC00Press a key to set the hotkey|r")
            else
                BlzFrameSetText(HotkeyMessage, "|cffFF0000Error|r")
            end
        end
    end

    local trig = CreateTrigger()

    ---@param frame framehandle
    ---@param id integer
    local function AsingHotkey(frame, id)
        BlzTriggerRegisterFrameEvent(trig, frame, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(trig, SetHotkey)

        referenceFrame[frame] = id

        local text = BlzCreateFrameByType("TEXT", "name", frame, "", 0)
        BlzFrameSetAllPoints(text, frame)
        BlzFrameSetText(text, "")
        BlzFrameSetScale(text, 1)
        BlzFrameSetEnable(text, false)
        BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetLevel(text, 4)
        hotkeyText[id] = text
    end

    local function HotkeyBackpackFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(visibleMenu, false)
            BlzFrameSetVisible(HotkeyBackpackSubMenu, true)
            visibleMenu = HotkeyBackpackSubMenu
        end
    end

    local function HotkeyExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(HotkeyMenu, false)
            BlzFrameSetVisible(visibleMenu, false)
            selectingKey = false
            frameSelected = -1
            BlzFrameSetText(HotkeyMessage, "")
            edits = {}
        end
    end

    local function HotkeySaveFunc()
        if GetTriggerPlayer() == LocalPlayer then
            for k, v in pairs(edits) do
                frameWithKey[k] = v
            end
            edits = {}
            SaveHotkeys()
            BlzFrameSetText(HotkeyMessage, "|cff00FF00Hotkeys saved|r")
        end
    end

    local function InitFrames()
        local t = nil ---@type trigger
        local start = 0

        HotkeyMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.140000, 0.530000)
        BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, 0.660000, 0.190000)
        BlzFrameSetVisible(HotkeyMenu, false)

        HotkeyMessage = BlzCreateFrameByType("TEXT", "name", HotkeyMenu, "", 0)
        BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.020000)
        BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.29000)
        BlzFrameSetText(HotkeyMessage, "")
        BlzFrameSetScale(HotkeyMessage, 1.00)
        BlzFrameSetTextAlignment(HotkeyMessage, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        HotkeyBackpackSubMenu = BlzCreateFrameByType("BACKDROP", "BACKDROP", HotkeyMenu, "", 1)
        BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.030000)
        BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.050000)
        BlzFrameSetTexture(HotkeyBackpackSubMenu, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(HotkeyBackpackSubMenu, false)

        HotkeyBackpack = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.040000)
        BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.30000, 0.26000)
        BlzFrameSetText(HotkeyBackpack, "|cffFCD20DBackpack|r")
        BlzFrameSetScale(HotkeyBackpack, 1.)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, HotkeyBackpack, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, HotkeyBackpackFunc)

        HotkeyBackpackSubMenuBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", HotkeyBackpackSubMenu, 0, 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, 0.11000, -0.020000)
        BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.050000)

        HotkeyBackpackSubMenuButton = BlzCreateFrame("IconButtonTemplate", HotkeyBackpackSubMenu, 0, 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuButton, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.10000)
        BlzFrameSetPoint(HotkeyBackpackSubMenuButton, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.18000, 0.11000)
        AsingHotkey(HotkeyBackpackSubMenuButton, start) -- 0

        BackdropHotkeyBackpackSubMenuButton = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyBackpackSubMenuButton", HotkeyBackpackSubMenuButton, "", 0)
        BlzFrameSetAllPoints(BackdropHotkeyBackpackSubMenuButton, HotkeyBackpackSubMenuButton)
        BlzFrameSetTexture(BackdropHotkeyBackpackSubMenuButton, "ReplaceableTextures\\CommandButtons\\BTNBackpackIcon.blp", 0, true)

        HotkeyBackpackSubMenuText = BlzCreateFrameByType("TEXT", "name", HotkeyBackpackSubMenuBackdrop, "", 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuText, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.0050000)
        BlzFrameSetPoint(HotkeyBackpackSubMenuText, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.12000)
        BlzFrameSetText(HotkeyBackpackSubMenuText, "Use an item for the focused digimon")
        BlzFrameSetEnable(HotkeyBackpackSubMenuText, false)
        BlzFrameSetScale(HotkeyBackpackSubMenuText, 1.00)
        BlzFrameSetTextAlignment(HotkeyBackpackSubMenuText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        HotkeyBackpackSubMenuDiscard = BlzCreateFrame("ScriptDialogButton", HotkeyBackpackSubMenuBackdrop, 0, 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDiscard, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.090000, -0.19245)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDiscard, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0025500)
        BlzFrameSetText(HotkeyBackpackSubMenuDiscard, "|cffFCD20DDiscard|r")
        BlzFrameSetScale(HotkeyBackpackSubMenuDiscard, 0.858)
        start = start + 1
        AsingHotkey(HotkeyBackpackSubMenuDiscard, start) -- 1

        HotkeyBackpackSubMenuDrop = BlzCreateFrame("ScriptDialogButton", HotkeyBackpackSubMenuBackdrop, 0, 0)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDrop, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.19245)
        BlzFrameSetPoint(HotkeyBackpackSubMenuDrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.090000, 0.0025500)
        BlzFrameSetText(HotkeyBackpackSubMenuDrop, "|cffFCD20DDrop|r")
        BlzFrameSetScale(HotkeyBackpackSubMenuDrop, 0.858)
        start = start + 1
        AsingHotkey(HotkeyBackpackSubMenuDrop, start) -- 2

        local x, y = {}, {}
        local stepSize = 0.03

        local startY = -0.030000
        for row = 1, 4 do
            local startX = 0.010000
            for colum = 1, 4 do
                local index = 4 * (row - 1) + colum

                x[index] = startX
                y[index] = startY

                startX = startX + stepSize
            end
            startY = startY - stepSize
        end

        for i = 1, udg_MAX_ITEMS do
            HotkeyBackpackSubMenuItem[i] = BlzCreateFrame("IconButtonTemplate", HotkeyBackpackSubMenuBackdrop, 0, 0)
            BlzFrameSetPoint(HotkeyBackpackSubMenuItem[i], FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, x[i], y[i])
            BlzFrameSetSize(HotkeyBackpackSubMenuItem[i], stepSize, stepSize)

            BackdropHotkeyBackpackSubMenuItem[i] = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyBackpackSubMenuItem[" .. i .. "]", HotkeyBackpackSubMenuItem[i], "", 0)
            BlzFrameSetAllPoints(BackdropHotkeyBackpackSubMenuItem[i], HotkeyBackpackSubMenuItem[i])
            BlzFrameSetTexture(BackdropHotkeyBackpackSubMenuItem[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, HotkeyBackpackSubMenuItem[i], FRAMEEVENT_CONTROL_CLICK)
            start = start + 1
            AsingHotkey(HotkeyBackpackSubMenuItem[i], start) -- start in 3 and end in 19
        end

        HotkeyExit = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.34000, -0.30000)
        BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.010000)
        BlzFrameSetText(HotkeyExit, "|cffFCD20DExit|r")
        BlzFrameSetScale(HotkeyExit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, HotkeyExit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, HotkeyExitFunc)

        HotkeySave = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
        BlzFrameSetPoint(HotkeySave, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.10000, -0.30000)
        BlzFrameSetPoint(HotkeySave, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
        BlzFrameSetText(HotkeySave, "|cffFCD20DSave|r")
        BlzFrameSetScale(HotkeySave, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, HotkeySave, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, HotkeySaveFunc)
    end

    FrameLoaderAdd(InitFrames)

    OnInit.final(function ()
        local t = CreateTrigger()
        for k, v in pairs(_G) do
            if Debug.wc3Type(v) == "oskeytype" and not IsBannedKey(v) then
                ForForce(FORCE_PLAYING, function ()
                    for meta = 0, 15 do
                        BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), v, meta, true)
                    end
                end)
                oskeyName[v] = string.sub(k, 7)
            end
        end
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                local key = BlzGetTriggerPlayerKey()
                local meta = BlzGetTriggerPlayerMetaKey()
                if selectingKey then
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
                else
                    local id = frameWithKey[key] and frameWithKey[key][meta]
                    if id and frames[id] and BlzFrameIsVisible(frames[id]) then
                        BlzFrameClick(frames[id])
                    end
                end
            end
        end)

        t = CreateTrigger()
        ForForce(FORCE_PLAYING, function ()
            TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-hotkey", true)
        end)
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                BlzFrameSetVisible(HotkeyMenu, true)
                UpdateHotkeys()
            end
        end)

        ForForce(FORCE_PLAYING, function ()
            if GetEnumPlayer() == LocalPlayer then
                LoadHotkeys()
            end
        end)
    end)

    function AssignFrame(frame, id)
        frames[id] = frame
        referenceFrame[frame] = id
    end

    ---Use this function in a `if player == GetLocalPlayer() then` block
    function SaveHotkeys()
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

        FileIO.Write(SaveFile.getFolder() .. "\\Hotkeys.pld", savecode:Save(LocalPlayer, 1))
        savecode:destroy()
    end

    ---Use this function in a `if player == GetLocalPlayer() then` block
    function LoadHotkeys()
        local load = FileIO.Read(SaveFile.getFolder() .. "\\Hotkeys.pld")
        if load:len() > 1 then
            local savecode = Savecode.create()
            if savecode:Load(LocalPlayer, load, 1) then
                local length1 = savecode:Decode(MAX_KEYS) -- load the length of the key list
                for _ = 1, length1 do
                    local key = ConvertOsKeyType(savecode:Decode(MAX_KEYS)) -- load the key
                    frameWithKey[key] = {}
                    local length2 = savecode:Decode(16) -- load the length of the metakey list
                    for _ = 1, length2 do
                        local meta = savecode:Decode(15) -- load the metakey
                        local id  = savecode:Decode(MAX_KEYS) -- load the id
                        frameWithKey[key][meta] = id
                    end
                end
                UpdateHotkeys()
                print("Hotkeys loaded")
            end
            savecode:destroy()
        end
    end
end)
Debug.endFile()