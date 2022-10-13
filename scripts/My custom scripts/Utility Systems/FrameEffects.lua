OnLibraryInit({name = "FrameEffects", "Timed"}, function () -- https://www.hiveworkshop.com/threads/timed-call-and-echo.339222/

    local INTERVAL = 0.03125

    local LocalPlayer = nil ---@type player

    local Fades = {} ---@type table<framehandle, function>

    ---@param frame framehandle -- Not nil
    ---@param duration number
    ---@param whatPlayer? player
    function FrameFadeOut(frame, duration, whatPlayer)
        whatPlayer = whatPlayer or LocalPlayer

        pcall(function ()
            Fades[frame]()
            BlzFrameSetAlpha(frame, 255)
        end)

        local steps = math.floor(duration / INTERVAL)
        local stepSize = 255 // steps
        local alpha = 255

        Fades[frame] = Timed.echo(function ()
            steps = steps - 1
            alpha = alpha - stepSize
            if steps > 0 then
                if LocalPlayer == whatPlayer then
                    BlzFrameSetAlpha(frame, alpha)
                end
            else
                if LocalPlayer == whatPlayer then
                    BlzFrameSetVisible(frame, false)
                end
                Fades[frame] = nil
                return true
            end
        end, INTERVAL)
    end

    ---@param frame framehandle -- Not nil
    ---@param duration number
    ---@param whatPlayer? player
    function FrameFadeIn(frame, duration, whatPlayer)
        whatPlayer = whatPlayer or LocalPlayer

        pcall(function ()
            Fades[frame]()
            BlzFrameSetAlpha(frame, 0)
        end)

        local steps = math.floor(duration / INTERVAL)
        local stepSize = 255 // steps
        local alpha = 0

        if LocalPlayer == whatPlayer then
            BlzFrameSetVisible(frame, true)
        end

        Fades[frame] = Timed.echo(function ()
            steps = steps - 1
            alpha = alpha + stepSize
            if steps > 0 then
                if LocalPlayer == whatPlayer then
                    BlzFrameSetAlpha(frame, alpha)
                end
                Fades[frame] = nil
            else
                return true
            end
        end, INTERVAL)
    end

    OnTrigInit(function ()
        LocalPlayer = GetLocalPlayer()
    end)
end)