Backdrop01 = nil 
TriggerBackdrop01 = nil 
Fisher = nil 
TriggerFisher = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.Initialize = function()
BlzHideOriginFrames(true) 
BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, 0.0001)


Backdrop01 = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
BlzFrameSetAbsPoint(Backdrop01, FRAMEPOINT_TOPLEFT, 0.250000, 0.350000)
BlzFrameSetAbsPoint(Backdrop01, FRAMEPOINT_BOTTOMRIGHT, 0.260000, 0.250000)
BlzFrameSetTexture(Backdrop01, "CustomFrame.png", 0, true)

Fisher = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop01, "", 1)
BlzFrameSetPoint(Fisher, FRAMEPOINT_TOPLEFT, Backdrop01, FRAMEPOINT_TOPLEFT, -0.010000, -0.10000)
BlzFrameSetPoint(Fisher, FRAMEPOINT_BOTTOMRIGHT, Backdrop01, FRAMEPOINT_BOTTOMRIGHT, 0.010000, -0.030000)
BlzFrameSetTexture(Fisher, "CustomFrame.png", 0, true)
end
