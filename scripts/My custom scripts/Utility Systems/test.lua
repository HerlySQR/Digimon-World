HotkeyMenu = nil 
TriggerHotkeyMenu = nil 
HotkeyBackpackSubMenu = nil 
TriggerHotkeyBackpackSubMenu = nil 
HotkeyBackpack = nil 
TriggerHotkeyBackpack = nil 
HotkeyExit = nil 
TriggerHotkeyExit = nil 
HotkeySave = nil 
TriggerHotkeySave = nil 
HotkeyMessage = nil 
TriggerHotkeyMessage = nil 
HotkeyYourDigimons = nil 
TriggerHotkeyYourDigimons = nil 
HotkeyYourDigimonsSubMenu = nil 
TriggerHotkeyYourDigimonsSubMenu = nil 
HotkeyBackpackSubMenuBackdrop = nil 
TriggerHotkeyBackpackSubMenuBackdrop = nil 
HotkeyBackpackSubMenuButton = nil 
BackdropHotkeyBackpackSubMenuButton = nil 
TriggerHotkeyBackpackSubMenuButton = nil 
HotkeyYourDigimonsSubMenuBackdrop = nil 
TriggerHotkeyYourDigimonsSubMenuBackdrop = nil 
HotkeyYourDigimonsSubMenuButton = nil 
BackdropHotkeyYourDigimonsSubMenuButton = nil 
TriggerHotkeyYourDigimonsSubMenuButton = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.HotkeyBackpackFunc = function() 
BlzFrameSetEnable(HotkeyBackpack, false) 
BlzFrameSetEnable(HotkeyBackpack, true) 
end 
 
REFORGEDUIMAKER.HotkeyExitFunc = function() 
BlzFrameSetEnable(HotkeyExit, false) 
BlzFrameSetEnable(HotkeyExit, true) 
end 
 
REFORGEDUIMAKER.HotkeySaveFunc = function() 
BlzFrameSetEnable(HotkeySave, false) 
BlzFrameSetEnable(HotkeySave, true) 
end 
 
REFORGEDUIMAKER.HotkeyYourDigimonsFunc = function() 
BlzFrameSetEnable(HotkeyYourDigimons, false) 
BlzFrameSetEnable(HotkeyYourDigimons, true) 
end 
 
REFORGEDUIMAKER.HotkeyBackpackSubMenuButtonFunc = function() 
BlzFrameSetEnable(HotkeyBackpackSubMenuButton, false) 
BlzFrameSetEnable(HotkeyBackpackSubMenuButton, true) 
end 
 
REFORGEDUIMAKER.HotkeyYourDigimonsSubMenuButtonFunc = function() 
BlzFrameSetEnable(HotkeyYourDigimonsSubMenuButton, false) 
BlzFrameSetEnable(HotkeyYourDigimonsSubMenuButton, true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


HotkeyMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.140000, 0.530000)
BlzFrameSetAbsPoint(HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, 0.660000, 0.190000)

HotkeyBackpackSubMenu = BlzCreateFrameByType("BACKDROP", "BACKDROP", HotkeyMenu, "", 1)
BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.030000)
BlzFrameSetPoint(HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.050000)
BlzFrameSetTexture(HotkeyBackpackSubMenu, "CustomFrame.png", 0, true)

HotkeyBackpack = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.080000)
BlzFrameSetPoint(HotkeyBackpack, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.30000, 0.22000)
BlzFrameSetText(HotkeyBackpack, "|cffFCD20DBackpack|r")
BlzFrameSetScale(HotkeyBackpack, 1.29)
TriggerHotkeyBackpack = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeyBackpack, HotkeyBackpack, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeyBackpack, REFORGEDUIMAKER.HotkeyBackpackFunc) 

HotkeyExit = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.34000, -0.30000)
BlzFrameSetPoint(HotkeyExit, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.010000)
BlzFrameSetText(HotkeyExit, "|cffFCD20DExit|r")
BlzFrameSetScale(HotkeyExit, 1.00)
TriggerHotkeyExit = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeyExit, HotkeyExit, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeyExit, REFORGEDUIMAKER.HotkeyExitFunc) 

HotkeySave = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
BlzFrameSetPoint(HotkeySave, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.10000, -0.30000)
BlzFrameSetPoint(HotkeySave, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
BlzFrameSetText(HotkeySave, "|cffFCD20DSave|r")
BlzFrameSetScale(HotkeySave, 1.00)
TriggerHotkeySave = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeySave, HotkeySave, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeySave, REFORGEDUIMAKER.HotkeySaveFunc) 

HotkeyMessage = BlzCreateFrameByType("TEXT", "name", HotkeyMenu, "", 0)
BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.020000)
BlzFrameSetPoint(HotkeyMessage, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.29000)
BlzFrameSetText(HotkeyMessage, "|cffFFCC00Press a key to set the hotkey|r")
BlzFrameSetEnable(HotkeyMessage, false)
BlzFrameSetScale(HotkeyMessage, 1.00)
BlzFrameSetTextAlignment(HotkeyMessage, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

HotkeyYourDigimons = BlzCreateFrame("ScriptDialogButton", HotkeyMenu, 0, 0)
BlzFrameSetPoint(HotkeyYourDigimons, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.040000)
BlzFrameSetPoint(HotkeyYourDigimons, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.30000, 0.26000)
BlzFrameSetText(HotkeyYourDigimons, "|cffFCD20DYour digimons|r")
BlzFrameSetScale(HotkeyYourDigimons, 1.29)
TriggerHotkeyYourDigimons = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeyYourDigimons, HotkeyYourDigimons, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeyYourDigimons, REFORGEDUIMAKER.HotkeyYourDigimonsFunc) 

HotkeyYourDigimonsSubMenu = BlzCreateFrameByType("BACKDROP", "BACKDROP", HotkeyMenu, "", 1)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenu, FRAMEPOINT_TOPLEFT, HotkeyMenu, FRAMEPOINT_TOPLEFT, 0.23000, -0.030000)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenu, FRAMEPOINT_BOTTOMRIGHT, HotkeyMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.050000)
BlzFrameSetTexture(HotkeyYourDigimonsSubMenu, "CustomFrame.png", 0, true)

HotkeyBackpackSubMenuBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", HotkeyBackpackSubMenu, 0, 0)
BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, 0.11000, -0.020000)
BlzFrameSetPoint(HotkeyBackpackSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.050000)

HotkeyBackpackSubMenuButton = BlzCreateFrame("IconButtonTemplate", HotkeyBackpackSubMenu, 0, 0)
BlzFrameSetPoint(HotkeyBackpackSubMenuButton, FRAMEPOINT_TOPLEFT, HotkeyBackpackSubMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.10000)
BlzFrameSetPoint(HotkeyBackpackSubMenuButton, FRAMEPOINT_BOTTOMRIGHT, HotkeyBackpackSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.19000, 0.11000)

BackdropHotkeyBackpackSubMenuButton = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyBackpackSubMenuButton", HotkeyBackpackSubMenuButton, "", 0)
BlzFrameSetAllPoints(BackdropHotkeyBackpackSubMenuButton, HotkeyBackpackSubMenuButton)
BlzFrameSetTexture(BackdropHotkeyBackpackSubMenuButton, "CustomFrame.png", 0, true)
TriggerHotkeyBackpackSubMenuButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeyBackpackSubMenuButton, HotkeyBackpackSubMenuButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeyBackpackSubMenuButton, REFORGEDUIMAKER.HotkeyBackpackSubMenuButtonFunc) 

HotkeyYourDigimonsSubMenuBackdrop = BlzCreateFrame("EscMenuBackdrop", HotkeyYourDigimonsSubMenu, 0, 0)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenu, FRAMEPOINT_TOPLEFT, 0.020000, 0.0000)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenuBackdrop, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, -0.010000)

HotkeyYourDigimonsSubMenuButton = BlzCreateFrame("IconButtonTemplate", HotkeyYourDigimonsSubMenu, 0, 0)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenuButton, FRAMEPOINT_TOPLEFT, HotkeyYourDigimonsSubMenu, FRAMEPOINT_TOPLEFT, 0.0050000, -0.10000)
BlzFrameSetPoint(HotkeyYourDigimonsSubMenuButton, FRAMEPOINT_BOTTOMRIGHT, HotkeyYourDigimonsSubMenu, FRAMEPOINT_BOTTOMRIGHT, -0.20500, 0.11000)

BackdropHotkeyYourDigimonsSubMenuButton = BlzCreateFrameByType("BACKDROP", "BackdropHotkeyYourDigimonsSubMenuButton", HotkeyYourDigimonsSubMenuButton, "", 0)
BlzFrameSetAllPoints(BackdropHotkeyYourDigimonsSubMenuButton, HotkeyYourDigimonsSubMenuButton)
BlzFrameSetTexture(BackdropHotkeyYourDigimonsSubMenuButton, "CustomFrame.png", 0, true)
TriggerHotkeyYourDigimonsSubMenuButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerHotkeyYourDigimonsSubMenuButton, HotkeyYourDigimonsSubMenuButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerHotkeyYourDigimonsSubMenuButton, REFORGEDUIMAKER.HotkeyYourDigimonsSubMenuButtonFunc) 
end
