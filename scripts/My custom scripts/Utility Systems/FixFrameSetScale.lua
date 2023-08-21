if Debug then Debug.beginFile("FixFrameSetScale") end
OnInit("FixFrameSetScale", function ()
    Require "AddHook"

    local scales = __jarray(1) ---@type table<framehandle, number>

    local oldFrameSetScale
    oldFrameSetScale = AddHook("BlzFrameSetScale", function (frame, scale)
        scales[frame] = 1/scale
        oldFrameSetScale(frame, scale)
    end)

    local oldFrameSetPoint
    oldFrameSetPoint = AddHook("BlzFrameSetPoint", function (frame, point, relative, relativePoint, x, y)
        oldFrameSetPoint(frame, point, relative, relativePoint, x * scales[frame], y * scales[frame])
    end)
end)
if Debug then Debug.endFile() end