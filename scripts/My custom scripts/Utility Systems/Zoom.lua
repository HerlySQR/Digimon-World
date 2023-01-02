OnInit("Zoom", function ()
    Require "Timed"
    Require "PlayerUtils"

    --[=[local DEFAULT_CAMERA_DISTANCE = 1240.
    local MAX_CAMERA_DISTANCE = 4000.
    local MIN_CAMERA_DISTANCE = 500.

    local Distances = __jarray(DEFAULT_CAMERA_DISTANCE) ---@type table<player, number>

    --local LocalPlayer = GetLocalPlayer()

    SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, DEFAULT_CAMERA_DISTANCE, 0.)

    --[[Timed.echo(function ()
        ForForce(FORCE_PLAYING, function ()
            local p = GetEnumPlayer()
            if p == LocalPlayer then
                SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, Distances[p], 0.)
            end
        end)
    end)]]

    OnInit.final(function ()
        local t = CreateTrigger()
        ForForce(FORCE_PLAYING, function ()
            TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-cam ", false)
        end)
        TriggerAddAction(t, function ()
            local p = GetTriggerPlayer()
            local chat = GetEventPlayerChatString()
            if string.sub(chat, 1, 5) ~= "-cam " then
                return
            end

            local dist = tonumber(string.sub(chat, 6))

            if type(dist) ~= "number" then
                DisplayTextToPlayer(p, 0, 0, "Invalid Zoom")
                return
            end

            if dist < MIN_CAMERA_DISTANCE then
                dist = MIN_CAMERA_DISTANCE
                DisplayTextToPlayer(p, 0, 0, "Min Zoom is 500!")
            elseif dist > MAX_CAMERA_DISTANCE then
                dist = MAX_CAMERA_DISTANCE
                DisplayTextToPlayer(p, 0, 0, "Max Zoom is 4000!")
            end

            Distances[p] = dist
        end)

        t = CreateTrigger()
        ForForce(FORCE_PLAYING, function ()
            TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-defcam ", true)
        end)
        TriggerAddAction(t, function ()
            Distances[GetTriggerPlayer()] = DEFAULT_CAMERA_DISTANCE
        end)
    end)]=]

    

end)