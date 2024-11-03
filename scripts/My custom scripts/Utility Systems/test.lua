ReleaseDigimon = nil 
TriggerReleaseDigimon = nil 
BackpackMenu = nil 
TriggerBackpackMenu = nil 
Backpack = nil 
BackdropBackpack = nil 
TriggerBackpack = nil 
SaveItem = nil 
BackdropSaveItem = nil 
TriggerSaveItem = nil 
BackpackText = nil 
TriggerBackpackText = nil 
BackpackItems = nil 
TriggerBackpackItems = nil 
BackpackDiscard = nil 
TriggerBackpackDiscard = nil 
BackpackDrop = nil 
TriggerBackpackDrop = nil 
BackpackItemT = {} 
BackdropBackpackItemT = {} 
TriggerBackpackItemT = {} 
BackpackItemTooltip = nil 
TriggerBackpackItemTooltip = nil 
BackPackItemChargesBackdrop = nil 
TriggerBackPackItemChargesBackdrop = nil 
BackpackItemTooltipText = nil 
TriggerBackpackItemTooltipText = nil 
BackPackItemCharges = nil 
TriggerBackPackItemCharges = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.ReleaseDigimonFunc = function() 
BlzFrameSetEnable(ReleaseDigimon, false) 
BlzFrameSetEnable(ReleaseDigimon, true) 
end 
 
REFORGEDUIMAKER.BackpackFunc = function() 
BlzFrameSetEnable(Backpack, false) 
BlzFrameSetEnable(Backpack, true) 
end 
 
REFORGEDUIMAKER.SaveItemFunc = function() 
BlzFrameSetEnable(SaveItem, false) 
BlzFrameSetEnable(SaveItem, true) 
end 
 
REFORGEDUIMAKER.BackpackDiscardFunc = function() 
BlzFrameSetEnable(BackpackDiscard, false) 
BlzFrameSetEnable(BackpackDiscard, true) 
end 
 
REFORGEDUIMAKER.BackpackDropFunc = function() 
BlzFrameSetEnable(BackpackDrop, false) 
BlzFrameSetEnable(BackpackDrop, true) 
end 
 
REFORGEDUIMAKER.BackpackItemT00Func = function() 
BlzFrameSetEnable(BackpackItemT[0], false) 
BlzFrameSetEnable(BackpackItemT[0], true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


ReleaseDigimon = BlzCreateFrame("ScriptDialogButton", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(ReleaseDigimon, FRAMEPOINT_TOPLEFT, 0.0102700, 0.206190)
BlzFrameSetAbsPoint(ReleaseDigimon, FRAMEPOINT_BOTTOMRIGHT, 0.140270, 0.171190)
BlzFrameSetText(ReleaseDigimon, "|cffFCD20DSummon/Store a Digimon|r")
BlzFrameSetScale(ReleaseDigimon, 0.858)
TriggerReleaseDigimon = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerReleaseDigimon, ReleaseDigimon, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerReleaseDigimon, REFORGEDUIMAKER.ReleaseDigimonFunc) 

BackpackMenu = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_TOPLEFT, 0.675000, 0.345000)
BlzFrameSetAbsPoint(BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, 0.830000, 0.145000)

Backpack = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_TOPLEFT, 0.747500, 0.0900000)
BlzFrameSetAbsPoint(Backpack, FRAMEPOINT_BOTTOMRIGHT, 0.787500, 0.0500000)

BackdropBackpack = BlzCreateFrameByType("BACKDROP", "BackdropBackpack", Backpack, "", 0)
BlzFrameSetAllPoints(BackdropBackpack, Backpack)
BlzFrameSetTexture(BackdropBackpack, "CustomFrame.png", 0, true)
TriggerBackpack = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBackpack, Backpack, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBackpack, REFORGEDUIMAKER.BackpackFunc) 

SaveItem = BlzCreateFrame("IconButtonTemplate", ReleaseDigimon, 0, 0)
BlzFrameSetPoint(SaveItem, FRAMEPOINT_TOPLEFT, ReleaseDigimon, FRAMEPOINT_TOPLEFT, 0.13973, -0.0011900)
BlzFrameSetPoint(SaveItem, FRAMEPOINT_BOTTOMRIGHT, ReleaseDigimon, FRAMEPOINT_BOTTOMRIGHT, 0.044730, -0.0011900)

BackdropSaveItem = BlzCreateFrameByType("BACKDROP", "BackdropSaveItem", SaveItem, "", 0)
BlzFrameSetAllPoints(BackdropSaveItem, SaveItem)
BlzFrameSetTexture(BackdropSaveItem, "CustomFrame.png", 0, true)
TriggerSaveItem = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerSaveItem, SaveItem, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerSaveItem, REFORGEDUIMAKER.SaveItemFunc) 

BackpackText = BlzCreateFrameByType("TEXT", "name", BackpackMenu, "", 0)
BlzFrameSetPoint(BackpackText, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
BlzFrameSetPoint(BackpackText, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.16000)
BlzFrameSetText(BackpackText, "|cffFFCC00Use an item\n|r")
BlzFrameSetEnable(BackpackText, false)
BlzFrameSetScale(BackpackText, 1.00)
BlzFrameSetTextAlignment(BackpackText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

BackpackItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", BackpackMenu, "", 1)
BlzFrameSetPoint(BackpackItems, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.030000)
BlzFrameSetPoint(BackpackItems, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.045000)
BlzFrameSetTexture(BackpackItems, "CustomFrame.png", 0, true)

BackpackDiscard = BlzCreateFrame("BrowserButton", BackpackMenu, 0, 0)
BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.095000, -0.16000)
BlzFrameSetPoint(BackpackDiscard, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.015000)
BlzFrameSetText(BackpackDiscard, "|cffFCD20DDiscard|r")
BlzFrameSetScale(BackpackDiscard, 0.858)
TriggerBackpackDiscard = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBackpackDiscard, BackpackDiscard, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBackpackDiscard, REFORGEDUIMAKER.BackpackDiscardFunc) 

BackpackDrop = BlzCreateFrame("BrowserButton", BackpackMenu, 0, 0)
BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_TOPLEFT, BackpackMenu, FRAMEPOINT_TOPLEFT, 0.015000, -0.16000)
BlzFrameSetPoint(BackpackDrop, FRAMEPOINT_BOTTOMRIGHT, BackpackMenu, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.015000)
BlzFrameSetText(BackpackDrop, "|cffFCD20DDrop|r")
BlzFrameSetScale(BackpackDrop, 0.858)
TriggerBackpackDrop = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBackpackDrop, BackpackDrop, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBackpackDrop, REFORGEDUIMAKER.BackpackDropFunc) 

BackpackItemT[0] = BlzCreateFrame("IconButtonTemplate", BackpackItems, 0, 0)
BlzFrameSetPoint(BackpackItemT[0], FRAMEPOINT_TOPLEFT, BackpackItems, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
BlzFrameSetPoint(BackpackItemT[0], FRAMEPOINT_BOTTOMRIGHT, BackpackItems, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.10000)

BackdropBackpackItemT[0] = BlzCreateFrameByType("BACKDROP", "BackdropBackpackItemT[0]", BackpackItemT[0], "", 0)
BlzFrameSetAllPoints(BackdropBackpackItemT[0], BackpackItemT[0])
BlzFrameSetTexture(BackdropBackpackItemT[0], "CustomFrame.png", 0, true)
TriggerBackpackItemT[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerBackpackItemT[0], BackpackItemT[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerBackpackItemT[0], REFORGEDUIMAKER.BackpackItemT00Func) 

BackpackItemTooltip = BlzCreateFrame("CheckListBox", BackpackItemT[0], 0, 0)
BlzFrameSetPoint(BackpackItemTooltip, FRAMEPOINT_TOPLEFT, BackpackItemT[0], FRAMEPOINT_TOPLEFT, -0.090000, 0.075000)
BlzFrameSetPoint(BackpackItemTooltip, FRAMEPOINT_BOTTOMRIGHT, BackpackItemT[0], FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.0000)

BlzFrameSetTooltip(BackpackItemT[0], BackpackItemTooltip)

BackPackItemChargesBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BackpackItemT[0], "", 1)
BlzFrameSetPoint(BackPackItemChargesBackdrop, FRAMEPOINT_TOPLEFT, BackpackItemT[0], FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
BlzFrameSetPoint(BackPackItemChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, BackpackItemT[0], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
BlzFrameSetTexture(BackPackItemChargesBackdrop, "UI\\Widgets\\EscMenu\\Human\\blank-background.blp", 0, true)

BackpackItemTooltipText = BlzCreateFrameByType("TEXT", "name", BackpackItemTooltip, "", 0)
BlzFrameSetPoint(BackpackItemTooltipText, FRAMEPOINT_TOPLEFT, BackpackItemTooltip, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
BlzFrameSetPoint(BackpackItemTooltipText, FRAMEPOINT_BOTTOMRIGHT, BackpackItemTooltip, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.020000)
BlzFrameSetText(BackpackItemTooltipText, "|cffFFCC00TextFrametesting|r")
BlzFrameSetEnable(BackpackItemTooltipText, false)
BlzFrameSetScale(BackpackItemTooltipText, 1.00)
BlzFrameSetTextAlignment(BackpackItemTooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

BackPackItemCharges = BlzCreateFrameByType("TEXT", "name", BackPackItemChargesBackdrop, "", 0)
BlzFrameSetPoint(BackPackItemCharges, FRAMEPOINT_TOPLEFT, BackPackItemChargesBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, -0.0020000)
BlzFrameSetPoint(BackPackItemCharges, FRAMEPOINT_BOTTOMRIGHT, BackPackItemChargesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.0010000, 0.0000)
BlzFrameSetText(BackPackItemCharges, "|cffffffff99|r")
BlzFrameSetEnable(BackPackItemCharges, false)
BlzFrameSetScale(BackPackItemCharges, 0.572)
BlzFrameSetTextAlignment(BackPackItemCharges, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)
end
