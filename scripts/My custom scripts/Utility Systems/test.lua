SavedDigimons = nil 
TriggerSavedDigimons = nil 
Using = nil 
TriggerUsing = nil 
UsingDigimonT00T00T = {} 
BackdropUsingDigimonT00T00T = {} 
TriggerUsingDigimonT00T00T = {} 
Saved = nil 
TriggerSaved = nil 
SavedDigimonT00T = {} 
BackdropSavedDigimonT00T = {} 
TriggerSavedDigimonT00T = {} 
Swap = nil 
TriggerSwap = nil 
Exit = nil 
TriggerExit = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.UsingDigimonT00T00T00Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[0], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[0], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T00Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[0], false) 
BlzFrameSetEnable(SavedDigimonT00T[0], true) 
end 
 
REFORGEDUIMAKER.SwapFunc = function() 
BlzFrameSetEnable(Swap, false) 
BlzFrameSetEnable(Swap, true) 
end 
 
REFORGEDUIMAKER.ExitFunc = function() 
BlzFrameSetEnable(Exit, false) 
BlzFrameSetEnable(Exit, true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T01Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[1], false) 
BlzFrameSetEnable(SavedDigimonT00T[1], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T02Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[2], false) 
BlzFrameSetEnable(SavedDigimonT00T[2], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T03Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[3], false) 
BlzFrameSetEnable(SavedDigimonT00T[3], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T04Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[4], false) 
BlzFrameSetEnable(SavedDigimonT00T[4], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T05Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[5], false) 
BlzFrameSetEnable(SavedDigimonT00T[5], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T06Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[6], false) 
BlzFrameSetEnable(SavedDigimonT00T[6], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T07Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[7], false) 
BlzFrameSetEnable(SavedDigimonT00T[7], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T08Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[8], false) 
BlzFrameSetEnable(SavedDigimonT00T[8], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T09Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[9], false) 
BlzFrameSetEnable(SavedDigimonT00T[9], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T10Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[10], false) 
BlzFrameSetEnable(SavedDigimonT00T[10], true) 
end 
 
REFORGEDUIMAKER.SavedDigimonT00T11Func = function() 
BlzFrameSetEnable(SavedDigimonT00T[11], false) 
BlzFrameSetEnable(SavedDigimonT00T[11], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T01Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[1], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[1], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T02Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[2], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[2], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T03Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[3], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[3], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T04Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[4], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[4], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T05Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[5], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[5], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T06Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[6], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[6], true) 
end 
 
REFORGEDUIMAKER.UsingDigimonT00T00T07Func = function() 
BlzFrameSetEnable(UsingDigimonT00T00T[7], false) 
BlzFrameSetEnable(UsingDigimonT00T00T[7], true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


SavedDigimons = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_TOPLEFT, 0.215000, 0.510000)
BlzFrameSetAbsPoint(SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, 0.585000, 0.180000)

Using = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
BlzFrameSetPoint(Using, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.030000)
BlzFrameSetPoint(Using, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.23500, 0.28000)
BlzFrameSetText(Using, "|cffFFCC00Using|r")
BlzFrameSetEnable(Using, false)
BlzFrameSetScale(Using, 1.29)
BlzFrameSetTextAlignment(Using, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

UsingDigimonT00T00T[0] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[0], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.070000)
BlzFrameSetPoint(UsingDigimonT00T00T[0], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.28500, 0.21000)

BackdropUsingDigimonT00T00T[0] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[0]", UsingDigimonT00T00T[0], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[0], UsingDigimonT00T00T[0])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[0], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[0], UsingDigimonT00T00T[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[0], REFORGEDUIMAKER.UsingDigimonT00T00T00Func) 

Saved = BlzCreateFrameByType("TEXT", "name", SavedDigimons, "", 0)
BlzFrameSetPoint(Saved, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.21000, -0.030000)
BlzFrameSetPoint(Saved, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.28000)
BlzFrameSetText(Saved, "|cffFFCC00Saved|r")
BlzFrameSetEnable(Saved, false)
BlzFrameSetScale(Saved, 1.29)
BlzFrameSetTextAlignment(Saved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

SavedDigimonT00T[0] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[0], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.18500, -0.070000)
BlzFrameSetPoint(SavedDigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.21000)

BackdropSavedDigimonT00T[0] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[0]", SavedDigimonT00T[0], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[0], SavedDigimonT00T[0])
BlzFrameSetTexture(BackdropSavedDigimonT00T[0], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[0], SavedDigimonT00T[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[0], REFORGEDUIMAKER.SavedDigimonT00T00Func) 

Swap = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
BlzFrameSetPoint(Swap, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.15000, -0.28000)
BlzFrameSetPoint(Swap, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.14000, 0.020000)
BlzFrameSetText(Swap, "|cffFCD20DSwap|r")
BlzFrameSetScale(Swap, 1.29)
TriggerSwap = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSwap, Swap, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSwap, REFORGEDUIMAKER.SwapFunc) 

Exit = BlzCreateFrame("ScriptDialogButton", SavedDigimons, 0, 0)
BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.34000, -0.0050000)
BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.30000)
BlzFrameSetText(Exit, "|cffFCD20DX|r")
BlzFrameSetScale(Exit, 1.00)
TriggerExit = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerExit, REFORGEDUIMAKER.ExitFunc) 

SavedDigimonT00T[1] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[1], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.23500, -0.070000)
BlzFrameSetPoint(SavedDigimonT00T[1], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.21000)

BackdropSavedDigimonT00T[1] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[1]", SavedDigimonT00T[1], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[1], SavedDigimonT00T[1])
BlzFrameSetTexture(BackdropSavedDigimonT00T[1], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[1], SavedDigimonT00T[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[1], REFORGEDUIMAKER.SavedDigimonT00T01Func) 

SavedDigimonT00T[2] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[2], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.28500, -0.070000)
BlzFrameSetPoint(SavedDigimonT00T[2], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.21000)

BackdropSavedDigimonT00T[2] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[2]", SavedDigimonT00T[2], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[2], SavedDigimonT00T[2])
BlzFrameSetTexture(BackdropSavedDigimonT00T[2], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[2], SavedDigimonT00T[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[2], REFORGEDUIMAKER.SavedDigimonT00T02Func) 

SavedDigimonT00T[3] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[3], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.18500, -0.12000)
BlzFrameSetPoint(SavedDigimonT00T[3], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.16000)

BackdropSavedDigimonT00T[3] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[3]", SavedDigimonT00T[3], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[3], SavedDigimonT00T[3])
BlzFrameSetTexture(BackdropSavedDigimonT00T[3], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[3], SavedDigimonT00T[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[3], REFORGEDUIMAKER.SavedDigimonT00T03Func) 

SavedDigimonT00T[4] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[4], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.23500, -0.12000)
BlzFrameSetPoint(SavedDigimonT00T[4], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.16000)

BackdropSavedDigimonT00T[4] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[4]", SavedDigimonT00T[4], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[4], SavedDigimonT00T[4])
BlzFrameSetTexture(BackdropSavedDigimonT00T[4], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[4] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[4], SavedDigimonT00T[4], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[4], REFORGEDUIMAKER.SavedDigimonT00T04Func) 

SavedDigimonT00T[5] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[5], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.28500, -0.12000)
BlzFrameSetPoint(SavedDigimonT00T[5], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.16000)

BackdropSavedDigimonT00T[5] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[5]", SavedDigimonT00T[5], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[5], SavedDigimonT00T[5])
BlzFrameSetTexture(BackdropSavedDigimonT00T[5], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[5] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[5], SavedDigimonT00T[5], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[5], REFORGEDUIMAKER.SavedDigimonT00T05Func) 

SavedDigimonT00T[6] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[6], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.18500, -0.17000)
BlzFrameSetPoint(SavedDigimonT00T[6], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.11000)

BackdropSavedDigimonT00T[6] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[6]", SavedDigimonT00T[6], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[6], SavedDigimonT00T[6])
BlzFrameSetTexture(BackdropSavedDigimonT00T[6], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[6] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[6], SavedDigimonT00T[6], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[6], REFORGEDUIMAKER.SavedDigimonT00T06Func) 

SavedDigimonT00T[7] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[7], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.23500, -0.17000)
BlzFrameSetPoint(SavedDigimonT00T[7], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.11000)

BackdropSavedDigimonT00T[7] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[7]", SavedDigimonT00T[7], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[7], SavedDigimonT00T[7])
BlzFrameSetTexture(BackdropSavedDigimonT00T[7], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[7] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[7], SavedDigimonT00T[7], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[7], REFORGEDUIMAKER.SavedDigimonT00T07Func) 

SavedDigimonT00T[8] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[8], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.28500, -0.17000)
BlzFrameSetPoint(SavedDigimonT00T[8], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.11000)

BackdropSavedDigimonT00T[8] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[8]", SavedDigimonT00T[8], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[8], SavedDigimonT00T[8])
BlzFrameSetTexture(BackdropSavedDigimonT00T[8], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[8] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[8], SavedDigimonT00T[8], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[8], REFORGEDUIMAKER.SavedDigimonT00T08Func) 

SavedDigimonT00T[9] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[9], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.18500, -0.22000)
BlzFrameSetPoint(SavedDigimonT00T[9], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.060000)

BackdropSavedDigimonT00T[9] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[9]", SavedDigimonT00T[9], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[9], SavedDigimonT00T[9])
BlzFrameSetTexture(BackdropSavedDigimonT00T[9], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[9] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[9], SavedDigimonT00T[9], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[9], REFORGEDUIMAKER.SavedDigimonT00T09Func) 

SavedDigimonT00T[10] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[10], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.23500, -0.22000)
BlzFrameSetPoint(SavedDigimonT00T[10], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.085000, 0.060000)

BackdropSavedDigimonT00T[10] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[10]", SavedDigimonT00T[10], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[10], SavedDigimonT00T[10])
BlzFrameSetTexture(BackdropSavedDigimonT00T[10], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[10] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[10], SavedDigimonT00T[10], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[10], REFORGEDUIMAKER.SavedDigimonT00T10Func) 

SavedDigimonT00T[11] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(SavedDigimonT00T[11], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.28500, -0.22000)
BlzFrameSetPoint(SavedDigimonT00T[11], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.060000)

BackdropSavedDigimonT00T[11] = BlzCreateFrameByType("BACKDROP", "BackdropSavedDigimonT00T[11]", SavedDigimonT00T[11], "", 0)
BlzFrameSetAllPoints(BackdropSavedDigimonT00T[11], SavedDigimonT00T[11])
BlzFrameSetTexture(BackdropSavedDigimonT00T[11], "CustomFrame.png", 0, true)
TriggerSavedDigimonT00T[11] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedDigimonT00T[11], SavedDigimonT00T[11], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedDigimonT00T[11], REFORGEDUIMAKER.SavedDigimonT00T11Func) 

UsingDigimonT00T00T[1] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[1], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.085000, -0.070000)
BlzFrameSetPoint(UsingDigimonT00T00T[1], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.23500, 0.21000)

BackdropUsingDigimonT00T00T[1] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[1]", UsingDigimonT00T00T[1], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[1], UsingDigimonT00T00T[1])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[1], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[1], UsingDigimonT00T00T[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[1], REFORGEDUIMAKER.UsingDigimonT00T00T01Func) 

UsingDigimonT00T00T[2] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[2], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.12000)
BlzFrameSetPoint(UsingDigimonT00T00T[2], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.28500, 0.16000)

BackdropUsingDigimonT00T00T[2] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[2]", UsingDigimonT00T00T[2], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[2], UsingDigimonT00T00T[2])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[2], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[2], UsingDigimonT00T00T[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[2], REFORGEDUIMAKER.UsingDigimonT00T00T02Func) 

UsingDigimonT00T00T[3] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[3], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.085000, -0.12000)
BlzFrameSetPoint(UsingDigimonT00T00T[3], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.23500, 0.16000)

BackdropUsingDigimonT00T00T[3] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[3]", UsingDigimonT00T00T[3], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[3], UsingDigimonT00T00T[3])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[3], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[3], UsingDigimonT00T00T[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[3], REFORGEDUIMAKER.UsingDigimonT00T00T03Func) 

UsingDigimonT00T00T[4] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[4], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.17000)
BlzFrameSetPoint(UsingDigimonT00T00T[4], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.28500, 0.11000)

BackdropUsingDigimonT00T00T[4] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[4]", UsingDigimonT00T00T[4], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[4], UsingDigimonT00T00T[4])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[4], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[4] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[4], UsingDigimonT00T00T[4], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[4], REFORGEDUIMAKER.UsingDigimonT00T00T04Func) 

UsingDigimonT00T00T[5] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[5], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.085000, -0.17000)
BlzFrameSetPoint(UsingDigimonT00T00T[5], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.23500, 0.11000)

BackdropUsingDigimonT00T00T[5] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[5]", UsingDigimonT00T00T[5], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[5], UsingDigimonT00T00T[5])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[5], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[5] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[5], UsingDigimonT00T00T[5], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[5], REFORGEDUIMAKER.UsingDigimonT00T00T05Func) 

UsingDigimonT00T00T[6] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[6], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.035000, -0.22000)
BlzFrameSetPoint(UsingDigimonT00T00T[6], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.28500, 0.060000)

BackdropUsingDigimonT00T00T[6] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[6]", UsingDigimonT00T00T[6], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[6], UsingDigimonT00T00T[6])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[6], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[6] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[6], UsingDigimonT00T00T[6], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[6], REFORGEDUIMAKER.UsingDigimonT00T00T06Func) 

UsingDigimonT00T00T[7] = BlzCreateFrame("IconButtonTemplate", SavedDigimons, 0, 0)
BlzFrameSetPoint(UsingDigimonT00T00T[7], FRAMEPOINT_TOPLEFT, SavedDigimons, FRAMEPOINT_TOPLEFT, 0.085000, -0.22000)
BlzFrameSetPoint(UsingDigimonT00T00T[7], FRAMEPOINT_BOTTOMRIGHT, SavedDigimons, FRAMEPOINT_BOTTOMRIGHT, -0.23500, 0.060000)

BackdropUsingDigimonT00T00T[7] = BlzCreateFrameByType("BACKDROP", "BackdropUsingDigimonT00T00T[7]", UsingDigimonT00T00T[7], "", 0)
BlzFrameSetAllPoints(BackdropUsingDigimonT00T00T[7], UsingDigimonT00T00T[7])
BlzFrameSetTexture(BackdropUsingDigimonT00T00T[7], "CustomFrame.png", 0, true)
TriggerUsingDigimonT00T00T[7] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUsingDigimonT00T00T[7], UsingDigimonT00T00T[7], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUsingDigimonT00T00T[7], REFORGEDUIMAKER.UsingDigimonT00T00T07Func) 
end
