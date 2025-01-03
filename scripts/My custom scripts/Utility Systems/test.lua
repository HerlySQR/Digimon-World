ItemsBackdrop = nil 
TriggerItemsBackdrop = nil 
Exit = nil 
TriggerExit = nil 
DigimonsButton = nil 
TriggerDigimonsButton = nil 
ItemsButton = nil 
TriggerItemsButton = nil 
MapButton = nil 
TriggerMapButton = nil 
ConsumablesText = nil 
TriggerConsumablesText = nil 
ItemInformation = nil 
TriggerItemInformation = nil 
ConsumablesContainer = nil 
TriggerConsumablesContainer = nil 
EquipmentsText = nil 
TriggerEquipmentsText = nil 
ShieldsText = nil 
TriggerShieldsText = nil 
ShieldsContainer = nil 
TriggerShieldsContainer = nil 
WeaponsContainer = nil 
TriggerWeaponsContainer = nil 
AccesoriesContainer = nil 
TriggerAccesoriesContainer = nil 
DigivicesContainer = nil 
TriggerDigivicesContainer = nil 
CrestsContainer = nil 
TriggerCrestsContainer = nil 
WeaponsText = nil 
TriggerWeaponsText = nil 
AccesoriesText = nil 
TriggerAccesoriesText = nil 
DigivicesText = nil 
TriggerDigivicesText = nil 
CrestsText = nil 
TriggerCrestsText = nil 
ItemName = nil 
TriggerItemName = nil 
ItemDescription = nil 
TriggerItemDescription = nil 
ItemType = nil 
BackdropItemType = nil 
TriggerItemType = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.ExitFunc = function() 
BlzFrameSetEnable(Exit, false) 
BlzFrameSetEnable(Exit, true) 
end 
 
REFORGEDUIMAKER.DigimonsButtonFunc = function() 
BlzFrameSetEnable(DigimonsButton, false) 
BlzFrameSetEnable(DigimonsButton, true) 
end 
 
REFORGEDUIMAKER.ItemsButtonFunc = function() 
BlzFrameSetEnable(ItemsButton, false) 
BlzFrameSetEnable(ItemsButton, true) 
end 
 
REFORGEDUIMAKER.MapButtonFunc = function() 
BlzFrameSetEnable(MapButton, false) 
BlzFrameSetEnable(MapButton, true) 
end 
 
REFORGEDUIMAKER.ItemTypeFunc = function() 
BlzFrameSetEnable(ItemType, false) 
BlzFrameSetEnable(ItemType, true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


ItemsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
BlzFrameSetAbsPoint(ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.600000)
BlzFrameSetAbsPoint(ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.00000)
BlzFrameSetTexture(ItemsBackdrop, "CustomFrame.png", 0, true)

Exit = BlzCreateFrame("ScriptDialogButton", ItemsBackdrop, 0, 0)
BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.71000, -0.030000)
BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.54000)
BlzFrameSetText(Exit, "|cffFCD20DExit|r")
BlzFrameSetScale(Exit, 1.00)
TriggerExit = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerExit, REFORGEDUIMAKER.ExitFunc) 

DigimonsButton = BlzCreateFrame("ScriptDialogButton", ItemsBackdrop, 0, 0)
BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.71000, 0.54000)
BlzFrameSetText(DigimonsButton, "|cffFCD20DDigimons|r")
BlzFrameSetScale(DigimonsButton, 1.00)
TriggerDigimonsButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonsButton, DigimonsButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonsButton, REFORGEDUIMAKER.DigimonsButtonFunc) 

ItemsButton = BlzCreateFrame("ScriptDialogButton", ItemsBackdrop, 0, 0)
BlzFrameSetPoint(ItemsButton, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.10000, -0.030000)
BlzFrameSetPoint(ItemsButton, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63000, 0.54000)
BlzFrameSetText(ItemsButton, "|cffFCD20DItems|r")
BlzFrameSetScale(ItemsButton, 1.00)
TriggerItemsButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerItemsButton, ItemsButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerItemsButton, REFORGEDUIMAKER.ItemsButtonFunc) 

MapButton = BlzCreateFrame("ScriptDialogButton", ItemsBackdrop, 0, 0)
BlzFrameSetPoint(MapButton, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.18000, -0.030000)
BlzFrameSetPoint(MapButton, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.55000, 0.54000)
BlzFrameSetText(MapButton, "|cffFCD20DMap|r")
BlzFrameSetScale(MapButton, 1.00)
TriggerMapButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMapButton, MapButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMapButton, REFORGEDUIMAKER.MapButtonFunc) 

ConsumablesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.51000)
BlzFrameSetText(ConsumablesText, "|cffFFCC00Consumables|r")
BlzFrameSetEnable(ConsumablesText, false)
BlzFrameSetScale(ConsumablesText, 2.00)
BlzFrameSetTextAlignment(ConsumablesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ItemInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(ItemInformation, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.61000, -0.11000)
BlzFrameSetPoint(ItemInformation, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.17000)
BlzFrameSetTexture(ItemInformation, "CustomFrame.png", 0, true)

ConsumablesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(ConsumablesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
BlzFrameSetPoint(ConsumablesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.42000)
BlzFrameSetTexture(ConsumablesContainer, "CustomFrame.png", 0, true)

EquipmentsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.19000)
BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.39000)
BlzFrameSetText(EquipmentsText, "|cffFFCC00Equipments|r")
BlzFrameSetEnable(EquipmentsText, false)
BlzFrameSetScale(EquipmentsText, 2.00)
BlzFrameSetTextAlignment(EquipmentsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ShieldsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(ShieldsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.22000)
BlzFrameSetPoint(ShieldsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.36000)
BlzFrameSetText(ShieldsText, "|cff00ffffShields|r")
BlzFrameSetEnable(ShieldsText, false)
BlzFrameSetScale(ShieldsText, 1.86)
BlzFrameSetTextAlignment(ShieldsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ShieldsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.24000)
BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.32000)
BlzFrameSetTexture(ShieldsContainer, "CustomFrame.png", 0, true)

WeaponsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.31500)
BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.24500)
BlzFrameSetTexture(WeaponsContainer, "CustomFrame.png", 0, true)

AccesoriesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.17000)
BlzFrameSetTexture(AccesoriesContainer, "CustomFrame.png", 0, true)

DigivicesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.46500)
BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.095000)
BlzFrameSetTexture(DigivicesContainer, "CustomFrame.png", 0, true)

CrestsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.54000)
BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.020000)
BlzFrameSetTexture(CrestsContainer, "CustomFrame.png", 0, true)

WeaponsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(WeaponsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.29550)
BlzFrameSetPoint(WeaponsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.28450)
BlzFrameSetText(WeaponsText, "|cff00ffffWeapons|r")
BlzFrameSetEnable(WeaponsText, false)
BlzFrameSetScale(WeaponsText, 1.86)
BlzFrameSetTextAlignment(WeaponsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

AccesoriesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.37100)
BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.20900)
BlzFrameSetText(AccesoriesText, "|cff00ffffAccesories|r")
BlzFrameSetEnable(AccesoriesText, false)
BlzFrameSetScale(AccesoriesText, 1.86)
BlzFrameSetTextAlignment(AccesoriesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigivicesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(DigivicesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.44650)
BlzFrameSetPoint(DigivicesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.13350)
BlzFrameSetText(DigivicesText, "|cff00ffffDigivices|r")
BlzFrameSetEnable(DigivicesText, false)
BlzFrameSetScale(DigivicesText, 1.86)
BlzFrameSetTextAlignment(DigivicesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

CrestsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(CrestsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.52200)
BlzFrameSetPoint(CrestsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.058000)
BlzFrameSetText(CrestsText, "|cff00ffffCrests|r")
BlzFrameSetEnable(CrestsText, false)
BlzFrameSetScale(CrestsText, 1.86)
BlzFrameSetTextAlignment(CrestsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ItemName = BlzCreateFrameByType("TEXT", "name", ItemInformation, "", 0)
BlzFrameSetPoint(ItemName, FRAMEPOINT_TOPLEFT, ItemInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
BlzFrameSetPoint(ItemName, FRAMEPOINT_BOTTOMRIGHT, ItemInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.29000)
BlzFrameSetText(ItemName, "|cffFFCC00Agumon|r")
BlzFrameSetEnable(ItemName, false)
BlzFrameSetScale(ItemName, 1.71)
BlzFrameSetTextAlignment(ItemName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ItemDescription = BlzCreateFrameByType("TEXT", "name", ItemInformation, "", 0)
BlzFrameSetPoint(ItemDescription, FRAMEPOINT_TOPLEFT, ItemInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.22000)
BlzFrameSetPoint(ItemDescription, FRAMEPOINT_BOTTOMRIGHT, ItemInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
BlzFrameSetText(ItemDescription, "|cffffffffStamina per level: |r")
BlzFrameSetEnable(ItemDescription, false)
BlzFrameSetScale(ItemDescription, 1.43)
BlzFrameSetTextAlignment(ItemDescription, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ItemType = BlzCreateFrame("IconButtonTemplate", ConsumablesContainer, 0, 0)
BlzFrameSetAbsPoint(ItemType, FRAMEPOINT_TOPLEFT, 0.0100000, 0.500000)
BlzFrameSetAbsPoint(ItemType, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.460000)

BackdropItemType = BlzCreateFrameByType("BACKDROP", "BackdropItemType", ItemType, "", 0)
BlzFrameSetAllPoints(BackdropItemType, ItemType)
BlzFrameSetTexture(BackdropItemType, "CustomFrame.png", 0, true)
TriggerItemType = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerItemType, ItemType, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerItemType, REFORGEDUIMAKER.ItemTypeFunc) 
end
