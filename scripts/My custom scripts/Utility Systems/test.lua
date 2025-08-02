StockedDigimonsMenu = nil 
TriggerStockedDigimonsMenu = nil 
UnstableDatasProgress = nil 
BackUnstableDatasProgress = nil 
TriggerUnstableDatasProgress = nil 
UnstableDatas = nil 
BackdropUnstableDatas = nil 
TriggerUnstableDatas = nil 
DigimonT00T = {} 
BackdropDigimonT00T = {} 
TriggerDigimonT00T = {} 
Text = nil 
TriggerText = nil 
Exit = nil 
TriggerExit = nil 
Summon = nil 
TriggerSummon = nil 
Free = nil 
TriggerFree = nil 
Store = nil 
TriggerStore = nil 
DigimonTIsMain = {} 
TriggerDigimonTIsMain = {} 
ReviveItems = nil 
TriggerReviveItems = nil 
DigimonTTooltipT = {} 
TriggerDigimonTTooltipT = {} 
DigimonTUsedT = {} 
TriggerDigimonTUsedT = {} 
DigimonTSelectedT = {} 
TriggerDigimonTSelectedT = {} 
DigimonTCooldownT = {} 
TriggerDigimonTCooldownT = {} 
Warning = nil 
TriggerWarning = nil 
ReviveItemsChargesBackdrop = nil 
TriggerReviveItemsChargesBackdrop = nil 
DigimonTTooltipTitleT = {} 
TriggerDigimonTTooltipTitleT = {} 
DigimonTTooltipDescriptionT = {} 
TriggerDigimonTTooltipDescriptionT = {} 
DigimonTTooltipStatusT = {} 
TriggerDigimonTTooltipStatusT = {} 
AreYouSure = nil 
TriggerAreYouSure = nil 
Yes = nil 
TriggerYes = nil 
No = nil 
TriggerNo = nil 
ReviveItemsCharges = nil 
TriggerReviveItemsCharges = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.UnstableDatasFunc = function() 
BlzFrameSetEnable(UnstableDatas, false) 
BlzFrameSetEnable(UnstableDatas, true) 
end 
 
REFORGEDUIMAKER.DigimonT00T00Func = function() 
BlzFrameSetEnable(DigimonT00T[0], false) 
BlzFrameSetEnable(DigimonT00T[0], true) 
end 
 
REFORGEDUIMAKER.ExitFunc = function() 
BlzFrameSetEnable(Exit, false) 
BlzFrameSetEnable(Exit, true) 
end 
 
REFORGEDUIMAKER.SummonFunc = function() 
BlzFrameSetEnable(Summon, false) 
BlzFrameSetEnable(Summon, true) 
end 
 
REFORGEDUIMAKER.FreeFunc = function() 
BlzFrameSetEnable(Free, false) 
BlzFrameSetEnable(Free, true) 
end 
 
REFORGEDUIMAKER.StoreFunc = function() 
BlzFrameSetEnable(Store, false) 
BlzFrameSetEnable(Store, true) 
end 
 
REFORGEDUIMAKER.DigimonT00T01Func = function() 
BlzFrameSetEnable(DigimonT00T[1], false) 
BlzFrameSetEnable(DigimonT00T[1], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T02Func = function() 
BlzFrameSetEnable(DigimonT00T[2], false) 
BlzFrameSetEnable(DigimonT00T[2], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T03Func = function() 
BlzFrameSetEnable(DigimonT00T[3], false) 
BlzFrameSetEnable(DigimonT00T[3], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T04Func = function() 
BlzFrameSetEnable(DigimonT00T[4], false) 
BlzFrameSetEnable(DigimonT00T[4], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T05Func = function() 
BlzFrameSetEnable(DigimonT00T[5], false) 
BlzFrameSetEnable(DigimonT00T[5], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T06Func = function() 
BlzFrameSetEnable(DigimonT00T[6], false) 
BlzFrameSetEnable(DigimonT00T[6], true) 
end 
 
REFORGEDUIMAKER.DigimonT00T07Func = function() 
BlzFrameSetEnable(DigimonT00T[7], false) 
BlzFrameSetEnable(DigimonT00T[7], true) 
end 
 
REFORGEDUIMAKER.YesFunc = function() 
BlzFrameSetEnable(Yes, false) 
BlzFrameSetEnable(Yes, true) 
end 
 
REFORGEDUIMAKER.NoFunc = function() 
BlzFrameSetEnable(No, false) 
BlzFrameSetEnable(No, true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


StockedDigimonsMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.00000, 0.420000)
BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.130000, 0.150000)

BackUnstableDatasProgress = BlzCreateFrameByType("BACKDROP", "BackUnstableDatasProgress", BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), "", 0)
BlzFrameSetAbsPoint(BackUnstableDatasProgress, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
BlzFrameSetAbsPoint(BackUnstableDatasProgress, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.520000)
BlzFrameSetTexture(BackUnstableDatasProgress, "", 0, true)

UnstableDatasProgress = BlzCreateFrameByType("SIMPLESTATUSBAR", "", BackUnstableDatasProgress, "", 0)
BlzFrameSetTexture(UnstableDatasProgress, "CustomFrame.png", 0, true)
BlzFrameSetAbsPoint(UnstableDatasProgress, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
BlzFrameSetAbsPoint(UnstableDatasProgress, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.520000)
BlzFrameSetValue(UnstableDatasProgress, 50)

UnstableDatas = BlzCreateFrame("IconButtonTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(UnstableDatas, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
BlzFrameSetAbsPoint(UnstableDatas, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.520000)

BackdropUnstableDatas = BlzCreateFrameByType("BACKDROP", "BackdropUnstableDatas", UnstableDatas, "", 0)
BlzFrameSetAllPoints(BackdropUnstableDatas, UnstableDatas)
BlzFrameSetTexture(BackdropUnstableDatas, "CustomFrame.png", 0, true)
TriggerUnstableDatas = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerUnstableDatas, UnstableDatas, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerUnstableDatas, REFORGEDUIMAKER.UnstableDatasFunc) 

DigimonT00T[0] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[0], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.040000)
BlzFrameSetPoint(DigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.19000)

BackdropDigimonT00T[0] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[0]", DigimonT00T[0], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[0], DigimonT00T[0])
BlzFrameSetTexture(BackdropDigimonT00T[0], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[0], DigimonT00T[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[0], REFORGEDUIMAKER.DigimonT00T00Func) 

Text = BlzCreateFrameByType("TEXT", "name", StockedDigimonsMenu, "", 0)
BlzFrameSetPoint(Text, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.015000)
BlzFrameSetPoint(Text, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.23500)
BlzFrameSetText(Text, "|cffFFCC00Choose a Digimon|r")
BlzFrameSetEnable(Text, false)
BlzFrameSetScale(Text, 1.00)
BlzFrameSetTextAlignment(Text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

Exit = BlzCreateFrame("BrowserButton", StockedDigimonsMenu, 0, 0)
BlzFrameSetAbsPoint(Exit, FRAMEPOINT_TOPLEFT, 0.340810, 0.314420)
BlzFrameSetAbsPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, 0.360810, 0.294420)
BlzFrameSetText(Exit, "|cffFCD20DX|r")
BlzFrameSetScale(Exit, 1.00)
TriggerExit = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerExit, REFORGEDUIMAKER.ExitFunc) 

Summon = BlzCreateFrame("BrowserButton", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(Summon, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
BlzFrameSetPoint(Summon, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.072500, 0.010000)
BlzFrameSetText(Summon, "|cffFCD20DSummon|r")
BlzFrameSetScale(Summon, 1.00)
TriggerSummon = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSummon, Summon, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSummon, REFORGEDUIMAKER.SummonFunc) 

Free = BlzCreateFrame("BrowserButton", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.065000, -0.23500)
BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.010000)
BlzFrameSetText(Free, "|cffFCD20DFree|r")
BlzFrameSetScale(Free, 1.00)
TriggerFree = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerFree, Free, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerFree, REFORGEDUIMAKER.FreeFunc) 

Store = BlzCreateFrame("BrowserButton", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.23500)
BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.065000, 0.010000)
BlzFrameSetText(Store, "|cffFCD20DStore|r")
BlzFrameSetScale(Store, 1.00)
TriggerStore = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerStore, Store, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerStore, REFORGEDUIMAKER.StoreFunc) 

DigimonTIsMain[0] = BlzCreateFrameByType("TEXT", "name", StockedDigimonsMenu, "", 0)
BlzFrameSetPoint(DigimonTIsMain[0], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.27940, -0.12563)
BlzFrameSetPoint(DigimonTIsMain[0], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.16440, 0.12937)
BlzFrameSetText(DigimonTIsMain[0], "|cff00ff00§|r")
BlzFrameSetEnable(DigimonTIsMain[0], false)
BlzFrameSetScale(DigimonTIsMain[0], 1.00)
BlzFrameSetTextAlignment(DigimonTIsMain[0], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_RIGHT)

DigimonT00T[1] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[1], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.040000)
BlzFrameSetPoint(DigimonT00T[1], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.19000)

BackdropDigimonT00T[1] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[1]", DigimonT00T[1], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[1], DigimonT00T[1])
BlzFrameSetTexture(BackdropDigimonT00T[1], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[1], DigimonT00T[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[1], REFORGEDUIMAKER.DigimonT00T01Func) 

DigimonT00T[2] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[2], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.090000)
BlzFrameSetPoint(DigimonT00T[2], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.14000)

BackdropDigimonT00T[2] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[2]", DigimonT00T[2], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[2], DigimonT00T[2])
BlzFrameSetTexture(BackdropDigimonT00T[2], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[2], DigimonT00T[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[2], REFORGEDUIMAKER.DigimonT00T02Func) 

DigimonT00T[3] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[3], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.090000)
BlzFrameSetPoint(DigimonT00T[3], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.14000)

BackdropDigimonT00T[3] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[3]", DigimonT00T[3], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[3], DigimonT00T[3])
BlzFrameSetTexture(BackdropDigimonT00T[3], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[3], DigimonT00T[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[3], REFORGEDUIMAKER.DigimonT00T03Func) 

DigimonT00T[4] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[4], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.14000)
BlzFrameSetPoint(DigimonT00T[4], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.090000)

BackdropDigimonT00T[4] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[4]", DigimonT00T[4], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[4], DigimonT00T[4])
BlzFrameSetTexture(BackdropDigimonT00T[4], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[4] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[4], DigimonT00T[4], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[4], REFORGEDUIMAKER.DigimonT00T04Func) 

DigimonT00T[5] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[5], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.14000)
BlzFrameSetPoint(DigimonT00T[5], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.090000)

BackdropDigimonT00T[5] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[5]", DigimonT00T[5], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[5], DigimonT00T[5])
BlzFrameSetTexture(BackdropDigimonT00T[5], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[5] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[5], DigimonT00T[5], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[5], REFORGEDUIMAKER.DigimonT00T05Func) 

DigimonT00T[6] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[6], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.19000)
BlzFrameSetPoint(DigimonT00T[6], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.040000)

BackdropDigimonT00T[6] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[6]", DigimonT00T[6], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[6], DigimonT00T[6])
BlzFrameSetTexture(BackdropDigimonT00T[6], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[6] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[6], DigimonT00T[6], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[6], REFORGEDUIMAKER.DigimonT00T06Func) 

DigimonT00T[7] = BlzCreateFrame("IconButtonTemplate", StockedDigimonsMenu, 0, 0)
BlzFrameSetPoint(DigimonT00T[7], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.19000)
BlzFrameSetPoint(DigimonT00T[7], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.040000)

BackdropDigimonT00T[7] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT00T[7]", DigimonT00T[7], "", 0)
BlzFrameSetAllPoints(BackdropDigimonT00T[7], DigimonT00T[7])
BlzFrameSetTexture(BackdropDigimonT00T[7], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
TriggerDigimonT00T[7] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonT00T[7], DigimonT00T[7], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonT00T[7], REFORGEDUIMAKER.DigimonT00T07Func) 

ReviveItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", StockedDigimonsMenu, "", 1)
BlzFrameSetPoint(ReviveItems, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.23000)
BlzFrameSetPoint(ReviveItems, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.030000, 0.010000)
BlzFrameSetTexture(ReviveItems, "CustomFrame.png", 0, true)

DigimonTTooltipT[0] = BlzCreateFrame("CheckListBox", DigimonT00T[0], 0, 0)
BlzFrameSetPoint(DigimonTTooltipT[0], FRAMEPOINT_TOPLEFT, DigimonT00T[0], FRAMEPOINT_TOPLEFT, 0.26610, 0.076840)
BlzFrameSetPoint(DigimonTTooltipT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, 0.36610, 0.0068400)

BlzFrameSetTooltip(DigimonT00T[0], DigimonTTooltipT[0])

DigimonTUsedT[0] = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonT00T[0], "", 1)
BlzFrameSetPoint(DigimonTUsedT[0], FRAMEPOINT_TOPLEFT, DigimonT00T[0], FRAMEPOINT_TOPLEFT, 0.39675, -0.076800)
BlzFrameSetPoint(DigimonTUsedT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, 0.39675, -0.076800)
BlzFrameSetTexture(DigimonTUsedT[0], "CustomFrame.png", 0, true)

DigimonTSelectedT[0] = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonT00T[0], "", 1)
BlzFrameSetPoint(DigimonTSelectedT[0], FRAMEPOINT_TOPLEFT, DigimonT00T[0], FRAMEPOINT_TOPLEFT, 0.43472, -0.0098780)
BlzFrameSetPoint(DigimonTSelectedT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, 0.43439, -0.0094900)
BlzFrameSetTexture(DigimonTSelectedT[0], "CustomFrame.png", 0, true)

DigimonTCooldownT[0] = BlzCreateFrameByType("TEXT", "name", DigimonT00T[0], "", 0)
BlzFrameSetPoint(DigimonTCooldownT[0], FRAMEPOINT_TOPLEFT, DigimonT00T[0], FRAMEPOINT_TOPLEFT, 0.35990, -0.029960)
BlzFrameSetPoint(DigimonTCooldownT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonT00T[0], FRAMEPOINT_BOTTOMRIGHT, 0.35990, -0.029960)
BlzFrameSetText(DigimonTCooldownT[0], "|cffffffff60|r")
BlzFrameSetEnable(DigimonTCooldownT[0], false)
BlzFrameSetScale(DigimonTCooldownT[0], 2.14)
BlzFrameSetTextAlignment(DigimonTCooldownT[0], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

Warning = BlzCreateFrame("QuestButtonBaseTemplate", Free, 0, 0)
BlzFrameSetPoint(Warning, FRAMEPOINT_TOPLEFT, Free, FRAMEPOINT_TOPLEFT, 0.18500, 0.035000)
BlzFrameSetPoint(Warning, FRAMEPOINT_BOTTOMRIGHT, Free, FRAMEPOINT_BOTTOMRIGHT, 0.25500, 0.0000)

ReviveItemsChargesBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", ReviveItems, "", 1)
BlzFrameSetPoint(ReviveItemsChargesBackdrop, FRAMEPOINT_TOPLEFT, ReviveItems, FRAMEPOINT_TOPLEFT, 0.015000, -0.017500)
BlzFrameSetPoint(ReviveItemsChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, ReviveItems, FRAMEPOINT_BOTTOMRIGHT, -2.7756e-17, -0.0025000)
BlzFrameSetTexture(ReviveItemsChargesBackdrop, "UI\\Widgets\\EscMenu\\Human\\blank-background.blp", 0, true)

DigimonTTooltipTitleT[0] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltipT[0], "", 0)
BlzFrameSetPoint(DigimonTTooltipTitleT[0], FRAMEPOINT_TOPLEFT, DigimonTTooltipT[0], FRAMEPOINT_TOPLEFT, 0.011160, -0.0085900)
BlzFrameSetPoint(DigimonTTooltipTitleT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipT[0], FRAMEPOINT_BOTTOMRIGHT, -0.0088400, 0.081410)
BlzFrameSetText(DigimonTTooltipTitleT[0], "|cffFFCC00Title|r")
BlzFrameSetEnable(DigimonTTooltipTitleT[0], false)
BlzFrameSetScale(DigimonTTooltipTitleT[0], 1.14)
BlzFrameSetTextAlignment(DigimonTTooltipTitleT[0], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

DigimonTTooltipDescriptionT[0] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltipT[0], "", 0)
BlzFrameSetPoint(DigimonTTooltipDescriptionT[0], FRAMEPOINT_TOPLEFT, DigimonTTooltipT[0], FRAMEPOINT_TOPLEFT, 0.015630, -0.026540)
BlzFrameSetPoint(DigimonTTooltipDescriptionT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipT[0], FRAMEPOINT_BOTTOMRIGHT, -0.0043700, 0.033460)
BlzFrameSetText(DigimonTTooltipDescriptionT[0], "|cffFFCC00Description|r")
BlzFrameSetEnable(DigimonTTooltipDescriptionT[0], false)
BlzFrameSetScale(DigimonTTooltipDescriptionT[0], 1.14)
BlzFrameSetTextAlignment(DigimonTTooltipDescriptionT[0], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonTTooltipStatusT[0] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltipT[0], "", 0)
BlzFrameSetPoint(DigimonTTooltipStatusT[0], FRAMEPOINT_TOPLEFT, DigimonTTooltipT[0], FRAMEPOINT_TOPLEFT, 0.0039000, -0.077034)
BlzFrameSetPoint(DigimonTTooltipStatusT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltipT[0], FRAMEPOINT_BOTTOMRIGHT, -0.026100, 0.013160)
BlzFrameSetText(DigimonTTooltipStatusT[0], "|cffFFCC00Status|r")
BlzFrameSetEnable(DigimonTTooltipStatusT[0], false)
BlzFrameSetScale(DigimonTTooltipStatusT[0], 1.14)
BlzFrameSetTextAlignment(DigimonTTooltipStatusT[0], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

AreYouSure = BlzCreateFrameByType("TEXT", "name", Warning, "", 0)
BlzFrameSetPoint(AreYouSure, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.010000, -0.0050000)
BlzFrameSetPoint(AreYouSure, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.025000)
BlzFrameSetText(AreYouSure, "|cffFFCC00Are you sure you wanna free this digimon?|r")
BlzFrameSetEnable(AreYouSure, false)
BlzFrameSetScale(AreYouSure, 1.00)
BlzFrameSetTextAlignment(AreYouSure, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

Yes = BlzCreateFrame("BrowserButton", Warning, 0, 0)
BlzFrameSetPoint(Yes, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.020000, -0.035000)
BlzFrameSetPoint(Yes, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.0050000)
BlzFrameSetText(Yes, "|cffFCD20DYes|r")
BlzFrameSetScale(Yes, 1.00)
TriggerYes = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerYes, Yes, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerYes, REFORGEDUIMAKER.YesFunc) 

No = BlzCreateFrame("BrowserButton", Warning, 0, 0)
BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
BlzFrameSetText(No, "|cffFCD20DNo|r")
BlzFrameSetScale(No, 1.00)
TriggerNo = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerNo, No, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerNo, REFORGEDUIMAKER.NoFunc) 

ReviveItemsCharges = BlzCreateFrameByType("TEXT", "name", ReviveItemsChargesBackdrop, "", 0)
BlzFrameSetPoint(ReviveItemsCharges, FRAMEPOINT_TOPLEFT, ReviveItemsChargesBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
BlzFrameSetPoint(ReviveItemsCharges, FRAMEPOINT_BOTTOMRIGHT, ReviveItemsChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0010000, 0.0000)
BlzFrameSetText(ReviveItemsCharges, "|cffffffff99|r")
BlzFrameSetEnable(ReviveItemsCharges, false)
BlzFrameSetScale(ReviveItemsCharges, 1.00)
BlzFrameSetTextAlignment(ReviveItemsCharges, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)
end
