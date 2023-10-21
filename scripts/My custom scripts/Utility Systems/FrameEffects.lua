if Debug then Debug.beginFile("FourCCTable") end
OnInit("FrameEffects", function ()
    Require "Timed" -- https://www.hiveworkshop.com/threads/timed-call-and-echo.339222/

    local INTERVAL = 0.03125

    local Fades = {} ---@type table<framehandle, function>

    ---@param frame framehandle -- Not nil
    ---@param duration number
    ---@param whatPlayer? player
    function FrameFadeOut(frame, duration, whatPlayer)
        whatPlayer = whatPlayer or GetLocalPlayer()

        pcall(function ()
            BlzFrameSetAlpha(frame, 255)
            Fades[frame]()
        end)

        local steps = math.floor(duration / INTERVAL)
        local stepSize = 255 // steps
        local alpha = 255

        Fades[frame] = Timed.echo(INTERVAL, function ()
            steps = steps - 1
            alpha = alpha - stepSize
            if steps > 0 then
                if GetLocalPlayer() == whatPlayer then
                    BlzFrameSetAlpha(frame, alpha)
                end
            else
                if GetLocalPlayer() == whatPlayer then
                    BlzFrameSetVisible(frame, false)
                end
                Fades[frame] = nil
                return true
            end
        end)
    end

    ---@param frame framehandle -- Not nil
    ---@param duration number
    ---@param whatPlayer? player
    function FrameFadeIn(frame, duration, whatPlayer)
        whatPlayer = whatPlayer or GetLocalPlayer()

        pcall(function ()
            BlzFrameSetAlpha(frame, 0)
            Fades[frame]()
        end)

        local steps = math.floor(duration / INTERVAL)
        local stepSize = 255 // steps
        local alpha = 0

        if GetLocalPlayer() == whatPlayer then
            BlzFrameSetVisible(frame, true)
        end

        Fades[frame] = Timed.echo(INTERVAL, function ()
            steps = steps - 1
            alpha = alpha + stepSize
            if steps > 0 then
                if GetLocalPlayer() == whatPlayer then
                    BlzFrameSetAlpha(frame, alpha)
                end
                Fades[frame] = nil
            else
                return true
            end
        end)
    end
end)
if Debug then Debug.endFile() end