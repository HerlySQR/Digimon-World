do
    local Vector3 = wGeometry.Vector3
    local Camera = wGeometry.Camera

    local target = gg_unit_hpal_0000
    local frame = nil ---@type framehandle

    OnMapInit(function ()
        frame = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMLEFT, 0, 0)
        BlzFrameSetSize(frame, 0.1, 0.1)
        BlzFrameSetText(frame, "TEXT")
        BlzFrameSetScale(frame, 0.90)

        Timed.echo(function ()
            xpcall(function ()
                local cam = Camera:new(GetCameraTargetPositionZ())
                local wPos = Vector3:copyFromUnit(target)
                local sPos = cam:worldToWindow(wPos)
                print(sPos)

                BlzFrameClearAllPoints(frame)
                BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMLEFT, sPos.x, sPos.y)
            end, print)
        end)
    end)

end