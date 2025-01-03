DigimonsBackdrop = nil 
TriggerDigimonsBackdrop = nil 
Exit = nil 
TriggerExit = nil 
DigimonsButton = nil 
TriggerDigimonsButton = nil 
ItemsButton = nil 
TriggerItemsButton = nil 
MapButton = nil 
TriggerMapButton = nil 
RookiesText = nil 
TriggerRookiesText = nil 
RookiesContainer = nil 
TriggerRookiesContainer = nil 
ChampionsText = nil 
TriggerChampionsText = nil 
ChampionsContainer = nil 
TriggerChampionsContainer = nil 
UltimatesText = nil 
TriggerUltimatesText = nil 
UltimatesContainer = nil 
TriggerUltimatesContainer = nil 
MegasText = nil 
TriggerMegasText = nil 
MegasContainer = nil 
TriggerMegasContainer = nil 
DigimonInformation = nil 
TriggerDigimonInformation = nil 
DigimonType = nil 
BackdropDigimonType = nil 
TriggerDigimonType = nil 
DigimonName = nil 
TriggerDigimonName = nil 
DigimonStamina = nil 
TriggerDigimonStamina = nil 
DigimonDexterity = nil 
TriggerDigimonDexterity = nil 
DigimonWisdom = nil 
TriggerDigimonWisdom = nil 
DigimonEvolvesToLabel = nil 
TriggerDigimonEvolvesToLabel = nil 
DigimonEvolveOptions = nil 
TriggerDigimonEvolveOptions = nil 
DigimonAbilityT = {} 
BackdropDigimonAbilityT = {} 
TriggerDigimonAbilityT = {} 
DigimonDescription = nil 
TriggerDigimonDescription = nil 
DigimonAttackTypeIcon = nil 
TriggerDigimonAttackTypeIcon = nil 
DigimonDefenseTypeIcon = nil 
TriggerDigimonDefenseTypeIcon = nil 
DigimonEvolvesToOptionT = {} 
TriggerDigimonEvolvesToOptionT = {} 
DigimonAttackTypeLabel = nil 
TriggerDigimonAttackTypeLabel = nil 
DigimonDefenseTypeLabel = nil 
TriggerDigimonDefenseTypeLabel = nil 
DigimonEvolveRequirements = nil 
TriggerDigimonEvolveRequirements = nil 
DigimonEvolveRequirementsText = nil 
TriggerDigimonEvolveRequirementsText = nil 
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
 
REFORGEDUIMAKER.DigimonTypeFunc = function() 
BlzFrameSetEnable(DigimonType, false) 
BlzFrameSetEnable(DigimonType, true) 
end 
 
REFORGEDUIMAKER.DigimonAbilityT00Func = function() 
BlzFrameSetEnable(DigimonAbilityT[0], false) 
BlzFrameSetEnable(DigimonAbilityT[0], true) 
end 
 
REFORGEDUIMAKER.DigimonAbilityT01Func = function() 
BlzFrameSetEnable(DigimonAbilityT[1], false) 
BlzFrameSetEnable(DigimonAbilityT[1], true) 
end 
 
REFORGEDUIMAKER.DigimonAbilityT02Func = function() 
BlzFrameSetEnable(DigimonAbilityT[2], false) 
BlzFrameSetEnable(DigimonAbilityT[2], true) 
end 
 
REFORGEDUIMAKER.DigimonAbilityT03Func = function() 
BlzFrameSetEnable(DigimonAbilityT[3], false) 
BlzFrameSetEnable(DigimonAbilityT[3], true) 
end 
 
REFORGEDUIMAKER.Initialize = function()


DigimonsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
BlzFrameSetAbsPoint(DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.600000)
BlzFrameSetAbsPoint(DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.00000)
BlzFrameSetTexture(DigimonsBackdrop, "CustomFrame.png", 0, true)

Exit = BlzCreateFrame("ScriptDialogButton", DigimonsBackdrop, 0, 0)
BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.71000, -0.030000)
BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.54000)
BlzFrameSetText(Exit, "|cffFCD20DExit|r")
BlzFrameSetScale(Exit, 1.00)
TriggerExit = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerExit, REFORGEDUIMAKER.ExitFunc) 

DigimonsButton = BlzCreateFrame("ScriptDialogButton", DigimonsBackdrop, 0, 0)
BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.71000, 0.54000)
BlzFrameSetText(DigimonsButton, "|cffFCD20DDigimons|r")
BlzFrameSetScale(DigimonsButton, 1.00)
TriggerDigimonsButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonsButton, DigimonsButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonsButton, REFORGEDUIMAKER.DigimonsButtonFunc) 

ItemsButton = BlzCreateFrame("ScriptDialogButton", DigimonsBackdrop, 0, 0)
BlzFrameSetPoint(ItemsButton, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.10000, -0.030000)
BlzFrameSetPoint(ItemsButton, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63000, 0.54000)
BlzFrameSetText(ItemsButton, "|cffFCD20DItems|r")
BlzFrameSetScale(ItemsButton, 1.00)
TriggerItemsButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerItemsButton, ItemsButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerItemsButton, REFORGEDUIMAKER.ItemsButtonFunc) 

MapButton = BlzCreateFrame("ScriptDialogButton", DigimonsBackdrop, 0, 0)
BlzFrameSetPoint(MapButton, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.18000, -0.030000)
BlzFrameSetPoint(MapButton, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.55000, 0.54000)
BlzFrameSetText(MapButton, "|cffFCD20DMap|r")
BlzFrameSetScale(MapButton, 1.00)
TriggerMapButton = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerMapButton, MapButton, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerMapButton, REFORGEDUIMAKER.MapButtonFunc) 

RookiesText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
BlzFrameSetPoint(RookiesText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.080000)
BlzFrameSetPoint(RookiesText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.50000)
BlzFrameSetText(RookiesText, "|cffFFCC00Rookies|r")
BlzFrameSetEnable(RookiesText, false)
BlzFrameSetScale(RookiesText, 2.00)
BlzFrameSetTextAlignment(RookiesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

RookiesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.11000)
BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.41000)
BlzFrameSetTexture(RookiesContainer, "CustomFrame.png", 0, true)

ChampionsText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
BlzFrameSetPoint(ChampionsText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.20000)
BlzFrameSetPoint(ChampionsText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.38000)
BlzFrameSetText(ChampionsText, "|cffFFCC00Champions|r")
BlzFrameSetEnable(ChampionsText, false)
BlzFrameSetScale(ChampionsText, 2.00)
BlzFrameSetTextAlignment(ChampionsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

ChampionsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.23000)
BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.29000)
BlzFrameSetTexture(ChampionsContainer, "CustomFrame.png", 0, true)

UltimatesText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
BlzFrameSetPoint(UltimatesText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.32000)
BlzFrameSetPoint(UltimatesText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.26000)
BlzFrameSetText(UltimatesText, "|cffFFCC00Ultimates|r")
BlzFrameSetEnable(UltimatesText, false)
BlzFrameSetScale(UltimatesText, 2.00)
BlzFrameSetTextAlignment(UltimatesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

UltimatesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.35000)
BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.17000)
BlzFrameSetTexture(UltimatesContainer, "CustomFrame.png", 0, true)

MegasText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
BlzFrameSetPoint(MegasText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.44000)
BlzFrameSetPoint(MegasText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.14000)
BlzFrameSetText(MegasText, "|cffFFCC00Megas|r")
BlzFrameSetEnable(MegasText, false)
BlzFrameSetScale(MegasText, 2.00)
BlzFrameSetTextAlignment(MegasText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

MegasContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
BlzFrameSetPoint(MegasContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.47000)
BlzFrameSetPoint(MegasContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.050000)
BlzFrameSetTexture(MegasContainer, "CustomFrame.png", 0, true)

DigimonInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.61000, -0.070000)
BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
BlzFrameSetTexture(DigimonInformation, "CustomFrame.png", 0, true)

DigimonType = BlzCreateFrame("IconButtonTemplate", RookiesContainer, 0, 0)
BlzFrameSetAbsPoint(DigimonType, FRAMEPOINT_TOPLEFT, 0.0100000, 0.490000)
BlzFrameSetAbsPoint(DigimonType, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.450000)

BackdropDigimonType = BlzCreateFrameByType("BACKDROP", "BackdropDigimonType", DigimonType, "", 0)
BlzFrameSetAllPoints(BackdropDigimonType, DigimonType)
BlzFrameSetTexture(BackdropDigimonType, "CustomFrame.png", 0, true)
TriggerDigimonType = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonType, DigimonType, FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonType, REFORGEDUIMAKER.DigimonTypeFunc) 

DigimonName = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonName, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
BlzFrameSetPoint(DigimonName, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
BlzFrameSetText(DigimonName, "|cffFFCC00Agumon|r")
BlzFrameSetEnable(DigimonName, false)
BlzFrameSetScale(DigimonName, 1.57)
BlzFrameSetTextAlignment(DigimonName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonStamina = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.35000)
BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.15000)
BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r")
BlzFrameSetEnable(DigimonStamina, false)
BlzFrameSetScale(DigimonStamina, 1.43)
BlzFrameSetTextAlignment(DigimonStamina, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonDexterity = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.37000)
BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.13000)
BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r")
BlzFrameSetEnable(DigimonDexterity, false)
BlzFrameSetScale(DigimonDexterity, 1.43)
BlzFrameSetTextAlignment(DigimonDexterity, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonWisdom = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.11000)
BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: \n|r")
BlzFrameSetEnable(DigimonWisdom, false)
BlzFrameSetScale(DigimonWisdom, 1.43)
BlzFrameSetTextAlignment(DigimonWisdom, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.42000)
BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.080000)
BlzFrameSetText(DigimonEvolvesToLabel, "|cffffcc00Evolves to:|r")
BlzFrameSetEnable(DigimonEvolvesToLabel, false)
BlzFrameSetScale(DigimonEvolvesToLabel, 1.57)
BlzFrameSetTextAlignment(DigimonEvolvesToLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolveOptions = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.44000)
BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
BlzFrameSetTexture(DigimonEvolveOptions, "CustomFrame.png", 0, true)

DigimonAbilityT[0] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
BlzFrameSetPoint(DigimonAbilityT[0], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.30000)
BlzFrameSetPoint(DigimonAbilityT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.18000)

BackdropDigimonAbilityT[0] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonAbilityT[0]", DigimonAbilityT[0], "", 0)
BlzFrameSetAllPoints(BackdropDigimonAbilityT[0], DigimonAbilityT[0])
BlzFrameSetTexture(BackdropDigimonAbilityT[0], "CustomFrame.png", 0, true)
TriggerDigimonAbilityT[0] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonAbilityT[0], DigimonAbilityT[0], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonAbilityT[0], REFORGEDUIMAKER.DigimonAbilityT00Func) 

DigimonAbilityT[1] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
BlzFrameSetPoint(DigimonAbilityT[1], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.050000, -0.30000)
BlzFrameSetPoint(DigimonAbilityT[1], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.090000, 0.18000)

BackdropDigimonAbilityT[1] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonAbilityT[1]", DigimonAbilityT[1], "", 0)
BlzFrameSetAllPoints(BackdropDigimonAbilityT[1], DigimonAbilityT[1])
BlzFrameSetTexture(BackdropDigimonAbilityT[1], "CustomFrame.png", 0, true)
TriggerDigimonAbilityT[1] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonAbilityT[1], DigimonAbilityT[1], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonAbilityT[1], REFORGEDUIMAKER.DigimonAbilityT01Func) 

DigimonAbilityT[2] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
BlzFrameSetPoint(DigimonAbilityT[2], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.090000, -0.30000)
BlzFrameSetPoint(DigimonAbilityT[2], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.050000, 0.18000)

BackdropDigimonAbilityT[2] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonAbilityT[2]", DigimonAbilityT[2], "", 0)
BlzFrameSetAllPoints(BackdropDigimonAbilityT[2], DigimonAbilityT[2])
BlzFrameSetTexture(BackdropDigimonAbilityT[2], "CustomFrame.png", 0, true)
TriggerDigimonAbilityT[2] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonAbilityT[2], DigimonAbilityT[2], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonAbilityT[2], REFORGEDUIMAKER.DigimonAbilityT02Func) 

DigimonAbilityT[3] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
BlzFrameSetPoint(DigimonAbilityT[3], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.13000, -0.30000)
BlzFrameSetPoint(DigimonAbilityT[3], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.18000)

BackdropDigimonAbilityT[3] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonAbilityT[3]", DigimonAbilityT[3], "", 0)
BlzFrameSetAllPoints(BackdropDigimonAbilityT[3], DigimonAbilityT[3])
BlzFrameSetTexture(BackdropDigimonAbilityT[3], "CustomFrame.png", 0, true)
TriggerDigimonAbilityT[3] = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerDigimonAbilityT[3], DigimonAbilityT[3], FRAMEEVENT_CONTROL_CLICK) 
TriggerAddAction(TriggerDigimonAbilityT[3], REFORGEDUIMAKER.DigimonAbilityT03Func) 

DigimonDescription = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
BlzFrameSetPoint(DigimonDescription, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.22000)
BlzFrameSetPoint(DigimonDescription, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.23000)
BlzFrameSetText(DigimonDescription, "|cffffffffDescription|r")
BlzFrameSetEnable(DigimonDescription, false)
BlzFrameSetScale(DigimonDescription, 1.21)
BlzFrameSetTextAlignment(DigimonDescription, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonAttackTypeIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
BlzFrameSetPoint(DigimonAttackTypeIcon, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.11000, -0.030000)
BlzFrameSetPoint(DigimonAttackTypeIcon, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.46000)
BlzFrameSetTexture(DigimonAttackTypeIcon, "CustomFrame.png", 0, true)

DigimonDefenseTypeIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
BlzFrameSetPoint(DigimonDefenseTypeIcon, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.14000, -0.030000)
BlzFrameSetPoint(DigimonDefenseTypeIcon, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.46000)
BlzFrameSetTexture(DigimonDefenseTypeIcon, "CustomFrame.png", 0, true)

DigimonEvolvesToOptionT[0] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[0], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -1.3878e-17)
BlzFrameSetPoint(DigimonEvolvesToOptionT[0], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.060000)
BlzFrameSetText(DigimonEvolvesToOptionT[0], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[0], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[0], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[0], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[1] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[1], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[1], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.050000)
BlzFrameSetText(DigimonEvolvesToOptionT[1], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[1], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[1], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[1], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[2] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[2], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.020000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[2], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.040000)
BlzFrameSetText(DigimonEvolvesToOptionT[2], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[2], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[2], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[2], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[3] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[3], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.030000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[3], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.030000)
BlzFrameSetText(DigimonEvolvesToOptionT[3], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[3], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[3], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[3], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[4] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[4], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.040000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[4], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.020000)
BlzFrameSetText(DigimonEvolvesToOptionT[4], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[4], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[4], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[4], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[5] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[5], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.050000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[5], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.010000)
BlzFrameSetText(DigimonEvolvesToOptionT[5], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[5], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[5], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[5], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonEvolvesToOptionT[6] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonEvolvesToOptionT[6], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.060000)
BlzFrameSetPoint(DigimonEvolvesToOptionT[6], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 3.4694e-18)
BlzFrameSetText(DigimonEvolvesToOptionT[6], "|cffffffff- Greymon|r")
BlzFrameSetEnable(DigimonEvolvesToOptionT[6], false)
BlzFrameSetScale(DigimonEvolvesToOptionT[6], 1.00)
BlzFrameSetTextAlignment(DigimonEvolvesToOptionT[6], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

DigimonAttackTypeLabel = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonAttackTypeLabel, FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.10000, 0.38000)
BlzFrameSetPoint(DigimonAttackTypeLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.44000)
BlzFrameSetText(DigimonAttackTypeLabel, "|cffffcc00Att|r")
BlzFrameSetEnable(DigimonAttackTypeLabel, false)
BlzFrameSetScale(DigimonAttackTypeLabel, 1.00)
BlzFrameSetTextAlignment(DigimonAttackTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

DigimonDefenseTypeLabel = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.13000, 0.38000)
BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.44000)
BlzFrameSetText(DigimonDefenseTypeLabel, "|cffffcc00Def|r")
BlzFrameSetEnable(DigimonDefenseTypeLabel, false)
BlzFrameSetScale(DigimonDefenseTypeLabel, 1.00)
BlzFrameSetTextAlignment(DigimonDefenseTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

DigimonEvolveRequirements = BlzCreateFrame("QuestButtonBaseTemplate", DigimonEvolvesToOptionT[0], 0, 0)
BlzFrameSetPoint(DigimonEvolveRequirements, FRAMEPOINT_TOPLEFT, DigimonEvolvesToOptionT[0], FRAMEPOINT_TOPLEFT, 0.037960, 0.092540)
BlzFrameSetPoint(DigimonEvolveRequirements, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolvesToOptionT[0], FRAMEPOINT_BOTTOMRIGHT, -0.012040, 0.0010500)

TooltipDigimonEvolveRequirements = BlzCreateFrameByType("FRAME", "", DigimonEvolvesToOptionT[0], "", 0)
BlzFrameSetAllPoints(TooltipDigimonEvolveRequirements, DigimonEvolvesToOptionT[0])
BlzFrameSetTooltip(TooltipDigimonEvolveRequirements, DigimonEvolveRequirements)

DigimonEvolveRequirementsText = BlzCreateFrameByType("TEXT", "name", DigimonEvolveRequirements, "", 0)
BlzFrameSetPoint(DigimonEvolveRequirementsText, FRAMEPOINT_TOPLEFT, DigimonEvolveRequirements, FRAMEPOINT_TOPLEFT, 0.0055800, -0.0066700)
BlzFrameSetPoint(DigimonEvolveRequirementsText, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveRequirements, FRAMEPOINT_BOTTOMRIGHT, -0.0044200, 0.0048200)
BlzFrameSetText(DigimonEvolveRequirementsText, "|cffFFCC00Requires:\n- Level 20\n- Common Digivice\n- Stay on Acient Dino Region|r")
BlzFrameSetEnable(DigimonEvolveRequirementsText, false)
BlzFrameSetScale(DigimonEvolveRequirementsText, 1.00)
BlzFrameSetTextAlignment(DigimonEvolveRequirementsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
end
