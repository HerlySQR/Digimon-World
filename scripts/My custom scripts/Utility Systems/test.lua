ThreatBackdrop = nil 
TriggerThreatBackdrop = nil 
HealthBar = nil 
BackHealthBar = nil 
TriggerHealthBar = nil 
ThreatBoss = nil 
TriggerThreatBoss = nil 
ThreatArrow = nil 
TriggerThreatArrow = nil 
ThreatPlayerUnitT = {} 
TriggerThreatPlayerUnitT = {} 
BackHealthBar = nil 
TriggerBackHealthBar = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.Initialize = function()


ThreatBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.575000)
BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.120000, 0.540000)

BackHealthBar = BlzCreateFrameByType("BACKDROP", "BackHealthBar", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
BlzFrameSetAbsPoint(BackHealthBar, FRAMEPOINT_TOPLEFT, 0.0525000, 0.537000)
BlzFrameSetAbsPoint(BackHealthBar, FRAMEPOINT_BOTTOMRIGHT, 0.0675000, 0.532500)
BlzFrameSetTexture(BackHealthBar, "", 0, true)

HealthBar = BlzCreateFrameByType("SIMPLESTATUSBAR", "", BackHealthBar, "", 0)
BlzFrameSetTexture(HealthBar, "CustomFrame.png", 0, true)
BlzFrameSetAbsPoint(HealthBar, FRAMEPOINT_TOPLEFT, 0.0525000, 0.537000)
BlzFrameSetAbsPoint(HealthBar, FRAMEPOINT_BOTTOMRIGHT, 0.0675000, 0.532500)
BlzFrameSetValue(HealthBar, 50)

ThreatBoss = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.0075000, -0.0075000)
BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.092500, 0.0075000)
BlzFrameSetTexture(ThreatBoss, "CustomFrame.png", 0, true)

ThreatArrow = BlzCreateFrameByType("TEXT", "name", ThreatBackdrop, "", 0)
BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_TOPLEFT, 0.0300000, 0.567500)
BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.547500)
BlzFrameSetText(ThreatArrow, "|cffFFCC00->|r")
BlzFrameSetEnable(ThreatArrow, false)
BlzFrameSetScale(ThreatArrow, 2.00)
BlzFrameSetTextAlignment(ThreatArrow, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

ThreatPlayerUnitT[0] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[0], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.052500, -0.0075000)
BlzFrameSetPoint(ThreatPlayerUnitT[0], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.047500, 0.0075000)
BlzFrameSetTexture(ThreatPlayerUnitT[0], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[1] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[1], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.072500, -0.0075000)
BlzFrameSetPoint(ThreatPlayerUnitT[1], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.027500, 0.0075000)
BlzFrameSetTexture(ThreatPlayerUnitT[1], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[2] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[2], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.092500, -0.0075000)
BlzFrameSetPoint(ThreatPlayerUnitT[2], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0075000, 0.0075000)
BlzFrameSetTexture(ThreatPlayerUnitT[2], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[3] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[3], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.11250, -0.0075000)
BlzFrameSetPoint(ThreatPlayerUnitT[3], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.012500, 0.0075000)
BlzFrameSetTexture(ThreatPlayerUnitT[3], "CustomFrame.png", 0, true)

BackHealthBar = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatPlayerUnitT[0], "", 1)
BlzFrameSetPoint(BackHealthBar, FRAMEPOINT_TOPLEFT, ThreatPlayerUnitT[0], FRAMEPOINT_TOPLEFT, 0.0010000, -0.020500)
BlzFrameSetPoint(BackHealthBar, FRAMEPOINT_BOTTOMRIGHT, ThreatPlayerUnitT[0], FRAMEPOINT_BOTTOMRIGHT, -0.0015000, -0.0050000)
BlzFrameSetTexture(BackHealthBar, "CustomFrame.png", 0, true)
end
