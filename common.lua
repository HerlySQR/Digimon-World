---@meta

---@class handle: userdata

--============================================================================
-- Native types. All native functions take extended handle types when
-- possible to help prevent passing bad values to native functions
--
---@class agent:                    handle  -- all reference counted objects
---@class event:                    agent  -- a reference to an event registration
---@class player:                   agent  -- a single player reference
---@class widget:                   agent  -- an interactive game object with life
---@class unit:                     widget  -- a single unit reference
---@class destructable:             widget
---@class item:                     widget
---@class ability:                  agent
---@class buff:                     ability
---@class force:                    agent
---@class group:                    agent
---@class trigger:                  agent
---@class triggercondition:         agent
---@class triggeraction:            handle
---@class timer:                    agent
---@class location:                 agent
---@class region:                   agent
---@class rect:                     agent
---@class boolexpr:                 agent
---@class sound:                    agent
---@class conditionfunc:            boolexpr
---@class filterfunc:               boolexpr
---@class unitpool:                 handle
---@class itempool:                 handle
---@class race:                     handle
---@class alliancetype:             handle
---@class racepreference:           handle
---@class gamestate:                handle
---@class igamestate:               gamestate
---@class fgamestate:               gamestate
---@class playerstate:              handle
---@class playerscore:              handle
---@class playergameresult:         handle
---@class unitstate:                handle
---@class aidifficulty:             handle

---@class eventid:                  handle
---@class gameevent:                eventid
---@class playerevent:              eventid
---@class playerunitevent:          eventid
---@class unitevent:                eventid
---@class limitop:                  eventid
---@class widgetevent:              eventid
---@class dialogevent:              eventid
---@class unittype:                 handle

---@class gamespeed:                handle
---@class gamedifficulty:           handle
---@class gametype:                 handle
---@class mapflag:                  handle
---@class mapvisibility:            handle
---@class mapsetting:               handle
---@class mapdensity:               handle
---@class mapcontrol:               handle
---@class minimapicon:              handle
---@class playerslotstate:          handle
---@class volumegroup:              handle
---@class camerafield:              handle
---@class camerasetup:              handle
---@class playercolor:              handle
---@class placement:                handle
---@class startlocprio:             handle
---@class raritycontrol:            handle
---@class blendmode:                handle
---@class texmapflags:              handle
---@class effect:                   agent
---@class effecttype:               handle
---@class weathereffect:            handle
---@class terraindeformation:       handle
---@class fogstate:                 handle
---@class fogmodifier:              agent
---@class dialog:                   agent
---@class button:                   agent
---@class quest:                    agent
---@class questitem:                agent
---@class defeatcondition:          agent
---@class timerdialog:              agent
---@class leaderboard:              agent
---@class multiboard:               agent
---@class multiboarditem:           agent
---@class trackable:                agent
---@class gamecache:                agent
---@class version:                  handle
---@class itemtype:                 handle
---@class texttag:                  handle
---@class attacktype:               handle
---@class damagetype:               handle
---@class weapontype:               handle
---@class soundtype:                handle
---@class lightning:                handle
---@class pathingtype:              handle
---@class mousebuttontype:          handle
---@class animtype:                 handle
---@class subanimtype:              handle
---@class image:                    handle
---@class ubersplat:                handle
---@class hashtable:                agent
---@class framehandle:              handle
---@class originframetype:          handle
---@class framepointtype:           handle
---@class textaligntype:            handle
---@class frameeventtype:           handle
---@class oskeytype:                handle
---@class abilityintegerfield:              handle
---@class abilityrealfield:                 handle
---@class abilitybooleanfield:              handle
---@class abilitystringfield:               handle
---@class abilityintegerlevelfield:         handle
---@class abilityreallevelfield:            handle
---@class abilitybooleanlevelfield:         handle
---@class abilitystringlevelfield:          handle
---@class abilityintegerlevelarrayfield:    handle
---@class abilityreallevelarrayfield:       handle
---@class abilitybooleanlevelarrayfield:    handle
---@class abilitystringlevelarrayfield:     handle
---@class unitintegerfield:                 handle
---@class unitrealfield:                    handle
---@class unitbooleanfield:                 handle
---@class unitstringfield:                  handle
---@class unitweaponintegerfield:           handle
---@class unitweaponrealfield:              handle
---@class unitweaponbooleanfield:           handle
---@class unitweaponstringfield:            handle
---@class itemintegerfield:                 handle
---@class itemrealfield:                    handle
---@class itembooleanfield:                 handle
---@class itemstringfield:                  handle
---@class movetype:                         handle
---@class targetflag:                       handle
---@class armortype:                        handle
---@class heroattribute:                    handle
---@class defensetype:                      handle
---@class regentype:                        handle
---@class unitcategory:                     handle
---@class pathingflag:                      handle
---@class commandbuttoneffect:              handle


ConvertRace=nil                 ---@type fun(i: integer): race (native)
ConvertAllianceType=nil         ---@type fun(i: integer): alliancetype (native)
ConvertRacePref=nil             ---@type fun(i: integer): racepreference (native)
ConvertIGameState=nil           ---@type fun(i: integer): igamestate (native)
ConvertFGameState=nil           ---@type fun(i: integer): fgamestate (native)
ConvertPlayerState=nil          ---@type fun(i: integer): playerstate (native)
ConvertPlayerScore=nil          ---@type fun(i: integer): playerscore (native)
ConvertPlayerGameResult=nil     ---@type fun(i: integer): playergameresult (native)
ConvertUnitState=nil            ---@type fun(i: integer): unitstate (native)
ConvertAIDifficulty=nil         ---@type fun(i: integer): aidifficulty (native)
ConvertGameEvent=nil            ---@type fun(i: integer): gameevent (native)
ConvertPlayerEvent=nil          ---@type fun(i: integer): playerevent (native)
ConvertPlayerUnitEvent=nil      ---@type fun(i: integer): playerunitevent (native)
ConvertWidgetEvent=nil          ---@type fun(i: integer): widgetevent (native)
ConvertDialogEvent=nil          ---@type fun(i: integer): dialogevent (native)
ConvertUnitEvent=nil            ---@type fun(i: integer): unitevent (native)
ConvertLimitOp=nil              ---@type fun(i: integer): limitop (native)
ConvertUnitType=nil             ---@type fun(i: integer): unittype (native)
ConvertGameSpeed=nil            ---@type fun(i: integer): gamespeed (native)
ConvertPlacement=nil            ---@type fun(i: integer): placement (native)
ConvertStartLocPrio=nil         ---@type fun(i: integer): startlocprio (native)
ConvertGameDifficulty=nil       ---@type fun(i: integer): gamedifficulty (native)
ConvertGameType=nil             ---@type fun(i: integer): gametype (native)
ConvertMapFlag=nil              ---@type fun(i: integer): mapflag (native)
ConvertMapVisibility=nil        ---@type fun(i: integer): mapvisibility (native)
ConvertMapSetting=nil           ---@type fun(i: integer): mapsetting (native)
ConvertMapDensity=nil           ---@type fun(i: integer): mapdensity (native)
ConvertMapControl=nil           ---@type fun(i: integer): mapcontrol (native)
ConvertPlayerColor=nil          ---@type fun(i: integer): playercolor (native)
ConvertPlayerSlotState=nil      ---@type fun(i: integer): playerslotstate (native)
ConvertVolumeGroup=nil          ---@type fun(i: integer): volumegroup (native)
ConvertCameraField=nil          ---@type fun(i: integer): camerafield (native)
ConvertBlendMode=nil            ---@type fun(i: integer): blendmode (native)
ConvertRarityControl=nil        ---@type fun(i: integer): raritycontrol (native)
ConvertTexMapFlags=nil          ---@type fun(i: integer): texmapflags (native)
ConvertFogState=nil             ---@type fun(i: integer): fogstate (native)
ConvertEffectType=nil           ---@type fun(i: integer): effecttype (native)
ConvertVersion=nil              ---@type fun(i: integer): version (native)
ConvertItemType=nil             ---@type fun(i: integer): itemtype (native)
ConvertAttackType=nil           ---@type fun(i: integer): attacktype (native)
ConvertDamageType=nil           ---@type fun(i: integer): damagetype (native)
ConvertWeaponType=nil           ---@type fun(i: integer): weapontype (native)
ConvertSoundType=nil            ---@type fun(i: integer): soundtype (native)
ConvertPathingType=nil          ---@type fun(i: integer): pathingtype (native)
ConvertMouseButtonType=nil      ---@type fun(i: integer): mousebuttontype (native)
ConvertAnimType=nil             ---@type fun(i: integer): animtype (native)
ConvertSubAnimType=nil          ---@type fun(i: integer): subanimtype (native)
ConvertOriginFrameType=nil      ---@type fun(i: integer): originframetype (native)
ConvertFramePointType=nil       ---@type fun(i: integer): framepointtype (native)
ConvertTextAlignType=nil        ---@type fun(i: integer): textaligntype (native)
ConvertFrameEventType=nil       ---@type fun(i: integer): frameeventtype (native)
ConvertOsKeyType=nil            ---@type fun(i: integer): oskeytype (native)
ConvertAbilityIntegerField=nil              ---@type fun(i: integer): abilityintegerfield (native)
ConvertAbilityRealField=nil                 ---@type fun(i: integer): abilityrealfield (native)
ConvertAbilityBooleanField=nil              ---@type fun(i: integer): abilitybooleanfield (native)
ConvertAbilityStringField=nil               ---@type fun(i: integer): abilitystringfield (native)
ConvertAbilityIntegerLevelField=nil         ---@type fun(i: integer): abilityintegerlevelfield (native)
ConvertAbilityRealLevelField=nil            ---@type fun(i: integer): abilityreallevelfield (native)
ConvertAbilityBooleanLevelField=nil         ---@type fun(i: integer): abilitybooleanlevelfield (native)
ConvertAbilityStringLevelField=nil          ---@type fun(i: integer): abilitystringlevelfield (native)
ConvertAbilityIntegerLevelArrayField=nil    ---@type fun(i: integer): abilityintegerlevelarrayfield (native)
ConvertAbilityRealLevelArrayField=nil       ---@type fun(i: integer): abilityreallevelarrayfield (native)
ConvertAbilityBooleanLevelArrayField=nil    ---@type fun(i: integer): abilitybooleanlevelarrayfield (native)
ConvertAbilityStringLevelArrayField=nil     ---@type fun(i: integer): abilitystringlevelarrayfield (native)
ConvertUnitIntegerField=nil                 ---@type fun(i: integer): unitintegerfield (native)
ConvertUnitRealField=nil                    ---@type fun(i: integer): unitrealfield (native)
ConvertUnitBooleanField=nil                 ---@type fun(i: integer): unitbooleanfield (native)
ConvertUnitStringField=nil                  ---@type fun(i: integer): unitstringfield (native)
ConvertUnitWeaponIntegerField=nil           ---@type fun(i: integer): unitweaponintegerfield (native)
ConvertUnitWeaponRealField=nil              ---@type fun(i: integer): unitweaponrealfield (native)
ConvertUnitWeaponBooleanField=nil           ---@type fun(i: integer): unitweaponbooleanfield (native)
ConvertUnitWeaponStringField=nil            ---@type fun(i: integer): unitweaponstringfield (native)
ConvertItemIntegerField=nil                 ---@type fun(i: integer): itemintegerfield (native)
ConvertItemRealField=nil                    ---@type fun(i: integer): itemrealfield (native)
ConvertItemBooleanField=nil                 ---@type fun(i: integer): itembooleanfield (native)
ConvertItemStringField=nil                  ---@type fun(i: integer): itemstringfield (native)
ConvertMoveType=nil                         ---@type fun(i: integer): movetype (native)
ConvertTargetFlag=nil                       ---@type fun(i: integer): targetflag (native)
ConvertArmorType=nil                        ---@type fun(i: integer): armortype (native)
ConvertHeroAttribute=nil                    ---@type fun(i: integer): heroattribute (native)
ConvertDefenseType=nil                      ---@type fun(i: integer): defensetype (native)
ConvertRegenType=nil                        ---@type fun(i: integer): regentype (native)
ConvertUnitCategory=nil                     ---@type fun(i: integer): unitcategory (native)
ConvertPathingFlag=nil                      ---@type fun(i: integer): pathingflag (native)

OrderId=nil                     ---@type fun(orderIdString: string): integer (native)
OrderId2String=nil              ---@type fun(orderId: integer): string (native)
UnitId=nil                      ---@type fun(unitIdString: string): integer (native)
UnitId2String=nil               ---@type fun(unitId: integer): string (native)

-- Not currently working correctly...
AbilityId=nil                   ---@type fun(abilityIdString: string): integer (native)
AbilityId2String=nil            ---@type fun(abilityId: integer): string (native)

-- Looks up the "name" field for any object (unit, item, ability)
GetObjectName=nil               ---@type fun(objectId: integer): string (native)

GetBJMaxPlayers=nil             ---@type fun(): integer (native)
GetBJPlayerNeutralVictim=nil    ---@type fun(): integer (native)
GetBJPlayerNeutralExtra=nil     ---@type fun(): integer (native)
GetBJMaxPlayerSlots=nil         ---@type fun(): integer (native)
GetPlayerNeutralPassive=nil     ---@type fun(): integer (native)
GetPlayerNeutralAggressive=nil  ---@type fun(): integer (native)



--===================================================
-- Game Constants
--===================================================

    -- pfff
    FALSE                                              = false ---@type boolean 
    TRUE                                               = true ---@type boolean 
    JASS_MAX_ARRAY_SIZE                                = 32768 ---@type integer 

    PLAYER_NEUTRAL_PASSIVE                             = GetPlayerNeutralPassive() ---@type integer 
    PLAYER_NEUTRAL_AGGRESSIVE                          = GetPlayerNeutralAggressive() ---@type integer 

    PLAYER_COLOR_RED                                   = ConvertPlayerColor(0) ---@type playercolor 
    PLAYER_COLOR_BLUE                                  = ConvertPlayerColor(1) ---@type playercolor 
    PLAYER_COLOR_CYAN                                  = ConvertPlayerColor(2) ---@type playercolor 
    PLAYER_COLOR_PURPLE                                = ConvertPlayerColor(3) ---@type playercolor 
    PLAYER_COLOR_YELLOW                                = ConvertPlayerColor(4) ---@type playercolor 
    PLAYER_COLOR_ORANGE                                = ConvertPlayerColor(5) ---@type playercolor 
    PLAYER_COLOR_GREEN                                 = ConvertPlayerColor(6) ---@type playercolor 
    PLAYER_COLOR_PINK                                  = ConvertPlayerColor(7) ---@type playercolor 
    PLAYER_COLOR_LIGHT_GRAY                            = ConvertPlayerColor(8) ---@type playercolor 
    PLAYER_COLOR_LIGHT_BLUE                            = ConvertPlayerColor(9) ---@type playercolor 
    PLAYER_COLOR_AQUA                                  = ConvertPlayerColor(10) ---@type playercolor 
    PLAYER_COLOR_BROWN                                 = ConvertPlayerColor(11) ---@type playercolor 
    PLAYER_COLOR_MAROON                                = ConvertPlayerColor(12) ---@type playercolor 
    PLAYER_COLOR_NAVY                                  = ConvertPlayerColor(13) ---@type playercolor 
    PLAYER_COLOR_TURQUOISE                             = ConvertPlayerColor(14) ---@type playercolor 
    PLAYER_COLOR_VIOLET                                = ConvertPlayerColor(15) ---@type playercolor 
    PLAYER_COLOR_WHEAT                                 = ConvertPlayerColor(16) ---@type playercolor 
    PLAYER_COLOR_PEACH                                 = ConvertPlayerColor(17) ---@type playercolor 
    PLAYER_COLOR_MINT                                  = ConvertPlayerColor(18) ---@type playercolor 
    PLAYER_COLOR_LAVENDER                              = ConvertPlayerColor(19) ---@type playercolor 
    PLAYER_COLOR_COAL                                  = ConvertPlayerColor(20) ---@type playercolor 
    PLAYER_COLOR_SNOW                                  = ConvertPlayerColor(21) ---@type playercolor 
    PLAYER_COLOR_EMERALD                               = ConvertPlayerColor(22) ---@type playercolor 
    PLAYER_COLOR_PEANUT                                = ConvertPlayerColor(23) ---@type playercolor 

    RACE_HUMAN                                         = ConvertRace(1) ---@type race 
    RACE_ORC                                           = ConvertRace(2) ---@type race 
    RACE_UNDEAD                                        = ConvertRace(3) ---@type race 
    RACE_NIGHTELF                                      = ConvertRace(4) ---@type race 
    RACE_DEMON                                         = ConvertRace(5) ---@type race 
    RACE_OTHER                                         = ConvertRace(7) ---@type race 

    PLAYER_GAME_RESULT_VICTORY                         = ConvertPlayerGameResult(0) ---@type playergameresult 
    PLAYER_GAME_RESULT_DEFEAT                          = ConvertPlayerGameResult(1) ---@type playergameresult 
    PLAYER_GAME_RESULT_TIE                             = ConvertPlayerGameResult(2) ---@type playergameresult 
    PLAYER_GAME_RESULT_NEUTRAL                         = ConvertPlayerGameResult(3) ---@type playergameresult 

    ALLIANCE_PASSIVE                                   = ConvertAllianceType(0) ---@type alliancetype 
    ALLIANCE_HELP_REQUEST                              = ConvertAllianceType(1) ---@type alliancetype 
    ALLIANCE_HELP_RESPONSE                             = ConvertAllianceType(2) ---@type alliancetype 
    ALLIANCE_SHARED_XP                                 = ConvertAllianceType(3) ---@type alliancetype 
    ALLIANCE_SHARED_SPELLS                             = ConvertAllianceType(4) ---@type alliancetype 
    ALLIANCE_SHARED_VISION                             = ConvertAllianceType(5) ---@type alliancetype 
    ALLIANCE_SHARED_CONTROL                            = ConvertAllianceType(6) ---@type alliancetype 
    ALLIANCE_SHARED_ADVANCED_CONTROL                   = ConvertAllianceType(7) ---@type alliancetype 
    ALLIANCE_RESCUABLE                                 = ConvertAllianceType(8) ---@type alliancetype 
    ALLIANCE_SHARED_VISION_FORCED                      = ConvertAllianceType(9) ---@type alliancetype 

    VERSION_REIGN_OF_CHAOS                             = ConvertVersion(0) ---@type version 
    VERSION_FROZEN_THRONE                              = ConvertVersion(1) ---@type version 

    ATTACK_TYPE_NORMAL                                 = ConvertAttackType(0) ---@type attacktype 
    ATTACK_TYPE_MELEE                                  = ConvertAttackType(1) ---@type attacktype 
    ATTACK_TYPE_PIERCE                                 = ConvertAttackType(2) ---@type attacktype 
    ATTACK_TYPE_SIEGE                                  = ConvertAttackType(3) ---@type attacktype 
    ATTACK_TYPE_MAGIC                                  = ConvertAttackType(4) ---@type attacktype 
    ATTACK_TYPE_CHAOS                                  = ConvertAttackType(5) ---@type attacktype 
    ATTACK_TYPE_HERO                                   = ConvertAttackType(6) ---@type attacktype 

    DAMAGE_TYPE_UNKNOWN                                = ConvertDamageType(0) ---@type damagetype 
    DAMAGE_TYPE_NORMAL                                 = ConvertDamageType(4) ---@type damagetype 
    DAMAGE_TYPE_ENHANCED                               = ConvertDamageType(5) ---@type damagetype 
    DAMAGE_TYPE_FIRE                                   = ConvertDamageType(8) ---@type damagetype 
    DAMAGE_TYPE_COLD                                   = ConvertDamageType(9) ---@type damagetype 
    DAMAGE_TYPE_LIGHTNING                              = ConvertDamageType(10) ---@type damagetype 
    DAMAGE_TYPE_POISON                                 = ConvertDamageType(11) ---@type damagetype 
    DAMAGE_TYPE_DISEASE                                = ConvertDamageType(12) ---@type damagetype 
    DAMAGE_TYPE_DIVINE                                 = ConvertDamageType(13) ---@type damagetype 
    DAMAGE_TYPE_MAGIC                                  = ConvertDamageType(14) ---@type damagetype 
    DAMAGE_TYPE_SONIC                                  = ConvertDamageType(15) ---@type damagetype 
    DAMAGE_TYPE_ACID                                   = ConvertDamageType(16) ---@type damagetype 
    DAMAGE_TYPE_FORCE                                  = ConvertDamageType(17) ---@type damagetype 
    DAMAGE_TYPE_DEATH                                  = ConvertDamageType(18) ---@type damagetype 
    DAMAGE_TYPE_MIND                                   = ConvertDamageType(19) ---@type damagetype 
    DAMAGE_TYPE_PLANT                                  = ConvertDamageType(20) ---@type damagetype 
    DAMAGE_TYPE_DEFENSIVE                              = ConvertDamageType(21) ---@type damagetype 
    DAMAGE_TYPE_DEMOLITION                             = ConvertDamageType(22) ---@type damagetype 
    DAMAGE_TYPE_SLOW_POISON                            = ConvertDamageType(23) ---@type damagetype 
    DAMAGE_TYPE_SPIRIT_LINK                            = ConvertDamageType(24) ---@type damagetype 
    DAMAGE_TYPE_SHADOW_STRIKE                          = ConvertDamageType(25) ---@type damagetype 
    DAMAGE_TYPE_UNIVERSAL                              = ConvertDamageType(26) ---@type damagetype 

    WEAPON_TYPE_WHOKNOWS                               = ConvertWeaponType(0) ---@type weapontype 
    WEAPON_TYPE_METAL_LIGHT_CHOP                       = ConvertWeaponType(1) ---@type weapontype 
    WEAPON_TYPE_METAL_MEDIUM_CHOP                      = ConvertWeaponType(2) ---@type weapontype 
    WEAPON_TYPE_METAL_HEAVY_CHOP                       = ConvertWeaponType(3) ---@type weapontype 
    WEAPON_TYPE_METAL_LIGHT_SLICE                      = ConvertWeaponType(4) ---@type weapontype 
    WEAPON_TYPE_METAL_MEDIUM_SLICE                     = ConvertWeaponType(5) ---@type weapontype 
    WEAPON_TYPE_METAL_HEAVY_SLICE                      = ConvertWeaponType(6) ---@type weapontype 
    WEAPON_TYPE_METAL_MEDIUM_BASH                      = ConvertWeaponType(7) ---@type weapontype 
    WEAPON_TYPE_METAL_HEAVY_BASH                       = ConvertWeaponType(8) ---@type weapontype 
    WEAPON_TYPE_METAL_MEDIUM_STAB                      = ConvertWeaponType(9) ---@type weapontype 
    WEAPON_TYPE_METAL_HEAVY_STAB                       = ConvertWeaponType(10) ---@type weapontype 
    WEAPON_TYPE_WOOD_LIGHT_SLICE                       = ConvertWeaponType(11) ---@type weapontype 
    WEAPON_TYPE_WOOD_MEDIUM_SLICE                      = ConvertWeaponType(12) ---@type weapontype 
    WEAPON_TYPE_WOOD_HEAVY_SLICE                       = ConvertWeaponType(13) ---@type weapontype 
    WEAPON_TYPE_WOOD_LIGHT_BASH                        = ConvertWeaponType(14) ---@type weapontype 
    WEAPON_TYPE_WOOD_MEDIUM_BASH                       = ConvertWeaponType(15) ---@type weapontype 
    WEAPON_TYPE_WOOD_HEAVY_BASH                        = ConvertWeaponType(16) ---@type weapontype 
    WEAPON_TYPE_WOOD_LIGHT_STAB                        = ConvertWeaponType(17) ---@type weapontype 
    WEAPON_TYPE_WOOD_MEDIUM_STAB                       = ConvertWeaponType(18) ---@type weapontype 
    WEAPON_TYPE_CLAW_LIGHT_SLICE                       = ConvertWeaponType(19) ---@type weapontype 
    WEAPON_TYPE_CLAW_MEDIUM_SLICE                      = ConvertWeaponType(20) ---@type weapontype 
    WEAPON_TYPE_CLAW_HEAVY_SLICE                       = ConvertWeaponType(21) ---@type weapontype 
    WEAPON_TYPE_AXE_MEDIUM_CHOP                        = ConvertWeaponType(22) ---@type weapontype 
    WEAPON_TYPE_ROCK_HEAVY_BASH                        = ConvertWeaponType(23) ---@type weapontype 

    PATHING_TYPE_ANY                                   = ConvertPathingType(0) ---@type pathingtype 
    PATHING_TYPE_WALKABILITY                           = ConvertPathingType(1) ---@type pathingtype 
    PATHING_TYPE_FLYABILITY                            = ConvertPathingType(2) ---@type pathingtype 
    PATHING_TYPE_BUILDABILITY                          = ConvertPathingType(3) ---@type pathingtype 
    PATHING_TYPE_PEONHARVESTPATHING                    = ConvertPathingType(4) ---@type pathingtype 
    PATHING_TYPE_BLIGHTPATHING                         = ConvertPathingType(5) ---@type pathingtype 
    PATHING_TYPE_FLOATABILITY                          = ConvertPathingType(6) ---@type pathingtype 
    PATHING_TYPE_AMPHIBIOUSPATHING                     = ConvertPathingType(7) ---@type pathingtype 

    MOUSE_BUTTON_TYPE_LEFT                             = ConvertMouseButtonType(1) ---@type mousebuttontype 
    MOUSE_BUTTON_TYPE_MIDDLE                           = ConvertMouseButtonType(2) ---@type mousebuttontype 
    MOUSE_BUTTON_TYPE_RIGHT                            = ConvertMouseButtonType(3) ---@type mousebuttontype 

    ANIM_TYPE_BIRTH                                    = ConvertAnimType(0) ---@type animtype 
    ANIM_TYPE_DEATH                                    = ConvertAnimType(1) ---@type animtype 
    ANIM_TYPE_DECAY                                    = ConvertAnimType(2) ---@type animtype 
    ANIM_TYPE_DISSIPATE                                = ConvertAnimType(3) ---@type animtype 
    ANIM_TYPE_STAND                                    = ConvertAnimType(4) ---@type animtype 
    ANIM_TYPE_WALK                                     = ConvertAnimType(5) ---@type animtype 
    ANIM_TYPE_ATTACK                                   = ConvertAnimType(6) ---@type animtype 
    ANIM_TYPE_MORPH                                    = ConvertAnimType(7) ---@type animtype 
    ANIM_TYPE_SLEEP                                    = ConvertAnimType(8) ---@type animtype 
    ANIM_TYPE_SPELL                                    = ConvertAnimType(9) ---@type animtype 
    ANIM_TYPE_PORTRAIT                                 = ConvertAnimType(10) ---@type animtype 

    SUBANIM_TYPE_ROOTED                                = ConvertSubAnimType(11) ---@type subanimtype 
    SUBANIM_TYPE_ALTERNATE_EX                          = ConvertSubAnimType(12) ---@type subanimtype 
    SUBANIM_TYPE_LOOPING                               = ConvertSubAnimType(13) ---@type subanimtype 
    SUBANIM_TYPE_SLAM                                  = ConvertSubAnimType(14) ---@type subanimtype 
    SUBANIM_TYPE_THROW                                 = ConvertSubAnimType(15) ---@type subanimtype 
    SUBANIM_TYPE_SPIKED                                = ConvertSubAnimType(16) ---@type subanimtype 
    SUBANIM_TYPE_FAST                                  = ConvertSubAnimType(17) ---@type subanimtype 
    SUBANIM_TYPE_SPIN                                  = ConvertSubAnimType(18) ---@type subanimtype 
    SUBANIM_TYPE_READY                                 = ConvertSubAnimType(19) ---@type subanimtype 
    SUBANIM_TYPE_CHANNEL                               = ConvertSubAnimType(20) ---@type subanimtype 
    SUBANIM_TYPE_DEFEND                                = ConvertSubAnimType(21) ---@type subanimtype 
    SUBANIM_TYPE_VICTORY                               = ConvertSubAnimType(22) ---@type subanimtype 
    SUBANIM_TYPE_TURN                                  = ConvertSubAnimType(23) ---@type subanimtype 
    SUBANIM_TYPE_LEFT                                  = ConvertSubAnimType(24) ---@type subanimtype 
    SUBANIM_TYPE_RIGHT                                 = ConvertSubAnimType(25) ---@type subanimtype 
    SUBANIM_TYPE_FIRE                                  = ConvertSubAnimType(26) ---@type subanimtype 
    SUBANIM_TYPE_FLESH                                 = ConvertSubAnimType(27) ---@type subanimtype 
    SUBANIM_TYPE_HIT                                   = ConvertSubAnimType(28) ---@type subanimtype 
    SUBANIM_TYPE_WOUNDED                               = ConvertSubAnimType(29) ---@type subanimtype 
    SUBANIM_TYPE_LIGHT                                 = ConvertSubAnimType(30) ---@type subanimtype 
    SUBANIM_TYPE_MODERATE                              = ConvertSubAnimType(31) ---@type subanimtype 
    SUBANIM_TYPE_SEVERE                                = ConvertSubAnimType(32) ---@type subanimtype 
    SUBANIM_TYPE_CRITICAL                              = ConvertSubAnimType(33) ---@type subanimtype 
    SUBANIM_TYPE_COMPLETE                              = ConvertSubAnimType(34) ---@type subanimtype 
    SUBANIM_TYPE_GOLD                                  = ConvertSubAnimType(35) ---@type subanimtype 
    SUBANIM_TYPE_LUMBER                                = ConvertSubAnimType(36) ---@type subanimtype 
    SUBANIM_TYPE_WORK                                  = ConvertSubAnimType(37) ---@type subanimtype 
    SUBANIM_TYPE_TALK                                  = ConvertSubAnimType(38) ---@type subanimtype 
    SUBANIM_TYPE_FIRST                                 = ConvertSubAnimType(39) ---@type subanimtype 
    SUBANIM_TYPE_SECOND                                = ConvertSubAnimType(40) ---@type subanimtype 
    SUBANIM_TYPE_THIRD                                 = ConvertSubAnimType(41) ---@type subanimtype 
    SUBANIM_TYPE_FOURTH                                = ConvertSubAnimType(42) ---@type subanimtype 
    SUBANIM_TYPE_FIFTH                                 = ConvertSubAnimType(43) ---@type subanimtype 
    SUBANIM_TYPE_ONE                                   = ConvertSubAnimType(44) ---@type subanimtype 
    SUBANIM_TYPE_TWO                                   = ConvertSubAnimType(45) ---@type subanimtype 
    SUBANIM_TYPE_THREE                                 = ConvertSubAnimType(46) ---@type subanimtype 
    SUBANIM_TYPE_FOUR                                  = ConvertSubAnimType(47) ---@type subanimtype 
    SUBANIM_TYPE_FIVE                                  = ConvertSubAnimType(48) ---@type subanimtype 
    SUBANIM_TYPE_SMALL                                 = ConvertSubAnimType(49) ---@type subanimtype 
    SUBANIM_TYPE_MEDIUM                                = ConvertSubAnimType(50) ---@type subanimtype 
    SUBANIM_TYPE_LARGE                                 = ConvertSubAnimType(51) ---@type subanimtype 
    SUBANIM_TYPE_UPGRADE                               = ConvertSubAnimType(52) ---@type subanimtype 
    SUBANIM_TYPE_DRAIN                                 = ConvertSubAnimType(53) ---@type subanimtype 
    SUBANIM_TYPE_FILL                                  = ConvertSubAnimType(54) ---@type subanimtype 
    SUBANIM_TYPE_CHAINLIGHTNING                        = ConvertSubAnimType(55) ---@type subanimtype 
    SUBANIM_TYPE_EATTREE                               = ConvertSubAnimType(56) ---@type subanimtype 
    SUBANIM_TYPE_PUKE                                  = ConvertSubAnimType(57) ---@type subanimtype 
    SUBANIM_TYPE_FLAIL                                 = ConvertSubAnimType(58) ---@type subanimtype 
    SUBANIM_TYPE_OFF                                   = ConvertSubAnimType(59) ---@type subanimtype 
    SUBANIM_TYPE_SWIM                                  = ConvertSubAnimType(60) ---@type subanimtype 
    SUBANIM_TYPE_ENTANGLE                              = ConvertSubAnimType(61) ---@type subanimtype 
    SUBANIM_TYPE_BERSERK                               = ConvertSubAnimType(62) ---@type subanimtype 

--===================================================
-- Map Setup Constants
--===================================================

    RACE_PREF_HUMAN                                        = ConvertRacePref(1) ---@type racepreference 
    RACE_PREF_ORC                                          = ConvertRacePref(2) ---@type racepreference 
    RACE_PREF_NIGHTELF                                     = ConvertRacePref(4) ---@type racepreference 
    RACE_PREF_UNDEAD                                       = ConvertRacePref(8) ---@type racepreference 
    RACE_PREF_DEMON                                        = ConvertRacePref(16) ---@type racepreference 
    RACE_PREF_RANDOM                                       = ConvertRacePref(32) ---@type racepreference 
    RACE_PREF_USER_SELECTABLE                              = ConvertRacePref(64) ---@type racepreference 

    MAP_CONTROL_USER                                       = ConvertMapControl(0) ---@type mapcontrol 
    MAP_CONTROL_COMPUTER                                   = ConvertMapControl(1) ---@type mapcontrol 
    MAP_CONTROL_RESCUABLE                                  = ConvertMapControl(2) ---@type mapcontrol 
    MAP_CONTROL_NEUTRAL                                    = ConvertMapControl(3) ---@type mapcontrol 
    MAP_CONTROL_CREEP                                      = ConvertMapControl(4) ---@type mapcontrol 
    MAP_CONTROL_NONE                                       = ConvertMapControl(5) ---@type mapcontrol 

    GAME_TYPE_MELEE                                        = ConvertGameType(1) ---@type gametype 
    GAME_TYPE_FFA                                          = ConvertGameType(2) ---@type gametype 
    GAME_TYPE_USE_MAP_SETTINGS                             = ConvertGameType(4) ---@type gametype 
    GAME_TYPE_BLIZ                                         = ConvertGameType(8) ---@type gametype 
    GAME_TYPE_ONE_ON_ONE                                   = ConvertGameType(16) ---@type gametype 
    GAME_TYPE_TWO_TEAM_PLAY                                = ConvertGameType(32) ---@type gametype 
    GAME_TYPE_THREE_TEAM_PLAY                              = ConvertGameType(64) ---@type gametype 
    GAME_TYPE_FOUR_TEAM_PLAY                               = ConvertGameType(128) ---@type gametype 

    MAP_FOG_HIDE_TERRAIN                                   = ConvertMapFlag(1) ---@type mapflag 
    MAP_FOG_MAP_EXPLORED                                   = ConvertMapFlag(2) ---@type mapflag 
    MAP_FOG_ALWAYS_VISIBLE                                 = ConvertMapFlag(4) ---@type mapflag 

    MAP_USE_HANDICAPS                                      = ConvertMapFlag(8) ---@type mapflag 
    MAP_OBSERVERS                                          = ConvertMapFlag(16) ---@type mapflag 
    MAP_OBSERVERS_ON_DEATH                                 = ConvertMapFlag(32) ---@type mapflag 

    MAP_FIXED_COLORS                                       = ConvertMapFlag(128) ---@type mapflag 

    MAP_LOCK_RESOURCE_TRADING                              = ConvertMapFlag(256) ---@type mapflag 
    MAP_RESOURCE_TRADING_ALLIES_ONLY                       = ConvertMapFlag(512) ---@type mapflag 

    MAP_LOCK_ALLIANCE_CHANGES                              = ConvertMapFlag(1024) ---@type mapflag 
    MAP_ALLIANCE_CHANGES_HIDDEN                            = ConvertMapFlag(2048) ---@type mapflag 

    MAP_CHEATS                                             = ConvertMapFlag(4096) ---@type mapflag 
    MAP_CHEATS_HIDDEN                                      = ConvertMapFlag(8192) ---@type mapflag 

    MAP_LOCK_SPEED                                         = ConvertMapFlag(8192*2) ---@type mapflag 
    MAP_LOCK_RANDOM_SEED                                   = ConvertMapFlag(8192*4) ---@type mapflag 
    MAP_SHARED_ADVANCED_CONTROL                            = ConvertMapFlag(8192*8) ---@type mapflag 
    MAP_RANDOM_HERO                                        = ConvertMapFlag(8192*16) ---@type mapflag 
    MAP_RANDOM_RACES                                       = ConvertMapFlag(8192*32) ---@type mapflag 
    MAP_RELOADED                                           = ConvertMapFlag(8192*64) ---@type mapflag 

    MAP_PLACEMENT_RANDOM                                   = ConvertPlacement(0)    ---@type placement -- random among all slots
    MAP_PLACEMENT_FIXED                                    = ConvertPlacement(1)    ---@type placement -- player 0 in start loc 0...
    MAP_PLACEMENT_USE_MAP_SETTINGS                         = ConvertPlacement(2)    ---@type placement -- whatever was specified by the script
    MAP_PLACEMENT_TEAMS_TOGETHER                           = ConvertPlacement(3)    ---@type placement -- random with allies next to each other

    MAP_LOC_PRIO_LOW                                       = ConvertStartLocPrio(0) ---@type startlocprio 
    MAP_LOC_PRIO_HIGH                                      = ConvertStartLocPrio(1) ---@type startlocprio 
    MAP_LOC_PRIO_NOT                                       = ConvertStartLocPrio(2) ---@type startlocprio 

    MAP_DENSITY_NONE                                       = ConvertMapDensity(0) ---@type mapdensity 
    MAP_DENSITY_LIGHT                                      = ConvertMapDensity(1) ---@type mapdensity 
    MAP_DENSITY_MEDIUM                                     = ConvertMapDensity(2) ---@type mapdensity 
    MAP_DENSITY_HEAVY                                      = ConvertMapDensity(3) ---@type mapdensity 

    MAP_DIFFICULTY_EASY                                    = ConvertGameDifficulty(0) ---@type gamedifficulty 
    MAP_DIFFICULTY_NORMAL                                  = ConvertGameDifficulty(1) ---@type gamedifficulty 
    MAP_DIFFICULTY_HARD                                    = ConvertGameDifficulty(2) ---@type gamedifficulty 
    MAP_DIFFICULTY_INSANE                                  = ConvertGameDifficulty(3) ---@type gamedifficulty 

    MAP_SPEED_SLOWEST                                      = ConvertGameSpeed(0) ---@type gamespeed 
    MAP_SPEED_SLOW                                         = ConvertGameSpeed(1) ---@type gamespeed 
    MAP_SPEED_NORMAL                                       = ConvertGameSpeed(2) ---@type gamespeed 
    MAP_SPEED_FAST                                         = ConvertGameSpeed(3) ---@type gamespeed 
    MAP_SPEED_FASTEST                                      = ConvertGameSpeed(4) ---@type gamespeed 

    PLAYER_SLOT_STATE_EMPTY                                = ConvertPlayerSlotState(0) ---@type playerslotstate 
    PLAYER_SLOT_STATE_PLAYING                              = ConvertPlayerSlotState(1) ---@type playerslotstate 
    PLAYER_SLOT_STATE_LEFT                                 = ConvertPlayerSlotState(2) ---@type playerslotstate 

--===================================================
-- Sound Constants
--===================================================
    SOUND_VOLUMEGROUP_UNITMOVEMENT                         = ConvertVolumeGroup(0) ---@type volumegroup 
    SOUND_VOLUMEGROUP_UNITSOUNDS                           = ConvertVolumeGroup(1) ---@type volumegroup 
    SOUND_VOLUMEGROUP_COMBAT                               = ConvertVolumeGroup(2) ---@type volumegroup 
    SOUND_VOLUMEGROUP_SPELLS                               = ConvertVolumeGroup(3) ---@type volumegroup 
    SOUND_VOLUMEGROUP_UI                                   = ConvertVolumeGroup(4) ---@type volumegroup 
    SOUND_VOLUMEGROUP_MUSIC                                = ConvertVolumeGroup(5) ---@type volumegroup 
    SOUND_VOLUMEGROUP_AMBIENTSOUNDS                        = ConvertVolumeGroup(6) ---@type volumegroup 
    SOUND_VOLUMEGROUP_FIRE                                 = ConvertVolumeGroup(7) ---@type volumegroup 
--Cinematic Sound Constants
    SOUND_VOLUMEGROUP_CINEMATIC_GENERAL                            = ConvertVolumeGroup(8) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_AMBIENT                            = ConvertVolumeGroup(9) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_MUSIC                              = ConvertVolumeGroup(10) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_DIALOGUE                           = ConvertVolumeGroup(11) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_1                    = ConvertVolumeGroup(12) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_2                    = ConvertVolumeGroup(13) ---@type volumegroup 
    SOUND_VOLUMEGROUP_CINEMATIC_SOUND_EFFECTS_3                    = ConvertVolumeGroup(14) ---@type volumegroup 


--===================================================
-- Game, Player, and Unit States
--
-- For use with TriggerRegister<X>StateEvent
--
--===================================================

    GAME_STATE_DIVINE_INTERVENTION                     = ConvertIGameState(0) ---@type igamestate 
    GAME_STATE_DISCONNECTED                            = ConvertIGameState(1) ---@type igamestate 
    GAME_STATE_TIME_OF_DAY                             = ConvertFGameState(2) ---@type fgamestate 

    PLAYER_STATE_GAME_RESULT                           = ConvertPlayerState(0) ---@type playerstate 

    -- current resource levels
    --
    PLAYER_STATE_RESOURCE_GOLD                         = ConvertPlayerState(1) ---@type playerstate 
    PLAYER_STATE_RESOURCE_LUMBER                       = ConvertPlayerState(2) ---@type playerstate 
    PLAYER_STATE_RESOURCE_HERO_TOKENS                  = ConvertPlayerState(3) ---@type playerstate 
    PLAYER_STATE_RESOURCE_FOOD_CAP                     = ConvertPlayerState(4) ---@type playerstate 
    PLAYER_STATE_RESOURCE_FOOD_USED                    = ConvertPlayerState(5) ---@type playerstate 
    PLAYER_STATE_FOOD_CAP_CEILING                      = ConvertPlayerState(6) ---@type playerstate 

    PLAYER_STATE_GIVES_BOUNTY                          = ConvertPlayerState(7) ---@type playerstate 
    PLAYER_STATE_ALLIED_VICTORY                        = ConvertPlayerState(8) ---@type playerstate 
    PLAYER_STATE_PLACED                                = ConvertPlayerState(9) ---@type playerstate 
    PLAYER_STATE_OBSERVER_ON_DEATH                     = ConvertPlayerState(10) ---@type playerstate 
    PLAYER_STATE_OBSERVER                              = ConvertPlayerState(11) ---@type playerstate 
    PLAYER_STATE_UNFOLLOWABLE                          = ConvertPlayerState(12) ---@type playerstate 

    -- taxation rate for each resource
    --
    PLAYER_STATE_GOLD_UPKEEP_RATE                      = ConvertPlayerState(13) ---@type playerstate 
    PLAYER_STATE_LUMBER_UPKEEP_RATE                    = ConvertPlayerState(14) ---@type playerstate 

    -- cumulative resources collected by the player during the mission
    --
    PLAYER_STATE_GOLD_GATHERED                         = ConvertPlayerState(15) ---@type playerstate 
    PLAYER_STATE_LUMBER_GATHERED                       = ConvertPlayerState(16) ---@type playerstate 

    PLAYER_STATE_NO_CREEP_SLEEP                        = ConvertPlayerState(25) ---@type playerstate 

    UNIT_STATE_LIFE                                    = ConvertUnitState(0) ---@type unitstate 
    UNIT_STATE_MAX_LIFE                                = ConvertUnitState(1) ---@type unitstate 
    UNIT_STATE_MANA                                    = ConvertUnitState(2) ---@type unitstate 
    UNIT_STATE_MAX_MANA                                = ConvertUnitState(3) ---@type unitstate 

    AI_DIFFICULTY_NEWBIE                               = ConvertAIDifficulty(0) ---@type aidifficulty 
    AI_DIFFICULTY_NORMAL                               = ConvertAIDifficulty(1) ---@type aidifficulty 
    AI_DIFFICULTY_INSANE                               = ConvertAIDifficulty(2) ---@type aidifficulty 

    -- player score values
    PLAYER_SCORE_UNITS_TRAINED                         = ConvertPlayerScore(0) ---@type playerscore 
    PLAYER_SCORE_UNITS_KILLED                          = ConvertPlayerScore(1) ---@type playerscore 
    PLAYER_SCORE_STRUCT_BUILT                          = ConvertPlayerScore(2) ---@type playerscore 
    PLAYER_SCORE_STRUCT_RAZED                          = ConvertPlayerScore(3) ---@type playerscore 
    PLAYER_SCORE_TECH_PERCENT                          = ConvertPlayerScore(4) ---@type playerscore 
    PLAYER_SCORE_FOOD_MAXPROD                          = ConvertPlayerScore(5) ---@type playerscore 
    PLAYER_SCORE_FOOD_MAXUSED                          = ConvertPlayerScore(6) ---@type playerscore 
    PLAYER_SCORE_HEROES_KILLED                         = ConvertPlayerScore(7) ---@type playerscore 
    PLAYER_SCORE_ITEMS_GAINED                          = ConvertPlayerScore(8) ---@type playerscore 
    PLAYER_SCORE_MERCS_HIRED                           = ConvertPlayerScore(9) ---@type playerscore 
    PLAYER_SCORE_GOLD_MINED_TOTAL                      = ConvertPlayerScore(10) ---@type playerscore 
    PLAYER_SCORE_GOLD_MINED_UPKEEP                     = ConvertPlayerScore(11) ---@type playerscore 
    PLAYER_SCORE_GOLD_LOST_UPKEEP                      = ConvertPlayerScore(12) ---@type playerscore 
    PLAYER_SCORE_GOLD_LOST_TAX                         = ConvertPlayerScore(13) ---@type playerscore 
    PLAYER_SCORE_GOLD_GIVEN                            = ConvertPlayerScore(14) ---@type playerscore 
    PLAYER_SCORE_GOLD_RECEIVED                         = ConvertPlayerScore(15) ---@type playerscore 
    PLAYER_SCORE_LUMBER_TOTAL                          = ConvertPlayerScore(16) ---@type playerscore 
    PLAYER_SCORE_LUMBER_LOST_UPKEEP                    = ConvertPlayerScore(17) ---@type playerscore 
    PLAYER_SCORE_LUMBER_LOST_TAX                       = ConvertPlayerScore(18) ---@type playerscore 
    PLAYER_SCORE_LUMBER_GIVEN                          = ConvertPlayerScore(19) ---@type playerscore 
    PLAYER_SCORE_LUMBER_RECEIVED                       = ConvertPlayerScore(20) ---@type playerscore 
    PLAYER_SCORE_UNIT_TOTAL                            = ConvertPlayerScore(21) ---@type playerscore 
    PLAYER_SCORE_HERO_TOTAL                            = ConvertPlayerScore(22) ---@type playerscore 
    PLAYER_SCORE_RESOURCE_TOTAL                        = ConvertPlayerScore(23) ---@type playerscore 
    PLAYER_SCORE_TOTAL                                 = ConvertPlayerScore(24) ---@type playerscore 

--===================================================
-- Game, Player and Unit Events
--
--  When an event causes a trigger to fire these
--  values allow the action code to determine which
--  event was dispatched and therefore which set of
--  native functions should be used to get information
--  about the event.
--
-- Do NOT change the order or value of these constants
-- without insuring that the JASS_GAME_EVENTS_WAR3 enum
-- is changed to match.
--
--===================================================

    --===================================================
    -- For use with TriggerRegisterGameEvent
    --===================================================

    EVENT_GAME_VICTORY                                 = ConvertGameEvent(0) ---@type gameevent 
    EVENT_GAME_END_LEVEL                               = ConvertGameEvent(1) ---@type gameevent 

    EVENT_GAME_VARIABLE_LIMIT                          = ConvertGameEvent(2) ---@type gameevent 
    EVENT_GAME_STATE_LIMIT                             = ConvertGameEvent(3) ---@type gameevent 

    EVENT_GAME_TIMER_EXPIRED                           = ConvertGameEvent(4) ---@type gameevent 

    EVENT_GAME_ENTER_REGION                            = ConvertGameEvent(5) ---@type gameevent 
    EVENT_GAME_LEAVE_REGION                            = ConvertGameEvent(6) ---@type gameevent 

    EVENT_GAME_TRACKABLE_HIT                           = ConvertGameEvent(7) ---@type gameevent 
    EVENT_GAME_TRACKABLE_TRACK                         = ConvertGameEvent(8) ---@type gameevent 

    EVENT_GAME_SHOW_SKILL                              = ConvertGameEvent(9) ---@type gameevent 
    EVENT_GAME_BUILD_SUBMENU                           = ConvertGameEvent(10) ---@type gameevent 

    --===================================================
    -- For use with TriggerRegisterPlayerEvent
    --===================================================
    EVENT_PLAYER_STATE_LIMIT                           = ConvertPlayerEvent(11) ---@type playerevent 
    EVENT_PLAYER_ALLIANCE_CHANGED                      = ConvertPlayerEvent(12) ---@type playerevent 

    EVENT_PLAYER_DEFEAT                                = ConvertPlayerEvent(13) ---@type playerevent 
    EVENT_PLAYER_VICTORY                               = ConvertPlayerEvent(14) ---@type playerevent 
    EVENT_PLAYER_LEAVE                                 = ConvertPlayerEvent(15) ---@type playerevent 
    EVENT_PLAYER_CHAT                                  = ConvertPlayerEvent(16) ---@type playerevent 
    EVENT_PLAYER_END_CINEMATIC                         = ConvertPlayerEvent(17) ---@type playerevent 

    --===================================================
    -- For use with TriggerRegisterPlayerUnitEvent
    --===================================================

    EVENT_PLAYER_UNIT_ATTACKED                                 = ConvertPlayerUnitEvent(18) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_RESCUED                                  = ConvertPlayerUnitEvent(19) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_DEATH                                    = ConvertPlayerUnitEvent(20) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_DECAY                                    = ConvertPlayerUnitEvent(21) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_DETECTED                                 = ConvertPlayerUnitEvent(22) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_HIDDEN                                   = ConvertPlayerUnitEvent(23) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_SELECTED                                 = ConvertPlayerUnitEvent(24) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_DESELECTED                               = ConvertPlayerUnitEvent(25) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_CONSTRUCT_START                          = ConvertPlayerUnitEvent(26) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL                         = ConvertPlayerUnitEvent(27) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_CONSTRUCT_FINISH                         = ConvertPlayerUnitEvent(28) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_UPGRADE_START                            = ConvertPlayerUnitEvent(29) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_UPGRADE_CANCEL                           = ConvertPlayerUnitEvent(30) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_UPGRADE_FINISH                           = ConvertPlayerUnitEvent(31) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_TRAIN_START                              = ConvertPlayerUnitEvent(32) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_TRAIN_CANCEL                             = ConvertPlayerUnitEvent(33) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_TRAIN_FINISH                             = ConvertPlayerUnitEvent(34) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_RESEARCH_START                           = ConvertPlayerUnitEvent(35) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_RESEARCH_CANCEL                          = ConvertPlayerUnitEvent(36) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_RESEARCH_FINISH                          = ConvertPlayerUnitEvent(37) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_ISSUED_ORDER                             = ConvertPlayerUnitEvent(38) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER                       = ConvertPlayerUnitEvent(39) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER                      = ConvertPlayerUnitEvent(40) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER                        = ConvertPlayerUnitEvent(40)     ---@type playerunitevent -- for compat

    EVENT_PLAYER_HERO_LEVEL                                    = ConvertPlayerUnitEvent(41) ---@type playerunitevent 
    EVENT_PLAYER_HERO_SKILL                                    = ConvertPlayerUnitEvent(42) ---@type playerunitevent 

    EVENT_PLAYER_HERO_REVIVABLE                                = ConvertPlayerUnitEvent(43) ---@type playerunitevent 

    EVENT_PLAYER_HERO_REVIVE_START                             = ConvertPlayerUnitEvent(44) ---@type playerunitevent 
    EVENT_PLAYER_HERO_REVIVE_CANCEL                            = ConvertPlayerUnitEvent(45) ---@type playerunitevent 
    EVENT_PLAYER_HERO_REVIVE_FINISH                            = ConvertPlayerUnitEvent(46) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SUMMON                                   = ConvertPlayerUnitEvent(47) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_DROP_ITEM                                = ConvertPlayerUnitEvent(48) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_PICKUP_ITEM                              = ConvertPlayerUnitEvent(49) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_USE_ITEM                                 = ConvertPlayerUnitEvent(50) ---@type playerunitevent 

    EVENT_PLAYER_UNIT_LOADED                                   = ConvertPlayerUnitEvent(51) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_DAMAGED                                  = ConvertPlayerUnitEvent(308) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_DAMAGING                                 = ConvertPlayerUnitEvent(315) ---@type playerunitevent 

    --===================================================
    -- For use with TriggerRegisterUnitEvent
    --===================================================

    EVENT_UNIT_DAMAGED                                         = ConvertUnitEvent(52) ---@type unitevent 
    EVENT_UNIT_DAMAGING                                        = ConvertUnitEvent(314) ---@type unitevent 
    EVENT_UNIT_DEATH                                           = ConvertUnitEvent(53) ---@type unitevent 
    EVENT_UNIT_DECAY                                           = ConvertUnitEvent(54) ---@type unitevent 
    EVENT_UNIT_DETECTED                                        = ConvertUnitEvent(55) ---@type unitevent 
    EVENT_UNIT_HIDDEN                                          = ConvertUnitEvent(56) ---@type unitevent 
    EVENT_UNIT_SELECTED                                        = ConvertUnitEvent(57) ---@type unitevent 
    EVENT_UNIT_DESELECTED                                      = ConvertUnitEvent(58) ---@type unitevent 
                                                                        
    EVENT_UNIT_STATE_LIMIT                                     = ConvertUnitEvent(59)                                                                         ---@type unitevent 

    -- Events which may have a filter for the "other unit"              
    --                                                                  
    EVENT_UNIT_ACQUIRED_TARGET                                 = ConvertUnitEvent(60) ---@type unitevent 
    EVENT_UNIT_TARGET_IN_RANGE                                 = ConvertUnitEvent(61) ---@type unitevent 
    EVENT_UNIT_ATTACKED                                        = ConvertUnitEvent(62) ---@type unitevent 
    EVENT_UNIT_RESCUED                                         = ConvertUnitEvent(63) ---@type unitevent 
                                                                        
    EVENT_UNIT_CONSTRUCT_CANCEL                                = ConvertUnitEvent(64) ---@type unitevent 
    EVENT_UNIT_CONSTRUCT_FINISH                                = ConvertUnitEvent(65) ---@type unitevent 
                                                                        
    EVENT_UNIT_UPGRADE_START                                   = ConvertUnitEvent(66) ---@type unitevent 
    EVENT_UNIT_UPGRADE_CANCEL                                  = ConvertUnitEvent(67) ---@type unitevent 
    EVENT_UNIT_UPGRADE_FINISH                                  = ConvertUnitEvent(68) ---@type unitevent 
                                                                        
    -- Events which involve the specified unit performing               
    -- training of other units                                          
    --                                                                  
    EVENT_UNIT_TRAIN_START                                     = ConvertUnitEvent(69) ---@type unitevent 
    EVENT_UNIT_TRAIN_CANCEL                                    = ConvertUnitEvent(70) ---@type unitevent 
    EVENT_UNIT_TRAIN_FINISH                                    = ConvertUnitEvent(71) ---@type unitevent 
                                                                        
    EVENT_UNIT_RESEARCH_START                                  = ConvertUnitEvent(72) ---@type unitevent 
    EVENT_UNIT_RESEARCH_CANCEL                                 = ConvertUnitEvent(73) ---@type unitevent 
    EVENT_UNIT_RESEARCH_FINISH                                 = ConvertUnitEvent(74) ---@type unitevent 
                                                                        
    EVENT_UNIT_ISSUED_ORDER                                    = ConvertUnitEvent(75) ---@type unitevent 
    EVENT_UNIT_ISSUED_POINT_ORDER                              = ConvertUnitEvent(76) ---@type unitevent 
    EVENT_UNIT_ISSUED_TARGET_ORDER                             = ConvertUnitEvent(77) ---@type unitevent 
                                                                       
    EVENT_UNIT_HERO_LEVEL                                      = ConvertUnitEvent(78) ---@type unitevent 
    EVENT_UNIT_HERO_SKILL                                      = ConvertUnitEvent(79) ---@type unitevent 
                                                                        
    EVENT_UNIT_HERO_REVIVABLE                                  = ConvertUnitEvent(80) ---@type unitevent 
    EVENT_UNIT_HERO_REVIVE_START                               = ConvertUnitEvent(81) ---@type unitevent 
    EVENT_UNIT_HERO_REVIVE_CANCEL                              = ConvertUnitEvent(82) ---@type unitevent 
    EVENT_UNIT_HERO_REVIVE_FINISH                              = ConvertUnitEvent(83) ---@type unitevent 
                                                                        
    EVENT_UNIT_SUMMON                                          = ConvertUnitEvent(84) ---@type unitevent 
                                                                        
    EVENT_UNIT_DROP_ITEM                                       = ConvertUnitEvent(85) ---@type unitevent 
    EVENT_UNIT_PICKUP_ITEM                                     = ConvertUnitEvent(86) ---@type unitevent 
    EVENT_UNIT_USE_ITEM                                        = ConvertUnitEvent(87) ---@type unitevent 

    EVENT_UNIT_LOADED                                          = ConvertUnitEvent(88) ---@type unitevent 

    EVENT_WIDGET_DEATH                                         = ConvertWidgetEvent(89) ---@type widgetevent 

    EVENT_DIALOG_BUTTON_CLICK                                  = ConvertDialogEvent(90) ---@type dialogevent 
    EVENT_DIALOG_CLICK                                         = ConvertDialogEvent(91) ---@type dialogevent 

    --===================================================
    -- Frozen Throne Expansion Events
    -- Need to be added here to preserve compat
    --===================================================
   
    --===================================================    
    -- For use with TriggerRegisterGameEvent
    --===================================================

    EVENT_GAME_LOADED                                          = ConvertGameEvent(256) ---@type gameevent 
    EVENT_GAME_TOURNAMENT_FINISH_SOON                          = ConvertGameEvent(257) ---@type gameevent 
    EVENT_GAME_TOURNAMENT_FINISH_NOW                           = ConvertGameEvent(258) ---@type gameevent 
    EVENT_GAME_SAVE                                            = ConvertGameEvent(259) ---@type gameevent 
    EVENT_GAME_CUSTOM_UI_FRAME                                 = ConvertGameEvent(310) ---@type gameevent 

    --===================================================
    -- For use with TriggerRegisterPlayerEvent
    --===================================================

    EVENT_PLAYER_ARROW_LEFT_DOWN                               = ConvertPlayerEvent(261) ---@type playerevent 
    EVENT_PLAYER_ARROW_LEFT_UP                                 = ConvertPlayerEvent(262) ---@type playerevent 
    EVENT_PLAYER_ARROW_RIGHT_DOWN                              = ConvertPlayerEvent(263) ---@type playerevent 
    EVENT_PLAYER_ARROW_RIGHT_UP                                = ConvertPlayerEvent(264) ---@type playerevent 
    EVENT_PLAYER_ARROW_DOWN_DOWN                               = ConvertPlayerEvent(265) ---@type playerevent 
    EVENT_PLAYER_ARROW_DOWN_UP                                 = ConvertPlayerEvent(266) ---@type playerevent 
    EVENT_PLAYER_ARROW_UP_DOWN                                 = ConvertPlayerEvent(267) ---@type playerevent 
    EVENT_PLAYER_ARROW_UP_UP                                   = ConvertPlayerEvent(268) ---@type playerevent 
    EVENT_PLAYER_MOUSE_DOWN                                    = ConvertPlayerEvent(305) ---@type playerevent 
    EVENT_PLAYER_MOUSE_UP                                      = ConvertPlayerEvent(306) ---@type playerevent 
    EVENT_PLAYER_MOUSE_MOVE                                    = ConvertPlayerEvent(307) ---@type playerevent 
    EVENT_PLAYER_SYNC_DATA                                     = ConvertPlayerEvent(309) ---@type playerevent 
    EVENT_PLAYER_KEY                                           = ConvertPlayerEvent(311) ---@type playerevent 
    EVENT_PLAYER_KEY_DOWN                                      = ConvertPlayerEvent(312) ---@type playerevent 
    EVENT_PLAYER_KEY_UP                                        = ConvertPlayerEvent(313) ---@type playerevent 

    --===================================================
    -- For use with TriggerRegisterPlayerUnitEvent
    --===================================================

    EVENT_PLAYER_UNIT_SELL                                     = ConvertPlayerUnitEvent(269) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_CHANGE_OWNER                             = ConvertPlayerUnitEvent(270) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SELL_ITEM                                = ConvertPlayerUnitEvent(271) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SPELL_CHANNEL                            = ConvertPlayerUnitEvent(272) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SPELL_CAST                               = ConvertPlayerUnitEvent(273) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SPELL_EFFECT                             = ConvertPlayerUnitEvent(274) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SPELL_FINISH                             = ConvertPlayerUnitEvent(275) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_SPELL_ENDCAST                            = ConvertPlayerUnitEvent(276) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_PAWN_ITEM                                = ConvertPlayerUnitEvent(277) ---@type playerunitevent 
    EVENT_PLAYER_UNIT_STACK_ITEM                               = ConvertPlayerUnitEvent(319) ---@type playerunitevent 

    --===================================================
    -- For use with TriggerRegisterUnitEvent
    --===================================================

    EVENT_UNIT_SELL                                            = ConvertUnitEvent(286) ---@type unitevent 
    EVENT_UNIT_CHANGE_OWNER                                    = ConvertUnitEvent(287) ---@type unitevent 
    EVENT_UNIT_SELL_ITEM                                       = ConvertUnitEvent(288) ---@type unitevent 
    EVENT_UNIT_SPELL_CHANNEL                                   = ConvertUnitEvent(289) ---@type unitevent 
    EVENT_UNIT_SPELL_CAST                                      = ConvertUnitEvent(290) ---@type unitevent 
    EVENT_UNIT_SPELL_EFFECT                                    = ConvertUnitEvent(291) ---@type unitevent 
    EVENT_UNIT_SPELL_FINISH                                    = ConvertUnitEvent(292) ---@type unitevent 
    EVENT_UNIT_SPELL_ENDCAST                                   = ConvertUnitEvent(293) ---@type unitevent 
    EVENT_UNIT_PAWN_ITEM                                       = ConvertUnitEvent(294) ---@type unitevent 
    EVENT_UNIT_STACK_ITEM                                      = ConvertUnitEvent(318) ---@type unitevent 

    --===================================================
    -- Limit Event API constants
    -- variable, player state, game state, and unit state events
    -- ( do NOT change the order of these... )
    --===================================================
    LESS_THAN                                      = ConvertLimitOp(0) ---@type limitop 
    LESS_THAN_OR_EQUAL                             = ConvertLimitOp(1) ---@type limitop 
    EQUAL                                          = ConvertLimitOp(2) ---@type limitop 
    GREATER_THAN_OR_EQUAL                          = ConvertLimitOp(3) ---@type limitop 
    GREATER_THAN                                   = ConvertLimitOp(4) ---@type limitop 
    NOT_EQUAL                                      = ConvertLimitOp(5) ---@type limitop 

--===================================================
-- Unit Type Constants for use with IsUnitType()
--===================================================

    UNIT_TYPE_HERO                                 = ConvertUnitType(0) ---@type unittype 
    UNIT_TYPE_DEAD                                 = ConvertUnitType(1) ---@type unittype 
    UNIT_TYPE_STRUCTURE                            = ConvertUnitType(2) ---@type unittype 

    UNIT_TYPE_FLYING                               = ConvertUnitType(3) ---@type unittype 
    UNIT_TYPE_GROUND                               = ConvertUnitType(4) ---@type unittype 

    UNIT_TYPE_ATTACKS_FLYING                       = ConvertUnitType(5) ---@type unittype 
    UNIT_TYPE_ATTACKS_GROUND                       = ConvertUnitType(6) ---@type unittype 

    UNIT_TYPE_MELEE_ATTACKER                       = ConvertUnitType(7) ---@type unittype 
    UNIT_TYPE_RANGED_ATTACKER                      = ConvertUnitType(8) ---@type unittype 

    UNIT_TYPE_GIANT                                = ConvertUnitType(9) ---@type unittype 
    UNIT_TYPE_SUMMONED                             = ConvertUnitType(10) ---@type unittype 
    UNIT_TYPE_STUNNED                              = ConvertUnitType(11) ---@type unittype 
    UNIT_TYPE_PLAGUED                              = ConvertUnitType(12) ---@type unittype 
    UNIT_TYPE_SNARED                               = ConvertUnitType(13) ---@type unittype 

    UNIT_TYPE_UNDEAD                               = ConvertUnitType(14) ---@type unittype 
    UNIT_TYPE_MECHANICAL                           = ConvertUnitType(15) ---@type unittype 
    UNIT_TYPE_PEON                                 = ConvertUnitType(16) ---@type unittype 
    UNIT_TYPE_SAPPER                               = ConvertUnitType(17) ---@type unittype 
    UNIT_TYPE_TOWNHALL                             = ConvertUnitType(18) ---@type unittype 
    UNIT_TYPE_ANCIENT                              = ConvertUnitType(19) ---@type unittype 

    UNIT_TYPE_TAUREN                               = ConvertUnitType(20) ---@type unittype 
    UNIT_TYPE_POISONED                             = ConvertUnitType(21) ---@type unittype 
    UNIT_TYPE_POLYMORPHED                          = ConvertUnitType(22) ---@type unittype 
    UNIT_TYPE_SLEEPING                             = ConvertUnitType(23) ---@type unittype 
    UNIT_TYPE_RESISTANT                            = ConvertUnitType(24) ---@type unittype 
    UNIT_TYPE_ETHEREAL                             = ConvertUnitType(25) ---@type unittype 
    UNIT_TYPE_MAGIC_IMMUNE                         = ConvertUnitType(26) ---@type unittype 

--===================================================
-- Unit Type Constants for use with ChooseRandomItemEx()
--===================================================

    ITEM_TYPE_PERMANENT                            = ConvertItemType(0) ---@type itemtype 
    ITEM_TYPE_CHARGED                              = ConvertItemType(1) ---@type itemtype 
    ITEM_TYPE_POWERUP                              = ConvertItemType(2) ---@type itemtype 
    ITEM_TYPE_ARTIFACT                             = ConvertItemType(3) ---@type itemtype 
    ITEM_TYPE_PURCHASABLE                          = ConvertItemType(4) ---@type itemtype 
    ITEM_TYPE_CAMPAIGN                             = ConvertItemType(5) ---@type itemtype 
    ITEM_TYPE_MISCELLANEOUS                        = ConvertItemType(6) ---@type itemtype 
    ITEM_TYPE_UNKNOWN                              = ConvertItemType(7) ---@type itemtype 
    ITEM_TYPE_ANY                                  = ConvertItemType(8) ---@type itemtype 

    -- Deprecated, should use ITEM_TYPE_POWERUP
    ITEM_TYPE_TOME                                 = ConvertItemType(2) ---@type itemtype 

--===================================================
-- Animatable Camera Fields
--===================================================

    CAMERA_FIELD_TARGET_DISTANCE                   = ConvertCameraField(0) ---@type camerafield 
    CAMERA_FIELD_FARZ                              = ConvertCameraField(1) ---@type camerafield 
    CAMERA_FIELD_ANGLE_OF_ATTACK                   = ConvertCameraField(2) ---@type camerafield 
    CAMERA_FIELD_FIELD_OF_VIEW                     = ConvertCameraField(3) ---@type camerafield 
    CAMERA_FIELD_ROLL                              = ConvertCameraField(4) ---@type camerafield 
    CAMERA_FIELD_ROTATION                          = ConvertCameraField(5) ---@type camerafield 
    CAMERA_FIELD_ZOFFSET                           = ConvertCameraField(6) ---@type camerafield 
    CAMERA_FIELD_NEARZ                             = ConvertCameraField(7) ---@type camerafield 
    CAMERA_FIELD_LOCAL_PITCH                       = ConvertCameraField(8) ---@type camerafield 
    CAMERA_FIELD_LOCAL_YAW                         = ConvertCameraField(9) ---@type camerafield 
    CAMERA_FIELD_LOCAL_ROLL                        = ConvertCameraField(10) ---@type camerafield 

    BLEND_MODE_NONE                                = ConvertBlendMode(0) ---@type blendmode 
    BLEND_MODE_DONT_CARE                           = ConvertBlendMode(0) ---@type blendmode 
    BLEND_MODE_KEYALPHA                            = ConvertBlendMode(1) ---@type blendmode 
    BLEND_MODE_BLEND                               = ConvertBlendMode(2) ---@type blendmode 
    BLEND_MODE_ADDITIVE                            = ConvertBlendMode(3) ---@type blendmode 
    BLEND_MODE_MODULATE                            = ConvertBlendMode(4) ---@type blendmode 
    BLEND_MODE_MODULATE_2X                         = ConvertBlendMode(5) ---@type blendmode 

    RARITY_FREQUENT                                = ConvertRarityControl(0) ---@type raritycontrol 
    RARITY_RARE                                    = ConvertRarityControl(1) ---@type raritycontrol 

    TEXMAP_FLAG_NONE                               = ConvertTexMapFlags(0) ---@type texmapflags 
    TEXMAP_FLAG_WRAP_U                             = ConvertTexMapFlags(1) ---@type texmapflags 
    TEXMAP_FLAG_WRAP_V                             = ConvertTexMapFlags(2) ---@type texmapflags 
    TEXMAP_FLAG_WRAP_UV                            = ConvertTexMapFlags(3) ---@type texmapflags 

    FOG_OF_WAR_MASKED                              = ConvertFogState(1) ---@type fogstate 
    FOG_OF_WAR_FOGGED                              = ConvertFogState(2) ---@type fogstate 
    FOG_OF_WAR_VISIBLE                             = ConvertFogState(4) ---@type fogstate 

--===================================================
-- Camera Margin constants for use with GetCameraMargin
--===================================================

    CAMERA_MARGIN_LEFT                             = 0 ---@type integer 
    CAMERA_MARGIN_RIGHT                            = 1 ---@type integer 
    CAMERA_MARGIN_TOP                              = 2 ---@type integer 
    CAMERA_MARGIN_BOTTOM                           = 3 ---@type integer 

--===================================================
-- Effect API constants
--===================================================

    EFFECT_TYPE_EFFECT                             = ConvertEffectType(0) ---@type effecttype 
    EFFECT_TYPE_TARGET                             = ConvertEffectType(1) ---@type effecttype 
    EFFECT_TYPE_CASTER                             = ConvertEffectType(2) ---@type effecttype 
    EFFECT_TYPE_SPECIAL                            = ConvertEffectType(3) ---@type effecttype 
    EFFECT_TYPE_AREA_EFFECT                        = ConvertEffectType(4) ---@type effecttype 
    EFFECT_TYPE_MISSILE                            = ConvertEffectType(5) ---@type effecttype 
    EFFECT_TYPE_LIGHTNING                          = ConvertEffectType(6) ---@type effecttype 

    SOUND_TYPE_EFFECT                              = ConvertSoundType(0) ---@type soundtype 
    SOUND_TYPE_EFFECT_LOOPED                       = ConvertSoundType(1) ---@type soundtype 

--===================================================
-- Custom UI API constants
--===================================================

    ORIGIN_FRAME_GAME_UI                                           = ConvertOriginFrameType(0) ---@type originframetype 
    ORIGIN_FRAME_COMMAND_BUTTON                                    = ConvertOriginFrameType(1) ---@type originframetype 
    ORIGIN_FRAME_HERO_BAR                                          = ConvertOriginFrameType(2) ---@type originframetype 
    ORIGIN_FRAME_HERO_BUTTON                                       = ConvertOriginFrameType(3) ---@type originframetype 
    ORIGIN_FRAME_HERO_HP_BAR                                       = ConvertOriginFrameType(4) ---@type originframetype 
    ORIGIN_FRAME_HERO_MANA_BAR                                     = ConvertOriginFrameType(5) ---@type originframetype 
    ORIGIN_FRAME_HERO_BUTTON_INDICATOR                             = ConvertOriginFrameType(6) ---@type originframetype 
    ORIGIN_FRAME_ITEM_BUTTON                                       = ConvertOriginFrameType(7) ---@type originframetype 
    ORIGIN_FRAME_MINIMAP                                           = ConvertOriginFrameType(8) ---@type originframetype 
    ORIGIN_FRAME_MINIMAP_BUTTON                                    = ConvertOriginFrameType(9) ---@type originframetype 
    ORIGIN_FRAME_SYSTEM_BUTTON                                     = ConvertOriginFrameType(10) ---@type originframetype 
    ORIGIN_FRAME_TOOLTIP                                           = ConvertOriginFrameType(11) ---@type originframetype 
    ORIGIN_FRAME_UBERTOOLTIP                                       = ConvertOriginFrameType(12) ---@type originframetype 
    ORIGIN_FRAME_CHAT_MSG                                          = ConvertOriginFrameType(13) ---@type originframetype 
    ORIGIN_FRAME_UNIT_MSG                                          = ConvertOriginFrameType(14) ---@type originframetype 
    ORIGIN_FRAME_TOP_MSG                                           = ConvertOriginFrameType(15) ---@type originframetype 
    ORIGIN_FRAME_PORTRAIT                                          = ConvertOriginFrameType(16) ---@type originframetype 
    ORIGIN_FRAME_WORLD_FRAME                                       = ConvertOriginFrameType(17) ---@type originframetype 
    ORIGIN_FRAME_SIMPLE_UI_PARENT                                  = ConvertOriginFrameType(18) ---@type originframetype 
    ORIGIN_FRAME_PORTRAIT_HP_TEXT                                  = ConvertOriginFrameType(19) ---@type originframetype 
    ORIGIN_FRAME_PORTRAIT_MANA_TEXT                                = ConvertOriginFrameType(20) ---@type originframetype 
    ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR                               = ConvertOriginFrameType(21) ---@type originframetype 
    ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL                         = ConvertOriginFrameType(22) ---@type originframetype 

    FRAMEPOINT_TOPLEFT                                          = ConvertFramePointType(0) ---@type framepointtype 
    FRAMEPOINT_TOP                                              = ConvertFramePointType(1) ---@type framepointtype 
    FRAMEPOINT_TOPRIGHT                                         = ConvertFramePointType(2) ---@type framepointtype 
    FRAMEPOINT_LEFT                                             = ConvertFramePointType(3) ---@type framepointtype 
    FRAMEPOINT_CENTER                                           = ConvertFramePointType(4) ---@type framepointtype 
    FRAMEPOINT_RIGHT                                            = ConvertFramePointType(5) ---@type framepointtype 
    FRAMEPOINT_BOTTOMLEFT                                       = ConvertFramePointType(6) ---@type framepointtype 
    FRAMEPOINT_BOTTOM                                           = ConvertFramePointType(7) ---@type framepointtype 
    FRAMEPOINT_BOTTOMRIGHT                                      = ConvertFramePointType(8) ---@type framepointtype 

    TEXT_JUSTIFY_TOP                                            = ConvertTextAlignType(0) ---@type textaligntype 
    TEXT_JUSTIFY_MIDDLE                                         = ConvertTextAlignType(1) ---@type textaligntype 
    TEXT_JUSTIFY_BOTTOM                                         = ConvertTextAlignType(2) ---@type textaligntype 
    TEXT_JUSTIFY_LEFT                                           = ConvertTextAlignType(3) ---@type textaligntype 
    TEXT_JUSTIFY_CENTER                                         = ConvertTextAlignType(4) ---@type textaligntype 
    TEXT_JUSTIFY_RIGHT                                          = ConvertTextAlignType(5) ---@type textaligntype 

    FRAMEEVENT_CONTROL_CLICK                                    = ConvertFrameEventType(1) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_ENTER                                      = ConvertFrameEventType(2) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_LEAVE                                      = ConvertFrameEventType(3) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_UP                                         = ConvertFrameEventType(4) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_DOWN                                       = ConvertFrameEventType(5) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_WHEEL                                      = ConvertFrameEventType(6) ---@type frameeventtype 
    FRAMEEVENT_CHECKBOX_CHECKED                                 = ConvertFrameEventType(7) ---@type frameeventtype 
    FRAMEEVENT_CHECKBOX_UNCHECKED                               = ConvertFrameEventType(8) ---@type frameeventtype 
    FRAMEEVENT_EDITBOX_TEXT_CHANGED                             = ConvertFrameEventType(9) ---@type frameeventtype 
    FRAMEEVENT_POPUPMENU_ITEM_CHANGED                           = ConvertFrameEventType(10) ---@type frameeventtype 
    FRAMEEVENT_MOUSE_DOUBLECLICK                                = ConvertFrameEventType(11) ---@type frameeventtype 
    FRAMEEVENT_SPRITE_ANIM_UPDATE                               = ConvertFrameEventType(12) ---@type frameeventtype 
    FRAMEEVENT_SLIDER_VALUE_CHANGED                             = ConvertFrameEventType(13) ---@type frameeventtype 
    FRAMEEVENT_DIALOG_CANCEL                                    = ConvertFrameEventType(14) ---@type frameeventtype 
    FRAMEEVENT_DIALOG_ACCEPT                                    = ConvertFrameEventType(15) ---@type frameeventtype 
    FRAMEEVENT_EDITBOX_ENTER                                    = ConvertFrameEventType(16) ---@type frameeventtype 

--===================================================
-- OS Key constants
--===================================================

    OSKEY_BACKSPACE                                             = ConvertOsKeyType(0x08) ---@type oskeytype 
    OSKEY_TAB                                                   = ConvertOsKeyType(0x09) ---@type oskeytype 
    OSKEY_CLEAR                                                 = ConvertOsKeyType(0x0C) ---@type oskeytype 
    OSKEY_RETURN                                                = ConvertOsKeyType(0x0D) ---@type oskeytype 
    OSKEY_SHIFT                                                 = ConvertOsKeyType(0x10) ---@type oskeytype 
    OSKEY_CONTROL                                               = ConvertOsKeyType(0x11) ---@type oskeytype 
    OSKEY_ALT                                                   = ConvertOsKeyType(0x12) ---@type oskeytype 
    OSKEY_PAUSE                                                 = ConvertOsKeyType(0x13) ---@type oskeytype 
    OSKEY_CAPSLOCK                                              = ConvertOsKeyType(0x14) ---@type oskeytype 
    OSKEY_KANA                                                  = ConvertOsKeyType(0x15) ---@type oskeytype 
    OSKEY_HANGUL                                                = ConvertOsKeyType(0x15) ---@type oskeytype 
    OSKEY_JUNJA                                                 = ConvertOsKeyType(0x17) ---@type oskeytype 
    OSKEY_FINAL                                                 = ConvertOsKeyType(0x18) ---@type oskeytype 
    OSKEY_HANJA                                                 = ConvertOsKeyType(0x19) ---@type oskeytype 
    OSKEY_KANJI                                                 = ConvertOsKeyType(0x19) ---@type oskeytype 
    OSKEY_ESCAPE                                                = ConvertOsKeyType(0x1B) ---@type oskeytype 
    OSKEY_CONVERT                                               = ConvertOsKeyType(0x1C) ---@type oskeytype 
    OSKEY_NONCONVERT                                            = ConvertOsKeyType(0x1D) ---@type oskeytype 
    OSKEY_ACCEPT                                                = ConvertOsKeyType(0x1E) ---@type oskeytype 
    OSKEY_MODECHANGE                                            = ConvertOsKeyType(0x1F) ---@type oskeytype 
    OSKEY_SPACE                                                 = ConvertOsKeyType(0x20) ---@type oskeytype 
    OSKEY_PAGEUP                                                = ConvertOsKeyType(0x21) ---@type oskeytype 
    OSKEY_PAGEDOWN                                              = ConvertOsKeyType(0x22) ---@type oskeytype 
    OSKEY_END                                                   = ConvertOsKeyType(0x23) ---@type oskeytype 
    OSKEY_HOME                                                  = ConvertOsKeyType(0x24) ---@type oskeytype 
    OSKEY_LEFT                                                  = ConvertOsKeyType(0x25) ---@type oskeytype 
    OSKEY_UP                                                    = ConvertOsKeyType(0x26) ---@type oskeytype 
    OSKEY_RIGHT                                                 = ConvertOsKeyType(0x27) ---@type oskeytype 
    OSKEY_DOWN                                                  = ConvertOsKeyType(0x28) ---@type oskeytype 
    OSKEY_SELECT                                                = ConvertOsKeyType(0x29) ---@type oskeytype 
    OSKEY_PRINT                                                 = ConvertOsKeyType(0x2A) ---@type oskeytype 
    OSKEY_EXECUTE                                               = ConvertOsKeyType(0x2B) ---@type oskeytype 
    OSKEY_PRINTSCREEN                                           = ConvertOsKeyType(0x2C) ---@type oskeytype 
    OSKEY_INSERT                                                = ConvertOsKeyType(0x2D) ---@type oskeytype 
    OSKEY_DELETE                                                = ConvertOsKeyType(0x2E) ---@type oskeytype 
    OSKEY_HELP                                                  = ConvertOsKeyType(0x2F) ---@type oskeytype 
    OSKEY_0                                                     = ConvertOsKeyType(0x30) ---@type oskeytype 
    OSKEY_1                                                     = ConvertOsKeyType(0x31) ---@type oskeytype 
    OSKEY_2                                                     = ConvertOsKeyType(0x32) ---@type oskeytype 
    OSKEY_3                                                     = ConvertOsKeyType(0x33) ---@type oskeytype 
    OSKEY_4                                                     = ConvertOsKeyType(0x34) ---@type oskeytype 
    OSKEY_5                                                     = ConvertOsKeyType(0x35) ---@type oskeytype 
    OSKEY_6                                                     = ConvertOsKeyType(0x36) ---@type oskeytype 
    OSKEY_7                                                     = ConvertOsKeyType(0x37) ---@type oskeytype 
    OSKEY_8                                                     = ConvertOsKeyType(0x38) ---@type oskeytype 
    OSKEY_9                                                     = ConvertOsKeyType(0x39) ---@type oskeytype 
    OSKEY_A                                                     = ConvertOsKeyType(0x41) ---@type oskeytype 
    OSKEY_B                                                     = ConvertOsKeyType(0x42) ---@type oskeytype 
    OSKEY_C                                                     = ConvertOsKeyType(0x43) ---@type oskeytype 
    OSKEY_D                                                     = ConvertOsKeyType(0x44) ---@type oskeytype 
    OSKEY_E                                                     = ConvertOsKeyType(0x45) ---@type oskeytype 
    OSKEY_F                                                     = ConvertOsKeyType(0x46) ---@type oskeytype 
    OSKEY_G                                                     = ConvertOsKeyType(0x47) ---@type oskeytype 
    OSKEY_H                                                     = ConvertOsKeyType(0x48) ---@type oskeytype 
    OSKEY_I                                                     = ConvertOsKeyType(0x49) ---@type oskeytype 
    OSKEY_J                                                     = ConvertOsKeyType(0x4A) ---@type oskeytype 
    OSKEY_K                                                     = ConvertOsKeyType(0x4B) ---@type oskeytype 
    OSKEY_L                                                     = ConvertOsKeyType(0x4C) ---@type oskeytype 
    OSKEY_M                                                     = ConvertOsKeyType(0x4D) ---@type oskeytype 
    OSKEY_N                                                     = ConvertOsKeyType(0x4E) ---@type oskeytype 
    OSKEY_O                                                     = ConvertOsKeyType(0x4F) ---@type oskeytype 
    OSKEY_P                                                     = ConvertOsKeyType(0x50) ---@type oskeytype 
    OSKEY_Q                                                     = ConvertOsKeyType(0x51) ---@type oskeytype 
    OSKEY_R                                                     = ConvertOsKeyType(0x52) ---@type oskeytype 
    OSKEY_S                                                     = ConvertOsKeyType(0x53) ---@type oskeytype 
    OSKEY_T                                                     = ConvertOsKeyType(0x54) ---@type oskeytype 
    OSKEY_U                                                     = ConvertOsKeyType(0x55) ---@type oskeytype 
    OSKEY_V                                                     = ConvertOsKeyType(0x56) ---@type oskeytype 
    OSKEY_W                                                     = ConvertOsKeyType(0x57) ---@type oskeytype 
    OSKEY_X                                                     = ConvertOsKeyType(0x58) ---@type oskeytype 
    OSKEY_Y                                                     = ConvertOsKeyType(0x59) ---@type oskeytype 
    OSKEY_Z                                                     = ConvertOsKeyType(0x5A) ---@type oskeytype 
    OSKEY_LMETA                                                 = ConvertOsKeyType(0x5B) ---@type oskeytype 
    OSKEY_RMETA                                                 = ConvertOsKeyType(0x5C) ---@type oskeytype 
    OSKEY_APPS                                                  = ConvertOsKeyType(0x5D) ---@type oskeytype 
    OSKEY_SLEEP                                                 = ConvertOsKeyType(0x5F) ---@type oskeytype 
    OSKEY_NUMPAD0                                               = ConvertOsKeyType(0x60) ---@type oskeytype 
    OSKEY_NUMPAD1                                               = ConvertOsKeyType(0x61) ---@type oskeytype 
    OSKEY_NUMPAD2                                               = ConvertOsKeyType(0x62) ---@type oskeytype 
    OSKEY_NUMPAD3                                               = ConvertOsKeyType(0x63) ---@type oskeytype 
    OSKEY_NUMPAD4                                               = ConvertOsKeyType(0x64) ---@type oskeytype 
    OSKEY_NUMPAD5                                               = ConvertOsKeyType(0x65) ---@type oskeytype 
    OSKEY_NUMPAD6                                               = ConvertOsKeyType(0x66) ---@type oskeytype 
    OSKEY_NUMPAD7                                               = ConvertOsKeyType(0x67) ---@type oskeytype 
    OSKEY_NUMPAD8                                               = ConvertOsKeyType(0x68) ---@type oskeytype 
    OSKEY_NUMPAD9                                               = ConvertOsKeyType(0x69) ---@type oskeytype 
    OSKEY_MULTIPLY                                              = ConvertOsKeyType(0x6A) ---@type oskeytype 
    OSKEY_ADD                                                   = ConvertOsKeyType(0x6B) ---@type oskeytype 
    OSKEY_SEPARATOR                                             = ConvertOsKeyType(0x6C) ---@type oskeytype 
    OSKEY_SUBTRACT                                              = ConvertOsKeyType(0x6D) ---@type oskeytype 
    OSKEY_DECIMAL                                               = ConvertOsKeyType(0x6E) ---@type oskeytype 
    OSKEY_DIVIDE                                                = ConvertOsKeyType(0x6F) ---@type oskeytype 
    OSKEY_F1                                                    = ConvertOsKeyType(0x70) ---@type oskeytype 
    OSKEY_F2                                                    = ConvertOsKeyType(0x71) ---@type oskeytype 
    OSKEY_F3                                                    = ConvertOsKeyType(0x72) ---@type oskeytype 
    OSKEY_F4                                                    = ConvertOsKeyType(0x73) ---@type oskeytype 
    OSKEY_F5                                                    = ConvertOsKeyType(0x74) ---@type oskeytype 
    OSKEY_F6                                                    = ConvertOsKeyType(0x75) ---@type oskeytype 
    OSKEY_F7                                                    = ConvertOsKeyType(0x76) ---@type oskeytype 
    OSKEY_F8                                                    = ConvertOsKeyType(0x77) ---@type oskeytype 
    OSKEY_F9                                                    = ConvertOsKeyType(0x78) ---@type oskeytype 
    OSKEY_F10                                                   = ConvertOsKeyType(0x79) ---@type oskeytype 
    OSKEY_F11                                                   = ConvertOsKeyType(0x7A) ---@type oskeytype 
    OSKEY_F12                                                   = ConvertOsKeyType(0x7B) ---@type oskeytype 
    OSKEY_F13                                                   = ConvertOsKeyType(0x7C) ---@type oskeytype 
    OSKEY_F14                                                   = ConvertOsKeyType(0x7D) ---@type oskeytype 
    OSKEY_F15                                                   = ConvertOsKeyType(0x7E) ---@type oskeytype 
    OSKEY_F16                                                   = ConvertOsKeyType(0x7F) ---@type oskeytype 
    OSKEY_F17                                                   = ConvertOsKeyType(0x80) ---@type oskeytype 
    OSKEY_F18                                                   = ConvertOsKeyType(0x81) ---@type oskeytype 
    OSKEY_F19                                                   = ConvertOsKeyType(0x82) ---@type oskeytype 
    OSKEY_F20                                                   = ConvertOsKeyType(0x83) ---@type oskeytype 
    OSKEY_F21                                                   = ConvertOsKeyType(0x84) ---@type oskeytype 
    OSKEY_F22                                                   = ConvertOsKeyType(0x85) ---@type oskeytype 
    OSKEY_F23                                                   = ConvertOsKeyType(0x86) ---@type oskeytype 
    OSKEY_F24                                                   = ConvertOsKeyType(0x87) ---@type oskeytype 
    OSKEY_NUMLOCK                                               = ConvertOsKeyType(0x90) ---@type oskeytype 
    OSKEY_SCROLLLOCK                                            = ConvertOsKeyType(0x91) ---@type oskeytype 
    OSKEY_OEM_NEC_EQUAL                                         = ConvertOsKeyType(0x92) ---@type oskeytype 
    OSKEY_OEM_FJ_JISHO                                          = ConvertOsKeyType(0x92) ---@type oskeytype 
    OSKEY_OEM_FJ_MASSHOU                                        = ConvertOsKeyType(0x93) ---@type oskeytype 
    OSKEY_OEM_FJ_TOUROKU                                        = ConvertOsKeyType(0x94) ---@type oskeytype 
    OSKEY_OEM_FJ_LOYA                                           = ConvertOsKeyType(0x95) ---@type oskeytype 
    OSKEY_OEM_FJ_ROYA                                           = ConvertOsKeyType(0x96) ---@type oskeytype 
    OSKEY_LSHIFT                                                = ConvertOsKeyType(0xA0) ---@type oskeytype 
    OSKEY_RSHIFT                                                = ConvertOsKeyType(0xA1) ---@type oskeytype 
    OSKEY_LCONTROL                                              = ConvertOsKeyType(0xA2) ---@type oskeytype 
    OSKEY_RCONTROL                                              = ConvertOsKeyType(0xA3) ---@type oskeytype 
    OSKEY_LALT                                                  = ConvertOsKeyType(0xA4) ---@type oskeytype 
    OSKEY_RALT                                                  = ConvertOsKeyType(0xA5) ---@type oskeytype 
    OSKEY_BROWSER_BACK                                          = ConvertOsKeyType(0xA6) ---@type oskeytype 
    OSKEY_BROWSER_FORWARD                                       = ConvertOsKeyType(0xA7) ---@type oskeytype 
    OSKEY_BROWSER_REFRESH                                       = ConvertOsKeyType(0xA8) ---@type oskeytype 
    OSKEY_BROWSER_STOP                                          = ConvertOsKeyType(0xA9) ---@type oskeytype 
    OSKEY_BROWSER_SEARCH                                        = ConvertOsKeyType(0xAA) ---@type oskeytype 
    OSKEY_BROWSER_FAVORITES                                     = ConvertOsKeyType(0xAB) ---@type oskeytype 
    OSKEY_BROWSER_HOME                                          = ConvertOsKeyType(0xAC) ---@type oskeytype 
    OSKEY_VOLUME_MUTE                                           = ConvertOsKeyType(0xAD) ---@type oskeytype 
    OSKEY_VOLUME_DOWN                                           = ConvertOsKeyType(0xAE) ---@type oskeytype 
    OSKEY_VOLUME_UP                                             = ConvertOsKeyType(0xAF) ---@type oskeytype 
    OSKEY_MEDIA_NEXT_TRACK                                      = ConvertOsKeyType(0xB0) ---@type oskeytype 
    OSKEY_MEDIA_PREV_TRACK                                      = ConvertOsKeyType(0xB1) ---@type oskeytype 
    OSKEY_MEDIA_STOP                                            = ConvertOsKeyType(0xB2) ---@type oskeytype 
    OSKEY_MEDIA_PLAY_PAUSE                                      = ConvertOsKeyType(0xB3) ---@type oskeytype 
    OSKEY_LAUNCH_MAIL                                           = ConvertOsKeyType(0xB4) ---@type oskeytype 
    OSKEY_LAUNCH_MEDIA_SELECT                                   = ConvertOsKeyType(0xB5) ---@type oskeytype 
    OSKEY_LAUNCH_APP1                                           = ConvertOsKeyType(0xB6) ---@type oskeytype 
    OSKEY_LAUNCH_APP2                                           = ConvertOsKeyType(0xB7) ---@type oskeytype 
    OSKEY_OEM_1                                                 = ConvertOsKeyType(0xBA) ---@type oskeytype 
    OSKEY_OEM_PLUS                                              = ConvertOsKeyType(0xBB) ---@type oskeytype 
    OSKEY_OEM_COMMA                                             = ConvertOsKeyType(0xBC) ---@type oskeytype 
    OSKEY_OEM_MINUS                                             = ConvertOsKeyType(0xBD) ---@type oskeytype 
    OSKEY_OEM_PERIOD                                            = ConvertOsKeyType(0xBE) ---@type oskeytype 
    OSKEY_OEM_2                                                 = ConvertOsKeyType(0xBF) ---@type oskeytype 
    OSKEY_OEM_3                                                 = ConvertOsKeyType(0xC0) ---@type oskeytype 
    OSKEY_OEM_4                                                 = ConvertOsKeyType(0xDB) ---@type oskeytype 
    OSKEY_OEM_5                                                 = ConvertOsKeyType(0xDC) ---@type oskeytype 
    OSKEY_OEM_6                                                 = ConvertOsKeyType(0xDD) ---@type oskeytype 
    OSKEY_OEM_7                                                 = ConvertOsKeyType(0xDE) ---@type oskeytype 
    OSKEY_OEM_8                                                 = ConvertOsKeyType(0xDF) ---@type oskeytype 
    OSKEY_OEM_AX                                                = ConvertOsKeyType(0xE1) ---@type oskeytype 
    OSKEY_OEM_102                                               = ConvertOsKeyType(0xE2) ---@type oskeytype 
    OSKEY_ICO_HELP                                              = ConvertOsKeyType(0xE3) ---@type oskeytype 
    OSKEY_ICO_00                                                = ConvertOsKeyType(0xE4) ---@type oskeytype 
    OSKEY_PROCESSKEY                                            = ConvertOsKeyType(0xE5) ---@type oskeytype 
    OSKEY_ICO_CLEAR                                             = ConvertOsKeyType(0xE6) ---@type oskeytype 
    OSKEY_PACKET                                                = ConvertOsKeyType(0xE7) ---@type oskeytype 
    OSKEY_OEM_RESET                                             = ConvertOsKeyType(0xE9) ---@type oskeytype 
    OSKEY_OEM_JUMP                                              = ConvertOsKeyType(0xEA) ---@type oskeytype 
    OSKEY_OEM_PA1                                               = ConvertOsKeyType(0xEB) ---@type oskeytype 
    OSKEY_OEM_PA2                                               = ConvertOsKeyType(0xEC) ---@type oskeytype 
    OSKEY_OEM_PA3                                               = ConvertOsKeyType(0xED) ---@type oskeytype 
    OSKEY_OEM_WSCTRL                                            = ConvertOsKeyType(0xEE) ---@type oskeytype 
    OSKEY_OEM_CUSEL                                             = ConvertOsKeyType(0xEF) ---@type oskeytype 
    OSKEY_OEM_ATTN                                              = ConvertOsKeyType(0xF0) ---@type oskeytype 
    OSKEY_OEM_FINISH                                            = ConvertOsKeyType(0xF1) ---@type oskeytype 
    OSKEY_OEM_COPY                                              = ConvertOsKeyType(0xF2) ---@type oskeytype 
    OSKEY_OEM_AUTO                                              = ConvertOsKeyType(0xF3) ---@type oskeytype 
    OSKEY_OEM_ENLW                                              = ConvertOsKeyType(0xF4) ---@type oskeytype 
    OSKEY_OEM_BACKTAB                                           = ConvertOsKeyType(0xF5) ---@type oskeytype 
    OSKEY_ATTN                                                  = ConvertOsKeyType(0xF6) ---@type oskeytype 
    OSKEY_CRSEL                                                 = ConvertOsKeyType(0xF7) ---@type oskeytype 
    OSKEY_EXSEL                                                 = ConvertOsKeyType(0xF8) ---@type oskeytype 
    OSKEY_EREOF                                                 = ConvertOsKeyType(0xF9) ---@type oskeytype 
    OSKEY_PLAY                                                  = ConvertOsKeyType(0xFA) ---@type oskeytype 
    OSKEY_ZOOM                                                  = ConvertOsKeyType(0xFB) ---@type oskeytype 
    OSKEY_NONAME                                                = ConvertOsKeyType(0xFC) ---@type oskeytype 
    OSKEY_PA1                                                   = ConvertOsKeyType(0xFD) ---@type oskeytype 
    OSKEY_OEM_CLEAR                                             = ConvertOsKeyType(0xFE) ---@type oskeytype 

--===================================================
-- Instanced Object Operation API constants
--===================================================
    
    -- Ability
    ABILITY_IF_BUTTON_POSITION_NORMAL_X                            = ConvertAbilityIntegerField(FourCC('abpx')) ---@type abilityintegerfield 
    ABILITY_IF_BUTTON_POSITION_NORMAL_Y                            = ConvertAbilityIntegerField(FourCC('abpy')) ---@type abilityintegerfield 
    ABILITY_IF_BUTTON_POSITION_ACTIVATED_X                         = ConvertAbilityIntegerField(FourCC('aubx')) ---@type abilityintegerfield 
    ABILITY_IF_BUTTON_POSITION_ACTIVATED_Y                         = ConvertAbilityIntegerField(FourCC('auby')) ---@type abilityintegerfield 
    ABILITY_IF_BUTTON_POSITION_RESEARCH_X                          = ConvertAbilityIntegerField(FourCC('arpx')) ---@type abilityintegerfield 
    ABILITY_IF_BUTTON_POSITION_RESEARCH_Y                          = ConvertAbilityIntegerField(FourCC('arpy')) ---@type abilityintegerfield 
    ABILITY_IF_MISSILE_SPEED                                       = ConvertAbilityIntegerField(FourCC('amsp')) ---@type abilityintegerfield 
    ABILITY_IF_TARGET_ATTACHMENTS                                  = ConvertAbilityIntegerField(FourCC('atac')) ---@type abilityintegerfield 
    ABILITY_IF_CASTER_ATTACHMENTS                                  = ConvertAbilityIntegerField(FourCC('acac')) ---@type abilityintegerfield 
    ABILITY_IF_PRIORITY                                            = ConvertAbilityIntegerField(FourCC('apri')) ---@type abilityintegerfield 
    ABILITY_IF_LEVELS                                              = ConvertAbilityIntegerField(FourCC('alev')) ---@type abilityintegerfield 
    ABILITY_IF_REQUIRED_LEVEL                                      = ConvertAbilityIntegerField(FourCC('arlv')) ---@type abilityintegerfield 
    ABILITY_IF_LEVEL_SKIP_REQUIREMENT                              = ConvertAbilityIntegerField(FourCC('alsk'))  ---@type abilityintegerfield 

    ABILITY_BF_HERO_ABILITY                                        = ConvertAbilityBooleanField(FourCC('aher'))  ---@type abilitybooleanfield -- Get only
    ABILITY_BF_ITEM_ABILITY                                        = ConvertAbilityBooleanField(FourCC('aite')) ---@type abilitybooleanfield 
    ABILITY_BF_CHECK_DEPENDENCIES                                  = ConvertAbilityBooleanField(FourCC('achd')) ---@type abilitybooleanfield 

    ABILITY_RF_ARF_MISSILE_ARC                                     = ConvertAbilityRealField(FourCC('amac')) ---@type abilityrealfield 

    ABILITY_SF_NAME                                                = ConvertAbilityStringField(FourCC('anam'))  ---@type abilitystringfield -- Get Only
    ABILITY_SF_ICON_ACTIVATED                                      = ConvertAbilityStringField(FourCC('auar')) ---@type abilitystringfield 
    ABILITY_SF_ICON_RESEARCH                                       = ConvertAbilityStringField(FourCC('arar')) ---@type abilitystringfield 
    ABILITY_SF_EFFECT_SOUND                                        = ConvertAbilityStringField(FourCC('aefs')) ---@type abilitystringfield 
    ABILITY_SF_EFFECT_SOUND_LOOPING                                = ConvertAbilityStringField(FourCC('aefl')) ---@type abilitystringfield 

    ABILITY_ILF_MANA_COST                                                  = ConvertAbilityIntegerLevelField(FourCC('amcs')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_WAVES                                            = ConvertAbilityIntegerLevelField(FourCC('Hbz1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SHARDS                                           = ConvertAbilityIntegerLevelField(FourCC('Hbz3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_UNITS_TELEPORTED                                 = ConvertAbilityIntegerLevelField(FourCC('Hmt1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_COUNT_HWE2                                   = ConvertAbilityIntegerLevelField(FourCC('Hwe2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_IMAGES                                           = ConvertAbilityIntegerLevelField(FourCC('Omi1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_UAN1                              = ConvertAbilityIntegerLevelField(FourCC('Uan1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MORPHING_FLAGS                                             = ConvertAbilityIntegerLevelField(FourCC('Eme2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STRENGTH_BONUS_NRG5                                        = ConvertAbilityIntegerLevelField(FourCC('Nrg5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DEFENSE_BONUS_NRG6                                         = ConvertAbilityIntegerLevelField(FourCC('Nrg6')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_TARGETS_HIT                                      = ConvertAbilityIntegerLevelField(FourCC('Ocl2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_OFS1                                        = ConvertAbilityIntegerLevelField(FourCC('Ofs1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_OSF2                              = ConvertAbilityIntegerLevelField(FourCC('Osf2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_EFN1                              = ConvertAbilityIntegerLevelField(FourCC('Efn1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_HRE1                              = ConvertAbilityIntegerLevelField(FourCC('Hre1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STACK_FLAGS                                                = ConvertAbilityIntegerLevelField(FourCC('Hca4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MINIMUM_NUMBER_OF_UNITS                                    = ConvertAbilityIntegerLevelField(FourCC('Ndp2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_NDP3                               = ConvertAbilityIntegerLevelField(FourCC('Ndp3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_UNITS_CREATED_NRC2                               = ConvertAbilityIntegerLevelField(FourCC('Nrc2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SHIELD_LIFE                                                = ConvertAbilityIntegerLevelField(FourCC('Ams3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_LOSS_AMS4                                             = ConvertAbilityIntegerLevelField(FourCC('Ams4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_PER_INTERVAL_BGM1                                     = ConvertAbilityIntegerLevelField(FourCC('Bgm1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_NUMBER_OF_MINERS                                       = ConvertAbilityIntegerLevelField(FourCC('Bgm3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_CARGO_CAPACITY                                             = ConvertAbilityIntegerLevelField(FourCC('Car1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_CREEP_LEVEL_DEV3                                   = ConvertAbilityIntegerLevelField(FourCC('Dev3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_CREEP_LEVEL_DEV1                                       = ConvertAbilityIntegerLevelField(FourCC('Dev1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_PER_INTERVAL_EGM1                                     = ConvertAbilityIntegerLevelField(FourCC('Egm1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DEFENSE_REDUCTION                                          = ConvertAbilityIntegerLevelField(FourCC('Fae1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_FLA1                                        = ConvertAbilityIntegerLevelField(FourCC('Fla1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_FLARE_COUNT                                                = ConvertAbilityIntegerLevelField(FourCC('Fla3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_GOLD                                                   = ConvertAbilityIntegerLevelField(FourCC('Gld1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MINING_CAPACITY                                            = ConvertAbilityIntegerLevelField(FourCC('Gld3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_GYD1                             = ConvertAbilityIntegerLevelField(FourCC('Gyd1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DAMAGE_TO_TREE                                             = ConvertAbilityIntegerLevelField(FourCC('Har1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LUMBER_CAPACITY                                            = ConvertAbilityIntegerLevelField(FourCC('Har2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_CAPACITY                                              = ConvertAbilityIntegerLevelField(FourCC('Har3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DEFENSE_INCREASE_INF2                                      = ConvertAbilityIntegerLevelField(FourCC('Inf2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_INTERACTION_TYPE                                           = ConvertAbilityIntegerLevelField(FourCC('Neu2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_COST_NDT1                                             = ConvertAbilityIntegerLevelField(FourCC('Ndt1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LUMBER_COST_NDT2                                           = ConvertAbilityIntegerLevelField(FourCC('Ndt2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_NDT3                                        = ConvertAbilityIntegerLevelField(FourCC('Ndt3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STACKING_TYPE_POI4                                         = ConvertAbilityIntegerLevelField(FourCC('Poi4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STACKING_TYPE_POA5                                         = ConvertAbilityIntegerLevelField(FourCC('Poa5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_CREEP_LEVEL_PLY1                                   = ConvertAbilityIntegerLevelField(FourCC('Ply1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_CREEP_LEVEL_POS1                                   = ConvertAbilityIntegerLevelField(FourCC('Pos1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MOVEMENT_UPDATE_FREQUENCY_PRG1                             = ConvertAbilityIntegerLevelField(FourCC('Prg1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ATTACK_UPDATE_FREQUENCY_PRG2                               = ConvertAbilityIntegerLevelField(FourCC('Prg2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_LOSS_PRG6                                             = ConvertAbilityIntegerLevelField(FourCC('Prg6')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNITS_SUMMONED_TYPE_ONE                                    = ConvertAbilityIntegerLevelField(FourCC('Rai1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNITS_SUMMONED_TYPE_TWO                                    = ConvertAbilityIntegerLevelField(FourCC('Rai2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_UNITS_SUMMONED                                         = ConvertAbilityIntegerLevelField(FourCC('Ucb5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ALLOW_WHEN_FULL_REJ3                                       = ConvertAbilityIntegerLevelField(FourCC('Rej3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_UNITS_CHARGED_TO_CASTER                            = ConvertAbilityIntegerLevelField(FourCC('Rpb5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_UNITS_AFFECTED                                     = ConvertAbilityIntegerLevelField(FourCC('Rpb6')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DEFENSE_INCREASE_ROA2                                      = ConvertAbilityIntegerLevelField(FourCC('Roa2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_UNITS_ROA7                                             = ConvertAbilityIntegerLevelField(FourCC('Roa7')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ROOTED_WEAPONS                                             = ConvertAbilityIntegerLevelField(FourCC('Roo1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UPROOTED_WEAPONS                                           = ConvertAbilityIntegerLevelField(FourCC('Roo2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UPROOTED_DEFENSE_TYPE                                      = ConvertAbilityIntegerLevelField(FourCC('Roo4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ACCUMULATION_STEP                                          = ConvertAbilityIntegerLevelField(FourCC('Sal2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_OWLS                                             = ConvertAbilityIntegerLevelField(FourCC('Esn4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STACKING_TYPE_SPO4                                         = ConvertAbilityIntegerLevelField(FourCC('Spo4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_UNITS                                            = ConvertAbilityIntegerLevelField(FourCC('Sod1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SPIDER_CAPACITY                                            = ConvertAbilityIntegerLevelField(FourCC('Spa1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_INTERVALS_BEFORE_CHANGING_TREES                            = ConvertAbilityIntegerLevelField(FourCC('Wha2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_AGILITY_BONUS                                              = ConvertAbilityIntegerLevelField(FourCC('Iagi')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_INTELLIGENCE_BONUS                                         = ConvertAbilityIntegerLevelField(FourCC('Iint')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_STRENGTH_BONUS_ISTR                                        = ConvertAbilityIntegerLevelField(FourCC('Istr')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ATTACK_BONUS                                               = ConvertAbilityIntegerLevelField(FourCC('Iatt')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DEFENSE_BONUS_IDEF                                         = ConvertAbilityIntegerLevelField(FourCC('Idef')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMON_1_AMOUNT                                            = ConvertAbilityIntegerLevelField(FourCC('Isn1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMON_2_AMOUNT                                            = ConvertAbilityIntegerLevelField(FourCC('Isn2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_EXPERIENCE_GAINED                                          = ConvertAbilityIntegerLevelField(FourCC('Ixpg')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_HIT_POINTS_GAINED_IHPG                                     = ConvertAbilityIntegerLevelField(FourCC('Ihpg')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_POINTS_GAINED_IMPG                                    = ConvertAbilityIntegerLevelField(FourCC('Impg')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_HIT_POINTS_GAINED_IHP2                                     = ConvertAbilityIntegerLevelField(FourCC('Ihp2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_POINTS_GAINED_IMP2                                    = ConvertAbilityIntegerLevelField(FourCC('Imp2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DAMAGE_BONUS_DICE                                          = ConvertAbilityIntegerLevelField(FourCC('Idic')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ARMOR_PENALTY_IARP                                         = ConvertAbilityIntegerLevelField(FourCC('Iarp')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ENABLED_ATTACK_INDEX_IOB5                                  = ConvertAbilityIntegerLevelField(FourCC('Iob5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LEVELS_GAINED                                              = ConvertAbilityIntegerLevelField(FourCC('Ilev')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_LIFE_GAINED                                            = ConvertAbilityIntegerLevelField(FourCC('Ilif')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_MANA_GAINED                                            = ConvertAbilityIntegerLevelField(FourCC('Iman')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_GIVEN                                                 = ConvertAbilityIntegerLevelField(FourCC('Igol')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LUMBER_GIVEN                                               = ConvertAbilityIntegerLevelField(FourCC('Ilum')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_IFA1                                        = ConvertAbilityIntegerLevelField(FourCC('Ifa1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_CREEP_LEVEL_ICRE                                   = ConvertAbilityIntegerLevelField(FourCC('Icre')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MOVEMENT_SPEED_BONUS                                       = ConvertAbilityIntegerLevelField(FourCC('Imvb')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND                          = ConvertAbilityIntegerLevelField(FourCC('Ihpr')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SIGHT_RANGE_BONUS                                          = ConvertAbilityIntegerLevelField(FourCC('Isib')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DAMAGE_PER_DURATION                                        = ConvertAbilityIntegerLevelField(FourCC('Icfd')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_USED_PER_SECOND                                       = ConvertAbilityIntegerLevelField(FourCC('Icfm')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_EXTRA_MANA_REQUIRED                                        = ConvertAbilityIntegerLevelField(FourCC('Icfx')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_RADIUS_IDET                                      = ConvertAbilityIntegerLevelField(FourCC('Idet')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_LOSS_PER_UNIT_IDIM                                    = ConvertAbilityIntegerLevelField(FourCC('Idim')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DAMAGE_TO_SUMMONED_UNITS_IDID                              = ConvertAbilityIntegerLevelField(FourCC('Idid')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_IREC                               = ConvertAbilityIntegerLevelField(FourCC('Irec')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DELAY_AFTER_DEATH_SECONDS                                  = ConvertAbilityIntegerLevelField(FourCC('Ircd')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_RESTORED_LIFE                                              = ConvertAbilityIntegerLevelField(FourCC('irc2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_RESTORED_MANA__1_FOR_CURRENT                               = ConvertAbilityIntegerLevelField(FourCC('irc3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_HIT_POINTS_RESTORED                                        = ConvertAbilityIntegerLevelField(FourCC('Ihps')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MANA_POINTS_RESTORED                                       = ConvertAbilityIntegerLevelField(FourCC('Imps')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_ITPM                               = ConvertAbilityIntegerLevelField(FourCC('Itpm')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_CAD1                              = ConvertAbilityIntegerLevelField(FourCC('Cad1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_TERRAIN_DEFORMATION_DURATION_MS                            = ConvertAbilityIntegerLevelField(FourCC('Wrs3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_UNITS                                              = ConvertAbilityIntegerLevelField(FourCC('Uds1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_DET1                                        = ConvertAbilityIntegerLevelField(FourCC('Det1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GOLD_COST_PER_STRUCTURE                                    = ConvertAbilityIntegerLevelField(FourCC('Nsp1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LUMBER_COST_PER_USE                                        = ConvertAbilityIntegerLevelField(FourCC('Nsp2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DETECTION_TYPE_NSP3                                        = ConvertAbilityIntegerLevelField(FourCC('Nsp3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SWARM_UNITS                                      = ConvertAbilityIntegerLevelField(FourCC('Uls1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_SWARM_UNITS_PER_TARGET                                 = ConvertAbilityIntegerLevelField(FourCC('Uls3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NBA2                              = ConvertAbilityIntegerLevelField(FourCC('Nba2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_CREEP_LEVEL_NCH1                                   = ConvertAbilityIntegerLevelField(FourCC('Nch1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ATTACKS_PREVENTED                                          = ConvertAbilityIntegerLevelField(FourCC('Nsi1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_EFK3                             = ConvertAbilityIntegerLevelField(FourCC('Efk3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_ESV1                              = ConvertAbilityIntegerLevelField(FourCC('Esv1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_EXH1                             = ConvertAbilityIntegerLevelField(FourCC('exh1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ITEM_CAPACITY                                              = ConvertAbilityIntegerLevelField(FourCC('inv1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_SPL2                             = ConvertAbilityIntegerLevelField(FourCC('spl2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ALLOW_WHEN_FULL_IRL3                                       = ConvertAbilityIntegerLevelField(FourCC('irl3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_DISPELLED_UNITS                                    = ConvertAbilityIntegerLevelField(FourCC('idc3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_LURES                                            = ConvertAbilityIntegerLevelField(FourCC('imo1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NEW_TIME_OF_DAY_HOUR                                       = ConvertAbilityIntegerLevelField(FourCC('ict1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NEW_TIME_OF_DAY_MINUTE                                     = ConvertAbilityIntegerLevelField(FourCC('ict2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_UNITS_CREATED_MEC1                               = ConvertAbilityIntegerLevelField(FourCC('mec1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MINIMUM_SPELLS                                             = ConvertAbilityIntegerLevelField(FourCC('spb3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_SPELLS                                             = ConvertAbilityIntegerLevelField(FourCC('spb4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DISABLED_ATTACK_INDEX                                      = ConvertAbilityIntegerLevelField(FourCC('gra3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ENABLED_ATTACK_INDEX_GRA4                                  = ConvertAbilityIntegerLevelField(FourCC('gra4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAXIMUM_ATTACKS                                            = ConvertAbilityIntegerLevelField(FourCC('gra5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_BUILDING_TYPES_ALLOWED_NPR1                                = ConvertAbilityIntegerLevelField(FourCC('Npr1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_BUILDING_TYPES_ALLOWED_NSA1                                = ConvertAbilityIntegerLevelField(FourCC('Nsa1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ATTACK_MODIFICATION                                        = ConvertAbilityIntegerLevelField(FourCC('Iaa1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_COUNT_NPA5                                   = ConvertAbilityIntegerLevelField(FourCC('Npa5')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UPGRADE_LEVELS                                             = ConvertAbilityIntegerLevelField(FourCC('Igl1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NDO2                              = ConvertAbilityIntegerLevelField(FourCC('Ndo2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_BEASTS_PER_SECOND                                          = ConvertAbilityIntegerLevelField(FourCC('Nst1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_TARGET_TYPE                                                = ConvertAbilityIntegerLevelField(FourCC('Ncl2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_OPTIONS                                                    = ConvertAbilityIntegerLevelField(FourCC('Ncl3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ARMOR_PENALTY_NAB3                                         = ConvertAbilityIntegerLevelField(FourCC('Nab3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_WAVE_COUNT_NHS6                                            = ConvertAbilityIntegerLevelField(FourCC('Nhs6')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_CREEP_LEVEL_NTM3                                       = ConvertAbilityIntegerLevelField(FourCC('Ntm3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MISSILE_COUNT                                              = ConvertAbilityIntegerLevelField(FourCC('Ncs3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SPLIT_ATTACK_COUNT                                         = ConvertAbilityIntegerLevelField(FourCC('Nlm3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_GENERATION_COUNT                                           = ConvertAbilityIntegerLevelField(FourCC('Nlm6')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ROCK_RING_COUNT                                            = ConvertAbilityIntegerLevelField(FourCC('Nvc1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_WAVE_COUNT_NVC2                                            = ConvertAbilityIntegerLevelField(FourCC('Nvc2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_PREFER_HOSTILES_TAU1                                       = ConvertAbilityIntegerLevelField(FourCC('Tau1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_PREFER_FRIENDLIES_TAU2                                     = ConvertAbilityIntegerLevelField(FourCC('Tau2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_MAX_UNITS_TAU3                                             = ConvertAbilityIntegerLevelField(FourCC('Tau3')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NUMBER_OF_PULSES                                           = ConvertAbilityIntegerLevelField(FourCC('Tau4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_HWE1                                    = ConvertAbilityIntegerLevelField(FourCC('Hwe1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_UIN4                                         = ConvertAbilityIntegerLevelField(FourCC('Uin4')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_OSF1                                         = ConvertAbilityIntegerLevelField(FourCC('Osf1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_EFNU                                    = ConvertAbilityIntegerLevelField(FourCC('Efnu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_NBAU                                    = ConvertAbilityIntegerLevelField(FourCC('Nbau')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_NTOU                                    = ConvertAbilityIntegerLevelField(FourCC('Ntou')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_ESVU                                    = ConvertAbilityIntegerLevelField(FourCC('Esvu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPES                                        = ConvertAbilityIntegerLevelField(FourCC('Nef1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SUMMONED_UNIT_TYPE_NDOU                                    = ConvertAbilityIntegerLevelField(FourCC('Ndou')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ALTERNATE_FORM_UNIT_EMEU                                   = ConvertAbilityIntegerLevelField(FourCC('Emeu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_PLAGUE_WARD_UNIT_TYPE                                      = ConvertAbilityIntegerLevelField(FourCC('Aplu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ALLOWED_UNIT_TYPE_BTL1                                     = ConvertAbilityIntegerLevelField(FourCC('Btl1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_NEW_UNIT_TYPE                                              = ConvertAbilityIntegerLevelField(FourCC('Cha1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_RESULTING_UNIT_TYPE_ENT1                                   = ConvertAbilityIntegerLevelField(FourCC('ent1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_CORPSE_UNIT_TYPE                                           = ConvertAbilityIntegerLevelField(FourCC('Gydu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_ALLOWED_UNIT_TYPE_LOA1                                     = ConvertAbilityIntegerLevelField(FourCC('Loa1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNIT_TYPE_FOR_LIMIT_CHECK                                  = ConvertAbilityIntegerLevelField(FourCC('Raiu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_WARD_UNIT_TYPE_STAU                                        = ConvertAbilityIntegerLevelField(FourCC('Stau')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_EFFECT_ABILITY                                             = ConvertAbilityIntegerLevelField(FourCC('Iobu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_CONVERSION_UNIT                                            = ConvertAbilityIntegerLevelField(FourCC('Ndc2')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNIT_TO_PRESERVE                                           = ConvertAbilityIntegerLevelField(FourCC('Nsl1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNIT_TYPE_ALLOWED                                          = ConvertAbilityIntegerLevelField(FourCC('Chl1')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SWARM_UNIT_TYPE                                            = ConvertAbilityIntegerLevelField(FourCC('Ulsu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_RESULTING_UNIT_TYPE_COAU                                   = ConvertAbilityIntegerLevelField(FourCC('coau')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNIT_TYPE_EXHU                                             = ConvertAbilityIntegerLevelField(FourCC('exhu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_WARD_UNIT_TYPE_HWDU                                        = ConvertAbilityIntegerLevelField(FourCC('hwdu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_LURE_UNIT_TYPE                                             = ConvertAbilityIntegerLevelField(FourCC('imou')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UNIT_TYPE_IPMU                                             = ConvertAbilityIntegerLevelField(FourCC('ipmu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_FACTORY_UNIT_ID                                            = ConvertAbilityIntegerLevelField(FourCC('Nsyu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_SPAWN_UNIT_ID_NFYU                                         = ConvertAbilityIntegerLevelField(FourCC('Nfyu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_DESTRUCTIBLE_ID                                            = ConvertAbilityIntegerLevelField(FourCC('Nvcu')) ---@type abilityintegerlevelfield 
    ABILITY_ILF_UPGRADE_TYPE                                               = ConvertAbilityIntegerLevelField(FourCC('Iglu')) ---@type abilityintegerlevelfield 

    ABILITY_RLF_CASTING_TIME                                                            = ConvertAbilityRealLevelField(FourCC('acas')) ---@type abilityreallevelfield 
    ABILITY_RLF_DURATION_NORMAL                                                         = ConvertAbilityRealLevelField(FourCC('adur')) ---@type abilityreallevelfield 
    ABILITY_RLF_DURATION_HERO                                                           = ConvertAbilityRealLevelField(FourCC('ahdu')) ---@type abilityreallevelfield 
    ABILITY_RLF_COOLDOWN                                                                = ConvertAbilityRealLevelField(FourCC('acdn')) ---@type abilityreallevelfield 
    ABILITY_RLF_AREA_OF_EFFECT                                                          = ConvertAbilityRealLevelField(FourCC('aare')) ---@type abilityreallevelfield 
    ABILITY_RLF_CAST_RANGE                                                              = ConvertAbilityRealLevelField(FourCC('aran')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_HBZ2                                                             = ConvertAbilityRealLevelField(FourCC('Hbz2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_REDUCTION_HBZ4                                                 = ConvertAbilityRealLevelField(FourCC('Hbz4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_HBZ5                                                  = ConvertAbilityRealLevelField(FourCC('Hbz5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_DAMAGE_PER_WAVE                                                 = ConvertAbilityRealLevelField(FourCC('Hbz6')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_REGENERATION_INCREASE                                              = ConvertAbilityRealLevelField(FourCC('Hab1')) ---@type abilityreallevelfield 
    ABILITY_RLF_CASTING_DELAY                                                           = ConvertAbilityRealLevelField(FourCC('Hmt2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_OWW1                                                  = ConvertAbilityRealLevelField(FourCC('Oww1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_OWW2                                             = ConvertAbilityRealLevelField(FourCC('Oww2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE                                               = ConvertAbilityRealLevelField(FourCC('Ocr1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2                                                  = ConvertAbilityRealLevelField(FourCC('Ocr2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_OCR3                                                       = ConvertAbilityRealLevelField(FourCC('Ocr3')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_EVADE_OCR4                                                    = ConvertAbilityRealLevelField(FourCC('Ocr4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_PERCENT_OMI2                                               = ConvertAbilityRealLevelField(FourCC('Omi2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_TAKEN_PERCENT_OMI3                                               = ConvertAbilityRealLevelField(FourCC('Omi3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ANIMATION_DELAY                                                         = ConvertAbilityRealLevelField(FourCC('Omi4')) ---@type abilityreallevelfield 
    ABILITY_RLF_TRANSITION_TIME                                                         = ConvertAbilityRealLevelField(FourCC('Owk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OWK2                                    = ConvertAbilityRealLevelField(FourCC('Owk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BACKSTAB_DAMAGE                                                         = ConvertAbilityRealLevelField(FourCC('Owk3')) ---@type abilityreallevelfield 
    ABILITY_RLF_AMOUNT_HEALED_DAMAGED_UDC1                                              = ConvertAbilityRealLevelField(FourCC('Udc1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_CONVERTED_TO_MANA                                                  = ConvertAbilityRealLevelField(FourCC('Udp1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_CONVERTED_TO_LIFE                                                  = ConvertAbilityRealLevelField(FourCC('Udp2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_UAU1                                    = ConvertAbilityRealLevelField(FourCC('Uau1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT                                      = ConvertAbilityRealLevelField(FourCC('Uau2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_EVADE_EEV1                                                    = ConvertAbilityRealLevelField(FourCC('Eev1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_INTERVAL                                                     = ConvertAbilityRealLevelField(FourCC('Eim1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_DRAINED_PER_SECOND_EIM2                                            = ConvertAbilityRealLevelField(FourCC('Eim2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUFFER_MANA_REQUIRED                                                    = ConvertAbilityRealLevelField(FourCC('Eim3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_MANA_DRAINED                                                        = ConvertAbilityRealLevelField(FourCC('Emb1')) ---@type abilityreallevelfield 
    ABILITY_RLF_BOLT_DELAY                                                              = ConvertAbilityRealLevelField(FourCC('Emb2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BOLT_LIFETIME                                                           = ConvertAbilityRealLevelField(FourCC('Emb3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ALTITUDE_ADJUSTMENT_DURATION                                            = ConvertAbilityRealLevelField(FourCC('Eme3')) ---@type abilityreallevelfield 
    ABILITY_RLF_LANDING_DELAY_TIME                                                      = ConvertAbilityRealLevelField(FourCC('Eme4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ALTERNATE_FORM_HIT_POINT_BONUS                                          = ConvertAbilityRealLevelField(FourCC('Eme5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVE_SPEED_BONUS_INFO_PANEL_ONLY                                        = ConvertAbilityRealLevelField(FourCC('Ncr5')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_BONUS_INFO_PANEL_ONLY                                      = ConvertAbilityRealLevelField(FourCC('Ncr6')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_REGENERATION_RATE_PER_SECOND                                       = ConvertAbilityRealLevelField(FourCC('ave5')) ---@type abilityreallevelfield 
    ABILITY_RLF_STUN_DURATION_USL1                                                      = ConvertAbilityRealLevelField(FourCC('Usl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_DAMAGE_STOLEN_PERCENT                                            = ConvertAbilityRealLevelField(FourCC('Uav1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_UCS1                                                             = ConvertAbilityRealLevelField(FourCC('Ucs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_DAMAGE_UCS2                                                         = ConvertAbilityRealLevelField(FourCC('Ucs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DISTANCE_UCS3                                                           = ConvertAbilityRealLevelField(FourCC('Ucs3')) ---@type abilityreallevelfield 
    ABILITY_RLF_FINAL_AREA_UCS4                                                         = ConvertAbilityRealLevelField(FourCC('Ucs4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_UIN1                                                             = ConvertAbilityRealLevelField(FourCC('Uin1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DURATION                                                                = ConvertAbilityRealLevelField(FourCC('Uin2')) ---@type abilityreallevelfield 
    ABILITY_RLF_IMPACT_DELAY                                                            = ConvertAbilityRealLevelField(FourCC('Uin3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_TARGET_OCL1                                                  = ConvertAbilityRealLevelField(FourCC('Ocl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_REDUCTION_PER_TARGET                                             = ConvertAbilityRealLevelField(FourCC('Ocl3')) ---@type abilityreallevelfield 
    ABILITY_RLF_EFFECT_DELAY_OEQ1                                                       = ConvertAbilityRealLevelField(FourCC('Oeq1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_TO_BUILDINGS                                          = ConvertAbilityRealLevelField(FourCC('Oeq2')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNITS_SLOWED_PERCENT                                                    = ConvertAbilityRealLevelField(FourCC('Oeq3')) ---@type abilityreallevelfield 
    ABILITY_RLF_FINAL_AREA_OEQ4                                                         = ConvertAbilityRealLevelField(FourCC('Oeq4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_EER1                                                  = ConvertAbilityRealLevelField(FourCC('Eer1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_TO_ATTACKERS                                               = ConvertAbilityRealLevelField(FourCC('Eah1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_HEALED                                                             = ConvertAbilityRealLevelField(FourCC('Etq1')) ---@type abilityreallevelfield 
    ABILITY_RLF_HEAL_INTERVAL                                                           = ConvertAbilityRealLevelField(FourCC('Etq2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_REDUCTION_ETQ3                                                 = ConvertAbilityRealLevelField(FourCC('Etq3')) ---@type abilityreallevelfield 
    ABILITY_RLF_INITIAL_IMMUNITY_DURATION                                               = ConvertAbilityRealLevelField(FourCC('Etq4')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_LIFE_DRAINED_PER_SECOND_PERCENT                                     = ConvertAbilityRealLevelField(FourCC('Udd1')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_REDUCTION_UDD2                                                 = ConvertAbilityRealLevelField(FourCC('Udd2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ARMOR_DURATION                                                          = ConvertAbilityRealLevelField(FourCC('Ufa1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ARMOR_BONUS_UFA2                                                        = ConvertAbilityRealLevelField(FourCC('Ufa2')) ---@type abilityreallevelfield 
    ABILITY_RLF_AREA_OF_EFFECT_DAMAGE                                                   = ConvertAbilityRealLevelField(FourCC('Ufn1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_UFN2                                             = ConvertAbilityRealLevelField(FourCC('Ufn2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_HFA1                                                       = ConvertAbilityRealLevelField(FourCC('Hfa1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_ESF1                                                       = ConvertAbilityRealLevelField(FourCC('Esf1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INTERVAL_ESF2                                                    = ConvertAbilityRealLevelField(FourCC('Esf2')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_REDUCTION_ESF3                                                 = ConvertAbilityRealLevelField(FourCC('Esf3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_PERCENT                                                    = ConvertAbilityRealLevelField(FourCC('Ear1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEFENSE_BONUS_HAV1                                                      = ConvertAbilityRealLevelField(FourCC('Hav1')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINT_BONUS                                                         = ConvertAbilityRealLevelField(FourCC('Hav2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_HAV3                                                       = ConvertAbilityRealLevelField(FourCC('Hav3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_HAV4                                             = ConvertAbilityRealLevelField(FourCC('Hav4')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_BASH                                                          = ConvertAbilityRealLevelField(FourCC('Hbh1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_MULTIPLIER_HBH2                                                  = ConvertAbilityRealLevelField(FourCC('Hbh2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_HBH3                                                       = ConvertAbilityRealLevelField(FourCC('Hbh3')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_MISS_HBH4                                                     = ConvertAbilityRealLevelField(FourCC('Hbh4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_HTB1                                                             = ConvertAbilityRealLevelField(FourCC('Htb1')) ---@type abilityreallevelfield 
    ABILITY_RLF_AOE_DAMAGE                                                              = ConvertAbilityRealLevelField(FourCC('Htc1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_HTC2                                             = ConvertAbilityRealLevelField(FourCC('Htc2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HTC3                                   = ConvertAbilityRealLevelField(FourCC('Htc3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HTC4                                     = ConvertAbilityRealLevelField(FourCC('Htc4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ARMOR_BONUS_HAD1                                                        = ConvertAbilityRealLevelField(FourCC('Had1')) ---@type abilityreallevelfield 
    ABILITY_RLF_AMOUNT_HEALED_DAMAGED_HHB1                                              = ConvertAbilityRealLevelField(FourCC('Hhb1')) ---@type abilityreallevelfield 
    ABILITY_RLF_EXTRA_DAMAGE_HCA1                                                       = ConvertAbilityRealLevelField(FourCC('Hca1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_HCA2                                              = ConvertAbilityRealLevelField(FourCC('Hca2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_HCA3                                                = ConvertAbilityRealLevelField(FourCC('Hca3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OAE1                                    = ConvertAbilityRealLevelField(FourCC('Oae1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_OAE2                                      = ConvertAbilityRealLevelField(FourCC('Oae2')) ---@type abilityreallevelfield 
    ABILITY_RLF_REINCARNATION_DELAY                                                     = ConvertAbilityRealLevelField(FourCC('Ore1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_OSH1                                                             = ConvertAbilityRealLevelField(FourCC('Osh1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_DAMAGE_OSH2                                                     = ConvertAbilityRealLevelField(FourCC('Osh2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DISTANCE_OSH3                                                           = ConvertAbilityRealLevelField(FourCC('Osh3')) ---@type abilityreallevelfield 
    ABILITY_RLF_FINAL_AREA_OSH4                                                         = ConvertAbilityRealLevelField(FourCC('Osh4')) ---@type abilityreallevelfield 
    ABILITY_RLF_GRAPHIC_DELAY_NFD1                                                      = ConvertAbilityRealLevelField(FourCC('Nfd1')) ---@type abilityreallevelfield 
    ABILITY_RLF_GRAPHIC_DURATION_NFD2                                                   = ConvertAbilityRealLevelField(FourCC('Nfd2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_NFD3                                                             = ConvertAbilityRealLevelField(FourCC('Nfd3')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_AMS1                                               = ConvertAbilityRealLevelField(FourCC('Ams1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_AMS2                                             = ConvertAbilityRealLevelField(FourCC('Ams2')) ---@type abilityreallevelfield 
    ABILITY_RLF_AURA_DURATION                                                           = ConvertAbilityRealLevelField(FourCC('Apl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_APL2                                                  = ConvertAbilityRealLevelField(FourCC('Apl2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DURATION_OF_PLAGUE_WARD                                                 = ConvertAbilityRealLevelField(FourCC('Apl3')) ---@type abilityreallevelfield 
    ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED                                        = ConvertAbilityRealLevelField(FourCC('Oar1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_DAMAGE_INCREASE_AKB1                                             = ConvertAbilityRealLevelField(FourCC('Akb1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_LOSS_ADM1                                                          = ConvertAbilityRealLevelField(FourCC('Adm1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_ADM2                                               = ConvertAbilityRealLevelField(FourCC('Adm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_EXPANSION_AMOUNT                                                        = ConvertAbilityRealLevelField(FourCC('Bli1')) ---@type abilityreallevelfield 
    ABILITY_RLF_INTERVAL_DURATION_BGM2                                                  = ConvertAbilityRealLevelField(FourCC('Bgm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_RADIUS_OF_MINING_RING                                                   = ConvertAbilityRealLevelField(FourCC('Bgm4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_BLO1                                      = ConvertAbilityRealLevelField(FourCC('Blo1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_BLO2                                    = ConvertAbilityRealLevelField(FourCC('Blo2')) ---@type abilityreallevelfield 
    ABILITY_RLF_SCALING_FACTOR                                                          = ConvertAbilityRealLevelField(FourCC('Blo3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_PER_SECOND_CAN1                                              = ConvertAbilityRealLevelField(FourCC('Can1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_HIT_POINTS                                                          = ConvertAbilityRealLevelField(FourCC('Can2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_DEV2                                                  = ConvertAbilityRealLevelField(FourCC('Dev2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_UPDATE_FREQUENCY_CHD1                                          = ConvertAbilityRealLevelField(FourCC('Chd1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_UPDATE_FREQUENCY_CHD2                                            = ConvertAbilityRealLevelField(FourCC('Chd2')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_CHD3                                               = ConvertAbilityRealLevelField(FourCC('Chd3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_CRI1                                   = ConvertAbilityRealLevelField(FourCC('Cri1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_CRI2                                     = ConvertAbilityRealLevelField(FourCC('Cri2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_REDUCTION_CRI3                                                   = ConvertAbilityRealLevelField(FourCC('Cri3')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_MISS_CRS                                                      = ConvertAbilityRealLevelField(FourCC('Crs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_RADIUS_DDA1                                                 = ConvertAbilityRealLevelField(FourCC('Dda1')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_AMOUNT_DDA2                                                 = ConvertAbilityRealLevelField(FourCC('Dda2')) ---@type abilityreallevelfield 
    ABILITY_RLF_PARTIAL_DAMAGE_RADIUS                                                   = ConvertAbilityRealLevelField(FourCC('Dda3')) ---@type abilityreallevelfield 
    ABILITY_RLF_PARTIAL_DAMAGE_AMOUNT                                                   = ConvertAbilityRealLevelField(FourCC('Dda4')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_DAMAGE_FACTOR_SDS1                                             = ConvertAbilityRealLevelField(FourCC('Sds1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_DAMAGE_UCO5                                                         = ConvertAbilityRealLevelField(FourCC('Uco5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVE_SPEED_BONUS_UCO6                                                   = ConvertAbilityRealLevelField(FourCC('Uco6')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_TAKEN_PERCENT_DEF1                                               = ConvertAbilityRealLevelField(FourCC('Def1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_PERCENT_DEF2                                               = ConvertAbilityRealLevelField(FourCC('Def2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_DEF3                                              = ConvertAbilityRealLevelField(FourCC('Def3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_DEF4                                                = ConvertAbilityRealLevelField(FourCC('Def4')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_DEF5                                             = ConvertAbilityRealLevelField(FourCC('Def5')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_DEFLECT                                                       = ConvertAbilityRealLevelField(FourCC('Def6')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_PIERCING                                           = ConvertAbilityRealLevelField(FourCC('Def7')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_SPELLS                                             = ConvertAbilityRealLevelField(FourCC('Def8')) ---@type abilityreallevelfield 
    ABILITY_RLF_RIP_DELAY                                                               = ConvertAbilityRealLevelField(FourCC('Eat1')) ---@type abilityreallevelfield 
    ABILITY_RLF_EAT_DELAY                                                               = ConvertAbilityRealLevelField(FourCC('Eat2')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_GAINED_EAT3                                                  = ConvertAbilityRealLevelField(FourCC('Eat3')) ---@type abilityreallevelfield 
    ABILITY_RLF_AIR_UNIT_LOWER_DURATION                                                 = ConvertAbilityRealLevelField(FourCC('Ens1')) ---@type abilityreallevelfield 
    ABILITY_RLF_AIR_UNIT_HEIGHT                                                         = ConvertAbilityRealLevelField(FourCC('Ens2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MELEE_ATTACK_RANGE                                                      = ConvertAbilityRealLevelField(FourCC('Ens3')) ---@type abilityreallevelfield 
    ABILITY_RLF_INTERVAL_DURATION_EGM2                                                  = ConvertAbilityRealLevelField(FourCC('Egm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_EFFECT_DELAY_FLA2                                                       = ConvertAbilityRealLevelField(FourCC('Fla2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINING_DURATION                                                         = ConvertAbilityRealLevelField(FourCC('Gld2')) ---@type abilityreallevelfield 
    ABILITY_RLF_RADIUS_OF_GRAVESTONES                                                   = ConvertAbilityRealLevelField(FourCC('Gyd2')) ---@type abilityreallevelfield 
    ABILITY_RLF_RADIUS_OF_CORPSES                                                       = ConvertAbilityRealLevelField(FourCC('Gyd3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_GAINED_HEA1                                                  = ConvertAbilityRealLevelField(FourCC('Hea1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1                                            = ConvertAbilityRealLevelField(FourCC('Inf1')) ---@type abilityreallevelfield 
    ABILITY_RLF_AUTOCAST_RANGE                                                          = ConvertAbilityRealLevelField(FourCC('Inf3')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_REGEN_RATE                                                         = ConvertAbilityRealLevelField(FourCC('Inf4')) ---@type abilityreallevelfield 
    ABILITY_RLF_GRAPHIC_DELAY_LIT1                                                      = ConvertAbilityRealLevelField(FourCC('Lit1')) ---@type abilityreallevelfield 
    ABILITY_RLF_GRAPHIC_DURATION_LIT2                                                   = ConvertAbilityRealLevelField(FourCC('Lit2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_LSH1                                                  = ConvertAbilityRealLevelField(FourCC('Lsh1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_GAINED                                                             = ConvertAbilityRealLevelField(FourCC('Mbt1')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_GAINED_MBT2                                                  = ConvertAbilityRealLevelField(FourCC('Mbt2')) ---@type abilityreallevelfield 
    ABILITY_RLF_AUTOCAST_REQUIREMENT                                                    = ConvertAbilityRealLevelField(FourCC('Mbt3')) ---@type abilityreallevelfield 
    ABILITY_RLF_WATER_HEIGHT                                                            = ConvertAbilityRealLevelField(FourCC('Mbt4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ACTIVATION_DELAY_MIN1                                                   = ConvertAbilityRealLevelField(FourCC('Min1')) ---@type abilityreallevelfield 
    ABILITY_RLF_INVISIBILITY_TRANSITION_TIME                                            = ConvertAbilityRealLevelField(FourCC('Min2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ACTIVATION_RADIUS                                                       = ConvertAbilityRealLevelField(FourCC('Neu1')) ---@type abilityreallevelfield 
    ABILITY_RLF_AMOUNT_REGENERATED                                                      = ConvertAbilityRealLevelField(FourCC('Arm1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_POI1                                                  = ConvertAbilityRealLevelField(FourCC('Poi1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_POI2                                                = ConvertAbilityRealLevelField(FourCC('Poi2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POI3                                              = ConvertAbilityRealLevelField(FourCC('Poi3')) ---@type abilityreallevelfield 
    ABILITY_RLF_EXTRA_DAMAGE_POA1                                                       = ConvertAbilityRealLevelField(FourCC('Poa1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_POA2                                                  = ConvertAbilityRealLevelField(FourCC('Poa2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_POA3                                                = ConvertAbilityRealLevelField(FourCC('Poa3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POA4                                              = ConvertAbilityRealLevelField(FourCC('Poa4'))    ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_AMPLIFICATION                                                    = ConvertAbilityRealLevelField(FourCC('Pos2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_STOMP_PERCENT                                                 = ConvertAbilityRealLevelField(FourCC('War1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_WAR2                                                       = ConvertAbilityRealLevelField(FourCC('War2')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_RADIUS_WAR3                                                 = ConvertAbilityRealLevelField(FourCC('War3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HALF_DAMAGE_RADIUS_WAR4                                                 = ConvertAbilityRealLevelField(FourCC('War4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_PRG3                                               = ConvertAbilityRealLevelField(FourCC('Prg3')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNIT_PAUSE_DURATION                                                     = ConvertAbilityRealLevelField(FourCC('Prg4')) ---@type abilityreallevelfield 
    ABILITY_RLF_HERO_PAUSE_DURATION                                                     = ConvertAbilityRealLevelField(FourCC('Prg5')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_GAINED_REJ1                                                  = ConvertAbilityRealLevelField(FourCC('Rej1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_POINTS_GAINED_REJ2                                                 = ConvertAbilityRealLevelField(FourCC('Rej2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINIMUM_LIFE_REQUIRED                                                   = ConvertAbilityRealLevelField(FourCC('Rpb3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINIMUM_MANA_REQUIRED                                                   = ConvertAbilityRealLevelField(FourCC('Rpb4')) ---@type abilityreallevelfield 
    ABILITY_RLF_REPAIR_COST_RATIO                                                       = ConvertAbilityRealLevelField(FourCC('Rep1')) ---@type abilityreallevelfield 
    ABILITY_RLF_REPAIR_TIME_RATIO                                                       = ConvertAbilityRealLevelField(FourCC('Rep2')) ---@type abilityreallevelfield 
    ABILITY_RLF_POWERBUILD_COST                                                         = ConvertAbilityRealLevelField(FourCC('Rep3')) ---@type abilityreallevelfield 
    ABILITY_RLF_POWERBUILD_RATE                                                         = ConvertAbilityRealLevelField(FourCC('Rep4')) ---@type abilityreallevelfield 
    ABILITY_RLF_NAVAL_RANGE_BONUS                                                       = ConvertAbilityRealLevelField(FourCC('Rep5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1                                            = ConvertAbilityRealLevelField(FourCC('Roa1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_REGENERATION_RATE                                                  = ConvertAbilityRealLevelField(FourCC('Roa3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_REGEN                                                              = ConvertAbilityRealLevelField(FourCC('Roa4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INCREASE                                                         = ConvertAbilityRealLevelField(FourCC('Nbr1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SALVAGE_COST_RATIO                                                      = ConvertAbilityRealLevelField(FourCC('Sal1')) ---@type abilityreallevelfield 
    ABILITY_RLF_IN_FLIGHT_SIGHT_RADIUS                                                  = ConvertAbilityRealLevelField(FourCC('Esn1')) ---@type abilityreallevelfield 
    ABILITY_RLF_HOVERING_SIGHT_RADIUS                                                   = ConvertAbilityRealLevelField(FourCC('Esn2')) ---@type abilityreallevelfield 
    ABILITY_RLF_HOVERING_HEIGHT                                                         = ConvertAbilityRealLevelField(FourCC('Esn3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DURATION_OF_OWLS                                                        = ConvertAbilityRealLevelField(FourCC('Esn5')) ---@type abilityreallevelfield 
    ABILITY_RLF_FADE_DURATION                                                           = ConvertAbilityRealLevelField(FourCC('Shm1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAY_NIGHT_DURATION                                                      = ConvertAbilityRealLevelField(FourCC('Shm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ACTION_DURATION                                                         = ConvertAbilityRealLevelField(FourCC('Shm3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SLO1                                              = ConvertAbilityRealLevelField(FourCC('Slo1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_SLO2                                                = ConvertAbilityRealLevelField(FourCC('Slo2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_SPO1                                                  = ConvertAbilityRealLevelField(FourCC('Spo1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SPO2                                              = ConvertAbilityRealLevelField(FourCC('Spo2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_SPO3                                                = ConvertAbilityRealLevelField(FourCC('Spo3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ACTIVATION_DELAY_STA1                                                   = ConvertAbilityRealLevelField(FourCC('Sta1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DETECTION_RADIUS_STA2                                                   = ConvertAbilityRealLevelField(FourCC('Sta2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DETONATION_RADIUS                                                       = ConvertAbilityRealLevelField(FourCC('Sta3')) ---@type abilityreallevelfield 
    ABILITY_RLF_STUN_DURATION_STA4                                                      = ConvertAbilityRealLevelField(FourCC('Sta4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT                                              = ConvertAbilityRealLevelField(FourCC('Uhf1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_UHF2                                                  = ConvertAbilityRealLevelField(FourCC('Uhf2')) ---@type abilityreallevelfield 
    ABILITY_RLF_LUMBER_PER_INTERVAL                                                     = ConvertAbilityRealLevelField(FourCC('Wha1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ART_ATTACHMENT_HEIGHT                                                   = ConvertAbilityRealLevelField(FourCC('Wha3')) ---@type abilityreallevelfield 
    ABILITY_RLF_TELEPORT_AREA_WIDTH                                                     = ConvertAbilityRealLevelField(FourCC('Wrp1')) ---@type abilityreallevelfield 
    ABILITY_RLF_TELEPORT_AREA_HEIGHT                                                    = ConvertAbilityRealLevelField(FourCC('Wrp2')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_STOLEN_PER_ATTACK                                                  = ConvertAbilityRealLevelField(FourCC('Ivam')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_IDAM                                                       = ConvertAbilityRealLevelField(FourCC('Idam')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_HIT_UNITS_PERCENT                                             = ConvertAbilityRealLevelField(FourCC('Iob2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_HIT_HEROS_PERCENT                                             = ConvertAbilityRealLevelField(FourCC('Iob3')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_HIT_SUMMONS_PERCENT                                           = ConvertAbilityRealLevelField(FourCC('Iob4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DELAY_FOR_TARGET_EFFECT                                                 = ConvertAbilityRealLevelField(FourCC('Idel')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL                                          = ConvertAbilityRealLevelField(FourCC('Iild')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER                                              = ConvertAbilityRealLevelField(FourCC('Iilw')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL                           = ConvertAbilityRealLevelField(FourCC('Imrp')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_ISPI                                            = ConvertAbilityRealLevelField(FourCC('Ispi')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_IDPS                                                  = ConvertAbilityRealLevelField(FourCC('Idps')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1                                             = ConvertAbilityRealLevelField(FourCC('Cac1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_COR1                                                  = ConvertAbilityRealLevelField(FourCC('Cor1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1                                              = ConvertAbilityRealLevelField(FourCC('Isx1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_WRS1                                                             = ConvertAbilityRealLevelField(FourCC('Wrs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_TERRAIN_DEFORMATION_AMPLITUDE                                           = ConvertAbilityRealLevelField(FourCC('Wrs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_CTC1                                                             = ConvertAbilityRealLevelField(FourCC('Ctc1')) ---@type abilityreallevelfield 
    ABILITY_RLF_EXTRA_DAMAGE_TO_TARGET                                                  = ConvertAbilityRealLevelField(FourCC('Ctc2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_CTC3                                           = ConvertAbilityRealLevelField(FourCC('Ctc3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_CTC4                                             = ConvertAbilityRealLevelField(FourCC('Ctc4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_CTB1                                                             = ConvertAbilityRealLevelField(FourCC('Ctb1')) ---@type abilityreallevelfield 
    ABILITY_RLF_CASTING_DELAY_SECONDS                                                   = ConvertAbilityRealLevelField(FourCC('Uds2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_LOSS_PER_UNIT_DTN1                                                 = ConvertAbilityRealLevelField(FourCC('Dtn1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_DTN2                                           = ConvertAbilityRealLevelField(FourCC('Dtn2')) ---@type abilityreallevelfield 
    ABILITY_RLF_TRANSITION_TIME_SECONDS                                                 = ConvertAbilityRealLevelField(FourCC('Ivs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_DRAINED_PER_SECOND_NMR1                                            = ConvertAbilityRealLevelField(FourCC('Nmr1')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_REDUCE_DAMAGE_PERCENT                                         = ConvertAbilityRealLevelField(FourCC('Ssk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINIMUM_DAMAGE                                                          = ConvertAbilityRealLevelField(FourCC('Ssk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_IGNORED_DAMAGE                                                          = ConvertAbilityRealLevelField(FourCC('Ssk3')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_DEALT                                                       = ConvertAbilityRealLevelField(FourCC('Hfs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_INTERVAL                                                    = ConvertAbilityRealLevelField(FourCC('Hfs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_HALF_DAMAGE_DEALT                                                       = ConvertAbilityRealLevelField(FourCC('Hfs3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HALF_DAMAGE_INTERVAL                                                    = ConvertAbilityRealLevelField(FourCC('Hfs4')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_REDUCTION_HFS5                                                 = ConvertAbilityRealLevelField(FourCC('Hfs5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_DAMAGE_HFS6                                                     = ConvertAbilityRealLevelField(FourCC('Hfs6')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_PER_HIT_POINT                                                      = ConvertAbilityRealLevelField(FourCC('Nms1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_ABSORBED_PERCENT                                                 = ConvertAbilityRealLevelField(FourCC('Nms2')) ---@type abilityreallevelfield 
    ABILITY_RLF_WAVE_DISTANCE                                                           = ConvertAbilityRealLevelField(FourCC('Uim1')) ---@type abilityreallevelfield 
    ABILITY_RLF_WAVE_TIME_SECONDS                                                       = ConvertAbilityRealLevelField(FourCC('Uim2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DEALT_UIM3                                                       = ConvertAbilityRealLevelField(FourCC('Uim3')) ---@type abilityreallevelfield 
    ABILITY_RLF_AIR_TIME_SECONDS_UIM4                                                   = ConvertAbilityRealLevelField(FourCC('Uim4')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNIT_RELEASE_INTERVAL_SECONDS                                           = ConvertAbilityRealLevelField(FourCC('Uls2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RETURN_FACTOR                                                    = ConvertAbilityRealLevelField(FourCC('Uls4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RETURN_THRESHOLD                                                 = ConvertAbilityRealLevelField(FourCC('Uls5')) ---@type abilityreallevelfield 
    ABILITY_RLF_RETURNED_DAMAGE_FACTOR                                                  = ConvertAbilityRealLevelField(FourCC('Uts1')) ---@type abilityreallevelfield 
    ABILITY_RLF_RECEIVED_DAMAGE_FACTOR                                                  = ConvertAbilityRealLevelField(FourCC('Uts2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEFENSE_BONUS_UTS3                                                      = ConvertAbilityRealLevelField(FourCC('Uts3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_NBA1                                                       = ConvertAbilityRealLevelField(FourCC('Nba1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NBA3                                     = ConvertAbilityRealLevelField(FourCC('Nba3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_PER_SUMMONED_HITPOINT                                              = ConvertAbilityRealLevelField(FourCC('Cmg2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHARGE_FOR_CURRENT_LIFE                                                 = ConvertAbilityRealLevelField(FourCC('Cmg3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_DRAINED                                                      = ConvertAbilityRealLevelField(FourCC('Ndr1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_POINTS_DRAINED                                                     = ConvertAbilityRealLevelField(FourCC('Ndr2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DRAIN_INTERVAL_SECONDS                                                  = ConvertAbilityRealLevelField(FourCC('Ndr3')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_TRANSFERRED_PER_SECOND                                             = ConvertAbilityRealLevelField(FourCC('Ndr4')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_TRANSFERRED_PER_SECOND                                             = ConvertAbilityRealLevelField(FourCC('Ndr5')) ---@type abilityreallevelfield 
    ABILITY_RLF_BONUS_LIFE_FACTOR                                                       = ConvertAbilityRealLevelField(FourCC('Ndr6')) ---@type abilityreallevelfield 
    ABILITY_RLF_BONUS_LIFE_DECAY                                                        = ConvertAbilityRealLevelField(FourCC('Ndr7')) ---@type abilityreallevelfield 
    ABILITY_RLF_BONUS_MANA_FACTOR                                                       = ConvertAbilityRealLevelField(FourCC('Ndr8')) ---@type abilityreallevelfield 
    ABILITY_RLF_BONUS_MANA_DECAY                                                        = ConvertAbilityRealLevelField(FourCC('Ndr9')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_MISS_PERCENT                                                  = ConvertAbilityRealLevelField(FourCC('Nsi2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_MODIFIER                                                 = ConvertAbilityRealLevelField(FourCC('Nsi3')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_MODIFIER                                                   = ConvertAbilityRealLevelField(FourCC('Nsi4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_TDG1                                                  = ConvertAbilityRealLevelField(FourCC('Tdg1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_TDG2                                               = ConvertAbilityRealLevelField(FourCC('Tdg2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MEDIUM_DAMAGE_PER_SECOND                                                = ConvertAbilityRealLevelField(FourCC('Tdg3')) ---@type abilityreallevelfield 
    ABILITY_RLF_SMALL_DAMAGE_RADIUS_TDG4                                                = ConvertAbilityRealLevelField(FourCC('Tdg4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SMALL_DAMAGE_PER_SECOND                                                 = ConvertAbilityRealLevelField(FourCC('Tdg5')) ---@type abilityreallevelfield 
    ABILITY_RLF_AIR_TIME_SECONDS_TSP1                                                   = ConvertAbilityRealLevelField(FourCC('Tsp1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINIMUM_HIT_INTERVAL_SECONDS                                            = ConvertAbilityRealLevelField(FourCC('Tsp2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_NBF5                                                  = ConvertAbilityRealLevelField(FourCC('Nbf5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_RANGE                                                           = ConvertAbilityRealLevelField(FourCC('Ebl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MINIMUM_RANGE                                                           = ConvertAbilityRealLevelField(FourCC('Ebl2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_TARGET_EFK1                                                  = ConvertAbilityRealLevelField(FourCC('Efk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE                                                    = ConvertAbilityRealLevelField(FourCC('Efk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_SPEED_ADJUSTMENT                                                = ConvertAbilityRealLevelField(FourCC('Efk4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DECAYING_DAMAGE                                                         = ConvertAbilityRealLevelField(FourCC('Esh1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_FACTOR_ESH2                                              = ConvertAbilityRealLevelField(FourCC('Esh2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_FACTOR_ESH3                                                = ConvertAbilityRealLevelField(FourCC('Esh3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DECAY_POWER                                                             = ConvertAbilityRealLevelField(FourCC('Esh4')) ---@type abilityreallevelfield 
    ABILITY_RLF_INITIAL_DAMAGE_ESH5                                                     = ConvertAbilityRealLevelField(FourCC('Esh5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_LIFE_ABSORBED                                                   = ConvertAbilityRealLevelField(FourCC('abs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAXIMUM_MANA_ABSORBED                                                   = ConvertAbilityRealLevelField(FourCC('abs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_INCREASE_BSK1                                            = ConvertAbilityRealLevelField(FourCC('bsk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_INCREASE_BSK2                                              = ConvertAbilityRealLevelField(FourCC('bsk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_TAKEN_INCREASE                                                   = ConvertAbilityRealLevelField(FourCC('bsk3')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_PER_UNIT                                                           = ConvertAbilityRealLevelField(FourCC('dvm1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_PER_UNIT                                                           = ConvertAbilityRealLevelField(FourCC('dvm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_PER_BUFF                                                           = ConvertAbilityRealLevelField(FourCC('dvm3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_PER_BUFF                                                           = ConvertAbilityRealLevelField(FourCC('dvm4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_DVM5                                               = ConvertAbilityRealLevelField(FourCC('dvm5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_FAK1                                                       = ConvertAbilityRealLevelField(FourCC('fak1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MEDIUM_DAMAGE_FACTOR_FAK2                                               = ConvertAbilityRealLevelField(FourCC('fak2')) ---@type abilityreallevelfield 
    ABILITY_RLF_SMALL_DAMAGE_FACTOR_FAK3                                                = ConvertAbilityRealLevelField(FourCC('fak3')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_RADIUS_FAK4                                                 = ConvertAbilityRealLevelField(FourCC('fak4')) ---@type abilityreallevelfield 
    ABILITY_RLF_HALF_DAMAGE_RADIUS_FAK5                                                 = ConvertAbilityRealLevelField(FourCC('fak5')) ---@type abilityreallevelfield 
    ABILITY_RLF_EXTRA_DAMAGE_PER_SECOND                                                 = ConvertAbilityRealLevelField(FourCC('liq1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_LIQ2                                           = ConvertAbilityRealLevelField(FourCC('liq2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_LIQ3                                             = ConvertAbilityRealLevelField(FourCC('liq3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_FACTOR                                                     = ConvertAbilityRealLevelField(FourCC('mim1')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNIT_DAMAGE_PER_MANA_POINT                                              = ConvertAbilityRealLevelField(FourCC('mfl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_HERO_DAMAGE_PER_MANA_POINT                                              = ConvertAbilityRealLevelField(FourCC('mfl2')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNIT_MAXIMUM_DAMAGE                                                     = ConvertAbilityRealLevelField(FourCC('mfl3')) ---@type abilityreallevelfield 
    ABILITY_RLF_HERO_MAXIMUM_DAMAGE                                                     = ConvertAbilityRealLevelField(FourCC('mfl4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_COOLDOWN                                                         = ConvertAbilityRealLevelField(FourCC('mfl5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_SPL1                                          = ConvertAbilityRealLevelField(FourCC('spl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_REGENERATED                                                        = ConvertAbilityRealLevelField(FourCC('irl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_REGENERATED                                                        = ConvertAbilityRealLevelField(FourCC('irl2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_LOSS_PER_UNIT_IDC1                                                 = ConvertAbilityRealLevelField(FourCC('idc1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DAMAGE_IDC2                                               = ConvertAbilityRealLevelField(FourCC('idc2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ACTIVATION_DELAY_IMO2                                                   = ConvertAbilityRealLevelField(FourCC('imo2')) ---@type abilityreallevelfield 
    ABILITY_RLF_LURE_INTERVAL_SECONDS                                                   = ConvertAbilityRealLevelField(FourCC('imo3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_ISR1                                                       = ConvertAbilityRealLevelField(FourCC('isr1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_REDUCTION_ISR2                                                   = ConvertAbilityRealLevelField(FourCC('isr2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_IPV1                                                       = ConvertAbilityRealLevelField(FourCC('ipv1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_STEAL_AMOUNT                                                       = ConvertAbilityRealLevelField(FourCC('ipv2')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_RESTORED_FACTOR                                                    = ConvertAbilityRealLevelField(FourCC('ast1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MANA_RESTORED_FACTOR                                                    = ConvertAbilityRealLevelField(FourCC('ast2')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACH_DELAY                                                            = ConvertAbilityRealLevelField(FourCC('gra1')) ---@type abilityreallevelfield 
    ABILITY_RLF_REMOVE_DELAY                                                            = ConvertAbilityRealLevelField(FourCC('gra2')) ---@type abilityreallevelfield 
    ABILITY_RLF_HERO_REGENERATION_DELAY                                                 = ConvertAbilityRealLevelField(FourCC('Nsa2')) ---@type abilityreallevelfield 
    ABILITY_RLF_UNIT_REGENERATION_DELAY                                                 = ConvertAbilityRealLevelField(FourCC('Nsa3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_NSA4                                             = ConvertAbilityRealLevelField(FourCC('Nsa4')) ---@type abilityreallevelfield 
    ABILITY_RLF_HIT_POINTS_PER_SECOND_NSA5                                              = ConvertAbilityRealLevelField(FourCC('Nsa5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_IXS1                                           = ConvertAbilityRealLevelField(FourCC('Ixs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_IXS2                                             = ConvertAbilityRealLevelField(FourCC('Ixs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DURATION                                                  = ConvertAbilityRealLevelField(FourCC('Npa6')) ---@type abilityreallevelfield 
    ABILITY_RLF_SHIELD_COOLDOWN_TIME                                                    = ConvertAbilityRealLevelField(FourCC('Nse1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_NDO1                                                  = ConvertAbilityRealLevelField(FourCC('Ndo1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NDO3                                     = ConvertAbilityRealLevelField(FourCC('Ndo3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_FLK1                                               = ConvertAbilityRealLevelField(FourCC('flk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SMALL_DAMAGE_RADIUS_FLK2                                                = ConvertAbilityRealLevelField(FourCC('flk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_AMOUNT_FLK3                                                 = ConvertAbilityRealLevelField(FourCC('flk3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MEDIUM_DAMAGE_AMOUNT                                                    = ConvertAbilityRealLevelField(FourCC('flk4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SMALL_DAMAGE_AMOUNT                                                     = ConvertAbilityRealLevelField(FourCC('flk5')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HBN1                                   = ConvertAbilityRealLevelField(FourCC('Hbn1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HBN2                                     = ConvertAbilityRealLevelField(FourCC('Hbn2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_MANA_DRAINED_UNITS                                                  = ConvertAbilityRealLevelField(FourCC('fbk1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RATIO_UNITS_PERCENT                                              = ConvertAbilityRealLevelField(FourCC('fbk2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_MANA_DRAINED_HEROS                                                  = ConvertAbilityRealLevelField(FourCC('fbk3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RATIO_HEROS_PERCENT                                              = ConvertAbilityRealLevelField(FourCC('fbk4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SUMMONED_DAMAGE                                                         = ConvertAbilityRealLevelField(FourCC('fbk5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_NCA1                                          = ConvertAbilityRealLevelField(FourCC('nca1')) ---@type abilityreallevelfield 
    ABILITY_RLF_INITIAL_DAMAGE_PXF1                                                     = ConvertAbilityRealLevelField(FourCC('pxf1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_PXF2                                                  = ConvertAbilityRealLevelField(FourCC('pxf2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PER_SECOND_MLS1                                                  = ConvertAbilityRealLevelField(FourCC('mls1')) ---@type abilityreallevelfield 
    ABILITY_RLF_BEAST_COLLISION_RADIUS                                                  = ConvertAbilityRealLevelField(FourCC('Nst2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_AMOUNT_NST3                                                      = ConvertAbilityRealLevelField(FourCC('Nst3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_RADIUS                                                           = ConvertAbilityRealLevelField(FourCC('Nst4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_DELAY                                                            = ConvertAbilityRealLevelField(FourCC('Nst5')) ---@type abilityreallevelfield 
    ABILITY_RLF_FOLLOW_THROUGH_TIME                                                     = ConvertAbilityRealLevelField(FourCC('Ncl1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ART_DURATION                                                            = ConvertAbilityRealLevelField(FourCC('Ncl4')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NAB1                                   = ConvertAbilityRealLevelField(FourCC('Nab1')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NAB2                                     = ConvertAbilityRealLevelField(FourCC('Nab2')) ---@type abilityreallevelfield 
    ABILITY_RLF_PRIMARY_DAMAGE                                                          = ConvertAbilityRealLevelField(FourCC('Nab4')) ---@type abilityreallevelfield 
    ABILITY_RLF_SECONDARY_DAMAGE                                                        = ConvertAbilityRealLevelField(FourCC('Nab5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INTERVAL_NAB6                                                    = ConvertAbilityRealLevelField(FourCC('Nab6')) ---@type abilityreallevelfield 
    ABILITY_RLF_GOLD_COST_FACTOR                                                        = ConvertAbilityRealLevelField(FourCC('Ntm1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LUMBER_COST_FACTOR                                                      = ConvertAbilityRealLevelField(FourCC('Ntm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVE_SPEED_BONUS_NEG1                                                   = ConvertAbilityRealLevelField(FourCC('Neg1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_BONUS_NEG2                                                       = ConvertAbilityRealLevelField(FourCC('Neg2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_AMOUNT_NCS1                                                      = ConvertAbilityRealLevelField(FourCC('Ncs1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_INTERVAL_NCS2                                                    = ConvertAbilityRealLevelField(FourCC('Ncs2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_DAMAGE_NCS4                                                         = ConvertAbilityRealLevelField(FourCC('Ncs4')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NCS5                                             = ConvertAbilityRealLevelField(FourCC('Ncs5')) ---@type abilityreallevelfield 
    ABILITY_RLF_EFFECT_DURATION                                                         = ConvertAbilityRealLevelField(FourCC('Ncs6')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPAWN_INTERVAL_NSY1                                                     = ConvertAbilityRealLevelField(FourCC('Nsy1')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPAWN_UNIT_DURATION                                                     = ConvertAbilityRealLevelField(FourCC('Nsy3')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPAWN_UNIT_OFFSET                                                       = ConvertAbilityRealLevelField(FourCC('Nsy4')) ---@type abilityreallevelfield 
    ABILITY_RLF_LEASH_RANGE_NSY5                                                        = ConvertAbilityRealLevelField(FourCC('Nsy5')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPAWN_INTERVAL_NFY1                                                     = ConvertAbilityRealLevelField(FourCC('Nfy1')) ---@type abilityreallevelfield 
    ABILITY_RLF_LEASH_RANGE_NFY2                                                        = ConvertAbilityRealLevelField(FourCC('Nfy2')) ---@type abilityreallevelfield 
    ABILITY_RLF_CHANCE_TO_DEMOLISH                                                      = ConvertAbilityRealLevelField(FourCC('Nde1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_MULTIPLIER_BUILDINGS                                             = ConvertAbilityRealLevelField(FourCC('Nde2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_MULTIPLIER_UNITS                                                 = ConvertAbilityRealLevelField(FourCC('Nde3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_MULTIPLIER_HEROES                                                = ConvertAbilityRealLevelField(FourCC('Nde4')) ---@type abilityreallevelfield 
    ABILITY_RLF_BONUS_DAMAGE_MULTIPLIER                                                 = ConvertAbilityRealLevelField(FourCC('Nic1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEATH_DAMAGE_FULL_AMOUNT                                                = ConvertAbilityRealLevelField(FourCC('Nic2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEATH_DAMAGE_FULL_AREA                                                  = ConvertAbilityRealLevelField(FourCC('Nic3')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEATH_DAMAGE_HALF_AMOUNT                                                = ConvertAbilityRealLevelField(FourCC('Nic4')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEATH_DAMAGE_HALF_AREA                                                  = ConvertAbilityRealLevelField(FourCC('Nic5')) ---@type abilityreallevelfield 
    ABILITY_RLF_DEATH_DAMAGE_DELAY                                                      = ConvertAbilityRealLevelField(FourCC('Nic6')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_AMOUNT_NSO1                                                      = ConvertAbilityRealLevelField(FourCC('Nso1')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PERIOD                                                           = ConvertAbilityRealLevelField(FourCC('Nso2')) ---@type abilityreallevelfield 
    ABILITY_RLF_DAMAGE_PENALTY                                                          = ConvertAbilityRealLevelField(FourCC('Nso3')) ---@type abilityreallevelfield 
    ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NSO4                                   = ConvertAbilityRealLevelField(FourCC('Nso4')) ---@type abilityreallevelfield 
    ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NSO5                                     = ConvertAbilityRealLevelField(FourCC('Nso5')) ---@type abilityreallevelfield 
    ABILITY_RLF_SPLIT_DELAY                                                             = ConvertAbilityRealLevelField(FourCC('Nlm2')) ---@type abilityreallevelfield 
    ABILITY_RLF_MAX_HITPOINT_FACTOR                                                     = ConvertAbilityRealLevelField(FourCC('Nlm4')) ---@type abilityreallevelfield 
    ABILITY_RLF_LIFE_DURATION_SPLIT_BONUS                                               = ConvertAbilityRealLevelField(FourCC('Nlm5')) ---@type abilityreallevelfield 
    ABILITY_RLF_WAVE_INTERVAL                                                           = ConvertAbilityRealLevelField(FourCC('Nvc3')) ---@type abilityreallevelfield 
    ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NVC4                                             = ConvertAbilityRealLevelField(FourCC('Nvc4')) ---@type abilityreallevelfield 
    ABILITY_RLF_FULL_DAMAGE_AMOUNT_NVC5                                                 = ConvertAbilityRealLevelField(FourCC('Nvc5')) ---@type abilityreallevelfield 
    ABILITY_RLF_HALF_DAMAGE_FACTOR                                                      = ConvertAbilityRealLevelField(FourCC('Nvc6')) ---@type abilityreallevelfield 
    ABILITY_RLF_INTERVAL_BETWEEN_PULSES                                                 = ConvertAbilityRealLevelField(FourCC('Tau5')) ---@type abilityreallevelfield 

    ABILITY_BLF_PERCENT_BONUS_HAB2                                     = ConvertAbilityBooleanLevelField(FourCC('Hab2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_USE_TELEPORT_CLUSTERING_HMT3                           = ConvertAbilityBooleanLevelField(FourCC('Hmt3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_NEVER_MISS_OCR5                                        = ConvertAbilityBooleanLevelField(FourCC('Ocr5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_EXCLUDE_ITEM_DAMAGE                                    = ConvertAbilityBooleanLevelField(FourCC('Ocr6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_BACKSTAB_DAMAGE                                        = ConvertAbilityBooleanLevelField(FourCC('Owk4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_INHERIT_UPGRADES_UAN3                                  = ConvertAbilityBooleanLevelField(FourCC('Uan3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_MANA_CONVERSION_AS_PERCENT                             = ConvertAbilityBooleanLevelField(FourCC('Udp3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_LIFE_CONVERSION_AS_PERCENT                             = ConvertAbilityBooleanLevelField(FourCC('Udp4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_LEAVE_TARGET_ALIVE                                     = ConvertAbilityBooleanLevelField(FourCC('Udp5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PERCENT_BONUS_UAU3                                     = ConvertAbilityBooleanLevelField(FourCC('Uau3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DAMAGE_IS_PERCENT_RECEIVED                             = ConvertAbilityBooleanLevelField(FourCC('Eah2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_MELEE_BONUS                                            = ConvertAbilityBooleanLevelField(FourCC('Ear2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_RANGED_BONUS                                           = ConvertAbilityBooleanLevelField(FourCC('Ear3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_FLAT_BONUS                                             = ConvertAbilityBooleanLevelField(FourCC('Ear4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_NEVER_MISS_HBH5                                        = ConvertAbilityBooleanLevelField(FourCC('Hbh5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PERCENT_BONUS_HAD2                                     = ConvertAbilityBooleanLevelField(FourCC('Had2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CAN_DEACTIVATE                                         = ConvertAbilityBooleanLevelField(FourCC('Hds1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_RAISED_UNITS_ARE_INVULNERABLE                          = ConvertAbilityBooleanLevelField(FourCC('Hre2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PERCENTAGE_OAR2                                        = ConvertAbilityBooleanLevelField(FourCC('Oar2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_SUMMON_BUSY_UNITS                                      = ConvertAbilityBooleanLevelField(FourCC('Btl2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CREATES_BLIGHT                                         = ConvertAbilityBooleanLevelField(FourCC('Bli2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_EXPLODES_ON_DEATH                                      = ConvertAbilityBooleanLevelField(FourCC('Sds6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ALWAYS_AUTOCAST_FAE2                                   = ConvertAbilityBooleanLevelField(FourCC('Fae2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_REGENERATE_ONLY_AT_NIGHT                               = ConvertAbilityBooleanLevelField(FourCC('Mbt5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_SHOW_SELECT_UNIT_BUTTON                                = ConvertAbilityBooleanLevelField(FourCC('Neu3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_SHOW_UNIT_INDICATOR                                    = ConvertAbilityBooleanLevelField(FourCC('Neu4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CHARGE_OWNING_PLAYER                                   = ConvertAbilityBooleanLevelField(FourCC('Ans6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PERCENTAGE_ARM2                                        = ConvertAbilityBooleanLevelField(FourCC('Arm2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_TARGET_IS_INVULNERABLE                                 = ConvertAbilityBooleanLevelField(FourCC('Pos3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_TARGET_IS_MAGIC_IMMUNE                                 = ConvertAbilityBooleanLevelField(FourCC('Pos4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_KILL_ON_CASTER_DEATH                                   = ConvertAbilityBooleanLevelField(FourCC('Ucb6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_NO_TARGET_REQUIRED_REJ4                                = ConvertAbilityBooleanLevelField(FourCC('Rej4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ACCEPTS_GOLD                                           = ConvertAbilityBooleanLevelField(FourCC('Rtn1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ACCEPTS_LUMBER                                         = ConvertAbilityBooleanLevelField(FourCC('Rtn2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PREFER_HOSTILES_ROA5                                   = ConvertAbilityBooleanLevelField(FourCC('Roa5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_PREFER_FRIENDLIES_ROA6                                 = ConvertAbilityBooleanLevelField(FourCC('Roa6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ROOTED_TURNING                                         = ConvertAbilityBooleanLevelField(FourCC('Roo3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ALWAYS_AUTOCAST_SLO3                                   = ConvertAbilityBooleanLevelField(FourCC('Slo3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_HIDE_BUTTON                                            = ConvertAbilityBooleanLevelField(FourCC('Ihid')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_USE_TELEPORT_CLUSTERING_ITP2                           = ConvertAbilityBooleanLevelField(FourCC('Itp2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS                                = ConvertAbilityBooleanLevelField(FourCC('Eth1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DOES_NOT_BLOCK_BUILDINGS                               = ConvertAbilityBooleanLevelField(FourCC('Eth2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_AUTO_ACQUIRE_ATTACK_TARGETS                            = ConvertAbilityBooleanLevelField(FourCC('Gho1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS_GHO2                           = ConvertAbilityBooleanLevelField(FourCC('Gho2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DO_NOT_BLOCK_BUILDINGS                                 = ConvertAbilityBooleanLevelField(FourCC('Gho3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_INCLUDE_RANGED_DAMAGE                                  = ConvertAbilityBooleanLevelField(FourCC('Ssk4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_INCLUDE_MELEE_DAMAGE                                   = ConvertAbilityBooleanLevelField(FourCC('Ssk5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_MOVE_TO_PARTNER                                        = ConvertAbilityBooleanLevelField(FourCC('coa2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CAN_BE_DISPELLED                                       = ConvertAbilityBooleanLevelField(FourCC('cyc1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_IGNORE_FRIENDLY_BUFFS                                  = ConvertAbilityBooleanLevelField(FourCC('dvm6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DROP_ITEMS_ON_DEATH                                    = ConvertAbilityBooleanLevelField(FourCC('inv2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CAN_USE_ITEMS                                          = ConvertAbilityBooleanLevelField(FourCC('inv3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CAN_GET_ITEMS                                          = ConvertAbilityBooleanLevelField(FourCC('inv4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CAN_DROP_ITEMS                                         = ConvertAbilityBooleanLevelField(FourCC('inv5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_REPAIRS_ALLOWED                                        = ConvertAbilityBooleanLevelField(FourCC('liq4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_CASTER_ONLY_SPLASH                                     = ConvertAbilityBooleanLevelField(FourCC('mfl6')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_NO_TARGET_REQUIRED_IRL4                                = ConvertAbilityBooleanLevelField(FourCC('irl4')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DISPEL_ON_ATTACK                                       = ConvertAbilityBooleanLevelField(FourCC('irl5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_AMOUNT_IS_RAW_VALUE                                    = ConvertAbilityBooleanLevelField(FourCC('ipv3')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_SHARED_SPELL_COOLDOWN                                  = ConvertAbilityBooleanLevelField(FourCC('spb2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_SLEEP_ONCE                                             = ConvertAbilityBooleanLevelField(FourCC('sla1')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ALLOW_ON_ANY_PLAYER_SLOT                               = ConvertAbilityBooleanLevelField(FourCC('sla2')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_DISABLE_OTHER_ABILITIES                                = ConvertAbilityBooleanLevelField(FourCC('Ncl5')) ---@type abilitybooleanlevelfield 
    ABILITY_BLF_ALLOW_BOUNTY                                           = ConvertAbilityBooleanLevelField(FourCC('Ntm4')) ---@type abilitybooleanlevelfield 

    ABILITY_SLF_ICON_NORMAL                                            = ConvertAbilityStringLevelField(FourCC('aart')) ---@type abilitystringlevelfield 
    ABILITY_SLF_CASTER                                                 = ConvertAbilityStringLevelField(FourCC('acat')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TARGET                                                 = ConvertAbilityStringLevelField(FourCC('atat')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SPECIAL                                                = ConvertAbilityStringLevelField(FourCC('asat')) ---@type abilitystringlevelfield 
    ABILITY_SLF_EFFECT                                                 = ConvertAbilityStringLevelField(FourCC('aeat')) ---@type abilitystringlevelfield 
    ABILITY_SLF_AREA_EFFECT                                            = ConvertAbilityStringLevelField(FourCC('aaea')) ---@type abilitystringlevelfield 
    ABILITY_SLF_LIGHTNING_EFFECTS                                      = ConvertAbilityStringLevelField(FourCC('alig')) ---@type abilitystringlevelfield 
    ABILITY_SLF_MISSILE_ART                                            = ConvertAbilityStringLevelField(FourCC('amat')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_LEARN                                          = ConvertAbilityStringLevelField(FourCC('aret')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_LEARN_EXTENDED                                 = ConvertAbilityStringLevelField(FourCC('arut')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_NORMAL                                         = ConvertAbilityStringLevelField(FourCC('atp1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_TURN_OFF                                       = ConvertAbilityStringLevelField(FourCC('aut1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED                                = ConvertAbilityStringLevelField(FourCC('aub1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED                              = ConvertAbilityStringLevelField(FourCC('auu1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_NORMAL_FORM_UNIT_EME1                                  = ConvertAbilityStringLevelField(FourCC('Eme1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SPAWNED_UNITS                                          = ConvertAbilityStringLevelField(FourCC('Ndp1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ABILITY_FOR_UNIT_CREATION                              = ConvertAbilityStringLevelField(FourCC('Nrc1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_NORMAL_FORM_UNIT_MIL1                                  = ConvertAbilityStringLevelField(FourCC('Mil1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ALTERNATE_FORM_UNIT_MIL2                               = ConvertAbilityStringLevelField(FourCC('Mil2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_BASE_ORDER_ID_ANS5                                     = ConvertAbilityStringLevelField(FourCC('Ans5')) ---@type abilitystringlevelfield 
    ABILITY_SLF_MORPH_UNITS_GROUND                                     = ConvertAbilityStringLevelField(FourCC('Ply2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_MORPH_UNITS_AIR                                        = ConvertAbilityStringLevelField(FourCC('Ply3')) ---@type abilitystringlevelfield 
    ABILITY_SLF_MORPH_UNITS_AMPHIBIOUS                                 = ConvertAbilityStringLevelField(FourCC('Ply4')) ---@type abilitystringlevelfield 
    ABILITY_SLF_MORPH_UNITS_WATER                                      = ConvertAbilityStringLevelField(FourCC('Ply5')) ---@type abilitystringlevelfield 
    ABILITY_SLF_UNIT_TYPE_ONE                                          = ConvertAbilityStringLevelField(FourCC('Rai3')) ---@type abilitystringlevelfield 
    ABILITY_SLF_UNIT_TYPE_TWO                                          = ConvertAbilityStringLevelField(FourCC('Rai4')) ---@type abilitystringlevelfield 
    ABILITY_SLF_UNIT_TYPE_SOD2                                         = ConvertAbilityStringLevelField(FourCC('Sod2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SUMMON_1_UNIT_TYPE                                     = ConvertAbilityStringLevelField(FourCC('Ist1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SUMMON_2_UNIT_TYPE                                     = ConvertAbilityStringLevelField(FourCC('Ist2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_RACE_TO_CONVERT                                        = ConvertAbilityStringLevelField(FourCC('Ndc1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_PARTNER_UNIT_TYPE                                      = ConvertAbilityStringLevelField(FourCC('coa1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_PARTNER_UNIT_TYPE_ONE                                  = ConvertAbilityStringLevelField(FourCC('dcp1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_PARTNER_UNIT_TYPE_TWO                                  = ConvertAbilityStringLevelField(FourCC('dcp2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_REQUIRED_UNIT_TYPE                                     = ConvertAbilityStringLevelField(FourCC('tpi1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_CONVERTED_UNIT_TYPE                                    = ConvertAbilityStringLevelField(FourCC('tpi2')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SPELL_LIST                                             = ConvertAbilityStringLevelField(FourCC('spb1')) ---@type abilitystringlevelfield 
    ABILITY_SLF_BASE_ORDER_ID_SPB5                                     = ConvertAbilityStringLevelField(FourCC('spb5')) ---@type abilitystringlevelfield 
    ABILITY_SLF_BASE_ORDER_ID_NCL6                                     = ConvertAbilityStringLevelField(FourCC('Ncl6')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ABILITY_UPGRADE_1                                      = ConvertAbilityStringLevelField(FourCC('Neg3')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ABILITY_UPGRADE_2                                      = ConvertAbilityStringLevelField(FourCC('Neg4')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ABILITY_UPGRADE_3                                      = ConvertAbilityStringLevelField(FourCC('Neg5')) ---@type abilitystringlevelfield 
    ABILITY_SLF_ABILITY_UPGRADE_4                                      = ConvertAbilityStringLevelField(FourCC('Neg6')) ---@type abilitystringlevelfield 
    ABILITY_SLF_SPAWN_UNIT_ID_NSY2                                     = ConvertAbilityStringLevelField(FourCC('Nsy2')) ---@type abilitystringlevelfield 

    -- Item
    ITEM_IF_LEVEL                                  = ConvertItemIntegerField(FourCC('ilev')) ---@type itemintegerfield 
    ITEM_IF_NUMBER_OF_CHARGES                      = ConvertItemIntegerField(FourCC('iuse')) ---@type itemintegerfield 
    ITEM_IF_COOLDOWN_GROUP                         = ConvertItemIntegerField(FourCC('icid')) ---@type itemintegerfield 
    ITEM_IF_MAX_HIT_POINTS                         = ConvertItemIntegerField(FourCC('ihtp')) ---@type itemintegerfield 
    ITEM_IF_HIT_POINTS                             = ConvertItemIntegerField(FourCC('ihpc')) ---@type itemintegerfield 
    ITEM_IF_PRIORITY                               = ConvertItemIntegerField(FourCC('ipri')) ---@type itemintegerfield 
    ITEM_IF_ARMOR_TYPE                             = ConvertItemIntegerField(FourCC('iarm')) ---@type itemintegerfield 
    ITEM_IF_TINTING_COLOR_RED                      = ConvertItemIntegerField(FourCC('iclr')) ---@type itemintegerfield 
    ITEM_IF_TINTING_COLOR_GREEN                    = ConvertItemIntegerField(FourCC('iclg')) ---@type itemintegerfield 
    ITEM_IF_TINTING_COLOR_BLUE                     = ConvertItemIntegerField(FourCC('iclb')) ---@type itemintegerfield 
    ITEM_IF_TINTING_COLOR_ALPHA                    = ConvertItemIntegerField(FourCC('ical')) ---@type itemintegerfield 

    ITEM_RF_SCALING_VALUE                          = ConvertItemRealField(FourCC('isca')) ---@type itemrealfield 

    ITEM_BF_DROPPED_WHEN_CARRIER_DIES                          = ConvertItemBooleanField(FourCC('idrp')) ---@type itembooleanfield 
    ITEM_BF_CAN_BE_DROPPED                                     = ConvertItemBooleanField(FourCC('idro')) ---@type itembooleanfield 
    ITEM_BF_PERISHABLE                                         = ConvertItemBooleanField(FourCC('iper')) ---@type itembooleanfield 
    ITEM_BF_INCLUDE_AS_RANDOM_CHOICE                           = ConvertItemBooleanField(FourCC('iprn')) ---@type itembooleanfield 
    ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED                    = ConvertItemBooleanField(FourCC('ipow')) ---@type itembooleanfield 
    ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS                           = ConvertItemBooleanField(FourCC('ipaw')) ---@type itembooleanfield 
    ITEM_BF_ACTIVELY_USED                                      = ConvertItemBooleanField(FourCC('iusa')) ---@type itembooleanfield 

    ITEM_SF_MODEL_USED                                         = ConvertItemStringField(FourCC('ifil')) ---@type itemstringfield 

    -- Unit
    UNIT_IF_DEFENSE_TYPE                                           = ConvertUnitIntegerField(FourCC('udty')) ---@type unitintegerfield 
    UNIT_IF_ARMOR_TYPE                                             = ConvertUnitIntegerField(FourCC('uarm')) ---@type unitintegerfield 
    UNIT_IF_LOOPING_FADE_IN_RATE                                   = ConvertUnitIntegerField(FourCC('ulfi')) ---@type unitintegerfield 
    UNIT_IF_LOOPING_FADE_OUT_RATE                                  = ConvertUnitIntegerField(FourCC('ulfo')) ---@type unitintegerfield 
    UNIT_IF_AGILITY                                                = ConvertUnitIntegerField(FourCC('uagc')) ---@type unitintegerfield 
    UNIT_IF_INTELLIGENCE                                           = ConvertUnitIntegerField(FourCC('uinc')) ---@type unitintegerfield 
    UNIT_IF_STRENGTH                                               = ConvertUnitIntegerField(FourCC('ustc')) ---@type unitintegerfield 
    UNIT_IF_AGILITY_PERMANENT                                      = ConvertUnitIntegerField(FourCC('uagm')) ---@type unitintegerfield 
    UNIT_IF_INTELLIGENCE_PERMANENT                                 = ConvertUnitIntegerField(FourCC('uinm')) ---@type unitintegerfield 
    UNIT_IF_STRENGTH_PERMANENT                                     = ConvertUnitIntegerField(FourCC('ustm')) ---@type unitintegerfield 
    UNIT_IF_AGILITY_WITH_BONUS                                     = ConvertUnitIntegerField(FourCC('uagb')) ---@type unitintegerfield 
    UNIT_IF_INTELLIGENCE_WITH_BONUS                                = ConvertUnitIntegerField(FourCC('uinb')) ---@type unitintegerfield 
    UNIT_IF_STRENGTH_WITH_BONUS                                    = ConvertUnitIntegerField(FourCC('ustb')) ---@type unitintegerfield 
    UNIT_IF_GOLD_BOUNTY_AWARDED_NUMBER_OF_DICE                     = ConvertUnitIntegerField(FourCC('ubdi')) ---@type unitintegerfield 
    UNIT_IF_GOLD_BOUNTY_AWARDED_BASE                               = ConvertUnitIntegerField(FourCC('ubba')) ---@type unitintegerfield 
    UNIT_IF_GOLD_BOUNTY_AWARDED_SIDES_PER_DIE                      = ConvertUnitIntegerField(FourCC('ubsi')) ---@type unitintegerfield 
    UNIT_IF_LUMBER_BOUNTY_AWARDED_NUMBER_OF_DICE                   = ConvertUnitIntegerField(FourCC('ulbd')) ---@type unitintegerfield 
    UNIT_IF_LUMBER_BOUNTY_AWARDED_BASE                             = ConvertUnitIntegerField(FourCC('ulba')) ---@type unitintegerfield 
    UNIT_IF_LUMBER_BOUNTY_AWARDED_SIDES_PER_DIE                    = ConvertUnitIntegerField(FourCC('ulbs')) ---@type unitintegerfield 
    UNIT_IF_LEVEL                                                  = ConvertUnitIntegerField(FourCC('ulev')) ---@type unitintegerfield 
    UNIT_IF_FORMATION_RANK                                         = ConvertUnitIntegerField(FourCC('ufor')) ---@type unitintegerfield 
    UNIT_IF_ORIENTATION_INTERPOLATION                              = ConvertUnitIntegerField(FourCC('uori')) ---@type unitintegerfield 
    UNIT_IF_ELEVATION_SAMPLE_POINTS                                = ConvertUnitIntegerField(FourCC('uept')) ---@type unitintegerfield 
    UNIT_IF_TINTING_COLOR_RED                                      = ConvertUnitIntegerField(FourCC('uclr')) ---@type unitintegerfield 
    UNIT_IF_TINTING_COLOR_GREEN                                    = ConvertUnitIntegerField(FourCC('uclg')) ---@type unitintegerfield 
    UNIT_IF_TINTING_COLOR_BLUE                                     = ConvertUnitIntegerField(FourCC('uclb')) ---@type unitintegerfield 
    UNIT_IF_TINTING_COLOR_ALPHA                                    = ConvertUnitIntegerField(FourCC('ucal')) ---@type unitintegerfield 
    UNIT_IF_MOVE_TYPE                                              = ConvertUnitIntegerField(FourCC('umvt')) ---@type unitintegerfield 
    UNIT_IF_TARGETED_AS                                            = ConvertUnitIntegerField(FourCC('utar')) ---@type unitintegerfield 
    UNIT_IF_UNIT_CLASSIFICATION                                    = ConvertUnitIntegerField(FourCC('utyp')) ---@type unitintegerfield 
    UNIT_IF_HIT_POINTS_REGENERATION_TYPE                           = ConvertUnitIntegerField(FourCC('uhrt')) ---@type unitintegerfield 
    UNIT_IF_PLACEMENT_PREVENTED_BY                                 = ConvertUnitIntegerField(FourCC('upar')) ---@type unitintegerfield 
    UNIT_IF_PRIMARY_ATTRIBUTE                                      = ConvertUnitIntegerField(FourCC('upra')) ---@type unitintegerfield 

    UNIT_RF_STRENGTH_PER_LEVEL                                     = ConvertUnitRealField(FourCC('ustp')) ---@type unitrealfield 
    UNIT_RF_AGILITY_PER_LEVEL                                      = ConvertUnitRealField(FourCC('uagp')) ---@type unitrealfield 
    UNIT_RF_INTELLIGENCE_PER_LEVEL                                 = ConvertUnitRealField(FourCC('uinp')) ---@type unitrealfield 
    UNIT_RF_HIT_POINTS_REGENERATION_RATE                           = ConvertUnitRealField(FourCC('uhpr')) ---@type unitrealfield 
    UNIT_RF_MANA_REGENERATION                                      = ConvertUnitRealField(FourCC('umpr')) ---@type unitrealfield 
    UNIT_RF_DEATH_TIME                                             = ConvertUnitRealField(FourCC('udtm')) ---@type unitrealfield 
    UNIT_RF_FLY_HEIGHT                                             = ConvertUnitRealField(FourCC('ufyh')) ---@type unitrealfield 
    UNIT_RF_TURN_RATE                                              = ConvertUnitRealField(FourCC('umvr')) ---@type unitrealfield 
    UNIT_RF_ELEVATION_SAMPLE_RADIUS                                = ConvertUnitRealField(FourCC('uerd')) ---@type unitrealfield 
    UNIT_RF_FOG_OF_WAR_SAMPLE_RADIUS                               = ConvertUnitRealField(FourCC('ufrd')) ---@type unitrealfield 
    UNIT_RF_MAXIMUM_PITCH_ANGLE_DEGREES                            = ConvertUnitRealField(FourCC('umxp')) ---@type unitrealfield 
    UNIT_RF_MAXIMUM_ROLL_ANGLE_DEGREES                             = ConvertUnitRealField(FourCC('umxr')) ---@type unitrealfield 
    UNIT_RF_SCALING_VALUE                                          = ConvertUnitRealField(FourCC('usca')) ---@type unitrealfield 
    UNIT_RF_ANIMATION_RUN_SPEED                                    = ConvertUnitRealField(FourCC('urun')) ---@type unitrealfield 
    UNIT_RF_SELECTION_SCALE                                        = ConvertUnitRealField(FourCC('ussc')) ---@type unitrealfield 
    UNIT_RF_SELECTION_CIRCLE_HEIGHT                                = ConvertUnitRealField(FourCC('uslz')) ---@type unitrealfield 
    UNIT_RF_SHADOW_IMAGE_HEIGHT                                    = ConvertUnitRealField(FourCC('ushh')) ---@type unitrealfield 
    UNIT_RF_SHADOW_IMAGE_WIDTH                                     = ConvertUnitRealField(FourCC('ushw')) ---@type unitrealfield 
    UNIT_RF_SHADOW_IMAGE_CENTER_X                                  = ConvertUnitRealField(FourCC('ushx')) ---@type unitrealfield 
    UNIT_RF_SHADOW_IMAGE_CENTER_Y                                  = ConvertUnitRealField(FourCC('ushy')) ---@type unitrealfield 
    UNIT_RF_ANIMATION_WALK_SPEED                                   = ConvertUnitRealField(FourCC('uwal')) ---@type unitrealfield 
    UNIT_RF_DEFENSE                                                = ConvertUnitRealField(FourCC('udfc')) ---@type unitrealfield 
    UNIT_RF_SIGHT_RADIUS                                           = ConvertUnitRealField(FourCC('usir')) ---@type unitrealfield 
    UNIT_RF_PRIORITY                                               = ConvertUnitRealField(FourCC('upri')) ---@type unitrealfield 
    UNIT_RF_SPEED                                                  = ConvertUnitRealField(FourCC('umvc')) ---@type unitrealfield 
    UNIT_RF_OCCLUDER_HEIGHT                                        = ConvertUnitRealField(FourCC('uocc')) ---@type unitrealfield 
    UNIT_RF_HP                                                     = ConvertUnitRealField(FourCC('uhpc')) ---@type unitrealfield 
    UNIT_RF_MANA                                                   = ConvertUnitRealField(FourCC('umpc')) ---@type unitrealfield 
    UNIT_RF_ACQUISITION_RANGE                                      = ConvertUnitRealField(FourCC('uacq')) ---@type unitrealfield 
    UNIT_RF_CAST_BACK_SWING                                        = ConvertUnitRealField(FourCC('ucbs')) ---@type unitrealfield 
    UNIT_RF_CAST_POINT                                             = ConvertUnitRealField(FourCC('ucpt')) ---@type unitrealfield 
    UNIT_RF_MINIMUM_ATTACK_RANGE                                   = ConvertUnitRealField(FourCC('uamn')) ---@type unitrealfield 

    UNIT_BF_RAISABLE                                               = ConvertUnitBooleanField(FourCC('urai')) ---@type unitbooleanfield 
    UNIT_BF_DECAYABLE                                              = ConvertUnitBooleanField(FourCC('udec')) ---@type unitbooleanfield 
    UNIT_BF_IS_A_BUILDING                                          = ConvertUnitBooleanField(FourCC('ubdg')) ---@type unitbooleanfield 
    UNIT_BF_USE_EXTENDED_LINE_OF_SIGHT                             = ConvertUnitBooleanField(FourCC('ulos')) ---@type unitbooleanfield 
    UNIT_BF_NEUTRAL_BUILDING_SHOWS_MINIMAP_ICON                    = ConvertUnitBooleanField(FourCC('unbm')) ---@type unitbooleanfield 
    UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON                          = ConvertUnitBooleanField(FourCC('uhhb')) ---@type unitbooleanfield 
    UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY                         = ConvertUnitBooleanField(FourCC('uhhm')) ---@type unitbooleanfield 
    UNIT_BF_HERO_HIDE_HERO_DEATH_MESSAGE                           = ConvertUnitBooleanField(FourCC('uhhd')) ---@type unitbooleanfield 
    UNIT_BF_HIDE_MINIMAP_DISPLAY                                   = ConvertUnitBooleanField(FourCC('uhom')) ---@type unitbooleanfield 
    UNIT_BF_SCALE_PROJECTILES                                      = ConvertUnitBooleanField(FourCC('uscb')) ---@type unitbooleanfield 
    UNIT_BF_SELECTION_CIRCLE_ON_WATER                              = ConvertUnitBooleanField(FourCC('usew')) ---@type unitbooleanfield 
    UNIT_BF_HAS_WATER_SHADOW                                       = ConvertUnitBooleanField(FourCC('ushr')) ---@type unitbooleanfield 

    UNIT_SF_NAME                                   = ConvertUnitStringField(FourCC('unam')) ---@type unitstringfield 
    UNIT_SF_PROPER_NAMES                           = ConvertUnitStringField(FourCC('upro')) ---@type unitstringfield 
    UNIT_SF_GROUND_TEXTURE                         = ConvertUnitStringField(FourCC('uubs')) ---@type unitstringfield 
    UNIT_SF_SHADOW_IMAGE_UNIT                      = ConvertUnitStringField(FourCC('ushu')) ---@type unitstringfield 

    -- Unit Weapon
    UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE                            = ConvertUnitWeaponIntegerField(FourCC('ua1d')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE                                      = ConvertUnitWeaponIntegerField(FourCC('ua1b')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE                             = ConvertUnitWeaponIntegerField(FourCC('ua1s')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_MAXIMUM_NUMBER_OF_TARGETS                        = ConvertUnitWeaponIntegerField(FourCC('utc1')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE                                      = ConvertUnitWeaponIntegerField(FourCC('ua1t')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_WEAPON_SOUND                                     = ConvertUnitWeaponIntegerField(FourCC('ucs1')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_AREA_OF_EFFECT_TARGETS                           = ConvertUnitWeaponIntegerField(FourCC('ua1p')) ---@type unitweaponintegerfield 
    UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED                                  = ConvertUnitWeaponIntegerField(FourCC('ua1g')) ---@type unitweaponintegerfield 

    UNIT_WEAPON_RF_ATTACK_BACKSWING_POINT                                  = ConvertUnitWeaponRealField(FourCC('ubs1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_POINT                                     = ConvertUnitWeaponRealField(FourCC('udp1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN                                    = ConvertUnitWeaponRealField(FourCC('ua1c')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_LOSS_FACTOR                               = ConvertUnitWeaponRealField(FourCC('udl1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_MEDIUM                             = ConvertUnitWeaponRealField(FourCC('uhd1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_SMALL                              = ConvertUnitWeaponRealField(FourCC('uqd1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_DISTANCE                            = ConvertUnitWeaponRealField(FourCC('usd1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_RADIUS                              = ConvertUnitWeaponRealField(FourCC('usr1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_PROJECTILE_SPEED                                 = ConvertUnitWeaponRealField(FourCC('ua1z')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_PROJECTILE_ARC                                   = ConvertUnitWeaponRealField(FourCC('uma1')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_FULL_DAMAGE                       = ConvertUnitWeaponRealField(FourCC('ua1f')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_MEDIUM_DAMAGE                     = ConvertUnitWeaponRealField(FourCC('ua1h')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE                      = ConvertUnitWeaponRealField(FourCC('ua1q')) ---@type unitweaponrealfield 
    UNIT_WEAPON_RF_ATTACK_RANGE                                            = ConvertUnitWeaponRealField(FourCC('ua1r')) ---@type unitweaponrealfield 

    UNIT_WEAPON_BF_ATTACK_SHOW_UI                                          = ConvertUnitWeaponBooleanField(FourCC('uwu1')) ---@type unitweaponbooleanfield 
    UNIT_WEAPON_BF_ATTACKS_ENABLED                                         = ConvertUnitWeaponBooleanField(FourCC('uaen')) ---@type unitweaponbooleanfield 
    UNIT_WEAPON_BF_ATTACK_PROJECTILE_HOMING_ENABLED                        = ConvertUnitWeaponBooleanField(FourCC('umh1')) ---@type unitweaponbooleanfield 
    
    UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART                                   = ConvertUnitWeaponStringField(FourCC('ua1m')) ---@type unitweaponstringfield 

    -- Move Type
    MOVE_TYPE_UNKNOWN                              = ConvertMoveType(0) ---@type movetype 
    MOVE_TYPE_FOOT                                 = ConvertMoveType(1) ---@type movetype 
    MOVE_TYPE_FLY                                  = ConvertMoveType(2) ---@type movetype 
    MOVE_TYPE_HORSE                                = ConvertMoveType(4) ---@type movetype 
    MOVE_TYPE_HOVER                                = ConvertMoveType(8) ---@type movetype 
    MOVE_TYPE_FLOAT                                = ConvertMoveType(16) ---@type movetype 
    MOVE_TYPE_AMPHIBIOUS                           = ConvertMoveType(32) ---@type movetype 
    MOVE_TYPE_UNBUILDABLE                          = ConvertMoveType(64) ---@type movetype 
    
    -- Target Flag
    TARGET_FLAG_NONE                               = ConvertTargetFlag(1) ---@type targetflag 
    TARGET_FLAG_GROUND                             = ConvertTargetFlag(2) ---@type targetflag 
    TARGET_FLAG_AIR                                = ConvertTargetFlag(4) ---@type targetflag 
    TARGET_FLAG_STRUCTURE                          = ConvertTargetFlag(8) ---@type targetflag 
    TARGET_FLAG_WARD                               = ConvertTargetFlag(16) ---@type targetflag 
    TARGET_FLAG_ITEM                               = ConvertTargetFlag(32) ---@type targetflag 
    TARGET_FLAG_TREE                               = ConvertTargetFlag(64) ---@type targetflag 
    TARGET_FLAG_WALL                               = ConvertTargetFlag(128) ---@type targetflag 
    TARGET_FLAG_DEBRIS                             = ConvertTargetFlag(256) ---@type targetflag 
    TARGET_FLAG_DECORATION                         = ConvertTargetFlag(512) ---@type targetflag 
    TARGET_FLAG_BRIDGE                             = ConvertTargetFlag(1024) ---@type targetflag 

    -- defense type
    DEFENSE_TYPE_LIGHT                             = ConvertDefenseType(0) ---@type defensetype 
    DEFENSE_TYPE_MEDIUM                            = ConvertDefenseType(1) ---@type defensetype 
    DEFENSE_TYPE_LARGE                             = ConvertDefenseType(2) ---@type defensetype 
    DEFENSE_TYPE_FORT                              = ConvertDefenseType(3) ---@type defensetype 
    DEFENSE_TYPE_NORMAL                            = ConvertDefenseType(4) ---@type defensetype 
    DEFENSE_TYPE_HERO                              = ConvertDefenseType(5) ---@type defensetype 
    DEFENSE_TYPE_DIVINE                            = ConvertDefenseType(6) ---@type defensetype 
    DEFENSE_TYPE_NONE                              = ConvertDefenseType(7) ---@type defensetype 

    -- Hero Attribute
    HERO_ATTRIBUTE_STR                             = ConvertHeroAttribute(1) ---@type heroattribute 
    HERO_ATTRIBUTE_INT                             = ConvertHeroAttribute(2) ---@type heroattribute 
    HERO_ATTRIBUTE_AGI                             = ConvertHeroAttribute(3) ---@type heroattribute 

    -- Armor Type
    ARMOR_TYPE_WHOKNOWS                            = ConvertArmorType(0) ---@type armortype 
    ARMOR_TYPE_FLESH                               = ConvertArmorType(1) ---@type armortype 
    ARMOR_TYPE_METAL                               = ConvertArmorType(2) ---@type armortype 
    ARMOR_TYPE_WOOD                                = ConvertArmorType(3) ---@type armortype 
    ARMOR_TYPE_ETHREAL                             = ConvertArmorType(4) ---@type armortype 
    ARMOR_TYPE_STONE                               = ConvertArmorType(5) ---@type armortype 

    -- Regeneration Type
    REGENERATION_TYPE_NONE                         = ConvertRegenType(0) ---@type regentype 
    REGENERATION_TYPE_ALWAYS                       = ConvertRegenType(1) ---@type regentype 
    REGENERATION_TYPE_BLIGHT                       = ConvertRegenType(2) ---@type regentype 
    REGENERATION_TYPE_DAY                          = ConvertRegenType(3) ---@type regentype 
    REGENERATION_TYPE_NIGHT                        = ConvertRegenType(4) ---@type regentype 

    -- Unit Category
    UNIT_CATEGORY_GIANT                            = ConvertUnitCategory(1) ---@type unitcategory 
    UNIT_CATEGORY_UNDEAD                           = ConvertUnitCategory(2) ---@type unitcategory 
    UNIT_CATEGORY_SUMMONED                         = ConvertUnitCategory(4) ---@type unitcategory 
    UNIT_CATEGORY_MECHANICAL                       = ConvertUnitCategory(8) ---@type unitcategory 
    UNIT_CATEGORY_PEON                             = ConvertUnitCategory(16) ---@type unitcategory 
    UNIT_CATEGORY_SAPPER                           = ConvertUnitCategory(32) ---@type unitcategory 
    UNIT_CATEGORY_TOWNHALL                         = ConvertUnitCategory(64) ---@type unitcategory 
    UNIT_CATEGORY_ANCIENT                          = ConvertUnitCategory(128) ---@type unitcategory 
    UNIT_CATEGORY_NEUTRAL                          = ConvertUnitCategory(256) ---@type unitcategory 
    UNIT_CATEGORY_WARD                             = ConvertUnitCategory(512) ---@type unitcategory 
    UNIT_CATEGORY_STANDON                          = ConvertUnitCategory(1024) ---@type unitcategory 
    UNIT_CATEGORY_TAUREN                           = ConvertUnitCategory(2048) ---@type unitcategory 

    -- Pathing Flag
    PATHING_FLAG_UNWALKABLE                            = ConvertPathingFlag(2) ---@type pathingflag 
    PATHING_FLAG_UNFLYABLE                             = ConvertPathingFlag(4) ---@type pathingflag 
    PATHING_FLAG_UNBUILDABLE                           = ConvertPathingFlag(8) ---@type pathingflag 
    PATHING_FLAG_UNPEONHARVEST                         = ConvertPathingFlag(16) ---@type pathingflag 
    PATHING_FLAG_BLIGHTED                              = ConvertPathingFlag(32) ---@type pathingflag 
    PATHING_FLAG_UNFLOATABLE                           = ConvertPathingFlag(64) ---@type pathingflag 
    PATHING_FLAG_UNAMPHIBIOUS                          = ConvertPathingFlag(128) ---@type pathingflag 
    PATHING_FLAG_UNITEMPLACABLE                        = ConvertPathingFlag(256) ---@type pathingflag 



--============================================================================
-- MathAPI
Deg2Rad=nil  ---@type fun(degrees: number): number (native)
Rad2Deg=nil  ---@type fun(radians: number): number (native)

Sin=nil      ---@type fun(radians: number): number (native)
Cos=nil      ---@type fun(radians: number): number (native)
Tan=nil      ---@type fun(radians: number): number (native)

-- Expect values between -1 and 1...returns 0 for invalid input
Asin=nil     ---@type fun(y: number): number (native)
Acos=nil     ---@type fun(x: number): number (native)

Atan=nil     ---@type fun(x: number): number (native)

-- Returns 0 if x and y are both 0
Atan2=nil    ---@type fun(y: number, x: number): number (native)

-- Returns 0 if x <= 0
SquareRoot=nil ---@type fun(x: number): number (native)

-- computes x to the y power
-- y == 0.0             => 1
-- x ==0.0 and y < 0    => 0
--
Pow=nil      ---@type fun(x: number, power: number): number (native)

MathRound=nil ---@type fun(r: number): integer (native)

--============================================================================
-- String Utility API
I2R=nil  ---@type fun(i: integer): number (native)
R2I=nil  ---@type fun(r: number): integer (native)
I2S=nil  ---@type fun(i: integer): string (native)
R2S=nil  ---@type fun(r: number): string (native)
R2SW=nil ---@type fun(r: number, width: integer, precision: integer): string (native)
S2I=nil  ---@type fun(s: string): integer (native)
S2R=nil  ---@type fun(s: string): number (native)
GetHandleId=nil ---@type fun(h: handle): integer (native)
SubString=nil ---@type fun(source: string, start: integer, end_: integer): string (native)
StringLength=nil ---@type fun(s: string): integer (native)
StringCase=nil ---@type fun(source: string, upper: boolean): string (native)
StringHash=nil ---@type fun(s: string): integer (native)

GetLocalizedString=nil ---@type fun(source: string): string (native)
GetLocalizedHotkey=nil ---@type fun(source: string): integer (native)

--============================================================================
-- Map Setup API
--
--  These are native functions for describing the map configuration
--  these funcs should only be used in the "config" function of
--  a map script. The functions should also be called in this order
--  ( i.e. call SetPlayers before SetPlayerColor...
--

SetMapName=nil           ---@type fun(name: string) (native)
SetMapDescription=nil    ---@type fun(description: string) (native)

SetTeams=nil             ---@type fun(teamcount: integer) (native)
SetPlayers=nil           ---@type fun(playercount: integer) (native)

DefineStartLocation=nil          ---@type fun(whichStartLoc: integer, x: number, y: number) (native)
DefineStartLocationLoc=nil       ---@type fun(whichStartLoc: integer, whichLocation: location) (native)
SetStartLocPrioCount=nil         ---@type fun(whichStartLoc: integer, prioSlotCount: integer) (native)
SetStartLocPrio=nil              ---@type fun(whichStartLoc: integer, prioSlotIndex: integer, otherStartLocIndex: integer, priority: startlocprio) (native)
GetStartLocPrioSlot=nil          ---@type fun(whichStartLoc: integer, prioSlotIndex: integer): integer (native)
GetStartLocPrio=nil              ---@type fun(whichStartLoc: integer, prioSlotIndex: integer): startlocprio (native)
SetEnemyStartLocPrioCount=nil    ---@type fun(whichStartLoc: integer, prioSlotCount: integer) (native)
SetEnemyStartLocPrio=nil         ---@type fun(whichStartLoc: integer, prioSlotIndex: integer, otherStartLocIndex: integer, priority: startlocprio) (native)

SetGameTypeSupported=nil ---@type fun(whichGameType: gametype, value: boolean) (native)
SetMapFlag=nil           ---@type fun(whichMapFlag: mapflag, value: boolean) (native)
SetGamePlacement=nil     ---@type fun(whichPlacementType: placement) (native)
SetGameSpeed=nil         ---@type fun(whichspeed: gamespeed) (native)
SetGameDifficulty=nil    ---@type fun(whichdifficulty: gamedifficulty) (native)
SetResourceDensity=nil   ---@type fun(whichdensity: mapdensity) (native)
SetCreatureDensity=nil   ---@type fun(whichdensity: mapdensity) (native)

GetTeams=nil             ---@type fun(): integer (native)
GetPlayers=nil           ---@type fun(): integer (native)

IsGameTypeSupported=nil  ---@type fun(whichGameType: gametype): boolean (native)
GetGameTypeSelected=nil  ---@type fun(): gametype (native)
IsMapFlagSet=nil         ---@type fun(whichMapFlag: mapflag): boolean (native)

GetGamePlacement=nil     ---@type fun(): placement (native)
GetGameSpeed=nil         ---@type fun(): gamespeed (native)
GetGameDifficulty=nil    ---@type fun(): gamedifficulty (native)
GetResourceDensity=nil   ---@type fun(): mapdensity (native)
GetCreatureDensity=nil   ---@type fun(): mapdensity (native)
GetStartLocationX=nil    ---@type fun(whichStartLocation: integer): number (native)
GetStartLocationY=nil    ---@type fun(whichStartLocation: integer): number (native)
GetStartLocationLoc=nil  ---@type fun(whichStartLocation: integer): location (native)


SetPlayerTeam=nil            ---@type fun(whichPlayer: player, whichTeam: integer) (native)
SetPlayerStartLocation=nil   ---@type fun(whichPlayer: player, startLocIndex: integer) (native)
-- forces player to have the specified start loc and marks the start loc as occupied
-- which removes it from consideration for subsequently placed players
-- ( i.e. you can use this to put people in a fixed loc and then
--   use random placement for any unplaced players etc )
ForcePlayerStartLocation=nil ---@type fun(whichPlayer: player, startLocIndex: integer) (native)
SetPlayerColor=nil           ---@type fun(whichPlayer: player, color: playercolor) (native)
SetPlayerAlliance=nil        ---@type fun(sourcePlayer: player, otherPlayer: player, whichAllianceSetting: alliancetype, value: boolean) (native)
SetPlayerTaxRate=nil         ---@type fun(sourcePlayer: player, otherPlayer: player, whichResource: playerstate, rate: integer) (native)
SetPlayerRacePreference=nil  ---@type fun(whichPlayer: player, whichRacePreference: racepreference) (native)
SetPlayerRaceSelectable=nil  ---@type fun(whichPlayer: player, value: boolean) (native)
SetPlayerController=nil      ---@type fun(whichPlayer: player, controlType: mapcontrol) (native)
SetPlayerName=nil            ---@type fun(whichPlayer: player, name: string) (native)

SetPlayerOnScoreScreen=nil   ---@type fun(whichPlayer: player, flag: boolean) (native)

GetPlayerTeam=nil            ---@type fun(whichPlayer: player): integer (native)
GetPlayerStartLocation=nil   ---@type fun(whichPlayer: player): integer (native)
GetPlayerColor=nil           ---@type fun(whichPlayer: player): playercolor (native)
GetPlayerSelectable=nil      ---@type fun(whichPlayer: player): boolean (native)
GetPlayerController=nil      ---@type fun(whichPlayer: player): mapcontrol (native)
GetPlayerSlotState=nil       ---@type fun(whichPlayer: player): playerslotstate (native)
GetPlayerTaxRate=nil         ---@type fun(sourcePlayer: player, otherPlayer: player, whichResource: playerstate): integer (native)
IsPlayerRacePrefSet=nil      ---@type fun(whichPlayer: player, pref: racepreference): boolean (native)
GetPlayerName=nil            ---@type fun(whichPlayer: player): string (native)

--============================================================================
-- Timer API
--
CreateTimer=nil          ---@type fun(): timer (native)
DestroyTimer=nil         ---@type fun(whichTimer: timer) (native)
TimerStart=nil           ---@type fun(whichTimer: timer, timeout: number, periodic: boolean, handlerFunc?: function) (native)
TimerGetElapsed=nil      ---@type fun(whichTimer: timer): number (native)
TimerGetRemaining=nil    ---@type fun(whichTimer: timer): number (native)
TimerGetTimeout=nil      ---@type fun(whichTimer: timer): number (native)
PauseTimer=nil           ---@type fun(whichTimer: timer) (native)
ResumeTimer=nil          ---@type fun(whichTimer: timer) (native)
GetExpiredTimer=nil      ---@type fun(): timer (native)

--============================================================================
-- Group API
--
CreateGroup=nil                          ---@type fun(): group (native)
DestroyGroup=nil                         ---@type fun(whichGroup: group) (native)
GroupAddUnit=nil                         ---@type fun(whichGroup: group, whichUnit: unit): boolean (native)
GroupRemoveUnit=nil                      ---@type fun(whichGroup: group, whichUnit: unit): boolean (native)
BlzGroupAddGroupFast=nil                 ---@type fun(whichGroup: group, addGroup: group): integer (native)
BlzGroupRemoveGroupFast=nil              ---@type fun(whichGroup: group, removeGroup: group): integer (native)
GroupClear=nil                           ---@type fun(whichGroup: group) (native)
BlzGroupGetSize=nil                      ---@type fun(whichGroup: group): integer (native)
BlzGroupUnitAt=nil                       ---@type fun(whichGroup: group, index: integer): unit (native)
GroupEnumUnitsOfType=nil                 ---@type fun(whichGroup: group, unitname: string, filter?: boolexpr) (native)
GroupEnumUnitsOfPlayer=nil               ---@type fun(whichGroup: group, whichPlayer: player, filter?: boolexpr) (native)
GroupEnumUnitsOfTypeCounted=nil          ---@type fun(whichGroup: group, unitname: string, filter?: boolexpr, countLimit: integer) (native)
GroupEnumUnitsInRect=nil                 ---@type fun(whichGroup: group, r: rect, filter?: boolexpr) (native)
GroupEnumUnitsInRectCounted=nil          ---@type fun(whichGroup: group, r: rect, filter?: boolexpr, countLimit: integer) (native)
GroupEnumUnitsInRange=nil                ---@type fun(whichGroup: group, x: number, y: number, radius: number, filter?: boolexpr) (native)
GroupEnumUnitsInRangeOfLoc=nil           ---@type fun(whichGroup: group, whichLocation: location, radius: number, filter?: boolexpr) (native)
GroupEnumUnitsInRangeCounted=nil         ---@type fun(whichGroup: group, x: number, y: number, radius: number, filter?: boolexpr, countLimit: integer) (native)
GroupEnumUnitsInRangeOfLocCounted=nil    ---@type fun(whichGroup: group, whichLocation: location, radius: number, filter?: boolexpr, countLimit: integer) (native)
GroupEnumUnitsSelected=nil               ---@type fun(whichGroup: group, whichPlayer: player, filter?: boolexpr) (native)

GroupImmediateOrder=nil                  ---@type fun(whichGroup: group, order: string): boolean (native)
GroupImmediateOrderById=nil              ---@type fun(whichGroup: group, order: integer): boolean (native)
GroupPointOrder=nil                      ---@type fun(whichGroup: group, order: string, x: number, y: number): boolean (native)
GroupPointOrderLoc=nil                   ---@type fun(whichGroup: group, order: string, whichLocation: location): boolean (native)
GroupPointOrderById=nil                  ---@type fun(whichGroup: group, order: integer, x: number, y: number): boolean (native)
GroupPointOrderByIdLoc=nil               ---@type fun(whichGroup: group, order: integer, whichLocation: location): boolean (native)
GroupTargetOrder=nil                     ---@type fun(whichGroup: group, order: string, targetWidget: widget): boolean (native)
GroupTargetOrderById=nil                 ---@type fun(whichGroup: group, order: integer, targetWidget: widget): boolean (native)

-- This will be difficult to support with potentially disjoint, cell-based regions
-- as it would involve enumerating all the cells that are covered by a particularregion
-- a better implementation would be a trigger that adds relevant units as they enter
-- and removes them if they leave...
ForGroup=nil                 ---@type fun(whichGroup: group, callback: function) (native)
FirstOfGroup=nil             ---@type fun(whichGroup: group): unit (native)

--============================================================================
-- Force API
--
CreateForce=nil              ---@type fun(): force (native)
DestroyForce=nil             ---@type fun(whichForce: force) (native)
ForceAddPlayer=nil           ---@type fun(whichForce: force, whichPlayer: player) (native)
ForceRemovePlayer=nil        ---@type fun(whichForce: force, whichPlayer: player) (native)
BlzForceHasPlayer=nil        ---@type fun(whichForce: force, whichPlayer: player): boolean (native)
ForceClear=nil               ---@type fun(whichForce: force) (native)
ForceEnumPlayers=nil         ---@type fun(whichForce: force, filter?: boolexpr) (native)
ForceEnumPlayersCounted=nil  ---@type fun(whichForce: force, filter?: boolexpr, countLimit: integer) (native)
ForceEnumAllies=nil          ---@type fun(whichForce: force, whichPlayer: player, filter?: boolexpr) (native)
ForceEnumEnemies=nil         ---@type fun(whichForce: force, whichPlayer: player, filter?: boolexpr) (native)
ForForce=nil                 ---@type fun(whichForce: force, callback: function) (native)

--============================================================================
-- Region and Location API
--
Rect=nil                     ---@type fun(minx: number, miny: number, maxx: number, maxy: number): rect (native)
RectFromLoc=nil              ---@type fun(min: location, max: location): rect (native)
RemoveRect=nil               ---@type fun(whichRect: rect) (native)
SetRect=nil                  ---@type fun(whichRect: rect, minx: number, miny: number, maxx: number, maxy: number) (native)
SetRectFromLoc=nil           ---@type fun(whichRect: rect, min: location, max: location) (native)
MoveRectTo=nil               ---@type fun(whichRect: rect, newCenterX: number, newCenterY: number) (native)
MoveRectToLoc=nil            ---@type fun(whichRect: rect, newCenterLoc: location) (native)

GetRectCenterX=nil           ---@type fun(whichRect: rect): number (native)
GetRectCenterY=nil           ---@type fun(whichRect: rect): number (native)
GetRectMinX=nil              ---@type fun(whichRect: rect): number (native)
GetRectMinY=nil              ---@type fun(whichRect: rect): number (native)
GetRectMaxX=nil              ---@type fun(whichRect: rect): number (native)
GetRectMaxY=nil              ---@type fun(whichRect: rect): number (native)

CreateRegion=nil             ---@type fun(): region (native)
RemoveRegion=nil             ---@type fun(whichRegion: region) (native)

RegionAddRect=nil            ---@type fun(whichRegion: region, r: rect) (native)
RegionClearRect=nil          ---@type fun(whichRegion: region, r: rect) (native)

RegionAddCell=nil           ---@type fun(whichRegion: region, x: number, y: number) (native)
RegionAddCellAtLoc=nil      ---@type fun(whichRegion: region, whichLocation: location) (native)
RegionClearCell=nil         ---@type fun(whichRegion: region, x: number, y: number) (native)
RegionClearCellAtLoc=nil    ---@type fun(whichRegion: region, whichLocation: location) (native)

Location=nil                 ---@type fun(x: number, y: number): location (native)
RemoveLocation=nil           ---@type fun(whichLocation: location) (native)
MoveLocation=nil             ---@type fun(whichLocation: location, newX: number, newY: number) (native)
GetLocationX=nil             ---@type fun(whichLocation: location): number (native)
GetLocationY=nil             ---@type fun(whichLocation: location): number (native)

-- This function is asynchronous. The values it returns are not guaranteed synchronous between each player.
--  If you attempt to use it in a synchronous manner, it may cause a desync.
GetLocationZ=nil             ---@type fun(whichLocation: location): number (native)

IsUnitInRegion=nil               ---@type fun(whichRegion: region, whichUnit: unit): boolean (native)
IsPointInRegion=nil              ---@type fun(whichRegion: region, x: number, y: number): boolean (native)
IsLocationInRegion=nil           ---@type fun(whichRegion: region, whichLocation: location): boolean (native)

-- Returns full map bounds, including unplayable borders, in world coordinates
GetWorldBounds=nil           ---@type fun(): rect (native)

--============================================================================
-- Native trigger interface
--
CreateTrigger=nil    ---@type fun(): trigger (native)
DestroyTrigger=nil   ---@type fun(whichTrigger: trigger) (native)
ResetTrigger=nil     ---@type fun(whichTrigger: trigger) (native)
EnableTrigger=nil    ---@type fun(whichTrigger: trigger) (native)
DisableTrigger=nil   ---@type fun(whichTrigger: trigger) (native)
IsTriggerEnabled=nil ---@type fun(whichTrigger: trigger): boolean (native)

TriggerWaitOnSleeps=nil   ---@type fun(whichTrigger: trigger, flag: boolean) (native)
IsTriggerWaitOnSleeps=nil ---@type fun(whichTrigger: trigger): boolean (native)

GetFilterUnit=nil       ---@type fun(): unit (native)
GetEnumUnit=nil         ---@type fun(): unit (native)

GetFilterDestructable=nil   ---@type fun(): destructable (native)
GetEnumDestructable=nil     ---@type fun(): destructable (native)

GetFilterItem=nil           ---@type fun(): item (native)
GetEnumItem=nil             ---@type fun(): item (native)

ParseTags=nil               ---@type fun(taggedString: string): string (native)

GetFilterPlayer=nil     ---@type fun(): player (native)
GetEnumPlayer=nil       ---@type fun(): player (native)

GetTriggeringTrigger=nil    ---@type fun(): trigger (native)
GetTriggerEventId=nil       ---@type fun(): eventid (native)
GetTriggerEvalCount=nil     ---@type fun(whichTrigger: trigger): integer (native)
GetTriggerExecCount=nil     ---@type fun(whichTrigger: trigger): integer (native)

ExecuteFunc=nil          ---@type fun(funcName: string) (native)

--============================================================================
-- Boolean Expr API ( for compositing trigger conditions and unit filter funcs...)
--============================================================================
And=nil              ---@type fun(operandA: boolexpr, operandB: boolexpr): boolexpr (native)
Or=nil               ---@type fun(operandA: boolexpr, operandB: boolexpr): boolexpr (native)
Not=nil              ---@type fun(operand: boolexpr): boolexpr (native)
Condition=nil        ---@type fun(func: function): conditionfunc (native)
DestroyCondition=nil ---@type fun(c: conditionfunc) (native)
Filter=nil           ---@type fun(func: function): filterfunc (native)
DestroyFilter=nil    ---@type fun(f: filterfunc) (native)
DestroyBoolExpr=nil  ---@type fun(e: boolexpr) (native)

--============================================================================
-- Trigger Game Event API
--============================================================================

TriggerRegisterVariableEvent=nil ---@type fun(whichTrigger: trigger, varName: string, opcode: limitop, limitval: number): event (native)

    -- EVENT_GAME_VARIABLE_LIMIT
    --constant native string GetTriggeringVariableName takes nothing returns string

-- Creates it's own timer and triggers when it expires
TriggerRegisterTimerEvent=nil ---@type fun(whichTrigger: trigger, timeout: number, periodic: boolean): event (native)

-- Triggers when the timer you tell it about expires
TriggerRegisterTimerExpireEvent=nil ---@type fun(whichTrigger: trigger, t: timer): event (native)

TriggerRegisterGameStateEvent=nil ---@type fun(whichTrigger: trigger, whichState: gamestate, opcode: limitop, limitval: number): event (native)

TriggerRegisterDialogEvent=nil       ---@type fun(whichTrigger: trigger, whichDialog: dialog): event (native)
TriggerRegisterDialogButtonEvent=nil ---@type fun(whichTrigger: trigger, whichButton: button): event (native)

--  EVENT_GAME_STATE_LIMIT
GetEventGameState=nil ---@type fun(): gamestate (native)

TriggerRegisterGameEvent=nil ---@type fun(whichTrigger: trigger, whichGameEvent: gameevent): event (native)

-- EVENT_GAME_VICTORY
GetWinningPlayer=nil ---@type fun(): player (native)


TriggerRegisterEnterRegion=nil ---@type fun(whichTrigger: trigger, whichRegion: region, filter?: boolexpr): event (native)

-- EVENT_GAME_ENTER_REGION
GetTriggeringRegion=nil ---@type fun(): region (native)
GetEnteringUnit=nil ---@type fun(): unit (native)

-- EVENT_GAME_LEAVE_REGION

TriggerRegisterLeaveRegion=nil ---@type fun(whichTrigger: trigger, whichRegion: region, filter?: boolexpr): event (native)
GetLeavingUnit=nil ---@type fun(): unit (native)

TriggerRegisterTrackableHitEvent=nil ---@type fun(whichTrigger: trigger, t: trackable): event (native)
TriggerRegisterTrackableTrackEvent=nil ---@type fun(whichTrigger: trigger, t: trackable): event (native)

-- EVENT_COMMAND_BUTTON_CLICK
TriggerRegisterCommandEvent=nil ---@type fun(whichTrigger: trigger, whichAbility: integer, order: string): event (native)
TriggerRegisterUpgradeCommandEvent=nil ---@type fun(whichTrigger: trigger, whichUpgrade: integer): event (native)

-- EVENT_GAME_TRACKABLE_HIT
-- EVENT_GAME_TRACKABLE_TRACK
GetTriggeringTrackable=nil ---@type fun(): trackable (native)

-- EVENT_DIALOG_BUTTON_CLICK
GetClickedButton=nil ---@type fun(): button (native)
GetClickedDialog=nil    ---@type fun(): dialog (native)

-- EVENT_GAME_TOURNAMENT_FINISH_SOON
GetTournamentFinishSoonTimeRemaining=nil ---@type fun(): number (native)
GetTournamentFinishNowRule=nil ---@type fun(): integer (native)
GetTournamentFinishNowPlayer=nil ---@type fun(): player (native)
GetTournamentScore=nil ---@type fun(whichPlayer: player): integer (native)

-- EVENT_GAME_SAVE
GetSaveBasicFilename=nil ---@type fun(): string (native)

--============================================================================
-- Trigger Player Based Event API
--============================================================================

TriggerRegisterPlayerEvent=nil ---@type fun(whichTrigger: trigger, whichPlayer: player, whichPlayerEvent: playerevent): event (native)

-- EVENT_PLAYER_DEFEAT
-- EVENT_PLAYER_VICTORY
GetTriggerPlayer=nil ---@type fun(): player (native)

TriggerRegisterPlayerUnitEvent=nil ---@type fun(whichTrigger: trigger, whichPlayer: player, whichPlayerUnitEvent: playerunitevent, filter?: boolexpr): event (native)

-- EVENT_PLAYER_HERO_LEVEL
-- EVENT_UNIT_HERO_LEVEL
GetLevelingUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_HERO_SKILL
-- EVENT_UNIT_HERO_SKILL
GetLearningUnit=nil      ---@type fun(): unit (native)
GetLearnedSkill=nil      ---@type fun(): integer (native)
GetLearnedSkillLevel=nil ---@type fun(): integer (native)

-- EVENT_PLAYER_HERO_REVIVABLE
GetRevivableUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_HERO_REVIVE_START
-- EVENT_PLAYER_HERO_REVIVE_CANCEL
-- EVENT_PLAYER_HERO_REVIVE_FINISH
-- EVENT_UNIT_HERO_REVIVE_START
-- EVENT_UNIT_HERO_REVIVE_CANCEL
-- EVENT_UNIT_HERO_REVIVE_FINISH
GetRevivingUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_ATTACKED
GetAttacker=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_RESCUED
GetRescuer=nil  ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_DEATH
GetDyingUnit=nil ---@type fun(): unit (native)
GetKillingUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_DECAY
GetDecayingUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_SELECTED
--constant native GetSelectedUnit takes nothing returns unit

-- EVENT_PLAYER_UNIT_CONSTRUCT_START
GetConstructingStructure=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_CONSTRUCT_FINISH
-- EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL
GetCancelledStructure=nil ---@type fun(): unit (native)
GetConstructedStructure=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_RESEARCH_START
-- EVENT_PLAYER_UNIT_RESEARCH_CANCEL
-- EVENT_PLAYER_UNIT_RESEARCH_FINISH
GetResearchingUnit=nil ---@type fun(): unit (native)
GetResearched=nil ---@type fun(): integer (native)

-- EVENT_PLAYER_UNIT_TRAIN_START
-- EVENT_PLAYER_UNIT_TRAIN_CANCEL
GetTrainedUnitType=nil ---@type fun(): integer (native)

-- EVENT_PLAYER_UNIT_TRAIN_FINISH
GetTrainedUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_DETECTED
GetDetectedUnit=nil ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_SUMMONED
GetSummoningUnit=nil    ---@type fun(): unit (native)
GetSummonedUnit=nil     ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_LOADED
GetTransportUnit=nil    ---@type fun(): unit (native)
GetLoadedUnit=nil       ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_SELL
GetSellingUnit=nil      ---@type fun(): unit (native)
GetSoldUnit=nil         ---@type fun(): unit (native)
GetBuyingUnit=nil       ---@type fun(): unit (native)

-- EVENT_PLAYER_UNIT_SELL_ITEM
GetSoldItem=nil         ---@type fun(): item (native)

-- EVENT_PLAYER_UNIT_CHANGE_OWNER
GetChangingUnit=nil             ---@type fun(): unit (native)
GetChangingUnitPrevOwner=nil    ---@type fun(): player (native)

-- EVENT_PLAYER_UNIT_DROP_ITEM
-- EVENT_PLAYER_UNIT_PICKUP_ITEM
-- EVENT_PLAYER_UNIT_USE_ITEM
GetManipulatingUnit=nil ---@type fun(): unit (native)
GetManipulatedItem=nil  ---@type fun(): item (native)

-- For EVENT_PLAYER_UNIT_PICKUP_ITEM, returns the item absorbing the picked up item in case it is stacking.
-- Returns null if the item was a powerup and not a stacking item.
BlzGetAbsorbingItem=nil ---@type fun(): item (native)
BlzGetManipulatedItemWasAbsorbed=nil ---@type fun(): boolean (native)

-- EVENT_PLAYER_UNIT_STACK_ITEM
-- Source is the item that is losing charges, Target is the item getting charges.
BlzGetStackingItemSource=nil ---@type fun(): item (native)
BlzGetStackingItemTarget=nil ---@type fun(): item (native)
BlzGetStackingItemTargetPreviousCharges=nil ---@type fun(): integer (native)

-- EVENT_PLAYER_UNIT_ISSUED_ORDER
GetOrderedUnit=nil ---@type fun(): unit (native)
GetIssuedOrderId=nil ---@type fun(): integer (native)

-- EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER
GetOrderPointX=nil ---@type fun(): number (native)
GetOrderPointY=nil ---@type fun(): number (native)
GetOrderPointLoc=nil ---@type fun(): location (native)

-- EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
GetOrderTarget=nil              ---@type fun(): widget (native)
GetOrderTargetDestructable=nil  ---@type fun(): destructable (native)
GetOrderTargetItem=nil          ---@type fun(): item (native)
GetOrderTargetUnit=nil          ---@type fun(): unit (native)

-- EVENT_UNIT_SPELL_CHANNEL
-- EVENT_UNIT_SPELL_CAST
-- EVENT_UNIT_SPELL_EFFECT
-- EVENT_UNIT_SPELL_FINISH
-- EVENT_UNIT_SPELL_ENDCAST
-- EVENT_PLAYER_UNIT_SPELL_CHANNEL
-- EVENT_PLAYER_UNIT_SPELL_CAST
-- EVENT_PLAYER_UNIT_SPELL_EFFECT
-- EVENT_PLAYER_UNIT_SPELL_FINISH
-- EVENT_PLAYER_UNIT_SPELL_ENDCAST
GetSpellAbilityUnit=nil         ---@type fun(): unit (native)
GetSpellAbilityId=nil           ---@type fun(): integer (native)
GetSpellAbility=nil             ---@type fun(): ability (native)
GetSpellTargetLoc=nil           ---@type fun(): location (native)
GetSpellTargetX=nil             ---@type fun(): number (native)
GetSpellTargetY=nil             ---@type fun(): number (native)
GetSpellTargetDestructable=nil  ---@type fun(): destructable (native)
GetSpellTargetItem=nil          ---@type fun(): item (native)
GetSpellTargetUnit=nil          ---@type fun(): unit (native)

TriggerRegisterPlayerAllianceChange=nil ---@type fun(whichTrigger: trigger, whichPlayer: player, whichAlliance: alliancetype): event (native)
TriggerRegisterPlayerStateEvent=nil ---@type fun(whichTrigger: trigger, whichPlayer: player, whichState: playerstate, opcode: limitop, limitval: number): event (native)

-- EVENT_PLAYER_STATE_LIMIT
GetEventPlayerState=nil ---@type fun(): playerstate (native)

TriggerRegisterPlayerChatEvent=nil ---@type fun(whichTrigger: trigger, whichPlayer: player, chatMessageToDetect: string, exactMatchOnly: boolean): event (native)

-- EVENT_PLAYER_CHAT

-- returns the actual string they typed in ( same as what you registered for
-- if you required exact match )
GetEventPlayerChatString=nil ---@type fun(): string (native)

-- returns the string that you registered for
GetEventPlayerChatStringMatched=nil ---@type fun(): string (native)

TriggerRegisterDeathEvent=nil ---@type fun(whichTrigger: trigger, whichWidget: widget): event (native)

--============================================================================
-- Trigger Unit Based Event API
--============================================================================

-- returns handle to unit which triggered the most recent event when called from
-- within a trigger action function...returns null handle when used incorrectly

GetTriggerUnit=nil ---@type fun(): unit (native)

TriggerRegisterUnitStateEvent=nil ---@type fun(whichTrigger: trigger, whichUnit: unit, whichState: unitstate, opcode: limitop, limitval: number): event (native)

-- EVENT_UNIT_STATE_LIMIT
GetEventUnitState=nil ---@type fun(): unitstate (native)

TriggerRegisterUnitEvent=nil ---@type fun(whichTrigger: trigger, whichUnit: unit, whichEvent: unitevent): event (native)

-- EVENT_UNIT_DAMAGED
GetEventDamage=nil ---@type fun(): number (native)
GetEventDamageSource=nil ---@type fun(): unit (native)

-- EVENT_UNIT_DEATH
-- EVENT_UNIT_DECAY
-- Use the GetDyingUnit and GetDecayingUnit funcs above

-- EVENT_UNIT_DETECTED
GetEventDetectingPlayer=nil ---@type fun(): player (native)

TriggerRegisterFilterUnitEvent=nil ---@type fun(whichTrigger: trigger, whichUnit: unit, whichEvent: unitevent, filter?: boolexpr): event (native)

-- EVENT_UNIT_ACQUIRED_TARGET
-- EVENT_UNIT_TARGET_IN_RANGE
GetEventTargetUnit=nil ---@type fun(): unit (native)

-- EVENT_UNIT_ATTACKED
-- Use GetAttacker from the Player Unit Event API Below...

-- EVENT_UNIT_RESCUEDED
-- Use GetRescuer from the Player Unit Event API Below...

-- EVENT_UNIT_CONSTRUCT_CANCEL
-- EVENT_UNIT_CONSTRUCT_FINISH

-- See the Player Unit Construction Event API above for event info funcs

-- EVENT_UNIT_TRAIN_START
-- EVENT_UNIT_TRAIN_CANCELLED
-- EVENT_UNIT_TRAIN_FINISH

-- See the Player Unit Training Event API above for event info funcs

-- EVENT_UNIT_SELL

-- See the Player Unit Sell Event API above for event info funcs

-- EVENT_UNIT_DROP_ITEM
-- EVENT_UNIT_PICKUP_ITEM
-- EVENT_UNIT_USE_ITEM
-- See the Player Unit/Item manipulation Event API above for event info funcs

-- EVENT_UNIT_STACK_ITEM
-- See the Player Unit/Item stack Event API above for event info funcs

-- EVENT_UNIT_ISSUED_ORDER
-- EVENT_UNIT_ISSUED_POINT_ORDER
-- EVENT_UNIT_ISSUED_TARGET_ORDER

-- See the Player Unit Order Event API above for event info funcs

TriggerRegisterUnitInRange=nil ---@type fun(whichTrigger: trigger, whichUnit: unit, range: number, filter?: boolexpr): event (native)

TriggerAddCondition=nil    ---@type fun(whichTrigger: trigger, condition: boolexpr): triggercondition (native)
TriggerRemoveCondition=nil ---@type fun(whichTrigger: trigger, whichCondition: triggercondition) (native)
TriggerClearConditions=nil ---@type fun(whichTrigger: trigger) (native)

TriggerAddAction=nil     ---@type fun(whichTrigger: trigger, actionFunc: function): triggeraction (native)
TriggerRemoveAction=nil  ---@type fun(whichTrigger: trigger, whichAction: triggeraction) (native)
TriggerClearActions=nil  ---@type fun(whichTrigger: trigger) (native)
TriggerSleepAction=nil   ---@type fun(timeout: number) (native)
TriggerWaitForSound=nil  ---@type fun(s: sound, offset: number) (native)
TriggerEvaluate=nil      ---@type fun(whichTrigger: trigger): boolean (native)
TriggerExecute=nil       ---@type fun(whichTrigger: trigger) (native)
TriggerExecuteWait=nil   ---@type fun(whichTrigger: trigger) (native)
TriggerSyncStart=nil     ---@type fun() (native)
TriggerSyncReady=nil     ---@type fun() (native)

--============================================================================
-- Widget API
GetWidgetLife=nil   ---@type fun(whichWidget: widget): number (native)
SetWidgetLife=nil   ---@type fun(whichWidget: widget, newLife: number) (native)
GetWidgetX=nil      ---@type fun(whichWidget: widget): number (native)
GetWidgetY=nil      ---@type fun(whichWidget: widget): number (native)
GetTriggerWidget=nil ---@type fun(): widget (native)

--============================================================================
-- Destructable Object API
-- Facing arguments are specified in degrees
CreateDestructable=nil          ---@type fun(objectid: integer, x: number, y: number, face: number, scale: number, variation: integer): destructable (native)
CreateDestructableZ=nil         ---@type fun(objectid: integer, x: number, y: number, z: number, face: number, scale: number, variation: integer): destructable (native)
CreateDeadDestructable=nil      ---@type fun(objectid: integer, x: number, y: number, face: number, scale: number, variation: integer): destructable (native)
CreateDeadDestructableZ=nil     ---@type fun(objectid: integer, x: number, y: number, z: number, face: number, scale: number, variation: integer): destructable (native)
RemoveDestructable=nil          ---@type fun(d: destructable) (native)
KillDestructable=nil            ---@type fun(d: destructable) (native)
SetDestructableInvulnerable=nil ---@type fun(d: destructable, flag: boolean) (native)
IsDestructableInvulnerable=nil  ---@type fun(d: destructable): boolean (native)
EnumDestructablesInRect=nil     ---@type fun(r: rect, filter?: boolexpr, actionFunc?: function) (native)
GetDestructableTypeId=nil       ---@type fun(d: destructable): integer (native)
GetDestructableX=nil            ---@type fun(d: destructable): number (native)
GetDestructableY=nil            ---@type fun(d: destructable): number (native)
SetDestructableLife=nil         ---@type fun(d: destructable, life: number) (native)
GetDestructableLife=nil         ---@type fun(d: destructable): number (native)
SetDestructableMaxLife=nil      ---@type fun(d: destructable, max: number) (native)
GetDestructableMaxLife=nil      ---@type fun(d: destructable): number (native)
DestructableRestoreLife=nil     ---@type fun(d: destructable, life: number, birth: boolean) (native)
QueueDestructableAnimation=nil  ---@type fun(d: destructable, whichAnimation: string) (native)
SetDestructableAnimation=nil    ---@type fun(d: destructable, whichAnimation: string) (native)
SetDestructableAnimationSpeed=nil ---@type fun(d: destructable, speedFactor: number) (native)
ShowDestructable=nil            ---@type fun(d: destructable, flag: boolean) (native)
GetDestructableOccluderHeight=nil ---@type fun(d: destructable): number (native)
SetDestructableOccluderHeight=nil ---@type fun(d: destructable, height: number) (native)
GetDestructableName=nil         ---@type fun(d: destructable): string (native)
GetTriggerDestructable=nil ---@type fun(): destructable (native)

--============================================================================
-- Item API
CreateItem=nil      ---@type fun(itemid: integer, x: number, y: number): item (native)
RemoveItem=nil      ---@type fun(whichItem: item) (native)
GetItemPlayer=nil   ---@type fun(whichItem: item): player (native)
GetItemTypeId=nil   ---@type fun(i: item): integer (native)
GetItemX=nil        ---@type fun(i: item): number (native)
GetItemY=nil        ---@type fun(i: item): number (native)
SetItemPosition=nil ---@type fun(i: item, x: number, y: number) (native)
SetItemDropOnDeath=nil  ---@type fun(whichItem: item, flag: boolean) (native)
SetItemDroppable=nil ---@type fun(i: item, flag: boolean) (native)
SetItemPawnable=nil ---@type fun(i: item, flag: boolean) (native)
SetItemPlayer=nil    ---@type fun(whichItem: item, whichPlayer: player, changeColor: boolean) (native)
SetItemInvulnerable=nil ---@type fun(whichItem: item, flag: boolean) (native)
IsItemInvulnerable=nil  ---@type fun(whichItem: item): boolean (native)
SetItemVisible=nil  ---@type fun(whichItem: item, show: boolean) (native)
IsItemVisible=nil   ---@type fun(whichItem: item): boolean (native)
IsItemOwned=nil     ---@type fun(whichItem: item): boolean (native)
IsItemPowerup=nil   ---@type fun(whichItem: item): boolean (native)
IsItemSellable=nil  ---@type fun(whichItem: item): boolean (native)
IsItemPawnable=nil  ---@type fun(whichItem: item): boolean (native)
IsItemIdPowerup=nil ---@type fun(itemId: integer): boolean (native)
IsItemIdSellable=nil ---@type fun(itemId: integer): boolean (native)
IsItemIdPawnable=nil ---@type fun(itemId: integer): boolean (native)
EnumItemsInRect=nil     ---@type fun(r: rect, filter?: boolexpr, actionFunc?: function) (native)
GetItemLevel=nil    ---@type fun(whichItem: item): integer (native)
GetItemType=nil     ---@type fun(whichItem: item): itemtype (native)
SetItemDropID=nil   ---@type fun(whichItem: item, unitId: integer) (native)
GetItemName=nil     ---@type fun(whichItem: item): string (native)
GetItemCharges=nil  ---@type fun(whichItem: item): integer (native)
SetItemCharges=nil  ---@type fun(whichItem: item, charges: integer) (native)
GetItemUserData=nil ---@type fun(whichItem: item): integer (native)
SetItemUserData=nil ---@type fun(whichItem: item, data: integer) (native)

--============================================================================
-- Unit API
-- Facing arguments are specified in degrees
CreateUnit=nil              ---@type fun(id: player, unitid: integer, x: number, y: number, face: number): unit (native)
CreateUnitByName=nil        ---@type fun(whichPlayer: player, unitname: string, x: number, y: number, face: number): unit (native)
CreateUnitAtLoc=nil         ---@type fun(id: player, unitid: integer, whichLocation: location, face: number): unit (native)
CreateUnitAtLocByName=nil   ---@type fun(id: player, unitname: string, whichLocation: location, face: number): unit (native)
CreateCorpse=nil            ---@type fun(whichPlayer: player, unitid: integer, x: number, y: number, face: number): unit (native)

KillUnit=nil            ---@type fun(whichUnit: unit) (native)
RemoveUnit=nil          ---@type fun(whichUnit: unit) (native)
ShowUnit=nil            ---@type fun(whichUnit: unit, show: boolean) (native)

SetUnitState=nil        ---@type fun(whichUnit: unit, whichUnitState: unitstate, newVal: number) (native)
SetUnitX=nil            ---@type fun(whichUnit: unit, newX: number) (native)
SetUnitY=nil            ---@type fun(whichUnit: unit, newY: number) (native)
SetUnitPosition=nil     ---@type fun(whichUnit: unit, newX: number, newY: number) (native)
SetUnitPositionLoc=nil  ---@type fun(whichUnit: unit, whichLocation: location) (native)
SetUnitFacing=nil       ---@type fun(whichUnit: unit, facingAngle: number) (native)
SetUnitFacingTimed=nil  ---@type fun(whichUnit: unit, facingAngle: number, duration: number) (native)
SetUnitMoveSpeed=nil    ---@type fun(whichUnit: unit, newSpeed: number) (native)
SetUnitFlyHeight=nil    ---@type fun(whichUnit: unit, newHeight: number, rate: number) (native)
SetUnitTurnSpeed=nil    ---@type fun(whichUnit: unit, newTurnSpeed: number) (native)
SetUnitPropWindow=nil   ---@type fun(whichUnit: unit, newPropWindowAngle: number) (native)
SetUnitAcquireRange=nil ---@type fun(whichUnit: unit, newAcquireRange: number) (native)
SetUnitCreepGuard=nil   ---@type fun(whichUnit: unit, creepGuard: boolean) (native)

GetUnitAcquireRange=nil     ---@type fun(whichUnit: unit): number (native)
GetUnitTurnSpeed=nil        ---@type fun(whichUnit: unit): number (native)
GetUnitPropWindow=nil       ---@type fun(whichUnit: unit): number (native)
GetUnitFlyHeight=nil        ---@type fun(whichUnit: unit): number (native)

GetUnitDefaultAcquireRange=nil      ---@type fun(whichUnit: unit): number (native)
GetUnitDefaultTurnSpeed=nil         ---@type fun(whichUnit: unit): number (native)
GetUnitDefaultPropWindow=nil        ---@type fun(whichUnit: unit): number (native)
GetUnitDefaultFlyHeight=nil         ---@type fun(whichUnit: unit): number (native)

SetUnitOwner=nil        ---@type fun(whichUnit: unit, whichPlayer: player, changeColor: boolean) (native)
SetUnitColor=nil        ---@type fun(whichUnit: unit, whichColor: playercolor) (native)

SetUnitScale=nil        ---@type fun(whichUnit: unit, scaleX: number, scaleY: number, scaleZ: number) (native)
SetUnitTimeScale=nil    ---@type fun(whichUnit: unit, timeScale: number) (native)
SetUnitBlendTime=nil    ---@type fun(whichUnit: unit, blendTime: number) (native)
SetUnitVertexColor=nil  ---@type fun(whichUnit: unit, red: integer, green: integer, blue: integer, alpha: integer) (native)

QueueUnitAnimation=nil          ---@type fun(whichUnit: unit, whichAnimation: string) (native)
SetUnitAnimation=nil            ---@type fun(whichUnit: unit, whichAnimation: string) (native)
SetUnitAnimationByIndex=nil     ---@type fun(whichUnit: unit, whichAnimation: integer) (native)
SetUnitAnimationWithRarity=nil  ---@type fun(whichUnit: unit, whichAnimation: string, rarity: raritycontrol) (native)
AddUnitAnimationProperties=nil  ---@type fun(whichUnit: unit, animProperties: string, add: boolean) (native)

SetUnitLookAt=nil       ---@type fun(whichUnit: unit, whichBone: string, lookAtTarget: unit, offsetX: number, offsetY: number, offsetZ: number) (native)
ResetUnitLookAt=nil     ---@type fun(whichUnit: unit) (native)

SetUnitRescuable=nil    ---@type fun(whichUnit: unit, byWhichPlayer: player, flag: boolean) (native)
SetUnitRescueRange=nil  ---@type fun(whichUnit: unit, range: number) (native)

SetHeroStr=nil          ---@type fun(whichHero: unit, newStr: integer, permanent: boolean) (native)
SetHeroAgi=nil          ---@type fun(whichHero: unit, newAgi: integer, permanent: boolean) (native)
SetHeroInt=nil          ---@type fun(whichHero: unit, newInt: integer, permanent: boolean) (native)

GetHeroStr=nil          ---@type fun(whichHero: unit, includeBonuses: boolean): integer (native)
GetHeroAgi=nil          ---@type fun(whichHero: unit, includeBonuses: boolean): integer (native)
GetHeroInt=nil          ---@type fun(whichHero: unit, includeBonuses: boolean): integer (native)

UnitStripHeroLevel=nil  ---@type fun(whichHero: unit, howManyLevels: integer): boolean (native)

GetHeroXP=nil           ---@type fun(whichHero: unit): integer (native)
SetHeroXP=nil           ---@type fun(whichHero: unit, newXpVal: integer, showEyeCandy: boolean) (native)

GetHeroSkillPoints=nil      ---@type fun(whichHero: unit): integer (native)
UnitModifySkillPoints=nil   ---@type fun(whichHero: unit, skillPointDelta: integer): boolean (native)

AddHeroXP=nil           ---@type fun(whichHero: unit, xpToAdd: integer, showEyeCandy: boolean) (native)
SetHeroLevel=nil        ---@type fun(whichHero: unit, level: integer, showEyeCandy: boolean) (native)
GetHeroLevel=nil        ---@type fun(whichHero: unit): integer (native)
GetUnitLevel=nil        ---@type fun(whichUnit: unit): integer (native)
GetHeroProperName=nil   ---@type fun(whichHero: unit): string (native)
SuspendHeroXP=nil       ---@type fun(whichHero: unit, flag: boolean) (native)
IsSuspendedXP=nil       ---@type fun(whichHero: unit): boolean (native)
SelectHeroSkill=nil     ---@type fun(whichHero: unit, abilcode: integer) (native)
GetUnitAbilityLevel=nil ---@type fun(whichUnit: unit, abilcode: integer): integer (native)
DecUnitAbilityLevel=nil ---@type fun(whichUnit: unit, abilcode: integer): integer (native)
IncUnitAbilityLevel=nil ---@type fun(whichUnit: unit, abilcode: integer): integer (native)
SetUnitAbilityLevel=nil ---@type fun(whichUnit: unit, abilcode: integer, level: integer): integer (native)
ReviveHero=nil          ---@type fun(whichHero: unit, x: number, y: number, doEyecandy: boolean): boolean (native)
ReviveHeroLoc=nil       ---@type fun(whichHero: unit, loc: location, doEyecandy: boolean): boolean (native)
SetUnitExploded=nil     ---@type fun(whichUnit: unit, exploded: boolean) (native)
SetUnitInvulnerable=nil ---@type fun(whichUnit: unit, flag: boolean) (native)
PauseUnit=nil           ---@type fun(whichUnit: unit, flag: boolean) (native)
IsUnitPaused=nil        ---@type fun(whichHero: unit): boolean (native)
SetUnitPathing=nil      ---@type fun(whichUnit: unit, flag: boolean) (native)

ClearSelection=nil      ---@type fun() (native)
SelectUnit=nil          ---@type fun(whichUnit: unit, flag: boolean) (native)

GetUnitPointValue=nil       ---@type fun(whichUnit: unit): integer (native)
GetUnitPointValueByType=nil ---@type fun(unitType: integer): integer (native)
--native        SetUnitPointValueByType takes integer unitType, integer newPointValue returns nothing

UnitAddItem=nil             ---@type fun(whichUnit: unit, whichItem: item): boolean (native)
UnitAddItemById=nil         ---@type fun(whichUnit: unit, itemId: integer): item (native)
UnitAddItemToSlotById=nil   ---@type fun(whichUnit: unit, itemId: integer, itemSlot: integer): boolean (native)
UnitRemoveItem=nil          ---@type fun(whichUnit: unit, whichItem: item) (native)
UnitRemoveItemFromSlot=nil  ---@type fun(whichUnit: unit, itemSlot: integer): item (native)
UnitHasItem=nil             ---@type fun(whichUnit: unit, whichItem: item): boolean (native)
UnitItemInSlot=nil          ---@type fun(whichUnit: unit, itemSlot: integer): item (native)
UnitInventorySize=nil       ---@type fun(whichUnit: unit): integer (native)

UnitDropItemPoint=nil       ---@type fun(whichUnit: unit, whichItem: item, x: number, y: number): boolean (native)
UnitDropItemSlot=nil        ---@type fun(whichUnit: unit, whichItem: item, slot: integer): boolean (native)
UnitDropItemTarget=nil      ---@type fun(whichUnit: unit, whichItem: item, target: widget): boolean (native)

UnitUseItem=nil             ---@type fun(whichUnit: unit, whichItem: item): boolean (native)
UnitUseItemPoint=nil        ---@type fun(whichUnit: unit, whichItem: item, x: number, y: number): boolean (native)
UnitUseItemTarget=nil       ---@type fun(whichUnit: unit, whichItem: item, target: widget): boolean (native)

GetUnitX=nil            ---@type fun(whichUnit: unit): number (native)
GetUnitY=nil            ---@type fun(whichUnit: unit): number (native)
GetUnitLoc=nil          ---@type fun(whichUnit: unit): location (native)
GetUnitFacing=nil       ---@type fun(whichUnit: unit): number (native)
GetUnitMoveSpeed=nil    ---@type fun(whichUnit: unit): number (native)
GetUnitDefaultMoveSpeed=nil ---@type fun(whichUnit: unit): number (native)
GetUnitState=nil        ---@type fun(whichUnit: unit, whichUnitState: unitstate): number (native)
GetOwningPlayer=nil     ---@type fun(whichUnit: unit): player (native)
GetUnitTypeId=nil       ---@type fun(whichUnit: unit): integer (native)
GetUnitRace=nil         ---@type fun(whichUnit: unit): race (native)
GetUnitName=nil         ---@type fun(whichUnit: unit): string (native)
GetUnitFoodUsed=nil     ---@type fun(whichUnit: unit): integer (native)
GetUnitFoodMade=nil     ---@type fun(whichUnit: unit): integer (native)
GetFoodMade=nil         ---@type fun(unitId: integer): integer (native)
GetFoodUsed=nil         ---@type fun(unitId: integer): integer (native)
SetUnitUseFood=nil      ---@type fun(whichUnit: unit, useFood: boolean) (native)

GetUnitRallyPoint=nil           ---@type fun(whichUnit: unit): location (native)
GetUnitRallyUnit=nil            ---@type fun(whichUnit: unit): unit (native)
GetUnitRallyDestructable=nil    ---@type fun(whichUnit: unit): destructable (native)

IsUnitInGroup=nil       ---@type fun(whichUnit: unit, whichGroup: group): boolean (native)
IsUnitInForce=nil       ---@type fun(whichUnit: unit, whichForce: force): boolean (native)
IsUnitOwnedByPlayer=nil ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitAlly=nil          ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitEnemy=nil         ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitVisible=nil       ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitDetected=nil      ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitInvisible=nil     ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitFogged=nil        ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitMasked=nil        ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitSelected=nil      ---@type fun(whichUnit: unit, whichPlayer: player): boolean (native)
IsUnitRace=nil          ---@type fun(whichUnit: unit, whichRace: race): boolean (native)
IsUnitType=nil          ---@type fun(whichUnit: unit, whichUnitType: unittype): boolean (native)
IsUnit=nil              ---@type fun(whichUnit: unit, whichSpecifiedUnit: unit): boolean (native)
IsUnitInRange=nil       ---@type fun(whichUnit: unit, otherUnit: unit, distance: number): boolean (native)
IsUnitInRangeXY=nil     ---@type fun(whichUnit: unit, x: number, y: number, distance: number): boolean (native)
IsUnitInRangeLoc=nil    ---@type fun(whichUnit: unit, whichLocation: location, distance: number): boolean (native)
IsUnitHidden=nil        ---@type fun(whichUnit: unit): boolean (native)
IsUnitIllusion=nil      ---@type fun(whichUnit: unit): boolean (native)

IsUnitInTransport=nil   ---@type fun(whichUnit: unit, whichTransport: unit): boolean (native)
IsUnitLoaded=nil        ---@type fun(whichUnit: unit): boolean (native)

IsHeroUnitId=nil        ---@type fun(unitId: integer): boolean (native)
IsUnitIdType=nil        ---@type fun(unitId: integer, whichUnitType: unittype): boolean (native)

UnitShareVision=nil              ---@type fun(whichUnit: unit, whichPlayer: player, share: boolean) (native)
UnitSuspendDecay=nil             ---@type fun(whichUnit: unit, suspend: boolean) (native)
UnitAddType=nil                  ---@type fun(whichUnit: unit, whichUnitType: unittype): boolean (native)
UnitRemoveType=nil               ---@type fun(whichUnit: unit, whichUnitType: unittype): boolean (native)

UnitAddAbility=nil               ---@type fun(whichUnit: unit, abilityId: integer): boolean (native)
UnitRemoveAbility=nil            ---@type fun(whichUnit: unit, abilityId: integer): boolean (native)
UnitMakeAbilityPermanent=nil     ---@type fun(whichUnit: unit, permanent: boolean, abilityId: integer): boolean (native)
UnitRemoveBuffs=nil              ---@type fun(whichUnit: unit, removePositive: boolean, removeNegative: boolean) (native)
UnitRemoveBuffsEx=nil            ---@type fun(whichUnit: unit, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean) (native)
UnitHasBuffsEx=nil               ---@type fun(whichUnit: unit, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean): boolean (native)
UnitCountBuffsEx=nil             ---@type fun(whichUnit: unit, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean): integer (native)
UnitAddSleep=nil                 ---@type fun(whichUnit: unit, add: boolean) (native)
UnitCanSleep=nil                 ---@type fun(whichUnit: unit): boolean (native)
UnitAddSleepPerm=nil             ---@type fun(whichUnit: unit, add: boolean) (native)
UnitCanSleepPerm=nil             ---@type fun(whichUnit: unit): boolean (native)
UnitIsSleeping=nil               ---@type fun(whichUnit: unit): boolean (native)
UnitWakeUp=nil                   ---@type fun(whichUnit: unit) (native)
UnitApplyTimedLife=nil           ---@type fun(whichUnit: unit, buffId: integer, duration: number) (native)
UnitIgnoreAlarm=nil              ---@type fun(whichUnit: unit, flag: boolean): boolean (native)
UnitIgnoreAlarmToggled=nil       ---@type fun(whichUnit: unit): boolean (native)
UnitResetCooldown=nil            ---@type fun(whichUnit: unit) (native)
UnitSetConstructionProgress=nil  ---@type fun(whichUnit: unit, constructionPercentage: integer) (native)
UnitSetUpgradeProgress=nil       ---@type fun(whichUnit: unit, upgradePercentage: integer) (native)
UnitPauseTimedLife=nil           ---@type fun(whichUnit: unit, flag: boolean) (native)
UnitSetUsesAltIcon=nil           ---@type fun(whichUnit: unit, flag: boolean) (native)

UnitDamagePoint=nil              ---@type fun(whichUnit: unit, delay: number, radius: number, x: number, y: number, amount: number, attack: boolean, ranged: boolean, attackType: attacktype, damageType: damagetype, weaponType: weapontype): boolean (native)
UnitDamageTarget=nil             ---@type fun(whichUnit: unit, target: widget, amount: number, attack: boolean, ranged: boolean, attackType: attacktype, damageType: damagetype, weaponType: weapontype): boolean (native)

IssueImmediateOrder=nil          ---@type fun(whichUnit: unit, order: string): boolean (native)
IssueImmediateOrderById=nil      ---@type fun(whichUnit: unit, order: integer): boolean (native)
IssuePointOrder=nil              ---@type fun(whichUnit: unit, order: string, x: number, y: number): boolean (native)
IssuePointOrderLoc=nil           ---@type fun(whichUnit: unit, order: string, whichLocation: location): boolean (native)
IssuePointOrderById=nil          ---@type fun(whichUnit: unit, order: integer, x: number, y: number): boolean (native)
IssuePointOrderByIdLoc=nil       ---@type fun(whichUnit: unit, order: integer, whichLocation: location): boolean (native)
IssueTargetOrder=nil             ---@type fun(whichUnit: unit, order: string, targetWidget: widget): boolean (native)
IssueTargetOrderById=nil         ---@type fun(whichUnit: unit, order: integer, targetWidget: widget): boolean (native)
IssueInstantPointOrder=nil       ---@type fun(whichUnit: unit, order: string, x: number, y: number, instantTargetWidget: widget): boolean (native)
IssueInstantPointOrderById=nil   ---@type fun(whichUnit: unit, order: integer, x: number, y: number, instantTargetWidget: widget): boolean (native)
IssueInstantTargetOrder=nil      ---@type fun(whichUnit: unit, order: string, targetWidget: widget, instantTargetWidget: widget): boolean (native)
IssueInstantTargetOrderById=nil  ---@type fun(whichUnit: unit, order: integer, targetWidget: widget, instantTargetWidget: widget): boolean (native)
IssueBuildOrder=nil              ---@type fun(whichPeon: unit, unitToBuild: string, x: number, y: number): boolean (native)
IssueBuildOrderById=nil          ---@type fun(whichPeon: unit, unitId: integer, x: number, y: number): boolean (native)

IssueNeutralImmediateOrder=nil       ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitToBuild: string): boolean (native)
IssueNeutralImmediateOrderById=nil   ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer): boolean (native)
IssueNeutralPointOrder=nil           ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitToBuild: string, x: number, y: number): boolean (native)
IssueNeutralPointOrderById=nil       ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer, x: number, y: number): boolean (native)
IssueNeutralTargetOrder=nil          ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitToBuild: string, target: widget): boolean (native)
IssueNeutralTargetOrderById=nil      ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer, target: widget): boolean (native)

GetUnitCurrentOrder=nil          ---@type fun(whichUnit: unit): integer (native)

SetResourceAmount=nil            ---@type fun(whichUnit: unit, amount: integer) (native)
AddResourceAmount=nil            ---@type fun(whichUnit: unit, amount: integer) (native)
GetResourceAmount=nil            ---@type fun(whichUnit: unit): integer (native)

WaygateGetDestinationX=nil       ---@type fun(waygate: unit): number (native)
WaygateGetDestinationY=nil       ---@type fun(waygate: unit): number (native)
WaygateSetDestination=nil        ---@type fun(waygate: unit, x: number, y: number) (native)
WaygateActivate=nil              ---@type fun(waygate: unit, activate: boolean) (native)
WaygateIsActive=nil              ---@type fun(waygate: unit): boolean (native)

AddItemToAllStock=nil            ---@type fun(itemId: integer, currentStock: integer, stockMax: integer) (native)
AddItemToStock=nil               ---@type fun(whichUnit: unit, itemId: integer, currentStock: integer, stockMax: integer) (native)
AddUnitToAllStock=nil            ---@type fun(unitId: integer, currentStock: integer, stockMax: integer) (native)
AddUnitToStock=nil               ---@type fun(whichUnit: unit, unitId: integer, currentStock: integer, stockMax: integer) (native)

RemoveItemFromAllStock=nil       ---@type fun(itemId: integer) (native)
RemoveItemFromStock=nil          ---@type fun(whichUnit: unit, itemId: integer) (native)
RemoveUnitFromAllStock=nil       ---@type fun(unitId: integer) (native)
RemoveUnitFromStock=nil          ---@type fun(whichUnit: unit, unitId: integer) (native)

SetAllItemTypeSlots=nil          ---@type fun(slots: integer) (native)
SetAllUnitTypeSlots=nil          ---@type fun(slots: integer) (native)
SetItemTypeSlots=nil             ---@type fun(whichUnit: unit, slots: integer) (native)
SetUnitTypeSlots=nil             ---@type fun(whichUnit: unit, slots: integer) (native)

GetUnitUserData=nil              ---@type fun(whichUnit: unit): integer (native)
SetUnitUserData=nil              ---@type fun(whichUnit: unit, data: integer) (native)

--============================================================================
-- Player API
Player=nil              ---@type fun(number: integer): player (native)
GetLocalPlayer=nil      ---@type fun(): player (native)
IsPlayerAlly=nil        ---@type fun(whichPlayer: player, otherPlayer: player): boolean (native)
IsPlayerEnemy=nil       ---@type fun(whichPlayer: player, otherPlayer: player): boolean (native)
IsPlayerInForce=nil     ---@type fun(whichPlayer: player, whichForce: force): boolean (native)
IsPlayerObserver=nil    ---@type fun(whichPlayer: player): boolean (native)
IsVisibleToPlayer=nil           ---@type fun(x: number, y: number, whichPlayer: player): boolean (native)
IsLocationVisibleToPlayer=nil   ---@type fun(whichLocation: location, whichPlayer: player): boolean (native)
IsFoggedToPlayer=nil            ---@type fun(x: number, y: number, whichPlayer: player): boolean (native)
IsLocationFoggedToPlayer=nil    ---@type fun(whichLocation: location, whichPlayer: player): boolean (native)
IsMaskedToPlayer=nil            ---@type fun(x: number, y: number, whichPlayer: player): boolean (native)
IsLocationMaskedToPlayer=nil    ---@type fun(whichLocation: location, whichPlayer: player): boolean (native)

GetPlayerRace=nil           ---@type fun(whichPlayer: player): race (native)
GetPlayerId=nil             ---@type fun(whichPlayer: player): integer (native)
GetPlayerUnitCount=nil      ---@type fun(whichPlayer: player, includeIncomplete: boolean): integer (native)
GetPlayerTypedUnitCount=nil ---@type fun(whichPlayer: player, unitName: string, includeIncomplete: boolean, includeUpgrades: boolean): integer (native)
GetPlayerStructureCount=nil ---@type fun(whichPlayer: player, includeIncomplete: boolean): integer (native)
GetPlayerState=nil          ---@type fun(whichPlayer: player, whichPlayerState: playerstate): integer (native)
GetPlayerScore=nil          ---@type fun(whichPlayer: player, whichPlayerScore: playerscore): integer (native)
GetPlayerAlliance=nil       ---@type fun(sourcePlayer: player, otherPlayer: player, whichAllianceSetting: alliancetype): boolean (native)

GetPlayerHandicap=nil       ---@type fun(whichPlayer: player): number (native)
GetPlayerHandicapXP=nil     ---@type fun(whichPlayer: player): number (native)
GetPlayerHandicapReviveTime=nil ---@type fun(whichPlayer: player): number (native)
GetPlayerHandicapDamage=nil ---@type fun(whichPlayer: player): number (native)
SetPlayerHandicap=nil       ---@type fun(whichPlayer: player, handicap: number) (native)
SetPlayerHandicapXP=nil     ---@type fun(whichPlayer: player, handicap: number) (native)
SetPlayerHandicapReviveTime=nil ---@type fun(whichPlayer: player, handicap: number) (native)
SetPlayerHandicapDamage=nil ---@type fun(whichPlayer: player, handicap: number) (native)

SetPlayerTechMaxAllowed=nil ---@type fun(whichPlayer: player, techid: integer, maximum: integer) (native)
GetPlayerTechMaxAllowed=nil ---@type fun(whichPlayer: player, techid: integer): integer (native)
AddPlayerTechResearched=nil ---@type fun(whichPlayer: player, techid: integer, levels: integer) (native)
SetPlayerTechResearched=nil ---@type fun(whichPlayer: player, techid: integer, setToLevel: integer) (native)
GetPlayerTechResearched=nil ---@type fun(whichPlayer: player, techid: integer, specificonly: boolean): boolean (native)
GetPlayerTechCount=nil      ---@type fun(whichPlayer: player, techid: integer, specificonly: boolean): integer (native)

SetPlayerUnitsOwner=nil ---@type fun(whichPlayer: player, newOwner: integer) (native)
CripplePlayer=nil ---@type fun(whichPlayer: player, toWhichPlayers: force, flag: boolean) (native)

SetPlayerAbilityAvailable=nil        ---@type fun(whichPlayer: player, abilid: integer, avail: boolean) (native)

SetPlayerState=nil   ---@type fun(whichPlayer: player, whichPlayerState: playerstate, value: integer) (native)
RemovePlayer=nil     ---@type fun(whichPlayer: player, gameResult: playergameresult) (native)

-- Used to store hero level data for the scorescreen
-- before units are moved to neutral passive in melee games
--
CachePlayerHeroData=nil ---@type fun(whichPlayer: player) (native)

--============================================================================
-- Fog of War API
SetFogStateRect=nil      ---@type fun(forWhichPlayer: player, whichState: fogstate, where: rect, useSharedVision: boolean) (native)
SetFogStateRadius=nil    ---@type fun(forWhichPlayer: player, whichState: fogstate, centerx: number, centerY: number, radius: number, useSharedVision: boolean) (native)
SetFogStateRadiusLoc=nil ---@type fun(forWhichPlayer: player, whichState: fogstate, center: location, radius: number, useSharedVision: boolean) (native)
FogMaskEnable=nil        ---@type fun(enable: boolean) (native)
IsFogMaskEnabled=nil     ---@type fun(): boolean (native)
FogEnable=nil            ---@type fun(enable: boolean) (native)
IsFogEnabled=nil         ---@type fun(): boolean (native)

CreateFogModifierRect=nil        ---@type fun(forWhichPlayer: player, whichState: fogstate, where: rect, useSharedVision: boolean, afterUnits: boolean): fogmodifier (native)
CreateFogModifierRadius=nil      ---@type fun(forWhichPlayer: player, whichState: fogstate, centerx: number, centerY: number, radius: number, useSharedVision: boolean, afterUnits: boolean): fogmodifier (native)
CreateFogModifierRadiusLoc=nil   ---@type fun(forWhichPlayer: player, whichState: fogstate, center: location, radius: number, useSharedVision: boolean, afterUnits: boolean): fogmodifier (native)
DestroyFogModifier=nil           ---@type fun(whichFogModifier: fogmodifier) (native)
FogModifierStart=nil             ---@type fun(whichFogModifier: fogmodifier) (native)
FogModifierStop=nil              ---@type fun(whichFogModifier: fogmodifier) (native)

--============================================================================
-- Game API
VersionGet=nil ---@type fun(): version (native)
VersionCompatible=nil ---@type fun(whichVersion: version): boolean (native)
VersionSupported=nil ---@type fun(whichVersion: version): boolean (native)

EndGame=nil ---@type fun(doScoreScreen: boolean) (native)

-- Async only!
ChangeLevel=nil         ---@type fun(newLevel: string, doScoreScreen: boolean) (native)
RestartGame=nil         ---@type fun(doScoreScreen: boolean) (native)
ReloadGame=nil          ---@type fun() (native)
-- %%% SetCampaignMenuRace is deprecated.  It must remain to support
-- old maps which use it, but all new maps should use SetCampaignMenuRaceEx
SetCampaignMenuRace=nil ---@type fun(r: race) (native)
SetCampaignMenuRaceEx=nil ---@type fun(campaignIndex: integer) (native)
ForceCampaignSelectScreen=nil ---@type fun() (native)

LoadGame=nil                ---@type fun(saveFileName: string, doScoreScreen: boolean) (native)
SaveGame=nil                ---@type fun(saveFileName: string) (native)
RenameSaveDirectory=nil     ---@type fun(sourceDirName: string, destDirName: string): boolean (native)
RemoveSaveDirectory=nil     ---@type fun(sourceDirName: string): boolean (native)
CopySaveGame=nil            ---@type fun(sourceSaveName: string, destSaveName: string): boolean (native)
SaveGameExists=nil          ---@type fun(saveName: string): boolean (native)
SetMaxCheckpointSaves=nil   ---@type fun(maxCheckpointSaves: integer) (native)
SaveGameCheckpoint=nil      ---@type fun(saveFileName: string, showWindow: boolean) (native)
SyncSelections=nil          ---@type fun() (native)
SetFloatGameState=nil       ---@type fun(whichFloatGameState: fgamestate, value: number) (native)
GetFloatGameState=nil       ---@type fun(whichFloatGameState: fgamestate): number (native)
SetIntegerGameState=nil     ---@type fun(whichIntegerGameState: igamestate, value: integer) (native)
GetIntegerGameState=nil     ---@type fun(whichIntegerGameState: igamestate): integer (native)


--============================================================================
-- Campaign API
SetTutorialCleared=nil      ---@type fun(cleared: boolean) (native)
SetMissionAvailable=nil     ---@type fun(campaignNumber: integer, missionNumber: integer, available: boolean) (native)
SetCampaignAvailable=nil    ---@type fun(campaignNumber: integer, available: boolean) (native)
SetOpCinematicAvailable=nil ---@type fun(campaignNumber: integer, available: boolean) (native)
SetEdCinematicAvailable=nil ---@type fun(campaignNumber: integer, available: boolean) (native)
GetDefaultDifficulty=nil    ---@type fun(): gamedifficulty (native)
SetDefaultDifficulty=nil    ---@type fun(g: gamedifficulty) (native)
SetCustomCampaignButtonVisible=nil  ---@type fun(whichButton: integer, visible: boolean) (native)
GetCustomCampaignButtonVisible=nil  ---@type fun(whichButton: integer): boolean (native)
DoNotSaveReplay=nil         ---@type fun() (native)

--============================================================================
-- Dialog API
DialogCreate=nil                 ---@type fun(): dialog (native)
DialogDestroy=nil                ---@type fun(whichDialog: dialog) (native)
DialogClear=nil                  ---@type fun(whichDialog: dialog) (native)
DialogSetMessage=nil             ---@type fun(whichDialog: dialog, messageText: string) (native)
DialogAddButton=nil              ---@type fun(whichDialog: dialog, buttonText: string, hotkey: integer): button (native)
DialogAddQuitButton=nil          ---@type fun(whichDialog: dialog, doScoreScreen: boolean, buttonText: string, hotkey: integer): button (native)
DialogDisplay=nil                ---@type fun(whichPlayer: player, whichDialog: dialog, flag: boolean) (native)

-- Creates a new or reads in an existing game cache file stored
-- in the current campaign profile dir
--
ReloadGameCachesFromDisk=nil ---@type fun(): boolean (native)

InitGameCache=nil    ---@type fun(campaignFile: string): gamecache (native)
SaveGameCache=nil    ---@type fun(whichCache: gamecache): boolean (native)

StoreInteger=nil                    ---@type fun(cache: gamecache, missionKey: string, key: string, value: integer) (native)
StoreReal=nil                       ---@type fun(cache: gamecache, missionKey: string, key: string, value: number) (native)
StoreBoolean=nil                    ---@type fun(cache: gamecache, missionKey: string, key: string, value: boolean) (native)
StoreUnit=nil                       ---@type fun(cache: gamecache, missionKey: string, key: string, whichUnit: unit): boolean (native)
StoreString=nil                     ---@type fun(cache: gamecache, missionKey: string, key: string, value: string): boolean (native)

SyncStoredInteger=nil        ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
SyncStoredReal=nil           ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
SyncStoredBoolean=nil        ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
SyncStoredUnit=nil           ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
SyncStoredString=nil         ---@type fun(cache: gamecache, missionKey: string, key: string) (native)

HaveStoredInteger=nil                   ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)
HaveStoredReal=nil                      ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)
HaveStoredBoolean=nil                   ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)
HaveStoredUnit=nil                      ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)
HaveStoredString=nil                    ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)

FlushGameCache=nil                      ---@type fun(cache: gamecache) (native)
FlushStoredMission=nil                  ---@type fun(cache: gamecache, missionKey: string) (native)
FlushStoredInteger=nil                  ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
FlushStoredReal=nil                     ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
FlushStoredBoolean=nil                  ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
FlushStoredUnit=nil                     ---@type fun(cache: gamecache, missionKey: string, key: string) (native)
FlushStoredString=nil                   ---@type fun(cache: gamecache, missionKey: string, key: string) (native)

-- Will return 0 if the specified value's data is not found in the cache
GetStoredInteger=nil                ---@type fun(cache: gamecache, missionKey: string, key: string): integer (native)
GetStoredReal=nil                   ---@type fun(cache: gamecache, missionKey: string, key: string): number (native)
GetStoredBoolean=nil                ---@type fun(cache: gamecache, missionKey: string, key: string): boolean (native)
GetStoredString=nil                 ---@type fun(cache: gamecache, missionKey: string, key: string): string (native)
RestoreUnit=nil                     ---@type fun(cache: gamecache, missionKey: string, key: string, forWhichPlayer: player, x: number, y: number, facing: number): unit (native)


InitHashtable=nil    ---@type fun(): hashtable (native)

SaveInteger=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer, value: integer) (native)
SaveReal=nil                        ---@type fun(table: hashtable, parentKey: integer, childKey: integer, value: number) (native)
SaveBoolean=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer, value: boolean) (native)
SaveStr=nil                         ---@type fun(table: hashtable, parentKey: integer, childKey: integer, value: string): boolean (native)
SavePlayerHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichPlayer: player): boolean (native)
SaveWidgetHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichWidget: widget): boolean (native)
SaveDestructableHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichDestructable: destructable): boolean (native)
SaveItemHandle=nil                  ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichItem: item): boolean (native)
SaveUnitHandle=nil                  ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichUnit: unit): boolean (native)
SaveAbilityHandle=nil               ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichAbility: ability): boolean (native)
SaveTimerHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTimer: timer): boolean (native)
SaveTriggerHandle=nil               ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTrigger: trigger): boolean (native)
SaveTriggerConditionHandle=nil      ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTriggercondition: triggercondition): boolean (native)
SaveTriggerActionHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTriggeraction: triggeraction): boolean (native)
SaveTriggerEventHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichEvent: event): boolean (native)
SaveForceHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichForce: force): boolean (native)
SaveGroupHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichGroup: group): boolean (native)
SaveLocationHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichLocation: location): boolean (native)
SaveRectHandle=nil                  ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichRect: rect): boolean (native)
SaveBooleanExprHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichBoolexpr: boolexpr): boolean (native)
SaveSoundHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichSound: sound): boolean (native)
SaveEffectHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichEffect: effect): boolean (native)
SaveUnitPoolHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichUnitpool: unitpool): boolean (native)
SaveItemPoolHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichItempool: itempool): boolean (native)
SaveQuestHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichQuest: quest): boolean (native)
SaveQuestItemHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichQuestitem: questitem): boolean (native)
SaveDefeatConditionHandle=nil       ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichDefeatcondition: defeatcondition): boolean (native)
SaveTimerDialogHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTimerdialog: timerdialog): boolean (native)
SaveLeaderboardHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichLeaderboard: leaderboard): boolean (native)
SaveMultiboardHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichMultiboard: multiboard): boolean (native)
SaveMultiboardItemHandle=nil        ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichMultiboarditem: multiboarditem): boolean (native)
SaveTrackableHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTrackable: trackable): boolean (native)
SaveDialogHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichDialog: dialog): boolean (native)
SaveButtonHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichButton: button): boolean (native)
SaveTextTagHandle=nil               ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichTexttag: texttag): boolean (native)
SaveLightningHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichLightning: lightning): boolean (native)
SaveImageHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichImage: image): boolean (native)
SaveUbersplatHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichUbersplat: ubersplat): boolean (native)
SaveRegionHandle=nil                ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichRegion: region): boolean (native)
SaveFogStateHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichFogState: fogstate): boolean (native)
SaveFogModifierHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichFogModifier: fogmodifier): boolean (native)
SaveAgentHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichAgent: agent): boolean (native)
SaveHashtableHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichHashtable: hashtable): boolean (native)
SaveFrameHandle=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer, whichFrameHandle: framehandle): boolean (native)


LoadInteger=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer): integer (native)
LoadReal=nil                    ---@type fun(table: hashtable, parentKey: integer, childKey: integer): number (native)
LoadBoolean=nil                 ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)
LoadStr=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer): string (native)
LoadPlayerHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): player (native)
LoadWidgetHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): widget (native)
LoadDestructableHandle=nil      ---@type fun(table: hashtable, parentKey: integer, childKey: integer): destructable (native)
LoadItemHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer): item (native)
LoadUnitHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer): unit (native)
LoadAbilityHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer): ability (native)
LoadTimerHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): timer (native)
LoadTriggerHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer): trigger (native)
LoadTriggerConditionHandle=nil  ---@type fun(table: hashtable, parentKey: integer, childKey: integer): triggercondition (native)
LoadTriggerActionHandle=nil     ---@type fun(table: hashtable, parentKey: integer, childKey: integer): triggeraction (native)
LoadTriggerEventHandle=nil      ---@type fun(table: hashtable, parentKey: integer, childKey: integer): event (native)
LoadForceHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): force (native)
LoadGroupHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): group (native)
LoadLocationHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer): location (native)
LoadRectHandle=nil              ---@type fun(table: hashtable, parentKey: integer, childKey: integer): rect (native)
LoadBooleanExprHandle=nil       ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolexpr (native)
LoadSoundHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): sound (native)
LoadEffectHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): effect (native)
LoadUnitPoolHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer): unitpool (native)
LoadItemPoolHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer): itempool (native)
LoadQuestHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): quest (native)
LoadQuestItemHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer): questitem (native)
LoadDefeatConditionHandle=nil   ---@type fun(table: hashtable, parentKey: integer, childKey: integer): defeatcondition (native)
LoadTimerDialogHandle=nil       ---@type fun(table: hashtable, parentKey: integer, childKey: integer): timerdialog (native)
LoadLeaderboardHandle=nil       ---@type fun(table: hashtable, parentKey: integer, childKey: integer): leaderboard (native)
LoadMultiboardHandle=nil        ---@type fun(table: hashtable, parentKey: integer, childKey: integer): multiboard (native)
LoadMultiboardItemHandle=nil    ---@type fun(table: hashtable, parentKey: integer, childKey: integer): multiboarditem (native)
LoadTrackableHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer): trackable (native)
LoadDialogHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): dialog (native)
LoadButtonHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): button (native)
LoadTextTagHandle=nil           ---@type fun(table: hashtable, parentKey: integer, childKey: integer): texttag (native)
LoadLightningHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer): lightning (native)
LoadImageHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): image (native)
LoadUbersplatHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer): ubersplat (native)
LoadRegionHandle=nil            ---@type fun(table: hashtable, parentKey: integer, childKey: integer): region (native)
LoadFogStateHandle=nil          ---@type fun(table: hashtable, parentKey: integer, childKey: integer): fogstate (native)
LoadFogModifierHandle=nil       ---@type fun(table: hashtable, parentKey: integer, childKey: integer): fogmodifier (native)
LoadHashtableHandle=nil         ---@type fun(table: hashtable, parentKey: integer, childKey: integer): hashtable (native)
LoadFrameHandle=nil             ---@type fun(table: hashtable, parentKey: integer, childKey: integer): framehandle (native)

HaveSavedInteger=nil                    ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)
HaveSavedReal=nil                       ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)
HaveSavedBoolean=nil                    ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)
HaveSavedString=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)
HaveSavedHandle=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer): boolean (native)

RemoveSavedInteger=nil                  ---@type fun(table: hashtable, parentKey: integer, childKey: integer) (native)
RemoveSavedReal=nil                     ---@type fun(table: hashtable, parentKey: integer, childKey: integer) (native)
RemoveSavedBoolean=nil                  ---@type fun(table: hashtable, parentKey: integer, childKey: integer) (native)
RemoveSavedString=nil                   ---@type fun(table: hashtable, parentKey: integer, childKey: integer) (native)
RemoveSavedHandle=nil                   ---@type fun(table: hashtable, parentKey: integer, childKey: integer) (native)

FlushParentHashtable=nil                        ---@type fun(table: hashtable) (native)
FlushChildHashtable=nil                 ---@type fun(table: hashtable, parentKey: integer) (native)


--============================================================================
-- Randomization API
GetRandomInt=nil ---@type fun(lowBound: integer, highBound: integer): integer (native)
GetRandomReal=nil ---@type fun(lowBound: number, highBound: number): number (native)

CreateUnitPool=nil           ---@type fun(): unitpool (native)
DestroyUnitPool=nil          ---@type fun(whichPool: unitpool) (native)
UnitPoolAddUnitType=nil      ---@type fun(whichPool: unitpool, unitId: integer, weight: number) (native)
UnitPoolRemoveUnitType=nil   ---@type fun(whichPool: unitpool, unitId: integer) (native)
PlaceRandomUnit=nil          ---@type fun(whichPool: unitpool, forWhichPlayer: player, x: number, y: number, facing: number): unit (native)

CreateItemPool=nil           ---@type fun(): itempool (native)
DestroyItemPool=nil          ---@type fun(whichItemPool: itempool) (native)
ItemPoolAddItemType=nil      ---@type fun(whichItemPool: itempool, itemId: integer, weight: number) (native)
ItemPoolRemoveItemType=nil   ---@type fun(whichItemPool: itempool, itemId: integer) (native)
PlaceRandomItem=nil          ---@type fun(whichItemPool: itempool, x: number, y: number): item (native)

-- Choose any random unit/item. (NP means Neutral Passive)
ChooseRandomCreep=nil        ---@type fun(level: integer): integer (native)
ChooseRandomNPBuilding=nil   ---@type fun(): integer (native)
ChooseRandomItem=nil         ---@type fun(level: integer): integer (native)
ChooseRandomItemEx=nil       ---@type fun(whichType: itemtype, level: integer): integer (native)
SetRandomSeed=nil            ---@type fun(seed: integer) (native)

--============================================================================
-- Visual API
SetTerrainFog=nil                ---@type fun(a: number, b: number, c: number, d: number, e: number) (native)
ResetTerrainFog=nil              ---@type fun() (native)

SetUnitFog=nil                   ---@type fun(a: number, b: number, c: number, d: number, e: number) (native)
SetTerrainFogEx=nil              ---@type fun(style: integer, zstart: number, zend: number, density: number, red: number, green: number, blue: number) (native)
DisplayTextToPlayer=nil          ---@type fun(toPlayer: player, x: number, y: number, message: string) (native)
DisplayTimedTextToPlayer=nil     ---@type fun(toPlayer: player, x: number, y: number, duration: number, message: string) (native)
DisplayTimedTextFromPlayer=nil   ---@type fun(toPlayer: player, x: number, y: number, duration: number, message: string) (native)
ClearTextMessages=nil            ---@type fun() (native)
SetDayNightModels=nil            ---@type fun(terrainDNCFile: string, unitDNCFile: string) (native)
SetPortraitLight=nil             ---@type fun(portraitDNCFile: string) (native)
SetSkyModel=nil                  ---@type fun(skyModelFile: string) (native)
EnableUserControl=nil            ---@type fun(b: boolean) (native)
EnableUserUI=nil                 ---@type fun(b: boolean) (native)
SuspendTimeOfDay=nil             ---@type fun(b: boolean) (native)
SetTimeOfDayScale=nil            ---@type fun(r: number) (native)
GetTimeOfDayScale=nil            ---@type fun(): number (native)
ShowInterface=nil                ---@type fun(flag: boolean, fadeDuration: number) (native)
PauseGame=nil                    ---@type fun(flag: boolean) (native)
UnitAddIndicator=nil             ---@type fun(whichUnit: unit, red: integer, green: integer, blue: integer, alpha: integer) (native)
AddIndicator=nil                 ---@type fun(whichWidget: widget, red: integer, green: integer, blue: integer, alpha: integer) (native)
PingMinimap=nil                  ---@type fun(x: number, y: number, duration: number) (native)
PingMinimapEx=nil                ---@type fun(x: number, y: number, duration: number, red: integer, green: integer, blue: integer, extraEffects: boolean) (native)
CreateMinimapIconOnUnit=nil      ---@type fun(whichUnit: unit, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate): minimapicon (native)
CreateMinimapIconAtLoc=nil       ---@type fun(where: location, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate): minimapicon (native)
CreateMinimapIcon=nil            ---@type fun(x: number, y: number, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate): minimapicon (native)
SkinManagerGetLocalPath=nil      ---@type fun(key: string): string (native)
DestroyMinimapIcon=nil           ---@type fun(pingId: minimapicon) (native)
SetMinimapIconVisible=nil        ---@type fun(whichMinimapIcon: minimapicon, visible: boolean) (native)
SetMinimapIconOrphanDestroy=nil  ---@type fun(whichMinimapIcon: minimapicon, doDestroy: boolean) (native)
EnableOcclusion=nil              ---@type fun(flag: boolean) (native)
SetIntroShotText=nil             ---@type fun(introText: string) (native)
SetIntroShotModel=nil            ---@type fun(introModelPath: string) (native)
EnableWorldFogBoundary=nil       ---@type fun(b: boolean) (native)
PlayModelCinematic=nil           ---@type fun(modelName: string) (native)
PlayCinematic=nil                ---@type fun(movieName: string) (native)
ForceUIKey=nil                   ---@type fun(key: string) (native)
ForceUICancel=nil                ---@type fun() (native)
DisplayLoadDialog=nil            ---@type fun() (native)
SetAltMinimapIcon=nil            ---@type fun(iconPath: string) (native)
DisableRestartMission=nil        ---@type fun(flag: boolean) (native)

CreateTextTag=nil                ---@type fun(): texttag (native)
DestroyTextTag=nil               ---@type fun(t: texttag) (native)
SetTextTagText=nil               ---@type fun(t: texttag, s: string, height: number) (native)
SetTextTagPos=nil                ---@type fun(t: texttag, x: number, y: number, heightOffset: number) (native)
SetTextTagPosUnit=nil            ---@type fun(t: texttag, whichUnit: unit, heightOffset: number) (native)
SetTextTagColor=nil              ---@type fun(t: texttag, red: integer, green: integer, blue: integer, alpha: integer) (native)
SetTextTagVelocity=nil           ---@type fun(t: texttag, xvel: number, yvel: number) (native)
SetTextTagVisibility=nil         ---@type fun(t: texttag, flag: boolean) (native)
SetTextTagSuspended=nil          ---@type fun(t: texttag, flag: boolean) (native)
SetTextTagPermanent=nil          ---@type fun(t: texttag, flag: boolean) (native)
SetTextTagAge=nil                ---@type fun(t: texttag, age: number) (native)
SetTextTagLifespan=nil           ---@type fun(t: texttag, lifespan: number) (native)
SetTextTagFadepoint=nil          ---@type fun(t: texttag, fadepoint: number) (native)

SetReservedLocalHeroButtons=nil  ---@type fun(reserved: integer) (native)
GetAllyColorFilterState=nil      ---@type fun(): integer (native)
SetAllyColorFilterState=nil      ---@type fun(state: integer) (native)
GetCreepCampFilterState=nil      ---@type fun(): boolean (native)
SetCreepCampFilterState=nil      ---@type fun(state: boolean) (native)
EnableMinimapFilterButtons=nil   ---@type fun(enableAlly: boolean, enableCreep: boolean) (native)
EnableDragSelect=nil             ---@type fun(state: boolean, ui: boolean) (native)
EnablePreSelect=nil              ---@type fun(state: boolean, ui: boolean) (native)
EnableSelect=nil                 ---@type fun(state: boolean, ui: boolean) (native)

--============================================================================
-- Trackable API
CreateTrackable=nil      ---@type fun(trackableModelPath: string, x: number, y: number, facing: number): trackable (native)

--============================================================================
-- Quest API
CreateQuest=nil          ---@type fun(): quest (native)
DestroyQuest=nil         ---@type fun(whichQuest: quest) (native)
QuestSetTitle=nil        ---@type fun(whichQuest: quest, title: string) (native)
QuestSetDescription=nil  ---@type fun(whichQuest: quest, description: string) (native)
QuestSetIconPath=nil     ---@type fun(whichQuest: quest, iconPath: string) (native)

QuestSetRequired=nil     ---@type fun(whichQuest: quest, required: boolean) (native)
QuestSetCompleted=nil    ---@type fun(whichQuest: quest, completed: boolean) (native)
QuestSetDiscovered=nil   ---@type fun(whichQuest: quest, discovered: boolean) (native)
QuestSetFailed=nil       ---@type fun(whichQuest: quest, failed: boolean) (native)
QuestSetEnabled=nil      ---@type fun(whichQuest: quest, enabled: boolean) (native)

IsQuestRequired=nil     ---@type fun(whichQuest: quest): boolean (native)
IsQuestCompleted=nil    ---@type fun(whichQuest: quest): boolean (native)
IsQuestDiscovered=nil   ---@type fun(whichQuest: quest): boolean (native)
IsQuestFailed=nil       ---@type fun(whichQuest: quest): boolean (native)
IsQuestEnabled=nil      ---@type fun(whichQuest: quest): boolean (native)

QuestCreateItem=nil          ---@type fun(whichQuest: quest): questitem (native)
QuestItemSetDescription=nil  ---@type fun(whichQuestItem: questitem, description: string) (native)
QuestItemSetCompleted=nil    ---@type fun(whichQuestItem: questitem, completed: boolean) (native)

IsQuestItemCompleted=nil     ---@type fun(whichQuestItem: questitem): boolean (native)

CreateDefeatCondition=nil            ---@type fun(): defeatcondition (native)
DestroyDefeatCondition=nil           ---@type fun(whichCondition: defeatcondition) (native)
DefeatConditionSetDescription=nil    ---@type fun(whichCondition: defeatcondition, description: string) (native)

FlashQuestDialogButton=nil   ---@type fun() (native)
ForceQuestDialogUpdate=nil   ---@type fun() (native)

--============================================================================
-- Timer Dialog API
CreateTimerDialog=nil                ---@type fun(t: timer): timerdialog (native)
DestroyTimerDialog=nil               ---@type fun(whichDialog: timerdialog) (native)
TimerDialogSetTitle=nil              ---@type fun(whichDialog: timerdialog, title: string) (native)
TimerDialogSetTitleColor=nil         ---@type fun(whichDialog: timerdialog, red: integer, green: integer, blue: integer, alpha: integer) (native)
TimerDialogSetTimeColor=nil          ---@type fun(whichDialog: timerdialog, red: integer, green: integer, blue: integer, alpha: integer) (native)
TimerDialogSetSpeed=nil              ---@type fun(whichDialog: timerdialog, speedMultFactor: number) (native)
TimerDialogDisplay=nil               ---@type fun(whichDialog: timerdialog, display: boolean) (native)
IsTimerDialogDisplayed=nil           ---@type fun(whichDialog: timerdialog): boolean (native)
TimerDialogSetRealTimeRemaining=nil  ---@type fun(whichDialog: timerdialog, timeRemaining: number) (native)

--============================================================================
-- Leaderboard API

-- Create a leaderboard object
CreateLeaderboard=nil                ---@type fun(): leaderboard (native)
DestroyLeaderboard=nil               ---@type fun(lb: leaderboard) (native)

LeaderboardDisplay=nil               ---@type fun(lb: leaderboard, show: boolean) (native)
IsLeaderboardDisplayed=nil           ---@type fun(lb: leaderboard): boolean (native)

LeaderboardGetItemCount=nil          ---@type fun(lb: leaderboard): integer (native)

LeaderboardSetSizeByItemCount=nil    ---@type fun(lb: leaderboard, count: integer) (native)
LeaderboardAddItem=nil               ---@type fun(lb: leaderboard, label: string, value: integer, p: player) (native)
LeaderboardRemoveItem=nil            ---@type fun(lb: leaderboard, index: integer) (native)
LeaderboardRemovePlayerItem=nil      ---@type fun(lb: leaderboard, p: player) (native)
LeaderboardClear=nil                 ---@type fun(lb: leaderboard) (native)

LeaderboardSortItemsByValue=nil      ---@type fun(lb: leaderboard, ascending: boolean) (native)
LeaderboardSortItemsByPlayer=nil     ---@type fun(lb: leaderboard, ascending: boolean) (native)
LeaderboardSortItemsByLabel=nil      ---@type fun(lb: leaderboard, ascending: boolean) (native)

LeaderboardHasPlayerItem=nil         ---@type fun(lb: leaderboard, p: player): boolean (native)
LeaderboardGetPlayerIndex=nil        ---@type fun(lb: leaderboard, p: player): integer (native)
LeaderboardSetLabel=nil              ---@type fun(lb: leaderboard, label: string) (native)
LeaderboardGetLabelText=nil          ---@type fun(lb: leaderboard): string (native)

PlayerSetLeaderboard=nil             ---@type fun(toPlayer: player, lb: leaderboard) (native)
PlayerGetLeaderboard=nil             ---@type fun(toPlayer: player): leaderboard (native)

LeaderboardSetLabelColor=nil         ---@type fun(lb: leaderboard, red: integer, green: integer, blue: integer, alpha: integer) (native)
LeaderboardSetValueColor=nil         ---@type fun(lb: leaderboard, red: integer, green: integer, blue: integer, alpha: integer) (native)
LeaderboardSetStyle=nil              ---@type fun(lb: leaderboard, showLabel: boolean, showNames: boolean, showValues: boolean, showIcons: boolean) (native)

LeaderboardSetItemValue=nil          ---@type fun(lb: leaderboard, whichItem: integer, val: integer) (native)
LeaderboardSetItemLabel=nil          ---@type fun(lb: leaderboard, whichItem: integer, val: string) (native)
LeaderboardSetItemStyle=nil          ---@type fun(lb: leaderboard, whichItem: integer, showLabel: boolean, showValue: boolean, showIcon: boolean) (native)
LeaderboardSetItemLabelColor=nil     ---@type fun(lb: leaderboard, whichItem: integer, red: integer, green: integer, blue: integer, alpha: integer) (native)
LeaderboardSetItemValueColor=nil     ---@type fun(lb: leaderboard, whichItem: integer, red: integer, green: integer, blue: integer, alpha: integer) (native)

--============================================================================
-- Multiboard API
--============================================================================

-- Create a multiboard object
CreateMultiboard=nil                 ---@type fun(): multiboard (native)
DestroyMultiboard=nil                ---@type fun(lb: multiboard) (native)

MultiboardDisplay=nil                ---@type fun(lb: multiboard, show: boolean) (native)
IsMultiboardDisplayed=nil            ---@type fun(lb: multiboard): boolean (native)

MultiboardMinimize=nil               ---@type fun(lb: multiboard, minimize: boolean) (native)
IsMultiboardMinimized=nil            ---@type fun(lb: multiboard): boolean (native)
MultiboardClear=nil                  ---@type fun(lb: multiboard) (native)

MultiboardSetTitleText=nil           ---@type fun(lb: multiboard, label: string) (native)
MultiboardGetTitleText=nil           ---@type fun(lb: multiboard): string (native)
MultiboardSetTitleTextColor=nil      ---@type fun(lb: multiboard, red: integer, green: integer, blue: integer, alpha: integer) (native)

MultiboardGetRowCount=nil            ---@type fun(lb: multiboard): integer (native)
MultiboardGetColumnCount=nil         ---@type fun(lb: multiboard): integer (native)

MultiboardSetColumnCount=nil         ---@type fun(lb: multiboard, count: integer) (native)
MultiboardSetRowCount=nil            ---@type fun(lb: multiboard, count: integer) (native)

-- broadcast settings to all items
MultiboardSetItemsStyle=nil          ---@type fun(lb: multiboard, showValues: boolean, showIcons: boolean) (native)
MultiboardSetItemsValue=nil          ---@type fun(lb: multiboard, value: string) (native)
MultiboardSetItemsValueColor=nil     ---@type fun(lb: multiboard, red: integer, green: integer, blue: integer, alpha: integer) (native)
MultiboardSetItemsWidth=nil          ---@type fun(lb: multiboard, width: number) (native)
MultiboardSetItemsIcon=nil           ---@type fun(lb: multiboard, iconPath: string) (native)


-- funcs for modifying individual items
MultiboardGetItem=nil                ---@type fun(lb: multiboard, row: integer, column: integer): multiboarditem (native)
MultiboardReleaseItem=nil            ---@type fun(mbi: multiboarditem) (native)

MultiboardSetItemStyle=nil           ---@type fun(mbi: multiboarditem, showValue: boolean, showIcon: boolean) (native)
MultiboardSetItemValue=nil           ---@type fun(mbi: multiboarditem, val: string) (native)
MultiboardSetItemValueColor=nil      ---@type fun(mbi: multiboarditem, red: integer, green: integer, blue: integer, alpha: integer) (native)
MultiboardSetItemWidth=nil           ---@type fun(mbi: multiboarditem, width: number) (native)
MultiboardSetItemIcon=nil            ---@type fun(mbi: multiboarditem, iconFileName: string) (native)

-- meant to unequivocally suspend display of existing and
-- subsequently displayed multiboards
--
MultiboardSuppressDisplay=nil        ---@type fun(flag: boolean) (native)

--============================================================================
-- Camera API
SetCameraPosition=nil            ---@type fun(x: number, y: number) (native)
SetCameraQuickPosition=nil       ---@type fun(x: number, y: number) (native)
SetCameraBounds=nil              ---@type fun(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number) (native)
StopCamera=nil                   ---@type fun() (native)
ResetToGameCamera=nil            ---@type fun(duration: number) (native)
PanCameraTo=nil                  ---@type fun(x: number, y: number) (native)
PanCameraToTimed=nil             ---@type fun(x: number, y: number, duration: number) (native)
PanCameraToWithZ=nil             ---@type fun(x: number, y: number, zOffsetDest: number) (native)
PanCameraToTimedWithZ=nil        ---@type fun(x: number, y: number, zOffsetDest: number, duration: number) (native)
SetCinematicCamera=nil           ---@type fun(cameraModelFile: string) (native)
SetCameraRotateMode=nil          ---@type fun(x: number, y: number, radiansToSweep: number, duration: number) (native)
SetCameraField=nil               ---@type fun(whichField: camerafield, value: number, duration: number) (native)
AdjustCameraField=nil            ---@type fun(whichField: camerafield, offset: number, duration: number) (native)
SetCameraTargetController=nil    ---@type fun(whichUnit: unit, xoffset: number, yoffset: number, inheritOrientation: boolean) (native)
SetCameraOrientController=nil    ---@type fun(whichUnit: unit, xoffset: number, yoffset: number) (native)

CreateCameraSetup=nil                    ---@type fun(): camerasetup (native)
CameraSetupSetField=nil                  ---@type fun(whichSetup: camerasetup, whichField: camerafield, value: number, duration: number) (native)
CameraSetupGetField=nil                  ---@type fun(whichSetup: camerasetup, whichField: camerafield): number (native)
CameraSetupSetDestPosition=nil           ---@type fun(whichSetup: camerasetup, x: number, y: number, duration: number) (native)
CameraSetupGetDestPositionLoc=nil        ---@type fun(whichSetup: camerasetup): location (native)
CameraSetupGetDestPositionX=nil          ---@type fun(whichSetup: camerasetup): number (native)
CameraSetupGetDestPositionY=nil          ---@type fun(whichSetup: camerasetup): number (native)
CameraSetupApply=nil                     ---@type fun(whichSetup: camerasetup, doPan: boolean, panTimed: boolean) (native)
CameraSetupApplyWithZ=nil                ---@type fun(whichSetup: camerasetup, zDestOffset: number) (native)
CameraSetupApplyForceDuration=nil        ---@type fun(whichSetup: camerasetup, doPan: boolean, forceDuration: number) (native)
CameraSetupApplyForceDurationWithZ=nil   ---@type fun(whichSetup: camerasetup, zDestOffset: number, forceDuration: number) (native)
BlzCameraSetupSetLabel=nil               ---@type fun(whichSetup: camerasetup, label: string) (native)
BlzCameraSetupGetLabel=nil               ---@type fun(whichSetup: camerasetup): string (native)

CameraSetTargetNoise=nil             ---@type fun(mag: number, velocity: number) (native)
CameraSetSourceNoise=nil             ---@type fun(mag: number, velocity: number) (native)

CameraSetTargetNoiseEx=nil           ---@type fun(mag: number, velocity: number, vertOnly: boolean) (native)
CameraSetSourceNoiseEx=nil           ---@type fun(mag: number, velocity: number, vertOnly: boolean) (native)

CameraSetSmoothingFactor=nil         ---@type fun(factor: number) (native)

CameraSetFocalDistance=nil           ---@type fun(distance: number) (native)
CameraSetDepthOfFieldScale=nil       ---@type fun(scale: number) (native)

SetCineFilterTexture=nil             ---@type fun(filename: string) (native)
SetCineFilterBlendMode=nil           ---@type fun(whichMode: blendmode) (native)
SetCineFilterTexMapFlags=nil         ---@type fun(whichFlags: texmapflags) (native)
SetCineFilterStartUV=nil             ---@type fun(minu: number, minv: number, maxu: number, maxv: number) (native)
SetCineFilterEndUV=nil               ---@type fun(minu: number, minv: number, maxu: number, maxv: number) (native)
SetCineFilterStartColor=nil          ---@type fun(red: integer, green: integer, blue: integer, alpha: integer) (native)
SetCineFilterEndColor=nil            ---@type fun(red: integer, green: integer, blue: integer, alpha: integer) (native)
SetCineFilterDuration=nil            ---@type fun(duration: number) (native)
DisplayCineFilter=nil                ---@type fun(flag: boolean) (native)
IsCineFilterDisplayed=nil            ---@type fun(): boolean (native)

SetCinematicScene=nil                ---@type fun(portraitUnitId: integer, color: playercolor, speakerTitle: string, text: string, sceneDuration: number, voiceoverDuration: number) (native)
EndCinematicScene=nil                ---@type fun() (native)
ForceCinematicSubtitles=nil          ---@type fun(flag: boolean) (native)
SetCinematicAudio=nil                ---@type fun(cinematicAudio: boolean) (native)

GetCameraMargin=nil                  ---@type fun(whichMargin: integer): number (native)

-- These return values for the local players camera only...
GetCameraBoundMinX=nil          ---@type fun(): number (native)
GetCameraBoundMinY=nil          ---@type fun(): number (native)
GetCameraBoundMaxX=nil          ---@type fun(): number (native)
GetCameraBoundMaxY=nil          ---@type fun(): number (native)
GetCameraField=nil              ---@type fun(whichField: camerafield): number (native)
GetCameraTargetPositionX=nil    ---@type fun(): number (native)
GetCameraTargetPositionY=nil    ---@type fun(): number (native)
GetCameraTargetPositionZ=nil    ---@type fun(): number (native)
GetCameraTargetPositionLoc=nil  ---@type fun(): location (native)
GetCameraEyePositionX=nil       ---@type fun(): number (native)
GetCameraEyePositionY=nil       ---@type fun(): number (native)
GetCameraEyePositionZ=nil       ---@type fun(): number (native)
GetCameraEyePositionLoc=nil     ---@type fun(): location (native)

--============================================================================
-- Sound API
--
NewSoundEnvironment=nil          ---@type fun(environmentName: string) (native)

CreateSound=nil                  ---@type fun(fileName: string, looping: boolean, is3D: boolean, stopwhenoutofrange: boolean, fadeInRate: integer, fadeOutRate: integer, eaxSetting: string): sound (native)
CreateSoundFilenameWithLabel=nil ---@type fun(fileName: string, looping: boolean, is3D: boolean, stopwhenoutofrange: boolean, fadeInRate: integer, fadeOutRate: integer, SLKEntryName: string): sound (native)
CreateSoundFromLabel=nil         ---@type fun(soundLabel: string, looping: boolean, is3D: boolean, stopwhenoutofrange: boolean, fadeInRate: integer, fadeOutRate: integer): sound (native)
CreateMIDISound=nil              ---@type fun(soundLabel: string, fadeInRate: integer, fadeOutRate: integer): sound (native)

SetSoundParamsFromLabel=nil      ---@type fun(soundHandle: sound, soundLabel: string) (native)
SetSoundDistanceCutoff=nil       ---@type fun(soundHandle: sound, cutoff: number) (native)
SetSoundChannel=nil              ---@type fun(soundHandle: sound, channel: integer) (native)
SetSoundVolume=nil               ---@type fun(soundHandle: sound, volume: integer) (native)
SetSoundPitch=nil                ---@type fun(soundHandle: sound, pitch: number) (native)

-- the following method must be called immediately after calling "StartSound"
SetSoundPlayPosition=nil         ---@type fun(soundHandle: sound, millisecs: integer) (native)

-- these calls are only valid if the sound was created with 3d enabled
SetSoundDistances=nil            ---@type fun(soundHandle: sound, minDist: number, maxDist: number) (native)
SetSoundConeAngles=nil           ---@type fun(soundHandle: sound, inside: number, outside: number, outsideVolume: integer) (native)
SetSoundConeOrientation=nil      ---@type fun(soundHandle: sound, x: number, y: number, z: number) (native)
SetSoundPosition=nil             ---@type fun(soundHandle: sound, x: number, y: number, z: number) (native)
SetSoundVelocity=nil             ---@type fun(soundHandle: sound, x: number, y: number, z: number) (native)
AttachSoundToUnit=nil            ---@type fun(soundHandle: sound, whichUnit: unit) (native)

StartSound=nil                   ---@type fun(soundHandle: sound) (native)
StartSoundEx=nil                 ---@type fun(soundHandle: sound, fadeIn: boolean) (native)
StopSound=nil                    ---@type fun(soundHandle: sound, killWhenDone: boolean, fadeOut: boolean) (native)
KillSoundWhenDone=nil            ---@type fun(soundHandle: sound) (native)

-- Music Interface. Note that if music is disabled, these calls do nothing
SetMapMusic=nil                  ---@type fun(musicName: string, random: boolean, index: integer) (native)
ClearMapMusic=nil                ---@type fun() (native)

PlayMusic=nil                    ---@type fun(musicName: string) (native)
PlayMusicEx=nil                  ---@type fun(musicName: string, frommsecs: integer, fadeinmsecs: integer) (native)
StopMusic=nil                    ---@type fun(fadeOut: boolean) (native)
ResumeMusic=nil                  ---@type fun() (native)

PlayThematicMusic=nil            ---@type fun(musicFileName: string) (native)
PlayThematicMusicEx=nil          ---@type fun(musicFileName: string, frommsecs: integer) (native)
EndThematicMusic=nil             ---@type fun() (native)

SetMusicVolume=nil               ---@type fun(volume: integer) (native)
SetMusicPlayPosition=nil         ---@type fun(millisecs: integer) (native)
SetThematicMusicVolume=nil       ---@type fun(volume: integer) (native)
SetThematicMusicPlayPosition=nil ---@type fun(millisecs: integer) (native)

-- other music and sound calls
SetSoundDuration=nil             ---@type fun(soundHandle: sound, duration: integer) (native)
GetSoundDuration=nil             ---@type fun(soundHandle: sound): integer (native)
GetSoundFileDuration=nil         ---@type fun(musicFileName: string): integer (native)

VolumeGroupSetVolume=nil         ---@type fun(vgroup: volumegroup, scale: number) (native)
VolumeGroupReset=nil             ---@type fun() (native)

GetSoundIsPlaying=nil            ---@type fun(soundHandle: sound): boolean (native)
GetSoundIsLoading=nil            ---@type fun(soundHandle: sound): boolean (native)

RegisterStackedSound=nil         ---@type fun(soundHandle: sound, byPosition: boolean, rectwidth: number, rectheight: number) (native)
UnregisterStackedSound=nil       ---@type fun(soundHandle: sound, byPosition: boolean, rectwidth: number, rectheight: number) (native)

SetSoundFacialAnimationLabel=nil ---@type fun(soundHandle: sound, animationLabel: string): boolean (native)
SetSoundFacialAnimationGroupLabel=nil ---@type fun(soundHandle: sound, groupLabel: string): boolean (native)
SetSoundFacialAnimationSetFilepath=nil ---@type fun(soundHandle: sound, animationSetFilepath: string): boolean (native)

--Subtitle support that is attached to the soundHandle rather than as disperate data with the legacy UI
SetDialogueSpeakerNameKey=nil    ---@type fun(soundHandle: sound, speakerName: string): boolean (native)
GetDialogueSpeakerNameKey=nil    ---@type fun(soundHandle: sound): string (native)
SetDialogueTextKey=nil           ---@type fun(soundHandle: sound, dialogueText: string): boolean (native)
GetDialogueTextKey=nil           ---@type fun(soundHandle: sound): string (native)

--============================================================================
-- Effects API
--
AddWeatherEffect=nil             ---@type fun(where: rect, effectID: integer): weathereffect (native)
RemoveWeatherEffect=nil          ---@type fun(whichEffect: weathereffect) (native)
EnableWeatherEffect=nil          ---@type fun(whichEffect: weathereffect, enable: boolean) (native)

TerrainDeformCrater=nil          ---@type fun(x: number, y: number, radius: number, depth: number, duration: integer, permanent: boolean): terraindeformation (native)
TerrainDeformRipple=nil          ---@type fun(x: number, y: number, radius: number, depth: number, duration: integer, count: integer, spaceWaves: number, timeWaves: number, radiusStartPct: number, limitNeg: boolean): terraindeformation (native)
TerrainDeformWave=nil            ---@type fun(x: number, y: number, dirX: number, dirY: number, distance: number, speed: number, radius: number, depth: number, trailTime: integer, count: integer): terraindeformation (native)
TerrainDeformRandom=nil          ---@type fun(x: number, y: number, radius: number, minDelta: number, maxDelta: number, duration: integer, updateInterval: integer): terraindeformation (native)
TerrainDeformStop=nil            ---@type fun(deformation: terraindeformation, duration: integer) (native)
TerrainDeformStopAll=nil         ---@type fun() (native)

AddSpecialEffect=nil             ---@type fun(modelName: string, x: number, y: number): effect (native)
AddSpecialEffectLoc=nil          ---@type fun(modelName: string, where: location): effect (native)
AddSpecialEffectTarget=nil       ---@type fun(modelName: string, targetWidget: widget, attachPointName: string): effect (native)
DestroyEffect=nil                ---@type fun(whichEffect: effect) (native)

AddSpellEffect=nil               ---@type fun(abilityString: string, t: effecttype, x: number, y: number): effect (native)
AddSpellEffectLoc=nil            ---@type fun(abilityString: string, t: effecttype, where: location): effect (native)
AddSpellEffectById=nil           ---@type fun(abilityId: integer, t: effecttype, x: number, y: number): effect (native)
AddSpellEffectByIdLoc=nil        ---@type fun(abilityId: integer, t: effecttype, where: location): effect (native)
AddSpellEffectTarget=nil         ---@type fun(modelName: string, t: effecttype, targetWidget: widget, attachPoint: string): effect (native)
AddSpellEffectTargetById=nil     ---@type fun(abilityId: integer, t: effecttype, targetWidget: widget, attachPoint: string): effect (native)

AddLightning=nil                 ---@type fun(codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number): lightning (native)
AddLightningEx=nil               ---@type fun(codeName: string, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): lightning (native)
DestroyLightning=nil             ---@type fun(whichBolt: lightning): boolean (native)
MoveLightning=nil                ---@type fun(whichBolt: lightning, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number): boolean (native)
MoveLightningEx=nil              ---@type fun(whichBolt: lightning, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): boolean (native)
GetLightningColorA=nil           ---@type fun(whichBolt: lightning): number (native)
GetLightningColorR=nil           ---@type fun(whichBolt: lightning): number (native)
GetLightningColorG=nil           ---@type fun(whichBolt: lightning): number (native)
GetLightningColorB=nil           ---@type fun(whichBolt: lightning): number (native)
SetLightningColor=nil            ---@type fun(whichBolt: lightning, r: number, g: number, b: number, a: number): boolean (native)

GetAbilityEffect=nil             ---@type fun(abilityString: string, t: effecttype, index: integer): string (native)
GetAbilityEffectById=nil         ---@type fun(abilityId: integer, t: effecttype, index: integer): string (native)
GetAbilitySound=nil              ---@type fun(abilityString: string, t: soundtype): string (native)
GetAbilitySoundById=nil          ---@type fun(abilityId: integer, t: soundtype): string (native)

--============================================================================
-- Terrain API
--
GetTerrainCliffLevel=nil         ---@type fun(x: number, y: number): integer (native)
SetWaterBaseColor=nil            ---@type fun(red: integer, green: integer, blue: integer, alpha: integer) (native)
SetWaterDeforms=nil              ---@type fun(val: boolean) (native)
GetTerrainType=nil               ---@type fun(x: number, y: number): integer (native)
GetTerrainVariance=nil           ---@type fun(x: number, y: number): integer (native)
SetTerrainType=nil               ---@type fun(x: number, y: number, terrainType: integer, variation: integer, area: integer, shape: integer) (native)
IsTerrainPathable=nil            ---@type fun(x: number, y: number, t: pathingtype): boolean (native)
SetTerrainPathable=nil           ---@type fun(x: number, y: number, t: pathingtype, flag: boolean) (native)

--============================================================================
-- Image API
--
CreateImage=nil                  ---@type fun(file: string, sizeX: number, sizeY: number, sizeZ: number, posX: number, posY: number, posZ: number, originX: number, originY: number, originZ: number, imageType: integer): image (native)
DestroyImage=nil                 ---@type fun(whichImage: image) (native)
ShowImage=nil                    ---@type fun(whichImage: image, flag: boolean) (native)
SetImageConstantHeight=nil       ---@type fun(whichImage: image, flag: boolean, height: number) (native)
SetImagePosition=nil             ---@type fun(whichImage: image, x: number, y: number, z: number) (native)
SetImageColor=nil                ---@type fun(whichImage: image, red: integer, green: integer, blue: integer, alpha: integer) (native)
SetImageRender=nil               ---@type fun(whichImage: image, flag: boolean) (native)
SetImageRenderAlways=nil         ---@type fun(whichImage: image, flag: boolean) (native)
SetImageAboveWater=nil           ---@type fun(whichImage: image, flag: boolean, useWaterAlpha: boolean) (native)
SetImageType=nil                 ---@type fun(whichImage: image, imageType: integer) (native)

--============================================================================
-- Ubersplat API
--
CreateUbersplat=nil              ---@type fun(x: number, y: number, name: string, red: integer, green: integer, blue: integer, alpha: integer, forcePaused: boolean, noBirthTime: boolean): ubersplat (native)
DestroyUbersplat=nil             ---@type fun(whichSplat: ubersplat) (native)
ResetUbersplat=nil               ---@type fun(whichSplat: ubersplat) (native)
FinishUbersplat=nil              ---@type fun(whichSplat: ubersplat) (native)
ShowUbersplat=nil                ---@type fun(whichSplat: ubersplat, flag: boolean) (native)
SetUbersplatRender=nil           ---@type fun(whichSplat: ubersplat, flag: boolean) (native)
SetUbersplatRenderAlways=nil     ---@type fun(whichSplat: ubersplat, flag: boolean) (native)

--============================================================================
-- Blight API
--
SetBlight=nil                ---@type fun(whichPlayer: player, x: number, y: number, radius: number, addBlight: boolean) (native)
SetBlightRect=nil            ---@type fun(whichPlayer: player, r: rect, addBlight: boolean) (native)
SetBlightPoint=nil           ---@type fun(whichPlayer: player, x: number, y: number, addBlight: boolean) (native)
SetBlightLoc=nil             ---@type fun(whichPlayer: player, whichLocation: location, radius: number, addBlight: boolean) (native)
CreateBlightedGoldmine=nil   ---@type fun(id: player, x: number, y: number, face: number): unit (native)
IsPointBlighted=nil          ---@type fun(x: number, y: number): boolean (native)

--============================================================================
-- Doodad API
--
SetDoodadAnimation=nil       ---@type fun(x: number, y: number, radius: number, doodadID: integer, nearestOnly: boolean, animName: string, animRandom: boolean) (native)
SetDoodadAnimationRect=nil   ---@type fun(r: rect, doodadID: integer, animName: string, animRandom: boolean) (native)

--============================================================================
-- Computer AI interface
--
StartMeleeAI=nil         ---@type fun(num: player, script: string) (native)
StartCampaignAI=nil      ---@type fun(num: player, script: string) (native)
CommandAI=nil            ---@type fun(num: player, command: integer, data: integer) (native)
PauseCompAI=nil          ---@type fun(p: player, pause: boolean) (native)
GetAIDifficulty=nil      ---@type fun(num: player): aidifficulty (native)

RemoveGuardPosition=nil  ---@type fun(hUnit: unit) (native)
RecycleGuardPosition=nil ---@type fun(hUnit: unit) (native)
RemoveAllGuardPositions=nil ---@type fun(num: player) (native)

--============================================================================
Cheat=nil            ---@type fun(cheatStr: string) (native)
IsNoVictoryCheat=nil ---@type fun(): boolean (native)
IsNoDefeatCheat=nil  ---@type fun(): boolean (native)

Preload=nil          ---@type fun(filename: string) (native)
PreloadEnd=nil       ---@type fun(timeout: number) (native)

PreloadStart=nil     ---@type fun() (native)
PreloadRefresh=nil   ---@type fun() (native)
PreloadEndEx=nil     ---@type fun() (native)

PreloadGenClear=nil  ---@type fun() (native)
PreloadGenStart=nil  ---@type fun() (native)
PreloadGenEnd=nil    ---@type fun(filename: string) (native)
Preloader=nil        ---@type fun(filename: string) (native)


--============================================================================
--Machinima API
--============================================================================
BlzHideCinematicPanels=nil                     ---@type fun(enable: boolean) (native)


-- Automation Test
AutomationSetTestType=nil                    ---@type fun(testType: string) (native)
AutomationTestStart=nil                      ---@type fun(testName: string) (native)
AutomationTestEnd=nil                        ---@type fun() (native)
AutomationTestingFinished=nil                ---@type fun() (native)

-- JAPI Functions
BlzGetTriggerPlayerMouseX=nil                   ---@type fun(): number (native)
BlzGetTriggerPlayerMouseY=nil                   ---@type fun(): number (native)
BlzGetTriggerPlayerMousePosition=nil            ---@type fun(): location (native)
BlzGetTriggerPlayerMouseButton=nil              ---@type fun(): mousebuttontype (native)
BlzSetAbilityTooltip=nil                        ---@type fun(abilCode: integer, tooltip: string, level: integer) (native)
BlzSetAbilityActivatedTooltip=nil               ---@type fun(abilCode: integer, tooltip: string, level: integer) (native)
BlzSetAbilityExtendedTooltip=nil                ---@type fun(abilCode: integer, extendedTooltip: string, level: integer) (native)
BlzSetAbilityActivatedExtendedTooltip=nil       ---@type fun(abilCode: integer, extendedTooltip: string, level: integer) (native)
BlzSetAbilityResearchTooltip=nil                ---@type fun(abilCode: integer, researchTooltip: string, level: integer) (native)
BlzSetAbilityResearchExtendedTooltip=nil        ---@type fun(abilCode: integer, researchExtendedTooltip: string, level: integer) (native)
BlzGetAbilityTooltip=nil                        ---@type fun(abilCode: integer, level: integer): string (native)
BlzGetAbilityActivatedTooltip=nil               ---@type fun(abilCode: integer, level: integer): string (native)
BlzGetAbilityExtendedTooltip=nil                ---@type fun(abilCode: integer, level: integer): string (native)
BlzGetAbilityActivatedExtendedTooltip=nil       ---@type fun(abilCode: integer, level: integer): string (native)
BlzGetAbilityResearchTooltip=nil                ---@type fun(abilCode: integer, level: integer): string (native)
BlzGetAbilityResearchExtendedTooltip=nil        ---@type fun(abilCode: integer, level: integer): string (native)
BlzSetAbilityIcon=nil                           ---@type fun(abilCode: integer, iconPath: string) (native)
BlzGetAbilityIcon=nil                           ---@type fun(abilCode: integer): string (native)
BlzSetAbilityActivatedIcon=nil                  ---@type fun(abilCode: integer, iconPath: string) (native)
BlzGetAbilityActivatedIcon=nil                  ---@type fun(abilCode: integer): string (native)
BlzGetAbilityPosX=nil                           ---@type fun(abilCode: integer): integer (native)
BlzGetAbilityPosY=nil                           ---@type fun(abilCode: integer): integer (native)
BlzSetAbilityPosX=nil                           ---@type fun(abilCode: integer, x: integer) (native)
BlzSetAbilityPosY=nil                           ---@type fun(abilCode: integer, y: integer) (native)
BlzGetAbilityActivatedPosX=nil                  ---@type fun(abilCode: integer): integer (native)
BlzGetAbilityActivatedPosY=nil                  ---@type fun(abilCode: integer): integer (native)
BlzSetAbilityActivatedPosX=nil                  ---@type fun(abilCode: integer, x: integer) (native)
BlzSetAbilityActivatedPosY=nil                  ---@type fun(abilCode: integer, y: integer) (native)
BlzGetUnitMaxHP=nil                             ---@type fun(whichUnit: unit): integer (native)
BlzSetUnitMaxHP=nil                             ---@type fun(whichUnit: unit, hp: integer) (native)
BlzGetUnitMaxMana=nil                           ---@type fun(whichUnit: unit): integer (native)
BlzSetUnitMaxMana=nil                           ---@type fun(whichUnit: unit, mana: integer) (native)
BlzSetItemName=nil                              ---@type fun(whichItem: item, name: string) (native)
BlzSetItemDescription=nil                       ---@type fun(whichItem: item, description: string) (native)
BlzGetItemDescription=nil                       ---@type fun(whichItem: item): string (native)
BlzSetItemTooltip=nil                           ---@type fun(whichItem: item, tooltip: string) (native)
BlzGetItemTooltip=nil                           ---@type fun(whichItem: item): string (native)
BlzSetItemExtendedTooltip=nil                   ---@type fun(whichItem: item, extendedTooltip: string) (native)
BlzGetItemExtendedTooltip=nil                   ---@type fun(whichItem: item): string (native)
BlzSetItemIconPath=nil                          ---@type fun(whichItem: item, iconPath: string) (native)
BlzGetItemIconPath=nil                          ---@type fun(whichItem: item): string (native)
BlzSetUnitName=nil                              ---@type fun(whichUnit: unit, name: string) (native)
BlzSetHeroProperName=nil                        ---@type fun(whichUnit: unit, heroProperName: string) (native)
BlzGetUnitBaseDamage=nil                        ---@type fun(whichUnit: unit, weaponIndex: integer): integer (native)
BlzSetUnitBaseDamage=nil                        ---@type fun(whichUnit: unit, baseDamage: integer, weaponIndex: integer) (native)
BlzGetUnitDiceNumber=nil                        ---@type fun(whichUnit: unit, weaponIndex: integer): integer (native)
BlzSetUnitDiceNumber=nil                        ---@type fun(whichUnit: unit, diceNumber: integer, weaponIndex: integer) (native)
BlzGetUnitDiceSides=nil                         ---@type fun(whichUnit: unit, weaponIndex: integer): integer (native)
BlzSetUnitDiceSides=nil                         ---@type fun(whichUnit: unit, diceSides: integer, weaponIndex: integer) (native)
BlzGetUnitAttackCooldown=nil                    ---@type fun(whichUnit: unit, weaponIndex: integer): number (native)
BlzSetUnitAttackCooldown=nil                    ---@type fun(whichUnit: unit, cooldown: number, weaponIndex: integer) (native)
BlzSetSpecialEffectColorByPlayer=nil            ---@type fun(whichEffect: effect, whichPlayer: player) (native)
BlzSetSpecialEffectColor=nil                    ---@type fun(whichEffect: effect, r: integer, g: integer, b: integer) (native)
BlzSetSpecialEffectAlpha=nil                    ---@type fun(whichEffect: effect, alpha: integer) (native)
BlzSetSpecialEffectScale=nil                    ---@type fun(whichEffect: effect, scale: number) (native)
BlzSetSpecialEffectPosition=nil                 ---@type fun(whichEffect: effect, x: number, y: number, z: number) (native)
BlzSetSpecialEffectHeight=nil                   ---@type fun(whichEffect: effect, height: number) (native)
BlzSetSpecialEffectTimeScale=nil                ---@type fun(whichEffect: effect, timeScale: number) (native)
BlzSetSpecialEffectTime=nil                     ---@type fun(whichEffect: effect, time: number) (native)
BlzSetSpecialEffectOrientation=nil              ---@type fun(whichEffect: effect, yaw: number, pitch: number, roll: number) (native)
BlzSetSpecialEffectYaw=nil                      ---@type fun(whichEffect: effect, yaw: number) (native)
BlzSetSpecialEffectPitch=nil                    ---@type fun(whichEffect: effect, pitch: number) (native)
BlzSetSpecialEffectRoll=nil                     ---@type fun(whichEffect: effect, roll: number) (native)
BlzSetSpecialEffectX=nil                        ---@type fun(whichEffect: effect, x: number) (native)
BlzSetSpecialEffectY=nil                        ---@type fun(whichEffect: effect, y: number) (native)
BlzSetSpecialEffectZ=nil                        ---@type fun(whichEffect: effect, z: number) (native)
BlzSetSpecialEffectPositionLoc=nil              ---@type fun(whichEffect: effect, loc: location) (native)
BlzGetLocalSpecialEffectX=nil                   ---@type fun(whichEffect: effect): number (native)
BlzGetLocalSpecialEffectY=nil                   ---@type fun(whichEffect: effect): number (native)
BlzGetLocalSpecialEffectZ=nil                   ---@type fun(whichEffect: effect): number (native)
BlzSpecialEffectClearSubAnimations=nil          ---@type fun(whichEffect: effect) (native)
BlzSpecialEffectRemoveSubAnimation=nil          ---@type fun(whichEffect: effect, whichSubAnim: subanimtype) (native)
BlzSpecialEffectAddSubAnimation=nil             ---@type fun(whichEffect: effect, whichSubAnim: subanimtype) (native)
BlzPlaySpecialEffect=nil                        ---@type fun(whichEffect: effect, whichAnim: animtype) (native)
BlzPlaySpecialEffectWithTimeScale=nil           ---@type fun(whichEffect: effect, whichAnim: animtype, timeScale: number) (native)
BlzGetAnimName=nil                              ---@type fun(whichAnim: animtype): string (native)
BlzGetUnitArmor=nil                             ---@type fun(whichUnit: unit): number (native)
BlzSetUnitArmor=nil                             ---@type fun(whichUnit: unit, armorAmount: number) (native)
BlzUnitHideAbility=nil                          ---@type fun(whichUnit: unit, abilId: integer, flag: boolean) (native)
BlzUnitDisableAbility=nil                       ---@type fun(whichUnit: unit, abilId: integer, flag: boolean, hideUI: boolean) (native)
BlzUnitCancelTimedLife=nil                      ---@type fun(whichUnit: unit) (native)
BlzIsUnitSelectable=nil                         ---@type fun(whichUnit: unit): boolean (native)
BlzIsUnitInvulnerable=nil                       ---@type fun(whichUnit: unit): boolean (native)
BlzUnitInterruptAttack=nil                      ---@type fun(whichUnit: unit) (native)
BlzGetUnitCollisionSize=nil                     ---@type fun(whichUnit: unit): number (native)
BlzGetAbilityManaCost=nil                       ---@type fun(abilId: integer, level: integer): integer (native)
BlzGetAbilityCooldown=nil                       ---@type fun(abilId: integer, level: integer): number (native)
BlzSetUnitAbilityCooldown=nil                   ---@type fun(whichUnit: unit, abilId: integer, level: integer, cooldown: number) (native)
BlzGetUnitAbilityCooldown=nil                   ---@type fun(whichUnit: unit, abilId: integer, level: integer): number (native)
BlzGetUnitAbilityCooldownRemaining=nil          ---@type fun(whichUnit: unit, abilId: integer): number (native)
BlzEndUnitAbilityCooldown=nil                   ---@type fun(whichUnit: unit, abilCode: integer) (native)
BlzStartUnitAbilityCooldown=nil                 ---@type fun(whichUnit: unit, abilCode: integer, cooldown: number) (native)
BlzGetUnitAbilityManaCost=nil                   ---@type fun(whichUnit: unit, abilId: integer, level: integer): integer (native)
BlzSetUnitAbilityManaCost=nil                   ---@type fun(whichUnit: unit, abilId: integer, level: integer, manaCost: integer) (native)
BlzGetLocalUnitZ=nil                            ---@type fun(whichUnit: unit): number (native)
BlzDecPlayerTechResearched=nil                  ---@type fun(whichPlayer: player, techid: integer, levels: integer) (native)
BlzSetEventDamage=nil                           ---@type fun(damage: number) (native)
BlzGetEventDamageTarget=nil                     ---@type fun(): unit (native)
BlzGetEventAttackType=nil                       ---@type fun(): attacktype (native)
BlzGetEventDamageType=nil                       ---@type fun(): damagetype (native)
BlzGetEventWeaponType=nil                       ---@type fun(): weapontype (native)
BlzSetEventAttackType=nil                       ---@type fun(attackType: attacktype): boolean (native)
BlzSetEventDamageType=nil                       ---@type fun(damageType: damagetype): boolean (native)
BlzSetEventWeaponType=nil                       ---@type fun(weaponType: weapontype): boolean (native)
BlzGetEventIsAttack=nil                         ---@type fun(): boolean (native)
RequestExtraIntegerData=nil                     ---@type fun(dataType: integer, whichPlayer: player, param1: string, param2: string, param3: boolean, param4: integer, param5: integer, param6: integer): integer (native)
RequestExtraBooleanData=nil                     ---@type fun(dataType: integer, whichPlayer: player, param1: string, param2: string, param3: boolean, param4: integer, param5: integer, param6: integer): boolean (native)
RequestExtraStringData=nil                      ---@type fun(dataType: integer, whichPlayer: player, param1: string, param2: string, param3: boolean, param4: integer, param5: integer, param6: integer): string (native)
RequestExtraRealData=nil                        ---@type fun(dataType: integer, whichPlayer: player, param1: string, param2: string, param3: boolean, param4: integer, param5: integer, param6: integer): number (native)
-- Add this function to follow the style of GetUnitX and GetUnitY, it has the same result as BlzGetLocalUnitZ
BlzGetUnitZ=nil                                 ---@type fun(whichUnit: unit): number (native)
BlzEnableSelections=nil                         ---@type fun(enableSelection: boolean, enableSelectionCircle: boolean) (native)
BlzIsSelectionEnabled=nil                       ---@type fun(): boolean (native)
BlzIsSelectionCircleEnabled=nil                 ---@type fun(): boolean (native)
BlzCameraSetupApplyForceDurationSmooth=nil      ---@type fun(whichSetup: camerasetup, doPan: boolean, forcedDuration: number, easeInDuration: number, easeOutDuration: number, smoothFactor: number) (native)
BlzEnableTargetIndicator=nil                    ---@type fun(enable: boolean) (native)
BlzIsTargetIndicatorEnabled=nil                 ---@type fun(): boolean (native)
BlzShowTerrain=nil                              ---@type fun(show: boolean) (native)
BlzShowSkyBox=nil                               ---@type fun(show: boolean) (native)
BlzStartRecording=nil                           ---@type fun(fps: integer) (native)
BlzEndRecording=nil                             ---@type fun() (native)
BlzShowUnitTeamGlow=nil                         ---@type fun(whichUnit: unit, show: boolean) (native)

BlzGetOriginFrame=nil                           ---@type fun(frameType: originframetype, index: integer): framehandle (native)
BlzEnableUIAutoPosition=nil                     ---@type fun(enable: boolean) (native)
BlzHideOriginFrames=nil                         ---@type fun(enable: boolean) (native)
BlzConvertColor=nil                             ---@type fun(a: integer, r: integer, g: integer, b: integer): integer (native)
BlzLoadTOCFile=nil                              ---@type fun(TOCFile: string): boolean (native)
BlzCreateFrame=nil                              ---@type fun(name: string, owner: framehandle, priority: integer, createContext: integer): framehandle (native)
BlzCreateSimpleFrame=nil                        ---@type fun(name: string, owner: framehandle, createContext: integer): framehandle (native)
BlzCreateFrameByType=nil                        ---@type fun(typeName: string, name: string, owner: framehandle, inherits: string, createContext: integer): framehandle (native)
BlzDestroyFrame=nil                             ---@type fun(frame: framehandle) (native)
BlzFrameSetPoint=nil                            ---@type fun(frame: framehandle, point: framepointtype, relative: framehandle, relativePoint: framepointtype, x: number, y: number) (native)
BlzFrameSetAbsPoint=nil                         ---@type fun(frame: framehandle, point: framepointtype, x: number, y: number) (native)
BlzFrameClearAllPoints=nil                      ---@type fun(frame: framehandle) (native)
BlzFrameSetAllPoints=nil                        ---@type fun(frame: framehandle, relative: framehandle) (native)
BlzFrameSetVisible=nil                          ---@type fun(frame: framehandle, visible: boolean) (native)
BlzFrameIsVisible=nil                           ---@type fun(frame: framehandle): boolean (native)
BlzGetFrameByName=nil                           ---@type fun(name: string, createContext: integer): framehandle (native)
BlzFrameGetName=nil                             ---@type fun(frame: framehandle): string (native)
BlzFrameClick=nil                               ---@type fun(frame: framehandle) (native)
BlzFrameSetText=nil                             ---@type fun(frame: framehandle, text: string) (native)
BlzFrameGetText=nil                             ---@type fun(frame: framehandle): string (native)
BlzFrameAddText=nil                             ---@type fun(frame: framehandle, text: string) (native)
BlzFrameSetTextSizeLimit=nil                    ---@type fun(frame: framehandle, size: integer) (native)
BlzFrameGetTextSizeLimit=nil                    ---@type fun(frame: framehandle): integer (native)
BlzFrameSetTextColor=nil                        ---@type fun(frame: framehandle, color: integer) (native)
BlzFrameSetFocus=nil                            ---@type fun(frame: framehandle, flag: boolean) (native)
BlzFrameSetModel=nil                            ---@type fun(frame: framehandle, modelFile: string, cameraIndex: integer) (native)
BlzFrameSetEnable=nil                           ---@type fun(frame: framehandle, enabled: boolean) (native)
BlzFrameGetEnable=nil                           ---@type fun(frame: framehandle): boolean (native)
BlzFrameSetAlpha=nil                            ---@type fun(frame: framehandle, alpha: integer) (native)
BlzFrameGetAlpha=nil                            ---@type fun(frame: framehandle): integer (native)
BlzFrameSetSpriteAnimate=nil                    ---@type fun(frame: framehandle, primaryProp: integer, flags: integer) (native)
BlzFrameSetTexture=nil                          ---@type fun(frame: framehandle, texFile: string, flag: integer, blend: boolean) (native)
BlzFrameSetScale=nil                            ---@type fun(frame: framehandle, scale: number) (native)
BlzFrameSetTooltip=nil                          ---@type fun(frame: framehandle, tooltip: framehandle) (native)
BlzFrameCageMouse=nil                           ---@type fun(frame: framehandle, enable: boolean) (native)
BlzFrameSetValue=nil                            ---@type fun(frame: framehandle, value: number) (native)
BlzFrameGetValue=nil                            ---@type fun(frame: framehandle): number (native)
BlzFrameSetMinMaxValue=nil                      ---@type fun(frame: framehandle, minValue: number, maxValue: number) (native)
BlzFrameSetStepSize=nil                         ---@type fun(frame: framehandle, stepSize: number) (native)
BlzFrameSetSize=nil                             ---@type fun(frame: framehandle, width: number, height: number) (native)
BlzFrameSetVertexColor=nil                      ---@type fun(frame: framehandle, color: integer) (native)
BlzFrameSetLevel=nil                            ---@type fun(frame: framehandle, level: integer) (native)
BlzFrameSetParent=nil                           ---@type fun(frame: framehandle, parent: framehandle) (native)
BlzFrameGetParent=nil                           ---@type fun(frame: framehandle): framehandle (native)
BlzFrameGetHeight=nil                           ---@type fun(frame: framehandle): number (native)
BlzFrameGetWidth=nil                            ---@type fun(frame: framehandle): number (native)
BlzFrameSetFont=nil                             ---@type fun(frame: framehandle, fileName: string, height: number, flags: integer) (native)
BlzFrameSetTextAlignment=nil                    ---@type fun(frame: framehandle, vert: textaligntype, horz: textaligntype) (native)
BlzFrameGetChildrenCount=nil                    ---@type fun(frame: framehandle): integer (native)
BlzFrameGetChild=nil                            ---@type fun(frame: framehandle, index: integer): framehandle (native)
BlzTriggerRegisterFrameEvent=nil                ---@type fun(whichTrigger: trigger, frame: framehandle, eventId: frameeventtype): event (native)
BlzGetTriggerFrame=nil                          ---@type fun(): framehandle (native)
BlzGetTriggerFrameEvent=nil                     ---@type fun(): frameeventtype (native)
BlzGetTriggerFrameValue=nil                     ---@type fun(): number (native)
BlzGetTriggerFrameText=nil                      ---@type fun(): string (native)
BlzTriggerRegisterPlayerSyncEvent=nil           ---@type fun(whichTrigger: trigger, whichPlayer: player, prefix: string, fromServer: boolean): event (native)
BlzSendSyncData=nil                             ---@type fun(prefix: string, data: string): boolean (native)
BlzGetTriggerSyncPrefix=nil                     ---@type fun(): string (native)
BlzGetTriggerSyncData=nil                       ---@type fun(): string (native)
BlzTriggerRegisterPlayerKeyEvent=nil            ---@type fun(whichTrigger: trigger, whichPlayer: player, key: oskeytype, metaKey: integer, keyDown: boolean): event (native)
BlzGetTriggerPlayerKey=nil                      ---@type fun(): oskeytype (native)
BlzGetTriggerPlayerMetaKey=nil                  ---@type fun(): integer (native)
BlzGetTriggerPlayerIsKeyDown=nil                ---@type fun(): boolean (native)
BlzEnableCursor=nil                             ---@type fun(enable: boolean) (native)
BlzSetMousePos=nil                              ---@type fun(x: integer, y: integer) (native)
BlzGetLocalClientWidth=nil                      ---@type fun(): integer (native)
BlzGetLocalClientHeight=nil                     ---@type fun(): integer (native)
BlzIsLocalClientActive=nil                      ---@type fun(): boolean (native)
BlzGetMouseFocusUnit=nil                        ---@type fun(): unit (native)
BlzChangeMinimapTerrainTex=nil                  ---@type fun(texFile: string): boolean (native)
BlzGetLocale=nil                                ---@type fun(): string (native)
BlzGetSpecialEffectScale=nil                    ---@type fun(whichEffect: effect): number (native)
BlzSetSpecialEffectMatrixScale=nil              ---@type fun(whichEffect: effect, x: number, y: number, z: number) (native)
BlzResetSpecialEffectMatrix=nil                 ---@type fun(whichEffect: effect) (native)
BlzGetUnitAbility=nil                           ---@type fun(whichUnit: unit, abilId: integer): ability (native)
BlzGetUnitAbilityByIndex=nil                    ---@type fun(whichUnit: unit, index: integer): ability (native)
BlzGetAbilityId=nil                             ---@type fun(whichAbility: ability): integer (native)
BlzDisplayChatMessage=nil                       ---@type fun(whichPlayer: player, recipient: integer, message: string) (native)
BlzPauseUnitEx=nil                              ---@type fun(whichUnit: unit, flag: boolean) (native)
-- native BlzFourCC2S                                 takes integer value returns string
-- native BlzS2FourCC                                 takes string value returns integer
BlzSetUnitFacingEx=nil                          ---@type fun(whichUnit: unit, facingAngle: number) (native)

CreateCommandButtonEffect=nil                   ---@type fun(abilityId: integer, order: string): commandbuttoneffect (native)
CreateUpgradeCommandButtonEffect=nil            ---@type fun(whichUprgade: integer): commandbuttoneffect (native)
CreateLearnCommandButtonEffect=nil              ---@type fun(abilityId: integer): commandbuttoneffect (native)
DestroyCommandButtonEffect=nil                  ---@type fun(whichEffect: commandbuttoneffect) (native)

-- Bit Operations
BlzBitOr=nil                                    ---@type fun(x: integer, y: integer): integer (native)
BlzBitAnd=nil                                   ---@type fun(x: integer, y: integer): integer (native)
BlzBitXor=nil                                   ---@type fun(x: integer, y: integer): integer (native)

-- Intanced Object Operations
-- Ability
BlzGetAbilityBooleanField=nil                   ---@type fun(whichAbility: ability, whichField: abilitybooleanfield): boolean (native)
BlzGetAbilityIntegerField=nil                   ---@type fun(whichAbility: ability, whichField: abilityintegerfield): integer (native)
BlzGetAbilityRealField=nil                      ---@type fun(whichAbility: ability, whichField: abilityrealfield): number (native)
BlzGetAbilityStringField=nil                    ---@type fun(whichAbility: ability, whichField: abilitystringfield): string (native)
BlzGetAbilityBooleanLevelField=nil              ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelfield, level: integer): boolean (native)
BlzGetAbilityIntegerLevelField=nil              ---@type fun(whichAbility: ability, whichField: abilityintegerlevelfield, level: integer): integer (native)
BlzGetAbilityRealLevelField=nil                 ---@type fun(whichAbility: ability, whichField: abilityreallevelfield, level: integer): number (native)
BlzGetAbilityStringLevelField=nil               ---@type fun(whichAbility: ability, whichField: abilitystringlevelfield, level: integer): string (native)
BlzGetAbilityBooleanLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, index: integer): boolean (native)
BlzGetAbilityIntegerLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, index: integer): integer (native)
BlzGetAbilityRealLevelArrayField=nil            ---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, index: integer): number (native)
BlzGetAbilityStringLevelArrayField=nil          ---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, index: integer): string (native)
BlzSetAbilityBooleanField=nil                   ---@type fun(whichAbility: ability, whichField: abilitybooleanfield, value: boolean): boolean (native)
BlzSetAbilityIntegerField=nil                   ---@type fun(whichAbility: ability, whichField: abilityintegerfield, value: integer): boolean (native)
BlzSetAbilityRealField=nil                      ---@type fun(whichAbility: ability, whichField: abilityrealfield, value: number): boolean (native)
BlzSetAbilityStringField=nil                    ---@type fun(whichAbility: ability, whichField: abilitystringfield, value: string): boolean (native)
BlzSetAbilityBooleanLevelField=nil              ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelfield, level: integer, value: boolean): boolean (native)
BlzSetAbilityIntegerLevelField=nil              ---@type fun(whichAbility: ability, whichField: abilityintegerlevelfield, level: integer, value: integer): boolean (native)
BlzSetAbilityRealLevelField=nil                 ---@type fun(whichAbility: ability, whichField: abilityreallevelfield, level: integer, value: number): boolean (native)
BlzSetAbilityStringLevelField=nil               ---@type fun(whichAbility: ability, whichField: abilitystringlevelfield, level: integer, value: string): boolean (native)
BlzSetAbilityBooleanLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, index: integer, value: boolean): boolean (native)
BlzSetAbilityIntegerLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, index: integer, value: integer): boolean (native)
BlzSetAbilityRealLevelArrayField=nil            ---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, index: integer, value: number): boolean (native)
BlzSetAbilityStringLevelArrayField=nil          ---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, index: integer, value: string): boolean (native)
BlzAddAbilityBooleanLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, value: boolean): boolean (native)
BlzAddAbilityIntegerLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, value: integer): boolean (native)
BlzAddAbilityRealLevelArrayField=nil            ---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, value: number): boolean (native)
BlzAddAbilityStringLevelArrayField=nil          ---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, value: string): boolean (native)
BlzRemoveAbilityBooleanLevelArrayField=nil      ---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, value: boolean): boolean (native)
BlzRemoveAbilityIntegerLevelArrayField=nil      ---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, value: integer): boolean (native)
BlzRemoveAbilityRealLevelArrayField=nil         ---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, value: number): boolean (native)
BlzRemoveAbilityStringLevelArrayField=nil       ---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, value: string): boolean (native)

-- Item 
BlzGetItemAbilityByIndex=nil                    ---@type fun(whichItem: item, index: integer): ability (native)
BlzGetItemAbility=nil                           ---@type fun(whichItem: item, abilCode: integer): ability (native)
BlzItemAddAbility=nil                           ---@type fun(whichItem: item, abilCode: integer): boolean (native)
BlzGetItemBooleanField=nil                      ---@type fun(whichItem: item, whichField: itembooleanfield): boolean (native)
BlzGetItemIntegerField=nil                      ---@type fun(whichItem: item, whichField: itemintegerfield): integer (native)
BlzGetItemRealField=nil                         ---@type fun(whichItem: item, whichField: itemrealfield): number (native)
BlzGetItemStringField=nil                       ---@type fun(whichItem: item, whichField: itemstringfield): string (native)
BlzSetItemBooleanField=nil                      ---@type fun(whichItem: item, whichField: itembooleanfield, value: boolean): boolean (native)
BlzSetItemIntegerField=nil                      ---@type fun(whichItem: item, whichField: itemintegerfield, value: integer): boolean (native)
BlzSetItemRealField=nil                         ---@type fun(whichItem: item, whichField: itemrealfield, value: number): boolean (native)
BlzSetItemStringField=nil                       ---@type fun(whichItem: item, whichField: itemstringfield, value: string): boolean (native)
BlzItemRemoveAbility=nil                        ---@type fun(whichItem: item, abilCode: integer): boolean (native)

-- Unit 
BlzGetUnitBooleanField=nil                      ---@type fun(whichUnit: unit, whichField: unitbooleanfield): boolean (native)
BlzGetUnitIntegerField=nil                      ---@type fun(whichUnit: unit, whichField: unitintegerfield): integer (native)
BlzGetUnitRealField=nil                         ---@type fun(whichUnit: unit, whichField: unitrealfield): number (native)
BlzGetUnitStringField=nil                       ---@type fun(whichUnit: unit, whichField: unitstringfield): string (native)
BlzSetUnitBooleanField=nil                      ---@type fun(whichUnit: unit, whichField: unitbooleanfield, value: boolean): boolean (native)
BlzSetUnitIntegerField=nil                      ---@type fun(whichUnit: unit, whichField: unitintegerfield, value: integer): boolean (native)
BlzSetUnitRealField=nil                         ---@type fun(whichUnit: unit, whichField: unitrealfield, value: number): boolean (native)
BlzSetUnitStringField=nil                       ---@type fun(whichUnit: unit, whichField: unitstringfield, value: string): boolean (native)

-- Unit Weapon
BlzGetUnitWeaponBooleanField=nil                ---@type fun(whichUnit: unit, whichField: unitweaponbooleanfield, index: integer): boolean (native)
BlzGetUnitWeaponIntegerField=nil                ---@type fun(whichUnit: unit, whichField: unitweaponintegerfield, index: integer): integer (native)
BlzGetUnitWeaponRealField=nil                   ---@type fun(whichUnit: unit, whichField: unitweaponrealfield, index: integer): number (native)
BlzGetUnitWeaponStringField=nil                 ---@type fun(whichUnit: unit, whichField: unitweaponstringfield, index: integer): string (native)
BlzSetUnitWeaponBooleanField=nil                ---@type fun(whichUnit: unit, whichField: unitweaponbooleanfield, index: integer, value: boolean): boolean (native)
BlzSetUnitWeaponIntegerField=nil                ---@type fun(whichUnit: unit, whichField: unitweaponintegerfield, index: integer, value: integer): boolean (native)
BlzSetUnitWeaponRealField=nil                   ---@type fun(whichUnit: unit, whichField: unitweaponrealfield, index: integer, value: number): boolean (native)
BlzSetUnitWeaponStringField=nil                 ---@type fun(whichUnit: unit, whichField: unitweaponstringfield, index: integer, value: string): boolean (native)

-- Skin
BlzGetUnitSkin=nil                                 ---@type fun(whichUnit: unit): integer (native)
BlzGetItemSkin=nil                                 ---@type fun(whichItem: item): integer (native)
-- native BlzGetDestructableSkin                         takes destructable whichDestructable returns integer
BlzSetUnitSkin=nil                                 ---@type fun(whichUnit: unit, skinId: integer) (native)
BlzSetItemSkin=nil                                 ---@type fun(whichItem: item, skinId: integer) (native)
-- native BlzSetDestructableSkin                         takes destructable whichDestructable, integer skinId returns nothing

BlzCreateItemWithSkin=nil                       ---@type fun(itemid: integer, x: number, y: number, skinId: integer): item (native)
BlzCreateUnitWithSkin=nil                       ---@type fun(id: player, unitid: integer, x: number, y: number, face: number, skinId: integer): unit (native)
BlzCreateDestructableWithSkin=nil               ---@type fun(objectid: integer, x: number, y: number, face: number, scale: number, variation: integer, skinId: integer): destructable (native)
BlzCreateDestructableZWithSkin=nil              ---@type fun(objectid: integer, x: number, y: number, z: number, face: number, scale: number, variation: integer, skinId: integer): destructable (native)
BlzCreateDeadDestructableWithSkin=nil           ---@type fun(objectid: integer, x: number, y: number, face: number, scale: number, variation: integer, skinId: integer): destructable (native)
BlzCreateDeadDestructableZWithSkin=nil          ---@type fun(objectid: integer, x: number, y: number, z: number, face: number, scale: number, variation: integer, skinId: integer): destructable (native)
BlzGetPlayerTownHallCount=nil                   ---@type fun(whichPlayer: player): integer (native)

BlzQueueImmediateOrderById=nil      ---@type fun(whichUnit: unit, order: integer): boolean (native)
BlzQueuePointOrderById=nil          ---@type fun(whichUnit: unit, order: integer, x: number, y: number): boolean (native)
BlzQueueTargetOrderById=nil         ---@type fun(whichUnit: unit, order: integer, targetWidget: widget): boolean (native)
BlzQueueInstantPointOrderById=nil   ---@type fun(whichUnit: unit, order: integer, x: number, y: number, instantTargetWidget: widget): boolean (native)
BlzQueueInstantTargetOrderById=nil  ---@type fun(whichUnit: unit, order: integer, targetWidget: widget, instantTargetWidget: widget): boolean (native)
BlzQueueBuildOrderById=nil          ---@type fun(whichPeon: unit, unitId: integer, x: number, y: number): boolean (native)
BlzQueueNeutralImmediateOrderById=nil   ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer): boolean (native)
BlzQueueNeutralPointOrderById=nil       ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer, x: number, y: number): boolean (native)
BlzQueueNeutralTargetOrderById=nil      ---@type fun(forWhichPlayer: player, neutralStructure: unit, unitId: integer, target: widget): boolean (native)

-- returns the number of orders the unit currently has queued up
BlzGetUnitOrderCount=nil ---@type fun(whichUnit: unit): integer (native)
-- clears either all orders or only queued up orders
BlzUnitClearOrders=nil ---@type fun(whichUnit: unit, onlyQueued: boolean) (native)
-- stops the current order and optionally clears the queue
BlzUnitForceStopOrder=nil ---@type fun(whichUnit: unit, clearQueue: boolean) (native)
--Conversion by vJass2Lua v0.A.3.0 beta