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
MiscsContainer = nil 
TriggerMiscsContainer = nil 
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
MiscText = nil 
TriggerMiscText = nil 
FoodsContainer = nil 
TriggerFoodsContainer = nil 
DrinksContainer = nil 
TriggerDrinksContainer = nil 
FoodText = nil 
TriggerFoodText = nil 
DrinkText = nil 
TriggerDrinkText = nil 
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

MiscsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(MiscsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.12000)
BlzFrameSetPoint(MiscsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63000, 0.40000)
BlzFrameSetTexture(MiscsContainer, "CustomFrame.png", 0, true)

EquipmentsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.21500)
BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.36500)
BlzFrameSetText(EquipmentsText, "|cffFFCC00Equipments|r")
BlzFrameSetEnable(EquipmentsText, false)
BlzFrameSetScale(EquipmentsText, 2.00)
BlzFrameSetTextAlignment(EquipmentsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ShieldsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(ShieldsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.24500)
BlzFrameSetPoint(ShieldsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.34000)
BlzFrameSetText(ShieldsText, "|cff00ffffShields|r")
BlzFrameSetEnable(ShieldsText, false)
BlzFrameSetScale(ShieldsText, 1.43)
BlzFrameSetTextAlignment(ShieldsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ShieldsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.26000)
BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.30000)
BlzFrameSetTexture(ShieldsContainer, "CustomFrame.png", 0, true)

WeaponsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.33000)
BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.23000)
BlzFrameSetTexture(WeaponsContainer, "CustomFrame.png", 0, true)

AccesoriesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.40000)
BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.16000)
BlzFrameSetTexture(AccesoriesContainer, "CustomFrame.png", 0, true)

DigivicesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.47000)
BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.090000)
BlzFrameSetTexture(DigivicesContainer, "CustomFrame.png", 0, true)

CrestsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.54000)
BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.020000)
BlzFrameSetTexture(CrestsContainer, "CustomFrame.png", 0, true)

WeaponsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(WeaponsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.31550)
BlzFrameSetPoint(WeaponsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.26950)
BlzFrameSetText(WeaponsText, "|cff00ffffWeapons|r")
BlzFrameSetEnable(WeaponsText, false)
BlzFrameSetScale(WeaponsText, 1.43)
BlzFrameSetTextAlignment(WeaponsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

AccesoriesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.38600)
BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.19900)
BlzFrameSetText(AccesoriesText, "|cff00ffffAccesories|r")
BlzFrameSetEnable(AccesoriesText, false)
BlzFrameSetScale(AccesoriesText, 1.43)
BlzFrameSetTextAlignment(AccesoriesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigivicesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(DigivicesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.45650)
BlzFrameSetPoint(DigivicesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.12850)
BlzFrameSetText(DigivicesText, "|cff00ffffDigivices|r")
BlzFrameSetEnable(DigivicesText, false)
BlzFrameSetScale(DigivicesText, 1.43)
BlzFrameSetTextAlignment(DigivicesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

CrestsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(CrestsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.52700)
BlzFrameSetPoint(CrestsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.058000)
BlzFrameSetText(CrestsText, "|cff00ffffCrests|r")
BlzFrameSetEnable(CrestsText, false)
BlzFrameSetScale(CrestsText, 1.43)
BlzFrameSetTextAlignment(CrestsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

MiscText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(MiscText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
BlzFrameSetPoint(MiscText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.48500)
BlzFrameSetText(MiscText, "|cff00ffffMiscellaneous|r")
BlzFrameSetEnable(MiscText, false)
BlzFrameSetScale(MiscText, 1.43)
BlzFrameSetTextAlignment(MiscText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

FoodsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(FoodsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.12000)
BlzFrameSetPoint(FoodsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.44000, 0.40000)
BlzFrameSetTexture(FoodsContainer, "CustomFrame.png", 0, true)

DrinksContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
BlzFrameSetPoint(DrinksContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.39000, -0.12000)
BlzFrameSetPoint(DrinksContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.25000, 0.40000)
BlzFrameSetTexture(DrinksContainer, "CustomFrame.png", 0, true)

FoodText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(FoodText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.10000)
BlzFrameSetPoint(FoodText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.46000, 0.48500)
BlzFrameSetText(FoodText, "|cff00ffffFoods|r")
BlzFrameSetEnable(FoodText, false)
BlzFrameSetScale(FoodText, 1.43)
BlzFrameSetTextAlignment(FoodText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DrinkText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
BlzFrameSetPoint(DrinkText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.39000, -0.10000)
BlzFrameSetPoint(DrinkText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.27000, 0.48500)
BlzFrameSetText(DrinkText, "|cff00ffffDrinks|r")
BlzFrameSetEnable(DrinkText, false)
BlzFrameSetScale(DrinkText, 1.43)
BlzFrameSetTextAlignment(DrinkText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

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

ItemType = BlzCreateFrame("IconButtonTemplate", MiscsContainer, 0, 0)
BlzFrameSetAbsPoint(ItemType, FRAMEPOINT_TOPLEFT, 0.0100000, 0.480000)
BlzFrameSetAbsPoint(ItemType, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.440000)

BackdropItemType = BlzCreateFrameByType("BACKDROP", "BackdropItemType", ItemType, "", 0)
BlzFrameSetAllPoints(BackdropItemType, ItemType)
BlzFrameSetTexture(BackdropItemType, "CustomFrame.png", 0, true)
TriggerItemType = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerItemType, ItemType, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerItemType, REFORGEDUIMAKER.ItemTypeFunc) 
end
