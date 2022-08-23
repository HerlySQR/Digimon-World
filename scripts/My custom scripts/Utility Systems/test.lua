OnMapInit(function ()

    local t = CreateTrigger()
    ForForce(bj_FORCE_ALL_PLAYERS, function ()
        TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-caminfo ", false)
    end)
    TriggerAddAction(t, function ()
        xpcall(function ()

        local id = tonumber(GetEventPlayerChatString():sub(10, 10))
        local p = Player(id)
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
            GetCameraField, {CAMERA_FIELD_LOCAL_YAW},
            GetCameraField, {CAMERA_FIELD_ROTATION},
            GetCameraField, {CAMERA_FIELD_ZOFFSET}
        })

        print("Player " .. GetPlayerName(p) .. "'s camera information:\n"
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
            .. "Rotation: " .. data[23] .. "\n"
            .. "Z offset: " .. data[24] .. "\n")

        end, print)
    end)
end)