Debug.beginFile("Menu")
OnInit("Menu", function ()
    Require "AddHook"

    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local DefaultHeight = BlzFrameGetHeight(Console)
    local MenuStack = {} ---@type framehandle[]
    --local HideSimpleFrame = nil ---@type framehandle
    local prevCamera = {} ---@type{targetX: number, targetY: number, targetZ: number, eyeX: number, eyeY: number, eyeZ: number, targetDistance: number, farZ: number, angleOfAttack: number, fieldOfView: number, roll: number, rotation: number, zOffset: number, nearZ: number, localPitch: number, localYaw: number, localRoll: number}
    local selectedUnits = {} ---@type table<player, group>

    ---@param showOriginFrames boolean?
    function ShowMenu(showOriginFrames)
        for i, frame in ipairs(Frames) do
            BlzFrameSetVisible(frame, WasVisible[i])
        end
        if showOriginFrames then
            BlzHideOriginFrames(false)
            BlzFrameSetSize(Console, 0, DefaultHeight)
        end
    end

    ---@param hideOriginFrames boolean?
    function HideMenu(hideOriginFrames)
        for i, frame in ipairs(Frames) do
            WasVisible[i] = BlzFrameIsVisible(frame)
            BlzFrameSetVisible(frame, false)
        end
        if hideOriginFrames then
            ClearSelection()
            BlzHideOriginFrames(true)
            BlzFrameSetSize(Console, 0, 0.0001)
        end
    end

    ---@param frame framehandle
    function AddFrameToMenu(frame)
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
        BlzFrameSetAbsPoint(text, FRAMEPOINT_BOTTOMRIGHT, 0.790000, 0.18500)
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

end)
Debug.endFile()