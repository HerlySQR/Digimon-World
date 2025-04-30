MaterialsBackdrop = nil 
TriggerMaterialsBackdrop = nil 
MaterialsLabel = nil 
TriggerMaterialsLabel = nil 
MaterialIconT = {} 
BackdropMaterialIconT = {} 
TriggerMaterialIconT = {} 
MaterialAmount = nil 
TriggerMaterialAmount = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.MaterialIconT00Func = function() 
BlzFrameSetEnable(MaterialIconT[0], false) 
BlzFrameSetEnable(MaterialIconT[0], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT01Func = function() 
BlzFrameSetEnable(MaterialIconT[1], false) 
BlzFrameSetEnable(MaterialIconT[1], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT02Func = function() 
BlzFrameSetEnable(MaterialIconT[2], false) 
BlzFrameSetEnable(MaterialIconT[2], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT03Func = function() 
BlzFrameSetEnable(MaterialIconT[3], false) 
BlzFrameSetEnable(MaterialIconT[3], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT04Func = function() 
BlzFrameSetEnable(MaterialIconT[4], false) 
BlzFrameSetEnable(MaterialIconT[4], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT05Func = function() 
BlzFrameSetEnable(MaterialIconT[5], false) 
BlzFrameSetEnable(MaterialIconT[5], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT06Func = function() 
BlzFrameSetEnable(MaterialIconT[6], false) 
BlzFrameSetEnable(MaterialIconT[6], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT07Func = function() 
BlzFrameSetEnable(MaterialIconT[7], false) 
BlzFrameSetEnable(MaterialIconT[7], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT08Func = function() 
BlzFrameSetEnable(MaterialIconT[8], false) 
BlzFrameSetEnable(MaterialIconT[8], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT09Func = function() 
BlzFrameSetEnable(MaterialIconT[9], false) 
BlzFrameSetEnable(MaterialIconT[9], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT10Func = function() 
BlzFrameSetEnable(MaterialIconT[10], false) 
BlzFrameSetEnable(MaterialIconT[10], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT11Func = function() 
BlzFrameSetEnable(MaterialIconT[11], false) 
BlzFrameSetEnable(MaterialIconT[11], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT12Func = function() 
BlzFrameSetEnable(MaterialIconT[12], false) 
BlzFrameSetEnable(MaterialIconT[12], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT13Func = function() 
BlzFrameSetEnable(MaterialIconT[13], false) 
BlzFrameSetEnable(MaterialIconT[13], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT14Func = function() 
BlzFrameSetEnable(MaterialIconT[14], false) 
BlzFrameSetEnable(MaterialIconT[14], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT15Func = function() 
BlzFrameSetEnable(MaterialIconT[15], false) 
BlzFrameSetEnable(MaterialIconT[15], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT16Func = function() 
BlzFrameSetEnable(MaterialIconT[16], false) 
BlzFrameSetEnable(MaterialIconT[16], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT17Func = function() 
BlzFrameSetEnable(MaterialIconT[17], false) 
BlzFrameSetEnable(MaterialIconT[17], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT18Func = function() 
BlzFrameSetEnable(MaterialIconT[18], false) 
BlzFrameSetEnable(MaterialIconT[18], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT19Func = function() 
BlzFrameSetEnable(MaterialIconT[19], false) 
BlzFrameSetEnable(MaterialIconT[19], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT20Func = function() 
BlzFrameSetEnable(MaterialIconT[20], false) 
BlzFrameSetEnable(MaterialIconT[20], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT21Func = function() 
BlzFrameSetEnable(MaterialIconT[21], false) 
BlzFrameSetEnable(MaterialIconT[21], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT22Func = function() 
BlzFrameSetEnable(MaterialIconT[22], false) 
BlzFrameSetEnable(MaterialIconT[22], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT23Func = function() 
BlzFrameSetEnable(MaterialIconT[23], false) 
BlzFrameSetEnable(MaterialIconT[23], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT24Func = function() 
BlzFrameSetEnable(MaterialIconT[24], false) 
BlzFrameSetEnable(MaterialIconT[24], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT25Func = function() 
BlzFrameSetEnable(MaterialIconT[25], false) 
BlzFrameSetEnable(MaterialIconT[25], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT26Func = function() 
BlzFrameSetEnable(MaterialIconT[26], false) 
BlzFrameSetEnable(MaterialIconT[26], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT27Func = function() 
BlzFrameSetEnable(MaterialIconT[27], false) 
BlzFrameSetEnable(MaterialIconT[27], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT28Func = function() 
BlzFrameSetEnable(MaterialIconT[28], false) 
BlzFrameSetEnable(MaterialIconT[28], true) 
end 
 
REFORGEDUIMAKER.MaterialIconT29Func = function() 
BlzFrameSetEnable(MaterialIconT[29], false) 
BlzFrameSetEnable(MaterialIconT[29], true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


MaterialsBackdrop = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.630000, 0.460000)
BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.890000, 0.270000)

MaterialsLabel = BlzCreateFrameByType("TEXT", "name", MaterialsBackdrop, "", 0)
BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.010000)
BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.16000)
BlzFrameSetText(MaterialsLabel, "|cffFFCC00Your materials:|r")
BlzFrameSetEnable(MaterialsLabel, false)
BlzFrameSetScale(MaterialsLabel, 1.29)
BlzFrameSetTextAlignment(MaterialsLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

MaterialIconT[0] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[0], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
BlzFrameSetPoint(MaterialIconT[0], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.14000)

BackdropMaterialIconT[0] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[0]", MaterialIconT[0], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[0], MaterialIconT[0])
BlzFrameSetTexture(BackdropMaterialIconT[0], "CustomFrame.png", 0, true)
TriggerMaterialIconT[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[0], MaterialIconT[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[0], REFORGEDUIMAKER.MaterialIconT00Func) 

MaterialIconT[1] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[1], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.030000)
BlzFrameSetPoint(MaterialIconT[1], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.14000)

BackdropMaterialIconT[1] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[1]", MaterialIconT[1], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[1], MaterialIconT[1])
BlzFrameSetTexture(BackdropMaterialIconT[1], "CustomFrame.png", 0, true)
TriggerMaterialIconT[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[1], MaterialIconT[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[1], REFORGEDUIMAKER.MaterialIconT01Func) 

MaterialIconT[2] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[2], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.030000)
BlzFrameSetPoint(MaterialIconT[2], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.14000)

BackdropMaterialIconT[2] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[2]", MaterialIconT[2], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[2], MaterialIconT[2])
BlzFrameSetTexture(BackdropMaterialIconT[2], "CustomFrame.png", 0, true)
TriggerMaterialIconT[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[2], MaterialIconT[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[2], REFORGEDUIMAKER.MaterialIconT02Func) 

MaterialIconT[3] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[3], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.030000)
BlzFrameSetPoint(MaterialIconT[3], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.14000)

BackdropMaterialIconT[3] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[3]", MaterialIconT[3], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[3], MaterialIconT[3])
BlzFrameSetTexture(BackdropMaterialIconT[3], "CustomFrame.png", 0, true)
TriggerMaterialIconT[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[3], MaterialIconT[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[3], REFORGEDUIMAKER.MaterialIconT03Func) 

MaterialIconT[4] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[4], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.030000)
BlzFrameSetPoint(MaterialIconT[4], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.14000)

BackdropMaterialIconT[4] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[4]", MaterialIconT[4], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[4], MaterialIconT[4])
BlzFrameSetTexture(BackdropMaterialIconT[4], "CustomFrame.png", 0, true)
TriggerMaterialIconT[4] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[4], MaterialIconT[4], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[4], REFORGEDUIMAKER.MaterialIconT04Func) 

MaterialIconT[5] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[5], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.055000)
BlzFrameSetPoint(MaterialIconT[5], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.11500)

BackdropMaterialIconT[5] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[5]", MaterialIconT[5], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[5], MaterialIconT[5])
BlzFrameSetTexture(BackdropMaterialIconT[5], "CustomFrame.png", 0, true)
TriggerMaterialIconT[5] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[5], MaterialIconT[5], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[5], REFORGEDUIMAKER.MaterialIconT05Func) 

MaterialIconT[6] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[6], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.055000)
BlzFrameSetPoint(MaterialIconT[6], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.11500)

BackdropMaterialIconT[6] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[6]", MaterialIconT[6], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[6], MaterialIconT[6])
BlzFrameSetTexture(BackdropMaterialIconT[6], "CustomFrame.png", 0, true)
TriggerMaterialIconT[6] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[6], MaterialIconT[6], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[6], REFORGEDUIMAKER.MaterialIconT06Func) 

MaterialIconT[7] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[7], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.055000)
BlzFrameSetPoint(MaterialIconT[7], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.11500)

BackdropMaterialIconT[7] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[7]", MaterialIconT[7], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[7], MaterialIconT[7])
BlzFrameSetTexture(BackdropMaterialIconT[7], "CustomFrame.png", 0, true)
TriggerMaterialIconT[7] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[7], MaterialIconT[7], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[7], REFORGEDUIMAKER.MaterialIconT07Func) 

MaterialIconT[8] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[8], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.055000)
BlzFrameSetPoint(MaterialIconT[8], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.11500)

BackdropMaterialIconT[8] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[8]", MaterialIconT[8], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[8], MaterialIconT[8])
BlzFrameSetTexture(BackdropMaterialIconT[8], "CustomFrame.png", 0, true)
TriggerMaterialIconT[8] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[8], MaterialIconT[8], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[8], REFORGEDUIMAKER.MaterialIconT08Func) 

MaterialIconT[9] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[9], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.055000)
BlzFrameSetPoint(MaterialIconT[9], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.11500)

BackdropMaterialIconT[9] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[9]", MaterialIconT[9], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[9], MaterialIconT[9])
BlzFrameSetTexture(BackdropMaterialIconT[9], "CustomFrame.png", 0, true)
TriggerMaterialIconT[9] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[9], MaterialIconT[9], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[9], REFORGEDUIMAKER.MaterialIconT09Func) 

MaterialIconT[10] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[10], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.080000)
BlzFrameSetPoint(MaterialIconT[10], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.090000)

BackdropMaterialIconT[10] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[10]", MaterialIconT[10], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[10], MaterialIconT[10])
BlzFrameSetTexture(BackdropMaterialIconT[10], "CustomFrame.png", 0, true)
TriggerMaterialIconT[10] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[10], MaterialIconT[10], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[10], REFORGEDUIMAKER.MaterialIconT10Func) 

MaterialIconT[11] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[11], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.080000)
BlzFrameSetPoint(MaterialIconT[11], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.090000)

BackdropMaterialIconT[11] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[11]", MaterialIconT[11], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[11], MaterialIconT[11])
BlzFrameSetTexture(BackdropMaterialIconT[11], "CustomFrame.png", 0, true)
TriggerMaterialIconT[11] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[11], MaterialIconT[11], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[11], REFORGEDUIMAKER.MaterialIconT11Func) 

MaterialIconT[12] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[12], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.080000)
BlzFrameSetPoint(MaterialIconT[12], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.090000)

BackdropMaterialIconT[12] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[12]", MaterialIconT[12], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[12], MaterialIconT[12])
BlzFrameSetTexture(BackdropMaterialIconT[12], "CustomFrame.png", 0, true)
TriggerMaterialIconT[12] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[12], MaterialIconT[12], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[12], REFORGEDUIMAKER.MaterialIconT12Func) 

MaterialIconT[13] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[13], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.080000)
BlzFrameSetPoint(MaterialIconT[13], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.090000)

BackdropMaterialIconT[13] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[13]", MaterialIconT[13], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[13], MaterialIconT[13])
BlzFrameSetTexture(BackdropMaterialIconT[13], "CustomFrame.png", 0, true)
TriggerMaterialIconT[13] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[13], MaterialIconT[13], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[13], REFORGEDUIMAKER.MaterialIconT13Func) 

MaterialIconT[14] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[14], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.080000)
BlzFrameSetPoint(MaterialIconT[14], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.090000)

BackdropMaterialIconT[14] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[14]", MaterialIconT[14], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[14], MaterialIconT[14])
BlzFrameSetTexture(BackdropMaterialIconT[14], "CustomFrame.png", 0, true)
TriggerMaterialIconT[14] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[14], MaterialIconT[14], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[14], REFORGEDUIMAKER.MaterialIconT14Func) 

MaterialIconT[15] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[15], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.10500)
BlzFrameSetPoint(MaterialIconT[15], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.065000)

BackdropMaterialIconT[15] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[15]", MaterialIconT[15], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[15], MaterialIconT[15])
BlzFrameSetTexture(BackdropMaterialIconT[15], "CustomFrame.png", 0, true)
TriggerMaterialIconT[15] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[15], MaterialIconT[15], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[15], REFORGEDUIMAKER.MaterialIconT15Func) 

MaterialIconT[16] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[16], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.10500)
BlzFrameSetPoint(MaterialIconT[16], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.065000)

BackdropMaterialIconT[16] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[16]", MaterialIconT[16], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[16], MaterialIconT[16])
BlzFrameSetTexture(BackdropMaterialIconT[16], "CustomFrame.png", 0, true)
TriggerMaterialIconT[16] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[16], MaterialIconT[16], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[16], REFORGEDUIMAKER.MaterialIconT16Func) 

MaterialIconT[17] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[17], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.10500)
BlzFrameSetPoint(MaterialIconT[17], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.065000)

BackdropMaterialIconT[17] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[17]", MaterialIconT[17], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[17], MaterialIconT[17])
BlzFrameSetTexture(BackdropMaterialIconT[17], "CustomFrame.png", 0, true)
TriggerMaterialIconT[17] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[17], MaterialIconT[17], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[17], REFORGEDUIMAKER.MaterialIconT17Func) 

MaterialIconT[18] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[18], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.10500)
BlzFrameSetPoint(MaterialIconT[18], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.065000)

BackdropMaterialIconT[18] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[18]", MaterialIconT[18], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[18], MaterialIconT[18])
BlzFrameSetTexture(BackdropMaterialIconT[18], "CustomFrame.png", 0, true)
TriggerMaterialIconT[18] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[18], MaterialIconT[18], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[18], REFORGEDUIMAKER.MaterialIconT18Func) 

MaterialIconT[19] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[19], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.10500)
BlzFrameSetPoint(MaterialIconT[19], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.065000)

BackdropMaterialIconT[19] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[19]", MaterialIconT[19], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[19], MaterialIconT[19])
BlzFrameSetTexture(BackdropMaterialIconT[19], "CustomFrame.png", 0, true)
TriggerMaterialIconT[19] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[19], MaterialIconT[19], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[19], REFORGEDUIMAKER.MaterialIconT19Func) 

MaterialIconT[20] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[20], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.13000)
BlzFrameSetPoint(MaterialIconT[20], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.040000)

BackdropMaterialIconT[20] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[20]", MaterialIconT[20], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[20], MaterialIconT[20])
BlzFrameSetTexture(BackdropMaterialIconT[20], "CustomFrame.png", 0, true)
TriggerMaterialIconT[20] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[20], MaterialIconT[20], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[20], REFORGEDUIMAKER.MaterialIconT20Func) 

MaterialIconT[21] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[21], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.13000)
BlzFrameSetPoint(MaterialIconT[21], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.040000)

BackdropMaterialIconT[21] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[21]", MaterialIconT[21], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[21], MaterialIconT[21])
BlzFrameSetTexture(BackdropMaterialIconT[21], "CustomFrame.png", 0, true)
TriggerMaterialIconT[21] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[21], MaterialIconT[21], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[21], REFORGEDUIMAKER.MaterialIconT21Func) 

MaterialIconT[22] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[22], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.13000)
BlzFrameSetPoint(MaterialIconT[22], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.040000)

BackdropMaterialIconT[22] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[22]", MaterialIconT[22], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[22], MaterialIconT[22])
BlzFrameSetTexture(BackdropMaterialIconT[22], "CustomFrame.png", 0, true)
TriggerMaterialIconT[22] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[22], MaterialIconT[22], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[22], REFORGEDUIMAKER.MaterialIconT22Func) 

MaterialIconT[23] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[23], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.13000)
BlzFrameSetPoint(MaterialIconT[23], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.040000)

BackdropMaterialIconT[23] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[23]", MaterialIconT[23], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[23], MaterialIconT[23])
BlzFrameSetTexture(BackdropMaterialIconT[23], "CustomFrame.png", 0, true)
TriggerMaterialIconT[23] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[23], MaterialIconT[23], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[23], REFORGEDUIMAKER.MaterialIconT23Func) 

MaterialIconT[24] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[24], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.13000)
BlzFrameSetPoint(MaterialIconT[24], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.040000)

BackdropMaterialIconT[24] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[24]", MaterialIconT[24], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[24], MaterialIconT[24])
BlzFrameSetTexture(BackdropMaterialIconT[24], "CustomFrame.png", 0, true)
TriggerMaterialIconT[24] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[24], MaterialIconT[24], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[24], REFORGEDUIMAKER.MaterialIconT24Func) 

MaterialIconT[25] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[25], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.15500)
BlzFrameSetPoint(MaterialIconT[25], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000, 0.015000)

BackdropMaterialIconT[25] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[25]", MaterialIconT[25], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[25], MaterialIconT[25])
BlzFrameSetTexture(BackdropMaterialIconT[25], "CustomFrame.png", 0, true)
TriggerMaterialIconT[25] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[25], MaterialIconT[25], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[25], REFORGEDUIMAKER.MaterialIconT25Func) 

MaterialIconT[26] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[26], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.065000, -0.15500)
BlzFrameSetPoint(MaterialIconT[26], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.015000)

BackdropMaterialIconT[26] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[26]", MaterialIconT[26], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[26], MaterialIconT[26])
BlzFrameSetTexture(BackdropMaterialIconT[26], "CustomFrame.png", 0, true)
TriggerMaterialIconT[26] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[26], MaterialIconT[26], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[26], REFORGEDUIMAKER.MaterialIconT26Func) 

MaterialIconT[27] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[27], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.11000, -0.15500)
BlzFrameSetPoint(MaterialIconT[27], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.015000)

BackdropMaterialIconT[27] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[27]", MaterialIconT[27], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[27], MaterialIconT[27])
BlzFrameSetTexture(BackdropMaterialIconT[27], "CustomFrame.png", 0, true)
TriggerMaterialIconT[27] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[27], MaterialIconT[27], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[27], REFORGEDUIMAKER.MaterialIconT27Func) 

MaterialIconT[28] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[28], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.15500)
BlzFrameSetPoint(MaterialIconT[28], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.015000)

BackdropMaterialIconT[28] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[28]", MaterialIconT[28], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[28], MaterialIconT[28])
BlzFrameSetTexture(BackdropMaterialIconT[28], "CustomFrame.png", 0, true)
TriggerMaterialIconT[28] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[28], MaterialIconT[28], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[28], REFORGEDUIMAKER.MaterialIconT28Func) 

MaterialIconT[29] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
BlzFrameSetPoint(MaterialIconT[29], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.15500)
BlzFrameSetPoint(MaterialIconT[29], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.015000)

BackdropMaterialIconT[29] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[29]", MaterialIconT[29], "", 0)
BlzFrameSetAllPoints(BackdropMaterialIconT[29], MaterialIconT[29])
BlzFrameSetTexture(BackdropMaterialIconT[29], "CustomFrame.png", 0, true)
TriggerMaterialIconT[29] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMaterialIconT[29], MaterialIconT[29], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMaterialIconT[29], REFORGEDUIMAKER.MaterialIconT29Func) 

MaterialAmount = BlzCreateFrameByType("TEXT", "name", MaterialIconT[0], "", 0)
BlzFrameSetPoint(MaterialAmount, FRAMEPOINT_TOPLEFT, MaterialIconT[0], FRAMEPOINT_TOPLEFT, 0.020000, 0.0000)
BlzFrameSetPoint(MaterialAmount, FRAMEPOINT_BOTTOMRIGHT, MaterialIconT[0], FRAMEPOINT_BOTTOMRIGHT, 0.020000, 0.0000)
BlzFrameSetText(MaterialAmount, "|cffffffff00|r")
BlzFrameSetEnable(MaterialAmount, false)
BlzFrameSetScale(MaterialAmount, 1.00)
BlzFrameSetTextAlignment(MaterialAmount, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
end
