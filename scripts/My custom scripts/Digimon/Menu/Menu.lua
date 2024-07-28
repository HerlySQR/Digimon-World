Debug.beginFile("Menu")
OnInit("Menu", function ()
    Require "AddHook"
    Require "Timed"
    Require "FrameLoader"

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
    local HeroHealth = {} ---@type framehandle[]
    local HeroMana = {} ---@type framehandle[]
    local CommandButtonBackDrop = nil ---@type framehandle
    local CommandButton = {} ---@type framehandle[]
    local InventoryButtonBackDrop = nil ---@type framehandle
    local InventoryButton = {} ---@type framehandle[]

    local oldFrameSetVisible
    oldFrameSetVisible = AddHook("BlzFrameSetVisible", function (frame, flag)
        for i, f in ipairs(Frames) do
            if frame == f then
                WasVisible[i] = flag
                break
            end
        end
        oldFrameSetVisible(frame, flag)
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
            oldFrameSetVisible(Minimap, true)
            oldFrameSetVisible(MinimapBackDrop, true)
            oldFrameSetVisible(HeroBar, true)
            oldFrameSetVisible(CommandButtonBackDrop, true)
            oldFrameSetVisible(InventoryButtonBackDrop, true)
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
            oldFrameSetVisible(Minimap, false)
            oldFrameSetVisible(MinimapBackDrop, false)
            oldFrameSetVisible(HeroBar, false)
            oldFrameSetVisible(CommandButtonBackDrop, false)
            oldFrameSetVisible(InventoryButtonBackDrop, false)
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

        BlzFrameSetText(BlzGetFrameByName("BoxedTextTitle", 0), title)

        BlzFrameSetText(text, content)
        BlzFrameSetSize(text, 0.25, 0)
        BlzFrameSetAbsPoint(text, FRAMEPOINT_TOPLEFT, 0.01000, 0.54500)
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

        BlzHideOriginFrames(true)

        -- Hide bottom-center black backdrop
        BlzFrameSetSize(Console, 0.0001, 0.0001)
        -- Show Quests/Menu/Chat/Allies buttons
        UpperButton = BlzGetFrameByName("UpperButtonBarFrame", 0)
        BlzFrameSetVisible(frame, true)
        -- Show Gold/Lumber/Food/Upkeep labels
        ResourceBar = BlzGetFrameByName("ResourceBarFrame", 0)
        BlzFrameSetVisible(frame, true)
        -- Hide Upkeep label
        BlzFrameSetAbsPoint(BlzGetFrameByName("ResourceBarUpkeepText", 0), FRAMEPOINT_TOPRIGHT, 0.4, 0.9)
        -- Show day clock
        Clock = BlzFrameGetChild(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 5),0)
        BlzFrameSetVisible(Clock, true)

        -- Move Hero buttons
        HeroBar = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BAR, 0)
        BlzFrameSetVisible(HeroBar, true)
        BlzFrameSetAbsPoint(HeroBar, FRAMEPOINT_TOPLEFT, 0.095000, 0.155000)

        -- Move minimap
        MinimapBackDrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_TOPLEFT, -0.080000, 0.170000)
        BlzFrameSetAbsPoint(MinimapBackDrop, FRAMEPOINT_BOTTOMRIGHT, 0.09000, 0.00000)

        Minimap = BlzGetFrameByName("MiniMapFrame", 0)
        BlzFrameSetParent(Minimap, MinimapBackDrop)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_TOPRIGHT, 0.075000, 0.155000)
        BlzFrameSetAbsPoint(Minimap, FRAMEPOINT_BOTTOMLEFT, -0.065000, 0.015000)
        BlzFrameSetVisible(Minimap, true)

        -- Move Hero Health/Mana bars
        for i = 0, 2 do
            HeroHealth[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_HP_BAR, i)
            BlzFrameClearAllPoints(HeroHealth[i])
            BlzFrameSetPoint(HeroHealth[i], FRAMEPOINT_TOPLEFT, BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i), FRAMEPOINT_TOPLEFT, 0.050000, -0.010000)
            BlzFrameSetSize(HeroHealth[i], 0.15, 0.01)

            HeroMana[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_MANA_BAR, i)
            BlzFrameSetSize(HeroMana[i], 0.15, 0.01)
        end

        -- Move unit command buttons
        CommandButtonBackDrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.30000, 0.180000)
        BlzFrameSetAbsPoint(CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, 0.53000, 0.00000)

        for i = 0, 2 do
            for j = 0, 3 do
                CommandButton[i] = BlzGetFrameByName("CommandButton_" .. (i*4+j), 0)
                BlzFrameSetAbsPoint(CommandButton[i], FRAMEPOINT_TOPLEFT, 0.320000 + 0.05*j, 0.160000 - 0.05*i)
                BlzFrameSetSize(CommandButton[i], 0.05, 0.05)
            end
        end

        -- Move inventory
        InventoryButtonBackDrop = BlzCreateFrame("EscMenuBackdrop", Console, 0, 0)
        BlzFrameSetAbsPoint(InventoryButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.53500, 0.14500)
        BlzFrameSetAbsPoint(InventoryButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, 0.637500, 0.005000)

        frame = BlzFrameGetParent(BlzFrameGetParent(BlzGetFrameByName("InventoryButton_0", 0)))
        BlzFrameSetVisible(frame, true)
        BlzFrameSetSize(frame, 0.0001, 0.0001)

        frame = BlzGetFrameByName("InventoryCoverTexture", 0)
        BlzFrameSetSize(frame, 0.0001, 0.0001)

        for i = 0, 2 do
            for j = 0, 1 do
                InventoryButton[i] = BlzGetFrameByName("InventoryButton_" .. (i*2+j), 0)
                BlzFrameSetAbsPoint(InventoryButton[i], FRAMEPOINT_TOPLEFT, 0.550000 + 0.04*j, 0.130000 - 0.04*i)
                BlzFrameSetSize(InventoryButton[i], 0.04, 0.04)
            end
        end

        -- Hide buff bar and label
        frame = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR, 0)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMRIGHT, 0.4, 0.9)

        frame = BlzGetOriginFrame(ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL, 0)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_CENTER, 0.1, 0.9)

        -- Move multiple unit selection frame
        Timed.call(function ()
            local u = CreateUnit(Player(0), FourCC('hpea'), 0, 0, 0)
            SelectUnitForPlayerSingle(u, Player(0))
            RemoveUnit(u)

            local unitFrame = BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0) ---@type framehandle 
            local bottomCenterUI = BlzFrameGetParent(unitFrame) ---@type framehandle 
            local groupFrame = BlzFrameGetChild(bottomCenterUI, 5) ---@type framehandle 
            local buttonContainerFrame = BlzFrameGetChild(groupFrame, 0) ---@type framehandle 
            for i = 0, 11 do
                BlzFrameSetAbsPoint(BlzFrameGetChild(buttonContainerFrame, i), FRAMEPOINT_TOPLEFT, 0.30 + 0.03*i, 0.22)
            end
        end)

        -- Move tooltip frame
        frame = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_TOPLEFT, 0.0000, 0.57000)

        -- Hide Mouse Dead Zone at Command Bar
        BlzFrameSetVisible(BlzFrameGetChild(BlzGetFrameByName("ConsoleUI", 0), 5), false)
    end)

    ---@param frame framehandle
    ---@param index integer
    function AddButtonToTheRight(frame, index)
        BlzFrameClearAllPoints(frame)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_TOPLEFT, 0.83500, 0.535000 - index * 0.045)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMRIGHT, 0.87500, 0.495000 - index * 0.045)
    end

    local ignore = {} ---@type table<integer, boolean>

    local oldSelectUnit
    oldSelectUnit = AddHook("SelectUnit", function (whichUnit, flag)
        if ignore[GetUnitTypeId(whichUnit)] then
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
        oldSelectUnit(whichUnit, flag)
    end)

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

end)
Debug.endFile()