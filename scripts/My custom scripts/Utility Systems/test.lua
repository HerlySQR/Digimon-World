Debug.beginFile("test")
OnInit(function ()
    Require "GetSyncedData"

    local t = CreateTrigger()
    ForForce(bj_FORCE_ALL_PLAYERS, function ()
        TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-caminfo", true)
    end)
    TriggerAddAction(t, function ()
        -- To be sure that it works for multiple threads being runned at the same time
        for i = 0, 2 do
            TimerStart(CreateTimer(), 0.01, false, function ()
                coroutine.resume(coroutine.create(function ()
                    local p = Player(i)
                    local empty = {}
                    local data = GetSyncedData(p, {
                        GetCameraBoundMaxX, empty, GetCameraBoundMaxY, empty, GetCameraBoundMinX, empty, GetCameraBoundMinY, empty,
                        GetCameraEyePositionX, empty, GetCameraEyePositionY, empty, GetCameraEyePositionZ, empty,
                        GetCameraTargetPositionX, empty, GetCameraTargetPositionY, empty, GetCameraTargetPositionZ, empty,
                        GetCameraMargin, {CAMERA_MARGIN_TOP}, GetCameraMargin, {CAMERA_MARGIN_RIGHT}, GetCameraMargin, {CAMERA_MARGIN_BOTTOM}, GetCameraMargin, {CAMERA_MARGIN_LEFT},
                        GetCameraField, {CAMERA_FIELD_TARGET_DISTANCE},
                        GetCameraField, {CAMERA_FIELD_ANGLE_OF_ATTACK},
                        GetCameraField, {CAMERA_FIELD_NEARZ},
                        GetCameraField, {CAMERA_FIELD_FARZ},
                        GetCameraField, {CAMERA_FIELD_FIELD_OF_VIEW},
                        GetCameraField, {CAMERA_FIELD_LOCAL_PITCH},
                        GetCameraField, {CAMERA_FIELD_LOCAL_ROLL},
                        GetCameraField, {CAMERA_FIELD_LOCAL_YAW}
                    })

                    local finalField1 = GetSyncedData(p, GetCameraField, CAMERA_FIELD_ROTATION)
                    local finalField2 = GetSyncedData(p, GetCameraField, CAMERA_FIELD_ZOFFSET)

                    print("\nPlayer " .. GetPlayerName(p) .. "'s camera information:\n"
                        .. "Bounds: " .. table.concat(data, ", ", 1, 4) .. "\n"
                        .. "Eye position: " .. table.concat(data, ", ", 5, 7) .. "\n"
                        .. "Target position: " .. table.concat(data, ", ", 8, 10) .. "\n"
                        .. "Margin: " .. table.concat(data, " ", 11, 14) .. "\n"
                        .. "Target distance: " .. data[15] .. "\n"
                        .. "Angle of attack: " .. data[16] .. "\n"
                        .. "Near Z: " .. data[17] .. "\n"
                        .. "Far Z: " .. data[18] .. "\n"
                        .. "Field of view: " .. data[19] .. "\n"
                        .. "Pitch: " .. data[20] .. "\n"
                        .. "Roll: " .. data[21] .. "\n"
                        .. "Yaw: " .. data[22] .. "\n"
                        .. "Rotation: " .. finalField1 .. "\n"
                        .. "Z offset: " .. finalField2 .. "\n")
                    print("\n")
                end))
            end)
        end
    end)
end)
Debug.endFile()