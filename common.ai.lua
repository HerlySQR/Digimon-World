--==================================================================================================
--  $Id: common.ai, v 2.0 2021/06/04 12:00:00 - InsaneMonster(Luca Pasqualini) $
--==================================================================================================

---@param str string
function DebugS(str) end    -- (native)

---@param str string
---@param val integer
function DebugFI(str, val) end    -- (native)

---@param str string
---@param val integer
function DebugUnitID(str, val) end    -- (native)

---@param p integer
---@param str string
function DisplayText(p, str) end    -- (native)

---@param p integer
---@param str string
---@param val integer
function DisplayTextI(p, str, val) end    -- (native)

---@param p integer
---@param str string
---@param v1 integer
---@param v2 integer
function DisplayTextII(p, str, v1, v2) end    -- (native)

---@param p integer
---@param str string
---@param v1 integer
---@param v2 integer
---@param v3 integer
function DisplayTextIII(p, str, v1, v2, v3) end    -- (native)

---@returns boolean
function DoAiScriptDebug() end    -- (native)


---@return integer
function GetAiPlayer() end    -- (native)

---@return integer
function GetHeroId() end    -- (native)

---@return integer
function GetHeroLevelAI() end    -- (native)


---@param unitid integer
---@return integer
function GetUnitCount(unitid) end    -- (native)

---@param p player
---@param unitid integer
---@return integer
function GetPlayerUnitTypeCount(p, unitid) end    -- (native)

---@param unitid integer
---@return integer
function GetUnitCountDone(unitid) end    -- (native)

---@param id integer
---@param tn integer
---@param dn boolean
---@return integer
function GetTownUnitCount(id, tn, dn) end    -- (native)

---@param unitid integer
---@return integer
function GetUnitGoldCost(unitid) end    -- (native)

---@param unitid integer
---@return integer
function GetUnitWoodCost(unitid) end    -- (native)

---@param unitid integer
---@return integer
function GetUnitBuildTime(unitid) end    -- (native)


---@return integer
function GetMinesOwned() end    -- (native)

---@return integer
function GetGoldOwned() end    -- (native)

---@return integer
function TownWithMine() end    -- (native)

---@param townid integer
---@return boolean
function TownHasMine(townid) end    -- (native)

---@param townid integer
---@return boolean
function TownHasHall(townid) end    -- (native)

---@param id integer
---@return integer
function GetUpgradeLevel(id) end    -- (native)

---@param id integer
---@return integer
function GetUpgradeGoldCost(id) end    -- (native)

---@param id integer
---@return integer
function GetUpgradeWoodCost(id) end    -- (native)

---@return integer
function GetNextExpansion() end    -- (native)

---@return unit
function GetMegaTarget() end    -- (native)

---@param p player
---@return unit
function GetBuilding(p) end    -- (native)

---@return integer
function GetEnemyPower() end    -- (native)

---@param id unit
function SetAllianceTarget(id) end    -- (native)

---@return unit
function GetAllianceTarget() end    -- (native)


---@param qty integer
---@param id integer
---@param town integer
---@return boolean
function SetProduce(qty, id, town) end    -- (native)

---@param unitid unit
function Unsummon(unitid) end    -- (native)

---@param peon unit
---@param id integer
---@return boolean
function SetExpansion(peon, id) end    -- (native)

---@param id integer
---@return boolean
function SetUpgrade(id) end    -- (native)

---@param func function
function SetHeroLevels(func) end    -- (native)

---@param state boolean
function SetNewHeroes(state) end    -- (native)

function PurchaseZeppelin() end    -- (native)


---@param qty integer
---@param a integer
---@param b integer
---@param make integer
---@return boolean
function MergeUnits(qty, a, b, make) end    -- (native)

---@param qty integer
---@param id integer
---@return boolean
function ConvertUnits(qty, id) end    -- (native)

function SetCampaignAI() end    -- (native)
function SetMeleeAI() end    -- (native)

---@param state boolean
function SetTargetHeroes(state) end    -- (native)

---@param state boolean
function SetPeonsRepair(state) end    -- (native)

---@param state boolean
function SetRandomPaths(state) end    -- (native)

---@param state boolean
function SetDefendPlayer(state) end    -- (native)

---@param state boolean
function SetHeroesFlee(state) end    -- (native)

---@param state boolean
function SetHeroesBuyItems(state) end    -- (native)

---@param state boolean
function SetWatchMegaTargets(state) end    -- (native)

---@param state boolean
function SetIgnoreInjured(state) end    -- (native)

---@param state boolean
function SetHeroesTakeItems(state) end    -- (native)

---@param state boolean
function SetUnitsFlee(state) end    -- (native)

---@param state boolean
function SetGroupsFlee(state) end    -- (native)

---@param state boolean
function SetSlowChopping(state) end    -- (native)

---@param allow boolean
function SetCaptainChanges(allow) end    -- (native)

---@param state boolean
function SetSmartArtillery(state) end    -- (native)

---@param qty integer
function SetReplacementCount(qty) end    -- (native)

---@param allow boolean
function GroupTimedLife(allow) end    -- (native)

function RemoveInjuries() end    -- (native)

function RemoveSiege() end    -- (native)

function InitAssault() end    -- (native)

---@param qty integer
---@param id integer
---@return boolean
function AddAssault(qty, id) end    -- (native)

---@param qty integer
---@param id integer
---@return boolean
function AddDefenders(qty, id) end    -- (native)


---@param min integer
---@param max integer
---@param flyers_ok boolean
---@return unit
function GetCreepCamp(min, max, flyers_ok) end    -- (native)

function StartGetEnemyBase() end    -- (native)

---@return boolean
function WaitGetEnemyBase() end    -- (native)

---@return unit
function GetEnemyBase() end    -- (native)

---@return unit
function GetExpansionFoe() end    -- (native)

---@return unit
function GetEnemyExpansion() end    -- (native)

---@return integer
function GetExpansionX() end    -- (native)

---@return integer
function GetExpansionY() end    -- (native)

---@param x real
---@param y real
function SetStagePoint(x, y) end    -- (native)

---@param target unit
function AttackMoveKill(target) end    -- (native)

---@param x integer
---@param y integer
function AttackMoveXY(x, y) end    -- (native)

---@param x integer
---@param y integer
function LoadZepWave(x, y) end    -- (native)

---@param id player
---@param check_full boolean
---@return boolean
function SuicidePlayer(id, check_full) end    -- (native)

---@param id player
---@param check_full boolean
---@return boolean
function SuicidePlayerUnits(id, check_full) end    -- (native)

---@param attack_captain boolean
---@return boolean
function CaptainInCombat(attack_captain) end    -- (native)

---@param target unit
---@return boolean
function IsTowered(target) end    -- (native)

function ClearHarvestAI() end    -- (native)

---@param town integer
---@param peons integer
function HarvestGold(town, peons) end    -- (native)

---@param town integer
---@param peons integer
function HarvestWood(town, peons) end    -- (native)

---@return unit
function GetExpansionPeon() end    -- (native)

function StopGathering() end    -- (native)

---@param id integer
---@param x real
---@param y real
function AddGuardPost(id, x, y) end    -- (native)
function FillGuardPosts() end    -- (native)
function ReturnGuardPosts() end    -- (native)
function CreateCaptains() end    -- (native)

---@param which integer
---@param x real
---@param y real
function SetCaptainHome(which, x, y) end    -- (native)
function ResetCaptainLocs() end    -- (native)

---@param x real
---@param y real
function ShiftTownSpot(x, y) end    -- (native)

---@param x real
---@param y real
function TeleportCaptain(x, y) end    -- (native)

function ClearCaptainTargets() end    -- (native)

---@param x real
---@param y real
function CaptainAttack(x, y) end    -- (native)

---@param id player
function CaptainVsUnits(id) end    -- (native)

---@param id player
function CaptainVsPlayer(id) end    -- (native)

function CaptainGoHome() end    -- (native)

---@return boolean
function CaptainIsHome() end    -- (native)

---@return boolean
function CaptainIsFull() end    -- (native)

---@return boolean
function CaptainIsEmpty() end    -- (native)

---@return integer
function CaptainGroupSize() end    -- (native)

---@return integer
function CaptainReadiness() end    -- (native)

---@return boolean
function CaptainRetreating() end    -- (native)

---@return integer
function CaptainReadinessHP() end    -- (native)

---@return integer
function CaptainReadinessMa() end    -- (native)

---@return boolean
function CaptainAtGoal() end    -- (native)

---@return boolean
function CreepsOnMap() end    -- (native)

---@param count integer
---@param unitid integer
function SuicideUnit(count, unitid) end    -- (native)

---@param ct integer
---@param uid integer
---@param pid integer
function SuicideUnitEx(ct, uid, pid) end    -- (native)

---@param func function
function StartThread(func) end    -- (native)

---@param seconds real
function Sleep(seconds) end    -- (native)

---@param id unit
---@return boolean
function UnitAlive(id) end    -- (native)

---@param id unit
---@return boolean
function UnitInvis(id) end    -- (native)

---@param unitid integer
---@return integer
function IgnoredUnits(unitid) end    -- (native)

---@return boolean
function TownThreatened() end    -- (native)

function DisablePathing() end    -- (native)

function SetAmphibious() end    -- (native)

---@return integer
function CommandsWaiting() end    -- (native)

---@return integer
function GetLastCommand() end    -- (native)

---@return integer
function GetLastData() end    -- (native)

---@return integer
function PopLastCommand() end    -- (native)

---@return integer
function MeleeDifficulty() end    -- (native)

--[[
--============================================================================
--  Globals for all AI scripts
--============================================================================


----------------------------------------------------------------------
--  HUMANS
----------------------------------------------------------------------

-- human heroes
ARCHMAGE            = FourCC("Hamg") ---@type integer
PALADIN             = FourCC("Hpal") ---@type integer
MTN_KING            = FourCC("Hmkg") ---@type integer
BLOOD_MAGE          = FourCC("Hblm") ---@type integer

-- human hero abilities
AVATAR              = FourCC("AHav") ---@type integer
BASH                = FourCC("AHbh") ---@type integer
THUNDER_BOLT        = FourCC("AHtb") ---@type integer
THUNDER_CLAP        = FourCC("AHtc") ---@type integer

DEVOTION_AURA       = FourCC("AHad") ---@type integer
DIVINE_SHIELD       = FourCC("AHds") ---@type integer
HOLY_BOLT           = FourCC("AHhb") ---@type integer
RESURRECTION        = FourCC("AHre") ---@type integer

BLIZZARD            = FourCC("AHbz") ---@type integer
BRILLIANCE_AURA     = FourCC("AHab") ---@type integer
MASS_TELEPORT       = FourCC("AHmt") ---@type integer
WATER_ELEMENTAL     = FourCC("AHwe") ---@type integer

BANISH              = FourCC("AHbn") ---@type integer
FLAME_STRIKE        = FourCC("AHfs") ---@type integer
SUMMON_PHOENIX      = FourCC("AHpx") ---@type integer
SIPHON_MANA         = FourCC("AHdr") ---@type integer

-- special human heroes
JAINA               = FourCC("Hjai") ---@type integer
MURADIN             = FourCC("Hmbr") ---@type integer
GARITHOS            = FourCC("Hlgr") ---@type integer
KAEL                = FourCC("Hkal") ---@type integer

-- human units
COPTER              = FourCC("hgyr") ---@type integer
GYRO                =  COPTER ---@type integer
ELEMENTAL           = FourCC("hwat") ---@type integer
FOOTMAN             = FourCC("hfoo") ---@type integer
FOOTMEN             =  FOOTMAN ---@type integer
GRYPHON             = FourCC("hgry") ---@type integer
KNIGHT              = FourCC("hkni") ---@type integer
MORTAR              = FourCC("hmtm") ---@type integer
PEASANT             = FourCC("hpea") ---@type integer
PRIEST              = FourCC("hmpr") ---@type integer
RIFLEMAN            = FourCC("hrif") ---@type integer
RIFLEMEN            =  RIFLEMAN ---@type integer
SORCERESS           = FourCC("hsor") ---@type integer
TANK                = FourCC("hmtt") ---@type integer
STEAM_TANK          =  TANK ---@type integer
ROCKET_TANK         = FourCC("hrtt") ---@type integer
MILITIA             = FourCC("hmil") ---@type integer
SPELL_BREAKER       = FourCC("hspt") ---@type integer
HUMAN_DRAGON_HAWK   = FourCC("hdhw") ---@type integer

-- special human units
BLOOD_PRIEST        = FourCC("hbep") ---@type integer
BLOOD_SORCERESS     = FourCC("hbes") ---@type integer
BLOOD_PEASANT       = FourCC("nhew") ---@type integer

-- human buildings
AVIARY              = FourCC("hgra") ---@type integer
BARRACKS            = FourCC("hbar") ---@type integer
BLACKSMITH          = FourCC("hbla") ---@type integer
CANNON_TOWER        = FourCC("hctw") ---@type integer
CASTLE              = FourCC("hcas") ---@type integer
CHURCH              = FourCC("htws") ---@type integer
MAGE_TOWER          =  CHURCH ---@type integer
GUARD_TOWER         = FourCC("hgtw") ---@type integer
HOUSE               = FourCC("hhou") ---@type integer
HUMAN_ALTAR         = FourCC("halt") ---@type integer
KEEP                = FourCC("hkee") ---@type integer
LUMBER_MILL         = FourCC("hlum") ---@type integer
SANCTUM             = FourCC("hars") ---@type integer
ARCANE_SANCTUM      =  SANCTUM ---@type integer
TOWN_HALL           = FourCC("htow") ---@type integer
WATCH_TOWER         = FourCC("hwtw") ---@type integer
WORKSHOP            = FourCC("harm") ---@type integer
ARCANE_VAULT        = FourCC("hvlt") ---@type integer
ARCANE_TOWER        = FourCC("hatw") ---@type integer

-- human upgrades
UPG_MELEE           = FourCC("Rhme") ---@type integer
UPG_RANGED          = FourCC("Rhra") ---@type integer
UPG_ARTILLERY       = FourCC("Rhaa") ---@type integer
UPG_ARMOR           = FourCC("Rhar") ---@type integer
UPG_GOLD            = FourCC("Rhmi") ---@type integer
UPG_MASONRY         = FourCC("Rhac") ---@type integer
UPG_SIGHT           = FourCC("Rhss") ---@type integer
UPG_DEFEND          = FourCC("Rhde") ---@type integer
UPG_BREEDING        = FourCC("Rhan") ---@type integer
UPG_PRAYING         = FourCC("Rhpt") ---@type integer
UPG_SORCERY         = FourCC("Rhst") ---@type integer
UPG_LEATHER         = FourCC("Rhla") ---@type integer
UPG_GUN_RANGE       = FourCC("Rhri") ---@type integer
UPG_WOOD            = FourCC("Rhlh") ---@type integer
UPG_SENTINEL        = FourCC("Rhse") ---@type integer
UPG_SCATTER         = FourCC("Rhsr") ---@type integer
UPG_BOMBS           = FourCC("Rhgb") ---@type integer
UPG_HAMMERS         = FourCC("Rhhb") ---@type integer
UPG_CONT_MAGIC      = FourCC("Rhss") ---@type integer
UPG_FRAGS           = FourCC("Rhfs") ---@type integer
UPG_TANK            = FourCC("Rhrt") ---@type integer
UPG_FLAK            = FourCC("Rhfc") ---@type integer
UPG_CLOUD           = FourCC("Rhcd") ---@type integer

----------------------------------------------------------------------
--  ORCS
----------------------------------------------------------------------

-- orc heroes
BLADE_MASTER        = FourCC("Obla") ---@type integer
FAR_SEER            = FourCC("Ofar") ---@type integer
TAUREN_CHIEF        = FourCC("Otch") ---@type integer
SHADOW_HUNTER       = FourCC("Oshd") ---@type integer

-- special orc heroes
GROM                = FourCC("Ogrh") ---@type integer
THRALL              = FourCC("Othr") ---@type integer

-- orc hero abilities
CRITICAL_STRIKE     = FourCC("AOcr") ---@type integer
MIRROR_IMAGE        = FourCC("AOmi") ---@type integer
BLADE_STORM         = FourCC("AOww") ---@type integer
WIND_WALK           = FourCC("AOwk") ---@type integer

CHAIN_LIGHTNING     = FourCC("AOcl") ---@type integer
EARTHQUAKE          = FourCC("AOeq") ---@type integer
FAR_SIGHT           = FourCC("AOfs") ---@type integer
SPIRIT_WOLF         = FourCC("AOsf") ---@type integer

ENDURANE_AURA       = FourCC("AOae") ---@type integer
REINCARNATION       = FourCC("AOre") ---@type integer
SHOCKWAVE           = FourCC("AOsh") ---@type integer
WAR_STOMP           = FourCC("AOws") ---@type integer

HEALING_WAVE        = FourCC("AOhw") ---@type integer
HEX                 = FourCC("AOhx") ---@type integer
SERPENT_WARD        = FourCC("AOsw") ---@type integer
VOODOO              = FourCC("AOvd") ---@type integer

-- orc units
GUARDIAN            = FourCC("oang") ---@type integer
CATAPULT            = FourCC("ocat") ---@type integer
WITCH_DOCTOR        = FourCC("odoc") ---@type integer
GRUNT               = FourCC("ogru") ---@type integer
HEAD_HUNTER         = FourCC("ohun") ---@type integer
BERSERKER           = FourCC("otbk") ---@type integer
KODO_BEAST          = FourCC("okod") ---@type integer
PEON                = FourCC("opeo") ---@type integer
RAIDER              = FourCC("orai") ---@type integer
SHAMAN              = FourCC("oshm") ---@type integer
TAUREN              = FourCC("otau") ---@type integer
WYVERN              = FourCC("owyv") ---@type integer
BATRIDER            = FourCC("otbr") ---@type integer
SPIRIT_WALKER       = FourCC("ospw") ---@type integer
SPIRIT_WALKER_M     = FourCC("ospm") ---@type integer

-- orc buildings
ORC_ALTAR           = FourCC("oalt") ---@type integer
ORC_BARRACKS        = FourCC("obar") ---@type integer
BESTIARY            = FourCC("obea") ---@type integer
FORGE               = FourCC("ofor") ---@type integer
FORTRESS            = FourCC("ofrt") ---@type integer
GREAT_HALL          = FourCC("ogre") ---@type integer
LODGE               = FourCC("osld") ---@type integer
STRONGHOLD          = FourCC("ostr") ---@type integer
BURROW              = FourCC("otrb") ---@type integer
TOTEM               = FourCC("otto") ---@type integer
ORC_WATCH_TOWER     = FourCC("owtw") ---@type integer
VOODOO_LOUNGE       = FourCC("ovln") ---@type integer

-- orc upgrades
UPG_ORC_MELEE       = FourCC("Rome") ---@type integer
UPG_ORC_RANGED      = FourCC("Rora") ---@type integer
UPG_ORC_ARTILLERY   = FourCC("Roaa") ---@type integer
UPG_ORC_ARMOR       = FourCC("Roar") ---@type integer
UPG_ORC_WAR_DRUMS   = FourCC("Rwdm") ---@type integer
UPG_ORC_PILLAGE     = FourCC("Ropg") ---@type integer
UPG_ORC_BERSERK     = FourCC("Robs") ---@type integer
UPG_ORC_PULVERIZE   = FourCC("Rows") ---@type integer
UPG_ORC_ENSNARE     = FourCC("Roen") ---@type integer
UPG_ORC_VENOM       = FourCC("Rovs") ---@type integer
UPG_ORC_DOCS        = FourCC("Rowd") ---@type integer
UPG_ORC_SHAMAN      = FourCC("Rost") ---@type integer
UPG_ORC_SPIKES      = FourCC("Rosp") ---@type integer
UPG_ORC_BURROWS     = FourCC("Rorb") ---@type integer
UPG_ORC_REGEN       = FourCC("Rotr") ---@type integer
UPG_ORC_FIRE        = FourCC("Rolf") ---@type integer
UPG_ORC_SWALKER     = FourCC("Rowt") ---@type integer
UPG_ORC_BERSERKER   = FourCC("Robk") ---@type integer
UPG_ORC_NAPTHA      = FourCC("Robf") ---@type integer
UPG_ORC_CHAOS       = FourCC("Roch") ---@type integer

-- Warcraft 2 orc units
OGRE_MAGI           = FourCC("nomg") ---@type integer
ORC_DRAGON          = FourCC("nrwm") ---@type integer
SAPPER              = FourCC("ngsp") ---@type integer
ZEPPLIN             = FourCC("nzep") ---@type integer
ZEPPELIN            =  ZEPPLIN ---@type integer
W2_WARLOCK          = FourCC("nw2w") ---@type integer
PIG_FARM            = FourCC("npgf") ---@type integer
FOREST_TROLL        = FourCC("nftr") ---@type integer

-- special orc units
CHAOS_GRUNT         = FourCC("nchg") ---@type integer
CHAOS_WARLOCK       = FourCC("nchw") ---@type integer
CHAOS_RAIDER        = FourCC("nchr") ---@type integer
CHAOS_PEON          = FourCC("ncpn") ---@type integer
CHAOS_KODO          = FourCC("nckb") ---@type integer
CHAOS_GROM          = FourCC("Opgh") ---@type integer
CHAOS_BLADEMASTER   = FourCC("Nbbc") ---@type integer
CHAOS_BURROW        = FourCC("ocbw") ---@type integer

----------------------------------------------------------------------
--  UNDEAD
----------------------------------------------------------------------

-- undead heroes
DEATH_KNIGHT        = FourCC("Udea") ---@type integer
DREAD_LORD          = FourCC("Udre") ---@type integer
LICH                = FourCC("Ulic") ---@type integer
CRYPT_LORD          = FourCC("Ucrl") ---@type integer

-- special undead heroes
MALGANIS            = FourCC("Umal") ---@type integer
TICHONDRIUS         = FourCC("Utic") ---@type integer
PIT_LORD            = FourCC("Npld") ---@type integer
DETHEROC            = FourCC("Udth") ---@type integer

-- undead hero abilities
SLEEP               = FourCC("AUsl") ---@type integer
VAMP_AURA           = FourCC("AUav") ---@type integer
CARRION_SWARM       = FourCC("AUcs") ---@type integer
INFERNO             = FourCC("AUin") ---@type integer

DARK_RITUAL         = FourCC("AUdr") ---@type integer
DEATH_DECAY         = FourCC("AUdd") ---@type integer
FROST_ARMOR         = FourCC("AUfu") ---@type integer
FROST_NOVA          = FourCC("AUfn") ---@type integer

ANIM_DEAD           = FourCC("AUan") ---@type integer
DEATH_COIL          = FourCC("AUdc") ---@type integer
DEATH_PACT          = FourCC("AUdp") ---@type integer
UNHOLY_AURA         = FourCC("AUau") ---@type integer

CARRION_SCARAB      = FourCC("AUcb") ---@type integer
IMPALE              = FourCC("AUim") ---@type integer
LOCUST_SWARM        = FourCC("AUls") ---@type integer
THORNY_SHIELD       = FourCC("AUts") ---@type integer

-- undead units
ABOMINATION         = FourCC("uabo") ---@type integer
ACOLYTE             = FourCC("uaco") ---@type integer
BANSHEE             = FourCC("uban") ---@type integer
PIT_FIEND           = FourCC("ucry") ---@type integer
CRYPT_FIEND         =  PIT_FIEND ---@type integer
FROST_WYRM          = FourCC("ufro") ---@type integer
GARGOYLE            = FourCC("ugar") ---@type integer
GARGOYLE_MORPH      = FourCC("ugrm") ---@type integer
GHOUL               = FourCC("ugho") ---@type integer
MEAT_WAGON          = FourCC("umtw") ---@type integer
NECRO               = FourCC("unec") ---@type integer
SKEL_WARRIOR        = FourCC("uske") ---@type integer
SHADE               = FourCC("ushd") ---@type integer
UNDEAD_BARGE        = FourCC("uarb") ---@type integer
OBSIDIAN_STATUE     = FourCC("uobs") ---@type integer
OBS_STATUE          =  OBSIDIAN_STATUE ---@type integer
BLK_SPHINX          = FourCC("ubsp") ---@type integer

-- undead buildings
UNDEAD_MINE         = FourCC("ugol") ---@type integer
UNDEAD_ALTAR        = FourCC("uaod") ---@type integer
BONEYARD            = FourCC("ubon") ---@type integer
GARG_SPIRE          = FourCC("ugsp") ---@type integer
NECROPOLIS_1        = FourCC("unpl")    -- normal ---@type integer
NECROPOLIS_2        = FourCC("unp1")    -- upgraded once ---@type integer
NECROPOLIS_3        = FourCC("unp2")    -- full upgrade ---@type integer
SAC_PIT             = FourCC("usap") ---@type integer
CRYPT               = FourCC("usep") ---@type integer
SLAUGHTERHOUSE      = FourCC("uslh") ---@type integer
DAMNED_TEMPLE       = FourCC("utod") ---@type integer
ZIGGURAT_1          = FourCC("uzig")    -- normal ---@type integer
ZIGGURAT_2          = FourCC("uzg1")    -- upgraded ---@type integer
ZIGGURAT_FROST      = FourCC("uzg2")    -- frost tower ---@type integer
GRAVEYARD           = FourCC("ugrv") ---@type integer
TOMB_OF_RELICS      = FourCC("utom") ---@type integer

-- undead upgrades
UPG_UNHOLY_STR      = FourCC("Rume") ---@type integer
UPG_CR_ATTACK       = FourCC("Rura") ---@type integer
UPG_UNHOLY_ARMOR    = FourCC("Ruar") ---@type integer
UPG_CANNIBALIZE     = FourCC("Ruac") ---@type integer
UPG_GHOUL_FRENZY    = FourCC("Rugf") ---@type integer
UPG_FIEND_WEB       = FourCC("Ruwb") ---@type integer
UPG_ABOM            = FourCC("Ruab") ---@type integer
UPG_STONE_FORM      = FourCC("Rusf") ---@type integer
UPG_NECROS          = FourCC("Rune") ---@type integer
UPG_BANSHEE         = FourCC("Ruba") ---@type integer
UPG_MEAT_WAGON      = FourCC("Rump") ---@type integer
UPG_WYRM_BREATH     = FourCC("Rufb") ---@type integer
UPG_SKEL_LIFE       = FourCC("Rusl") ---@type integer
UPG_SKEL_MASTERY    = FourCC("Rusm") ---@type integer
UPG_EXHUME          = FourCC("Ruex") ---@type integer
UPG_SACRIFICE       = FourCC("Rurs") ---@type integer
UPG_ABOM_EXPL       = FourCC("Ruax") ---@type integer
UPG_CR_ARMOR        = FourCC("Rucr") ---@type integer
UPG_PLAGUE          = FourCC("Rupc") ---@type integer
UPG_BLK_SPHINX      = FourCC("Rusp") ---@type integer
UPG_BURROWING       = FourCC("Rubu") ---@type integer

----------------------------------------------------------------------
--  ELVES
----------------------------------------------------------------------

-- elf heroes
DEMON_HUNTER        = FourCC("Edem") ---@type integer
DEMON_HUNTER_M      = FourCC("Edmm") ---@type integer
KEEPER              = FourCC("Ekee") ---@type integer
MOON_CHICK          = FourCC("Emoo") ---@type integer
MOON_BABE           =  MOON_CHICK ---@type integer
MOON_HONEY          =  MOON_CHICK ---@type integer
WARDEN              = FourCC("Ewar") ---@type integer

-- special elf heroes
SYLVANUS            = FourCC("Hvwd") ---@type integer
CENARIUS            = FourCC("Ecen") ---@type integer
ILLIDAN             = FourCC("Eevi") ---@type integer
ILLIDAN_DEMON       = FourCC("Eevm") ---@type integer
MAIEV               = FourCC("Ewrd") ---@type integer

-- elf hero abilities
FORCE_NATURE        = FourCC("AEfn") ---@type integer
ENT_ROOTS           = FourCC("AEer") ---@type integer
THORNS_AURA         = FourCC("AEah") ---@type integer
TRANQUILITY         = FourCC("AEtq") ---@type integer

EVASION             = FourCC("AEev") ---@type integer
IMMOLATION          = FourCC("AEim") ---@type integer
MANA_BURN           = FourCC("AEmb") ---@type integer
METAMORPHOSIS       = FourCC("AEme") ---@type integer

SEARING_ARROWS      = FourCC("AHfa") ---@type integer
SCOUT               = FourCC("AEst") ---@type integer
STARFALL            = FourCC("AEsf") ---@type integer
TRUESHOT            = FourCC("AEar") ---@type integer

BLINK               = FourCC("AEbl") ---@type integer
FAN_KNIVES          = FourCC("AEfk") ---@type integer
SHADOW_TOUCH        = FourCC("AEsh") ---@type integer
VENGEANCE           = FourCC("AEsv") ---@type integer

-- elf units
WISP                = FourCC("ewsp") ---@type integer
ARCHER              = FourCC("earc") ---@type integer
DRUID_TALON         = FourCC("edot") ---@type integer
DRUID_TALON_M       = FourCC("edtm") ---@type integer
BALLISTA            = FourCC("ebal") ---@type integer
DRUID_CLAW          = FourCC("edoc") ---@type integer
DRUID_CLAW_M        = FourCC("edcm") ---@type integer
DRYAD               = FourCC("edry") ---@type integer
HIPPO               = FourCC("ehip") ---@type integer
HIPPO_RIDER         = FourCC("ehpr") ---@type integer
HUNTRESS            = FourCC("esen") ---@type integer
CHIMAERA            = FourCC("echm") ---@type integer
ENT                 = FourCC("efon") ---@type integer
MOUNTAIN_GIANT      = FourCC("emtg") ---@type integer
FAERIE_DRAGON       = FourCC("efdr") ---@type integer

-- special elf units
HIGH_ARCHER         = FourCC("nhea") ---@type integer
HIGH_FOOTMAN        = FourCC("hcth") ---@type integer
HIGH_FOOTMEN        =  HIGH_FOOTMAN ---@type integer
HIGH_SWORDMAN       = FourCC("hhes") ---@type integer
DRAGON_HAWK         = FourCC("nws1") ---@type integer
CORRUPT_TREANT      = FourCC("nenc") ---@type integer
POISON_TREANT       = FourCC("nenp") ---@type integer
PLAGUE_TREANT       = FourCC("nepl") ---@type integer
SHANDRIS            = FourCC("eshd") ---@type integer

-- elf buildings
ANCIENT_LORE        = FourCC("eaoe") ---@type integer
ANCIENT_WAR         = FourCC("eaom") ---@type integer
ANCIENT_WIND        = FourCC("eaow") ---@type integer
TREE_AGES           = FourCC("etoa") ---@type integer
TREE_ETERNITY       = FourCC("etoe") ---@type integer
TREE_LIFE           = FourCC("etol") ---@type integer
ANCIENT_PROTECT     = FourCC("etrp") ---@type integer
ELF_ALTAR           = FourCC("eate") ---@type integer
BEAR_DEN            = FourCC("edol") ---@type integer
CHIMAERA_ROOST      = FourCC("edos") ---@type integer
HUNTERS_HALL        = FourCC("edob") ---@type integer
MOON_WELL           = FourCC("emow") ---@type integer
ELF_MINE            = FourCC("egol") ---@type integer
DEN_OF_WONDERS      = FourCC("eden") ---@type integer

-- special elf buildings
ELF_FARM            = FourCC("nefm") ---@type integer
ELF_GUARD_TOWER     = FourCC("negt") ---@type integer
HIGH_SKY            = FourCC("negm") ---@type integer
HIGH_EARTH          = FourCC("negf") ---@type integer
HIGH_TOWER          = FourCC("negt") ---@type integer
ELF_HIGH_BARRACKS   = FourCC("nheb") ---@type integer
CORRUPT_LIFE        = FourCC("nctl") ---@type integer
CORRUPT_WELL        = FourCC("ncmw") ---@type integer
CORRUPT_PROTECTOR   = FourCC("ncap") ---@type integer
CORRUPT_WAR         = FourCC("ncaw") ---@type integer

-- elf upgrades
UPG_STR_MOON        = FourCC("Resm") ---@type integer
UPG_STR_WILD        = FourCC("Resw") ---@type integer
UPG_MOON_ARMOR      = FourCC("Rema") ---@type integer
UPG_HIDES           = FourCC("Rerh") ---@type integer
UPG_ULTRAVISION     = FourCC("Reuv") ---@type integer
UPG_BLESSING        = FourCC("Renb") ---@type integer
UPG_SCOUT           = FourCC("Resc") ---@type integer
UPG_GLAIVE          = FourCC("Remg") ---@type integer
UPG_BOWS            = FourCC("Reib") ---@type integer
UPG_MARKSMAN        = FourCC("Remk") ---@type integer
UPG_DRUID_TALON     = FourCC("Redt") ---@type integer
UPG_DRUID_CLAW      = FourCC("Redc") ---@type integer
UPG_ABOLISH         = FourCC("Resi") ---@type integer
UPG_CHIM_ACID       = FourCC("Recb") ---@type integer
UPG_HIPPO_TAME      = FourCC("Reht") ---@type integer
UPG_BOLT            = FourCC("Repd") ---@type integer
UPG_MARK_CLAW       = FourCC("Reeb") ---@type integer
UPG_MARK_TALON      = FourCC("Reec") ---@type integer
UPG_HARD_SKIN       = FourCC("Rehs") ---@type integer
UPG_RESIST_SKIN     = FourCC("Rers") ---@type integer
UPG_WELL_SPRING     = FourCC("Rews") ---@type integer

----------------------------------------------------------------------
-- Neutral
----------------------------------------------------------------------
DEMON_GATE          = FourCC("ndmg") ---@type integer
FELLHOUND           = FourCC("nfel") ---@type integer
INFERNAL            = FourCC("ninf") ---@type integer
DOOMGUARD           = FourCC("nbal") ---@type integer
SATYR               = FourCC("nsty") ---@type integer
TRICKSTER           = FourCC("nsat") ---@type integer
SHADOWDANCER        = FourCC("nsts") ---@type integer
SOULSTEALER         = FourCC("nstl") ---@type integer
HELLCALLER          = FourCC("nsth") ---@type integer
SKEL_ARCHER         = FourCC("nska") ---@type integer
SKEL_MARKSMAN       = FourCC("nskm") ---@type integer
SKEL_BURNING        = FourCC("nskf") ---@type integer
SKEL_GIANT          = FourCC("nskg") ---@type integer
FURBOLG             = FourCC("nfrl") ---@type integer
FURBOLG_TRACKER     = FourCC("nfrb") ---@type integer
FURBOLG_SHAMAN      = FourCC("nfrs") ---@type integer
FURBOLG_CHAMP       = FourCC("nfrg") ---@type integer
FURBOLG_ELDER       = FourCC("nfre") ---@type integer

----------------------------------------------------------------------
-- NAGA
----------------------------------------------------------------------

-- naga heroes
NAGA_SORCERESS      = FourCC("Nngs") ---@type integer
NAGA_VASHJ          = FourCC("Hvsh") ---@type integer

-- naga units
NAGA_DRAGON         = FourCC("nsnp")        -- old names ---@type integer
NAGA_WITCH          = FourCC("nnsw") ---@type integer
NAGA_SERPENT        = FourCC("nwgs") ---@type integer
NAGA_HYDRA          = FourCC("nhyc") ---@type integer

NAGA_SLAVE          = FourCC("nmpe")        -- peon ---@type integer
NAGA_SNAP_DRAGON    =  NAGA_DRAGON  -- weak ranged ---@type integer
NAGA_COUATL         =  NAGA_SERPENT -- weak air ---@type integer
NAGA_SIREN          =  NAGA_WITCH   -- caster ---@type integer
NAGA_MYRMIDON       = FourCC("nmyr")        -- knight ---@type integer
NAGA_REAVER         = FourCC("nnmg")        -- footman ---@type integer
NAGA_TURTLE         =  NAGA_HYDRA   -- siege ---@type integer
NAGA_ROYAL          = FourCC("nnrg")        -- royal guard ---@type integer

-- naga buildings
NAGA_TEMPLE         = FourCC("nntt")        -- town hall ---@type integer
NAGA_CORAL          = FourCC("nnfm")        -- farm ---@type integer
NAGA_SHRINE         = FourCC("nnsa")        -- sirens & couatls ---@type integer
NAGA_SPAWNING       = FourCC("nnsg")        -- myrm, snap dragon, hydra ---@type integer
NAGA_GUARDIAN       = FourCC("nntg")        -- tower ---@type integer
NAGA_ALTAR          = FourCC("nnad")        -- altar ---@type integer

-- naga upgrades
UPG_NAGA_ARMOR      = FourCC("Rnam") ---@type integer
UPG_NAGA_ATTACK     = FourCC("Rnat") ---@type integer
UPG_NAGA_ABOLISH    = FourCC("Rnsi") ---@type integer
UPG_SIREN           = FourCC("Rnsw") ---@type integer
UPG_NAGA_ENSNARE    = FourCC("Rnen") ---@type integer


----------------------------------------------------------------------
M1                  =    60 ---@type integer
M2                  =  2*60 ---@type integer
M3                  =  3*60 ---@type integer
M4                  =  4*60 ---@type integer
M5                  =  5*60 ---@type integer
M6                  =  6*60 ---@type integer
M7                  =  7*60 ---@type integer
M8                  =  8*60 ---@type integer
M9                  =  9*60 ---@type integer
M10                 = 10*60 ---@type integer
M11                 = 11*60 ---@type integer
M12                 = 12*60 ---@type integer
M13                 = 13*60 ---@type integer
M14                 = 14*60 ---@type integer
M15                 = 15*60 ---@type integer

EASY                = 1 ---@type integer
NORMAL              = 2 ---@type integer
HARD                = 3 ---@type integer
INSANE              = 4 -- not used ---@type integer

MELEE_NEWBIE        = 1 ---@type integer
MELEE_NORMAL        = 2 ---@type integer
MELEE_INSANE        = 3 ---@type integer

ATTACK_CAPTAIN      = 1 ---@type integer
DEFENSE_CAPTAIN     = 2 ---@type integer
BOTH_CAPTAINS       = 3 ---@type integer

BUILD_UNIT          = 1 ---@type integer
BUILD_UPGRADE       = 2 ---@type integer
BUILD_EXPAND        = 3 ---@type integer

UPKEEP_TIER1        = 50 ---@type integer
UPKEEP_TIER2        = 80 ---@type integer

----------------------------------------------------------------------

ai_player  = nil ---@type player

sleep_seconds = nil ---@type integer
total_gold                                       = 0 ---@type integer
total_wood                                       = 0 ---@type integer
gold_buffer                                      = 0 -- usually for potion money ---@type integer
difficulty                                       = NORMAL ---@type integer
exp_seen                                         = 0 ---@type integer
racial_farm                                      = FourCC("hhou") ---@type integer
hero_id                                          = FourCC("Hamg") ---@type integer
hero_id2                                         = FourCC("Hmkg") ---@type integer
hero_id3                                         = FourCC("Hpal") ---@type integer
skill = {} ---@type integer[]
skills1 = {} ---@type integer[]
skills2 = {} ---@type integer[]
skills3 = {} ---@type integer[]
max_hero_level                                   = 0 ---@type integer

harass_qty = {} ---@type integer[]
harass_max = {} ---@type integer[]
harass_units = {} ---@type integer[]
harass_length                                        = 0 ---@type integer

defense_qty = {} ---@type integer[]
defense_units = {} ---@type integer[]
defense_length                                   = 0 ---@type integer

build_qty = {} ---@type integer[]
build_type = {} ---@type integer[]
build_item = {} ---@type integer[]
build_town = {} ---@type integer[]
build_length                                     = 0 ---@type integer

campaign_gold_peons                              = 5 ---@type integer
campaign_wood_peons                              = 3 ---@type integer
campaign_basics_speed                            = 5 ---@type integer

min_creeps                                       = -1 ---@type integer
max_creeps                                          = -1 ---@type integer

harvest_town1                                    = true ---@type boolean
harvest_town2                                    = true ---@type boolean
harvest_town3                                    = true ---@type boolean
do_campaign_farms                                = true ---@type boolean
two_heroes                                       = false ---@type boolean
allow_air_creeps                                 = false ---@type boolean
take_exp                                         = false ---@type boolean
allow_signal_abort                               = false ---@type boolean
ready_for_zeppelin                               = true ---@type boolean
get_zeppelin                                        = false ---@type boolean

build_campaign_attackers                          = true ---@type boolean

do_debug_cheats                                  = false ---@type boolean
trace_on                                         = true ---@type boolean
zep_next_wave                                    = false ---@type boolean
form_group_timeouts                              = true ---@type boolean

----------------------------------------------------------------------

debug_player = nil ---@type player
debug                                              = false ---@type boolean

suicide                                             = false ---@type boolean

wave_reach_goal_timeout_seconds                  = 300 ---@type integer
wave_enter_combat_timeout_seconds                  = 3 ---@type integer
wave_clear_goal_timeout_seconds                     = 60 ---@type integer

continue_far_away_radius                              = 960.0 ---@type real
preferred_locations_radius                          = 640.0 ---@type real

wave_reach_goal_sleep_seconds = nil ---@type integer
wave_enter_combat_sleep_seconds = nil ---@type integer
wave_clear_goal_sleep_seconds = nil ---@type integer

defense_captain_home_x = nil ---@type real
defense_captain_home_y = nil ---@type real
defense_captain_home_set                          = false ---@type boolean

attack_wave_gather_return_x = nil ---@type real
attack_wave_gather_return_y = nil ---@type real
attack_wave_gather_return_set                     = false ---@type boolean
    
preferred_locations = {} ---@type location[]
preferred_locations_count                          = 0 ---@type integer

preferred_locations_current = {} ---@type location[]
preferred_locations_count_current                  = 0 ---@type integer

wood_peons_warriors                              = false ---@type boolean

search_preferred_locations                          = true ---@type boolean
search_everywhere                                  = true ---@type boolean
can_search_units                                  = true ---@type boolean
can_search_invulnerable                          = false ---@type boolean
prioritize_town_halls                              = true ---@type boolean
prioritize_nearest                                  = true ---@type boolean

reach_goal_timeout                                  = true ---@type boolean
enter_combat_timeout                              = true ---@type boolean
clear_goal_timeout                                  = true ---@type boolean
continue_attack_percentage                          = 100 ---@type integer
continue_attack_reduce_percentage_if_far_away      = true ---@type boolean
continue_attack_reduce_percentage                  = 25 ---@type integer

targetable_town_halls = {} ---@type unit[]
targetable_town_halls_count                      = 0 ---@type integer

targetable_buildings = {} ---@type unit[]
targetable_buildings_count                          = 0 ---@type integer

targetable_units = {} ---@type unit[]
targetable_units_count                              = 0 ---@type integer

last_target_x = nil ---@type real
last_target_y = nil ---@type real
search_target_max_cycles_default                 = 100 ---@type integer
search_target_max_cycles_last_target             = 10 ---@type integer
    


--============================================================================
---@param slot integer
---@return player
function PlayerEx(slot)
    return Player(slot-1)
end

--============================================================================
---@param message string
function Trace(message)
    if trace_on then
        DisplayText(GetAiPlayer(),message)
    end
end

--============================================================================
---@param message string
---@param val integer
function TraceI(message, val)
    if trace_on then
        DisplayTextI(GetAiPlayer(),message,val)
    end
end

--============================================================================
---@param message string
---@param v1 integer
---@param v2 integer
function TraceII(message, v1, v2)
    if trace_on then
        DisplayTextII(GetAiPlayer(),message,v1,v2)
    end
end

--============================================================================
---@param message string
---@param v1 integer
---@param v2 integer
---@param v3 integer
function TraceIII(message, v1, v2, v3)
    if trace_on then
        DisplayTextIII(GetAiPlayer(),message,v1,v2,v3)
    end
end

--============================================================================
function InitAI()
    ai_player = Player(GetAiPlayer())
    sleep_seconds = 0
    StopGathering()
end

--============================================================================
---@param heroes function
---@param peons function
---@param attacks function
function StandardAI(heroes, peons, attacks)

    local isNewbie  =(MeleeDifficulty() == MELEE_NEWBIE) ---@type boolean

    InitAI()

    SetMeleeAI()

    SetDefendPlayer(true)
    SetGroupsFlee(not isNewbie)
    SetHeroesBuyItems(not isNewbie)
    SetHeroesFlee(true)
    SetHeroesTakeItems(true)
    SetIgnoreInjured(true)
    SetPeonsRepair(true)
    SetSmartArtillery(not isNewbie)
    SetTargetHeroes(not isNewbie)
    SetUnitsFlee(not isNewbie)
    SetWatchMegaTargets(true)

    CreateCaptains()

    SetHeroLevels(heroes)

    Sleep(0.1)
    StartThread(peons)
    StartThread(attacks)
end

--============================================================================
--  Utility Functions
--============================================================================
---@param A integer
---@param B integer
---@return integer
function Min(A, B)
    if A < B then
        return A
    else
        return B
    end
end

---@param A integer
---@param B integer
---@return integer
function Max(A, B)
    if A > B then
        return A
    else
        return B
    end
end

function SetZepNextWave()
    zep_next_wave = true
end

---@param seconds integer
function SuicideSleep(seconds)
    sleep_seconds = sleep_seconds - seconds
    while not(seconds <= 0) do
        if allow_signal_abort and CommandsWaiting() ~= 0 then break end
        if suicide then break end

        if seconds >= 5 then
            Sleep(5)
            seconds = seconds - 5
        else
            Sleep(seconds)
            seconds = 0
        end
    end
end

--============================================================================
---@return integer
function WaitForSignal()
    local cmd = nil ---@type integer
    local display  = false --xxx ---@type boolean
    while not(CommandsWaiting() ~= 0) do

        --xxx
        Trace("waiting for a signal to begin AI script...\n")
        display = true
        Sleep(2)
        if CommandsWaiting() ~= 0 then break end
        Sleep(2)
        if CommandsWaiting() ~= 0 then break end
        Sleep(2)
        if CommandsWaiting() ~= 0 then break end
        Sleep(2)
        if CommandsWaiting() ~= 0 then break end
        Sleep(2)
        --xxx

    end

    --xxx
    if display then
        Trace("signal received, beginning AI script\n")
    end
    --xxx

    cmd = GetLastCommand()
    PopLastCommand()
    return cmd
end

--============================================================================
---@param count integer
function SetWoodPeons(count)
    campaign_wood_peons = count
end

--============================================================================
---@param count integer
function SetGoldPeons(count)
    campaign_gold_peons = count
end

--============================================================================
---@param harvest boolean
function SetHarvestLumber(harvest)
    if harvest then
        campaign_wood_peons = 3
    else
        campaign_wood_peons = 0
    end
end

--============================================================================
---@param state boolean
function SetFormGroupTimeouts(state)
    form_group_timeouts = state
end

--============================================================================
---@param state boolean
function DoCampaignFarms(state)
    do_campaign_farms = state
end

--============================================================================
---@return unit
function GetMinorCreep()
    return GetCreepCamp(0,9,false)
end

--============================================================================
---@return unit
function GetMajorCreep()
    return GetCreepCamp(10,100,allow_air_creeps)
end

--============================================================================
---@return integer
function GetGold()
    return GetPlayerState(ai_player,PLAYER_STATE_RESOURCE_GOLD)
end

--============================================================================
---@return integer
function GetWood()
    return GetPlayerState(ai_player,PLAYER_STATE_RESOURCE_LUMBER)
end

--============================================================================
function InitBuildArray()
    build_length = 0
end

--============================================================================
function InitAssaultGroup()
    harass_length = 0
end

--============================================================================
function InitDefenseGroup()
    defense_length = 0
end

--============================================================================
function InitMeleeGroup()
    InitAssaultGroup()
    RemoveInjuries()
    RemoveSiege()
end

--============================================================================
function PrepFullSuicide()
    InitAssaultGroup()
    InitDefenseGroup()
    campaign_gold_peons = 0
    campaign_wood_peons = 0
end

--============================================================================
---@param easy integer
---@param med integer
---@param hard integer
function SetReplacements(easy, med, hard)
    if difficulty == EASY then
        SetReplacementCount(easy)
    elseif difficulty == NORMAL then
        SetReplacementCount(med)
    else
        SetReplacementCount(hard)
    end
end

--============================================================================
---@param func function
function StartTownBuilder(func)
    StartThread(func)
end

--============================================================================
---@param t integer
---@param qty integer
---@param unitid integer
---@param town integer
function SetBuildAll(t, qty, unitid, town)
    if qty > 0 then
        build_qty[build_length] = qty
        build_type[build_length] = t
        build_item[build_length] = unitid
        build_town[build_length] = town
        build_length = build_length + 1
    end
end

--============================================================================
---@param qty integer
---@param unitid integer
function SetBuildUnit(qty, unitid)
    SetBuildAll(BUILD_UNIT,qty,unitid,-1)
end

--============================================================================
---@param qty integer
---@param unitid integer
function SetBuildNext(qty, unitid)
    local has  = GetUnitCount(unitid) ---@type integer
    if has >= qty then
        return
    end
    SetBuildAll(BUILD_UNIT,GetUnitCountDone(unitid)+1,unitid,-1)
end

--============================================================================
---@param easy integer
---@param med integer
---@param hard integer
---@param unitid integer
function SetBuildUnitEx(easy, med, hard, unitid)
    if difficulty == EASY then
        SetBuildAll(BUILD_UNIT,easy,unitid,-1)
    elseif difficulty == NORMAL then
        SetBuildAll(BUILD_UNIT,med,unitid,-1)
    else
        SetBuildAll(BUILD_UNIT,hard,unitid,-1)
    end
end

--============================================================================
---@param town integer
---@param qty integer
---@param unitid integer
function SecondaryTown(town, qty, unitid)
    SetBuildAll(BUILD_UNIT,qty,unitid,town)
end

--============================================================================
---@param town integer
---@param qty integer
---@param unitid integer
function SecTown(town, qty, unitid)
    SetBuildAll(BUILD_UNIT,qty,unitid,town)
end

--============================================================================
---@param qty integer
---@param unitid integer
function SetBuildUpgr(qty, unitid)
    if MeleeDifficulty() ~= MELEE_NEWBIE or qty == 1 then
        SetBuildAll(BUILD_UPGRADE,qty,unitid,-1)
    end
end

--============================================================================
---@param easy integer
---@param med integer
---@param hard integer
---@param unitid integer
function SetBuildUpgrEx(easy, med, hard, unitid)
    if difficulty == EASY then
        SetBuildAll(BUILD_UPGRADE,easy,unitid,-1)
    elseif difficulty == NORMAL then
        SetBuildAll(BUILD_UPGRADE,med,unitid,-1)
    else
        SetBuildAll(BUILD_UPGRADE,hard,unitid,-1)
    end
end

--============================================================================
---@param qty integer
---@param unitid integer
function SetBuildExpa(qty, unitid)
    SetBuildAll(BUILD_EXPAND,qty,unitid,-1)
end

--============================================================================
---@param level integer
---@param upgid integer
---@return boolean
function StartUpgrade(level, upgid)
    local gold_cost = nil ---@type integer
    local wood_cost = nil ---@type integer

    if GetUpgradeLevel(upgid) >= level then
        return true
    end

    gold_cost = GetUpgradeGoldCost(upgid)
    if total_gold < gold_cost then
        return false
    end

    wood_cost = GetUpgradeWoodCost(upgid)
    if total_wood < wood_cost then
        return false
    end

    return SetUpgrade(upgid)
end

--============================================================================
---@param unitid integer
function BuildFactory(unitid)
    if GetGold() > 1000 and GetWood() > 500 then
        SetBuildUnit( 2, unitid )
    else
        SetBuildUnit( 1, unitid )
    end
end

--============================================================================
---@param unitid integer
---@return boolean
function HallsCompleted(unitid)
    return GetUnitCount(unitid) == GetUnitCountDone(unitid)
end

--============================================================================
---@param townid integer
---@param qty integer
---@param unitid integer
function GuardSecondary(townid, qty, unitid)
    if TownHasHall(townid) and TownHasMine(townid) then
        SecondaryTown( townid, qty, unitid )
    end
end

--============================================================================
---@param unitid integer
---@param only_done boolean
---@param townid integer
---@return integer
function GetUnitCountEx(unitid, only_done, townid)
    if townid == -1 then
        if only_done then
            return GetUnitCountDone(unitid)
        else
            return GetUnitCount(unitid)
        end
    else
        return GetTownUnitCount(unitid,townid,only_done)
    end
end

--============================================================================
---@param unitid integer
---@param only_done boolean
---@param townid integer
---@return integer
function TownCountEx(unitid, only_done, townid)

    local have_qty  = GetUnitCountEx(unitid,only_done,townid) ---@type integer

    if unitid == TOWN_HALL then
        have_qty = have_qty + GetUnitCountEx(KEEP,false,townid) + GetUnitCountEx(CASTLE,false,townid)
    elseif unitid == KEEP then
        have_qty = have_qty  + GetUnitCountEx(CASTLE,false,townid)

    elseif unitid == WATCH_TOWER then
        have_qty = have_qty + GetUnitCountEx(GUARD_TOWER,false,townid) + GetUnitCountEx(CANNON_TOWER,false,townid) + GetUnitCountEx(ARCANE_TOWER,false,townid)

    elseif unitid == PEASANT then
        have_qty = have_qty + GetUnitCountEx(MILITIA,false,townid)

    elseif unitid == GREAT_HALL then
        have_qty = have_qty + GetUnitCountEx(STRONGHOLD,false,townid) + GetUnitCountEx(FORTRESS,false,townid)
    elseif unitid == STRONGHOLD then
        have_qty = have_qty + GetUnitCountEx(FORTRESS,false,townid)

    elseif unitid == HEAD_HUNTER then
        have_qty = have_qty + GetUnitCountEx(BERSERKER,false,townid)

    elseif unitid == SPIRIT_WALKER then
        have_qty = have_qty + GetUnitCountEx(SPIRIT_WALKER_M,false,townid)
    elseif unitid == SPIRIT_WALKER_M then
        have_qty = have_qty + GetUnitCountEx(SPIRIT_WALKER,only_done,townid)

    elseif unitid == NECROPOLIS_1 then
        have_qty = have_qty + GetUnitCountEx(NECROPOLIS_2,false,townid) + GetUnitCountEx(NECROPOLIS_3,false,townid)
    elseif unitid == NECROPOLIS_2 then
        have_qty = have_qty + GetUnitCountEx(NECROPOLIS_3,false,townid)

    elseif unitid == ZIGGURAT_1 then
        have_qty = have_qty + GetUnitCountEx(ZIGGURAT_2,false,townid) + GetUnitCountEx(ZIGGURAT_FROST,false,townid)

    elseif unitid == GARGOYLE then
        have_qty = have_qty + GetUnitCountEx(GARGOYLE_MORPH,false,townid)

    elseif unitid == TREE_LIFE then
        have_qty = have_qty + GetUnitCountEx(TREE_AGES,false,townid) + GetUnitCountEx(TREE_ETERNITY,false,townid)
    elseif unitid == TREE_AGES then
        have_qty = have_qty + GetUnitCountEx(TREE_ETERNITY,false,townid)

    elseif unitid == DRUID_TALON then
        have_qty = have_qty + GetUnitCountEx(DRUID_TALON_M,false,townid)
    elseif unitid == DRUID_TALON_M then
        have_qty = have_qty + GetUnitCountEx(DRUID_TALON,only_done,townid)

    elseif unitid == DRUID_CLAW then
        have_qty = have_qty + GetUnitCountEx(DRUID_CLAW_M,false,townid)
    elseif unitid == DRUID_CLAW_M then
        have_qty = have_qty + GetUnitCountEx(DRUID_CLAW,only_done,townid)

    elseif unitid == ILLIDAN then
        have_qty = have_qty + GetUnitCountEx(ILLIDAN_DEMON,false,townid)

    end
    return have_qty
end

--============================================================================
---@param base integer
---@return integer
function TownCountDone(base)
    return TownCountEx(base,true,-1)
end

--============================================================================
---@param base integer
---@return integer
function TownCount(base)
    return TownCountEx(base,false,-1)
end

--============================================================================
---@param build_it boolean
---@param unitid integer
function BasicExpansion(build_it, unitid)
    if build_it and HallsCompleted(unitid) then
        SetBuildExpa( TownCount(unitid)+1, unitid )
    end
end

--============================================================================
---@param baseid integer
---@param newid integer
function UpgradeAll(baseid, newid)
    SetBuildUnit( TownCountDone(baseid), newid )
end

--============================================================================
---@param base integer
---@param townid integer
---@return integer
function TownCountTown(base, townid)
    return TownCountEx(base,false,townid)
end

--============================================================================
--  FoodPool
--============================================================================
---@param food integer
---@param weak boolean
---@param id1 integer
---@param use1 integer
---@param strong boolean
---@param id2 integer
---@param use2 integer
function FoodPool(food, weak, id1, use1, strong, id2, use2)
    if strong then
        SetBuildUnit((food - use1 * TownCount(id1)) / use2, id2 )
    elseif weak then
        SetBuildUnit((food - use2 * TownCount(id2)) / use1, id1 )
    end
end

--============================================================================
--  MeleeTownHall
--============================================================================
---@param townid integer
---@param unitid integer
function MeleeTownHall(townid, unitid)
    if TownHasMine(townid) and not TownHasHall(townid) then
        SecondaryTown( townid, 1, unitid )
    end
end

--============================================================================
---@param unitid integer
---@param qty integer
function WaitForUnits(unitid, qty)
    while not(TownCountDone(unitid) == qty) do
        Sleep(2)
    end
end

--============================================================================
---@param ask_qty integer
---@param unitid integer
---@param town integer
---@return boolean
function StartUnit(ask_qty, unitid, town)
    local have_qty = nil ---@type integer
    local need_qty = nil ---@type integer
    local afford_gold = nil ---@type integer
    local afford_wood = nil ---@type integer
    local afford_qty = nil ---@type integer
    local gold_cost = nil ---@type integer
    local wood_cost = nil ---@type integer

    --------------------------------------------------------------------------
    -- if we have all we're asking for then make nothing
    --
    if town == -1 then
        have_qty = TownCount(unitid)
    else
        have_qty = TownCountTown(unitid,town)
    end

    if have_qty >= ask_qty then
        return true
    end
    need_qty = ask_qty - have_qty

    --------------------------------------------------------------------------
    -- limit the qty we're requesting to the amount of resources available
    --
    gold_cost = GetUnitGoldCost(unitid)
    wood_cost = GetUnitWoodCost(unitid)

    if gold_cost == 0 then
        afford_gold = need_qty
    else
        afford_gold = total_gold / gold_cost
    end
    if afford_gold < need_qty then
        afford_qty = afford_gold
    else
        afford_qty = need_qty
    end

    if wood_cost == 0 then
        afford_wood = need_qty
    else
        afford_wood = total_wood / wood_cost
    end
    if afford_wood < afford_qty then
        afford_qty = afford_wood
    end

    -- if we're waiting on gold/wood; pause build orders
    if afford_qty < 1 then
        return false
    end

    --------------------------------------------------------------------------
    -- whether we make right now what we're requesting or not, assume we will
    -- and deduct the cost of the units from our fake gold total right away
    --
    total_gold = total_gold - gold_cost * need_qty
    total_wood = total_wood - wood_cost * need_qty

    if total_gold < 0 then
        total_gold = 0
    end
    if total_wood < 0 then
        total_wood = 0
    end

    --------------------------------------------------------------------------
    -- give the AI a chance to make the units(it may not be able to right now
    -- but that doesn't stop us from trying other units after self as long
    -- as we have enough money to make self AND the needed, unbuilt ones)
    --
    return SetProduce(afford_qty,unitid,town)
end

--============================================================================
---@param towns integer
---@param townid integer
function WaitForTown(towns, townid)
    local i  = 0 ---@type integer
    repeat
        Sleep(10)
        if TownCount(townid) >= towns then break end
        i = i + 1
    until i == 12
end

--============================================================================
---@param qty integer
---@param hall integer
---@return boolean
function StartExpansion(qty, hall)
    local count = nil ---@type integer
    local town = nil ---@type integer
    local peon    = nil ---@type unit
    local gold_cost = nil ---@type integer

    count = TownCount(hall)
    if count >= qty then
        return true
    end

    town = GetNextExpansion()
    if town == -1 then
        return true
    end

    take_exp = true

    gold_cost = GetUnitGoldCost(hall)
    if gold_cost > total_gold then
        return false
    end
    total_gold = total_gold - gold_cost

    if GetExpansionFoe() ~= nil then
        return true
    end

    peon = GetExpansionPeon()
    if peon ~= nil then
        return SetExpansion(peon,hall)
    end

    return true
end

--============================================================================
function OneBuildLoop()
    local index  = 0 ---@type integer
    local qty = nil ---@type integer
    local id = nil ---@type integer
    local tp = nil ---@type integer

    total_gold = GetGold() - gold_buffer
    total_wood = GetWood()

    while not(index == build_length) do

        qty = build_qty [index]
        id  = build_item[index]
        tp  = build_type[index]

        ----------------------------------------------------------------------
        if tp == BUILD_UNIT then
            if not StartUnit(qty,id,build_town[index]) then
                return
            end

        ----------------------------------------------------------------------
        elseif tp == BUILD_UPGRADE then
            StartUpgrade(qty,id)

        ----------------------------------------------------------------------
        else -- tp == BUILD_EXPAND
            if not StartExpansion(qty,id) then
                return
            end
        end

        index = index + 1
    end
end

--============================================================================
---@param base real
---@param spread real
function StaggerSleep(base, spread)
    Sleep(base + spread * I2R(GetAiPlayer()) / I2R(GetPlayers()))
end

--============================================================================
function BuildLoop()
    OneBuildLoop()
    StaggerSleep(1,2)
    while true do
        OneBuildLoop()
        Sleep(2)
    end
end

--============================================================================
function StartBuildLoop()
    StartThread(BuildLoop)
end

--============================================================================
---@param seconds integer
function SetInitialWave(seconds)
    sleep_seconds = seconds
end

--============================================================================
---@param seconds integer
function AddSleepSeconds(seconds)
    sleep_seconds = sleep_seconds + seconds
end

--============================================================================
function SleepForever()
    Trace("going to sleep forever\n") --xxx
    while true do
        Sleep(100)
    end
end

--============================================================================
function PlayGame()
    StartBuildLoop()
    SleepForever()
end

--============================================================================
---@param unitid integer
function ConvertNeeds(unitid)
    if GetUnitCount(unitid) < 1 then
        StartUnit(1,unitid,-1)
    end
end

--============================================================================
---@param desire integer
---@param unitid integer
function Conversions(desire, unitid)

    if GetUnitCount(unitid) >= desire then
        return
    end

    if unitid == HIPPO_RIDER then
        ConvertNeeds(ARCHER)
        ConvertNeeds(HIPPO)
        MergeUnits(desire,ARCHER,HIPPO,HIPPO_RIDER)

    elseif unitid == BLK_SPHINX then
        ConvertNeeds(OBS_STATUE)
        ConvertUnits(desire,OBS_STATUE)
    end
end

--============================================================================
---@param qty integer
---@param max integer
---@param unitid integer
function SetAssaultGroup(qty, max, unitid)
    Conversions(max,unitid)

    if qty <= 0 and TownCountDone(unitid) == 0 then
        return
    end
    harass_qty[harass_length] = qty
    harass_max[harass_length] = max
    harass_units[harass_length] = unitid
    harass_length = harass_length + 1
end

--============================================================================
---@param e1 integer
---@param m1 integer
---@param h1 integer
---@param u1 integer
---@param e2 integer
---@param m2 integer
---@param h2 integer
---@param u2 integer
---@param e3 integer
---@param m3 integer
---@param h3 integer
---@param u3 integer
function Interleave3(e1, m1, h1, u1, e2, m2, h2, u2, e3, m3, h3, u3)
    local i1  = 1 ---@type integer
    local i2  = 1 ---@type integer
    local i3  = 1 ---@type integer
    local q1 = nil ---@type integer
    local q2 = nil ---@type integer
    local q3 = nil ---@type integer

    if difficulty == EASY then
        q1 = e1
        q2 = e2
        q3 = e3
    elseif difficulty == NORMAL then
        q1 = m1
        q2 = m2
        q3 = m3
    else -- difficulty == HARD
        q1 = h1
        q2 = h2
        q3 = h3
    end

    while not(q1<=0 and q2<=0 and q3<=0) do

        if q1 > 0 then
            SetAssaultGroup(i1,i1,u1)
            q1 = q1 - 1
            i1 = i1 + 1
        end

        if q2 > 0 then
            SetAssaultGroup(i2,i2,u2)
            q2 = q2 - 1
            i2 = i2 + 1
        end

        if q3 > 0 then
            SetAssaultGroup(i3,i3,u3)
            q3 = q3 - 1
            i3 = i3 + 1
        end
    end
end

--============================================================================
---@param unitid integer
function SetMeleeGroup(unitid)
    if unitid == hero_id then
        SetAssaultGroup(1,9,unitid)
    else
        SetAssaultGroup((TownCountDone(unitid)*3)/4,20,unitid)
    end
end

--============================================================================
---@param level integer
---@param qty integer
---@param unitid integer
function CampaignDefender(level, qty, unitid)
    if qty > 0 and difficulty >= level then
        defense_qty[defense_length] = qty
        defense_units[defense_length] = unitid
        defense_length = defense_length + 1
        Conversions(qty,unitid)
        SetBuildUnit(qty,unitid)
    end
end

--============================================================================
---@param easy integer
---@param med integer
---@param hard integer
---@param unitid integer
function CampaignDefenderEx(easy, med, hard, unitid)
    if difficulty == EASY then
        CampaignDefender(EASY,easy,unitid)
    elseif difficulty == NORMAL then
        CampaignDefender(NORMAL,med,unitid)
    else
        CampaignDefender(HARD,hard,unitid)
    end
end

--============================================================================
---@param level integer
---@param qty integer
---@param unitid integer
function CampaignAttacker(level, qty, unitid)
    if qty > 0 and difficulty >= level then
        SetAssaultGroup(qty,qty,unitid)
    end
end

--============================================================================
---@param easy integer
---@param med integer
---@param hard integer
---@param unitid integer
function CampaignAttackerEx(easy, med, hard, unitid)
    if difficulty == EASY then
        CampaignAttacker(EASY,easy,unitid)
    elseif difficulty == NORMAL then
        CampaignAttacker(NORMAL,med,unitid)
    else
        CampaignAttacker(HARD,hard,unitid)
    end
end

--============================================================================
---@param seconds integer
---@param testReady boolean
function FormGroup(seconds, testReady)
    local index = nil ---@type integer
    local count = nil ---@type integer
    local unitid = nil ---@type integer
    local desire = nil ---@type integer
    local readyPercent = nil ---@type integer

    -- normally test for CaptainReadiness() of 50%
    if testReady == true then
        readyPercent = 50
        Trace("forming group, requiring healthy guys\n") --xxx
    else
        readyPercent = 0
        Trace("forming group, unit health not important\n") --xxx
    end

    Trace("trying to gather forces\n") --xxx

    while true do
        SuicideSleep(seconds)
        InitAssault()

        index = 0
        while not(index == harass_length) do

            unitid = harass_units[index]
            desire = harass_max[index]
            count  = TownCountDone(unitid)

            Conversions(desire,unitid)

            if count >= desire then
                AddAssault(desire,unitid)
            else
                desire = harass_qty[index]

                if count < desire then
                    AddAssault(desire,unitid)
                else
                    AddAssault(count,unitid)
                end
            end

            index = index + 1
        end

        --xxx
        if form_group_timeouts and(sleep_seconds < -60) then
            Trace("exit form group -- timeout\n")
        elseif CaptainInCombat(true) then
            Trace("exit form group -- can't form while already in combat\n")
        elseif CaptainIsFull() and CaptainReadiness() >= readyPercent then
            Trace("exit form group -- ready\n")
        end
        --xxx

        -- time out and send group anyway if time has already expired
        if form_group_timeouts and(sleep_seconds < -60) then break end
        if CaptainInCombat(true) then break end
        if CaptainIsFull() and CaptainReadiness() >= readyPercent then break end
    end
end

--============================================================================
---@param unitid integer
---@return integer
function WavePrepare(unitid)
    return GetUnitBuildTime(unitid)
end

--============================================================================
---@return integer
function PrepTime()
    local unitid = nil ---@type integer
    local missing = nil ---@type integer
    local prep = nil ---@type integer
    local count = nil ---@type integer
    local largest  = 30 ---@type integer
    local index  = 0 ---@type integer

    while not(index == harass_length) do

        unitid  = harass_units[index]
        missing = harass_qty[index] + IgnoredUnits(unitid) - TownCount(unitid)
        prep    = WavePrepare(unitid) * missing

        if prep > largest then
            largest = prep
        end

        index = index + 1
    end
    TraceI("next wave will require around %d seconds to build and gather\n",largest) --xxx

    return largest
end

--============================================================================
---@param seconds integer
---@return boolean
function PrepSuicideOnPlayer(seconds)
    local wave_prep    = PrepTime() ---@type integer
    local save_length = nil ---@type integer

    save_length = harass_length
    harass_length = 0

    AddSleepSeconds(seconds)
    if sleep_seconds-wave_prep > 0 then
        TraceI("going to sleep for %d seconds before gathering next attack wave\n",sleep_seconds-wave_prep) --xxx
        SuicideSleep(sleep_seconds-wave_prep)
    end

    Trace("preparing suicide attack wave\n") --xxx

    harass_length = save_length
    if harass_length < 1 then
        Trace("ERROR - no units specificed, exiting early\n") --xxx
        return false
    end

    return true
end

--============================================================================
function SleepUntilAtGoal()
    while true do
        if CaptainRetreating() then break end
        if CaptainAtGoal() then break end        -- reached goal
        if CaptainIsHome() then break end        -- failed to path and returned home
        if CaptainIsEmpty() then break end       -- all units died
        SuicideSleep(3)
    end
end

--============================================================================
function SleepInCombat()
    local count  = 0 ---@type integer
    -- Trace("SleepInCombat\n")
    while true do
        while CaptainInCombat(true) do  -- goal is cleared
            if CaptainIsEmpty() then break end           -- duh
            SuicideSleep(1)
        end

        count = count + 1
        if count >= 8 then break end

        --xxx self is what it should have been; do self for next patch?
        --call SuicideSleep(1)
    end
    -- Trace("exit SleepInCombat\n")
end

--============================================================================
---@param x integer
---@param y integer
function AttackMoveXYA(x, y)

    if zep_next_wave then
        LoadZepWave(x,y)
        zep_next_wave = false
    end

    AttackMoveXY(x,y)
    SleepUntilAtGoal()
    SleepInCombat()
end

--============================================================================
function SuicideOnPlayerWave()
    Trace("waiting for attack wave to enter combat\n") --xxx
    repeat
        --xxx
        if allow_signal_abort and CommandsWaiting() ~= 0 then
            Trace("ABORT -- attack wave override\n")
        end

        if CaptainInCombat(true) then
            Trace("done - captain has entered combat\n")
        end

        if CaptainIsEmpty() then
            Trace("done - all units are dead\n")
        end

        if sleep_seconds < -300 then
            Trace("done - timeout, took too long to reach engage the enemy\n")
        end
        --xxx

        if allow_signal_abort and CommandsWaiting() ~= 0 then break end

        if CaptainInCombat(true) then break end
        if CaptainIsEmpty() then break end
        SuicideSleep(10)
    until sleep_seconds < -300

    Trace("waiting for attack wave to die\n") --xxx
    repeat
        --xxx
        if allow_signal_abort and CommandsWaiting() ~= 0 then
            Trace("ABORT - attack wave override\n")
        end

        if CaptainIsEmpty() then
            Trace("done - all units are dead\n")
        end

        if sleep_seconds < -300 then
            Trace("done - timeout, took too long to reach engage the enemy\n")
        end
        --xxx

        if allow_signal_abort and CommandsWaiting() ~= 0 then break end

        if CaptainIsEmpty() then break end
        SuicideSleep(10)
    until sleep_seconds < -300
end

----------------------------------------------------------------------------------------------------
---@param standard boolean
---@param bldgs boolean
---@param seconds integer
---@param p player
---@param x integer
---@param y integer
function CommonSuicideOnPlayer(standard, bldgs, seconds, p, x, y)
    local save_peons = nil ---@type integer

    if not PrepSuicideOnPlayer(seconds) then
        return
    end

    save_peons = campaign_wood_peons
    campaign_wood_peons = 0

    while true do
        --xxx
        if allow_signal_abort and CommandsWaiting() ~= 0 then
            Trace("ABORT -- attack wave override\n")
        end
        --xxx

        if allow_signal_abort and CommandsWaiting() ~= 0 then break end

        while not(allow_signal_abort and CommandsWaiting() ~= 0) do

            FormGroup(5,true)
            if sleep_seconds <= 0 then break end
            TraceI("waiting %d seconds before suicide\n",sleep_seconds) --xxx
        end

        if standard then
            if bldgs then
                if SuicidePlayer(p,sleep_seconds >= -60) then break end
            else
                if SuicidePlayerUnits(p,sleep_seconds >= -60) then break end
            end
        else
            AttackMoveXYA(x,y)
        end

        TraceI("waiting %d seconds before timeout\n",60+sleep_seconds) --xxx
        SuicideSleep(5)
    end

    campaign_wood_peons = save_peons
    harass_length = 0

    SuicideOnPlayerWave()
end

----------------------------------------------------------------------------------------------------
---@param seconds integer
---@param p player
function SuicideOnPlayer(seconds, p)
    CommonSuicideOnPlayer(true,true,seconds,p,0,0)
end

----------------------------------------------------------------------------------------------------
---@param seconds integer
---@param p player
function SuicideOnUnits(seconds, p)
    CommonSuicideOnPlayer(true,false,seconds,p,0,0)
end

----------------------------------------------------------------------------------------------------
---@param seconds integer
---@param p player
---@param x integer
---@param y integer
function SuicideOnPoint(seconds, p, x, y)
    CommonSuicideOnPlayer(false,false,seconds,p,x,y)
end

--============================================================================
---@param seconds integer
---@param p player
function SuicideUntilSignal(seconds, p)
    local save = nil ---@type integer
    local wave_prep  = PrepTime() ---@type integer

    while true do
        AddSleepSeconds(seconds)
        if sleep_seconds-wave_prep > 0 then
            SuicideSleep(sleep_seconds-wave_prep)
        end

        save = campaign_wood_peons
        campaign_wood_peons = 0
        while true do
            repeat
                FormGroup(5, true)
                if sleep_seconds <= 0 then break end
            until CommandsWaiting() ~= 0
            if SuicidePlayer(p,sleep_seconds >= -60) then break end
            if CommandsWaiting() ~= 0 then break end
            SuicideSleep(3)
        end
        campaign_wood_peons = save

        while not(CaptainIsEmpty()) do
            if CommandsWaiting() ~= 0 then break end
            SuicideSleep(5)
        end
        if CommandsWaiting() ~= 0 then break end
    end
end

----------------------------------------------------------------------------------------------------
---@param easy integer
---@param med integer
---@param hard integer
---@param unitid integer
function SuicideOnce(easy, med, hard, unitid)
    if difficulty == EASY then
        SuicideUnit(easy,unitid)
    elseif difficulty == NORMAL then
        SuicideUnit(med,unitid)
    else
        SuicideUnit(hard,unitid)
    end
end

----------------------------------------------------------------------------------------------------
---@param unitid integer
function SuicideUnitA(unitid)
    if unitid ~= 0 then
        SuicideUnit(1,unitid)
    end
    Sleep(0.1)
end

----------------------------------------------------------------------------------------------------
---@param unitid integer
---@param playerid integer
function SuicideUnitB(unitid, playerid)
    if unitid ~= 0 then
        SuicideUnitEx(1,unitid,playerid)
    end
    Sleep(0.1)
end

----------------------------------------------------------------------------------------------------
---@param u1 integer
---@param u2 integer
---@param u3 integer
---@param u4 integer
---@param u5 integer
---@param u6 integer
---@param u7 integer
---@param u8 integer
---@param u9 integer
---@param uA integer
function SuicideUnits(u1, u2, u3, u4, u5, u6, u7, u8, u9, uA)
    Trace("MASS SUICIDE - self script is now technically done\n") --xxx

    PrepFullSuicide()
    while true do
        SuicideUnitA(u1)
        SuicideUnitA(u2)
        SuicideUnitA(u3)
        SuicideUnitA(u4)
        SuicideUnitA(u5)
        SuicideUnitA(u6)
        SuicideUnitA(u7)
        SuicideUnitA(u8)
        SuicideUnitA(u9)
        SuicideUnitA(uA)
    end
end

----------------------------------------------------------------------------------------------------
---@param playerid integer
---@param u1 integer
---@param u2 integer
---@param u3 integer
---@param u4 integer
---@param u5 integer
---@param u6 integer
---@param u7 integer
---@param u8 integer
---@param u9 integer
---@param uA integer
function SuicideUnitsEx(playerid, u1, u2, u3, u4, u5, u6, u7, u8, u9, uA)
    Trace("MASS SUICIDE - self script is now technically done\n") --xxx

    PrepFullSuicide()
    while true do
        SuicideUnitB(u1,playerid)
        SuicideUnitB(u2,playerid)
        SuicideUnitB(u3,playerid)
        SuicideUnitB(u4,playerid)
        SuicideUnitB(u5,playerid)
        SuicideUnitB(u6,playerid)
        SuicideUnitB(u7,playerid)
        SuicideUnitB(u8,playerid)
        SuicideUnitB(u9,playerid)
        SuicideUnitB(uA,playerid)
    end
end

----------------------------------------------------------------------------------------------------
---@param easy integer
---@param med integer
---@param hard integer
---@param p player
function SuicideOnPlayerEx(easy, med, hard, p)
    if difficulty == EASY then
        SuicideOnPlayer(easy,p)
    elseif difficulty == NORMAL then
        SuicideOnPlayer(med,p)
    else
        SuicideOnPlayer(hard,p)
    end
end

----------------------------------------------------------------------------------------------------
---@param easy integer
---@param med integer
---@param hard integer
---@param p player
function SuicideOnUnitsEx(easy, med, hard, p)
    if difficulty == EASY then
        SuicideOnUnits(easy,p)
    elseif difficulty == NORMAL then
        SuicideOnUnits(med,p)
    else
        SuicideOnUnits(hard,p)
    end
end

----------------------------------------------------------------------------------------------------
---@param easy integer
---@param med integer
---@param hard integer
---@param p player
---@param x integer
---@param y integer
function SuicideOnPointEx(easy, med, hard, p, x, y)
    if difficulty == EASY then
        SuicideOnPoint(easy,p,x,y)
    elseif difficulty == NORMAL then
        SuicideOnPoint(med,p,x,y)
    else
        SuicideOnPoint(hard,p,x,y)
    end
end

--============================================================================
---@param seconds integer
---@param p player
function ForeverSuicideOnPlayer(seconds, p)
    local length  = harass_length ---@type integer
    while not(allow_signal_abort and CommandsWaiting() ~= 0) do
        SuicideOnPlayer(seconds,p)
        harass_length = length
    end
end

--============================================================================
---@param target unit
---@param reform boolean
function CommonSleepUntilTargetDead(target, reform)
    while not(CaptainRetreating()) do
        if CaptainReadinessHP() <= 40 then break end

        if not UnitAlive(target) then break end
        if UnitInvis(target) and not IsUnitDetected(target,ai_player) then break end

        if not TownThreatened() then
            AttackMoveKill(target)
        end

        SuicideSleep(3)

        if reform and sleep_seconds < -40 then
            if CaptainInCombat(true) then
                sleep_seconds = sleep_seconds + 5
            else
                sleep_seconds = 0
                FormGroup(1,false)
            end
        end
    end
end

--============================================================================
---@param target unit
function SleepUntilTargetDead(target)
    CommonSleepUntilTargetDead(target,false)
end

--============================================================================
---@param target unit
function ReformUntilTargetDead(target)
    -- Trace("ReformUntilTargetDead\n")
    CommonSleepUntilTargetDead(target,true)
end

--============================================================================
---@param target unit
function AttackMoveKillA(target)
    if target == nil then
        SuicideSleep(3)
        return
    end

    -- Trace("AttackMoveKillA\n")
    AttackMoveKill(target)
    ReformUntilTargetDead(target)
    SleepInCombat()
end

--============================================================================
function MinorCreepAttack()
    local target  = GetMinorCreep() ---@type unit
    SetAllianceTarget(target)
    FormGroup(3, true)
    AttackMoveKillA(target)
end

--============================================================================
function MajorCreepAttack()
    local target  = GetMajorCreep() ---@type unit
    SetAllianceTarget(target)
    FormGroup(3,true)
    AttackMoveKillA(target)
end

--============================================================================
function CreepAttackEx()
    local target  = GetCreepCamp(min_creeps,max_creeps,allow_air_creeps) ---@type unit
    SetAllianceTarget(target)
    FormGroup(3,true)
    AttackMoveKillA(target)
end

--============================================================================
function AnyPlayerAttack()
    local hall = nil ---@type unit

    hall = GetEnemyExpansion()
    if hall == nil then
        StartGetEnemyBase()
        while not(not WaitGetEnemyBase()) do
            SuicideSleep(1)
        end
        hall = GetEnemyBase()
    end

    SetAllianceTarget(hall)
    FormGroup(3,true)
    AttackMoveKillA(hall)
end

--============================================================================
function ExpansionAttack()
    local creep  = GetExpansionFoe() ---@type unit
    local x = nil ---@type integer

    FormGroup(3, true)
    if creep == nil then
        x = GetExpansionX()
        if x ~= -1 then
            AttackMoveXYA(x,GetExpansionY())
        end
    else
        AttackMoveKillA(creep)
    end
end

--============================================================================
--  AddSiege
--============================================================================
function AddSiege()
    SetAssaultGroup( 0, 9, SHADE       )
    SetAssaultGroup( 0, 9, MEAT_WAGON  )
    SetAssaultGroup( 0, 9, MORTAR      )
    SetAssaultGroup( 0, 9, TANK        )
    SetAssaultGroup( 0, 9, BALLISTA    )
    SetAssaultGroup( 0, 9, CATAPULT    )
end

--===========================================================================
--  GetAllyCount
--============================================================================
---@param whichPlayer player
---@return integer
function GetAllyCount(whichPlayer)
    local playerIndex     = 0 ---@type integer
    local count     = 0 ---@type integer
    local indexPlayer     = nil ---@type player

    repeat
        indexPlayer = Player(playerIndex)

        if whichPlayer ~= indexPlayer then
            if GetPlayerAlliance(whichPlayer,indexPlayer,ALLIANCE_PASSIVE) then
                if GetPlayerAlliance(indexPlayer,whichPlayer,ALLIANCE_PASSIVE) then
                    if GetPlayerStructureCount(indexPlayer,true) > 0 then
                        count = count + 1
                    end
                end
            end
        end

        playerIndex = playerIndex + 1
    until playerIndex == 12

    return count
end

--============================================================================
--  SingleMeleeAttack
--============================================================================
---@param needs_exp boolean
---@param has_siege boolean
---@param major_ok boolean
---@param air_units boolean
function SingleMeleeAttack(needs_exp, has_siege, major_ok, air_units)
    local can_siege   = nil ---@type boolean
    local daytime      = nil ---@type real
    local hall      = nil ---@type unit
    local mega      = nil ---@type unit
    local creep      = nil ---@type unit
    local common      = nil ---@type unit
    local minimum   = nil ---@type integer
    local allies   = nil ---@type boolean

    Trace("===SingleMeleeAttack===\n") --xxx

    if TownThreatened() then
        Trace("sleep 2, town threatened\n") --xxx
        Sleep(2)
        return
    end

    -- purchase zeppelins
    --
    if get_zeppelin and GetGold() > 300 and GetWood() > 100 then
        Trace("purchase zep\n") --xxx
        PurchaseZeppelin()
        get_zeppelin = false
        ready_for_zeppelin = false
        return
    end
    ready_for_zeppelin = true

    -- coordinate with allies
    --
    allies = GetAllyCount(ai_player) > 0
    if allies and MeleeDifficulty() ~= MELEE_NEWBIE then
        common = GetAllianceTarget()
        if common ~= nil then
            Trace("join ally force\n") --xxx
            if GetMegaTarget() ~= nil then
                AddSiege()
            end
            FormGroup(3,true)
            AttackMoveKillA(common)
            SetAllianceTarget(nil)
            return
        end
    end

    -- take expansions as needed
    --
    if needs_exp then
        Trace("needs exp\n") --xxx
        creep = GetExpansionFoe()
        if creep ~= nil then
            Trace("attack exp\n") --xxx
            SetAllianceTarget(creep)
            FormGroup(3,true)
            AttackMoveKillA(creep)
            Sleep(20)
            take_exp = false
            return
        end
    end

    -- all-out attack if the player is weak
    --
    if MeleeDifficulty() ~= MELEE_NEWBIE then
        mega = GetMegaTarget()
        if mega ~= nil then
            Trace("MEGA TARGET!!!\n") --xxx
            AddSiege()
            FormGroup(3,true)
            AttackMoveKillA(mega)
            return
        end
    end

    -- deny player an expansion
    --
    hall = GetEnemyExpansion()
    daytime = GetFloatGameState(GAME_STATE_TIME_OF_DAY)
    can_siege = has_siege and(air_units or(daytime>=4 and daytime<=12))

    if hall~=nil and(can_siege or not IsTowered(hall)) then

        Trace("test player town attack\n") --xxx

        if MeleeDifficulty() == MELEE_NEWBIE then
            minimum = 3
        elseif allies and MeleeDifficulty() == MELEE_NORMAL then
            minimum = 1
        else
            minimum = 0 -- HARD, INSANE, and NORMAL with no allies
        end

        if exp_seen >= minimum then
            Trace("do player town attack\n") --xxx
            exp_seen = 0
            AddSiege()
            SetAllianceTarget(hall)
            FormGroup(3,true)
            AttackMoveKillA(hall)
            return
        end

        exp_seen = exp_seen + 1
    end

    -- attack player's main base when siege is available
    --
    if can_siege then
        Trace("attack player's town\n") --xxx
        AddSiege()
        AnyPlayerAttack()
        return
    end

    -- extended, more specific method of determining creep levels
    --
    if min_creeps ~= -1 then
        TraceI("custom creep attack %d\n",max_creeps) --xxx
        CreepAttackEx()
        return
    end

    -- nothing better to do, so kill a creep camp
    --
    if major_ok then
        Trace("major creep attack\n") --xxx
        MajorCreepAttack()
        return
    end

    Trace("minor creep attack\n") --xxx
    MinorCreepAttack()
end

--============================================================================
function GetZeppelin()
    if ready_for_zeppelin then
        get_zeppelin = true
    end
end

--============================================================================
---@return integer
function FoodUsed()
    return GetPlayerState(ai_player,PLAYER_STATE_RESOURCE_FOOD_USED)
end

--============================================================================
---@return integer
function FoodCap()
    return GetPlayerState(ai_player,PLAYER_STATE_RESOURCE_FOOD_CAP)
end

--============================================================================
---@return integer
function FoodSpace()
    return FoodCap() - FoodUsed()
end

--============================================================================
---@param base integer
---@return integer
function FoodAvail(base)
    return GetFoodMade(racial_farm) * TownCount(racial_farm) + GetFoodMade(base) * TownCount(base)
end

--============================================================================
function BuildAttackers()
    local index  = 0 ---@type integer
    local unitid = nil ---@type integer
    local desire = nil ---@type integer
    local count = nil ---@type integer

    while not(index == harass_length) do

        unitid = harass_units[index]
        desire = harass_qty[index] + IgnoredUnits(unitid)
        count  = TownCount(unitid)

        if count ~= desire then
            if not StartUnit(desire,unitid,-1) then
                return
            end
        end

        index = index + 1
    end
end

--============================================================================
function BuildDefenders()
    local index  = 0 ---@type integer
    local unitid = nil ---@type integer
    local qty = nil ---@type integer
    while not(index == defense_length) do

        unitid = defense_units[index]
        qty = defense_qty[index]

        Conversions(qty,unitid)
        AddDefenders(qty,unitid)

        index = index + 1
    end
end

--============================================================================
function CampaignBasicsA()
    local food_each  = GetFoodMade(racial_farm) ---@type integer
    local on_wood = nil ---@type integer

    ClearHarvestAI()

    if CaptainInCombat(false) then
        on_wood = 0
    else
        on_wood = campaign_wood_peons
    end

    HarvestGold(0,campaign_gold_peons)
    HarvestWood(0,on_wood)

    if harvest_town1 then
        HarvestGold(1,campaign_gold_peons)
        HarvestWood(1,on_wood)
    end

    if harvest_town2 then
        HarvestGold(2,campaign_gold_peons)
        HarvestWood(2,on_wood)
    end

    if harvest_town3 then
        HarvestGold(3,campaign_gold_peons)
        HarvestWood(3,on_wood)
    end

    if do_campaign_farms and FoodUsed()+food_each-1 > food_each*(TownCount(racial_farm)+1) then
        StartUnit(TownCount(racial_farm)+1,racial_farm,-1)
    end

    if build_campaign_attackers then
        BuildAttackers()
    end

    if not CaptainInCombat(false) then
        BuildDefenders()
    end

    FillGuardPosts()
    ReturnGuardPosts()
end

--============================================================================
function CampaignBasics()
    Sleep(1)
    CampaignBasicsA()
    StaggerSleep(1,5)
    while true do
        CampaignBasicsA()
        Sleep(campaign_basics_speed)
    end
end

--============================================================================
---@param farms integer
---@param heroes function
function CampaignAI(farms, heroes)
    if GetGameDifficulty() == MAP_DIFFICULTY_EASY then
        difficulty = EASY

        SetTargetHeroes(false)
        SetUnitsFlee(false)

    elseif GetGameDifficulty() == MAP_DIFFICULTY_NORMAL then
        difficulty = NORMAL

        SetTargetHeroes(false)
        SetUnitsFlee(false)

    elseif GetGameDifficulty() == MAP_DIFFICULTY_HARD then
        difficulty = HARD

        SetPeonsRepair(true)
    else
        difficulty = INSANE
    end

    InitAI()
    InitBuildArray()
    InitAssaultGroup()
    CreateCaptains()

    SetNewHeroes(false)
    if heroes ~= nil then
        SetHeroLevels(heroes)
    end

    SetHeroesFlee(false)
    SetGroupsFlee(false)
    SetSlowChopping(true)
    GroupTimedLife(false)
    SetCampaignAI()
    Sleep(0.1)

    racial_farm = farms
    StartThread(CampaignBasics)
    StartBuildLoop()
end

--============================================================================
function UnsummonAll()
    local bldg = nil ---@type unit
    while true do
        bldg = GetBuilding(ai_player)
        if bldg==nil then break end
        Unsummon(bldg)
        Sleep(2)
    end
end

--============================================================================
--  SkillArrays
--============================================================================
---@return integer
function SkillArrays()
    local level  = GetHeroLevelAI() ---@type integer

    if level > max_hero_level then
        max_hero_level = level
    end

    if GetHeroId() == hero_id then
        return skills1[level]
    elseif GetHeroId() == hero_id2 then
        return skills2[level]
    else
        return skills3[level]
    end
end

----------------------------------------------------------------------------------------------------
--  SetSkillArray
----------------------------------------------------------------------------------------------------
---@param index integer
---@param id integer
function SetSkillArray(index, id)
    local i  = 1 ---@type integer

    if index == 1 then
        if hero_id ~= id then
            return
        end
        while true do
            skills1[i] = skill[i]
            if i == 10 then break end
            i = i + 1
        end
    elseif index == 2 then
        if hero_id2 ~= id then
            return
        end
        while true do
            skills2[i] = skill[i]
            if i == 10 then break end
            i = i + 1
        end
    else
        if hero_id3 ~= id then
            return
        end
        while true do
            skills3[i] = skill[i]
            if i == 10 then break end
            i = i + 1
        end
    end
end

--============================================================================
--  AwaitMeleeHeroes
--============================================================================
function AwaitMeleeHeroes()
    if GetUnitCountDone(hero_id2) > 0 then
        two_heroes = true
    end
    while not(GetUnitCountDone(hero_id)>0 and(take_exp or(not two_heroes or GetUnitCountDone(hero_id2)>0))) do
        Sleep(1)
    end
end

--============================================================================
--  PickMeleeHero
--============================================================================
---@param raceid race
---@return integer
function PickMeleeHero(raceid)
    local first = nil ---@type integer
    local second = nil ---@type integer
    local third = nil ---@type integer
    local last = nil ---@type integer
    local heroes = {} ---@type integer[]

    --------------------------------------------------------------------------
    if raceid == RACE_HUMAN then
    --------------------------------------------------------------------------
        heroes[1] = ARCHMAGE
        heroes[2] = MTN_KING
        heroes[3] = PALADIN
        heroes[4] = BLOOD_MAGE

    --------------------------------------------------------------------------
    elseif raceid == RACE_ORC then
    --------------------------------------------------------------------------
        heroes[1] = BLADE_MASTER
        heroes[2] = FAR_SEER
        heroes[3] = TAUREN_CHIEF
        heroes[4] = SHADOW_HUNTER

    --------------------------------------------------------------------------
    elseif raceid == RACE_NIGHTELF then
    --------------------------------------------------------------------------
        heroes[1] = DEMON_HUNTER
        heroes[2] = KEEPER
        heroes[3] = MOON_BABE
        heroes[4] = WARDEN

    --------------------------------------------------------------------------
    elseif raceid == RACE_UNDEAD then
    --------------------------------------------------------------------------
        heroes[1] = DEATH_KNIGHT
        heroes[2] = DREAD_LORD
        heroes[3] = LICH
        heroes[4] = CRYPT_LORD
    else
        hero_id = 0
    end

    if VersionCompatible(VERSION_FROZEN_THRONE) then
        last = 4
    else
        last = 3
    end

    first  = GetRandomInt(1,last)
    second = GetRandomInt(1,last-1)
    third  = GetRandomInt(1,last-2)

    hero_id        = heroes[first]
    heroes[first]  = heroes[last]
    hero_id2       = heroes[second]
    heroes[second] = heroes[last-1]
    hero_id3       = heroes[third]

    return hero_id
end

--============================================================================
--  ADVANCED UTILITY
--============================================================================
---@param x1 real
---@param y1 real
---@param x2 real
---@param y2 real
---@return real
function AdvDistance(x1, y1, x2, y2)
    return SquareRoot(((x2 - x1) *(x2 - x1)) +((y2 - y1) *(y2 - y1)))
end

---@param u unit
---@return boolean
function AdvIsUnitAlive(u)
    return GetUnitState(u, UNIT_STATE_LIFE) > 0.0
end

---@param message string
function AdvDebugDisplayToPlayer(message)
    if debug then
        DisplayTextToPlayer(debug_player, 0, 0, message)
    end
    Trace(message)
end

--============================================================================
--  ADVANCED SETTINGS
--============================================================================
---@param debugPlayer player
---@param flag boolean
function AdvSetDebug(debugPlayer, flag)
    debug_player = debugPlayer
    debug = flag
end

--============================================================================

---@param seconds integer
function AdvSetWaveReachGoalTimeoutSeconds(seconds)
    wave_reach_goal_timeout_seconds = seconds
end

---@param seconds integer
function AdvSetWaveEnterCombatTimeoutSeconds(seconds)
    wave_enter_combat_timeout_seconds = seconds
end

---@param seconds integer
function AdvSetWaveClearGoalTimeoutSeconds(seconds)
    wave_clear_goal_timeout_seconds = seconds
end

--============================================================================

---@param radius real
function AdvSetContinueFarAwayRadius(radius)
    continue_far_away_radius = radius
end

---@param radius real
function AdvSetPreferredLocationsRadius(radius)
    preferred_locations_radius = radius
end

--============================================================================

---@param flag boolean
function AdvSetWoodPeonsWarriors(flag)
    wood_peons_warriors = flag
end

--============================================================================

---@param flag boolean
function AdvSetSearchPreferredLocations(flag)
    search_preferred_locations = flag
end

---@param flag boolean
function AdvSetSearchEverywhere(flag)
    search_everywhere = flag
end

---@param flag boolean
function AdvSetCanSearchUnit(flag)
    can_search_units = flag
end

---@param flag boolean
function AdvSetCanSearchInvulnerable(flag)
    can_search_invulnerable = flag
end

--============================================================================

---@param flag boolean
function AdvSetPrioritizeTownHalls(flag)
    prioritize_town_halls = flag
end

---@param flag boolean
function AdvSetPrioritizeNearest(flag)
    prioritize_nearest = flag
end

---@param value integer
function AdvSetSearchTargetMaxCyclesDefault(value)
    search_target_max_cycles_default = value
end

---@param value integer
function AdvSetSearchTargetMaxCyclesLastTarget(value)
    search_target_max_cycles_last_target = value
end

--============================================================================

---@param flag boolean
function AdvSetUseReachGoalTimeout(flag)
    reach_goal_timeout = flag
end

---@param flag boolean
function AdvSetUseEnterCombatTimeout(flag)
    reach_goal_timeout = flag
end

---@param flag boolean
function AdvSetUseClearGoalTimeout(flag)
    enter_combat_timeout = flag
end

--============================================================================

---@param percentage integer
function AdvSetContinueAttackPercentage(percentage)
    continue_attack_percentage = percentage
end

---@param flag boolean
function AdvSetContinueAttackReducePercentageIfFarAway(flag)
    continue_attack_reduce_percentage_if_far_away = flag
end

---@param percentage integer
function AdvSetContinueAttackReducePercentage(percentage)
    continue_attack_reduce_percentage = percentage
end

--============================================================================

---@param x real
---@param y real
function AdvSetAttackWaveGatherReturnXY(x, y)
    attack_wave_gather_return_x = x
    attack_wave_gather_return_y = y
    attack_wave_gather_return_set = true
end

---@param x real
---@param y real
function AdvSetDefenseCaptainHomeXY(x, y)
    defense_captain_home_x = x
    defense_captain_home_y = y
    defense_captain_home_set = true

end

-- Note: self should never be called in the script with argument different from DEFENSE_CAPTAIN
---@param whichCaptain integer
function AdvSetCaptainHome(whichCaptain)

    if whichCaptain == BOTH_CAPTAINS then
    
        if defense_captain_home_set then
            SetCaptainHome(DEFENSE_CAPTAIN, defense_captain_home_x, defense_captain_home_y)
        end
        
        if attack_wave_gather_return_set then
            SetCaptainHome(ATTACK_CAPTAIN, attack_wave_gather_return_x, attack_wave_gather_return_y)
        end
        
        return
        
    end

    if defense_captain_home_set and whichCaptain == DEFENSE_CAPTAIN then
    
        SetCaptainHome(DEFENSE_CAPTAIN, defense_captain_home_x, defense_captain_home_y)
        return
        
    end
    
    if attack_wave_gather_return_set and whichCaptain == ATTACK_CAPTAIN then
    
        SetCaptainHome(ATTACK_CAPTAIN, attack_wave_gather_return_x, attack_wave_gather_return_y)
        return
        
    end
        
end

--============================================================================

---@param x real
---@param y real
---@return integer
function AdvAddPreferredLocation(x, y)
    preferred_locations[preferred_locations_count] = Location(x, y)
    preferred_locations_count = preferred_locations_count + 1
    
    return preferred_locations_count
end

---@param index integer
---@param x real
---@param y real
function AdvSetPreferredLocationXY(index, x, y)
    if index < preferred_locations_count then
        preferred_locations[index] = Location(x, y)
    end
end

--============================================================================

---@param flag boolean
function AdvSetSuicide(flag)
    suicide = flag
end

--============================================================================
-- ADVANCED SUICIDE WAVE LAUNCH
--============================================================================
---@return unit
function AdvGetRandomTargetableTownHall()
    local randomIndex  = GetRandomInt(0, targetable_town_halls_count - 1) ---@type integer
    
    if targetable_town_halls_count <= 0 then
        return nil
    end

    return targetable_town_halls[randomIndex]
end

---@param x real
---@param y real
---@return unit
function AdvGetNearestTargetableTownHall(x, y)
    local index  = 0 ---@type integer
    local minDistanceIndex  = 0 ---@type integer
    local minDistance = nil ---@type real
    
    if targetable_town_halls_count <= 0 then
        return nil
    end
    
    minDistance = AdvDistance(GetUnitX(targetable_town_halls[minDistanceIndex]), GetUnitY(targetable_town_halls[minDistanceIndex]), x, y)
        
    while true do
    
        index = index + 1            
        if index >= targetable_town_halls_count then break end
        
        if AdvDistance(GetUnitX(targetable_town_halls[index]), GetUnitY(targetable_town_halls[index]), x, y) < minDistance then
            minDistanceIndex = index
            minDistance = AdvDistance(GetUnitX(targetable_town_halls[minDistanceIndex]), GetUnitY(targetable_town_halls[minDistanceIndex]), x, y)
        end
        
    end
    
    return targetable_town_halls[minDistanceIndex]
    
end

--============================================================================

---@return unit
function AdvGetRandomTargetableBuilding()
    local randomIndex  = GetRandomInt(0, targetable_buildings_count - 1) ---@type integer
    
    if targetable_buildings_count <= 0 then
        return nil
    end

    return targetable_buildings[randomIndex]
end

---@param x real
---@param y real
---@return unit
function AdvGetNearestTargetableBuilding(x, y)
    local index  = 0 ---@type integer
    local minDistanceIndex  = 0 ---@type integer
    local minDistance = nil ---@type real
    
    if targetable_buildings_count <= 0 then
        return nil
    end
    
    minDistance = AdvDistance(GetUnitX(targetable_buildings[minDistanceIndex]), GetUnitY(targetable_buildings[minDistanceIndex]), x, y)
        
    while true do
    
        index = index + 1
        if index >= targetable_buildings_count then break end
                
        if AdvDistance(GetUnitX(targetable_buildings[index]), GetUnitY(targetable_buildings[index]), x, y) < minDistance then
            minDistanceIndex = index
            minDistance = AdvDistance(GetUnitX(targetable_buildings[minDistanceIndex]), GetUnitY(targetable_buildings[minDistanceIndex]), x, y)
        end
        
    end
    
    return targetable_buildings[minDistanceIndex]
    
end

--============================================================================

---@return unit
function AdvGetRandomTargetableUnit()
    local randomIndex  = GetRandomInt(0, targetable_units_count - 1) ---@type integer
    
    if targetable_units_count <= 0 then
        return nil
    end

    return targetable_units[randomIndex]
end

---@param x real
---@param y real
---@return unit
function AdvGetNearestTargetableUnit(x, y)
    local index  = 0 ---@type integer
    local minDistanceIndex  = 0 ---@type integer
    local minDistance = nil ---@type real
    
    if targetable_units_count <= 0 then
        return nil
    end
    
    minDistance = AdvDistance(GetUnitX(targetable_units[minDistanceIndex]), GetUnitY(targetable_units[minDistanceIndex]), x, y)
        
    while true do
    
        index = index + 1
        if index >= targetable_units_count then break end
                
        if AdvDistance(GetUnitX(targetable_units[index]), GetUnitY(targetable_units[index]), x, y) < minDistance then
            minDistanceIndex = index
            minDistance = AdvDistance(GetUnitX(targetable_units[minDistanceIndex]), GetUnitY(targetable_units[minDistanceIndex]), x, y)
        end
        
    end
    
    return targetable_units[minDistanceIndex]
    
end

--============================================================================

---@param targetPlayer player
---@param preferredLocations boolean
---@return boolean
function AdvAssignTargetableTownHalls(targetPlayer, preferredLocations)
    local currentUnit  = nil ---@type unit
    local targetsGroup  = CreateGroup() ---@type group 
    local tempGroup  = CreateGroup() ---@type group 
    local index  = 0 ---@type integer
    
    targetable_town_halls_count = 0
        
    if preferredLocations then
        repeat
            GroupEnumUnitsInRangeOfLoc(tempGroup, preferred_locations_current[index], preferred_locations_radius, nil)         
            BlzGroupAddGroupFast(tempGroup, targetsGroup)
            
            index = index + 1        
            GroupClear(tempGroup)
            
        until index >= preferred_locations_count_current
    else
        GroupEnumUnitsOfPlayer(targetsGroup, targetPlayer, nil) 
    end
    
    if BlzGroupGetSize(targetsGroup) <= 0 then
        return false
    end
    
    while true do
    
        currentUnit = FirstOfGroup(targetsGroup)
        
        if currentUnit == nil then break end
        
        if GetOwningPlayer(currentUnit) == targetPlayer and IsUnitType(currentUnit, UNIT_TYPE_TOWNHALL) and IsUnitType(currentUnit, UNIT_TYPE_STRUCTURE) and AdvIsUnitAlive(currentUnit) then            
            if not can_search_invulnerable then
                if not BlzIsUnitInvulnerable(currentUnit) then
                    targetable_town_halls[targetable_town_halls_count] = currentUnit
                    targetable_town_halls_count = targetable_town_halls_count + 1
                end
            else
                targetable_town_halls[targetable_town_halls_count] = currentUnit
                targetable_town_halls_count = targetable_town_halls_count + 1
            end
        end
        
        GroupRemoveUnit(targetsGroup, currentUnit)
    
    end
    
    if targetable_town_halls_count > 0 then
        return true
    end
    
    return false
    
end

--============================================================================

---@param targetPlayer player
---@param preferredLocations boolean
---@return boolean
function AdvAssignTargetableBuildings(targetPlayer, preferredLocations)
    local currentUnit  = nil ---@type unit
    local targetsGroup  = CreateGroup() ---@type group 
    local tempGroup  = CreateGroup() ---@type group 
    local index  = 0 ---@type integer
    
    targetable_buildings_count = 0
    
    if preferredLocations then
        repeat
            GroupEnumUnitsInRangeOfLoc(tempGroup, preferred_locations_current[index], preferred_locations_radius, nil)         
            BlzGroupAddGroupFast(tempGroup, targetsGroup)
            
            index = index + 1        
            GroupClear(tempGroup)
            
        until index >= preferred_locations_count_current
    else
        GroupEnumUnitsOfPlayer(targetsGroup, targetPlayer, nil) 
    end
    
    if BlzGroupGetSize(targetsGroup) <= 0 then
        return false
    end
    
    while true do
    
        currentUnit = FirstOfGroup(targetsGroup)
        
        if currentUnit == nil then break end
        
        if GetOwningPlayer(currentUnit) == targetPlayer and IsUnitType(currentUnit, UNIT_TYPE_STRUCTURE) and AdvIsUnitAlive(currentUnit) then        
            if not can_search_invulnerable then
                if not BlzIsUnitInvulnerable(currentUnit) then
                    targetable_buildings[targetable_buildings_count] = currentUnit
                    targetable_buildings_count = targetable_buildings_count + 1    
                end
            else
                targetable_buildings[targetable_buildings_count] = currentUnit
                targetable_buildings_count = targetable_buildings_count + 1    
            end
        end
        
        GroupRemoveUnit(targetsGroup, currentUnit)
    
    end
    
    if targetable_buildings_count > 0 then
        return true
    end
    
    return false
    
end

--============================================================================

---@param targetPlayer player
---@param preferredLocations boolean
---@return boolean
function AdvAssignTargetableUnits(targetPlayer, preferredLocations)
    local currentUnit  = nil ---@type unit
    local targetsGroup  = CreateGroup() ---@type group 
    local tempGroup  = CreateGroup() ---@type group 
    local index  = 0 ---@type integer
    
    targetable_units_count = 0
    
    if preferredLocations then
        repeat
            GroupEnumUnitsInRangeOfLoc(tempGroup, preferred_locations_current[index], preferred_locations_radius, nil)         
            BlzGroupAddGroupFast(tempGroup, targetsGroup)
            
            index = index + 1        
            GroupClear(tempGroup)
            
        until index >= preferred_locations_count_current
    else
        GroupEnumUnitsOfPlayer(targetsGroup, targetPlayer, nil) 
    end
    
    if BlzGroupGetSize(targetsGroup) <= 0 then
        return false
    end
    
    while true do
    
        currentUnit = FirstOfGroup(targetsGroup)
        
        if currentUnit == nil then break end
        
        if GetOwningPlayer(currentUnit) == targetPlayer and AdvIsUnitAlive(currentUnit) then
            if not can_search_invulnerable then
                if not BlzIsUnitInvulnerable(currentUnit) then
                    targetable_units[targetable_units_count] = currentUnit
                    targetable_units_count = targetable_units_count + 1    
                end
            else
                targetable_units[targetable_units_count] = currentUnit
                targetable_units_count = targetable_units_count + 1    
            end
        end
        
        GroupRemoveUnit(targetsGroup, currentUnit)
    
    end
    
    if targetable_units_count > 0 then
        return true
    end
    
    return false
    
end

--============================================================================

---@param targetPlayer player
---@param startX real
---@param startY real
---@param searchPreferredLocations boolean
---@param searchEverywhere boolean
---@param canSearchUnits boolean
---@param prioritizeTownHalls boolean
---@param prioritizeNearest boolean
---@param useLastTarget boolean
---@return boolean
function AdvSuicideWaveLaunch(targetPlayer, startX, startY, searchPreferredLocations, searchEverywhere, canSearchUnits, prioritizeTownHalls, prioritizeNearest, useLastTarget)
    local target  = nil ---@type unit
    local index  = 0 ---@type integer
    local targetX = nil ---@type real
    local targetY = nil ---@type real
    local searchTargetCycle  = 0 ---@type integer
    
    -- Set the start coordinates
    if useLastTarget then
        startX = last_target_x
        startY = last_target_y
    end
    
    AdvDebugDisplayToPlayer("AI Info: searching for a target...")
    
    -- --- LOOP UNTIL TARGET IS FOUND OR TIMEOUT IS REACHED ---
    while not(suicide) do
    
        -- --- CACHE PREFERRED LOCATIONS ---
        preferred_locations_count_current = 0    
        if searchPreferredLocations and preferred_locations_count > 0 then
        
            preferred_locations_count_current = preferred_locations_count
            repeat
            
                preferred_locations_current[index] = preferred_locations[index]
            
                index = index + 1
            until index >= preferred_locations_count_current
            
        end
        
        -- --- TOWN HALLS PREFERRED LOCATIONS ---    
        if searchPreferredLocations and prioritizeTownHalls and preferred_locations_count_current > 0 then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target town halls at preferred locations...")
            
            if AdvAssignTargetableTownHalls(targetPlayer, true) then
                AdvDebugDisplayToPlayer("AI Info: at least one targetable town hall found!")
                
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest town hall...")
                    
                    -- Nearest town hall
                    target = AdvGetNearestTargetableTownHall(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random town hall target...")
                            
                    -- Random town hall
                    target = AdvGetRandomTargetableTownHall()
                end    
            
            end
        
            if target == nil then
                AdvDebugDisplayToPlayer("AI Info: town hall target not found!")
            else
                AdvDebugDisplayToPlayer("AI Info: town hall target found!")
            end
        
        end
        
        if target ~= nil then break end
        
        -- --- BUILDINGS PREFERRED LOCATIONS ---    
        if searchPreferredLocations and preferred_locations_count_current > 0 then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target buildings at preferred locations...")
            
            if AdvAssignTargetableBuildings(targetPlayer, true) then    
                AdvDebugDisplayToPlayer("AI Info: at least one targetable building found!")
            
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest building...")
                    
                    -- Nearest building
                    target = AdvGetNearestTargetableBuilding(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random building...")
                            
                    -- Random building
                    target = AdvGetRandomTargetableBuilding()
                end    
                
            end
                
            if target == nil then
                AdvDebugDisplayToPlayer("AI Info: building target not found!")
            else
                AdvDebugDisplayToPlayer("AI Info: building target found!")
            end
        
        end
        
        if target ~= nil then break end
    
        -- --- TOWN HALLS EVERYWHERE ----    
        if searchEverywhere and prioritizeTownHalls then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target town halls anywhere on the map...")
            
            if AdvAssignTargetableTownHalls(targetPlayer, false) then
                AdvDebugDisplayToPlayer("AI Info: at least one targetable town hall found!")
                
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest town hall...")
                    
                    -- Nearest town hall
                    target = AdvGetNearestTargetableTownHall(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random town hall target...")
                            
                    -- Random town hall
                    target = AdvGetRandomTargetableTownHall()
                end    
            
            end
        
            if target == nil then
                AdvDebugDisplayToPlayer("AI Info: town hall target not found!")
            else
                AdvDebugDisplayToPlayer("AI Info: town hall target found!")
            end
        
            
        end
        
        if target ~= nil then break end
        
        -- --- BUILDINGS EVERYWHERE ---    
        if searchEverywhere then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target buildings anywhere on the map...")
            
            if AdvAssignTargetableBuildings(targetPlayer, false) then    
                AdvDebugDisplayToPlayer("AI Info: at least one targetable building found!")
            
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest building...")
                    
                    -- Nearest building
                    target = AdvGetNearestTargetableBuilding(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random building...")
                            
                    -- Random building
                    target = AdvGetRandomTargetableBuilding()
                end    
                
                if target == nil then
                    AdvDebugDisplayToPlayer("AI Info: building target not found!")
                else
                    AdvDebugDisplayToPlayer("AI Info: building target found!")
                end
                
            end
            
        end
        
        if target ~= nil then break end
        
        -- --- UNITS PREFERRED LOCATIONS ---    
        if canSearchUnits and searchPreferredLocations and preferred_locations_count_current > 0 then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target units at preferred locations...")
            
            if AdvAssignTargetableUnits(targetPlayer, true) then    
                AdvDebugDisplayToPlayer("AI Info: at least one targetable unit found!")
            
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest unit...")
                    
                    -- Nearest unit
                    target = AdvGetNearestTargetableUnit(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random unit...")
                            
                    -- Random unit
                    target = AdvGetRandomTargetableUnit()
                end    
                
            end
                
            if target == nil then
                AdvDebugDisplayToPlayer("AI Info: unit target not found!")
            else
                AdvDebugDisplayToPlayer("AI Info: unit target found!")
            end
        
        end
        
        if target ~= nil then break end
        
        -- --- UNITS EVERYWHERE ---    
        if canSearchUnits and searchEverywhere then
        
            AdvDebugDisplayToPlayer("AI Info: looking for target units anywhere on the map...")
            
            if AdvAssignTargetableUnits(targetPlayer, false) then    
                AdvDebugDisplayToPlayer("AI Info: at least one targetable unit found!")
            
                if prioritizeNearest then
                    AdvDebugDisplayToPlayer("AI Info: looking for the nearest unit...")
                    
                    -- Nearest unit
                    target = AdvGetNearestTargetableUnit(startX, startY)
                
                else
                    AdvDebugDisplayToPlayer("AI Info: looking for a random unit...")
                            
                    -- Random unit
                    target = AdvGetRandomTargetableUnit()
                end    
                
                if target == nil then
                    AdvDebugDisplayToPlayer("AI Info: unit target not found!")
                else
                    AdvDebugDisplayToPlayer("AI Info: unit target found!")
                end
                
            end
            
        end
        
        if target ~= nil     then break end
        
        Sleep(5)
        searchTargetCycle = searchTargetCycle + 1
        
        -- When using the last target as start point, we are continuing the attack, so cycle less times(a negative value means to cycle forever)
        if search_target_max_cycles_last_target > -1 then
            if useLastTarget and searchTargetCycle > search_target_max_cycles_last_target then break end
        end
        
        -- Cycles timeout(a negative value means to cycle forever)
        if search_target_max_cycles_default > -1 then
            if searchTargetCycle > search_target_max_cycles_default then break end
        end
        
        AdvDebugDisplayToPlayer("AI Info: no target found, trying again...")
        
    end
    
    -- --- LAUNCH ATTACK IF THERE IS A TARGET---
    
    if target ~= nil then
    
        AdvDebugDisplayToPlayer("AI Info: assigning target coordinates and launching attack!")
        
        targetX = GetUnitX(target)
        targetY = GetUnitY(target)
        
        -- Send the captain to attack and store last targets
        last_target_x = targetX
        last_target_y = targetY
        SetCaptainHome(ATTACK_CAPTAIN, targetX,  targetY)
        CaptainAttack(targetX, targetY)
        
        if not suicide then
            Sleep(5)
        end
        
        -- Target found
        return true
        
    end
    
    AdvDebugDisplayToPlayer("AI Info: no target found, done trying!")
    
    -- No target found
    return false

end

--============================================================================
-- ADVANCED SUICIDE WAVE ROUTINE
--============================================================================
---@param seconds integer
function AdvWaveReachGoalSleep(seconds)

    -- Decrease counter seconds to reach the goal
    wave_reach_goal_sleep_seconds = wave_reach_goal_sleep_seconds - seconds
    
    -- Wait with precision
    while not(seconds <= 0) do
        if suicide then break end

        if seconds >= 5 then
            Sleep(5)
            seconds = seconds - 5
        else
            Sleep(seconds)
            seconds = 0
        end
        
    end
    
end

---@param seconds integer
function AdvWaveEnterCombatSleep(seconds)

    -- Decrease counter seconds to enter combat
    wave_enter_combat_sleep_seconds = wave_enter_combat_sleep_seconds - seconds
    
    -- Wait with precision
    while not(seconds <= 0) do
        if suicide then break end

        if seconds >= 5 then
            Sleep(5)
            seconds = seconds - 5
        else
            Sleep(seconds)
            seconds = 0
        end
        
    end
    
end

---@param seconds integer
function AdvWaveClearGoalSleep(seconds)

    -- Decrease counter seconds to die
    wave_clear_goal_sleep_seconds = wave_clear_goal_sleep_seconds - seconds
    
    -- Wait with precision
    while not(seconds <= 0) do
        if suicide then break end

        if seconds >= 5 then
            Sleep(5)
            seconds = seconds - 5
        else
            Sleep(seconds)
            seconds = 0
        end
        
    end
    
end

--============================================================================

---@param timeout boolean
---@return integer
function AdvSuicideWaveRoutineReachGoal(timeout)
    local goalReached  = false ---@type boolean
    local combatEntered  = false ---@type boolean
    local allDead  = false ---@type boolean
    local outOfTime  = false ---@type boolean

    while not(suicide) do
    
        -- Goal reached
        if CaptainAtGoal() then
            goalReached = true
        end
        if CaptainAtGoal() then break end
                
        -- Entered combat before reaching goal
        if CaptainInCombat(true) then
            combatEntered = true
        end
            
        -- All dead
        if CaptainIsEmpty() then
            allDead = true
        end
        if CaptainIsEmpty() then break end
            
        AdvWaveReachGoalSleep(2)
            
        -- Out of time
        if timeout then
            if wave_reach_goal_sleep_seconds < -wave_reach_goal_timeout_seconds then
                outOfTime = true
            end
            if wave_reach_goal_sleep_seconds < -wave_reach_goal_timeout_seconds then break end
        end
        
    end
    
    -- Goal is reached and fought before
    if goalReached and combatEntered then
        return 1
    -- Goal is reached and not fought before
    elseif goalReached and not combatEntered then
        return 2
    -- Attack wave is dead(no matter having fought)
    elseif allDead then
        return -1
    -- Timeout expired
    elseif outOfTime then
        return 0
    end
    
end

---@param timeout boolean
---@return integer
function AdvSuicideWaveRoutineEnterCombat(timeout)
    local combatEntered  = false ---@type boolean
    local allDead  = false ---@type boolean
    local outOfTime  = false ---@type boolean

    while not(suicide) do
    
        -- Combat
        if CaptainInCombat(true) then
            combatEntered = true
        end
        if CaptainInCombat(true) then break end
            
        -- All dead
        if CaptainIsEmpty() then
            allDead = true
        end
        if CaptainIsEmpty() then break end
            
        AdvWaveEnterCombatSleep(1)
            
        -- Out of time
        if timeout then
            if wave_reach_goal_sleep_seconds < -wave_reach_goal_timeout_seconds then
                outOfTime = true
            end
            if wave_enter_combat_sleep_seconds < -wave_enter_combat_timeout_seconds then break end
        end
        
    end
    
    -- Combat entered
    if combatEntered then
        return 1
    -- Attack wave is dead
    elseif allDead then
        return -1
    -- Timeout expired
    elseif outOfTime then
        return 0
    end
    
end

---@param timeout boolean
---@return integer
function AdvSuicideWaveRoutineClearGoal(timeout)
    local goalCleared  = false ---@type boolean
    local allDead  = false ---@type boolean
    local outOfTime  = false ---@type boolean

    while not(suicide) do

        -- Goal cleared
        if not CaptainInCombat(true) then
            goalCleared = true
        end
        if not CaptainInCombat(true) then break end
    
        -- All dead
        if CaptainIsEmpty() then
            allDead = true
        end
        if CaptainIsEmpty() then break end
        
        AdvWaveClearGoalSleep(2)
        
        -- Out of time
        if timeout then
            if wave_reach_goal_sleep_seconds < -wave_reach_goal_timeout_seconds then
                outOfTime = true
            end
            if wave_clear_goal_sleep_seconds < -wave_clear_goal_timeout_seconds then break end
        end
        
    end
    
    -- Goal cleared
    if goalCleared then
        return 1
    -- Attack wave is dead
    elseif allDead then
        return -1
    -- Timeout expired
    elseif outOfTime then
        return 0
    end
    
end

--============================================================================

---@param targetPlayer player
---@param startX real
---@param startY real
---@param reachGoalTimeout boolean
---@param enterCombatTimeout boolean
---@param clearGoalTimeout boolean
---@param continuePercentage integer
function AdvSuicideWaveRoutine(targetPlayer, startX, startY, reachGoalTimeout, enterCombatTimeout, clearGoalTimeout, continuePercentage)
    local continuePercentageNew  = continuePercentage ---@type integer
    local previousTargetX  = last_target_x ---@type real
    local previousTargetY  = last_target_y ---@type real
    local state  = 0 ---@type integer
    local combatEnteredBeforeGoal  = false ---@type boolean
    local goalReached  = false ---@type boolean
    local combatEntered  = false ---@type boolean
    local goalCleared  = false ---@type boolean
    local continueAttackReducePercentageIfFarAway  = continue_attack_reduce_percentage_if_far_away ---@type boolean
    local newTargetFound  = false ---@type boolean
    
    -- Reset all timeout seconds
    wave_reach_goal_sleep_seconds = 0
    wave_enter_combat_sleep_seconds = 0
    wave_clear_goal_sleep_seconds = 0
    
    AdvDebugDisplayToPlayer("AI Info: waiting for attack wave to reach goal...")

    -- --- WAIT TO REACH GOAL(OR DIE) ---
    state = AdvSuicideWaveRoutineReachGoal(reachGoalTimeout)
    
    -- Timeout
    if state == 0 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave goal reached timeout!")
    
        goalReached = false
        combatEnteredBeforeGoal = false
        
    -- Dead
    elseif state == -1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave dead!")
    
        goalReached = false
        combatEnteredBeforeGoal = false
        
    -- Goal reached after figthing
    elseif state == 1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave goal reached after figthing!")
    
        goalReached = true
        combatEnteredBeforeGoal = true
        
    -- Goal reached before figthing
    elseif state == 2 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave goal reached before figthing!")
    
        goalReached = true
        combatEnteredBeforeGoal = false
        
    end
    
    AdvDebugDisplayToPlayer("AI Info: waiting for attack wave to enter combat...")

    -- --- WAIT TO ENTER COMBAT(OR DIE) ---
    state = AdvSuicideWaveRoutineEnterCombat(enterCombatTimeout)
    
    -- Timeout
    if state == 0 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave enter combat reached timeout!")
    
        combatEntered = false
        
    -- Dead
    elseif state == -1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave dead!")
    
        combatEntered = true
        
    -- Combat entered
    elseif state == 1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave combat entered!")
    
        combatEntered = true
        
    end
    
    AdvDebugDisplayToPlayer("AI Info: waiting for attack wave to clear goal...")

    -- --- WAIT TO CLEAR GOAL(OR DIE) ---
    state = AdvSuicideWaveRoutineClearGoal(clearGoalTimeout)
    
    -- Timeout
    if state == 0 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave clear goal reached timeout!")
    
        combatEntered = false
        
    -- Dead
    elseif state == -1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave dead!")
    
        combatEntered = true
        
    -- Goal cleared
    elseif state == 1 then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave goal cleared!")
    
        goalCleared = true
        
    end

    -- --- GROUP DEAD ---
    if CaptainIsEmpty() then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave dead, going back home...")
        
        SetCaptainHome(ATTACK_CAPTAIN, startX,  startY)
        CaptainAttack(startX, startY)
        
        if not suicide then
            Sleep(1)
        end
        
        TeleportCaptain(startX, startY)
        
        -- Wait for the captain to go back home
        
        repeat
        
            Sleep(1)
            
            if suicide then break end
        until CaptainAtGoal()
        
        AdvDebugDisplayToPlayer("AI Info: returned home!")
        
        ClearCaptainTargets()
        ResetCaptainLocs()
        AdvSetCaptainHome(BOTH_CAPTAINS)
        
        if not suicide then
            Sleep(2)
        end
        
        return
        
    end
    
    -- --- ATTACK FINISHED CONTINUE(IF REQUIRED) ---
    AdvDebugDisplayToPlayer("AI Info: attack wave finished duty, checking if  should continue...")    
    
    -- If attack wave has not fought before reaching goal and then never fought again, it must continue
    if goalReached and not combatEnteredBeforeGoal and not combatEntered then
    
        AdvDebugDisplayToPlayer("AI Info: attack wave never fought at goal nor to reach it, forcing continue...")    
    
        continuePercentage = 100
        continueAttackReducePercentageIfFarAway = false
    end

    if not suicide and not CaptainIsEmpty() and GetRandomInt(0, 100) <= continuePercentage then

        AdvDebugDisplayToPlayer("AI Info: attack wave continues to another target!")
        
        newTargetFound = AdvSuicideWaveLaunch(targetPlayer, 0.0, 0.0, false, true, can_search_units, false, true, true)
        
        if newTargetFound then
            -- If target is not close to previous one, decrease the continue percentage(if required)
            if continueAttackReducePercentageIfFarAway and AdvDistance(previousTargetX, previousTargetY, last_target_x, last_target_y) > continue_far_away_radius then
                AdvDebugDisplayToPlayer("AI Info: reducing percentage of continuing again...")
                
                continuePercentageNew = continuePercentageNew - continue_attack_reduce_percentage
            end
            
            AdvSuicideWaveRoutine(targetPlayer, startX, startY, reach_goal_timeout, enter_combat_timeout, clear_goal_timeout, continuePercentageNew)
            
            return    
        end
        
    end
    
    -- --- ATTACK FINISHED GO HOME ---
    AdvDebugDisplayToPlayer("AI Info: attack wave does not continue, going back home...")
    
    SetCaptainHome(ATTACK_CAPTAIN, startX, startY)
    CaptainAttack(startX, startY)
    
    -- Wait for the captain to go back home
    repeat
    
        Sleep(1)
        
        if suicide then break end
    until CaptainAtGoal()
    
    AdvDebugDisplayToPlayer("AI Info: returned home!")
    
    ClearCaptainTargets()
    ResetCaptainLocs()
    AdvSetCaptainHome(BOTH_CAPTAINS)
    
    if not suicide then
        Sleep(2)
    end
    
end

--============================================================================
-- ADVANCED SUICIDE ON PLAYER
--============================================================================
---@param seconds integer
---@param targetPlayer player
---@param startX real
---@param startY real
function AdvSuicideOnPlayer(seconds, targetPlayer, startX, startY)
    local woodPeons = nil ---@type integer
    local targetFound  = false ---@type boolean
    
    AdvDebugDisplayToPlayer("AI Info: waiting to attack...")
        
    -- Make sure the captain are at right spots
    ResetCaptainLocs()
    AdvSetCaptainHome(BOTH_CAPTAINS)
    
    if not suicide then
        Sleep(2)
    end

    -- Prepare attack for given seconds
    if not PrepSuicideOnPlayer(seconds) then
        return
    end
    
    AdvDebugDisplayToPlayer("AI Info: wait is over!")

    -- If necessary(e.g. undead race), save the wood peons before attack group is prepared
    if wood_peons_warriors then
        woodPeons = campaign_wood_peons
        campaign_wood_peons = 0
    end
    
    AdvDebugDisplayToPlayer("AI Info: forming group...")

    while not(suicide) do
    
        FormGroup(5, true)    
        if sleep_seconds <= 0 then break end
        
    end
    
    AdvDebugDisplayToPlayer("AI Info: group formed!")
    
    -- If necessary(e.g. undead race), reset the wood peons after attack group is ready
    if wood_peons_warriors then
        campaign_wood_peons = woodPeons
    end
    
    -- Travel to start position
    AdvDebugDisplayToPlayer("AI Info: traveling to start position...")
    
    SetCaptainHome(ATTACK_CAPTAIN, startX, startY)
    CaptainAttack(startX, startY)
    
    repeat
    
        Sleep(1)
    
        if suicide then break end
        if CaptainAtGoal()     then break end
    until CaptainIsEmpty()
    
    -- Stop here if captain is empty
    if CaptainIsEmpty() then
        return
    end
    
    AdvDebugDisplayToPlayer("AI Info: start position reached!")
    
    -- Launch the wave against a suitable target
    targetFound = AdvSuicideWaveLaunch(targetPlayer, startX, startY, search_preferred_locations, search_everywhere, can_search_units, prioritize_town_halls, prioritize_nearest, false)
        
    harass_length = 0

    -- Start the wave routine if there is a target
    if targetFound then
        AdvSuicideWaveRoutine(targetPlayer, startX, startY, reach_goal_timeout, enter_combat_timeout, clear_goal_timeout, continue_attack_percentage)
    end
    
end

--============================================================================

---@param easy integer
---@param med integer
---@param hard integer
---@param targetPlayer player
---@param startX real
---@param startY real
function AdvSuicideOnPlayerEx(easy, med, hard, targetPlayer, startX, startY)

    if difficulty == EASY then
        AdvSuicideOnPlayer(easy, targetPlayer, startX, startY)    
    elseif difficulty == NORMAL then
        AdvSuicideOnPlayer(med, targetPlayer, startX, startY)    
    else
        AdvSuicideOnPlayer(hard, targetPlayer, startX, startY)    
    end
    
end
--Conversion by vJass2Lua v0.7.0.1
]]