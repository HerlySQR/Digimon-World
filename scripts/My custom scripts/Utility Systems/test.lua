ItemMenu = nil 
TriggerItemMenu = nil 
BuySlotMenu = nil 
TriggerBuySlotMenu = nil 
ExitItem = nil 
TriggerExitItem = nil 
SaveItemDrop = nil 
TriggerSaveItemDrop = nil 
SaveItemDiscard = nil 
TriggerSaveItemDiscard = nil 
SavedItemT = {} 
BackdropSavedItemT = {} 
TriggerSavedItemT = {} 
BuySlotMessage = nil 
TriggerBuySlotMessage = nil 
BuySlotYes = nil 
TriggerBuySlotYes = nil 
BuySlotNo = nil 
TriggerBuySlotNo = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.ExitItemFunc = function() 
BlzFrameSetEnable(ExitItem, false) 
BlzFrameSetEnable(ExitItem, true) 
end 
 
REFORGEDUIMAKER.SaveItemDropFunc = function() 
BlzFrameSetEnable(SaveItemDrop, false) 
BlzFrameSetEnable(SaveItemDrop, true) 
end 
 
REFORGEDUIMAKER.SaveItemDiscardFunc = function() 
BlzFrameSetEnable(SaveItemDiscard, false) 
BlzFrameSetEnable(SaveItemDiscard, true) 
end 
 
REFORGEDUIMAKER.SavedItemT00Func = function() 
BlzFrameSetEnable(SavedItemT[0], false) 
BlzFrameSetEnable(SavedItemT[0], true) 
end 
 
REFORGEDUIMAKER.SavedItemT01Func = function() 
BlzFrameSetEnable(SavedItemT[1], false) 
BlzFrameSetEnable(SavedItemT[1], true) 
end 
 
REFORGEDUIMAKER.SavedItemT02Func = function() 
BlzFrameSetEnable(SavedItemT[2], false) 
BlzFrameSetEnable(SavedItemT[2], true) 
end 
 
REFORGEDUIMAKER.SavedItemT03Func = function() 
BlzFrameSetEnable(SavedItemT[3], false) 
BlzFrameSetEnable(SavedItemT[3], true) 
end 
 
REFORGEDUIMAKER.SavedItemT04Func = function() 
BlzFrameSetEnable(SavedItemT[4], false) 
BlzFrameSetEnable(SavedItemT[4], true) 
end 
 
REFORGEDUIMAKER.SavedItemT05Func = function() 
BlzFrameSetEnable(SavedItemT[5], false) 
BlzFrameSetEnable(SavedItemT[5], true) 
end 
 
REFORGEDUIMAKER.SavedItemT06Func = function() 
BlzFrameSetEnable(SavedItemT[6], false) 
BlzFrameSetEnable(SavedItemT[6], true) 
end 
 
REFORGEDUIMAKER.SavedItemT07Func = function() 
BlzFrameSetEnable(SavedItemT[7], false) 
BlzFrameSetEnable(SavedItemT[7], true) 
end 
 
REFORGEDUIMAKER.SavedItemT08Func = function() 
BlzFrameSetEnable(SavedItemT[8], false) 
BlzFrameSetEnable(SavedItemT[8], true) 
end 
 
REFORGEDUIMAKER.SavedItemT09Func = function() 
BlzFrameSetEnable(SavedItemT[9], false) 
BlzFrameSetEnable(SavedItemT[9], true) 
end 
 
REFORGEDUIMAKER.SavedItemT10Func = function() 
BlzFrameSetEnable(SavedItemT[10], false) 
BlzFrameSetEnable(SavedItemT[10], true) 
end 
 
REFORGEDUIMAKER.SavedItemT11Func = function() 
BlzFrameSetEnable(SavedItemT[11], false) 
BlzFrameSetEnable(SavedItemT[11], true) 
end 
 
REFORGEDUIMAKER.SavedItemT12Func = function() 
BlzFrameSetEnable(SavedItemT[12], false) 
BlzFrameSetEnable(SavedItemT[12], true) 
end 
 
REFORGEDUIMAKER.SavedItemT13Func = function() 
BlzFrameSetEnable(SavedItemT[13], false) 
BlzFrameSetEnable(SavedItemT[13], true) 
end 
 
REFORGEDUIMAKER.SavedItemT14Func = function() 
BlzFrameSetEnable(SavedItemT[14], false) 
BlzFrameSetEnable(SavedItemT[14], true) 
end 
 
REFORGEDUIMAKER.SavedItemT15Func = function() 
BlzFrameSetEnable(SavedItemT[15], false) 
BlzFrameSetEnable(SavedItemT[15], true) 
end 
 
REFORGEDUIMAKER.SavedItemT16Func = function() 
BlzFrameSetEnable(SavedItemT[16], false) 
BlzFrameSetEnable(SavedItemT[16], true) 
end 
 
REFORGEDUIMAKER.SavedItemT17Func = function() 
BlzFrameSetEnable(SavedItemT[17], false) 
BlzFrameSetEnable(SavedItemT[17], true) 
end 
 
REFORGEDUIMAKER.SavedItemT18Func = function() 
BlzFrameSetEnable(SavedItemT[18], false) 
BlzFrameSetEnable(SavedItemT[18], true) 
end 
 
REFORGEDUIMAKER.SavedItemT19Func = function() 
BlzFrameSetEnable(SavedItemT[19], false) 
BlzFrameSetEnable(SavedItemT[19], true) 
end 
 
REFORGEDUIMAKER.SavedItemT20Func = function() 
BlzFrameSetEnable(SavedItemT[20], false) 
BlzFrameSetEnable(SavedItemT[20], true) 
end 
 
REFORGEDUIMAKER.SavedItemT21Func = function() 
BlzFrameSetEnable(SavedItemT[21], false) 
BlzFrameSetEnable(SavedItemT[21], true) 
end 
 
REFORGEDUIMAKER.SavedItemT22Func = function() 
BlzFrameSetEnable(SavedItemT[22], false) 
BlzFrameSetEnable(SavedItemT[22], true) 
end 
 
REFORGEDUIMAKER.SavedItemT23Func = function() 
BlzFrameSetEnable(SavedItemT[23], false) 
BlzFrameSetEnable(SavedItemT[23], true) 
end 
 
REFORGEDUIMAKER.BuySlotYesFunc = function() 
BlzFrameSetEnable(BuySlotYes, false) 
BlzFrameSetEnable(BuySlotYes, true) 
end 
 
REFORGEDUIMAKER.BuySlotNoFunc = function() 
BlzFrameSetEnable(BuySlotNo, false) 
BlzFrameSetEnable(BuySlotNo, true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


ItemMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_TOPLEFT, 0.210000, 0.500000)
BlzFrameSetAbsPoint(ItemMenu, FRAMEPOINT_BOTTOMRIGHT, 0.570000, 0.200000)

BuySlotMenu = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.300000, 0.420000)
BlzFrameSetAbsPoint(BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, 0.480000, 0.300000)

ExitItem = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
BlzFrameSetPoint(ExitItem, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.33000, -0.0050000)
BlzFrameSetPoint(ExitItem, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.27000)
BlzFrameSetText(ExitItem, "|cffFCD20DX|r")
BlzFrameSetScale(ExitItem, 1.00)
TriggerExitItem = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerExitItem, ExitItem, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerExitItem, REFORGEDUIMAKER.ExitItemFunc) 

SaveItemDrop = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.070000, -0.25000)
BlzFrameSetPoint(SaveItemDrop, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.19000, 0.020000)
BlzFrameSetText(SaveItemDrop, "|cffFCD20DDrop|r")
BlzFrameSetScale(SaveItemDrop, 1.00)
TriggerSaveItemDrop = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSaveItemDrop, SaveItemDrop, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSaveItemDrop, REFORGEDUIMAKER.SaveItemDropFunc) 

SaveItemDiscard = BlzCreateFrame("ScriptDialogButton", ItemMenu, 0, 0)
BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.19000, -0.25000)
BlzFrameSetPoint(SaveItemDiscard, FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.020000)
BlzFrameSetText(SaveItemDiscard, "|cffFCD20DDiscard|r")
BlzFrameSetScale(SaveItemDiscard, 1.00)
TriggerSaveItemDiscard = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSaveItemDiscard, SaveItemDiscard, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSaveItemDiscard, REFORGEDUIMAKER.SaveItemDiscardFunc) 

SavedItemT[0] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[0], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.040000)
BlzFrameSetPoint(SavedItemT[0], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.28000, 0.21000)

BackdropSavedItemT[0] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[0]", SavedItemT[0], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[0], SavedItemT[0])
BlzFrameSetTexture(BackdropSavedItemT[0], "CustomFrame.png", 0, true)
TriggerSavedItemT[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[0], SavedItemT[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[0], REFORGEDUIMAKER.SavedItemT00Func) 

SavedItemT[1] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[1], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.080000, -0.040000)
BlzFrameSetPoint(SavedItemT[1], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.21000)

BackdropSavedItemT[1] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[1]", SavedItemT[1], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[1], SavedItemT[1])
BlzFrameSetTexture(BackdropSavedItemT[1], "CustomFrame.png", 0, true)
TriggerSavedItemT[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[1], SavedItemT[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[1], REFORGEDUIMAKER.SavedItemT01Func) 

SavedItemT[2] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[2], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.040000)
BlzFrameSetPoint(SavedItemT[2], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.18000, 0.21000)

BackdropSavedItemT[2] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[2]", SavedItemT[2], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[2], SavedItemT[2])
BlzFrameSetTexture(BackdropSavedItemT[2], "CustomFrame.png", 0, true)
TriggerSavedItemT[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[2], SavedItemT[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[2], REFORGEDUIMAKER.SavedItemT02Func) 

SavedItemT[3] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[3], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.18000, -0.040000)
BlzFrameSetPoint(SavedItemT[3], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.21000)

BackdropSavedItemT[3] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[3]", SavedItemT[3], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[3], SavedItemT[3])
BlzFrameSetTexture(BackdropSavedItemT[3], "CustomFrame.png", 0, true)
TriggerSavedItemT[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[3], SavedItemT[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[3], REFORGEDUIMAKER.SavedItemT03Func) 

SavedItemT[4] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[4], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.040000)
BlzFrameSetPoint(SavedItemT[4], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.080000, 0.21000)

BackdropSavedItemT[4] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[4]", SavedItemT[4], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[4], SavedItemT[4])
BlzFrameSetTexture(BackdropSavedItemT[4], "CustomFrame.png", 0, true)
TriggerSavedItemT[4] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[4], SavedItemT[4], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[4], REFORGEDUIMAKER.SavedItemT04Func) 

SavedItemT[5] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[5], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.28000, -0.040000)
BlzFrameSetPoint(SavedItemT[5], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.21000)

BackdropSavedItemT[5] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[5]", SavedItemT[5], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[5], SavedItemT[5])
BlzFrameSetTexture(BackdropSavedItemT[5], "CustomFrame.png", 0, true)
TriggerSavedItemT[5] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[5], SavedItemT[5], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[5], REFORGEDUIMAKER.SavedItemT05Func) 

SavedItemT[6] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[6], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.090000)
BlzFrameSetPoint(SavedItemT[6], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.28000, 0.16000)

BackdropSavedItemT[6] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[6]", SavedItemT[6], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[6], SavedItemT[6])
BlzFrameSetTexture(BackdropSavedItemT[6], "CustomFrame.png", 0, true)
TriggerSavedItemT[6] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[6], SavedItemT[6], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[6], REFORGEDUIMAKER.SavedItemT06Func) 

SavedItemT[7] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[7], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.080000, -0.090000)
BlzFrameSetPoint(SavedItemT[7], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.16000)

BackdropSavedItemT[7] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[7]", SavedItemT[7], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[7], SavedItemT[7])
BlzFrameSetTexture(BackdropSavedItemT[7], "CustomFrame.png", 0, true)
TriggerSavedItemT[7] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[7], SavedItemT[7], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[7], REFORGEDUIMAKER.SavedItemT07Func) 

SavedItemT[8] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[8], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.090000)
BlzFrameSetPoint(SavedItemT[8], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.18000, 0.16000)

BackdropSavedItemT[8] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[8]", SavedItemT[8], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[8], SavedItemT[8])
BlzFrameSetTexture(BackdropSavedItemT[8], "CustomFrame.png", 0, true)
TriggerSavedItemT[8] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[8], SavedItemT[8], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[8], REFORGEDUIMAKER.SavedItemT08Func) 

SavedItemT[9] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[9], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.18000, -0.090000)
BlzFrameSetPoint(SavedItemT[9], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.16000)

BackdropSavedItemT[9] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[9]", SavedItemT[9], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[9], SavedItemT[9])
BlzFrameSetTexture(BackdropSavedItemT[9], "CustomFrame.png", 0, true)
TriggerSavedItemT[9] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[9], SavedItemT[9], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[9], REFORGEDUIMAKER.SavedItemT09Func) 

SavedItemT[10] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[10], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.090000)
BlzFrameSetPoint(SavedItemT[10], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.080000, 0.16000)

BackdropSavedItemT[10] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[10]", SavedItemT[10], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[10], SavedItemT[10])
BlzFrameSetTexture(BackdropSavedItemT[10], "CustomFrame.png", 0, true)
TriggerSavedItemT[10] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[10], SavedItemT[10], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[10], REFORGEDUIMAKER.SavedItemT10Func) 

SavedItemT[11] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[11], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.28000, -0.090000)
BlzFrameSetPoint(SavedItemT[11], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.16000)

BackdropSavedItemT[11] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[11]", SavedItemT[11], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[11], SavedItemT[11])
BlzFrameSetTexture(BackdropSavedItemT[11], "CustomFrame.png", 0, true)
TriggerSavedItemT[11] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[11], SavedItemT[11], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[11], REFORGEDUIMAKER.SavedItemT11Func) 

SavedItemT[12] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[12], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14000)
BlzFrameSetPoint(SavedItemT[12], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.28000, 0.11000)

BackdropSavedItemT[12] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[12]", SavedItemT[12], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[12], SavedItemT[12])
BlzFrameSetTexture(BackdropSavedItemT[12], "CustomFrame.png", 0, true)
TriggerSavedItemT[12] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[12], SavedItemT[12], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[12], REFORGEDUIMAKER.SavedItemT12Func) 

SavedItemT[13] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[13], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.080000, -0.14000)
BlzFrameSetPoint(SavedItemT[13], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.11000)

BackdropSavedItemT[13] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[13]", SavedItemT[13], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[13], SavedItemT[13])
BlzFrameSetTexture(BackdropSavedItemT[13], "CustomFrame.png", 0, true)
TriggerSavedItemT[13] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[13], SavedItemT[13], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[13], REFORGEDUIMAKER.SavedItemT13Func) 

SavedItemT[14] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[14], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.14000)
BlzFrameSetPoint(SavedItemT[14], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.18000, 0.11000)

BackdropSavedItemT[14] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[14]", SavedItemT[14], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[14], SavedItemT[14])
BlzFrameSetTexture(BackdropSavedItemT[14], "CustomFrame.png", 0, true)
TriggerSavedItemT[14] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[14], SavedItemT[14], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[14], REFORGEDUIMAKER.SavedItemT14Func) 

SavedItemT[15] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[15], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.18000, -0.14000)
BlzFrameSetPoint(SavedItemT[15], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.11000)

BackdropSavedItemT[15] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[15]", SavedItemT[15], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[15], SavedItemT[15])
BlzFrameSetTexture(BackdropSavedItemT[15], "CustomFrame.png", 0, true)
TriggerSavedItemT[15] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[15], SavedItemT[15], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[15], REFORGEDUIMAKER.SavedItemT15Func) 

SavedItemT[16] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[16], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.14000)
BlzFrameSetPoint(SavedItemT[16], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.080000, 0.11000)

BackdropSavedItemT[16] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[16]", SavedItemT[16], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[16], SavedItemT[16])
BlzFrameSetTexture(BackdropSavedItemT[16], "CustomFrame.png", 0, true)
TriggerSavedItemT[16] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[16], SavedItemT[16], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[16], REFORGEDUIMAKER.SavedItemT16Func) 

SavedItemT[17] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[17], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.28000, -0.14000)
BlzFrameSetPoint(SavedItemT[17], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.11000)

BackdropSavedItemT[17] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[17]", SavedItemT[17], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[17], SavedItemT[17])
BlzFrameSetTexture(BackdropSavedItemT[17], "CustomFrame.png", 0, true)
TriggerSavedItemT[17] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[17], SavedItemT[17], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[17], REFORGEDUIMAKER.SavedItemT17Func) 

SavedItemT[18] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[18], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.19000)
BlzFrameSetPoint(SavedItemT[18], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.28000, 0.060000)

BackdropSavedItemT[18] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[18]", SavedItemT[18], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[18], SavedItemT[18])
BlzFrameSetTexture(BackdropSavedItemT[18], "CustomFrame.png", 0, true)
TriggerSavedItemT[18] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[18], SavedItemT[18], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[18], REFORGEDUIMAKER.SavedItemT18Func) 

SavedItemT[19] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[19], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.080000, -0.19000)
BlzFrameSetPoint(SavedItemT[19], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.060000)

BackdropSavedItemT[19] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[19]", SavedItemT[19], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[19], SavedItemT[19])
BlzFrameSetTexture(BackdropSavedItemT[19], "CustomFrame.png", 0, true)
TriggerSavedItemT[19] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[19], SavedItemT[19], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[19], REFORGEDUIMAKER.SavedItemT19Func) 

SavedItemT[20] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[20], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.13000, -0.19000)
BlzFrameSetPoint(SavedItemT[20], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.18000, 0.060000)

BackdropSavedItemT[20] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[20]", SavedItemT[20], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[20], SavedItemT[20])
BlzFrameSetTexture(BackdropSavedItemT[20], "CustomFrame.png", 0, true)
TriggerSavedItemT[20] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[20], SavedItemT[20], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[20], REFORGEDUIMAKER.SavedItemT20Func) 

SavedItemT[21] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[21], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.18000, -0.19000)
BlzFrameSetPoint(SavedItemT[21], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.060000)

BackdropSavedItemT[21] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[21]", SavedItemT[21], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[21], SavedItemT[21])
BlzFrameSetTexture(BackdropSavedItemT[21], "CustomFrame.png", 0, true)
TriggerSavedItemT[21] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[21], SavedItemT[21], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[21], REFORGEDUIMAKER.SavedItemT21Func) 

SavedItemT[22] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[22], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.19000)
BlzFrameSetPoint(SavedItemT[22], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.080000, 0.060000)

BackdropSavedItemT[22] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[22]", SavedItemT[22], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[22], SavedItemT[22])
BlzFrameSetTexture(BackdropSavedItemT[22], "CustomFrame.png", 0, true)
TriggerSavedItemT[22] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[22], SavedItemT[22], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[22], REFORGEDUIMAKER.SavedItemT22Func) 

SavedItemT[23] = BlzCreateFrame("IconButtonTemplate", ItemMenu, 0, 0)
BlzFrameSetPoint(SavedItemT[23], FRAMEPOINT_TOPLEFT, ItemMenu, FRAMEPOINT_TOPLEFT, 0.28000, -0.19000)
BlzFrameSetPoint(SavedItemT[23], FRAMEPOINT_BOTTOMRIGHT, ItemMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.060000)

BackdropSavedItemT[23] = BlzCreateFrameByType("BACKDROP", "BackdropSavedItemT[23]", SavedItemT[23], "", 0)
BlzFrameSetAllPoints(BackdropSavedItemT[23], SavedItemT[23])
BlzFrameSetTexture(BackdropSavedItemT[23], "CustomFrame.png", 0, true)
TriggerSavedItemT[23] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSavedItemT[23], SavedItemT[23], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSavedItemT[23], REFORGEDUIMAKER.SavedItemT23Func) 

BuySlotMessage = BlzCreateFrameByType("TEXT", "name", BuySlotMenu, "", 0)
BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
BlzFrameSetPoint(BuySlotMessage, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.035000)
BlzFrameSetText(BuySlotMessage, "|cffffffffDo you want to buy a new digimon slot for 9999 digibits and 99 digicrystals?|r")
BlzFrameSetEnable(BuySlotMessage, false)
BlzFrameSetScale(BuySlotMessage, 1.43)
BlzFrameSetTextAlignment(BuySlotMessage, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

BuySlotYes = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.025000, -0.087500)
BlzFrameSetPoint(BuySlotYes, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10500, 0.0025000)
BlzFrameSetText(BuySlotYes, "|cffFCD20DYes|r")
BlzFrameSetScale(BuySlotYes, 1.00)
TriggerBuySlotYes = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBuySlotYes, BuySlotYes, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBuySlotYes, REFORGEDUIMAKER.BuySlotYesFunc) 

BuySlotNo = BlzCreateFrame("ScriptDialogButton", BuySlotMenu, 0, 0)
BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_TOPLEFT, BuySlotMenu, FRAMEPOINT_TOPLEFT, 0.10500, -0.087500)
BlzFrameSetPoint(BuySlotNo, FRAMEPOINT_BOTTOMRIGHT, BuySlotMenu, FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.0025000)
BlzFrameSetText(BuySlotNo, "|cffFCD20DNo|r")
BlzFrameSetScale(BuySlotNo, 1.00)
TriggerBuySlotNo = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBuySlotNo, BuySlotNo, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBuySlotNo, REFORGEDUIMAKER.BuySlotNoFunc) 
end
