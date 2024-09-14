ThreatBackdrop = nil 
TriggerThreatBackdrop = nil 
ThreatBoss = nil 
TriggerThreatBoss = nil 
ThreatArrow = nil 
TriggerThreatArrow = nil 
ThreatPlayerUnitT = {} 
TriggerThreatPlayerUnitT = {} 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.Initialize = function()


ThreatBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.230000, 0.520000)

ThreatBoss = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.18500, 0.0050000)
BlzFrameSetTexture(ThreatBoss, "CustomFrame.png", 0, true)

ThreatArrow = BlzCreateFrameByType("TEXT", "name", ThreatBackdrop, "", 0)
BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_TOPLEFT, 0.0500000, 0.570000)
BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_BOTTOMRIGHT, 0.100000, 0.520000)
BlzFrameSetText(ThreatArrow, "|cffFFCC00→|r")
BlzFrameSetEnable(ThreatArrow, false)
BlzFrameSetScale(ThreatArrow, 4.57)
BlzFrameSetTextAlignment(ThreatArrow, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

ThreatPlayerUnitT[0] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[0], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.10500, -0.0050000)
BlzFrameSetPoint(ThreatPlayerUnitT[0], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.0050000)
BlzFrameSetTexture(ThreatPlayerUnitT[0], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[1] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[1], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.14500, -0.0050000)
BlzFrameSetPoint(ThreatPlayerUnitT[1], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.045000, 0.0050000)
BlzFrameSetTexture(ThreatPlayerUnitT[1], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[2] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[2], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.18500, -0.0050000)
BlzFrameSetPoint(ThreatPlayerUnitT[2], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.0050000)
BlzFrameSetTexture(ThreatPlayerUnitT[2], "CustomFrame.png", 0, true)

ThreatPlayerUnitT[3] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
BlzFrameSetPoint(ThreatPlayerUnitT[3], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.22500, -0.0050000)
BlzFrameSetPoint(ThreatPlayerUnitT[3], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.035000, 0.0050000)
BlzFrameSetTexture(ThreatPlayerUnitT[3], "CustomFrame.png", 0, true)
end
