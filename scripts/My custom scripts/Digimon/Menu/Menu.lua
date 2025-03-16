Debug.beginFile("Menu")
OnInit("Menu", function ()
    Require "AddHook"
    Require "Timed"
    Require "FrameLoader"
    Require "EventListener"
    Require "GameStatus"

    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local MenuStack = {} ---@type framehandle[]
    --local HideSimpleFrame = nil ---@type framehandle
    local prevCamera = {} ---@type{targetX: number, targetY: number, targetZ: number, eyeX: number, eyeY: number, eyeZ: number, targetDistance: number, farZ: number, angleOfAttack: number, fieldOfView: number, roll: number, rotation: number, zOffset: number, nearZ: number, localPitch: number, localYaw: number, localRoll: number}
    local selectedUnits = {} ---@type table<player, group>

    local UpperButton = nil ---@type framehandle
    local ResourceBar = nil ---@type framehandle
    local Clock = nil ---@type framehandle
    local Minimap = nil ---@type framehandle
    local MinimapBackDrop = nil ---@type framehandle
    local HeroBar = nil ---@type framehandle
    local HeroButton = {} ---@type framehandle[]
    local HeroHealth = {} ---@type framehandle[]
    local HeroMana = {} ---@type framehandle[]
    local CommandButtonBackDrop = nil ---@type framehandle
    local CommandButton = {} ---@type framehandle[]
    local TopbarBackdrop = nil ---@type framehandle
    local TextLength = nil ---@type framehandle

    local onChangeDimensions = EventListener.create()
    local windowWidth = 1400
    local windowHeight = 900
    local minX, maxX = 0., 0.8

    local ignore = {} ---@type table<integer, boolean>
    local isIgnored = false

    local onLeaderboard = EventListener.create()
    local onSelectedUnit = EventListener.create()

    local function check()
        local width = BlzGetLocalClientWidth()
        local height = BlzGetLocalClientHeight()
        if (width ~= windowWidth and width ~= 0) or (height ~= windowHeight and height ~= 0) then
            windowWidth = width
            windowHeight = height

            local extraWidth = ((windowWidth/windowHeight * 0.6) - 0.8) / 2
            minX, maxX = -extraWidth, 0.8+extraWidth

            onChangeDimensions:run()
        end
    end

    check()
    OnInit.final(check)
    Timed.echo(0.1, check)

    OnInit.final(function ()
        CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, "")
        BlzFrameSetSize(BlzGetFrameByName("Leaderboard", 0), 0, 0)
        BlzFrameSetVisible(BlzGetFrameByName("LeaderboardBackdrop", 0), false)
        BlzFrameSetVisible(BlzGetFrameByName("LeaderboardTitle", 0), false)
        onLeaderboard:run()
    end)

    ---@return number
    function GetMinScreenX()
        return minX
    end

    ---@return number
    function GetMaxScreenX()
        return maxX
    end

    local onFrameChangeVisible = EventListener.create()

    ---@param func fun(frame: framehandle, flag: boolean)
    function OnFrameChangeVisible(func)
        onFrameChangeVisible:register(func)
    end

    local oldFrameSetVisible
    oldFrameSetVisible = AddHook("BlzFrameSetVisible", function (frame, flag)
        for i, f in ipairs(Frames) do
            if frame == f then
                WasVisible[i] = flag
                break
            end
        end
        oldFrameSetVisible(frame, flag)
        onFrameChangeVisible:run(frame, flag)
    end)

    ---@param showOriginFrames boolean?
    function ShowMenu(showOriginFrames)
        for i, frame in ipairs(Frames) do
            oldFrameSetVisible(frame, WasVisible[i])
        end
        if showOriginFrames then
            oldFrameSetVisible(UpperButton, true)
            oldFrameSetVisible(ResourceBar, true)
            oldFrameSetVisible(Clock, true)
            oldFrameSetVisible(TopbarBackdrop, true)
            oldFrameSetVisible(Minimap, true)
            oldFrameSetVisible(MinimapBackDrop, true)
            oldFrameSetVisible(HeroBar, true)
            oldFrameSetVisible(CommandButtonBackDrop, true)
        end
    end

    ---@param hideOriginFrames boolean?
    function HideMenu(hideOriginFrames)
        for i, frame in ipairs(Frames) do
            WasVisible[i] = BlzFrameIsVisible(frame)
            oldFrameSetVisible(frame, false)
        end
        if hideOriginFrames then
            ClearSelection()
            oldFrameSetVisible(UpperButton, false)
            oldFrameSetVisible(ResourceBar, false)
            oldFrameSetVisible(Clock, false)
            oldFrameSetVisible(TopbarBackdrop, false)
            oldFrameSetVisible(Minimap, false)
            oldFrameSetVisible(MinimapBackDrop, false)
            oldFrameSetVisible(HeroBar, false)
            oldFrameSetVisible(CommandButtonBackDrop, false)
        end
    end

    ---@param frame framehandle
    function AddFrameToMenu(frame)
        assert(frame, "You are adding a nil frame to the menu")
        table.insert(Frames, frame)
        WasVisible[#Frames] = BlzFrameIsVisible(frame)
    end

    ---@param frame framehandle
    function AddButtonToEscStack(frame)
        table.insert(MenuStack, frame)
    end

    ---@param frame framehandle
    function RemoveButtonFromEscStack(frame)
        for i = #MenuStack, 1, -1 do
            if MenuStack[i] == frame then
                table.remove(MenuStack, i)
                break
            end
        end
    end

    if not BlzLoadTOCFile("Templates.toc") then
        print("Loading Templates Toc file failed")
    end

    ---@param frame framehandle
    ---@param title string
    ---@param content string
    function AddDefaultTooltip(frame, title, content)
        local tooltip = BlzCreateFrame("BoxedText", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        local text = BlzGetFrameByName("BoxedTextValue", 0)

        BlzFrameSetText(BlzGetFrameByName("BoxedTextTitle", 0), title .. " (" .. GetFrameHotkey(frame) .. ")")

        BlzFrameSetTextSizeLimit(text, content:len())
        BlzFrameSetText(text, content)
        BlzFrameSetSize(text, 0.25, 0)
        BlzFrameSetAbsPoint(text, FRAMEPOINT_BOTTOMLEFT, 0.01000, 0.18500)
        BlzFrameSetPoint(tooltip,FRAMEPOINT_TOPLEFT, text, FRAMEPOINT_TOPLEFT, -0.01, 0.025)
        BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, text, FRAMEPOINT_BOTTOMRIGHT, 0.01, -0.01)

        BlzFrameSetTooltip(frame, tooltip)
    end

    OnInit.final(function ()
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerEvent(t, GetEnumPlayer(), EVENT_PLAYER_END_CINEMATIC)
            selectedUnits[GetEnumPlayer()] = CreateGroup()
        end)
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                local frame = MenuStack[#MenuStack]
                if frame then
                    BlzFrameClick(frame)
                end
            end
        end)

        --[[HideSimpleFrame = BlzCreateFrameByType("SIMPLEFRAME", "HideSimpleFrame", BlzGetFrameByName("ConsoleUI", 0), "", 0)
        -- Warcraft 3 V1.31
        BlzFrameSetParent(BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, 0)), HideSimpleFrame)
        -- Current has access by Name for it (Parent hierachy is a little bit different from V1.31)
        BlzFrameSetParent(BlzGetFrameByName("CommandBarFrame", 0), HideSimpleFrame)
        AddFrameToMenu(HideSimpleFrame)]]
    end)

    function SaveCameraSetup()
        prevCamera.targetX = GetCameraTargetPositionX()
        prevCamera.targetY = GetCameraTargetPositionY()
        prevCamera.targetZ = GetCameraTargetPositionZ()
        prevCamera.targetDistance = GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
        prevCamera.farZ = GetCameraField(CAMERA_FIELD_FARZ)
        prevCamera.angleOfAttack = math.deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
        --prevCamera.fieldOfView = GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
        prevCamera.zOffset = GetCameraField(CAMERA_FIELD_ZOFFSET)
        prevCamera.nearZ = GetCameraField(CAMERA_FIELD_NEARZ)
    end

    function RestartToPreviousCamera()
        ResetToGameCamera(0)
        PanCameraToTimedWithZ(prevCamera.targetX, prevCamera.targetY, prevCamera.targetZ, 0)
        SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, prevCamera.targetDistance, 0)
        SetCameraField(CAMERA_FIELD_FARZ, prevCamera.farZ, 0)
        SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, prevCamera.angleOfAttack, 0)
        --SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, prevCamera.fieldOfView, 0)
        SetCameraField(CAMERA_FIELD_ZOFFSET, prevCamera.zOffset, 0)
        SetCameraField(CAMERA_FIELD_NEARZ, prevCamera.nearZ, 0)
    end

    ---@return {[1]: number, [2]: number}
    function GetSavedCameraTarget()
        return {prevCamera.targetX, prevCamera.targetY}
    end

    ---@param p player
    function SaveSelectedUnits(p)
        SyncSelections()
        GroupEnumUnitsSelected(selectedUnits[p], p)
    end

    ---@param p player
    function RestartSelectedUnits(p)
        ForGroup(selectedUnits[p], function ()
            if p == LocalPlayer then
                SelectUnit(GetEnumUnit(), true)
            end
        end)
        GroupClear(selectedUnits[p])
    end

    ---@param u unit
    ---@param p player
    ---@return boolean
    function IsUnitSelectionSaved(u, p)
        return IsUnitInGroup(u, selectedUnits[p])
    end

    local oldIsUnitSelected
    oldIsUnitSelected = AddHook("IsUnitSelected", function (u, p)
        return oldIsUnitSelected(u, p) or IsUnitSelectionSaved(u, p)
    end)

    FrameLoaderAdd(function ()
        local frame ---@type framehandle 

        BlzEnableUIAutoPosition(false)

        -- Reforged 2.0 Fix
        TopbarBackdrop = BlzGetFrameByName("ConsoleTopBar", 0)
        BlzFrameSetVisible(TopbarBackdrop, false)
        BlzFrameSetParent(BlzGetFrameByName("CommandBarFrame", 0), BlzGetFrameByName("ConsoleUI", 0))
        BlzFrameSetParent(BlzFrameGetParent(BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0)), BlzGetFrameByName("ConsoleUI", 0))
        BlzFrameSetParent(BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP , 0), BlzGetFrameByName("ConsoleUI", 0))
        BlzFrameSetVisible(BlzGetFrameByName("ConsoleBottomBar", 0), false)

        -- Hide bottom-center black backdrop
        BlzFrameSetSize(Console, 0.0001, 0.0001)
        -- Show Quests/Menu/Chat/Allies buttons
        UpperButton = BlzGetFrameByName("UpperButtonBarFrame", 0)
        BlzFrameSetVisible(frame, true)
        -- Show Gold/Lumber/Food/Upkeep labels
        ResourceBar = BlzGetFrameByName("ResourceBarFrame", 0)
        BlzFrameSetVisible(frame, true)
        -- Hide Upkeep label
        BlzFrameSetAbsPoint(BlzGetFrameByName("ResourceBarUpkeepText", 0), FRAMEPOINT_TOPRIGHT, 999, 999)
        -- Show day clock
        Clock = BlzFrameGetChild(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 5),0)
        BlzFrameSetVisible(Clock, true)

        --[[TopbarBackdrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(TopbarBackdrop, FRAMEPOINT_TOPLEFT, -0.0150000, 0.670000)
        BlzFrameSetAbsPoint(TopbarBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.815000, 0.565000)]]

        -- Hide map buttons
        for i = 0, 4 do
            BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP_BUTTON, i), false)
        end
        -- Move minimap
        MinimapBackDrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_TOPLEFT, minX, 0.180000)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_BOTTOMRIGHT, minX + 0.18, 0.00000)

        Minimap = BlzGetFrameByName("MiniMapFrame", 0)
        BlzFrameSetParent(Minimap, MinimapBackDrop)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_TOPRIGHT, minX + 0.165, 0.165000)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_BOTTOMLEFT, minX + 0.015, 0.015000)
        BlzFrameSetVisible(Minimap, true)

        CommandButtonBackDrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, minX + 0.18, 0.180000)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, minX + 0.41, 0.00000)

        -- Hide portrait
        BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0), false)

        -- Hide inventory
        frame = BlzFrameGetParent(BlzFrameGetParent(BlzGetFrameByName("InventoryButton_0", 0)))
        BlzFrameSetVisible(frame, true)
        BlzFrameSetSize(frame, 0.0001, 0.0001)

        frame = BlzGetFrameByName("InventoryCoverTexture", 0)
        BlzFrameSetSize(frame, 0.0001, 0.0001)

        -- Move Hero buttons
        HeroBar = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0)
        BlzFrameSetVisible(HeroBar, true)
        BlzFrameSetAbsPoint(HeroBar, FRAMEPOINT_TOPLEFT, minX + 0.41, 0.16000)

        -- Move Hero Health/Mana bars
        for i = 0, 2 do
            HeroButton[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)
            BlzFrameClearAllPoints(HeroButton[i])
            BlzFrameSetPoint(HeroButton[i], FRAMEPOINT_TOPLEFT, HeroBar, FRAMEPOINT_TOPLEFT, 0.000000, -0.05*i)

            HeroHealth[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, i)
            BlzFrameClearAllPoints(HeroHealth[i])
            BlzFrameSetPoint(HeroHealth[i], FRAMEPOINT_TOPLEFT, HeroButton[i], FRAMEPOINT_TOPRIGHT, 0.010000, 0.00000)
            BlzFrameSetSize(HeroHealth[i], 0.1, 0.01)

            HeroMana[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, i)
            BlzFrameSetSize(HeroMana[i], 0.1, 0.01)
        end

        -- Hide buff bar and label
        frame = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR, 0)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMRIGHT, 999, 999)

        frame = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL, 0)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_CENTER, 999, 999)

        -- Hide multiple unit selection frame
        Timed.call(function ()
            local p
            for i = 0, bj_MAX_PLAYERS - 1 do
                p = Player(i)
                if IsPlayerInGame(p) then
                    break
                end
            end
            local u = CreateUnit(p, FourCC('hpea'), 0, 0, 0)
            SelectUnitForPlayerSingle(u, Player(0))
            RemoveUnit(u)

            onSelectedUnit:run()

            local unitFrame = BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0) ---@type framehandle
            local bottomCenterUI = BlzFrameGetParent(unitFrame) ---@type framehandle
            local groupFrame = BlzFrameGetChild(bottomCenterUI, 5) ---@type framehandle
            local buttonContainerFrame = BlzFrameGetChild(groupFrame, 0) ---@type framehandle
            for i = 0, 11 do
                BlzFrameSetAbsPoint(BlzFrameGetChild(buttonContainerFrame, i), FRAMEPOINT_TOPLEFT, 999., 999.)
            end

            -- Move unit command buttons

            for i = 0, 2 do
                for j = 0, 3 do
                    local index = i*4+j
                    CommandButton[index] = BlzGetFrameByName("CommandButton_" .. index, 0)
                    BlzFrameSetAbsPoint(CommandButton[index], FRAMEPOINT_TOPLEFT, minX + 0.2 + 0.05*j, 0.16 - 0.05*i)
                    BlzFrameSetSize(CommandButton[index], 0.05, 0.05)
                end
            end
        end)

        -- Move tooltip frame
        frame = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMLEFT, 0.0000, 0.180000)

        -- Hide Mouse Dead Zone at Command Bar
        BlzFrameSetVisible(BlzFrameGetChild(BlzGetFrameByName("ConsoleUI", 0), 5), false)

        -- Show and move Item on ground info
        Timed.echo(0.02, function ()
            local f = BlzGetFrameByName("SimpleInfoPanelItemDetail", 3)
            if f then
                BlzFrameClearAllPoints(f)
                BlzFrameSetPoint(f, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.02, -0.04)
                BlzFrameSetSize(f, 0.188125, 0.1140625)
                BlzFrameSetVisible(f, true)
                return true
            end
        end)

        -- To get text length
        TextLength = BlzCreateFrameByType("TEXT", "name", Console, "", 0)
        BlzFrameSetVisible(TextLength, false)
    end)

    local rightButtons = {} ---@type framehandle[]
    local maxIndex = 0

    ---@param frame framehandle
    ---@param index integer
    function AddButtonToTheRight(frame, index)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_TOPLEFT, maxX - 0.05, 0.535000 - index * 0.045)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMRIGHT, maxX - 0.005, 0.495000 - index * 0.045)
        rightButtons[index] = frame
        if index > maxIndex then
            maxIndex = index
        end
    end

    onChangeDimensions:register(function ()
        for i = 0, maxIndex do
            if rightButtons[i] then
                BlzFrameClearAllPoints(rightButtons[i])
                BlzFrameSetAbsPoint(rightButtons[i], FRAMEPOINT_TOPLEFT, maxX - 0.05, 0.535000 - i * 0.045)
                BlzFrameSetAbsPoint(rightButtons[i], FRAMEPOINT_BOTTOMRIGHT, maxX - 0.005, 0.495000 - i * 0.045)
            end
        end

        BlzFrameClearAllPoints(MinimapBackDrop)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_TOPLEFT, minX, 0.180000)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_BOTTOMRIGHT, minX + 0.18, 0.00000)

        BlzFrameClearAllPoints(Minimap)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_TOPRIGHT, minX + 0.165, 0.165000)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_BOTTOMLEFT, minX + 0.015, 0.015000)

        BlzFrameClearAllPoints(CommandButtonBackDrop)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, minX + 0.18, 0.180000)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, minX + 0.41, 0.00000)

        if not isIgnored then
            for i = 0, 2 do
                for j = 0, 3 do
                    local index = i*4+j
                    BlzFrameClearAllPoints(CommandButton[index])
                    BlzFrameSetAbsPoint(CommandButton[index], FRAMEPOINT_TOPLEFT, minX + 0.2 + 0.05*j, 0.16 - 0.05*i)
                    BlzFrameSetSize(CommandButton[index], 0.05, 0.05)
                end
            end
        end

        BlzFrameClearAllPoints(HeroBar)
        BlzFrameSetAbsPoint(HeroBar, FRAMEPOINT_TOPLEFT, minX + 0.41, 0.16000)
    end)

    local oldSelectUnit
    oldSelectUnit = AddHook("SelectUnit", function (whichUnit, flag)
        if ignore[GetUnitTypeId(whichUnit)] then
            isIgnored = true
            for i = 0, 11 do
                BlzFrameClearAllPoints(CommandButton[i])
                BlzFrameSetAbsPoint(CommandButton[i], FRAMEPOINT_TOPLEFT, 0.40000, 0.90000)
            end
        else
            isIgnored = false
            for i = 0, 2 do
                for j = 0, 3 do
                    local index = i*4+j
                    BlzFrameClearAllPoints(CommandButton[index])
                    BlzFrameSetAbsPoint(CommandButton[index], FRAMEPOINT_TOPLEFT, minX + 0.2 + 0.05*j, 0.16 - 0.05*i)
                end
            end
        end
        oldSelectUnit(whichUnit, flag)
    end)

    ---@param s string
    ---@return number
    function GetStringFrameLength(s)
        BlzFrameSetText(TextLength, s)
        BlzFrameSetSize(TextLength, 0, 0.01)
        return BlzFrameGetWidth(TextLength)
    end

    --[[local t = CreateTrigger()
    for i = 0, bj_MAX_PLAYERS do
        TriggerRegisterPlayerSelectionEventBJ(t, Player(i), true)
    end
    TriggerAddAction(t, function ()
        if GetTriggerPlayer() == GetLocalPlayer() then
            if ignore[GetUnitTypeId(GetTriggerUnit())] then
                for i = 0, 11 do
                    BlzFrameSetAbsPoint(CommandButton[i], FRAMEPOINT_TOPLEFT, 0.40000, 0.90000)
                end
            else
                for i = 0, 2 do
                    for j = 0, 3 do
                        BlzFrameSetAbsPoint(CommandButton[i], FRAMEPOINT_TOPLEFT, 0.320000 + 0.05*j, 0.160000 - 0.05*i)
                    end
                end
            end
        end
    end)]]

    ---@param uType integer
    function IgnoreCommandButton(uType)
        ignore[uType] = true
    end

    ---@param func function
    function OnChangeDimensions(func)
        onChangeDimensions:register(func)
    end

    ---@param func function
    function OnLeaderboard(func)
        onLeaderboard:register(function ()
            FrameLoaderAdd(func)
        end)
    end

    ---@param func function
    function OnSelectedUnit(func)
        onSelectedUnit:register(function ()
            FrameLoaderAdd(func)
        end)
    end

end)
Debug.endFile()