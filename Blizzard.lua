---@meta
--===========================================================================
-- Blizzard.j ( define Jass2 functions that need to be in every map script )
--===========================================================================

---@diagnostic disable

    -------------------------------------------------------------------------
    -- Constants
    --

    -- Misc constants
    bj_PI                                      = 3.14159 ---@type number 
    bj_E                                       = 2.71828 ---@type number 
    bj_CELLWIDTH                               = 128.0 ---@type number 
    bj_CLIFFHEIGHT                             = 128.0 ---@type number 
    bj_UNIT_FACING                             = 270.0 ---@type number 
    bj_RADTODEG                                = 180.0/bj_PI ---@type number 
    bj_DEGTORAD                                = bj_PI/180.0 ---@type number 
    bj_TEXT_DELAY_QUEST                        = 20.00 ---@type number 
    bj_TEXT_DELAY_QUESTUPDATE                  = 20.00 ---@type number 
    bj_TEXT_DELAY_QUESTDONE                    = 20.00 ---@type number 
    bj_TEXT_DELAY_QUESTFAILED                  = 20.00 ---@type number 
    bj_TEXT_DELAY_QUESTREQUIREMENT             = 20.00 ---@type number 
    bj_TEXT_DELAY_MISSIONFAILED                = 20.00 ---@type number 
    bj_TEXT_DELAY_ALWAYSHINT                   = 12.00 ---@type number 
    bj_TEXT_DELAY_HINT                         = 12.00 ---@type number 
    bj_TEXT_DELAY_SECRET                       = 10.00 ---@type number 
    bj_TEXT_DELAY_UNITACQUIRED                 = 15.00 ---@type number 
    bj_TEXT_DELAY_UNITAVAILABLE                = 10.00 ---@type number 
    bj_TEXT_DELAY_ITEMACQUIRED                 = 10.00 ---@type number 
    bj_TEXT_DELAY_WARNING                      = 12.00 ---@type number 
    bj_QUEUE_DELAY_QUEST                       =  5.00 ---@type number 
    bj_QUEUE_DELAY_HINT                        =  5.00 ---@type number 
    bj_QUEUE_DELAY_SECRET                      =  3.00 ---@type number 
    bj_HANDICAP_EASY                           = 60.00 ---@type number 
    bj_HANDICAP_NORMAL                         = 90.00 ---@type number 
    bj_HANDICAPDAMAGE_EASY                     = 50.00 ---@type number 
    bj_HANDICAPDAMAGE_NORMAL                   = 90.00 ---@type number 
    bj_HANDICAPREVIVE_NOTHARD                  = 50.00 ---@type number 
    bj_GAME_STARTED_THRESHOLD                  =  0.01 ---@type number 
    bj_WAIT_FOR_COND_MIN_INTERVAL              =  0.10 ---@type number 
    bj_POLLED_WAIT_INTERVAL                    =  0.10 ---@type number 
    bj_POLLED_WAIT_SKIP_THRESHOLD              =  2.00 ---@type number 

    -- Game constants
    bj_MAX_INVENTORY                           =  6 ---@type integer 
    bj_MAX_PLAYERS                             =  GetBJMaxPlayers() ---@type integer 
    bj_PLAYER_NEUTRAL_VICTIM                   =  GetBJPlayerNeutralVictim() ---@type integer 
    bj_PLAYER_NEUTRAL_EXTRA                    =  GetBJPlayerNeutralExtra() ---@type integer 
    bj_MAX_PLAYER_SLOTS                        =  GetBJMaxPlayerSlots() ---@type integer 
    bj_MAX_SKELETONS                           =  25 ---@type integer 
    bj_MAX_STOCK_ITEM_SLOTS                    =  11 ---@type integer 
    bj_MAX_STOCK_UNIT_SLOTS                    =  11 ---@type integer 
    bj_MAX_ITEM_LEVEL                          =  10 ---@type integer 
    
    -- Auto Save constants
    bj_MAX_CHECKPOINTS                         =  5 ---@type integer 

    -- Ideally these would be looked up from Units/MiscData.txt,
    -- but there is currently no script functionality exposed to do that
    bj_TOD_DAWN                                = 6.00 ---@type number 
    bj_TOD_DUSK                                = 18.00 ---@type number 

    -- Melee game settings:
    --   - Starting Time of Day (TOD)
    --   - Starting Gold
    --   - Starting Lumber
    --   - Starting Hero Tokens (free heroes)
    --   - Max heroes allowed per player
    --   - Max heroes allowed per hero type
    --   - Distance from start loc to search for nearby mines
    --
    bj_MELEE_STARTING_TOD                      = 8.00 ---@type number 
    bj_MELEE_STARTING_GOLD_V0                  = 750 ---@type integer 
    bj_MELEE_STARTING_GOLD_V1                  = 500 ---@type integer 
    bj_MELEE_STARTING_LUMBER_V0                = 200 ---@type integer 
    bj_MELEE_STARTING_LUMBER_V1                = 150 ---@type integer 
    bj_MELEE_STARTING_HERO_TOKENS              = 1 ---@type integer 
    bj_MELEE_HERO_LIMIT                        = 3 ---@type integer 
    bj_MELEE_HERO_TYPE_LIMIT                   = 1 ---@type integer 
    bj_MELEE_MINE_SEARCH_RADIUS                = 2000 ---@type number 
    bj_MELEE_CLEAR_UNITS_RADIUS                = 1500 ---@type number 
    bj_MELEE_CRIPPLE_TIMEOUT                   = 120.00 ---@type number 
    bj_MELEE_CRIPPLE_MSG_DURATION              = 20.00 ---@type number 
    bj_MELEE_MAX_TWINKED_HEROES_V0             = 3 ---@type integer 
    bj_MELEE_MAX_TWINKED_HEROES_V1             = 1 ---@type integer 

    -- Delay between a creep's death and the time it may drop an item.
    bj_CREEP_ITEM_DELAY                        = 0.50 ---@type number 

    -- Timing settings for Marketplace inventories.
    bj_STOCK_RESTOCK_INITIAL_DELAY             = 120 ---@type number 
    bj_STOCK_RESTOCK_INTERVAL                  = 30 ---@type number 
    bj_STOCK_MAX_ITERATIONS                    = 20 ---@type integer 

    -- Max events registered by a single "dest dies in region" event.
    bj_MAX_DEST_IN_REGION_EVENTS               = 64 ---@type integer 

    -- Camera settings
    bj_CAMERA_MIN_FARZ                         = 100 ---@type integer 
    bj_CAMERA_DEFAULT_DISTANCE                 = 1650 ---@type integer 
    bj_CAMERA_DEFAULT_FARZ                     = 5000 ---@type integer 
    bj_CAMERA_DEFAULT_AOA                      = 304 ---@type integer 
    bj_CAMERA_DEFAULT_FOV                      = 70 ---@type integer 
    bj_CAMERA_DEFAULT_ROLL                     = 0 ---@type integer 
    bj_CAMERA_DEFAULT_ROTATION                 = 90 ---@type integer 

    -- Rescue
    bj_RESCUE_PING_TIME                        = 2.00 ---@type number 

    -- Transmission behavior settings
    bj_NOTHING_SOUND_DURATION                  = 5.00 ---@type number 
    bj_TRANSMISSION_PING_TIME                  = 1.00 ---@type number 
    bj_TRANSMISSION_IND_RED                    = 255 ---@type integer 
    bj_TRANSMISSION_IND_BLUE                   = 255 ---@type integer 
    bj_TRANSMISSION_IND_GREEN                  = 255 ---@type integer 
    bj_TRANSMISSION_IND_ALPHA                  = 255 ---@type integer 
    bj_TRANSMISSION_PORT_HANGTIME              = 1.50 ---@type number 

    -- Cinematic mode settings
    bj_CINEMODE_INTERFACEFADE                  = 0.50 ---@type number 
    bj_CINEMODE_GAMESPEED                      = MAP_SPEED_NORMAL ---@type gamespeed 

    -- Cinematic mode volume levels
    bj_CINEMODE_VOLUME_UNITMOVEMENT            = 0.40 ---@type number 
    bj_CINEMODE_VOLUME_UNITSOUNDS              = 0.00 ---@type number 
    bj_CINEMODE_VOLUME_COMBAT                  = 0.40 ---@type number 
    bj_CINEMODE_VOLUME_SPELLS                  = 0.40 ---@type number 
    bj_CINEMODE_VOLUME_UI                      = 0.00 ---@type number 
    bj_CINEMODE_VOLUME_MUSIC                   = 0.55 ---@type number 
    bj_CINEMODE_VOLUME_AMBIENTSOUNDS           = 1.00 ---@type number 
    bj_CINEMODE_VOLUME_FIRE                    = 0.60 ---@type number 

    -- Speech mode volume levels
    bj_SPEECH_VOLUME_UNITMOVEMENT              = 0.25 ---@type number 
    bj_SPEECH_VOLUME_UNITSOUNDS                = 0.00 ---@type number 
    bj_SPEECH_VOLUME_COMBAT                    = 0.25 ---@type number 
    bj_SPEECH_VOLUME_SPELLS                    = 0.25 ---@type number 
    bj_SPEECH_VOLUME_UI                        = 0.00 ---@type number 
    bj_SPEECH_VOLUME_MUSIC                     = 0.55 ---@type number 
    bj_SPEECH_VOLUME_AMBIENTSOUNDS             = 1.00 ---@type number 
    bj_SPEECH_VOLUME_FIRE                      = 0.60 ---@type number 

    -- Smart pan settings
    bj_SMARTPAN_TRESHOLD_PAN                   = 500 ---@type number 
    bj_SMARTPAN_TRESHOLD_SNAP                  = 3500 ---@type number 

    -- QueuedTriggerExecute settings
    bj_MAX_QUEUED_TRIGGERS                     = 100 ---@type integer 
    bj_QUEUED_TRIGGER_TIMEOUT                  = 180.00 ---@type number 

    -- Campaign indexing constants
    bj_CAMPAIGN_INDEX_T                  = 0 ---@type integer 
    bj_CAMPAIGN_INDEX_H                  = 1 ---@type integer 
    bj_CAMPAIGN_INDEX_U                  = 2 ---@type integer 
    bj_CAMPAIGN_INDEX_O                  = 3 ---@type integer 
    bj_CAMPAIGN_INDEX_N                  = 4 ---@type integer 
    bj_CAMPAIGN_INDEX_XN                 = 5 ---@type integer 
    bj_CAMPAIGN_INDEX_XH                 = 6 ---@type integer 
    bj_CAMPAIGN_INDEX_XU                 = 7 ---@type integer 
    bj_CAMPAIGN_INDEX_XO                 = 8 ---@type integer 

    -- Campaign offset constants (for mission indexing)
    bj_CAMPAIGN_OFFSET_T                 = 0 ---@type integer 
    bj_CAMPAIGN_OFFSET_H                 = 1 ---@type integer 
    bj_CAMPAIGN_OFFSET_U                 = 2 ---@type integer 
    bj_CAMPAIGN_OFFSET_O                 = 3 ---@type integer 
    bj_CAMPAIGN_OFFSET_N                 = 4 ---@type integer 
    bj_CAMPAIGN_OFFSET_XN                = 5 ---@type integer 
    bj_CAMPAIGN_OFFSET_XH                = 6 ---@type integer 
    bj_CAMPAIGN_OFFSET_XU                = 7 ---@type integer 
    bj_CAMPAIGN_OFFSET_XO                = 8 ---@type integer 

    -- Mission indexing constants
    -- Tutorial
    bj_MISSION_INDEX_T00                 = bj_CAMPAIGN_OFFSET_T * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_T01                 = bj_CAMPAIGN_OFFSET_T * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_T02                 = bj_CAMPAIGN_OFFSET_T * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_T03                 = bj_CAMPAIGN_OFFSET_T * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_T04                 = bj_CAMPAIGN_OFFSET_T * 1000 + 4 ---@type integer 
    -- Human
    bj_MISSION_INDEX_H00                 = bj_CAMPAIGN_OFFSET_H * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_H01                 = bj_CAMPAIGN_OFFSET_H * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_H02                 = bj_CAMPAIGN_OFFSET_H * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_H03                 = bj_CAMPAIGN_OFFSET_H * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_H04                 = bj_CAMPAIGN_OFFSET_H * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_H05                 = bj_CAMPAIGN_OFFSET_H * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_H06                 = bj_CAMPAIGN_OFFSET_H * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_H07                 = bj_CAMPAIGN_OFFSET_H * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_H08                 = bj_CAMPAIGN_OFFSET_H * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_H09                 = bj_CAMPAIGN_OFFSET_H * 1000 + 9 ---@type integer 
    bj_MISSION_INDEX_H10                 = bj_CAMPAIGN_OFFSET_H * 1000 + 10 ---@type integer 
    bj_MISSION_INDEX_H11                 = bj_CAMPAIGN_OFFSET_H * 1000 + 11 ---@type integer 
    -- Undead
    bj_MISSION_INDEX_U00                 = bj_CAMPAIGN_OFFSET_U * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_U01                 = bj_CAMPAIGN_OFFSET_U * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_U02                 = bj_CAMPAIGN_OFFSET_U * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_U03                 = bj_CAMPAIGN_OFFSET_U * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_U05                 = bj_CAMPAIGN_OFFSET_U * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_U07                 = bj_CAMPAIGN_OFFSET_U * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_U08                 = bj_CAMPAIGN_OFFSET_U * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_U09                 = bj_CAMPAIGN_OFFSET_U * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_U10                 = bj_CAMPAIGN_OFFSET_U * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_U11                 = bj_CAMPAIGN_OFFSET_U * 1000 + 9 ---@type integer 
    -- Orc
    bj_MISSION_INDEX_O00                 = bj_CAMPAIGN_OFFSET_O * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_O01                 = bj_CAMPAIGN_OFFSET_O * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_O02                 = bj_CAMPAIGN_OFFSET_O * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_O03                 = bj_CAMPAIGN_OFFSET_O * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_O04                 = bj_CAMPAIGN_OFFSET_O * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_O05                 = bj_CAMPAIGN_OFFSET_O * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_O06                 = bj_CAMPAIGN_OFFSET_O * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_O07                 = bj_CAMPAIGN_OFFSET_O * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_O08                 = bj_CAMPAIGN_OFFSET_O * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_O09                 = bj_CAMPAIGN_OFFSET_O * 1000 + 9 ---@type integer 
    bj_MISSION_INDEX_O10                 = bj_CAMPAIGN_OFFSET_O * 1000 + 10 ---@type integer 
    -- Night Elf
    bj_MISSION_INDEX_N00                 = bj_CAMPAIGN_OFFSET_N * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_N01                 = bj_CAMPAIGN_OFFSET_N * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_N02                 = bj_CAMPAIGN_OFFSET_N * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_N03                 = bj_CAMPAIGN_OFFSET_N * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_N04                 = bj_CAMPAIGN_OFFSET_N * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_N05                 = bj_CAMPAIGN_OFFSET_N * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_N06                 = bj_CAMPAIGN_OFFSET_N * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_N07                 = bj_CAMPAIGN_OFFSET_N * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_N08                 = bj_CAMPAIGN_OFFSET_N * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_N09                 = bj_CAMPAIGN_OFFSET_N * 1000 + 9 ---@type integer 
    -- Expansion Night Elf
    bj_MISSION_INDEX_XN00                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_XN01                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_XN02                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_XN03                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_XN04                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_XN05                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_XN06                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_XN07                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_XN08                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_XN09                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 9 ---@type integer 
    bj_MISSION_INDEX_XN10                 = bj_CAMPAIGN_OFFSET_XN * 1000 + 10 ---@type integer 
    -- Expansion Human
    bj_MISSION_INDEX_XH00                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_XH01                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_XH02                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_XH03                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_XH04                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_XH05                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_XH06                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_XH07                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_XH08                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_XH09                 = bj_CAMPAIGN_OFFSET_XH * 1000 + 9 ---@type integer 
    -- Expansion Undead
    bj_MISSION_INDEX_XU00                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_XU01                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_XU02                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_XU03                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 3 ---@type integer 
    bj_MISSION_INDEX_XU04                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 4 ---@type integer 
    bj_MISSION_INDEX_XU05                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 5 ---@type integer 
    bj_MISSION_INDEX_XU06                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 6 ---@type integer 
    bj_MISSION_INDEX_XU07                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 7 ---@type integer 
    bj_MISSION_INDEX_XU08                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 8 ---@type integer 
    bj_MISSION_INDEX_XU09                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 9 ---@type integer 
    bj_MISSION_INDEX_XU10                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 10 ---@type integer 
    bj_MISSION_INDEX_XU11                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 11 ---@type integer 
    bj_MISSION_INDEX_XU12                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 12 ---@type integer 
    bj_MISSION_INDEX_XU13                 = bj_CAMPAIGN_OFFSET_XU * 1000 + 13 ---@type integer 

    -- Expansion Orc
    bj_MISSION_INDEX_XO00                 = bj_CAMPAIGN_OFFSET_XO * 1000 + 0 ---@type integer 
    bj_MISSION_INDEX_XO01                 = bj_CAMPAIGN_OFFSET_XO * 1000 + 1 ---@type integer 
    bj_MISSION_INDEX_XO02                 = bj_CAMPAIGN_OFFSET_XO * 1000 + 2 ---@type integer 
    bj_MISSION_INDEX_XO03                 = bj_CAMPAIGN_OFFSET_XO * 1000 + 3 ---@type integer 

    -- Cinematic indexing constants
    bj_CINEMATICINDEX_TOP                = 0 ---@type integer 
    bj_CINEMATICINDEX_HOP                = 1 ---@type integer 
    bj_CINEMATICINDEX_HED                = 2 ---@type integer 
    bj_CINEMATICINDEX_OOP                = 3 ---@type integer 
    bj_CINEMATICINDEX_OED                = 4 ---@type integer 
    bj_CINEMATICINDEX_UOP                = 5 ---@type integer 
    bj_CINEMATICINDEX_UED                = 6 ---@type integer 
    bj_CINEMATICINDEX_NOP                = 7 ---@type integer 
    bj_CINEMATICINDEX_NED                = 8 ---@type integer 
    bj_CINEMATICINDEX_XOP                = 9 ---@type integer 
    bj_CINEMATICINDEX_XED                = 10 ---@type integer 

    -- Alliance settings
    bj_ALLIANCE_UNALLIED                  = 0 ---@type integer 
    bj_ALLIANCE_UNALLIED_VISION           = 1 ---@type integer 
    bj_ALLIANCE_ALLIED                    = 2 ---@type integer 
    bj_ALLIANCE_ALLIED_VISION             = 3 ---@type integer 
    bj_ALLIANCE_ALLIED_UNITS              = 4 ---@type integer 
    bj_ALLIANCE_ALLIED_ADVUNITS           = 5 ---@type integer 
    bj_ALLIANCE_NEUTRAL                   = 6 ---@type integer 
    bj_ALLIANCE_NEUTRAL_VISION            = 7 ---@type integer 

    -- Keyboard Event Types
    bj_KEYEVENTTYPE_DEPRESS               = 0 ---@type integer 
    bj_KEYEVENTTYPE_RELEASE               = 1 ---@type integer 

    -- Keyboard Event Keys
    bj_KEYEVENTKEY_LEFT                   = 0 ---@type integer 
    bj_KEYEVENTKEY_RIGHT                  = 1 ---@type integer 
    bj_KEYEVENTKEY_DOWN                   = 2 ---@type integer 
    bj_KEYEVENTKEY_UP                     = 3 ---@type integer 

    -- Mouse Event Types
    bj_MOUSEEVENTTYPE_DOWN               = 0 ---@type integer 
    bj_MOUSEEVENTTYPE_UP                 = 1 ---@type integer 
    bj_MOUSEEVENTTYPE_MOVE               = 2 ---@type integer 

    -- Transmission timing methods
    bj_TIMETYPE_ADD                       = 0 ---@type integer 
    bj_TIMETYPE_SET                       = 1 ---@type integer 
    bj_TIMETYPE_SUB                       = 2 ---@type integer 

    -- Camera bounds adjustment methods
    bj_CAMERABOUNDS_ADJUST_ADD            = 0 ---@type integer 
    bj_CAMERABOUNDS_ADJUST_SUB            = 1 ---@type integer 

    -- Quest creation states
    bj_QUESTTYPE_REQ_DISCOVERED             = 0 ---@type integer 
    bj_QUESTTYPE_REQ_UNDISCOVERED           = 1 ---@type integer 
    bj_QUESTTYPE_OPT_DISCOVERED             = 2 ---@type integer 
    bj_QUESTTYPE_OPT_UNDISCOVERED           = 3 ---@type integer 

    -- Quest message types
    bj_QUESTMESSAGE_DISCOVERED              = 0 ---@type integer 
    bj_QUESTMESSAGE_UPDATED                 = 1 ---@type integer 
    bj_QUESTMESSAGE_COMPLETED               = 2 ---@type integer 
    bj_QUESTMESSAGE_FAILED                  = 3 ---@type integer 
    bj_QUESTMESSAGE_REQUIREMENT             = 4 ---@type integer 
    bj_QUESTMESSAGE_MISSIONFAILED           = 5 ---@type integer 
    bj_QUESTMESSAGE_ALWAYSHINT              = 6 ---@type integer 
    bj_QUESTMESSAGE_HINT                    = 7 ---@type integer 
    bj_QUESTMESSAGE_SECRET                  = 8 ---@type integer 
    bj_QUESTMESSAGE_UNITACQUIRED            = 9 ---@type integer 
    bj_QUESTMESSAGE_UNITAVAILABLE           = 10 ---@type integer 
    bj_QUESTMESSAGE_ITEMACQUIRED            = 11 ---@type integer 
    bj_QUESTMESSAGE_WARNING                 = 12 ---@type integer 

    -- Leaderboard sorting methods
    bj_SORTTYPE_SORTBYVALUE               = 0 ---@type integer 
    bj_SORTTYPE_SORTBYPLAYER              = 1 ---@type integer 
    bj_SORTTYPE_SORTBYLABEL               = 2 ---@type integer 

    -- Cinematic fade filter methods
    bj_CINEFADETYPE_FADEIN                = 0 ---@type integer 
    bj_CINEFADETYPE_FADEOUT               = 1 ---@type integer 
    bj_CINEFADETYPE_FADEOUTIN             = 2 ---@type integer 

    -- Buff removal methods
    bj_REMOVEBUFFS_POSITIVE               = 0 ---@type integer 
    bj_REMOVEBUFFS_NEGATIVE               = 1 ---@type integer 
    bj_REMOVEBUFFS_ALL                    = 2 ---@type integer 
    bj_REMOVEBUFFS_NONTLIFE               = 3 ---@type integer 

    -- Buff properties - polarity
    bj_BUFF_POLARITY_POSITIVE             = 0 ---@type integer 
    bj_BUFF_POLARITY_NEGATIVE             = 1 ---@type integer 
    bj_BUFF_POLARITY_EITHER               = 2 ---@type integer 

    -- Buff properties - resist type
    bj_BUFF_RESIST_MAGIC                  = 0 ---@type integer 
    bj_BUFF_RESIST_PHYSICAL               = 1 ---@type integer 
    bj_BUFF_RESIST_EITHER                 = 2 ---@type integer 
    bj_BUFF_RESIST_BOTH                   = 3 ---@type integer 

    -- Hero stats
    bj_HEROSTAT_STR                       = 0 ---@type integer 
    bj_HEROSTAT_AGI                       = 1 ---@type integer 
    bj_HEROSTAT_INT                       = 2 ---@type integer 

    -- Hero skill point modification methods
    bj_MODIFYMETHOD_ADD              = 0 ---@type integer 
    bj_MODIFYMETHOD_SUB              = 1 ---@type integer 
    bj_MODIFYMETHOD_SET              = 2 ---@type integer 

    -- Unit state adjustment methods (for replaced units)
    bj_UNIT_STATE_METHOD_ABSOLUTE           = 0 ---@type integer 
    bj_UNIT_STATE_METHOD_RELATIVE           = 1 ---@type integer 
    bj_UNIT_STATE_METHOD_DEFAULTS           = 2 ---@type integer 
    bj_UNIT_STATE_METHOD_MAXIMUM            = 3 ---@type integer 

    -- Gate operations
    bj_GATEOPERATION_CLOSE                = 0 ---@type integer 
    bj_GATEOPERATION_OPEN                 = 1 ---@type integer 
    bj_GATEOPERATION_DESTROY              = 2 ---@type integer 

    -- Game cache value types
    bj_GAMECACHE_BOOLEAN                           = 0 ---@type integer 
    bj_GAMECACHE_INTEGER                           = 1 ---@type integer 
    bj_GAMECACHE_REAL                              = 2 ---@type integer 
    bj_GAMECACHE_UNIT                              = 3 ---@type integer 
    bj_GAMECACHE_STRING                            = 4 ---@type integer 
    
    -- Hashtable value types
    bj_HASHTABLE_BOOLEAN                           = 0 ---@type integer 
    bj_HASHTABLE_INTEGER                           = 1 ---@type integer 
    bj_HASHTABLE_REAL                              = 2 ---@type integer 
    bj_HASHTABLE_STRING                            = 3 ---@type integer 
    bj_HASHTABLE_HANDLE                            = 4 ---@type integer 

    -- Item status types
    bj_ITEM_STATUS_HIDDEN                 = 0 ---@type integer 
    bj_ITEM_STATUS_OWNED                  = 1 ---@type integer 
    bj_ITEM_STATUS_INVULNERABLE           = 2 ---@type integer 
    bj_ITEM_STATUS_POWERUP                = 3 ---@type integer 
    bj_ITEM_STATUS_SELLABLE               = 4 ---@type integer 
    bj_ITEM_STATUS_PAWNABLE               = 5 ---@type integer 

    -- Itemcode status types
    bj_ITEMCODE_STATUS_POWERUP            = 0 ---@type integer 
    bj_ITEMCODE_STATUS_SELLABLE           = 1 ---@type integer 
    bj_ITEMCODE_STATUS_PAWNABLE           = 2 ---@type integer 

    -- Minimap ping styles
    bj_MINIMAPPINGSTYLE_SIMPLE            = 0 ---@type integer 
    bj_MINIMAPPINGSTYLE_FLASHY            = 1 ---@type integer 
    bj_MINIMAPPINGSTYLE_ATTACK            = 2 ---@type integer 
    
    -- Campaign Minimap icon styles
    bj_CAMPPINGSTYLE_PRIMARY                   = 0 ---@type integer 
    bj_CAMPPINGSTYLE_PRIMARY_GREEN             = 1 ---@type integer 
    bj_CAMPPINGSTYLE_PRIMARY_RED               = 2 ---@type integer 
    bj_CAMPPINGSTYLE_BONUS                     = 3 ---@type integer 
    bj_CAMPPINGSTYLE_TURNIN                    = 4 ---@type integer 
    bj_CAMPPINGSTYLE_BOSS                      = 5 ---@type integer 
    bj_CAMPPINGSTYLE_CONTROL_ALLY              = 6 ---@type integer 
    bj_CAMPPINGSTYLE_CONTROL_NEUTRAL           = 7 ---@type integer 
    bj_CAMPPINGSTYLE_CONTROL_ENEMY             = 8 ---@type integer 

    -- Corpse creation settings
    bj_CORPSE_MAX_DEATH_TIME              = 8.00 ---@type number 

    -- Corpse creation styles
    bj_CORPSETYPE_FLESH                   = 0 ---@type integer 
    bj_CORPSETYPE_BONE                    = 1 ---@type integer 

    -- Elevator pathing-blocker destructable code
    bj_ELEVATOR_BLOCKER_CODE              = FourCC('DTep') ---@type integer 
    bj_ELEVATOR_CODE01                    = FourCC('DTrf') ---@type integer 
    bj_ELEVATOR_CODE02                    = FourCC('DTrx') ---@type integer 

    -- Elevator wall codes
    bj_ELEVATOR_WALL_TYPE_ALL                  = 0 ---@type integer 
    bj_ELEVATOR_WALL_TYPE_EAST                 = 1 ---@type integer 
    bj_ELEVATOR_WALL_TYPE_NORTH                = 2 ---@type integer 
    bj_ELEVATOR_WALL_TYPE_SOUTH                = 3 ---@type integer 
    bj_ELEVATOR_WALL_TYPE_WEST                 = 4 ---@type integer 

    -------------------------------------------------------------------------
    -- Variables
    --

    -- Force predefs
    bj_FORCE_ALL_PLAYERS                           = nil ---@type force 
    bj_FORCE_PLAYER={} ---@type force[] 

    bj_MELEE_MAX_TWINKED_HEROES                    = 0 ---@type integer 

    -- Map area rects
    bj_mapInitialPlayableArea                      = nil ---@type rect 
    bj_mapInitialCameraBounds                      = nil ---@type rect 

    -- Utility function vars
    bj_forLoopAIndex                               = 0 ---@type integer 
    bj_forLoopBIndex                               = 0 ---@type integer 
    bj_forLoopAIndexEnd                            = 0 ---@type integer 
    bj_forLoopBIndexEnd                            = 0 ---@type integer 

    bj_slotControlReady                            = false ---@type boolean 
    bj_slotControlUsed=__jarray(false) ---@type boolean[] 
    bj_slotControl={} ---@type mapcontrol[] 

    -- Game started detection vars
    bj_gameStartedTimer                            = nil ---@type timer 
    bj_gameStarted                                 = false ---@type boolean 
    bj_volumeGroupsTimer                           = CreateTimer() ---@type timer 

    -- Singleplayer check
    bj_isSinglePlayer                              = false ---@type boolean 

    -- Day/Night Cycle vars
    bj_dncSoundsDay                                = nil ---@type trigger 
    bj_dncSoundsNight                              = nil ---@type trigger 
    bj_dayAmbientSound                             = nil ---@type sound 
    bj_nightAmbientSound                           = nil ---@type sound 
    bj_dncSoundsDawn                               = nil ---@type trigger 
    bj_dncSoundsDusk                               = nil ---@type trigger 
    bj_dawnSound                                   = nil ---@type sound 
    bj_duskSound                                   = nil ---@type sound 
    bj_useDawnDuskSounds                           = true ---@type boolean 
    bj_dncIsDaytime                                = false ---@type boolean 

    -- Triggered sounds
    --sound              bj_pingMinimapSound         = null
    bj_rescueSound                                 = nil ---@type sound 
    bj_questDiscoveredSound                        = nil ---@type sound 
    bj_questUpdatedSound                           = nil ---@type sound 
    bj_questCompletedSound                         = nil ---@type sound 
    bj_questFailedSound                            = nil ---@type sound 
    bj_questHintSound                              = nil ---@type sound 
    bj_questSecretSound                            = nil ---@type sound 
    bj_questItemAcquiredSound                      = nil ---@type sound 
    bj_questWarningSound                           = nil ---@type sound 
    bj_victoryDialogSound                          = nil ---@type sound 
    bj_defeatDialogSound                           = nil ---@type sound 

    -- Marketplace vars
    bj_stockItemPurchased                          = nil ---@type trigger 
    bj_stockUpdateTimer                            = nil ---@type timer 
    bj_stockAllowedPermanent=__jarray(false) ---@type boolean[] 
    bj_stockAllowedCharged=__jarray(false) ---@type boolean[] 
    bj_stockAllowedArtifact=__jarray(false) ---@type boolean[] 
    bj_stockPickedItemLevel                        = 0 ---@type integer 
    bj_stockPickedItemType=nil ---@type itemtype 

    -- Melee vars
    bj_meleeVisibilityTrained                      = nil ---@type trigger 
    bj_meleeVisibilityIsDay                        = true ---@type boolean 
    bj_meleeGrantHeroItems                         = false ---@type boolean 
    bj_meleeNearestMineToLoc                       = nil ---@type location 
    bj_meleeNearestMine                            = nil ---@type unit 
    bj_meleeNearestMineDist                        = 0.00 ---@type number 
    bj_meleeGameOver                               = false ---@type boolean 
    bj_meleeDefeated=__jarray(false) ---@type boolean[] 
    bj_meleeVictoried=__jarray(false) ---@type boolean[] 
    bj_ghoul={} ---@type unit[] 
    bj_crippledTimer={} ---@type timer[] 
    bj_crippledTimerWindows={} ---@type timerdialog[] 
    bj_playerIsCrippled=__jarray(false) ---@type boolean[] 
    bj_playerIsExposed=__jarray(false) ---@type boolean[] 
    bj_finishSoonAllExposed                        = false ---@type boolean 
    bj_finishSoonTimerDialog                       = nil ---@type timerdialog 
    bj_meleeTwinkedHeroes=__jarray(0) ---@type integer[] 

    -- Rescue behavior vars
    bj_rescueUnitBehavior                          = nil ---@type trigger 
    bj_rescueChangeColorUnit                       = true ---@type boolean 
    bj_rescueChangeColorBldg                       = true ---@type boolean 

    -- Transmission vars
    bj_cineSceneEndingTimer                        = nil ---@type timer 
    bj_cineSceneLastSound                          = nil ---@type sound 
    bj_cineSceneBeingSkipped                       = nil ---@type trigger 

    -- Cinematic mode vars
    bj_cineModePriorSpeed                          = MAP_SPEED_NORMAL ---@type gamespeed 
    bj_cineModePriorFogSetting                     = false ---@type boolean 
    bj_cineModePriorMaskSetting                    = false ---@type boolean 
    bj_cineModeAlreadyIn                           = false ---@type boolean 
    bj_cineModePriorDawnDusk                       = false ---@type boolean 
    bj_cineModeSavedSeed                           = 0 ---@type integer 

    -- Cinematic fade vars
    bj_cineFadeFinishTimer                         = nil ---@type timer 
    bj_cineFadeContinueTimer                       = nil ---@type timer 
    bj_cineFadeContinueRed                         = 0 ---@type number 
    bj_cineFadeContinueGreen                       = 0 ---@type number 
    bj_cineFadeContinueBlue                        = 0 ---@type number 
    bj_cineFadeContinueTrans                       = 0 ---@type number 
    bj_cineFadeContinueDuration                    = 0 ---@type number 
    bj_cineFadeContinueTex                         = "" ---@type string 

    -- QueuedTriggerExecute vars
    bj_queuedExecTotal                             = 0 ---@type integer 
    bj_queuedExecTriggers={} ---@type trigger[] 
    bj_queuedExecUseConds=__jarray(false) ---@type boolean[] 
    bj_queuedExecTimeoutTimer                      = CreateTimer() ---@type timer 
    bj_queuedExecTimeout                           = nil ---@type trigger 

    -- Helper vars (for Filter and Enum funcs)
    bj_destInRegionDiesCount                       = 0 ---@type integer 
    bj_destInRegionDiesTrig                        = nil ---@type trigger 
    bj_groupCountUnits                             = 0 ---@type integer 
    bj_forceCountPlayers                           = 0 ---@type integer 
    bj_groupEnumTypeId                             = 0 ---@type integer 
    bj_groupEnumOwningPlayer                       = nil ---@type player 
    bj_groupAddGroupDest                           = nil ---@type group 
    bj_groupRemoveGroupDest                        = nil ---@type group 
    bj_groupRandomConsidered                       = 0 ---@type integer 
    bj_groupRandomCurrentPick                      = nil ---@type unit 
    bj_groupLastCreatedDest                        = nil ---@type group 
    bj_randomSubGroupGroup                         = nil ---@type group 
    bj_randomSubGroupWant                          = 0 ---@type integer 
    bj_randomSubGroupTotal                         = 0 ---@type integer 
    bj_randomSubGroupChance                        = 0 ---@type number 
    bj_destRandomConsidered                        = 0 ---@type integer 
    bj_destRandomCurrentPick                       = nil ---@type destructable 
    bj_elevatorWallBlocker                         = nil ---@type destructable 
    bj_elevatorNeighbor                            = nil ---@type destructable 
    bj_itemRandomConsidered                        = 0 ---@type integer 
    bj_itemRandomCurrentPick                       = nil ---@type item 
    bj_forceRandomConsidered                       = 0 ---@type integer 
    bj_forceRandomCurrentPick                      = nil ---@type player 
    bj_makeUnitRescuableUnit                       = nil ---@type unit 
    bj_makeUnitRescuableFlag                       = true ---@type boolean 
    bj_pauseAllUnitsFlag                           = true ---@type boolean 
    bj_enumDestructableCenter                      = nil ---@type location 
    bj_enumDestructableRadius                      = 0 ---@type number 
    bj_setPlayerTargetColor                        = nil ---@type playercolor 
    bj_isUnitGroupDeadResult                       = true ---@type boolean 
    bj_isUnitGroupEmptyResult                      = true ---@type boolean 
    bj_isUnitGroupInRectResult                     = true ---@type boolean 
    bj_isUnitGroupInRectRect                       = nil ---@type rect 
    bj_changeLevelShowScores                       = false ---@type boolean 
    bj_changeLevelMapName                          = nil ---@type string 
    bj_suspendDecayFleshGroup                      = CreateGroup() ---@type group 
    bj_suspendDecayBoneGroup                       = CreateGroup() ---@type group 
    bj_delayedSuspendDecayTimer                    = CreateTimer() ---@type timer 
    bj_delayedSuspendDecayTrig                     = nil ---@type trigger 
    bj_livingPlayerUnitsTypeId                     = 0 ---@type integer 
    bj_lastDyingWidget                             = nil ---@type widget 

    -- Random distribution vars
    bj_randDistCount                               = 0 ---@type integer 
    bj_randDistID=__jarray(0) ---@type integer[] 
    bj_randDistChance=__jarray(0) ---@type integer[] 

    -- Last X'd vars
    bj_lastCreatedUnit                             = nil ---@type unit 
    bj_lastCreatedItem                             = nil ---@type item 
    bj_lastRemovedItem                             = nil ---@type item 
    bj_lastHauntedGoldMine                         = nil ---@type unit 
    bj_lastCreatedDestructable                     = nil ---@type destructable 
    bj_lastCreatedGroup                            = CreateGroup() ---@type group 
    bj_lastCreatedFogModifier                      = nil ---@type fogmodifier 
    bj_lastCreatedEffect                           = nil ---@type effect 
    bj_lastCreatedWeatherEffect                    = nil ---@type weathereffect 
    bj_lastCreatedTerrainDeformation                    = nil ---@type terraindeformation 
    bj_lastCreatedQuest                            = nil ---@type quest 
    bj_lastCreatedQuestItem                        = nil ---@type questitem 
    bj_lastCreatedDefeatCondition                    = nil ---@type defeatcondition 
    bj_lastStartedTimer                            = CreateTimer() ---@type timer 
    bj_lastCreatedTimerDialog                      = nil ---@type timerdialog 
    bj_lastCreatedLeaderboard                      = nil ---@type leaderboard 
    bj_lastCreatedMultiboard                       = nil ---@type multiboard 
    bj_lastPlayedSound                             = nil ---@type sound 
    bj_lastPlayedMusic                             = "" ---@type string 
    bj_lastTransmissionDuration                    = 0 ---@type number 
    bj_lastCreatedGameCache                        = nil ---@type gamecache 
    bj_lastCreatedHashtable                        = nil ---@type hashtable 
    bj_lastLoadedUnit                              = nil ---@type unit 
    bj_lastCreatedButton                           = nil ---@type button 
    bj_lastReplacedUnit                            = nil ---@type unit 
    bj_lastCreatedTextTag                          = nil ---@type texttag 
    bj_lastCreatedLightning                        = nil ---@type lightning 
    bj_lastCreatedImage                            = nil ---@type image 
    bj_lastCreatedUbersplat                        = nil ---@type ubersplat 
    bj_lastCreatedMinimapIcon                      = nil ---@type minimapicon 
    bj_lastCreatedCommandButtonEffect                     = nil ---@type commandbuttoneffect 

    -- Filter function vars
    filterIssueHauntOrderAtLocBJ                         = nil ---@type boolexpr 
    filterEnumDestructablesInCircleBJ                    = nil ---@type boolexpr 
    filterGetUnitsInRectOfPlayer                         = nil ---@type boolexpr 
    filterGetUnitsOfTypeIdAll                            = nil ---@type boolexpr 
    filterGetUnitsOfPlayerAndTypeId                      = nil ---@type boolexpr 
    filterMeleeTrainedUnitIsHeroBJ                       = nil ---@type boolexpr 
    filterLivingPlayerUnitsOfTypeId                      = nil ---@type boolexpr 

    -- Memory cleanup vars
    bj_wantDestroyGroup                            = false ---@type boolean 

    -- Instanced Operation Results
    bj_lastInstObjFuncSuccessful                    = true ---@type boolean 




--***************************************************************************
--*
--*  Debugging Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(msg: string)
function BJDebugMsg(msg)
    local i         = 0 ---@type integer 
    repeat
        DisplayTimedTextToPlayer(Player(i),0,0,60,msg)
        i = i + 1
    until i == bj_MAX_PLAYERS
end



--***************************************************************************
--*
--*  Math Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(a: number, b: number):number
function RMinBJ(a, b)
    if (a < b) then
        return a
    else
        return b
    end
end

--===========================================================================
---@type fun(a: number, b: number):number
function RMaxBJ(a, b)
    if (a < b) then
        return b
    else
        return a
    end
end

--===========================================================================
---@type fun(a: number):number
function RAbsBJ(a)
    if (a >= 0) then
        return a
    else
        return -a
    end
end

--===========================================================================
---@type fun(a: number):number
function RSignBJ(a)
    if (a >= 0.0) then
        return 1.0
    else
        return -1.0
    end
end

--===========================================================================
---@type fun(a: integer, b: integer):integer
function IMinBJ(a, b)
    if (a < b) then
        return a
    else
        return b
    end
end

--===========================================================================
---@type fun(a: integer, b: integer):integer
function IMaxBJ(a, b)
    if (a < b) then
        return b
    else
        return a
    end
end

--===========================================================================
---@type fun(a: integer):integer
function IAbsBJ(a)
    if (a >= 0) then
        return a
    else
        return -a
    end
end

--===========================================================================
---@type fun(a: integer):integer
function ISignBJ(a)
    if (a >= 0) then
        return 1
    else
        return -1
    end
end

--===========================================================================
---@type fun(degrees: number):number
function SinBJ(degrees)
    return Sin(degrees * bj_DEGTORAD)
end

--===========================================================================
---@type fun(degrees: number):number
function CosBJ(degrees)
    return Cos(degrees * bj_DEGTORAD)
end

--===========================================================================
---@type fun(degrees: number):number
function TanBJ(degrees)
    return Tan(degrees * bj_DEGTORAD)
end

--===========================================================================
---@type fun(degrees: number):number
function AsinBJ(degrees)
    return Asin(degrees) * bj_RADTODEG
end

--===========================================================================
---@type fun(degrees: number):number
function AcosBJ(degrees)
    return Acos(degrees) * bj_RADTODEG
end

--===========================================================================
---@type fun(degrees: number):number
function AtanBJ(degrees)
    return Atan(degrees) * bj_RADTODEG
end

--===========================================================================
---@type fun(y: number, x: number):number
function Atan2BJ(y, x)
    return Atan2(y, x) * bj_RADTODEG
end

--===========================================================================
---@type fun(locA: location, locB: location):number
function AngleBetweenPoints(locA, locB)
    return bj_RADTODEG * Atan2(GetLocationY(locB) - GetLocationY(locA), GetLocationX(locB) - GetLocationX(locA))
end

--===========================================================================
---@type fun(locA: location, locB: location):number
function DistanceBetweenPoints(locA, locB)
    local dx      = GetLocationX(locB) - GetLocationX(locA) ---@type number 
    local dy      = GetLocationY(locB) - GetLocationY(locA) ---@type number 
    return SquareRoot(dx * dx + dy * dy)
end

--===========================================================================
---@type fun(source: location, dist: number, angle: number):location
function PolarProjectionBJ(source, dist, angle)
    local x      = GetLocationX(source) + dist * Cos(angle * bj_DEGTORAD) ---@type number 
    local y      = GetLocationY(source) + dist * Sin(angle * bj_DEGTORAD) ---@type number 
    return Location(x, y)
end

--===========================================================================
---@type fun():number
function GetRandomDirectionDeg()
    return GetRandomReal(0, 360)
end

--===========================================================================
---@type fun():number
function GetRandomPercentageBJ()
    return GetRandomReal(0, 100)
end

--===========================================================================
---@type fun(whichRect: rect):location
function GetRandomLocInRect(whichRect)
    return Location(GetRandomReal(GetRectMinX(whichRect), GetRectMaxX(whichRect)), GetRandomReal(GetRectMinY(whichRect), GetRectMaxY(whichRect)))
end

--===========================================================================
-- Calculate the modulus/remainder of (dividend) divided by (divisor).
-- Examples:  18 mod 5 = 3.  15 mod 5 = 0.  -8 mod 5 = 2.
--
---@type fun(dividend: integer, divisor: integer):integer
function ModuloInteger(dividend, divisor)
    local modulus         = dividend - (dividend // divisor) * divisor ---@type integer 

    -- If the dividend was negative, the above modulus calculation will
    -- be negative, but within (-divisor..0).  We can add (divisor) to
    -- shift this result into the desired range of (0..divisor).
    if (modulus < 0) then
        modulus = modulus + divisor
    end

    return modulus
end

--===========================================================================
-- Calculate the modulus/remainder of (dividend) divided by (divisor).
-- Examples:  13.000 mod 2.500 = 0.500.  -6.000 mod 2.500 = 1.500.
--
---@type fun(dividend: number, divisor: number):number
function ModuloReal(dividend, divisor)
    local modulus      = dividend - I2R(R2I(dividend // divisor)) * divisor ---@type number 

    -- If the dividend was negative, the above modulus calculation will
    -- be negative, but within (-divisor..0).  We can add (divisor) to
    -- shift this result into the desired range of (0..divisor).
    if (modulus < 0) then
        modulus = modulus + divisor
    end

    return modulus
end

--===========================================================================
---@type fun(loc: location, dx: number, dy: number):location
function OffsetLocation(loc, dx, dy)
    return Location(GetLocationX(loc) + dx, GetLocationY(loc) + dy)
end

--===========================================================================
---@type fun(r: rect, dx: number, dy: number):rect
function OffsetRectBJ(r, dx, dy)
    return Rect( GetRectMinX(r) + dx, GetRectMinY(r) + dy, GetRectMaxX(r) + dx, GetRectMaxY(r) + dy )
end

--===========================================================================
---@type fun(center: location, width: number, height: number):rect
function RectFromCenterSizeBJ(center, width, height)
    local x      = GetLocationX( center ) ---@type number 
    local y      = GetLocationY( center ) ---@type number 
    return Rect( x - width*0.5, y - height*0.5, x + width*0.5, y + height*0.5 )
end

--===========================================================================
---@type fun(r: rect, x: number, y: number):boolean
function RectContainsCoords(r, x, y)
    return (GetRectMinX(r) <= x) and (x <= GetRectMaxX(r)) and (GetRectMinY(r) <= y) and (y <= GetRectMaxY(r))
end

--===========================================================================
---@type fun(r: rect, loc: location):boolean
function RectContainsLoc(r, loc)
    return RectContainsCoords(r, GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
---@type fun(r: rect, whichUnit: unit):boolean
function RectContainsUnit(r, whichUnit)
    return RectContainsCoords(r, GetUnitX(whichUnit), GetUnitY(whichUnit))
end

--===========================================================================
---@type fun(whichItem: item, r: rect):boolean
function RectContainsItem(whichItem, r)
    if (whichItem == nil) then
        return false
    end

    if (IsItemOwned(whichItem)) then
        return false
    end

    return RectContainsCoords(r, GetItemX(whichItem), GetItemY(whichItem))
end



--***************************************************************************
--*
--*  Utility Constructs
--*
--***************************************************************************

--===========================================================================
-- Runs the trigger's actions if the trigger's conditions evaluate to true.
--
---@type fun(trig: trigger)
function ConditionalTriggerExecute(trig)
    if TriggerEvaluate(trig) then
        TriggerExecute(trig)
    end
end

--===========================================================================
-- Runs the trigger's actions if the trigger's conditions evaluate to true.
--
---@type fun(trig: trigger, checkConditions: boolean):boolean
function TriggerExecuteBJ(trig, checkConditions)
    if checkConditions then
        if not (TriggerEvaluate(trig)) then
            return false
        end
    end
    TriggerExecute(trig)
    return true
end

--===========================================================================
-- Arranges for a trigger to fire almost immediately, except that the calling
-- trigger is not interrupted as is the case with a TriggerExecute call.
-- Since the trigger executes normally, its conditions are still evaluated.
--
---@type fun(trig: trigger, checkConditions: boolean):boolean
function PostTriggerExecuteBJ(trig, checkConditions)
    if checkConditions then
        if not (TriggerEvaluate(trig)) then
            return false
        end
    end
    TriggerRegisterTimerEvent(trig, 0, false)
    return true
end

--===========================================================================
-- Debug - Display the contents of the trigger queue (as either null or "x"
-- for each entry).
function QueuedTriggerCheck()
    local s        = "TrigQueue Check " ---@type string 
    local i ---@type integer 

    i = 0
    while i < bj_queuedExecTotal do 
        s = s .."q[".. I2S(i) .."]="
        if (bj_queuedExecTriggers[i] == nil) then
            s = s .."null "
        else
            s = s .."x "
        end
        i = i + 1
    end
    s = s .."(".. I2S(bj_queuedExecTotal) .." total)"
    DisplayTimedTextToPlayer(GetLocalPlayer(),0,0,600,s)
end

--===========================================================================
-- Searches the queue for a given trigger, returning the index of the
-- trigger within the queue if it is found, or -1 if it is not found.
--
---@type fun(trig: trigger):integer
function QueuedTriggerGetIndex(trig)
    -- Determine which, if any, of the queued triggers is being removed.
    local index             = 0 ---@type integer 
    while index < bj_queuedExecTotal do 
        if (bj_queuedExecTriggers[index] == trig) then
            return index
        end
        index = index + 1
    end
    return -1
end

--===========================================================================
-- Removes a trigger from the trigger queue, shifting other triggers down
-- to fill the unused space.  If the currently running trigger is removed
-- in this manner, this function does NOT attempt to run the next trigger.
--
---@type fun(trigIndex: integer):boolean
function QueuedTriggerRemoveByIndex(trigIndex)
    local index ---@type integer 

    -- If the to-be-removed index is out of range, fail.
    if (trigIndex >= bj_queuedExecTotal) then
        return false
    end

    -- Shift all queue entries down to fill in the gap.
    bj_queuedExecTotal = bj_queuedExecTotal - 1
    index = trigIndex
    while index < bj_queuedExecTotal do 
        bj_queuedExecTriggers[index] = bj_queuedExecTriggers[index + 1]
        bj_queuedExecUseConds[index] = bj_queuedExecUseConds[index + 1]
        index = index + 1
    end
    return true
end

--===========================================================================
-- Attempt to execute the first trigger in the queue.  If it fails, remove
-- it and execute the next one.  Continue this cycle until a trigger runs,
-- or until the queue is empty.
--
---@type fun():boolean
function QueuedTriggerAttemptExec()
    while bj_queuedExecTotal ~= 0 do

        if TriggerExecuteBJ(bj_queuedExecTriggers[0], bj_queuedExecUseConds[0]) then
            -- Timeout the queue if it sits at the front of the queue for too long.
            TimerStart(bj_queuedExecTimeoutTimer, bj_QUEUED_TRIGGER_TIMEOUT, false, nil)
            return true
        end

        QueuedTriggerRemoveByIndex(0)
    end
    return false
end

--===========================================================================
-- Queues a trigger to be executed, assuring that such triggers are not
-- executed at the same time.
--
---@type fun(trig: trigger, checkConditions: boolean):boolean
function QueuedTriggerAddBJ(trig, checkConditions)
    -- Make sure our queue isn't full.  If it is, return failure.
    if (bj_queuedExecTotal >= bj_MAX_QUEUED_TRIGGERS) then
        return false
    end

    -- Add the trigger to an array of to-be-executed triggers.
    bj_queuedExecTriggers[bj_queuedExecTotal] = trig
    bj_queuedExecUseConds[bj_queuedExecTotal] = checkConditions
    bj_queuedExecTotal = bj_queuedExecTotal + 1

    -- If this is the only trigger in the queue, run it.
    if (bj_queuedExecTotal == 1) then
        QueuedTriggerAttemptExec()
    end
    return true
end

--===========================================================================
-- Denotes the end of a queued trigger. Be sure to call this only once per
-- queued trigger, or risk stepping on the toes of other queued triggers.
--
---@type fun(trig: trigger)
function QueuedTriggerRemoveBJ(trig)
    local index ---@type integer 
    local trigIndex ---@type integer 
    local trigExecuted ---@type boolean 

    -- Find the trigger's index.
    trigIndex = QueuedTriggerGetIndex(trig)
    if (trigIndex == -1) then
        return
    end

    -- Shuffle the other trigger entries down to fill in the gap.
    QueuedTriggerRemoveByIndex(trigIndex)

    -- If we just axed the currently running trigger, run the next one.
    if (trigIndex == 0) then
        PauseTimer(bj_queuedExecTimeoutTimer)
        QueuedTriggerAttemptExec()
    end
end

--===========================================================================
-- Denotes the end of a queued trigger. Be sure to call this only once per
-- queued trigger, lest you step on the toes of other queued triggers.
--
function QueuedTriggerDoneBJ()
    local index ---@type integer 

    -- Make sure there's something on the queue to remove.
    if (bj_queuedExecTotal <= 0) then
        return
    end

    -- Remove the currently running trigger from the array.
    QueuedTriggerRemoveByIndex(0)

    -- If other triggers are waiting to run, run one of them.
    PauseTimer(bj_queuedExecTimeoutTimer)
    QueuedTriggerAttemptExec()
end

--===========================================================================
-- Empty the trigger queue.
--
function QueuedTriggerClearBJ()
    PauseTimer(bj_queuedExecTimeoutTimer)
    bj_queuedExecTotal = 0
end

--===========================================================================
-- Remove all but the currently executing trigger from the trigger queue.
--
function QueuedTriggerClearInactiveBJ()
    bj_queuedExecTotal = IMinBJ(bj_queuedExecTotal, 1)
end

--===========================================================================
---@type fun():integer
function QueuedTriggerCountBJ()
    return bj_queuedExecTotal
end

--===========================================================================
---@type fun():boolean
function IsTriggerQueueEmptyBJ()
    return bj_queuedExecTotal <= 0
end

--===========================================================================
---@type fun(trig: trigger):boolean
function IsTriggerQueuedBJ(trig)
    return QueuedTriggerGetIndex(trig) ~= -1
end

--===========================================================================
---@type fun():integer
function GetForLoopIndexA()
    return bj_forLoopAIndex
end

--===========================================================================
---@type fun(newIndex: integer)
function SetForLoopIndexA(newIndex)
    bj_forLoopAIndex = newIndex
end

--===========================================================================
---@type fun():integer
function GetForLoopIndexB()
    return bj_forLoopBIndex
end

--===========================================================================
---@type fun(newIndex: integer)
function SetForLoopIndexB(newIndex)
    bj_forLoopBIndex = newIndex
end

--===========================================================================
-- We can't do game-time waits, so this simulates one by starting a timer
-- and polling until the timer expires.
---@type fun(duration: number)
function PolledWait(duration)
    local t ---@type timer 
    local timeRemaining ---@type number 

    if (duration > 0) then
        t = CreateTimer()
        TimerStart(t, duration, false, nil)
        while true do
            timeRemaining = TimerGetRemaining(t)
            if timeRemaining <= 0 then break end

            -- If we have a bit of time left, skip past 10% of the remaining
            -- duration instead of checking every interval, to minimize the
            -- polling on long waits.
            if (timeRemaining > bj_POLLED_WAIT_SKIP_THRESHOLD) then
                TriggerSleepAction(0.1 * timeRemaining)
            else
                TriggerSleepAction(bj_POLLED_WAIT_INTERVAL)
            end
        end
        DestroyTimer(t)
    end
end

--===========================================================================
---@type fun(flag: boolean, valueA: integer, valueB: integer):integer
function IntegerTertiaryOp(flag, valueA, valueB)
    if flag then
        return valueA
    else
        return valueB
    end
end


--***************************************************************************
--*
--*  General Utility Functions
--*  These functions exist purely to make the trigger dialogs cleaner and
--*  more comprehensible.
--*
--***************************************************************************

--===========================================================================
function DoNothing()
end

--===========================================================================
-- This function does nothing.  WorldEdit should should eventually ignore
-- CommentString triggers during script generation, but until such a time,
-- this function will serve as a stub.
--
---@type fun(commentString: string)
function CommentString(commentString)
end

--===========================================================================
-- This function returns the input string, converting it from the localized text, if necessary
--
---@type fun(theString: string):string
function StringIdentity(theString)
    return GetLocalizedString(theString)
end

--===========================================================================
---@type fun(valueA: boolean, valueB: boolean):boolean
function GetBooleanAnd(valueA, valueB)
    return valueA and valueB
end

--===========================================================================
---@type fun(valueA: boolean, valueB: boolean):boolean
function GetBooleanOr(valueA, valueB)
    return valueA or valueB
end

--===========================================================================
-- Converts a percentage (real, 0..100) into a scaled integer (0..max),
-- clipping the result to 0..max in case the input is invalid.
--
---@type fun(percentage: number, max: integer):integer
function PercentToInt(percentage, max)
    local realpercent      = percentage * I2R(max) * 0.01 ---@type number 
    local result         = MathRound(realpercent) ---@type integer 

    if (result < 0) then
        result = 0
    elseif (result > max) then
        result = max
    end

    return result
end

--===========================================================================
---@type fun(percentage: number):integer
function PercentTo255(percentage)
    return PercentToInt(percentage, 255)
end

--===========================================================================
---@type fun():number
function GetTimeOfDay()
    return GetFloatGameState(GAME_STATE_TIME_OF_DAY)
end

--===========================================================================
---@type fun(whatTime: number)
function SetTimeOfDay(whatTime)
    SetFloatGameState(GAME_STATE_TIME_OF_DAY, whatTime)
end

--===========================================================================
---@type fun(scalePercent: number)
function SetTimeOfDayScalePercentBJ(scalePercent)
    SetTimeOfDayScale(scalePercent * 0.01)
end

--===========================================================================
---@type fun():number
function GetTimeOfDayScalePercentBJ()
    return GetTimeOfDayScale() * 100
end

--===========================================================================
---@type fun(soundName: string)
function PlaySound(soundName)
    local soundHandle       = CreateSound(soundName, false, false, true, 12700, 12700, "") ---@type sound 
    StartSound(soundHandle)
    KillSoundWhenDone(soundHandle)
end

--===========================================================================
---@type fun(A: location, B: location):boolean
function CompareLocationsBJ(A, B)
    return GetLocationX(A) == GetLocationX(B) and GetLocationY(A) == GetLocationY(B)
end

--===========================================================================
---@type fun(A: rect, B: rect):boolean
function CompareRectsBJ(A, B)
    return GetRectMinX(A) == GetRectMinX(B) and GetRectMinY(A) == GetRectMinY(B) and GetRectMaxX(A) == GetRectMaxX(B) and GetRectMaxY(A) == GetRectMaxY(B)
end

--===========================================================================
-- Returns a square rect that exactly encompasses the specified circle.
--
---@type fun(center: location, radius: number):rect
function GetRectFromCircleBJ(center, radius)
    local centerX      = GetLocationX(center) ---@type number 
    local centerY      = GetLocationY(center) ---@type number 
    return Rect(centerX - radius, centerY - radius, centerX + radius, centerY + radius)
end



--***************************************************************************
--*
--*  Camera Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun():camerasetup
function GetCurrentCameraSetup()
    local theCam             = CreateCameraSetup() ---@type camerasetup 
    local duration      = 0 ---@type number 
    CameraSetupSetField(theCam, CAMERA_FIELD_TARGET_DISTANCE, GetCameraField(CAMERA_FIELD_TARGET_DISTANCE), duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_FARZ,            GetCameraField(CAMERA_FIELD_FARZ),            duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_ZOFFSET,         GetCameraField(CAMERA_FIELD_ZOFFSET),         duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_ANGLE_OF_ATTACK, bj_RADTODEG * GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK), duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_FIELD_OF_VIEW,   bj_RADTODEG * GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW),   duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_ROLL,            bj_RADTODEG * GetCameraField(CAMERA_FIELD_ROLL),            duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_ROTATION,        bj_RADTODEG * GetCameraField(CAMERA_FIELD_ROTATION),        duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_LOCAL_PITCH,     bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_PITCH),     duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_LOCAL_YAW,       bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_YAW),       duration)
    CameraSetupSetField(theCam, CAMERA_FIELD_LOCAL_ROLL,      bj_RADTODEG * GetCameraField(CAMERA_FIELD_LOCAL_ROLL),      duration)
    CameraSetupSetDestPosition(theCam, GetCameraTargetPositionX(), GetCameraTargetPositionY(), duration)
    return theCam
end

--===========================================================================
---@type fun(doPan: boolean, whichSetup: camerasetup, whichPlayer: player, duration: number)
function CameraSetupApplyForPlayer(doPan, whichSetup, whichPlayer, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        CameraSetupApplyForceDuration(whichSetup, doPan, duration)
    end
end

--===========================================================================
---@type fun(doPan: boolean, whichSetup: camerasetup, whichPlayer: player, forcedDuration: number, easeInDuration: number, easeOutDuration: number, smoothFactor: number)
function CameraSetupApplyForPlayerSmooth(doPan, whichSetup, whichPlayer, forcedDuration, easeInDuration, easeOutDuration, smoothFactor)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        BlzCameraSetupApplyForceDurationSmooth(whichSetup, doPan, forcedDuration, easeInDuration, easeOutDuration, smoothFactor)
    end
end

--===========================================================================
---@type fun(whichField: camerafield, whichSetup: camerasetup):number
function CameraSetupGetFieldSwap(whichField, whichSetup)
    return CameraSetupGetField(whichSetup, whichField)
end

--===========================================================================
---@type fun(whichPlayer: player, whichField: camerafield, value: number, duration: number)
function SetCameraFieldForPlayer(whichPlayer, whichField, value, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraField(whichField, value, duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, whichUnit: unit, xoffset: number, yoffset: number, inheritOrientation: boolean)
function SetCameraTargetControllerNoZForPlayer(whichPlayer, whichUnit, xoffset, yoffset, inheritOrientation)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraTargetController(whichUnit, xoffset, yoffset, inheritOrientation)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, x: number, y: number)
function SetCameraPositionForPlayer(whichPlayer, x, y)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraPosition(x, y)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location)
function SetCameraPositionLocForPlayer(whichPlayer, loc)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraPosition(GetLocationX(loc), GetLocationY(loc))
    end
end

--===========================================================================
---@type fun(degrees: number, loc: location, whichPlayer: player, duration: number)
function RotateCameraAroundLocBJ(degrees, loc, whichPlayer, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraRotateMode(GetLocationX(loc), GetLocationY(loc), bj_DEGTORAD * degrees, duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, x: number, y: number)
function PanCameraToForPlayer(whichPlayer, x, y)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PanCameraTo(x, y)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location)
function PanCameraToLocForPlayer(whichPlayer, loc)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PanCameraTo(GetLocationX(loc), GetLocationY(loc))
    end
end

--===========================================================================
---@type fun(whichPlayer: player, x: number, y: number, duration: number)
function PanCameraToTimedForPlayer(whichPlayer, x, y, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PanCameraToTimed(x, y, duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location, duration: number)
function PanCameraToTimedLocForPlayer(whichPlayer, loc, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PanCameraToTimed(GetLocationX(loc), GetLocationY(loc), duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location, zOffset: number, duration: number)
function PanCameraToTimedLocWithZForPlayer(whichPlayer, loc, zOffset, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PanCameraToTimedWithZ(GetLocationX(loc), GetLocationY(loc), zOffset, duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location, duration: number)
function SmartCameraPanBJ(whichPlayer, loc, duration)
    local dist ---@type number 
    local cameraLoc          = GetCameraTargetPositionLoc() ---@type location 
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        dist = DistanceBetweenPoints(loc, cameraLoc)
        if (dist >= bj_SMARTPAN_TRESHOLD_SNAP) then
            -- If the user is too far away, snap the camera.
            PanCameraToTimed(GetLocationX(loc), GetLocationY(loc), 0)
        elseif (dist >= bj_SMARTPAN_TRESHOLD_PAN) then
            -- If the user is moderately close, pan the camera.
            PanCameraToTimed(GetLocationX(loc), GetLocationY(loc), duration)
        else
            -- User is close enough, so don't touch the camera.
        end
    end
    RemoveLocation(cameraLoc)
end

--===========================================================================
---@type fun(whichPlayer: player, cameraModelFile: string)
function SetCinematicCameraForPlayer(whichPlayer, cameraModelFile)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCinematicCamera(cameraModelFile)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, duration: number)
function ResetToGameCameraForPlayer(whichPlayer, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ResetToGameCamera(duration)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, magnitude: number, velocity: number)
function CameraSetSourceNoiseForPlayer(whichPlayer, magnitude, velocity)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        CameraSetSourceNoise(magnitude, velocity)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, magnitude: number, velocity: number)
function CameraSetTargetNoiseForPlayer(whichPlayer, magnitude, velocity)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        CameraSetTargetNoise(magnitude, velocity)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, magnitude: number)
function CameraSetEQNoiseForPlayer(whichPlayer, magnitude)
    local richter      = magnitude ---@type number 
    if (richter > 5.0) then
        richter = 5.0
    end
    if (richter < 2.0) then
        richter = 2.0
    end
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        CameraSetTargetNoiseEx(magnitude*2.0, magnitude*Pow(10,richter),true)
        CameraSetSourceNoiseEx(magnitude*2.0, magnitude*Pow(10,richter),true)
    end
end

--===========================================================================
---@type fun(whichPlayer: player)
function CameraClearNoiseForPlayer(whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        CameraSetSourceNoise(0, 0)
        CameraSetTargetNoise(0, 0)
    end
end

--===========================================================================
-- Query the current camera bounds.
--
---@type fun():rect
function GetCurrentCameraBoundsMapRectBJ()
    return Rect(GetCameraBoundMinX(), GetCameraBoundMinY(), GetCameraBoundMaxX(), GetCameraBoundMaxY())
end

--===========================================================================
-- Query the initial camera bounds, as defined at map init.
--
---@type fun():rect
function GetCameraBoundsMapRect()
    return bj_mapInitialCameraBounds
end

--===========================================================================
-- Query the playable map area, as defined at map init.
--
---@type fun():rect
function GetPlayableMapRect()
    return bj_mapInitialPlayableArea
end

--===========================================================================
-- Query the entire map area, as defined at map init.
--
---@type fun():rect
function GetEntireMapRect()
    return GetWorldBounds()
end

--===========================================================================
---@type fun(r: rect)
function SetCameraBoundsToRect(r)
    local minX      = GetRectMinX(r) ---@type number 
    local minY      = GetRectMinY(r) ---@type number 
    local maxX      = GetRectMaxX(r) ---@type number 
    local maxY      = GetRectMaxY(r) ---@type number 
    SetCameraBounds(minX, minY, minX, maxY, maxX, maxY, maxX, minY)
end

--===========================================================================
---@type fun(whichPlayer: player, r: rect)
function SetCameraBoundsToRectForPlayerBJ(whichPlayer, r)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraBoundsToRect(r)
    end
end

--===========================================================================
---@type fun(adjustMethod: integer, dxWest: number, dxEast: number, dyNorth: number, dySouth: number)
function AdjustCameraBoundsBJ(adjustMethod, dxWest, dxEast, dyNorth, dySouth)
    local minX      = 0 ---@type number 
    local minY      = 0 ---@type number 
    local maxX      = 0 ---@type number 
    local maxY      = 0 ---@type number 
    local scale      = 0 ---@type number 

    if (adjustMethod == bj_CAMERABOUNDS_ADJUST_ADD) then
        scale = 1
    elseif (adjustMethod == bj_CAMERABOUNDS_ADJUST_SUB) then
        scale = -1
    else
        -- Unrecognized adjustment method - ignore the request.
        return
    end

    -- Adjust the actual camera values
    minX = GetCameraBoundMinX() - scale * dxWest
    maxX = GetCameraBoundMaxX() + scale * dxEast
    minY = GetCameraBoundMinY() - scale * dySouth
    maxY = GetCameraBoundMaxY() + scale * dyNorth

    -- Make sure the camera bounds are still valid.
    if (maxX < minX) then
        minX = (minX + maxX) * 0.5
        maxX = minX
    end
    if (maxY < minY) then
        minY = (minY + maxY) * 0.5
        maxY = minY
    end

    -- Apply the new camera values.
    SetCameraBounds(minX, minY, minX, maxY, maxX, maxY, maxX, minY)
end

--===========================================================================
---@type fun(adjustMethod: integer, whichPlayer: player, dxWest: number, dxEast: number, dyNorth: number, dySouth: number)
function AdjustCameraBoundsForPlayerBJ(adjustMethod, whichPlayer, dxWest, dxEast, dyNorth, dySouth)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        AdjustCameraBoundsBJ(adjustMethod, dxWest, dxEast, dyNorth, dySouth)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, x: number, y: number)
function SetCameraQuickPositionForPlayer(whichPlayer, x, y)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraQuickPosition(x, y)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location)
function SetCameraQuickPositionLocForPlayer(whichPlayer, loc)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraQuickPosition(GetLocationX(loc), GetLocationY(loc))
    end
end

--===========================================================================
---@type fun(loc: location)
function SetCameraQuickPositionLoc(loc)
    SetCameraQuickPosition(GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
---@type fun(whichPlayer: player)
function StopCameraForPlayerBJ(whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        StopCamera()
    end
end

--===========================================================================
---@type fun(whichPlayer: player, whichUnit: unit, xoffset: number, yoffset: number)
function SetCameraOrientControllerForPlayerBJ(whichPlayer, whichUnit, xoffset, yoffset)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetCameraOrientController(whichUnit, xoffset, yoffset)
    end
end

--===========================================================================
---@type fun(factor: number)
function CameraSetSmoothingFactorBJ(factor)
    CameraSetSmoothingFactor(factor)
end

--===========================================================================
function CameraResetSmoothingFactorBJ()
    CameraSetSmoothingFactor(0)
end



--***************************************************************************
--*
--*  Text Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(toForce: force, message: string)
function DisplayTextToForce(toForce, message)
    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        DisplayTextToPlayer(GetLocalPlayer(), 0, 0, message)
    end
end

--===========================================================================
---@type fun(toForce: force, duration: number, message: string)
function DisplayTimedTextToForce(toForce, duration, message)
    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, duration, message)
    end
end

--===========================================================================
---@type fun(toForce: force)
function ClearTextMessagesBJ(toForce)
    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ClearTextMessages()
    end
end

--===========================================================================
-- The parameters for the API Substring function are unintuitive, so this
-- merely performs a translation for the starting index.
--
---@type fun(source: string, start: integer, end_: integer):string
function SubStringBJ(source, start, end_)
    return SubString(source, start-1, end_)
end  
  
---@type fun(h: handle):integer
function GetHandleIdBJ(h)
    return GetHandleId(h)
end

---@type fun(s: string):integer
function StringHashBJ(s)
    return StringHash(s)
end



--***************************************************************************
--*
--*  Event Registration Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(trig: trigger, timeout: number):event
function TriggerRegisterTimerEventPeriodic(trig, timeout)
    return TriggerRegisterTimerEvent(trig, timeout, true)
end

--===========================================================================
---@type fun(trig: trigger, timeout: number):event
function TriggerRegisterTimerEventSingle(trig, timeout)
    return TriggerRegisterTimerEvent(trig, timeout, false)
end

--===========================================================================
---@type fun(trig: trigger, t: timer):event
function TriggerRegisterTimerExpireEventBJ(trig, t)
    return TriggerRegisterTimerExpireEvent(trig, t)
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player, whichEvent: playerunitevent):event
function TriggerRegisterPlayerUnitEventSimple(trig, whichPlayer, whichEvent)
    return TriggerRegisterPlayerUnitEvent(trig, whichPlayer, whichEvent, nil)
end

--===========================================================================
---@type fun(trig: trigger, whichEvent: playerunitevent)
function TriggerRegisterAnyUnitEventBJ(trig, whichEvent)
    local index ---@type integer 

    index = 0
    repeat
        TriggerRegisterPlayerUnitEvent(trig, Player(index), whichEvent, nil)

        index = index + 1
    until index == bj_MAX_PLAYER_SLOTS
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player, selected: boolean):event
function TriggerRegisterPlayerSelectionEventBJ(trig, whichPlayer, selected)
    if selected then
        return TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_SELECTED, nil)
    else
        return TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player, keType: integer, keKey: integer):event
function TriggerRegisterPlayerKeyEventBJ(trig, whichPlayer, keType, keKey)
    if (keType == bj_KEYEVENTTYPE_DEPRESS) then
        -- Depress event - find out what key
        if (keKey == bj_KEYEVENTKEY_LEFT) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_LEFT_DOWN)
        elseif (keKey == bj_KEYEVENTKEY_RIGHT) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_RIGHT_DOWN)
        elseif (keKey == bj_KEYEVENTKEY_DOWN) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_DOWN_DOWN)
        elseif (keKey == bj_KEYEVENTKEY_UP) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_UP_DOWN)
        else
            -- Unrecognized key - ignore the request and return failure.
            return nil
        end
    elseif (keType == bj_KEYEVENTTYPE_RELEASE) then
        -- Release event - find out what key
        if (keKey == bj_KEYEVENTKEY_LEFT) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_LEFT_UP)
        elseif (keKey == bj_KEYEVENTKEY_RIGHT) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_RIGHT_UP)
        elseif (keKey == bj_KEYEVENTKEY_DOWN) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_DOWN_UP)
        elseif (keKey == bj_KEYEVENTKEY_UP) then
            return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_UP_UP)
        else
            -- Unrecognized key - ignore the request and return failure.
            return nil
        end
    else
        -- Unrecognized type - ignore the request and return failure.
        return nil
    end
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player, meType: integer):event
function TriggerRegisterPlayerMouseEventBJ(trig, whichPlayer, meType)
     if (meType == bj_MOUSEEVENTTYPE_DOWN) then
        -- Mouse down event
        return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_MOUSE_DOWN)
    elseif (meType == bj_MOUSEEVENTTYPE_UP) then
        -- Mouse up event
        return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_MOUSE_UP)
    elseif (meType == bj_MOUSEEVENTTYPE_MOVE) then
        -- Mouse move event
        return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_MOUSE_MOVE)
    else
        -- Unrecognized type - ignore the request and return failure.
         return nil
    end
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player):event
function TriggerRegisterPlayerEventVictory(trig, whichPlayer)
    return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_VICTORY)
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player):event
function TriggerRegisterPlayerEventDefeat(trig, whichPlayer)
    return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_DEFEAT)
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player):event
function TriggerRegisterPlayerEventLeave(trig, whichPlayer)
    return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_LEAVE)
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player):event
function TriggerRegisterPlayerEventAllianceChanged(trig, whichPlayer)
    return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ALLIANCE_CHANGED)
end

--===========================================================================
---@type fun(trig: trigger, whichPlayer: player):event
function TriggerRegisterPlayerEventEndCinematic(trig, whichPlayer)
    return TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_END_CINEMATIC)
end

--===========================================================================
---@type fun(trig: trigger, opcode: limitop, limitval: number):event
function TriggerRegisterGameStateEventTimeOfDay(trig, opcode, limitval)
    return TriggerRegisterGameStateEvent(trig, GAME_STATE_TIME_OF_DAY, opcode, limitval)
end

--===========================================================================
---@type fun(trig: trigger, whichRegion: region):event
function TriggerRegisterEnterRegionSimple(trig, whichRegion)
    return TriggerRegisterEnterRegion(trig, whichRegion, nil)
end

--===========================================================================
---@type fun(trig: trigger, whichRegion: region):event
function TriggerRegisterLeaveRegionSimple(trig, whichRegion)
    return TriggerRegisterLeaveRegion(trig, whichRegion, nil)
end

--===========================================================================
---@type fun(trig: trigger, r: rect):event
function TriggerRegisterEnterRectSimple(trig, r)
    local rectRegion        = CreateRegion() ---@type region 
    RegionAddRect(rectRegion, r)
    return TriggerRegisterEnterRegion(trig, rectRegion, nil)
end

--===========================================================================
---@type fun(trig: trigger, r: rect):event
function TriggerRegisterLeaveRectSimple(trig, r)
    local rectRegion        = CreateRegion() ---@type region 
    RegionAddRect(rectRegion, r)
    return TriggerRegisterLeaveRegion(trig, rectRegion, nil)
end

--===========================================================================
---@type fun(trig: trigger, whichUnit: unit, condition?: boolexpr, range: number):event
function TriggerRegisterDistanceBetweenUnits(trig, whichUnit, condition, range)
    return TriggerRegisterUnitInRange(trig, whichUnit, range, condition)
end

--===========================================================================
---@type fun(trig: trigger, range: number, whichUnit: unit):event
function TriggerRegisterUnitInRangeSimple(trig, range, whichUnit)
    return TriggerRegisterUnitInRange(trig, whichUnit, range, nil)
end

--===========================================================================
---@type fun(trig: trigger, whichUnit: unit, opcode: limitop, limitval: number):event
function TriggerRegisterUnitLifeEvent(trig, whichUnit, opcode, limitval)
    return TriggerRegisterUnitStateEvent(trig, whichUnit, UNIT_STATE_LIFE, opcode, limitval)
end

--===========================================================================
---@type fun(trig: trigger, whichUnit: unit, opcode: limitop, limitval: number):event
function TriggerRegisterUnitManaEvent(trig, whichUnit, opcode, limitval)
    return TriggerRegisterUnitStateEvent(trig, whichUnit, UNIT_STATE_MANA, opcode, limitval)
end

--===========================================================================
---@type fun(trig: trigger, whichDialog: dialog):event
function TriggerRegisterDialogEventBJ(trig, whichDialog)
    return TriggerRegisterDialogEvent(trig, whichDialog)
end

--===========================================================================
---@type fun(trig: trigger):event
function TriggerRegisterShowSkillEventBJ(trig)
    return TriggerRegisterGameEvent(trig, EVENT_GAME_SHOW_SKILL)
end

--===========================================================================
---@type fun(trig: trigger):event
function TriggerRegisterBuildSubmenuEventBJ(trig)
    return TriggerRegisterGameEvent(trig, EVENT_GAME_BUILD_SUBMENU)
end

--===========================================================================
---@type fun(trig: trigger, unitId: integer):event
function TriggerRegisterBuildCommandEventBJ(trig, unitId)
    TriggerRegisterCommandEvent(trig, FourCC('ANbu'), UnitId2String(unitId))
    TriggerRegisterCommandEvent(trig, FourCC('AHbu'), UnitId2String(unitId))
    TriggerRegisterCommandEvent(trig, FourCC('AEbu'), UnitId2String(unitId))
    TriggerRegisterCommandEvent(trig, FourCC('AObu'), UnitId2String(unitId))
    TriggerRegisterCommandEvent(trig, FourCC('AUbu'), UnitId2String(unitId))
    return TriggerRegisterCommandEvent(trig, FourCC('AGbu'), UnitId2String(unitId))
end

--===========================================================================
---@type fun(trig: trigger, unitId: integer):event
function TriggerRegisterTrainCommandEventBJ(trig, unitId)
    return TriggerRegisterCommandEvent(trig, FourCC('Aque'), UnitId2String(unitId))
end

--===========================================================================
---@type fun(trig: trigger, techId: integer):event
function TriggerRegisterUpgradeCommandEventBJ(trig, techId)
    return TriggerRegisterUpgradeCommandEvent(trig, techId)
end

--===========================================================================
---@type fun(trig: trigger, order: string):event
function TriggerRegisterCommonCommandEventBJ(trig, order)
    return TriggerRegisterCommandEvent(trig, 0, order)
end

--===========================================================================
---@type fun(trig: trigger):event
function TriggerRegisterGameLoadedEventBJ(trig)
    return TriggerRegisterGameEvent(trig, EVENT_GAME_LOADED)
end

--===========================================================================
---@type fun(trig: trigger):event
function TriggerRegisterGameSavedEventBJ(trig)
    return TriggerRegisterGameEvent(trig, EVENT_GAME_SAVE)
end

--===========================================================================
function RegisterDestDeathInRegionEnum()
    bj_destInRegionDiesCount = bj_destInRegionDiesCount + 1
    if (bj_destInRegionDiesCount <= bj_MAX_DEST_IN_REGION_EVENTS) then
        TriggerRegisterDeathEvent(bj_destInRegionDiesTrig, GetEnumDestructable())
    end
end

--===========================================================================
---@type fun(trig: trigger, r: rect)
function TriggerRegisterDestDeathInRegionEvent(trig, r)
    bj_destInRegionDiesTrig = trig
    bj_destInRegionDiesCount = 0
    EnumDestructablesInRect(r, nil, RegisterDestDeathInRegionEnum)
end



--***************************************************************************
--*
--*  Environment Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(where: rect, effectID: integer):weathereffect
function AddWeatherEffectSaveLast(where, effectID)
    bj_lastCreatedWeatherEffect = AddWeatherEffect(where, effectID)
    return bj_lastCreatedWeatherEffect
end

--===========================================================================
---@type fun():weathereffect
function GetLastCreatedWeatherEffect()
    return bj_lastCreatedWeatherEffect
end

--===========================================================================
---@type fun(whichWeatherEffect: weathereffect)
function RemoveWeatherEffectBJ(whichWeatherEffect)
    RemoveWeatherEffect(whichWeatherEffect)
end

--===========================================================================
---@type fun(duration: number, permanent: boolean, where: location, radius: number, depth: number):terraindeformation
function TerrainDeformationCraterBJ(duration, permanent, where, radius, depth)
    bj_lastCreatedTerrainDeformation = TerrainDeformCrater(GetLocationX(where), GetLocationY(where), radius, depth, R2I(duration * 1000), permanent)
    return bj_lastCreatedTerrainDeformation
end

--===========================================================================
---@type fun(duration: number, limitNeg: boolean, where: location, startRadius: number, endRadius: number, depth: number, wavePeriod: number, waveWidth: number):terraindeformation
function TerrainDeformationRippleBJ(duration, limitNeg, where, startRadius, endRadius, depth, wavePeriod, waveWidth)
    local spaceWave ---@type number 
    local timeWave ---@type number 
    local radiusRatio ---@type number 

    if (endRadius <= 0 or waveWidth <= 0 or wavePeriod <= 0) then
        return nil
    end

    timeWave = 2.0 * duration / wavePeriod
    spaceWave = 2.0 * endRadius / waveWidth
    radiusRatio = startRadius / endRadius

    bj_lastCreatedTerrainDeformation = TerrainDeformRipple(GetLocationX(where), GetLocationY(where), endRadius, depth, R2I(duration * 1000), 1, spaceWave, timeWave, radiusRatio, limitNeg)
    return bj_lastCreatedTerrainDeformation
end

--===========================================================================
---@type fun(duration: number, source: location, target: location, radius: number, depth: number, trailDelay: number):terraindeformation
function TerrainDeformationWaveBJ(duration, source, target, radius, depth, trailDelay)
    local distance ---@type number 
    local dirX ---@type number 
    local dirY ---@type number 
    local speed ---@type number 

    distance = DistanceBetweenPoints(source, target)
    if (distance == 0 or duration <= 0) then
        return nil
    end

    dirX = (GetLocationX(target) - GetLocationX(source)) / distance
    dirY = (GetLocationY(target) - GetLocationY(source)) / distance
    speed = distance / duration

    bj_lastCreatedTerrainDeformation = TerrainDeformWave(GetLocationX(source), GetLocationY(source), dirX, dirY, distance, speed, radius, depth, R2I(trailDelay * 1000), 1)
    return bj_lastCreatedTerrainDeformation
end

--===========================================================================
---@type fun(duration: number, where: location, radius: number, minDelta: number, maxDelta: number, updateInterval: number):terraindeformation
function TerrainDeformationRandomBJ(duration, where, radius, minDelta, maxDelta, updateInterval)
    bj_lastCreatedTerrainDeformation = TerrainDeformRandom(GetLocationX(where), GetLocationY(where), radius, minDelta, maxDelta, R2I(duration * 1000), R2I(updateInterval * 1000))
    return bj_lastCreatedTerrainDeformation
end

--===========================================================================
---@type fun(deformation: terraindeformation, duration: number)
function TerrainDeformationStopBJ(deformation, duration)
    TerrainDeformStop(deformation, R2I(duration * 1000))
end

--===========================================================================
---@type fun():terraindeformation
function GetLastCreatedTerrainDeformation()
    return bj_lastCreatedTerrainDeformation
end

--===========================================================================
---@type fun(codeName: string, where1: location, where2: location):lightning
function AddLightningLoc(codeName, where1, where2)
    bj_lastCreatedLightning = AddLightningEx(codeName, true, GetLocationX(where1), GetLocationY(where1), GetLocationZ(where1), GetLocationX(where2), GetLocationY(where2), GetLocationZ(where2))
    return bj_lastCreatedLightning
end

--===========================================================================
---@type fun(whichBolt: lightning):boolean
function DestroyLightningBJ(whichBolt)
    return DestroyLightning(whichBolt)
end

--===========================================================================
---@type fun(whichBolt: lightning, where1: location, where2: location):boolean
function MoveLightningLoc(whichBolt, where1, where2)
    return MoveLightningEx(whichBolt, true, GetLocationX(where1), GetLocationY(where1), GetLocationZ(where1), GetLocationX(where2), GetLocationY(where2), GetLocationZ(where2))
end

--===========================================================================
---@type fun(whichBolt: lightning):number
function GetLightningColorABJ(whichBolt)
    return GetLightningColorA(whichBolt)
end

--===========================================================================
---@type fun(whichBolt: lightning):number
function GetLightningColorRBJ(whichBolt)
    return GetLightningColorR(whichBolt)
end

--===========================================================================
---@type fun(whichBolt: lightning):number
function GetLightningColorGBJ(whichBolt)
    return GetLightningColorG(whichBolt)
end

--===========================================================================
---@type fun(whichBolt: lightning):number
function GetLightningColorBBJ(whichBolt)
    return GetLightningColorB(whichBolt)
end

--===========================================================================
---@type fun(whichBolt: lightning, r: number, g: number, b: number, a: number):boolean
function SetLightningColorBJ(whichBolt, r, g, b, a)
    return SetLightningColor(whichBolt, r, g, b, a)
end

--===========================================================================
---@type fun():lightning
function GetLastCreatedLightningBJ()
    return bj_lastCreatedLightning
end

--===========================================================================
---@type fun(abilcode: integer, t: effecttype, index: integer):string
function GetAbilityEffectBJ(abilcode, t, index)
    return GetAbilityEffectById(abilcode, t, index)
end

--===========================================================================
---@type fun(abilcode: integer, t: soundtype):string
function GetAbilitySoundBJ(abilcode, t)
    return GetAbilitySoundById(abilcode, t)
end


--===========================================================================
---@type fun(where: location):integer
function GetTerrainCliffLevelBJ(where)
    return GetTerrainCliffLevel(GetLocationX(where), GetLocationY(where))
end

--===========================================================================
---@type fun(where: location):integer
function GetTerrainTypeBJ(where)
    return GetTerrainType(GetLocationX(where), GetLocationY(where))
end

--===========================================================================
---@type fun(where: location):integer
function GetTerrainVarianceBJ(where)
    return GetTerrainVariance(GetLocationX(where), GetLocationY(where))
end

--===========================================================================
---@type fun(where: location, terrainType: integer, variation: integer, area: integer, shape: integer)
function SetTerrainTypeBJ(where, terrainType, variation, area, shape)
    SetTerrainType(GetLocationX(where), GetLocationY(where), terrainType, variation, area, shape)
end

--===========================================================================
---@type fun(where: location, t: pathingtype):boolean
function IsTerrainPathableBJ(where, t)
    return IsTerrainPathable(GetLocationX(where), GetLocationY(where), t)
end

--===========================================================================
---@type fun(where: location, t: pathingtype, flag: boolean)
function SetTerrainPathableBJ(where, t, flag)
    SetTerrainPathable(GetLocationX(where), GetLocationY(where), t, flag)
end

--===========================================================================
---@type fun(red: number, green: number, blue: number, transparency: number)
function SetWaterBaseColorBJ(red, green, blue, transparency)
    SetWaterBaseColor(PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(whichPlayer: player, whichFogState: fogstate, r: rect, afterUnits: boolean):fogmodifier
function CreateFogModifierRectSimple(whichPlayer, whichFogState, r, afterUnits)
    bj_lastCreatedFogModifier = CreateFogModifierRect(whichPlayer, whichFogState, r, true, afterUnits)
    return bj_lastCreatedFogModifier
end

--===========================================================================
---@type fun(whichPlayer: player, whichFogState: fogstate, center: location, radius: number, afterUnits: boolean):fogmodifier
function CreateFogModifierRadiusLocSimple(whichPlayer, whichFogState, center, radius, afterUnits)
    bj_lastCreatedFogModifier = CreateFogModifierRadiusLoc(whichPlayer, whichFogState, center, radius, true, afterUnits)
    return bj_lastCreatedFogModifier
end

--===========================================================================
-- Version of CreateFogModifierRect that assumes use of sharedVision and
-- gives the option of immediately enabling the modifier, so that triggers
-- can default to modifiers that are immediately enabled.
--
---@type fun(enabled: boolean, whichPlayer: player, whichFogState: fogstate, r: rect):fogmodifier
function CreateFogModifierRectBJ(enabled, whichPlayer, whichFogState, r)
    bj_lastCreatedFogModifier = CreateFogModifierRect(whichPlayer, whichFogState, r, true, false)
    if enabled then
        FogModifierStart(bj_lastCreatedFogModifier)
    end
    return bj_lastCreatedFogModifier
end

--===========================================================================
-- Version of CreateFogModifierRadius that assumes use of sharedVision and
-- gives the option of immediately enabling the modifier, so that triggers
-- can default to modifiers that are immediately enabled.
--
---@type fun(enabled: boolean, whichPlayer: player, whichFogState: fogstate, center: location, radius: number):fogmodifier
function CreateFogModifierRadiusLocBJ(enabled, whichPlayer, whichFogState, center, radius)
    bj_lastCreatedFogModifier = CreateFogModifierRadiusLoc(whichPlayer, whichFogState, center, radius, true, false)
    if enabled then
        FogModifierStart(bj_lastCreatedFogModifier)
    end
    return bj_lastCreatedFogModifier
end

--===========================================================================
---@type fun():fogmodifier
function GetLastCreatedFogModifier()
    return bj_lastCreatedFogModifier
end

--===========================================================================
function FogEnableOn()
    FogEnable(true)
end

--===========================================================================
function FogEnableOff()
    FogEnable(false)
end

--===========================================================================
function FogMaskEnableOn()
    FogMaskEnable(true)
end

--===========================================================================
function FogMaskEnableOff()
    FogMaskEnable(false)
end

--===========================================================================
---@type fun(flag: boolean)
function UseTimeOfDayBJ(flag)
    SuspendTimeOfDay(not flag)
end

--===========================================================================
---@type fun(style: integer, zstart: number, zend: number, density: number, red: number, green: number, blue: number)
function SetTerrainFogExBJ(style, zstart, zend, density, red, green, blue)
    SetTerrainFogEx(style, zstart, zend, density, red * 0.01, green * 0.01, blue * 0.01)
end

--===========================================================================
function ResetTerrainFogBJ()
    ResetTerrainFog()
end

--===========================================================================
---@type fun(animName: string, doodadID: integer, radius: number, center: location)
function SetDoodadAnimationBJ(animName, doodadID, radius, center)
    SetDoodadAnimation(GetLocationX(center), GetLocationY(center), radius, doodadID, false, animName, false)
end

--===========================================================================
---@type fun(animName: string, doodadID: integer, r: rect)
function SetDoodadAnimationRectBJ(animName, doodadID, r)
    SetDoodadAnimationRect(r, doodadID, animName, false)
end

--===========================================================================
---@type fun(add: boolean, animProperties: string, whichUnit: unit)
function AddUnitAnimationPropertiesBJ(add, animProperties, whichUnit)
    AddUnitAnimationProperties(whichUnit, animProperties, add)
end


--============================================================================
---@type fun(file: string, size: number, where: location, zOffset: number, imageType: integer):image
function CreateImageBJ(file, size, where, zOffset, imageType)
    bj_lastCreatedImage = CreateImage(file, size, size, size, GetLocationX(where), GetLocationY(where), zOffset, 0, 0, 0, imageType)
    return bj_lastCreatedImage
end

--============================================================================
---@type fun(flag: boolean, whichImage: image)
function ShowImageBJ(flag, whichImage)
    ShowImage(whichImage, flag)
end

--============================================================================
---@type fun(whichImage: image, where: location, zOffset: number)
function SetImagePositionBJ(whichImage, where, zOffset)
    SetImagePosition(whichImage, GetLocationX(where), GetLocationY(where), zOffset)
end

--============================================================================
---@type fun(whichImage: image, red: number, green: number, blue: number, alpha: number)
function SetImageColorBJ(whichImage, red, green, blue, alpha)
    SetImageColor(whichImage, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-alpha))
end

--============================================================================
---@type fun():image
function GetLastCreatedImage()
    return bj_lastCreatedImage
end

--============================================================================
---@type fun(where: location, name: string, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean):ubersplat
function CreateUbersplatBJ(where, name, red, green, blue, alpha, forcePaused, noBirthTime)
    bj_lastCreatedUbersplat = CreateUbersplat(GetLocationX(where), GetLocationY(where), name, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-alpha), forcePaused, noBirthTime)
    return bj_lastCreatedUbersplat
end

--============================================================================
---@type fun(flag: boolean, whichSplat: ubersplat)
function ShowUbersplatBJ(flag, whichSplat)
    ShowUbersplat(whichSplat, flag)
end

--============================================================================
---@type fun():ubersplat
function GetLastCreatedUbersplat()
    return bj_lastCreatedUbersplat
end

--============================================================================
---@type fun():minimapicon
function GetLastCreatedMinimapIcon()
    return bj_lastCreatedMinimapIcon
end

--============================================================================
---@type fun(whichUnit: unit, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate):minimapicon
function CreateMinimapIconOnUnitBJ(whichUnit, red, green, blue, pingPath, fogVisibility)
    bj_lastCreatedMinimapIcon = CreateMinimapIconOnUnit(whichUnit, red, green, blue, pingPath, fogVisibility)
    return bj_lastCreatedMinimapIcon
end

--============================================================================
---@type fun(where: location, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate):minimapicon
function CreateMinimapIconAtLocBJ(where, red, green, blue, pingPath, fogVisibility)
    bj_lastCreatedMinimapIcon = CreateMinimapIconAtLoc(where, red, green, blue, pingPath, fogVisibility)
    return bj_lastCreatedMinimapIcon
end

--============================================================================
---@type fun(x: number, y: number, red: integer, green: integer, blue: integer, pingPath: string, fogVisibility: fogstate):minimapicon
function CreateMinimapIconBJ(x, y, red, green, blue, pingPath, fogVisibility)
    bj_lastCreatedMinimapIcon = CreateMinimapIcon(x, y, red, green, blue, pingPath, fogVisibility)
    return bj_lastCreatedMinimapIcon
end

--============================================================================
---@type fun(whichUnit: unit, style: integer)
function CampaignMinimapIconUnitBJ(whichUnit, style)
    local red ---@type integer 
    local green ---@type integer 
    local blue ---@type integer 
    local path ---@type string 
    if ( style == bj_CAMPPINGSTYLE_PRIMARY ) then
        -- green
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_PRIMARY_GREEN ) then
        -- green
        red     = 0
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_PRIMARY_RED ) then
        -- green
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_BONUS ) then
        -- yellow
        red     = 255
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectiveBonus" )
    elseif ( style == bj_CAMPPINGSTYLE_TURNIN ) then
        -- yellow
        red     = 255
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestTurnIn" )
    elseif ( style == bj_CAMPPINGSTYLE_BOSS ) then
        -- red
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestBoss" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_ALLY ) then
        -- green
        red     = 0
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_NEUTRAL ) then
        -- white
        red     = 255
        green   = 255
        blue    = 255
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_ENEMY ) then
        -- red
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    end
    CreateMinimapIconOnUnitBJ( whichUnit, red, green, blue, path, FOG_OF_WAR_MASKED )
    SetMinimapIconOrphanDestroy( bj_lastCreatedMinimapIcon, true )
end


--============================================================================
---@type fun(where: location, style: integer)
function CampaignMinimapIconLocBJ(where, style)
    local red ---@type integer 
    local green ---@type integer 
    local blue ---@type integer 
    local path ---@type string 
    if ( style == bj_CAMPPINGSTYLE_PRIMARY ) then
        -- green (different from the unit version)
        red     = 0
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_PRIMARY_GREEN ) then
        -- green (different from the unit version)
        red     = 0
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_PRIMARY_RED ) then
        -- green (different from the unit version)
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectivePrimary" )
    elseif ( style == bj_CAMPPINGSTYLE_BONUS ) then
        -- yellow
        red     = 255
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestObjectiveBonus" )
    elseif ( style == bj_CAMPPINGSTYLE_TURNIN ) then
        -- yellow
        red     = 255
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestTurnIn" )
    elseif ( style == bj_CAMPPINGSTYLE_BOSS ) then
        -- red
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestBoss" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_ALLY ) then
        -- green
        red     = 0
        green   = 255
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_NEUTRAL ) then
        -- white
        red     = 255
        green   = 255
        blue    = 255
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    elseif ( style == bj_CAMPPINGSTYLE_CONTROL_ENEMY ) then
        -- red
        red     = 255
        green   = 0
        blue    = 0
        path    = SkinManagerGetLocalPath( "MinimapQuestControlPoint" )
    end
    CreateMinimapIconAtLocBJ( where, red, green, blue, path, FOG_OF_WAR_MASKED )
end


--***************************************************************************
--*
--*  Sound Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(soundHandle: sound)
function PlaySoundBJ(soundHandle)
    bj_lastPlayedSound = soundHandle
    if (soundHandle ~= nil) then
        StartSound(soundHandle)
    end
end

--===========================================================================
---@type fun(soundHandle: sound, fadeOut: boolean)
function StopSoundBJ(soundHandle, fadeOut)
    StopSound(soundHandle, false, fadeOut)
end

--===========================================================================
---@type fun(soundHandle: sound, volumePercent: number)
function SetSoundVolumeBJ(soundHandle, volumePercent)
    SetSoundVolume(soundHandle, PercentToInt(volumePercent, 127))
end

--===========================================================================
---@type fun(newOffset: number, soundHandle: sound)
function SetSoundOffsetBJ(newOffset, soundHandle)
    SetSoundPlayPosition(soundHandle, R2I(newOffset * 1000))
end

--===========================================================================
---@type fun(soundHandle: sound, cutoff: number)
function SetSoundDistanceCutoffBJ(soundHandle, cutoff)
    SetSoundDistanceCutoff(soundHandle, cutoff)
end

--===========================================================================
---@type fun(soundHandle: sound, pitch: number)
function SetSoundPitchBJ(soundHandle, pitch)
    SetSoundPitch(soundHandle, pitch)
end

--===========================================================================
---@type fun(soundHandle: sound, loc: location, z: number)
function SetSoundPositionLocBJ(soundHandle, loc, z)
    SetSoundPosition(soundHandle, GetLocationX(loc), GetLocationY(loc), z)
end

--===========================================================================
---@type fun(soundHandle: sound, whichUnit: unit)
function AttachSoundToUnitBJ(soundHandle, whichUnit)
    AttachSoundToUnit(soundHandle, whichUnit)
end

--===========================================================================
---@type fun(soundHandle: sound, inside: number, outside: number, outsideVolumePercent: number)
function SetSoundConeAnglesBJ(soundHandle, inside, outside, outsideVolumePercent)
    SetSoundConeAngles(soundHandle, inside, outside, PercentToInt(outsideVolumePercent, 127))
end

--===========================================================================
---@type fun(soundHandle: sound)
function KillSoundWhenDoneBJ(soundHandle)
    KillSoundWhenDone(soundHandle)
end

--===========================================================================
---@type fun(soundHandle: sound, volumePercent: number, loc: location, z: number)
function PlaySoundAtPointBJ(soundHandle, volumePercent, loc, z)
    SetSoundPositionLocBJ(soundHandle, loc, z)
    SetSoundVolumeBJ(soundHandle, volumePercent)
    PlaySoundBJ(soundHandle)
end

--===========================================================================
---@type fun(soundHandle: sound, volumePercent: number, whichUnit: unit)
function PlaySoundOnUnitBJ(soundHandle, volumePercent, whichUnit)
    AttachSoundToUnitBJ(soundHandle, whichUnit)
    SetSoundVolumeBJ(soundHandle, volumePercent)
    PlaySoundBJ(soundHandle)
end

--===========================================================================
---@type fun(soundHandle: sound, volumePercent: number, startingOffset: number)
function PlaySoundFromOffsetBJ(soundHandle, volumePercent, startingOffset)
    SetSoundVolumeBJ(soundHandle, volumePercent)
    PlaySoundBJ(soundHandle)
    SetSoundOffsetBJ(startingOffset, soundHandle)
end

--===========================================================================
---@type fun(musicFileName: string)
function PlayMusicBJ(musicFileName)
    bj_lastPlayedMusic = musicFileName
    PlayMusic(musicFileName)
end

--===========================================================================
---@type fun(musicFileName: string, startingOffset: number, fadeInTime: number)
function PlayMusicExBJ(musicFileName, startingOffset, fadeInTime)
    bj_lastPlayedMusic = musicFileName
    PlayMusicEx(musicFileName, R2I(startingOffset * 1000), R2I(fadeInTime * 1000))
end

--===========================================================================
---@type fun(newOffset: number)
function SetMusicOffsetBJ(newOffset)
    SetMusicPlayPosition(R2I(newOffset * 1000))
end

--===========================================================================
---@type fun(musicName: string)
function PlayThematicMusicBJ(musicName)
    PlayThematicMusic(musicName)
end

--===========================================================================
---@type fun(musicName: string, startingOffset: number)
function PlayThematicMusicExBJ(musicName, startingOffset)
    PlayThematicMusicEx(musicName, R2I(startingOffset * 1000))
end

--===========================================================================
---@type fun(newOffset: number)
function SetThematicMusicOffsetBJ(newOffset)
    SetThematicMusicPlayPosition(R2I(newOffset * 1000))
end

--===========================================================================
function EndThematicMusicBJ()
    EndThematicMusic()
end

--===========================================================================
---@type fun(fadeOut: boolean)
function StopMusicBJ(fadeOut)
    StopMusic(fadeOut)
end

--===========================================================================
function ResumeMusicBJ()
    ResumeMusic()
end

--===========================================================================
---@type fun(volumePercent: number)
function SetMusicVolumeBJ(volumePercent)
    SetMusicVolume(PercentToInt(volumePercent, 127))
end

--===========================================================================
---@type fun(volumePercent: number)
function SetThematicMusicVolumeBJ(volumePercent)
    SetThematicMusicVolume(PercentToInt(volumePercent, 127))
end

--===========================================================================
---@type fun(soundHandle: sound):number
function GetSoundDurationBJ(soundHandle)
    if (soundHandle == nil) then
        return bj_NOTHING_SOUND_DURATION
    else
        return I2R(GetSoundDuration(soundHandle)) * 0.001
    end
end

--===========================================================================
---@type fun(musicFileName: string):number
function GetSoundFileDurationBJ(musicFileName)
    return I2R(GetSoundFileDuration(musicFileName)) * 0.001
end

--===========================================================================
---@type fun():sound
function GetLastPlayedSound()
    return bj_lastPlayedSound
end

--===========================================================================
---@type fun():string
function GetLastPlayedMusic()
    return bj_lastPlayedMusic
end

--===========================================================================
---@type fun(vgroup: volumegroup, percent: number)
function VolumeGroupSetVolumeBJ(vgroup, percent)
    VolumeGroupSetVolume(vgroup, percent * 0.01)
end

--===========================================================================
function SetCineModeVolumeGroupsImmediateBJ()
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITMOVEMENT,  bj_CINEMODE_VOLUME_UNITMOVEMENT)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITSOUNDS,    bj_CINEMODE_VOLUME_UNITSOUNDS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_COMBAT,        bj_CINEMODE_VOLUME_COMBAT)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_SPELLS,        bj_CINEMODE_VOLUME_SPELLS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI,            bj_CINEMODE_VOLUME_UI)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC,         bj_CINEMODE_VOLUME_MUSIC)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_CINEMODE_VOLUME_AMBIENTSOUNDS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_FIRE,          bj_CINEMODE_VOLUME_FIRE)
end

--===========================================================================
function SetCineModeVolumeGroupsBJ()
    -- Delay the request if it occurs at map init.
    if bj_gameStarted then
        SetCineModeVolumeGroupsImmediateBJ()
    else
        TimerStart(bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, SetCineModeVolumeGroupsImmediateBJ)
    end
end

--===========================================================================
function SetSpeechVolumeGroupsImmediateBJ()
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITMOVEMENT,  bj_SPEECH_VOLUME_UNITMOVEMENT)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITSOUNDS,    bj_SPEECH_VOLUME_UNITSOUNDS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_COMBAT,        bj_SPEECH_VOLUME_COMBAT)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_SPELLS,        bj_SPEECH_VOLUME_SPELLS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI,            bj_SPEECH_VOLUME_UI)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC,         bj_SPEECH_VOLUME_MUSIC)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_SPEECH_VOLUME_AMBIENTSOUNDS)
    VolumeGroupSetVolume(SOUND_VOLUMEGROUP_FIRE,          bj_SPEECH_VOLUME_FIRE)
end

--===========================================================================
function SetSpeechVolumeGroupsBJ()
    -- Delay the request if it occurs at map init.
    if bj_gameStarted then
        SetSpeechVolumeGroupsImmediateBJ()
    else
        TimerStart(bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, SetSpeechVolumeGroupsImmediateBJ)
    end
end

--===========================================================================
function VolumeGroupResetImmediateBJ()
    VolumeGroupReset()
end

--===========================================================================
function VolumeGroupResetBJ()
    -- Delay the request if it occurs at map init.
    if bj_gameStarted then
        VolumeGroupResetImmediateBJ()
    else
        TimerStart(bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, VolumeGroupResetImmediateBJ)
    end
end

--===========================================================================
---@type fun(soundHandle: sound):boolean
function GetSoundIsPlayingBJ(soundHandle)
    return GetSoundIsLoading(soundHandle) or GetSoundIsPlaying(soundHandle)
end

--===========================================================================
---@type fun(soundHandle: sound, offset: number)
function WaitForSoundBJ(soundHandle, offset)
    TriggerWaitForSound( soundHandle, offset )
end

--===========================================================================
---@type fun(musicName: string, index: integer)
function SetMapMusicIndexedBJ(musicName, index)
    SetMapMusic(musicName, false, index)
end

--===========================================================================
---@type fun(musicName: string)
function SetMapMusicRandomBJ(musicName)
    SetMapMusic(musicName, true, 0)
end

--===========================================================================
function ClearMapMusicBJ()
    ClearMapMusic()
end

--===========================================================================
---@type fun(add: boolean, soundHandle: sound, r: rect)
function SetStackedSoundBJ(add, soundHandle, r)
    local width      = GetRectMaxX(r) - GetRectMinX(r) ---@type number 
    local height      = GetRectMaxY(r) - GetRectMinY(r) ---@type number 

    SetSoundPosition(soundHandle, GetRectCenterX(r), GetRectCenterY(r), 0)
    if add then
        RegisterStackedSound(soundHandle, true, width, height)
    else
        UnregisterStackedSound(soundHandle, true, width, height)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, soundHandle: sound)
function StartSoundForPlayerBJ(whichPlayer, soundHandle)
    if (whichPlayer == GetLocalPlayer()) then
        StartSound(soundHandle)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, vgroup: volumegroup, scale: number)
function VolumeGroupSetVolumeForPlayerBJ(whichPlayer, vgroup, scale)
    if (GetLocalPlayer() == whichPlayer) then
        VolumeGroupSetVolume(vgroup, scale)
    end
end

--===========================================================================
---@type fun(flag: boolean)
function EnableDawnDusk(flag)
    bj_useDawnDuskSounds = flag
end

--===========================================================================
---@type fun():boolean
function IsDawnDuskEnabled()
    return bj_useDawnDuskSounds
end



--***************************************************************************
--*
--*  Day/Night ambient sounds
--*
--***************************************************************************

--===========================================================================
---@type fun(inLabel: string)
function SetAmbientDaySound(inLabel)
    local ToD ---@type number 

    -- Stop old sound, if necessary
    if (bj_dayAmbientSound ~= nil) then
        StopSound(bj_dayAmbientSound, true, true)
    end

    -- Create new sound
    bj_dayAmbientSound = CreateMIDISound(inLabel, 20, 20)

    -- Start the sound if necessary, based on current time
    ToD = GetTimeOfDay()
    if (ToD >= bj_TOD_DAWN and ToD < bj_TOD_DUSK) then
        StartSound(bj_dayAmbientSound)
    end
end

--===========================================================================
---@type fun(inLabel: string)
function SetAmbientNightSound(inLabel)
    local ToD ---@type number 

    -- Stop old sound, if necessary
    if (bj_nightAmbientSound ~= nil) then
        StopSound(bj_nightAmbientSound, true, true)
    end

    -- Create new sound
    bj_nightAmbientSound = CreateMIDISound(inLabel, 20, 20)

    -- Start the sound if necessary, based on current time
    ToD = GetTimeOfDay()
    if (ToD < bj_TOD_DAWN or ToD >= bj_TOD_DUSK) then
        StartSound(bj_nightAmbientSound)
    end
end



--***************************************************************************
--*
--*  Special Effect Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(where: location, modelName: string):effect
function AddSpecialEffectLocBJ(where, modelName)
    bj_lastCreatedEffect = AddSpecialEffectLoc(modelName, where)
    return bj_lastCreatedEffect
end

--===========================================================================
---@type fun(attachPointName: string, targetWidget: widget, modelName: string):effect
function AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
    bj_lastCreatedEffect = AddSpecialEffectTarget(modelName, targetWidget, attachPointName)
    return bj_lastCreatedEffect
end

--===========================================================================
-- Two distinct trigger actions can't share the same function name, so this
-- dummy function simply mimics the behavior of an existing call.
--
-- Commented out - Destructibles have no attachment points.
--
--function AddSpecialEffectTargetDestructableBJ takes string attachPointName, widget targetWidget, string modelName returns effect
--    return AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
--endfunction

--===========================================================================
-- Two distinct trigger actions can't share the same function name, so this
-- dummy function simply mimics the behavior of an existing call.
--
-- Commented out - Items have no attachment points.
--
--function AddSpecialEffectTargetItemBJ takes string attachPointName, widget targetWidget, string modelName returns effect
--    return AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName)
--endfunction

--===========================================================================
---@type fun(whichEffect: effect)
function DestroyEffectBJ(whichEffect)
    DestroyEffect(whichEffect)
end

--===========================================================================
---@type fun():effect
function GetLastCreatedEffectBJ()
    return bj_lastCreatedEffect
end



--***************************************************************************
--*
--*  Command Button Effect Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(abilityId: integer, order: string):commandbuttoneffect
function CreateCommandButtonEffectBJ(abilityId, order)
    bj_lastCreatedCommandButtonEffect = CreateCommandButtonEffect(abilityId, order)
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun(unitId: integer):commandbuttoneffect
function CreateTrainCommandButtonEffectBJ(unitId)
    bj_lastCreatedCommandButtonEffect = CreateCommandButtonEffect(FourCC('Aque'), UnitId2String(unitId))
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun(techId: integer):commandbuttoneffect
function CreateUpgradeCommandButtonEffectBJ(techId)
    bj_lastCreatedCommandButtonEffect = CreateUpgradeCommandButtonEffect(techId)
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun(order: string):commandbuttoneffect
function CreateCommonCommandButtonEffectBJ(order)
    bj_lastCreatedCommandButtonEffect = CreateCommandButtonEffect(0, order)
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun(abilityId: integer):commandbuttoneffect
function CreateLearnCommandButtonEffectBJ(abilityId)
    bj_lastCreatedCommandButtonEffect = CreateLearnCommandButtonEffect(abilityId)
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun(unitId: integer):commandbuttoneffect
function CreateBuildCommandButtonEffectBJ(unitId)
    local r      = GetPlayerRace(GetLocalPlayer()) ---@type race 
    local abilityId ---@type integer 
    if (r == RACE_HUMAN) then
        abilityId = FourCC('AHbu')
    elseif (r == RACE_ORC) then
        abilityId = FourCC('AObu')
    elseif (r == RACE_UNDEAD) then
        abilityId = FourCC('AUbu')
    elseif (r == RACE_NIGHTELF) then
        abilityId = FourCC('AEbu')
    else
        abilityId = FourCC('ANbu')
    end
    bj_lastCreatedCommandButtonEffect = CreateCommandButtonEffect(abilityId, UnitId2String(unitId))
    return bj_lastCreatedCommandButtonEffect
end

--===========================================================================
---@type fun():commandbuttoneffect
function GetLastCreatedCommandButtonEffectBJ()
    return bj_lastCreatedCommandButtonEffect
end


--***************************************************************************
--*
--*  Hero and Item Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(whichItem: item):location
function GetItemLoc(whichItem)
    return Location(GetItemX(whichItem), GetItemY(whichItem))
end

--===========================================================================
---@type fun(whichWidget: widget):number
function GetItemLifeBJ(whichWidget)
    return GetWidgetLife(whichWidget)
end

--===========================================================================
---@type fun(whichWidget: widget, life: number)
function SetItemLifeBJ(whichWidget, life)
    SetWidgetLife(whichWidget, life)
end

--===========================================================================
---@type fun(xpToAdd: integer, whichHero: unit, showEyeCandy: boolean)
function AddHeroXPSwapped(xpToAdd, whichHero, showEyeCandy)
    AddHeroXP(whichHero, xpToAdd, showEyeCandy)
end

--===========================================================================
---@type fun(whichHero: unit, newLevel: integer, showEyeCandy: boolean)
function SetHeroLevelBJ(whichHero, newLevel, showEyeCandy)
    local oldLevel         = GetHeroLevel(whichHero) ---@type integer 

    if (newLevel > oldLevel) then
        SetHeroLevel(whichHero, newLevel, showEyeCandy)
    elseif (newLevel < oldLevel) then
        UnitStripHeroLevel(whichHero, oldLevel - newLevel)
    else
        -- No change in level - ignore the request.
    end
end

--===========================================================================
---@type fun(abilcode: integer, whichUnit: unit):integer
function DecUnitAbilityLevelSwapped(abilcode, whichUnit)
    return DecUnitAbilityLevel(whichUnit, abilcode)
end

--===========================================================================
---@type fun(abilcode: integer, whichUnit: unit):integer
function IncUnitAbilityLevelSwapped(abilcode, whichUnit)
    return IncUnitAbilityLevel(whichUnit, abilcode)
end

--===========================================================================
---@type fun(abilcode: integer, whichUnit: unit, level: integer):integer
function SetUnitAbilityLevelSwapped(abilcode, whichUnit, level)
    return SetUnitAbilityLevel(whichUnit, abilcode, level)
end

--===========================================================================
---@type fun(abilcode: integer, whichUnit: unit):integer
function GetUnitAbilityLevelSwapped(abilcode, whichUnit)
    return GetUnitAbilityLevel(whichUnit, abilcode)
end

--===========================================================================
---@type fun(whichUnit: unit, buffcode: integer):boolean
function UnitHasBuffBJ(whichUnit, buffcode)
    return (GetUnitAbilityLevel(whichUnit, buffcode) > 0)
end

--===========================================================================
---@type fun(buffcode: integer, whichUnit: unit):boolean
function UnitRemoveBuffBJ(buffcode, whichUnit)
    return UnitRemoveAbility(whichUnit, buffcode)
end

--===========================================================================
---@type fun(whichItem: item, whichHero: unit):boolean
function UnitAddItemSwapped(whichItem, whichHero)
    return UnitAddItem(whichHero, whichItem)
end

--===========================================================================
---@type fun(itemId: integer, whichHero: unit):item
function UnitAddItemByIdSwapped(itemId, whichHero)
    -- Create the item at the hero's feet first, and then give it to him.
    -- This is to ensure that the item will be left at the hero's feet if
    -- his inventory is full. 
    bj_lastCreatedItem = CreateItem(itemId, GetUnitX(whichHero), GetUnitY(whichHero))
    UnitAddItem(whichHero, bj_lastCreatedItem)
    return bj_lastCreatedItem
end

--===========================================================================
---@type fun(whichItem: item, whichHero: unit)
function UnitRemoveItemSwapped(whichItem, whichHero)
    bj_lastRemovedItem = whichItem
    UnitRemoveItem(whichHero, whichItem)
end

--===========================================================================
-- Translates 0-based slot indices to 1-based slot indices.
--
---@type fun(itemSlot: integer, whichHero: unit):item
function UnitRemoveItemFromSlotSwapped(itemSlot, whichHero)
    bj_lastRemovedItem = UnitRemoveItemFromSlot(whichHero, itemSlot-1)
    return bj_lastRemovedItem
end

--===========================================================================
---@type fun(itemId: integer, loc: location):item
function CreateItemLoc(itemId, loc)
    bj_lastCreatedItem = CreateItem(itemId, GetLocationX(loc), GetLocationY(loc))
    return bj_lastCreatedItem
end

--===========================================================================
---@type fun():item
function GetLastCreatedItem()
    return bj_lastCreatedItem
end

--===========================================================================
---@type fun():item
function GetLastRemovedItem()
    return bj_lastRemovedItem
end

--===========================================================================
---@type fun(whichItem: item, loc: location)
function SetItemPositionLoc(whichItem, loc)
    SetItemPosition(whichItem, GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
---@type fun():integer
function GetLearnedSkillBJ()
    return GetLearnedSkill()
end

--===========================================================================
---@type fun(flag: boolean, whichHero: unit)
function SuspendHeroXPBJ(flag, whichHero)
    SuspendHeroXP(whichHero, not flag)
end

--===========================================================================
---@type fun(whichPlayer: player, handicapPercent: number)
function SetPlayerHandicapDamageBJ(whichPlayer, handicapPercent)
    SetPlayerHandicapDamage(whichPlayer, handicapPercent * 0.01)
end

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerHandicapDamageBJ(whichPlayer)
    return GetPlayerHandicapDamage(whichPlayer) * 100
end

--===========================================================================
---@type fun(whichPlayer: player, handicapPercent: number)
function SetPlayerHandicapReviveTimeBJ(whichPlayer, handicapPercent)
    SetPlayerHandicapReviveTime(whichPlayer, handicapPercent * 0.01)
end

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerHandicapReviveTimeBJ(whichPlayer)
    return GetPlayerHandicapReviveTime(whichPlayer) * 100
end

--===========================================================================
---@type fun(whichPlayer: player, handicapPercent: number)
function SetPlayerHandicapXPBJ(whichPlayer, handicapPercent)
    SetPlayerHandicapXP(whichPlayer, handicapPercent * 0.01)
end

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerHandicapXPBJ(whichPlayer)
    return GetPlayerHandicapXP(whichPlayer) * 100
end

--===========================================================================
---@type fun(whichPlayer: player, handicapPercent: number)
function SetPlayerHandicapBJ(whichPlayer, handicapPercent)
    SetPlayerHandicap(whichPlayer, handicapPercent * 0.01)
end

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerHandicapBJ(whichPlayer)
    return GetPlayerHandicap(whichPlayer) * 100
end

--===========================================================================
---@type fun(whichStat: integer, whichHero: unit, includeBonuses: boolean):integer
function GetHeroStatBJ(whichStat, whichHero, includeBonuses)
    if (whichStat == bj_HEROSTAT_STR) then
        return GetHeroStr(whichHero, includeBonuses)
    elseif (whichStat == bj_HEROSTAT_AGI) then
        return GetHeroAgi(whichHero, includeBonuses)
    elseif (whichStat == bj_HEROSTAT_INT) then
        return GetHeroInt(whichHero, includeBonuses)
    else
        -- Unrecognized hero stat - return 0
        return 0
    end
end

--===========================================================================
---@type fun(whichHero: unit, whichStat: integer, value: integer)
function SetHeroStat(whichHero, whichStat, value)
    -- Ignore requests for negative hero stats.
    if (value <= 0) then
        return
    end

    if (whichStat == bj_HEROSTAT_STR) then
        SetHeroStr(whichHero, value, true)
    elseif (whichStat == bj_HEROSTAT_AGI) then
        SetHeroAgi(whichHero, value, true)
    elseif (whichStat == bj_HEROSTAT_INT) then
        SetHeroInt(whichHero, value, true)
    else
        -- Unrecognized hero stat - ignore the request.
    end
end

--===========================================================================
---@type fun(whichStat: integer, whichHero: unit, modifyMethod: integer, value: integer)
function ModifyHeroStat(whichStat, whichHero, modifyMethod, value)
    if (modifyMethod == bj_MODIFYMETHOD_ADD) then
        SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) + value)
    elseif (modifyMethod == bj_MODIFYMETHOD_SUB) then
        SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) - value)
    elseif (modifyMethod == bj_MODIFYMETHOD_SET) then
        SetHeroStat(whichHero, whichStat, value)
    else
        -- Unrecognized modification method - ignore the request.
    end
end

--===========================================================================
---@type fun(whichHero: unit, modifyMethod: integer, value: integer):boolean
function ModifyHeroSkillPoints(whichHero, modifyMethod, value)
    if (modifyMethod == bj_MODIFYMETHOD_ADD) then
        return UnitModifySkillPoints(whichHero, value)
    elseif (modifyMethod == bj_MODIFYMETHOD_SUB) then
        return UnitModifySkillPoints(whichHero, -value)
    elseif (modifyMethod == bj_MODIFYMETHOD_SET) then
        return UnitModifySkillPoints(whichHero, value - GetHeroSkillPoints(whichHero))
    else
        -- Unrecognized modification method - ignore the request and return failure.
        return false
    end
end

--===========================================================================
---@type fun(whichUnit: unit, whichItem: item, x: number, y: number):boolean
function UnitDropItemPointBJ(whichUnit, whichItem, x, y)
    return UnitDropItemPoint(whichUnit, whichItem, x, y)
end

--===========================================================================
---@type fun(whichUnit: unit, whichItem: item, loc: location):boolean
function UnitDropItemPointLoc(whichUnit, whichItem, loc)
    return UnitDropItemPoint(whichUnit, whichItem, GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
---@type fun(whichUnit: unit, whichItem: item, slot: integer):boolean
function UnitDropItemSlotBJ(whichUnit, whichItem, slot)
    return UnitDropItemSlot(whichUnit, whichItem, slot-1)
end

--===========================================================================
---@type fun(whichUnit: unit, whichItem: item, target: widget):boolean
function UnitDropItemTargetBJ(whichUnit, whichItem, target)
    return UnitDropItemTarget(whichUnit, whichItem, target)
end

--===========================================================================
-- Two distinct trigger actions can't share the same function name, so this
-- dummy function simply mimics the behavior of an existing call.
--
---@type fun(whichUnit: unit, whichItem: item, target: widget):boolean
function UnitUseItemDestructable(whichUnit, whichItem, target)
    return UnitUseItemTarget(whichUnit, whichItem, target)
end

--===========================================================================
---@type fun(whichUnit: unit, whichItem: item, loc: location):boolean
function UnitUseItemPointLoc(whichUnit, whichItem, loc)
    return UnitUseItemPoint(whichUnit, whichItem, GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
-- Translates 0-based slot indices to 1-based slot indices.
--
---@type fun(whichUnit: unit, itemSlot: integer):item
function UnitItemInSlotBJ(whichUnit, itemSlot)
    return UnitItemInSlot(whichUnit, itemSlot-1)
end

--===========================================================================
-- Translates 0-based slot indices to 1-based slot indices.
--
---@type fun(whichUnit: unit, itemId: integer):integer
function GetInventoryIndexOfItemTypeBJ(whichUnit, itemId)
    local index ---@type integer 
    local indexItem ---@type item 

    index = 0
    repeat
        indexItem = UnitItemInSlot(whichUnit, index)
        if (indexItem ~= nil) and (GetItemTypeId(indexItem) == itemId) then
            return index + 1
        end

        index = index + 1
    until index >= bj_MAX_INVENTORY
    return 0
end

--===========================================================================
---@type fun(whichUnit: unit, itemId: integer):item
function GetItemOfTypeFromUnitBJ(whichUnit, itemId)
    local index         = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId) ---@type integer 

    if (index == 0) then
        return nil
    else
        return UnitItemInSlot(whichUnit, index - 1)
    end
end

--===========================================================================
---@type fun(whichUnit: unit, itemId: integer):boolean
function UnitHasItemOfTypeBJ(whichUnit, itemId)
    return GetInventoryIndexOfItemTypeBJ(whichUnit, itemId) > 0
end

--===========================================================================
---@type fun(whichUnit: unit):integer
function UnitInventoryCount(whichUnit)
    local index         = 0 ---@type integer 
    local count         = 0 ---@type integer 

    repeat
        if (UnitItemInSlot(whichUnit, index) ~= nil) then
            count = count + 1
        end

        index = index + 1
    until index >= bj_MAX_INVENTORY

    return count
end

--===========================================================================
---@type fun(whichUnit: unit):integer
function UnitInventorySizeBJ(whichUnit)
    return UnitInventorySize(whichUnit)
end

--===========================================================================
---@type fun(whichItem: item, flag: boolean)
function SetItemInvulnerableBJ(whichItem, flag)
    SetItemInvulnerable(whichItem, flag)
end

--===========================================================================
---@type fun(whichItem: item, flag: boolean)
function SetItemDropOnDeathBJ(whichItem, flag)
    SetItemDropOnDeath(whichItem, flag)
end

--===========================================================================
---@type fun(whichItem: item, flag: boolean)
function SetItemDroppableBJ(whichItem, flag)
    SetItemDroppable(whichItem, flag)
end

--===========================================================================
---@type fun(whichItem: item, whichPlayer: player, changeColor: boolean)
function SetItemPlayerBJ(whichItem, whichPlayer, changeColor)
    SetItemPlayer(whichItem, whichPlayer, changeColor)
end

--===========================================================================
---@type fun(show: boolean, whichItem: item)
function SetItemVisibleBJ(show, whichItem)
    SetItemVisible(whichItem, show)
end

--===========================================================================
---@type fun(whichItem: item):boolean
function IsItemHiddenBJ(whichItem)
    return not IsItemVisible(whichItem)
end

--===========================================================================
---@type fun(level: integer):integer
function ChooseRandomItemBJ(level)
    return ChooseRandomItem(level)
end

--===========================================================================
---@type fun(level: integer, whichType: itemtype):integer
function ChooseRandomItemExBJ(level, whichType)
    return ChooseRandomItemEx(whichType, level)
end

--===========================================================================
---@type fun():integer
function ChooseRandomNPBuildingBJ()
    return ChooseRandomNPBuilding()
end

--===========================================================================
---@type fun(level: integer):integer
function ChooseRandomCreepBJ(level)
    return ChooseRandomCreep(level)
end

--===========================================================================
---@type fun(r: rect, actionFunc: function)
function EnumItemsInRectBJ(r, actionFunc)
    EnumItemsInRect(r, nil, actionFunc)
end

--===========================================================================
-- See GroupPickRandomUnitEnum for the details of this algorithm.
--
function RandomItemInRectBJEnum()
    bj_itemRandomConsidered = bj_itemRandomConsidered + 1
    if (GetRandomInt(1, bj_itemRandomConsidered) == 1) then
        bj_itemRandomCurrentPick = GetEnumItem()
    end
end

--===========================================================================
-- Picks a random item from within a rect, matching a condition
--
---@type fun(r: rect, filter?: boolexpr):item
function RandomItemInRectBJ(r, filter)
    bj_itemRandomConsidered = 0
    bj_itemRandomCurrentPick = nil
    EnumItemsInRect(r, filter, RandomItemInRectBJEnum)
    DestroyBoolExpr(filter)
    return bj_itemRandomCurrentPick
end

--===========================================================================
-- Picks a random item from within a rect
--
---@type fun(r: rect):item
function RandomItemInRectSimpleBJ(r)
    return RandomItemInRectBJ(r, nil)
end

--===========================================================================
---@type fun(whichItem: item, status: integer):boolean
function CheckItemStatus(whichItem, status)
    if (status == bj_ITEM_STATUS_HIDDEN) then
        return not IsItemVisible(whichItem)
    elseif (status == bj_ITEM_STATUS_OWNED) then
        return IsItemOwned(whichItem)
    elseif (status == bj_ITEM_STATUS_INVULNERABLE) then
        return IsItemInvulnerable(whichItem)
    elseif (status == bj_ITEM_STATUS_POWERUP) then
        return IsItemPowerup(whichItem)
    elseif (status == bj_ITEM_STATUS_SELLABLE) then
        return IsItemSellable(whichItem)
    elseif (status == bj_ITEM_STATUS_PAWNABLE) then
        return IsItemPawnable(whichItem)
    else
        -- Unrecognized status - return false
        return false
    end
end

--===========================================================================
---@type fun(itemId: integer, status: integer):boolean
function CheckItemcodeStatus(itemId, status)
    if (status == bj_ITEMCODE_STATUS_POWERUP) then
        return IsItemIdPowerup(itemId)
    elseif (status == bj_ITEMCODE_STATUS_SELLABLE) then
        return IsItemIdSellable(itemId)
    elseif (status == bj_ITEMCODE_STATUS_PAWNABLE) then
        return IsItemIdPawnable(itemId)
    else
        -- Unrecognized status - return false
        return false
    end
end



--***************************************************************************
--*
--*  Unit Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(unitId: integer):integer
function UnitId2OrderIdBJ(unitId)
    return unitId
end

--===========================================================================
---@type fun(unitIdString: string):integer
function String2UnitIdBJ(unitIdString)
    return UnitId(unitIdString)
end

--===========================================================================
---@type fun(unitId: integer):string
function UnitId2StringBJ(unitId)
    local unitString        = UnitId2String(unitId) ---@type string 

    if (unitString ~= nil) then
        return unitString
    end

    -- The unitId was not recognized - return an empty string.
    return ""
end

--===========================================================================
---@type fun(orderIdString: string):integer
function String2OrderIdBJ(orderIdString)
    local orderId ---@type integer 
    
    -- Check to see if it's a generic order.
    orderId = OrderId(orderIdString)
    if (orderId ~= 0) then
        return orderId
    end

    -- Check to see if it's a (train) unit order.
    orderId = UnitId(orderIdString)
    if (orderId ~= 0) then
        return orderId
    end

    -- Unrecognized - return 0
    return 0
end

--===========================================================================
---@type fun(orderId: integer):string
function OrderId2StringBJ(orderId)
    local orderString ---@type string 

    -- Check to see if it's a generic order.
    orderString = OrderId2String(orderId)
    if (orderString ~= nil) then
        return orderString
    end

    -- Check to see if it's a (train) unit order.
    orderString = UnitId2String(orderId)
    if (orderString ~= nil) then
        return orderString
    end

    -- Unrecognized - return an empty string.
    return ""
end

--===========================================================================
---@type fun():integer
function GetIssuedOrderIdBJ()
    return GetIssuedOrderId()
end

--===========================================================================
---@type fun():unit
function GetKillingUnitBJ()
    return GetKillingUnit()
end

--===========================================================================
---@type fun(id: player, unitid: integer, loc: location, face: number):unit
function CreateUnitAtLocSaveLast(id, unitid, loc, face)
    if (unitid == FourCC('ugol')) then
        bj_lastCreatedUnit = CreateBlightedGoldmine(id, GetLocationX(loc), GetLocationY(loc), face)
    else
        bj_lastCreatedUnit = CreateUnitAtLoc(id, unitid, loc, face)
    end

    return bj_lastCreatedUnit
end

--===========================================================================
---@type fun():unit
function GetLastCreatedUnit()
    return bj_lastCreatedUnit
end

--===========================================================================
---@type fun(count: integer, unitId: integer, whichPlayer: player, loc: location, face: number):group
function CreateNUnitsAtLoc(count, unitId, whichPlayer, loc, face)
    GroupClear(bj_lastCreatedGroup)
    while true do
        count = count - 1
        if count < 0 then break end
        CreateUnitAtLocSaveLast(whichPlayer, unitId, loc, face)
        GroupAddUnit(bj_lastCreatedGroup, bj_lastCreatedUnit)
    end
    return bj_lastCreatedGroup
end

--===========================================================================
---@type fun(count: integer, unitId: integer, whichPlayer: player, loc: location, lookAt: location):group
function CreateNUnitsAtLocFacingLocBJ(count, unitId, whichPlayer, loc, lookAt)
    return CreateNUnitsAtLoc(count, unitId, whichPlayer, loc, AngleBetweenPoints(loc, lookAt))
end

--===========================================================================
function GetLastCreatedGroupEnum()
    GroupAddUnit(bj_groupLastCreatedDest, GetEnumUnit())
end

--===========================================================================
---@type fun():group
function GetLastCreatedGroup()
    bj_groupLastCreatedDest = CreateGroup()
    ForGroup(bj_lastCreatedGroup, GetLastCreatedGroupEnum)
    return bj_groupLastCreatedDest
end

--===========================================================================
---@type fun(unitid: integer, whichPlayer: player, loc: location):unit
function CreateCorpseLocBJ(unitid, whichPlayer, loc)
    bj_lastCreatedUnit = CreateCorpse(whichPlayer, unitid, GetLocationX(loc), GetLocationY(loc), GetRandomReal(0, 360))
    return bj_lastCreatedUnit
end

--===========================================================================
---@type fun(suspend: boolean, whichUnit: unit)
function UnitSuspendDecayBJ(suspend, whichUnit)
    UnitSuspendDecay(whichUnit, suspend)
end

--===========================================================================
function DelayedSuspendDecayStopAnimEnum()
    local enumUnit      = GetEnumUnit() ---@type unit 

    if (GetUnitState(enumUnit, UNIT_STATE_LIFE) <= 0) then
        SetUnitTimeScale(enumUnit, 0.0001)
    end
end

--===========================================================================
function DelayedSuspendDecayBoneEnum()
    local enumUnit      = GetEnumUnit() ---@type unit 

    if (GetUnitState(enumUnit, UNIT_STATE_LIFE) <= 0) then
        UnitSuspendDecay(enumUnit, true)
        SetUnitTimeScale(enumUnit, 0.0001)
    end
end

--===========================================================================
-- Game code explicitly sets the animation back to "decay bone" after the
-- initial corpse fades away, so we reset it now.  It's best not to show
-- off corpses thus created until after this grace period has passed.
--
function DelayedSuspendDecayFleshEnum()
    local enumUnit      = GetEnumUnit() ---@type unit 

    if (GetUnitState(enumUnit, UNIT_STATE_LIFE) <= 0) then
        UnitSuspendDecay(enumUnit, true)
        SetUnitTimeScale(enumUnit, 10.0)
        SetUnitAnimation(enumUnit, "decay flesh")
    end
end

--===========================================================================
-- Waits a short period of time to ensure that the corpse is decaying, and
-- then suspend the animation and corpse decay.
--
function DelayedSuspendDecay()
    local boneGroup ---@type group 
    local fleshGroup ---@type group 

    -- Switch the global unit groups over to local variables and recreate
    -- the global versions, so that this function can handle overlapping
    -- calls.
    boneGroup = bj_suspendDecayBoneGroup
    fleshGroup = bj_suspendDecayFleshGroup
    bj_suspendDecayBoneGroup = CreateGroup()
    bj_suspendDecayFleshGroup = CreateGroup()

    ForGroup(fleshGroup, DelayedSuspendDecayStopAnimEnum)
    ForGroup(boneGroup, DelayedSuspendDecayStopAnimEnum)

    TriggerSleepAction(bj_CORPSE_MAX_DEATH_TIME)
    ForGroup(fleshGroup, DelayedSuspendDecayFleshEnum)
    ForGroup(boneGroup, DelayedSuspendDecayBoneEnum)

    TriggerSleepAction(0.05)
    ForGroup(fleshGroup, DelayedSuspendDecayStopAnimEnum)

    DestroyGroup(boneGroup)
    DestroyGroup(fleshGroup)
end

--===========================================================================
function DelayedSuspendDecayCreate()
    bj_delayedSuspendDecayTrig = CreateTrigger()
    TriggerRegisterTimerExpireEvent(bj_delayedSuspendDecayTrig, bj_delayedSuspendDecayTimer)
    TriggerAddAction(bj_delayedSuspendDecayTrig, DelayedSuspendDecay)
end

--===========================================================================
---@type fun(style: integer, unitid: integer, whichPlayer: player, loc: location, facing: number):unit
function CreatePermanentCorpseLocBJ(style, unitid, whichPlayer, loc, facing)
    bj_lastCreatedUnit = CreateCorpse(whichPlayer, unitid, GetLocationX(loc), GetLocationY(loc), facing)
    SetUnitBlendTime(bj_lastCreatedUnit, 0)

    if (style == bj_CORPSETYPE_FLESH) then
        SetUnitAnimation(bj_lastCreatedUnit, "decay flesh")
        GroupAddUnit(bj_suspendDecayFleshGroup, bj_lastCreatedUnit)
    elseif (style == bj_CORPSETYPE_BONE) then
        SetUnitAnimation(bj_lastCreatedUnit, "decay bone")
        GroupAddUnit(bj_suspendDecayBoneGroup, bj_lastCreatedUnit)
    else
        -- Unknown decay style - treat as skeletal.
        SetUnitAnimation(bj_lastCreatedUnit, "decay bone")
        GroupAddUnit(bj_suspendDecayBoneGroup, bj_lastCreatedUnit)
    end

    TimerStart(bj_delayedSuspendDecayTimer, 0.05, false, nil)
    return bj_lastCreatedUnit
end

--===========================================================================
---@type fun(whichState: unitstate, whichUnit: unit):number
function GetUnitStateSwap(whichState, whichUnit)
    return GetUnitState(whichUnit, whichState)
end

--===========================================================================
---@type fun(whichUnit: unit, whichState: unitstate, whichMaxState: unitstate):number
function GetUnitStatePercent(whichUnit, whichState, whichMaxState)
    local value         = GetUnitState(whichUnit, whichState) ---@type number 
    local maxValue      = GetUnitState(whichUnit, whichMaxState) ---@type number 

    -- Return 0 for null units.
    if (whichUnit == nil) or (maxValue == 0) then
        return 0.0
    end

    return value / maxValue * 100.0
end

--===========================================================================
---@type fun(whichUnit: unit):number
function GetUnitLifePercent(whichUnit)
    return GetUnitStatePercent(whichUnit, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE)
end

--===========================================================================
---@type fun(whichUnit: unit):number
function GetUnitManaPercent(whichUnit)
    return GetUnitStatePercent(whichUnit, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA)
end

--===========================================================================
---@type fun(whichUnit: unit)
function SelectUnitSingle(whichUnit)
    ClearSelection()
    SelectUnit(whichUnit, true)
end

--===========================================================================
function SelectGroupBJEnum()
    SelectUnit( GetEnumUnit(), true )
end

--===========================================================================
---@type fun(g: group)
function SelectGroupBJ(g)
    ClearSelection()
    ForGroup( g, SelectGroupBJEnum )
end

--===========================================================================
---@type fun(whichUnit: unit)
function SelectUnitAdd(whichUnit)
    SelectUnit(whichUnit, true)
end

--===========================================================================
---@type fun(whichUnit: unit)
function SelectUnitRemove(whichUnit)
    SelectUnit(whichUnit, false)
end

--===========================================================================
---@type fun(whichPlayer: player)
function ClearSelectionForPlayer(whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ClearSelection()
    end
end

--===========================================================================
---@type fun(whichUnit: unit, whichPlayer: player)
function SelectUnitForPlayerSingle(whichUnit, whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ClearSelection()
        SelectUnit(whichUnit, true)
    end
end

--===========================================================================
---@type fun(g: group, whichPlayer: player)
function SelectGroupForPlayerBJ(g, whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ClearSelection()
        ForGroup( g, SelectGroupBJEnum )
    end
end

--===========================================================================
---@type fun(whichUnit: unit, whichPlayer: player)
function SelectUnitAddForPlayer(whichUnit, whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SelectUnit(whichUnit, true)
    end
end

--===========================================================================
---@type fun(whichUnit: unit, whichPlayer: player)
function SelectUnitRemoveForPlayer(whichUnit, whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SelectUnit(whichUnit, false)
    end
end

--===========================================================================
---@type fun(whichUnit: unit, newValue: number)
function SetUnitLifeBJ(whichUnit, newValue)
    SetUnitState(whichUnit, UNIT_STATE_LIFE, RMaxBJ(0,newValue))
end

--===========================================================================
---@type fun(whichUnit: unit, newValue: number)
function SetUnitManaBJ(whichUnit, newValue)
    SetUnitState(whichUnit, UNIT_STATE_MANA, RMaxBJ(0,newValue))
end

--===========================================================================
---@type fun(whichUnit: unit, percent: number)
function SetUnitLifePercentBJ(whichUnit, percent)
    SetUnitState(whichUnit, UNIT_STATE_LIFE, GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) * RMaxBJ(0,percent) * 0.01)
end

--===========================================================================
---@type fun(whichUnit: unit, percent: number)
function SetUnitManaPercentBJ(whichUnit, percent)
    SetUnitState(whichUnit, UNIT_STATE_MANA, GetUnitState(whichUnit, UNIT_STATE_MAX_MANA) * RMaxBJ(0,percent) * 0.01)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitDeadBJ(whichUnit)
    return GetUnitState(whichUnit, UNIT_STATE_LIFE) <= 0
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitAliveBJ(whichUnit)
    return not IsUnitDeadBJ(whichUnit)
end

--===========================================================================
function IsUnitGroupDeadBJEnum()
    if not IsUnitDeadBJ(GetEnumUnit()) then
        bj_isUnitGroupDeadResult = false
    end
end

--===========================================================================
-- Returns true if every unit of the group is dead.
--
---@type fun(g: group):boolean
function IsUnitGroupDeadBJ(g)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_isUnitGroupDeadResult = true
    ForGroup(g, IsUnitGroupDeadBJEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(g)
    end
    return bj_isUnitGroupDeadResult
end

--===========================================================================
function IsUnitGroupEmptyBJEnum()
    bj_isUnitGroupEmptyResult = false
end

--===========================================================================
-- Returns true if the group contains no units.
--
---@type fun(g: group):boolean
function IsUnitGroupEmptyBJ(g)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_isUnitGroupEmptyResult = true
    ForGroup(g, IsUnitGroupEmptyBJEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(g)
    end
    return bj_isUnitGroupEmptyResult
end

--===========================================================================
function IsUnitGroupInRectBJEnum()
    if not RectContainsUnit(bj_isUnitGroupInRectRect, GetEnumUnit()) then
        bj_isUnitGroupInRectResult = false
    end
end

--===========================================================================
-- Returns true if every unit of the group is within the given rect.
--
---@type fun(g: group, r: rect):boolean
function IsUnitGroupInRectBJ(g, r)
    bj_isUnitGroupInRectResult = true
    bj_isUnitGroupInRectRect = r
    ForGroup(g, IsUnitGroupInRectBJEnum)
    return bj_isUnitGroupInRectResult
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitHiddenBJ(whichUnit)
    return IsUnitHidden(whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit)
function ShowUnitHide(whichUnit)
    ShowUnit(whichUnit, false)
end

--===========================================================================
---@type fun(whichUnit: unit)
function ShowUnitShow(whichUnit)
    -- Prevent dead heroes from being unhidden.
    if (IsUnitType(whichUnit, UNIT_TYPE_HERO) and IsUnitDeadBJ(whichUnit)) then
        return
    end

    ShowUnit(whichUnit, true)
end

--===========================================================================
---@type fun():boolean
function IssueHauntOrderAtLocBJFilter()
    return GetUnitTypeId(GetFilterUnit()) == FourCC('ngol')
end

--===========================================================================
---@type fun(whichPeon: unit, loc: location):boolean
function IssueHauntOrderAtLocBJ(whichPeon, loc)
    local g       = nil ---@type group 
    local goldMine      = nil ---@type unit 

    -- Search for a gold mine within a 1-cell radius of the specified location.
    g = CreateGroup()
    GroupEnumUnitsInRangeOfLoc(g, loc, 2*bj_CELLWIDTH, filterIssueHauntOrderAtLocBJ)
    goldMine = FirstOfGroup(g)
    DestroyGroup(g)

    -- If no mine was found, abort the request.
    if (goldMine == nil) then
        return false
    end

    -- Issue the Haunt Gold Mine order.
    return IssueTargetOrderById(whichPeon, FourCC('ugol'), goldMine)
end

--===========================================================================
---@type fun(whichPeon: unit, unitId: integer, loc: location):boolean
function IssueBuildOrderByIdLocBJ(whichPeon, unitId, loc)
    if (unitId == FourCC('ugol')) then
        return IssueHauntOrderAtLocBJ(whichPeon, loc)
    else
        return IssueBuildOrderById(whichPeon, unitId, GetLocationX(loc), GetLocationY(loc))
    end
end

--===========================================================================
---@type fun(whichUnit: unit, unitId: integer):boolean
function IssueTrainOrderByIdBJ(whichUnit, unitId)
    return IssueImmediateOrderById(whichUnit, unitId)
end

--===========================================================================
---@type fun(g: group, unitId: integer):boolean
function GroupTrainOrderByIdBJ(g, unitId)
    return GroupImmediateOrderById(g, unitId)
end

--===========================================================================
---@type fun(whichUnit: unit, techId: integer):boolean
function IssueUpgradeOrderByIdBJ(whichUnit, techId)
    return IssueImmediateOrderById(whichUnit, techId)
end

--===========================================================================
---@type fun():unit
function GetAttackedUnitBJ()
    return GetTriggerUnit()
end

--===========================================================================
---@type fun(whichUnit: unit, newHeight: number, rate: number)
function SetUnitFlyHeightBJ(whichUnit, newHeight, rate)
    SetUnitFlyHeight(whichUnit, newHeight, rate)
end

--===========================================================================
---@type fun(whichUnit: unit, turnSpeed: number)
function SetUnitTurnSpeedBJ(whichUnit, turnSpeed)
    SetUnitTurnSpeed(whichUnit, turnSpeed)
end

--===========================================================================
---@type fun(whichUnit: unit, propWindow: number)
function SetUnitPropWindowBJ(whichUnit, propWindow)
    local angle      = propWindow ---@type number 
    if (angle <= 0) then
        angle = 1
    elseif (angle >= 360) then
        angle = 359
    end
    angle = angle * bj_DEGTORAD

    SetUnitPropWindow(whichUnit, angle)
end

--===========================================================================
---@type fun(whichUnit: unit):number
function GetUnitPropWindowBJ(whichUnit)
    return GetUnitPropWindow(whichUnit) * bj_RADTODEG
end

--===========================================================================
---@type fun(whichUnit: unit):number
function GetUnitDefaultPropWindowBJ(whichUnit)
    return GetUnitDefaultPropWindow(whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit, blendTime: number)
function SetUnitBlendTimeBJ(whichUnit, blendTime)
    SetUnitBlendTime(whichUnit, blendTime)
end

--===========================================================================
---@type fun(whichUnit: unit, acquireRange: number)
function SetUnitAcquireRangeBJ(whichUnit, acquireRange)
    SetUnitAcquireRange(whichUnit, acquireRange)
end

--===========================================================================
---@type fun(whichUnit: unit, canSleep: boolean)
function UnitSetCanSleepBJ(whichUnit, canSleep)
    UnitAddSleep(whichUnit, canSleep)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function UnitCanSleepBJ(whichUnit)
    return UnitCanSleep(whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit)
function UnitWakeUpBJ(whichUnit)
    UnitWakeUp(whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function UnitIsSleepingBJ(whichUnit)
    return UnitIsSleeping(whichUnit)
end

--===========================================================================
function WakePlayerUnitsEnum()
    UnitWakeUp(GetEnumUnit())
end

--===========================================================================
---@type fun(whichPlayer: player)
function WakePlayerUnits(whichPlayer)
    local g       = CreateGroup() ---@type group 
    GroupEnumUnitsOfPlayer(g, whichPlayer, nil)
    ForGroup(g, WakePlayerUnitsEnum)
    DestroyGroup(g)
end

--===========================================================================
---@type fun(enable: boolean)
function EnableCreepSleepBJ(enable)
    SetPlayerState(Player(PLAYER_NEUTRAL_AGGRESSIVE), PLAYER_STATE_NO_CREEP_SLEEP, IntegerTertiaryOp(enable, 0, 1))

    -- If we're disabling, attempt to wake any already-sleeping creeps.
    if (not enable) then
        WakePlayerUnits(Player(PLAYER_NEUTRAL_AGGRESSIVE))
    end
end

--===========================================================================
---@type fun(whichUnit: unit, generate: boolean):boolean
function UnitGenerateAlarms(whichUnit, generate)
    return UnitIgnoreAlarm(whichUnit, not generate)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function DoesUnitGenerateAlarms(whichUnit)
    return not UnitIgnoreAlarmToggled(whichUnit)
end

--===========================================================================
function PauseAllUnitsBJEnum()
    PauseUnit( GetEnumUnit(), bj_pauseAllUnitsFlag )
end

--===========================================================================
-- Pause all units 
---@type fun(pause: boolean)
function PauseAllUnitsBJ(pause)
    local index ---@type integer 
    local indexPlayer ---@type player 
    local g ---@type group 

    bj_pauseAllUnitsFlag = pause
    g = CreateGroup()
    index = 0
    repeat
        indexPlayer = Player( index )

        -- If this is a computer slot, pause/resume the AI.
        if (GetPlayerController( indexPlayer ) == MAP_CONTROL_COMPUTER) then
            PauseCompAI( indexPlayer, pause )
        end

        -- Enumerate and unpause every unit owned by the player.
        GroupEnumUnitsOfPlayer( g, indexPlayer, nil )
        ForGroup( g, PauseAllUnitsBJEnum )
        GroupClear( g )

        index = index + 1
    until index == bj_MAX_PLAYER_SLOTS
    DestroyGroup(g)
end

--===========================================================================
---@type fun(pause: boolean, whichUnit: unit)
function PauseUnitBJ(pause, whichUnit)
    PauseUnit(whichUnit, pause)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitPausedBJ(whichUnit)
    return IsUnitPaused(whichUnit)
end

--===========================================================================
---@type fun(flag: boolean, whichUnit: unit)
function UnitPauseTimedLifeBJ(flag, whichUnit)
    UnitPauseTimedLife(whichUnit, flag)
end

--===========================================================================
---@type fun(duration: number, buffId: integer, whichUnit: unit)
function UnitApplyTimedLifeBJ(duration, buffId, whichUnit)
    UnitApplyTimedLife(whichUnit, buffId, duration)
end

--===========================================================================
---@type fun(share: boolean, whichUnit: unit, whichPlayer: player)
function UnitShareVisionBJ(share, whichUnit, whichPlayer)
    UnitShareVision(whichUnit, whichPlayer, share)
end

--===========================================================================
---@type fun(buffType: integer, whichUnit: unit)
function UnitRemoveBuffsBJ(buffType, whichUnit)
    if (buffType == bj_REMOVEBUFFS_POSITIVE) then
        UnitRemoveBuffs(whichUnit, true, false)
    elseif (buffType == bj_REMOVEBUFFS_NEGATIVE) then
        UnitRemoveBuffs(whichUnit, false, true)
    elseif (buffType == bj_REMOVEBUFFS_ALL) then
        UnitRemoveBuffs(whichUnit, true, true)
    elseif (buffType == bj_REMOVEBUFFS_NONTLIFE) then
        UnitRemoveBuffsEx(whichUnit, true, true, false, false, false, true, false)
    else
        -- Unrecognized dispel type - ignore the request.
    end
end

--===========================================================================
---@type fun(polarity: integer, resist: integer, whichUnit: unit, bTLife: boolean, bAura: boolean)
function UnitRemoveBuffsExBJ(polarity, resist, whichUnit, bTLife, bAura)
    local bPos           = (polarity == bj_BUFF_POLARITY_EITHER) or (polarity == bj_BUFF_POLARITY_POSITIVE) ---@type boolean 
    local bNeg           = (polarity == bj_BUFF_POLARITY_EITHER) or (polarity == bj_BUFF_POLARITY_NEGATIVE) ---@type boolean 
    local bMagic         = (resist == bj_BUFF_RESIST_BOTH) or (resist == bj_BUFF_RESIST_MAGIC) ---@type boolean 
    local bPhys          = (resist == bj_BUFF_RESIST_BOTH) or (resist == bj_BUFF_RESIST_PHYSICAL) ---@type boolean 

    UnitRemoveBuffsEx(whichUnit, bPos, bNeg, bMagic, bPhys, bTLife, bAura, false)
end

--===========================================================================
---@type fun(polarity: integer, resist: integer, whichUnit: unit, bTLife: boolean, bAura: boolean):integer
function UnitCountBuffsExBJ(polarity, resist, whichUnit, bTLife, bAura)
    local bPos           = (polarity == bj_BUFF_POLARITY_EITHER) or (polarity == bj_BUFF_POLARITY_POSITIVE) ---@type boolean 
    local bNeg           = (polarity == bj_BUFF_POLARITY_EITHER) or (polarity == bj_BUFF_POLARITY_NEGATIVE) ---@type boolean 
    local bMagic         = (resist == bj_BUFF_RESIST_BOTH) or (resist == bj_BUFF_RESIST_MAGIC) ---@type boolean 
    local bPhys          = (resist == bj_BUFF_RESIST_BOTH) or (resist == bj_BUFF_RESIST_PHYSICAL) ---@type boolean 

    return UnitCountBuffsEx(whichUnit, bPos, bNeg, bMagic, bPhys, bTLife, bAura, false)
end

--===========================================================================
---@type fun(abilityId: integer, whichUnit: unit):boolean
function UnitRemoveAbilityBJ(abilityId, whichUnit)
    return UnitRemoveAbility(whichUnit, abilityId)
end

--===========================================================================
---@type fun(abilityId: integer, whichUnit: unit):boolean
function UnitAddAbilityBJ(abilityId, whichUnit)
    return UnitAddAbility(whichUnit, abilityId)
end

--===========================================================================
---@type fun(whichType: unittype, whichUnit: unit):boolean
function UnitRemoveTypeBJ(whichType, whichUnit)
    return UnitRemoveType(whichUnit, whichType)
end

--===========================================================================
---@type fun(whichType: unittype, whichUnit: unit):boolean
function UnitAddTypeBJ(whichType, whichUnit)
    return UnitAddType(whichUnit, whichType)
end

--===========================================================================
---@type fun(permanent: boolean, abilityId: integer, whichUnit: unit):boolean
function UnitMakeAbilityPermanentBJ(permanent, abilityId, whichUnit)
    return UnitMakeAbilityPermanent(whichUnit, permanent, abilityId)
end

--===========================================================================
---@type fun(whichUnit: unit, exploded: boolean)
function SetUnitExplodedBJ(whichUnit, exploded)
    SetUnitExploded(whichUnit, exploded)
end

--===========================================================================
---@type fun(whichUnit: unit)
function ExplodeUnitBJ(whichUnit)
    SetUnitExploded(whichUnit, true)
    KillUnit(whichUnit)
end

--===========================================================================
---@type fun():unit
function GetTransportUnitBJ()
    return GetTransportUnit()
end

--===========================================================================
---@type fun():unit
function GetLoadedUnitBJ()
    return GetLoadedUnit()
end

--===========================================================================
---@type fun(whichUnit: unit, whichTransport: unit):boolean
function IsUnitInTransportBJ(whichUnit, whichTransport)
    return IsUnitInTransport(whichUnit, whichTransport)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitLoadedBJ(whichUnit)
    return IsUnitLoaded(whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit):boolean
function IsUnitIllusionBJ(whichUnit)
    return IsUnitIllusion(whichUnit)
end

--===========================================================================
-- This attempts to replace a unit with a new unit type by creating a new
-- unit of the desired type using the old unit's location, facing, etc.
--
---@type fun(whichUnit: unit, newUnitId: integer, unitStateMethod: integer):unit
function ReplaceUnitBJ(whichUnit, newUnitId, unitStateMethod)
    local oldUnit         = whichUnit ---@type unit 
    local newUnit ---@type unit 
    local wasHidden ---@type boolean 
    local index ---@type integer 
    local indexItem ---@type item 
    local oldRatio ---@type number 

    -- If we have bogus data, don't attempt the replace.
    if (oldUnit == nil) then
        bj_lastReplacedUnit = oldUnit
        return oldUnit
    end

    -- Hide the original unit.
    wasHidden = IsUnitHidden(oldUnit)
    ShowUnit(oldUnit, false)

    -- Create the replacement unit.
    if (newUnitId == FourCC('ugol')) then
        newUnit = CreateBlightedGoldmine(GetOwningPlayer(oldUnit), GetUnitX(oldUnit), GetUnitY(oldUnit), GetUnitFacing(oldUnit))
    else
        newUnit = CreateUnit(GetOwningPlayer(oldUnit), newUnitId, GetUnitX(oldUnit), GetUnitY(oldUnit), GetUnitFacing(oldUnit))
    end

    -- Set the unit's life and mana according to the requested method.
    if (unitStateMethod == bj_UNIT_STATE_METHOD_RELATIVE) then
        -- Set the replacement's current/max life ratio to that of the old unit.
        -- If both units have mana, do the same for mana.
        if (GetUnitState(oldUnit, UNIT_STATE_MAX_LIFE) > 0) then
            oldRatio = GetUnitState(oldUnit, UNIT_STATE_LIFE) / GetUnitState(oldUnit, UNIT_STATE_MAX_LIFE)
            SetUnitState(newUnit, UNIT_STATE_LIFE, oldRatio * GetUnitState(newUnit, UNIT_STATE_MAX_LIFE))
        end

        if (GetUnitState(oldUnit, UNIT_STATE_MAX_MANA) > 0) and (GetUnitState(newUnit, UNIT_STATE_MAX_MANA) > 0) then
            oldRatio = GetUnitState(oldUnit, UNIT_STATE_MANA) / GetUnitState(oldUnit, UNIT_STATE_MAX_MANA)
            SetUnitState(newUnit, UNIT_STATE_MANA, oldRatio * GetUnitState(newUnit, UNIT_STATE_MAX_MANA))
        end
    elseif (unitStateMethod == bj_UNIT_STATE_METHOD_ABSOLUTE) then
        -- Set the replacement's current life to that of the old unit.
        -- If the new unit has mana, do the same for mana.
        SetUnitState(newUnit, UNIT_STATE_LIFE, GetUnitState(oldUnit, UNIT_STATE_LIFE))
        if (GetUnitState(newUnit, UNIT_STATE_MAX_MANA) > 0) then
            SetUnitState(newUnit, UNIT_STATE_MANA, GetUnitState(oldUnit, UNIT_STATE_MANA))
        end
    elseif (unitStateMethod == bj_UNIT_STATE_METHOD_DEFAULTS) then
        -- The newly created unit should already have default life and mana.
    elseif (unitStateMethod == bj_UNIT_STATE_METHOD_MAXIMUM) then
        -- Use max life and mana.
        SetUnitState(newUnit, UNIT_STATE_LIFE, GetUnitState(newUnit, UNIT_STATE_MAX_LIFE))
        SetUnitState(newUnit, UNIT_STATE_MANA, GetUnitState(newUnit, UNIT_STATE_MAX_MANA))
    else
        -- Unrecognized unit state method - ignore the request.
    end

    -- Mirror properties of the old unit onto the new unit.
    --call PauseUnit(newUnit, IsUnitPaused(oldUnit))
    SetResourceAmount(newUnit, GetResourceAmount(oldUnit))

    -- If both the old and new units are heroes, handle their hero info.
    if (IsUnitType(oldUnit, UNIT_TYPE_HERO) and IsUnitType(newUnit, UNIT_TYPE_HERO)) then
        SetHeroXP(newUnit, GetHeroXP(oldUnit), false)

        index = 0
        repeat
            indexItem = UnitItemInSlot(oldUnit, index)
            if (indexItem ~= nil) then
                UnitRemoveItem(oldUnit, indexItem)
                UnitAddItem(newUnit, indexItem)
            end

            index = index + 1
        until index >= bj_MAX_INVENTORY
    end

    -- Remove or kill the original unit.  It is sometimes unsafe to remove
    -- hidden units, so kill the original unit if it was previously hidden.
    if wasHidden then
        KillUnit(oldUnit)
        RemoveUnit(oldUnit)
    else
        RemoveUnit(oldUnit)
    end

    bj_lastReplacedUnit = newUnit
    return newUnit
end

--===========================================================================
---@type fun():unit
function GetLastReplacedUnitBJ()
    return bj_lastReplacedUnit
end

--===========================================================================
---@type fun(whichUnit: unit, loc: location, facing: number)
function SetUnitPositionLocFacingBJ(whichUnit, loc, facing)
    SetUnitPositionLoc(whichUnit, loc)
    SetUnitFacing(whichUnit, facing)
end

--===========================================================================
---@type fun(whichUnit: unit, loc: location, lookAt: location)
function SetUnitPositionLocFacingLocBJ(whichUnit, loc, lookAt)
    SetUnitPositionLoc(whichUnit, loc)
    SetUnitFacing(whichUnit, AngleBetweenPoints(loc, lookAt))
end

--===========================================================================
---@type fun(itemId: integer, whichUnit: unit, currentStock: integer, stockMax: integer)
function AddItemToStockBJ(itemId, whichUnit, currentStock, stockMax)
    AddItemToStock(whichUnit, itemId, currentStock, stockMax)
end

--===========================================================================
---@type fun(unitId: integer, whichUnit: unit, currentStock: integer, stockMax: integer)
function AddUnitToStockBJ(unitId, whichUnit, currentStock, stockMax)
    AddUnitToStock(whichUnit, unitId, currentStock, stockMax)
end

--===========================================================================
---@type fun(itemId: integer, whichUnit: unit)
function RemoveItemFromStockBJ(itemId, whichUnit)
    RemoveItemFromStock(whichUnit, itemId)
end

--===========================================================================
---@type fun(unitId: integer, whichUnit: unit)
function RemoveUnitFromStockBJ(unitId, whichUnit)
    RemoveUnitFromStock(whichUnit, unitId)
end

--===========================================================================
---@type fun(enable: boolean, whichUnit: unit)
function SetUnitUseFoodBJ(enable, whichUnit)
    SetUnitUseFood(whichUnit, enable)
end

--===========================================================================
---@type fun(whichUnit: unit, delay: number, radius: number, loc: location, amount: number, whichAttack: attacktype, whichDamage: damagetype):boolean
function UnitDamagePointLoc(whichUnit, delay, radius, loc, amount, whichAttack, whichDamage)
    return UnitDamagePoint(whichUnit, delay, radius, GetLocationX(loc), GetLocationY(loc), amount, true, false, whichAttack, whichDamage, WEAPON_TYPE_WHOKNOWS)
end

--===========================================================================
---@type fun(whichUnit: unit, target: unit, amount: number, whichAttack: attacktype, whichDamage: damagetype):boolean
function UnitDamageTargetBJ(whichUnit, target, amount, whichAttack, whichDamage)
    return UnitDamageTarget(whichUnit, target, amount, true, false, whichAttack, whichDamage, WEAPON_TYPE_WHOKNOWS)
end



--***************************************************************************
--*
--*  Destructable Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(objectid: integer, loc: location, facing: number, scale: number, variation: integer):destructable
function CreateDestructableLoc(objectid, loc, facing, scale, variation)
    bj_lastCreatedDestructable = CreateDestructable(objectid, GetLocationX(loc), GetLocationY(loc), facing, scale, variation)
    return bj_lastCreatedDestructable
end

--===========================================================================
---@type fun(objectid: integer, loc: location, facing: number, scale: number, variation: integer):destructable
function CreateDeadDestructableLocBJ(objectid, loc, facing, scale, variation)
    bj_lastCreatedDestructable = CreateDeadDestructable(objectid, GetLocationX(loc), GetLocationY(loc), facing, scale, variation)
    return bj_lastCreatedDestructable
end

--===========================================================================
---@type fun():destructable
function GetLastCreatedDestructable()
    return bj_lastCreatedDestructable
end

--===========================================================================
---@type fun(flag: boolean, d: destructable)
function ShowDestructableBJ(flag, d)
    ShowDestructable(d, flag)
end

--===========================================================================
---@type fun(d: destructable, flag: boolean)
function SetDestructableInvulnerableBJ(d, flag)
    SetDestructableInvulnerable(d, flag)
end

--===========================================================================
---@type fun(d: destructable):boolean
function IsDestructableInvulnerableBJ(d)
    return IsDestructableInvulnerable(d)
end

--===========================================================================
---@type fun(whichDestructable: destructable):location
function GetDestructableLoc(whichDestructable)
    return Location(GetDestructableX(whichDestructable), GetDestructableY(whichDestructable))
end

--===========================================================================
---@type fun(r: rect, actionFunc: function)
function EnumDestructablesInRectAll(r, actionFunc)
    EnumDestructablesInRect(r, nil, actionFunc)
end

--===========================================================================
---@type fun():boolean
function EnumDestructablesInCircleBJFilter()
    local destLoc          = GetDestructableLoc(GetFilterDestructable()) ---@type location 
    local result ---@type boolean 

    result = DistanceBetweenPoints(destLoc, bj_enumDestructableCenter) <= bj_enumDestructableRadius
    RemoveLocation(destLoc)
    return result
end

--===========================================================================
---@type fun(d: destructable):boolean
function IsDestructableDeadBJ(d)
    return GetDestructableLife(d) <= 0
end

--===========================================================================
---@type fun(d: destructable):boolean
function IsDestructableAliveBJ(d)
    return not IsDestructableDeadBJ(d)
end

--===========================================================================
-- See GroupPickRandomUnitEnum for the details of this algorithm.
--
function RandomDestructableInRectBJEnum()
    bj_destRandomConsidered = bj_destRandomConsidered + 1
    if (GetRandomInt(1,bj_destRandomConsidered) == 1) then
        bj_destRandomCurrentPick = GetEnumDestructable()
    end
end

--===========================================================================
-- Picks a random destructable from within a rect, matching a condition
--
---@type fun(r: rect, filter?: boolexpr):destructable
function RandomDestructableInRectBJ(r, filter)
    bj_destRandomConsidered = 0
    bj_destRandomCurrentPick = nil
    EnumDestructablesInRect(r, filter, RandomDestructableInRectBJEnum)
    DestroyBoolExpr(filter)
    return bj_destRandomCurrentPick
end

--===========================================================================
-- Picks a random destructable from within a rect
--
---@type fun(r: rect):destructable
function RandomDestructableInRectSimpleBJ(r)
    return RandomDestructableInRectBJ(r, nil)
end

--===========================================================================
-- Enumerates within a rect, with a filter to narrow the enumeration down
-- objects within a circular area.
--
---@type fun(radius: number, loc: location, actionFunc: function)
function EnumDestructablesInCircleBJ(radius, loc, actionFunc)
    local r ---@type rect 

    if (radius >= 0) then
        bj_enumDestructableCenter = loc
        bj_enumDestructableRadius = radius
        r = GetRectFromCircleBJ(loc, radius)
        EnumDestructablesInRect(r, filterEnumDestructablesInCircleBJ, actionFunc)
        RemoveRect(r)
    end
end

--===========================================================================
---@type fun(d: destructable, percent: number)
function SetDestructableLifePercentBJ(d, percent)
    SetDestructableLife(d, GetDestructableMaxLife(d) * percent * 0.01)
end

--===========================================================================
---@type fun(d: destructable, max: number)
function SetDestructableMaxLifeBJ(d, max)
    SetDestructableMaxLife(d, max)
end

--===========================================================================
---@type fun(gateOperation: integer, d: destructable)
function ModifyGateBJ(gateOperation, d)
    if (gateOperation == bj_GATEOPERATION_CLOSE) then
        if (GetDestructableLife(d) <= 0) then
            DestructableRestoreLife(d, GetDestructableMaxLife(d), true)
        end
        SetDestructableAnimation(d, "stand")
    elseif (gateOperation == bj_GATEOPERATION_OPEN) then
        if (GetDestructableLife(d) > 0) then
            KillDestructable(d)
        end
        SetDestructableAnimation(d, "death alternate")
    elseif (gateOperation == bj_GATEOPERATION_DESTROY) then
        if (GetDestructableLife(d) > 0) then
            KillDestructable(d)
        end
        SetDestructableAnimation(d, "death")
    else
        -- Unrecognized gate state - ignore the request.
    end
end

--===========================================================================
-- Determine the elevator's height from its occlusion height.
--
---@type fun(d: destructable):integer
function GetElevatorHeight(d)
    local height ---@type integer 

    height = 1 + R2I(GetDestructableOccluderHeight(d) // bj_CLIFFHEIGHT)
    if (height < 1) or (height > 3) then
        height = 1
    end
    return height
end

--===========================================================================
-- To properly animate an elevator, we must know not only what height we
-- want to change to, but also what height we are currently at.  This code
-- determines the elevator's current height from its occlusion height.
-- Arbitrarily changing an elevator's occlusion height is thus inadvisable.
--
---@type fun(d: destructable, newHeight: integer)
function ChangeElevatorHeight(d, newHeight)
    local oldHeight ---@type integer 

    -- Cap the new height within the supported range.
    newHeight = IMaxBJ(1, newHeight)
    newHeight = IMinBJ(3, newHeight)

    -- Find out what height the elevator is already at.
    oldHeight = GetElevatorHeight(d)

    -- Set the elevator's occlusion height.
    SetDestructableOccluderHeight(d, bj_CLIFFHEIGHT*(newHeight-1))

    if (newHeight == 1) then
        if (oldHeight == 2) then
            SetDestructableAnimation(d, "birth")
            QueueDestructableAnimation(d, "stand")
        elseif (oldHeight == 3) then
            SetDestructableAnimation(d, "birth third")
            QueueDestructableAnimation(d, "stand")
        else
            -- Unrecognized old height - snap to new height.
            SetDestructableAnimation(d, "stand")
        end
    elseif (newHeight == 2) then
        if (oldHeight == 1) then
            SetDestructableAnimation(d, "death")
            QueueDestructableAnimation(d, "stand second")
        elseif (oldHeight == 3) then
            SetDestructableAnimation(d, "birth second")
            QueueDestructableAnimation(d, "stand second")
        else
            -- Unrecognized old height - snap to new height.
            SetDestructableAnimation(d, "stand second")
        end
    elseif (newHeight == 3) then
        if (oldHeight == 1) then
            SetDestructableAnimation(d, "death third")
            QueueDestructableAnimation(d, "stand third")
        elseif (oldHeight == 2) then
            SetDestructableAnimation(d, "death second")
            QueueDestructableAnimation(d, "stand third")
        else
            -- Unrecognized old height - snap to new height.
            SetDestructableAnimation(d, "stand third")
        end
    else
        -- Unrecognized new height - ignore the request.
    end
end

--===========================================================================
-- Grab the unit and throw his own coords in his face, forcing him to push
-- and shove until he finds a spot where noone will bother him.
--
function NudgeUnitsInRectEnum()
    local nudgee      = GetEnumUnit() ---@type unit 

    SetUnitPosition(nudgee, GetUnitX(nudgee), GetUnitY(nudgee))
end

--===========================================================================
function NudgeItemsInRectEnum()
    local nudgee      = GetEnumItem() ---@type item 

    SetItemPosition(nudgee, GetItemX(nudgee), GetItemY(nudgee))
end

--===========================================================================
-- Nudge the items and units within a given rect ever so gently, so as to
-- encourage them to find locations where they can peacefully coexist with
-- pathing restrictions and live happy, fruitful lives.
--
---@type fun(nudgeArea: rect)
function NudgeObjectsInRect(nudgeArea)
    local g ---@type group 

    g = CreateGroup()
    GroupEnumUnitsInRect(g, nudgeArea, nil)
    ForGroup(g, NudgeUnitsInRectEnum)
    DestroyGroup(g)

    EnumItemsInRect(nudgeArea, nil, NudgeItemsInRectEnum)
end

--===========================================================================
function NearbyElevatorExistsEnum()
    local d                  = GetEnumDestructable() ---@type destructable 
    local dType              = GetDestructableTypeId(d) ---@type integer 

    if (dType == bj_ELEVATOR_CODE01) or (dType == bj_ELEVATOR_CODE02) then
        bj_elevatorNeighbor = d
    end
end

--===========================================================================
---@type fun(x: number, y: number):boolean
function NearbyElevatorExists(x, y)
    local findThreshold      = 32 ---@type number 
    local r ---@type rect 

    -- If another elevator is overlapping this one, ignore the wall.
    r = Rect(x - findThreshold, y - findThreshold, x + findThreshold, y + findThreshold)
    bj_elevatorNeighbor = nil
    EnumDestructablesInRect(r, nil, NearbyElevatorExistsEnum)
    RemoveRect(r)

    return bj_elevatorNeighbor ~= nil
end

--===========================================================================
function FindElevatorWallBlockerEnum()
    bj_elevatorWallBlocker = GetEnumDestructable()
end

--===========================================================================
-- This toggles pathing on or off for one wall of an elevator by killing
-- or reviving a pathing blocker at the appropriate location (and creating
-- the pathing blocker in the first place, if it does not yet exist).
--
---@type fun(x: number, y: number, facing: number, open: boolean)
function ChangeElevatorWallBlocker(x, y, facing, open)
    local blocker              = nil ---@type destructable 
    local findThreshold              = 32 ---@type number 
    local nudgeLength                = 4.25 * bj_CELLWIDTH ---@type number 
    local nudgeWidth                 = 1.25 * bj_CELLWIDTH ---@type number 
    local r ---@type rect 

    -- Search for the pathing blocker within the general area.
    r = Rect(x - findThreshold, y - findThreshold, x + findThreshold, y + findThreshold)
    bj_elevatorWallBlocker = nil
    EnumDestructablesInRect(r, nil, FindElevatorWallBlockerEnum)
    RemoveRect(r)
    blocker = bj_elevatorWallBlocker

    -- Ensure that the blocker exists.
    if (blocker == nil) then
        blocker = CreateDeadDestructable(bj_ELEVATOR_BLOCKER_CODE, x, y, facing, 1, 0)
    elseif (GetDestructableTypeId(blocker) ~= bj_ELEVATOR_BLOCKER_CODE) then
        -- If a different destructible exists in the blocker's spot, ignore
        -- the request.  (Two destructibles cannot occupy the same location
        -- on the map, so we cannot create an elevator blocker here.)
        return
    end

    if (open) then
        -- Ensure that the blocker is dead.
        if (GetDestructableLife(blocker) > 0) then
            KillDestructable(blocker)
        end
    else
        -- Ensure that the blocker is alive.
        if (GetDestructableLife(blocker) <= 0) then
            DestructableRestoreLife(blocker, GetDestructableMaxLife(blocker), false)
        end

        -- Nudge any objects standing in the blocker's way.
        if (facing == 0) then
            r = Rect(x - nudgeWidth/2, y - nudgeLength/2, x + nudgeWidth/2, y + nudgeLength/2)
            NudgeObjectsInRect(r)
            RemoveRect(r)
        elseif (facing == 90) then
            r = Rect(x - nudgeLength/2, y - nudgeWidth/2, x + nudgeLength/2, y + nudgeWidth/2)
            NudgeObjectsInRect(r)
            RemoveRect(r)
        else
            -- Unrecognized blocker angle - don't nudge anything.
        end
    end
end

--===========================================================================
---@type fun(open: boolean, walls: integer, d: destructable)
function ChangeElevatorWalls(open, walls, d)
    local x      = GetDestructableX(d) ---@type number 
    local y      = GetDestructableY(d) ---@type number 
    local distToBlocker      = 192 ---@type number 
    local distToNeighbor      = 256 ---@type number 

    if (walls == bj_ELEVATOR_WALL_TYPE_ALL) or (walls == bj_ELEVATOR_WALL_TYPE_EAST) then
        if (not NearbyElevatorExists(x + distToNeighbor, y)) then
            ChangeElevatorWallBlocker(x + distToBlocker, y, 0, open)
        end
    end

    if (walls == bj_ELEVATOR_WALL_TYPE_ALL) or (walls == bj_ELEVATOR_WALL_TYPE_NORTH) then
        if (not NearbyElevatorExists(x, y + distToNeighbor)) then
            ChangeElevatorWallBlocker(x, y + distToBlocker, 90, open)
        end
    end

    if (walls == bj_ELEVATOR_WALL_TYPE_ALL) or (walls == bj_ELEVATOR_WALL_TYPE_SOUTH) then
        if (not NearbyElevatorExists(x, y - distToNeighbor)) then
            ChangeElevatorWallBlocker(x, y - distToBlocker, 90, open)
        end
    end

    if (walls == bj_ELEVATOR_WALL_TYPE_ALL) or (walls == bj_ELEVATOR_WALL_TYPE_WEST) then
        if (not NearbyElevatorExists(x - distToNeighbor, y)) then
            ChangeElevatorWallBlocker(x - distToBlocker, y, 0, open)
        end
    end
end



--***************************************************************************
--*
--*  Neutral Building Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(activate: boolean, waygate: unit)
function WaygateActivateBJ(activate, waygate)
    WaygateActivate(waygate, activate)
end

--===========================================================================
---@type fun(waygate: unit):boolean
function WaygateIsActiveBJ(waygate)
    return WaygateIsActive(waygate)
end

--===========================================================================
---@type fun(waygate: unit, loc: location)
function WaygateSetDestinationLocBJ(waygate, loc)
    WaygateSetDestination(waygate, GetLocationX(loc), GetLocationY(loc))
end

--===========================================================================
---@type fun(waygate: unit):location
function WaygateGetDestinationLocBJ(waygate)
    return Location(WaygateGetDestinationX(waygate), WaygateGetDestinationY(waygate))
end

--===========================================================================
---@type fun(flag: boolean, whichUnit: unit)
function UnitSetUsesAltIconBJ(flag, whichUnit)
    UnitSetUsesAltIcon(whichUnit, flag)
end



--***************************************************************************
--*
--*  UI Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(whichPlayer: player, key: string)
function ForceUIKeyBJ(whichPlayer, key)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ForceUIKey(key)
    end
end

--===========================================================================
---@type fun(whichPlayer: player)
function ForceUICancelBJ(whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ForceUICancel()
    end
end



--***************************************************************************
--*
--*  Group and Force Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(whichGroup: group, callback: function)
function ForGroupBJ(whichGroup, callback)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    ForGroup(whichGroup, callback)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(whichGroup)
    end
end

--===========================================================================
---@type fun(whichUnit: unit, whichGroup: group)
function GroupAddUnitSimple(whichUnit, whichGroup)
    GroupAddUnit(whichGroup, whichUnit)
end

--===========================================================================
---@type fun(whichUnit: unit, whichGroup: group)
function GroupRemoveUnitSimple(whichUnit, whichGroup)
    GroupRemoveUnit(whichGroup, whichUnit)
end

--===========================================================================
function GroupAddGroupEnum()
    GroupAddUnit(bj_groupAddGroupDest, GetEnumUnit())
end

--===========================================================================
---@type fun(sourceGroup: group, destGroup: group)
function GroupAddGroup(sourceGroup, destGroup)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_groupAddGroupDest = destGroup
    ForGroup(sourceGroup, GroupAddGroupEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(sourceGroup)
    end
end

--===========================================================================
function GroupRemoveGroupEnum()
    GroupRemoveUnit(bj_groupRemoveGroupDest, GetEnumUnit())
end

--===========================================================================
---@type fun(sourceGroup: group, destGroup: group)
function GroupRemoveGroup(sourceGroup, destGroup)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_groupRemoveGroupDest = destGroup
    ForGroup(sourceGroup, GroupRemoveGroupEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(sourceGroup)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, whichForce: force)
function ForceAddPlayerSimple(whichPlayer, whichForce)
    ForceAddPlayer(whichForce, whichPlayer)
end

--===========================================================================
---@type fun(whichPlayer: player, whichForce: force)
function ForceRemovePlayerSimple(whichPlayer, whichForce)
    ForceRemovePlayer(whichForce, whichPlayer)
end

--===========================================================================
-- Consider each unit, one at a time, keeping a "current pick".   Once all units
-- are considered, this "current pick" will be the resulting random unit.
--
-- The chance of picking a given unit over the "current pick" is 1/N, where N is
-- the number of units considered thusfar (including the current consideration).
--
function GroupPickRandomUnitEnum()
    bj_groupRandomConsidered = bj_groupRandomConsidered + 1
    if (GetRandomInt(1,bj_groupRandomConsidered) == 1) then
        bj_groupRandomCurrentPick = GetEnumUnit()
    end
end

--===========================================================================
-- Picks a random unit from a group.
--
---@type fun(whichGroup: group):unit
function GroupPickRandomUnit(whichGroup)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_groupRandomConsidered = 0
    bj_groupRandomCurrentPick = nil
    ForGroup(whichGroup, GroupPickRandomUnitEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(whichGroup)
    end
    return bj_groupRandomCurrentPick
end

--===========================================================================
-- See GroupPickRandomUnitEnum for the details of this algorithm.
--
function ForcePickRandomPlayerEnum()
    bj_forceRandomConsidered = bj_forceRandomConsidered + 1
    if (GetRandomInt(1,bj_forceRandomConsidered) == 1) then
        bj_forceRandomCurrentPick = GetEnumPlayer()
    end
end

--===========================================================================
-- Picks a random player from a force.
--
---@type fun(whichForce: force):player
function ForcePickRandomPlayer(whichForce)
    bj_forceRandomConsidered = 0
    bj_forceRandomCurrentPick = nil
    ForForce(whichForce, ForcePickRandomPlayerEnum)
    return bj_forceRandomCurrentPick
end

--===========================================================================
---@type fun(whichPlayer: player, enumFilter?: boolexpr, enumAction: function)
function EnumUnitsSelected(whichPlayer, enumFilter, enumAction)
    local g       = CreateGroup() ---@type group 
    SyncSelections()
    GroupEnumUnitsSelected(g, whichPlayer, enumFilter)
    DestroyBoolExpr(enumFilter)
    ForGroup(g, enumAction)
    DestroyGroup(g)
end

--===========================================================================
---@type fun(r: rect, filter?: boolexpr):group
function GetUnitsInRectMatching(r, filter)
    local g       = CreateGroup() ---@type group 
    GroupEnumUnitsInRect(g, r, filter)
    DestroyBoolExpr(filter)
    return g
end

--===========================================================================
---@type fun(r: rect):group
function GetUnitsInRectAll(r)
    return GetUnitsInRectMatching(r, nil)
end

--===========================================================================
---@type fun():boolean
function GetUnitsInRectOfPlayerFilter()
    return GetOwningPlayer(GetFilterUnit()) == bj_groupEnumOwningPlayer
end

--===========================================================================
---@type fun(r: rect, whichPlayer: player):group
function GetUnitsInRectOfPlayer(r, whichPlayer)
    local g       = CreateGroup() ---@type group 
    bj_groupEnumOwningPlayer = whichPlayer
    GroupEnumUnitsInRect(g, r, filterGetUnitsInRectOfPlayer)
    return g
end

--===========================================================================
---@type fun(radius: number, whichLocation: location, filter?: boolexpr):group
function GetUnitsInRangeOfLocMatching(radius, whichLocation, filter)
    local g       = CreateGroup() ---@type group 
    GroupEnumUnitsInRangeOfLoc(g, whichLocation, radius, filter)
    DestroyBoolExpr(filter)
    return g
end

--===========================================================================
---@type fun(radius: number, whichLocation: location):group
function GetUnitsInRangeOfLocAll(radius, whichLocation)
    return GetUnitsInRangeOfLocMatching(radius, whichLocation, nil)
end

--===========================================================================
---@type fun():boolean
function GetUnitsOfTypeIdAllFilter()
    return GetUnitTypeId(GetFilterUnit()) == bj_groupEnumTypeId
end

--===========================================================================
---@type fun(unitid: integer):group
function GetUnitsOfTypeIdAll(unitid)
    local result         = CreateGroup() ---@type group 
    local g              = CreateGroup() ---@type group 
    local index ---@type integer 

    index = 0
    repeat
        bj_groupEnumTypeId = unitid
        GroupClear(g)
        GroupEnumUnitsOfPlayer(g, Player(index), filterGetUnitsOfTypeIdAll)
        GroupAddGroup(g, result)

        index = index + 1
    until index == bj_MAX_PLAYER_SLOTS
    DestroyGroup(g)

    return result
end

--===========================================================================
---@type fun(whichPlayer: player, filter?: boolexpr):group
function GetUnitsOfPlayerMatching(whichPlayer, filter)
    local g       = CreateGroup() ---@type group 
    GroupEnumUnitsOfPlayer(g, whichPlayer, filter)
    DestroyBoolExpr(filter)
    return g
end

--===========================================================================
---@type fun(whichPlayer: player):group
function GetUnitsOfPlayerAll(whichPlayer)
    return GetUnitsOfPlayerMatching(whichPlayer, nil)
end

--===========================================================================
---@type fun():boolean
function GetUnitsOfPlayerAndTypeIdFilter()
    return GetUnitTypeId(GetFilterUnit()) == bj_groupEnumTypeId
end

--===========================================================================
---@type fun(whichPlayer: player, unitid: integer):group
function GetUnitsOfPlayerAndTypeId(whichPlayer, unitid)
    local g       = CreateGroup() ---@type group 
    bj_groupEnumTypeId = unitid
    GroupEnumUnitsOfPlayer(g, whichPlayer, filterGetUnitsOfPlayerAndTypeId)
    return g
end

--===========================================================================
---@type fun(whichPlayer: player):group
function GetUnitsSelectedAll(whichPlayer)
    local g       = CreateGroup() ---@type group 
    SyncSelections()
    GroupEnumUnitsSelected(g, whichPlayer, nil)
    return g
end

--===========================================================================
---@type fun(whichPlayer: player):force
function GetForceOfPlayer(whichPlayer)
    local f       = CreateForce() ---@type force 
    ForceAddPlayer(f, whichPlayer)
    return f
end

--===========================================================================
---@type fun():force
function GetPlayersAll()
    return bj_FORCE_ALL_PLAYERS
end

--===========================================================================
---@type fun(whichControl: mapcontrol):force
function GetPlayersByMapControl(whichControl)
    local f       = CreateForce() ---@type force 
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 

    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if GetPlayerController(indexPlayer) == whichControl then
            ForceAddPlayer(f, indexPlayer)
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYER_SLOTS

    return f
end

--===========================================================================
---@type fun(whichPlayer: player):force
function GetPlayersAllies(whichPlayer)
    local f       = CreateForce() ---@type force 
    ForceEnumAllies(f, whichPlayer, nil)
    return f
end

--===========================================================================
---@type fun(whichPlayer: player):force
function GetPlayersEnemies(whichPlayer)
    local f       = CreateForce() ---@type force 
    ForceEnumEnemies(f, whichPlayer, nil)
    return f
end

--===========================================================================
---@type fun(filter?: boolexpr):force
function GetPlayersMatching(filter)
    local f       = CreateForce() ---@type force 
    ForceEnumPlayers(f, filter)
    DestroyBoolExpr(filter)
    return f
end

--===========================================================================
function CountUnitsInGroupEnum()
    bj_groupCountUnits = bj_groupCountUnits + 1
end

--===========================================================================
---@type fun(g: group):integer
function CountUnitsInGroup(g)
    -- If the user wants the group destroyed, remember that fact and clear
    -- the flag, in case it is used again in the callback.
    local wantDestroy         = bj_wantDestroyGroup ---@type boolean 
    bj_wantDestroyGroup = false

    bj_groupCountUnits = 0
    ForGroup(g, CountUnitsInGroupEnum)

    -- If the user wants the group destroyed, do so now.
    if (wantDestroy) then
        DestroyGroup(g)
    end
    return bj_groupCountUnits
end

--===========================================================================
function CountPlayersInForceEnum()
    bj_forceCountPlayers = bj_forceCountPlayers + 1
end

--===========================================================================
---@type fun(f: force):integer
function CountPlayersInForceBJ(f)
    bj_forceCountPlayers = 0
    ForForce(f, CountPlayersInForceEnum)
    return bj_forceCountPlayers
end

--===========================================================================
function GetRandomSubGroupEnum()
    if (bj_randomSubGroupWant > 0) then
        if (bj_randomSubGroupWant >= bj_randomSubGroupTotal) or (GetRandomReal(0,1) < bj_randomSubGroupChance) then
            -- We either need every remaining unit, or the unit passed its chance check.
            GroupAddUnit(bj_randomSubGroupGroup, GetEnumUnit())
            bj_randomSubGroupWant = bj_randomSubGroupWant - 1
        end
    end
    bj_randomSubGroupTotal = bj_randomSubGroupTotal - 1
end

--===========================================================================
---@type fun(count: integer, sourceGroup: group):group
function GetRandomSubGroup(count, sourceGroup)
    local g       = CreateGroup() ---@type group 

    bj_randomSubGroupGroup = g
    bj_randomSubGroupWant  = count
    bj_randomSubGroupTotal = CountUnitsInGroup(sourceGroup)

    if (bj_randomSubGroupWant <= 0 or bj_randomSubGroupTotal <= 0) then
        return g
    end

    bj_randomSubGroupChance = I2R(bj_randomSubGroupWant) / I2R(bj_randomSubGroupTotal)
    ForGroup(sourceGroup, GetRandomSubGroupEnum)
    return g
end

--===========================================================================
---@type fun():boolean
function LivingPlayerUnitsOfTypeIdFilter()
    local filterUnit      = GetFilterUnit() ---@type unit 
    return IsUnitAliveBJ(filterUnit) and GetUnitTypeId(filterUnit) == bj_livingPlayerUnitsTypeId
end

--===========================================================================
---@type fun(unitId: integer, whichPlayer: player):integer
function CountLivingPlayerUnitsOfTypeId(unitId, whichPlayer)
    local g ---@type group 
    local matchedCount ---@type integer 

    g = CreateGroup()
    bj_livingPlayerUnitsTypeId = unitId
    GroupEnumUnitsOfPlayer(g, whichPlayer, filterLivingPlayerUnitsOfTypeId)
    matchedCount = CountUnitsInGroup(g)
    DestroyGroup(g)

    return matchedCount
end



--***************************************************************************
--*
--*  Animation Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(whichUnit: unit)
function ResetUnitAnimation(whichUnit)
    SetUnitAnimation(whichUnit, "stand")
end

--===========================================================================
---@type fun(whichUnit: unit, percentScale: number)
function SetUnitTimeScalePercent(whichUnit, percentScale)
    SetUnitTimeScale(whichUnit, percentScale * 0.01)
end

--===========================================================================
---@type fun(whichUnit: unit, percentScaleX: number, percentScaleY: number, percentScaleZ: number)
function SetUnitScalePercent(whichUnit, percentScaleX, percentScaleY, percentScaleZ)
    SetUnitScale(whichUnit, percentScaleX * 0.01, percentScaleY * 0.01, percentScaleZ * 0.01)
end

--===========================================================================
-- This version differs from the common.j interface in that the alpha value
-- is reversed so as to be displayed as transparency, and all four parameters
-- are treated as percentages rather than bytes.
--
---@type fun(whichUnit: unit, red: number, green: number, blue: number, transparency: number)
function SetUnitVertexColorBJ(whichUnit, red, green, blue, transparency)
    SetUnitVertexColor(whichUnit, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(whichUnit: unit, red: number, green: number, blue: number, transparency: number)
function UnitAddIndicatorBJ(whichUnit, red, green, blue, transparency)
    AddIndicator(whichUnit, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(whichDestructable: destructable, red: number, green: number, blue: number, transparency: number)
function DestructableAddIndicatorBJ(whichDestructable, red, green, blue, transparency)
    AddIndicator(whichDestructable, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(whichItem: item, red: number, green: number, blue: number, transparency: number)
function ItemAddIndicatorBJ(whichItem, red, green, blue, transparency)
    AddIndicator(whichItem, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
-- Sets a unit's facing to point directly at a location.
--
---@type fun(whichUnit: unit, target: location, duration: number)
function SetUnitFacingToFaceLocTimed(whichUnit, target, duration)
    local unitLoc          = GetUnitLoc(whichUnit) ---@type location 

    SetUnitFacingTimed(whichUnit, AngleBetweenPoints(unitLoc, target), duration)
    RemoveLocation(unitLoc)
end

--===========================================================================
-- Sets a unit's facing to point directly at another unit.
--
---@type fun(whichUnit: unit, target: unit, duration: number)
function SetUnitFacingToFaceUnitTimed(whichUnit, target, duration)
    local unitLoc          = GetUnitLoc(target) ---@type location 

    SetUnitFacingToFaceLocTimed(whichUnit, unitLoc, duration)
    RemoveLocation(unitLoc)
end

--===========================================================================
---@type fun(whichUnit: unit, whichAnimation: string)
function QueueUnitAnimationBJ(whichUnit, whichAnimation)
    QueueUnitAnimation(whichUnit, whichAnimation)
end

--===========================================================================
---@type fun(d: destructable, whichAnimation: string)
function SetDestructableAnimationBJ(d, whichAnimation)
    SetDestructableAnimation(d, whichAnimation)
end

--===========================================================================
---@type fun(d: destructable, whichAnimation: string)
function QueueDestructableAnimationBJ(d, whichAnimation)
    QueueDestructableAnimation(d, whichAnimation)
end

--===========================================================================
---@type fun(d: destructable, percentScale: number)
function SetDestAnimationSpeedPercent(d, percentScale)
    SetDestructableAnimationSpeed(d, percentScale * 0.01)
end



--***************************************************************************
--*
--*  Dialog Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(flag: boolean, whichDialog: dialog, whichPlayer: player)
function DialogDisplayBJ(flag, whichDialog, whichPlayer)
    DialogDisplay(whichPlayer, whichDialog, flag)
end

--===========================================================================
---@type fun(whichDialog: dialog, message: string)
function DialogSetMessageBJ(whichDialog, message)
    DialogSetMessage(whichDialog, message)
end

--===========================================================================
---@type fun(whichDialog: dialog, buttonText: string):button
function DialogAddButtonBJ(whichDialog, buttonText)
    bj_lastCreatedButton = DialogAddButton(whichDialog, buttonText,0)
    return bj_lastCreatedButton
end

--===========================================================================
---@type fun(whichDialog: dialog, buttonText: string, hotkey: integer):button
function DialogAddButtonWithHotkeyBJ(whichDialog, buttonText, hotkey)
    bj_lastCreatedButton = DialogAddButton(whichDialog, buttonText,hotkey)
    return bj_lastCreatedButton
end

--===========================================================================
---@type fun(whichDialog: dialog)
function DialogClearBJ(whichDialog)
    DialogClear(whichDialog)
end

--===========================================================================
---@type fun():button
function GetLastCreatedButtonBJ()
    return bj_lastCreatedButton
end

--===========================================================================
---@type fun():button
function GetClickedButtonBJ()
    return GetClickedButton()
end

--===========================================================================
---@type fun():dialog
function GetClickedDialogBJ()
    return GetClickedDialog()
end



--***************************************************************************
--*
--*  Alliance Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(sourcePlayer: player, whichAllianceSetting: alliancetype, value: boolean, otherPlayer: player)
function SetPlayerAllianceBJ(sourcePlayer, whichAllianceSetting, value, otherPlayer)
    -- Prevent players from attempting to ally with themselves.
    if (sourcePlayer == otherPlayer) then
        return
    end

    SetPlayerAlliance(sourcePlayer, otherPlayer, whichAllianceSetting, value)
end

--===========================================================================
-- Set all flags used by the in-game "Ally" checkbox.
--
---@type fun(sourcePlayer: player, otherPlayer: player, flag: boolean)
function SetPlayerAllianceStateAllyBJ(sourcePlayer, otherPlayer, flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_PASSIVE,       flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_HELP_REQUEST,  flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_HELP_RESPONSE, flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_XP,     flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_SPELLS, flag)
end

--===========================================================================
-- Set all flags used by the in-game "Shared Vision" checkbox.
--
---@type fun(sourcePlayer: player, otherPlayer: player, flag: boolean)
function SetPlayerAllianceStateVisionBJ(sourcePlayer, otherPlayer, flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_VISION, flag)
end

--===========================================================================
-- Set all flags used by the in-game "Shared Units" checkbox.
--
---@type fun(sourcePlayer: player, otherPlayer: player, flag: boolean)
function SetPlayerAllianceStateControlBJ(sourcePlayer, otherPlayer, flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_CONTROL, flag)
end

--===========================================================================
-- Set all flags used by the in-game "Shared Units" checkbox with the Full
-- Shared Unit Control feature enabled.
--
---@type fun(sourcePlayer: player, otherPlayer: player, flag: boolean)
function SetPlayerAllianceStateFullControlBJ(sourcePlayer, otherPlayer, flag)
    SetPlayerAlliance(sourcePlayer, otherPlayer, ALLIANCE_SHARED_ADVANCED_CONTROL, flag)
end

--===========================================================================
---@type fun(sourcePlayer: player, otherPlayer: player, allianceState: integer)
function SetPlayerAllianceStateBJ(sourcePlayer, otherPlayer, allianceState)
    -- Prevent players from attempting to ally with themselves.
    if (sourcePlayer == otherPlayer) then
        return
    end

    if allianceState == bj_ALLIANCE_UNALLIED then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
    elseif allianceState == bj_ALLIANCE_UNALLIED_VISION then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
    elseif allianceState == bj_ALLIANCE_ALLIED then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
    elseif allianceState == bj_ALLIANCE_ALLIED_VISION then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
    elseif allianceState == bj_ALLIANCE_ALLIED_UNITS then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
    elseif allianceState == bj_ALLIANCE_ALLIED_ADVUNITS then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, true  )
    elseif allianceState == bj_ALLIANCE_NEUTRAL then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
        SetPlayerAlliance( sourcePlayer, otherPlayer, ALLIANCE_PASSIVE, true )
    elseif allianceState == bj_ALLIANCE_NEUTRAL_VISION then
        SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  )
        SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false )
        SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false )
        SetPlayerAlliance( sourcePlayer, otherPlayer, ALLIANCE_PASSIVE, true )
    else
        -- Unrecognized alliance state - ignore the request.
    end
end

--===========================================================================
-- Set the alliance states for an entire force towards another force.
--
---@type fun(sourceForce: force, targetForce: force, allianceState: integer)
function SetForceAllianceStateBJ(sourceForce, targetForce, allianceState)
    local sourceIndex ---@type integer 
    local targetIndex ---@type integer 

    sourceIndex = 0
    repeat

        if (sourceForce==bj_FORCE_ALL_PLAYERS or IsPlayerInForce(Player(sourceIndex), sourceForce)) then
            targetIndex = 0
            repeat
                if (targetForce==bj_FORCE_ALL_PLAYERS or IsPlayerInForce(Player(targetIndex), targetForce)) then
                    SetPlayerAllianceStateBJ(Player(sourceIndex), Player(targetIndex), allianceState)
                end

                targetIndex = targetIndex + 1
            until targetIndex == bj_MAX_PLAYER_SLOTS
        end

        sourceIndex = sourceIndex + 1
    until sourceIndex == bj_MAX_PLAYER_SLOTS
end

--===========================================================================
-- Test to see if two players are co-allied (allied with each other).
--
---@type fun(playerA: player, playerB: player):boolean
function PlayersAreCoAllied(playerA, playerB)
    -- Players are considered to be allied with themselves.
    if (playerA == playerB) then
        return true
    end

    -- Co-allies are both allied with each other.
    if GetPlayerAlliance(playerA, playerB, ALLIANCE_PASSIVE) then
        if GetPlayerAlliance(playerB, playerA, ALLIANCE_PASSIVE) then
            return true
        end
    end
    return false
end

--===========================================================================
-- Force (whichPlayer) AI player to share vision and advanced unit control 
-- with all AI players of its allies.
--
---@type fun(whichPlayer: player)
function ShareEverythingWithTeamAI(whichPlayer)
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 

    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if (PlayersAreCoAllied(whichPlayer, indexPlayer) and whichPlayer ~= indexPlayer) then
            if (GetPlayerController(indexPlayer) == MAP_CONTROL_COMPUTER) then
                SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_VISION, true)
                SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_CONTROL, true)
                SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_ADVANCED_CONTROL, true)
            end
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
end

--===========================================================================
-- Force (whichPlayer) to share vision and advanced unit control with all of his/her allies.
--
---@type fun(whichPlayer: player)
function ShareEverythingWithTeam(whichPlayer)
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 

    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if (PlayersAreCoAllied(whichPlayer, indexPlayer) and whichPlayer ~= indexPlayer) then
            SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_VISION, true)
            SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_CONTROL, true)
            SetPlayerAlliance(indexPlayer, whichPlayer, ALLIANCE_SHARED_CONTROL, true)
            SetPlayerAlliance(whichPlayer, indexPlayer, ALLIANCE_SHARED_ADVANCED_CONTROL, true)
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
end

--===========================================================================
-- Creates a 'Neutral Victim' player slot.  This slot is passive towards all
-- other players, but all other players are aggressive towards him/her.
-- 
function ConfigureNeutralVictim()
    local index ---@type integer 
    local indexPlayer ---@type player 
    local neutralVictim        = Player(bj_PLAYER_NEUTRAL_VICTIM) ---@type player 

    index = 0
    repeat
        indexPlayer = Player(index)

        SetPlayerAlliance(neutralVictim, indexPlayer, ALLIANCE_PASSIVE, true)
        SetPlayerAlliance(indexPlayer, neutralVictim, ALLIANCE_PASSIVE, false)

        index = index + 1
    until index == bj_MAX_PLAYERS

    -- Neutral Victim and Neutral Aggressive should not fight each other.
    indexPlayer = Player(PLAYER_NEUTRAL_AGGRESSIVE)
    SetPlayerAlliance(neutralVictim, indexPlayer, ALLIANCE_PASSIVE, true)
    SetPlayerAlliance(indexPlayer, neutralVictim, ALLIANCE_PASSIVE, true)

    -- Neutral Victim does not give bounties.
    SetPlayerState(neutralVictim, PLAYER_STATE_GIVES_BOUNTY, 0)
end

--===========================================================================
function MakeUnitsPassiveForPlayerEnum()
    SetUnitOwner(GetEnumUnit(), Player(bj_PLAYER_NEUTRAL_VICTIM), false)
end

--===========================================================================
-- Change ownership for every unit of (whichPlayer)'s team to neutral passive.
--
---@type fun(whichPlayer: player)
function MakeUnitsPassiveForPlayer(whichPlayer)
    local playerUnits         = CreateGroup() ---@type group 
    CachePlayerHeroData(whichPlayer)
    GroupEnumUnitsOfPlayer(playerUnits, whichPlayer, nil)
    ForGroup(playerUnits, MakeUnitsPassiveForPlayerEnum)
    DestroyGroup(playerUnits)
end

--===========================================================================
-- Change ownership for every unit of (whichPlayer)'s team to neutral passive.
--
---@type fun(whichPlayer: player)
function MakeUnitsPassiveForTeam(whichPlayer)
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 

    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if PlayersAreCoAllied(whichPlayer, indexPlayer) then
            MakeUnitsPassiveForPlayer(indexPlayer)
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
end

--===========================================================================
-- Determine whether or not victory/defeat is disabled via cheat codes.
--
---@type fun(gameResult: playergameresult):boolean
function AllowVictoryDefeat(gameResult)
    if (gameResult == PLAYER_GAME_RESULT_VICTORY) then
        return not IsNoVictoryCheat()
    end
    if (gameResult == PLAYER_GAME_RESULT_DEFEAT) then
        return not IsNoDefeatCheat()
    end
    if (gameResult == PLAYER_GAME_RESULT_NEUTRAL) then
        return (not IsNoVictoryCheat()) and (not IsNoDefeatCheat())
    end
    return true
end

--===========================================================================
function EndGameBJ()
    EndGame( true )
end

--===========================================================================
---@type fun(whichPlayer: player, leftGame: boolean)
function MeleeVictoryDialogBJ(whichPlayer, leftGame)
    local t         = CreateTrigger() ---@type trigger 
    local d         = DialogCreate() ---@type dialog 
    local formatString ---@type string 

    -- Display "player was victorious" or "player has left the game" message
    if (leftGame) then
        formatString = GetLocalizedString( "PLAYER_LEFT_GAME" )
    else
        formatString = GetLocalizedString( "PLAYER_VICTORIOUS" )
    end

    DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, formatString)

    DialogSetMessage( d, GetLocalizedString( "GAMEOVER_VICTORY_MSG" ) )
    DialogAddButton( d, GetLocalizedString( "GAMEOVER_CONTINUE_GAME" ), GetLocalizedHotkey("GAMEOVER_CONTINUE_GAME") )

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddQuitButton( d, true, GetLocalizedString( "GAMEOVER_QUIT_GAME" ), GetLocalizedHotkey("GAMEOVER_QUIT_GAME") ) )

    DialogDisplay( whichPlayer, d, true )
    StartSoundForPlayerBJ( whichPlayer, bj_victoryDialogSound )
end

--===========================================================================
---@type fun(whichPlayer: player, leftGame: boolean)
function MeleeDefeatDialogBJ(whichPlayer, leftGame)
    local t         = CreateTrigger() ---@type trigger 
    local d         = DialogCreate() ---@type dialog 
    local formatString ---@type string 

    -- Display "player was defeated" or "player has left the game" message
    if (leftGame) then
        formatString = GetLocalizedString( "PLAYER_LEFT_GAME" )
    else
        formatString = GetLocalizedString( "PLAYER_DEFEATED" )
    end

    DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, formatString)

    DialogSetMessage( d, GetLocalizedString( "GAMEOVER_DEFEAT_MSG" ) )

    -- Only show the continue button if the game is not over and observers on death are allowed
    if (not bj_meleeGameOver and IsMapFlagSet(MAP_OBSERVERS_ON_DEATH)) then
        DialogAddButton( d, GetLocalizedString( "GAMEOVER_CONTINUE_OBSERVING" ), GetLocalizedHotkey("GAMEOVER_CONTINUE_OBSERVING") )
    end

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddQuitButton( d, true, GetLocalizedString( "GAMEOVER_QUIT_GAME" ), GetLocalizedHotkey("GAMEOVER_QUIT_GAME") ) )

    DialogDisplay( whichPlayer, d, true )
    StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound )
end

--===========================================================================
---@type fun(whichPlayer: player, leftGame: boolean)
function GameOverDialogBJ(whichPlayer, leftGame)
    local t         = CreateTrigger() ---@type trigger 
    local d         = DialogCreate() ---@type dialog 
    local s ---@type string 

    -- Display "player left the game" message
    DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, GetLocalizedString( "PLAYER_LEFT_GAME" ))

    if (GetIntegerGameState(GAME_STATE_DISCONNECTED) ~= 0) then
        s = GetLocalizedString( "GAMEOVER_DISCONNECTED" )
    else
        s = GetLocalizedString( "GAMEOVER_GAME_OVER" )
    end

    DialogSetMessage( d, s )

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddQuitButton( d, true, GetLocalizedString( "GAMEOVER_OK" ), GetLocalizedHotkey("GAMEOVER_OK") ) )

    DialogDisplay( whichPlayer, d, true )
    StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound )
end

--===========================================================================
---@type fun(whichPlayer: player, gameResult: playergameresult, leftGame: boolean)
function RemovePlayerPreserveUnitsBJ(whichPlayer, gameResult, leftGame)
    if AllowVictoryDefeat(gameResult) then

        RemovePlayer(whichPlayer, gameResult)

        if( gameResult == PLAYER_GAME_RESULT_VICTORY ) then
            MeleeVictoryDialogBJ( whichPlayer, leftGame )
            return
        elseif( gameResult == PLAYER_GAME_RESULT_DEFEAT ) then
            MeleeDefeatDialogBJ( whichPlayer, leftGame )
        else
            GameOverDialogBJ( whichPlayer, leftGame )
        end

    end
end

--===========================================================================
function CustomVictoryOkBJ()
    if bj_isSinglePlayer then
        PauseGame( false )
        -- Bump the difficulty back up to the default.
        SetGameDifficulty(GetDefaultDifficulty())
    end

    if (bj_changeLevelMapName == nil) then
        EndGame( bj_changeLevelShowScores )
    else
        ChangeLevel( bj_changeLevelMapName, bj_changeLevelShowScores )
    end
end

--===========================================================================
function CustomVictoryQuitBJ()
    if bj_isSinglePlayer then
        PauseGame( false )
        -- Bump the difficulty back up to the default.
        SetGameDifficulty(GetDefaultDifficulty())
    end

    EndGame( bj_changeLevelShowScores )
end

--===========================================================================
---@type fun(whichPlayer: player)
function CustomVictoryDialogBJ(whichPlayer)
    local t         = CreateTrigger() ---@type trigger 
    local d         = DialogCreate() ---@type dialog 

    DialogSetMessage( d, GetLocalizedString( "GAMEOVER_VICTORY_MSG" ) )

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_CONTINUE" ), GetLocalizedHotkey("GAMEOVER_CONTINUE") ) )
    TriggerAddAction( t, CustomVictoryOkBJ )

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_QUIT_MISSION" ), GetLocalizedHotkey("GAMEOVER_QUIT_MISSION") ) )
    TriggerAddAction( t, CustomVictoryQuitBJ )

    if (GetLocalPlayer() == whichPlayer) then
        EnableUserControl( true )
        if bj_isSinglePlayer then
            PauseGame( true )
        end
        EnableUserUI(false)
    end

    DialogDisplay( whichPlayer, d, true )
    VolumeGroupSetVolumeForPlayerBJ( whichPlayer, SOUND_VOLUMEGROUP_UI, 1.0 )
    StartSoundForPlayerBJ( whichPlayer, bj_victoryDialogSound )
end

--===========================================================================
---@type fun(whichPlayer: player)
function CustomVictorySkipBJ(whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        if bj_isSinglePlayer then
            -- Bump the difficulty back up to the default.
            SetGameDifficulty(GetDefaultDifficulty())
        end

        if (bj_changeLevelMapName == nil) then
            EndGame( bj_changeLevelShowScores )
        else
            ChangeLevel( bj_changeLevelMapName, bj_changeLevelShowScores )
        end
    end
end

--===========================================================================
---@type fun(whichPlayer: player, showDialog: boolean, showScores: boolean)
function CustomVictoryBJ(whichPlayer, showDialog, showScores)
    if AllowVictoryDefeat( PLAYER_GAME_RESULT_VICTORY ) then
        RemovePlayer( whichPlayer, PLAYER_GAME_RESULT_VICTORY )

        if not bj_isSinglePlayer then
            DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, GetLocalizedString( "PLAYER_VICTORIOUS" ) )
        end

        -- UI only needs to be displayed to users.
        if (GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
            bj_changeLevelShowScores = showScores
            if showDialog then
                CustomVictoryDialogBJ( whichPlayer )
            else
                CustomVictorySkipBJ( whichPlayer )
            end
        end
    end
end

--===========================================================================
function CustomDefeatRestartBJ()
    PauseGame( false )
    RestartGame( true )
end

--===========================================================================
function CustomDefeatReduceDifficultyBJ()
    local diff                = GetGameDifficulty() ---@type gamedifficulty 

    PauseGame( false )

    -- Knock the difficulty down, if possible.
    if (diff == MAP_DIFFICULTY_EASY) then
        -- Sorry, but it doesn't get any easier than this.
    elseif (diff == MAP_DIFFICULTY_NORMAL) then
        SetGameDifficulty(MAP_DIFFICULTY_EASY)
    elseif (diff == MAP_DIFFICULTY_HARD) then
        SetGameDifficulty(MAP_DIFFICULTY_NORMAL)
    else
        -- Unrecognized difficulty
    end

    RestartGame( true )
end

--===========================================================================
function CustomDefeatLoadBJ()
    PauseGame( false )
    DisplayLoadDialog()
end

--===========================================================================
function CustomDefeatQuitBJ()
    if bj_isSinglePlayer then
        PauseGame( false )
    end

    -- Bump the difficulty back up to the default.
    SetGameDifficulty(GetDefaultDifficulty())
    EndGame( true )
end

--===========================================================================
---@type fun(whichPlayer: player, message: string)
function CustomDefeatDialogBJ(whichPlayer, message)
    local t         = CreateTrigger() ---@type trigger 
    local d         = DialogCreate() ---@type dialog 

    DialogSetMessage( d, message )

    if bj_isSinglePlayer then
        t = CreateTrigger()
        TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_RESTART" ), GetLocalizedHotkey("GAMEOVER_RESTART") ) )
        TriggerAddAction( t, CustomDefeatRestartBJ )

        if (GetGameDifficulty() ~= MAP_DIFFICULTY_EASY) then
            t = CreateTrigger()
            TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_REDUCE_DIFFICULTY" ), GetLocalizedHotkey("GAMEOVER_REDUCE_DIFFICULTY") ) )
            TriggerAddAction( t, CustomDefeatReduceDifficultyBJ )
        end

        t = CreateTrigger()
        TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_LOAD" ), GetLocalizedHotkey("GAMEOVER_LOAD") ) )
        TriggerAddAction( t, CustomDefeatLoadBJ )
    end

    t = CreateTrigger()
    TriggerRegisterDialogButtonEvent( t, DialogAddButton( d, GetLocalizedString( "GAMEOVER_QUIT_MISSION" ), GetLocalizedHotkey("GAMEOVER_QUIT_MISSION") ) )
    TriggerAddAction( t, CustomDefeatQuitBJ )

    if (GetLocalPlayer() == whichPlayer) then
        EnableUserControl( true )
        if bj_isSinglePlayer then
            PauseGame( true )
        end
        EnableUserUI(false)
    end

    DialogDisplay( whichPlayer, d, true )
    VolumeGroupSetVolumeForPlayerBJ( whichPlayer, SOUND_VOLUMEGROUP_UI, 1.0 )
    StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound )
end

--===========================================================================
---@type fun(whichPlayer: player, message: string)
function CustomDefeatBJ(whichPlayer, message)
    if AllowVictoryDefeat( PLAYER_GAME_RESULT_DEFEAT ) then
        RemovePlayer( whichPlayer, PLAYER_GAME_RESULT_DEFEAT )

        if not bj_isSinglePlayer then
            DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, GetLocalizedString( "PLAYER_DEFEATED" ) )
        end

        -- UI only needs to be displayed to users.
        if (GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
            CustomDefeatDialogBJ( whichPlayer, message )
        end
    end
end

--===========================================================================
---@type fun(nextLevel: string)
function SetNextLevelBJ(nextLevel)
    if (nextLevel == "") then
        bj_changeLevelMapName = nil ---@diagnostic disable-line
    else
        bj_changeLevelMapName = nextLevel
    end
end

--===========================================================================
---@type fun(flag: boolean, whichPlayer: player)
function SetPlayerOnScoreScreenBJ(flag, whichPlayer)
    SetPlayerOnScoreScreen(whichPlayer, flag)
end



--***************************************************************************
--*
--*  Quest Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(questType: integer, title: string, description: string, iconPath: string):quest
function CreateQuestBJ(questType, title, description, iconPath)
    local required           = (questType == bj_QUESTTYPE_REQ_DISCOVERED) or (questType == bj_QUESTTYPE_REQ_UNDISCOVERED) ---@type boolean 
    local discovered         = (questType == bj_QUESTTYPE_REQ_DISCOVERED) or (questType == bj_QUESTTYPE_OPT_DISCOVERED) ---@type boolean 

    bj_lastCreatedQuest = CreateQuest()
    QuestSetTitle(bj_lastCreatedQuest, title)
    QuestSetDescription(bj_lastCreatedQuest, description)
    QuestSetIconPath(bj_lastCreatedQuest, iconPath)
    QuestSetRequired(bj_lastCreatedQuest, required)
    QuestSetDiscovered(bj_lastCreatedQuest, discovered)
    QuestSetCompleted(bj_lastCreatedQuest, false)
    return bj_lastCreatedQuest
end

--===========================================================================
---@type fun(whichQuest: quest)
function DestroyQuestBJ(whichQuest)
    DestroyQuest(whichQuest)
end

--===========================================================================
---@type fun(enabled: boolean, whichQuest: quest)
function QuestSetEnabledBJ(enabled, whichQuest)
    QuestSetEnabled(whichQuest, enabled)
end

--===========================================================================
---@type fun(whichQuest: quest, title: string)
function QuestSetTitleBJ(whichQuest, title)
    QuestSetTitle(whichQuest, title)
end

--===========================================================================
---@type fun(whichQuest: quest, description: string)
function QuestSetDescriptionBJ(whichQuest, description)
    QuestSetDescription(whichQuest, description)
end

--===========================================================================
---@type fun(whichQuest: quest, completed: boolean)
function QuestSetCompletedBJ(whichQuest, completed)
    QuestSetCompleted(whichQuest, completed)
end

--===========================================================================
---@type fun(whichQuest: quest, failed: boolean)
function QuestSetFailedBJ(whichQuest, failed)
    QuestSetFailed(whichQuest, failed)
end

--===========================================================================
---@type fun(whichQuest: quest, discovered: boolean)
function QuestSetDiscoveredBJ(whichQuest, discovered)
    QuestSetDiscovered(whichQuest, discovered)
end

--===========================================================================
---@type fun():quest
function GetLastCreatedQuestBJ()
    return bj_lastCreatedQuest
end

--===========================================================================
---@type fun(whichQuest: quest, description: string):questitem
function CreateQuestItemBJ(whichQuest, description)
    bj_lastCreatedQuestItem = QuestCreateItem(whichQuest)
    QuestItemSetDescription(bj_lastCreatedQuestItem, description)
    QuestItemSetCompleted(bj_lastCreatedQuestItem, false)
    return bj_lastCreatedQuestItem
end

--===========================================================================
---@type fun(whichQuestItem: questitem, description: string)
function QuestItemSetDescriptionBJ(whichQuestItem, description)
    QuestItemSetDescription(whichQuestItem, description)
end

--===========================================================================
---@type fun(whichQuestItem: questitem, completed: boolean)
function QuestItemSetCompletedBJ(whichQuestItem, completed)
    QuestItemSetCompleted(whichQuestItem, completed)
end

--===========================================================================
---@type fun():questitem
function GetLastCreatedQuestItemBJ()
    return bj_lastCreatedQuestItem
end

--===========================================================================
---@type fun(description: string):defeatcondition
function CreateDefeatConditionBJ(description)
    bj_lastCreatedDefeatCondition = CreateDefeatCondition()
    DefeatConditionSetDescription(bj_lastCreatedDefeatCondition, description)
    return bj_lastCreatedDefeatCondition
end

--===========================================================================
---@type fun(whichCondition: defeatcondition)
function DestroyDefeatConditionBJ(whichCondition)
    DestroyDefeatCondition(whichCondition)
end

--===========================================================================
---@type fun(whichCondition: defeatcondition, description: string)
function DefeatConditionSetDescriptionBJ(whichCondition, description)
    DefeatConditionSetDescription(whichCondition, description)
end

--===========================================================================
---@type fun():defeatcondition
function GetLastCreatedDefeatConditionBJ()
    return bj_lastCreatedDefeatCondition
end

--===========================================================================
function FlashQuestDialogButtonBJ()
    FlashQuestDialogButton()
end

--===========================================================================
---@type fun(f: force, messageType: integer, message: string)
function QuestMessageBJ(f, messageType, message)
    if (IsPlayerInForce(GetLocalPlayer(), f)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        if (messageType == bj_QUESTMESSAGE_DISCOVERED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUEST, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUEST, message)
            StartSound(bj_questDiscoveredSound)
            FlashQuestDialogButton()

        elseif (messageType == bj_QUESTMESSAGE_UPDATED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTUPDATE, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTUPDATE, message)
            StartSound(bj_questUpdatedSound)
            FlashQuestDialogButton()

        elseif (messageType == bj_QUESTMESSAGE_COMPLETED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTDONE, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTDONE, message)
            StartSound(bj_questCompletedSound)
            FlashQuestDialogButton()

        elseif (messageType == bj_QUESTMESSAGE_FAILED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTFAILED, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTFAILED, message)
            StartSound(bj_questFailedSound)
            FlashQuestDialogButton()

        elseif (messageType == bj_QUESTMESSAGE_REQUIREMENT) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_QUESTREQUIREMENT, message)

        elseif (messageType == bj_QUESTMESSAGE_MISSIONFAILED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_MISSIONFAILED, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_MISSIONFAILED, message)
            StartSound(bj_questFailedSound)

        elseif (messageType == bj_QUESTMESSAGE_HINT) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_HINT, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_HINT, message)
            StartSound(bj_questHintSound)

        elseif (messageType == bj_QUESTMESSAGE_ALWAYSHINT) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_ALWAYSHINT, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_ALWAYSHINT, message)
            StartSound(bj_questHintSound)

        elseif (messageType == bj_QUESTMESSAGE_SECRET) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_SECRET, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_SECRET, message)
            StartSound(bj_questSecretSound)

        elseif (messageType == bj_QUESTMESSAGE_UNITACQUIRED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_UNITACQUIRED, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_UNITACQUIRED, message)
            StartSound(bj_questHintSound)

        elseif (messageType == bj_QUESTMESSAGE_UNITAVAILABLE) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_UNITAVAILABLE, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_UNITAVAILABLE, message)
            StartSound(bj_questHintSound)

        elseif (messageType == bj_QUESTMESSAGE_ITEMACQUIRED) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_ITEMACQUIRED, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_ITEMACQUIRED, message)
            StartSound(bj_questItemAcquiredSound)

        elseif (messageType == bj_QUESTMESSAGE_WARNING) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_WARNING, " ")
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_TEXT_DELAY_WARNING, message)
            StartSound(bj_questWarningSound)

        else
            -- Unrecognized message type - ignore the request.
        end
    end
end



--***************************************************************************
--*
--*  Timer Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(t: timer, periodic: boolean, timeout: number):timer
function StartTimerBJ(t, periodic, timeout)
    bj_lastStartedTimer = t
    TimerStart(t, timeout, periodic, nil)
    return bj_lastStartedTimer
end

--===========================================================================
---@type fun(periodic: boolean, timeout: number):timer
function CreateTimerBJ(periodic, timeout)
    bj_lastStartedTimer = CreateTimer()
    TimerStart(bj_lastStartedTimer, timeout, periodic, nil)
    return bj_lastStartedTimer
end

--===========================================================================
---@type fun(whichTimer: timer)
function DestroyTimerBJ(whichTimer)
    DestroyTimer(whichTimer)
end

--===========================================================================
---@type fun(pause: boolean, whichTimer: timer)
function PauseTimerBJ(pause, whichTimer)
    if pause then
        PauseTimer(whichTimer)
    else
        ResumeTimer(whichTimer)
    end
end

--===========================================================================
---@type fun():timer
function GetLastCreatedTimerBJ()
    return bj_lastStartedTimer
end

--===========================================================================
---@type fun(t: timer, title: string):timerdialog
function CreateTimerDialogBJ(t, title)
    bj_lastCreatedTimerDialog = CreateTimerDialog(t)
    TimerDialogSetTitle(bj_lastCreatedTimerDialog, title)
    TimerDialogDisplay(bj_lastCreatedTimerDialog, true)
    return bj_lastCreatedTimerDialog
end

--===========================================================================
---@type fun(td: timerdialog)
function DestroyTimerDialogBJ(td)
    DestroyTimerDialog(td)
end

--===========================================================================
---@type fun(td: timerdialog, title: string)
function TimerDialogSetTitleBJ(td, title)
    TimerDialogSetTitle(td, title)
end

--===========================================================================
---@type fun(td: timerdialog, red: number, green: number, blue: number, transparency: number)
function TimerDialogSetTitleColorBJ(td, red, green, blue, transparency)
    TimerDialogSetTitleColor(td, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(td: timerdialog, red: number, green: number, blue: number, transparency: number)
function TimerDialogSetTimeColorBJ(td, red, green, blue, transparency)
    TimerDialogSetTimeColor(td, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(td: timerdialog, speedMultFactor: number)
function TimerDialogSetSpeedBJ(td, speedMultFactor)
    TimerDialogSetSpeed(td, speedMultFactor)
end

--===========================================================================
---@type fun(show: boolean, td: timerdialog, whichPlayer: player)
function TimerDialogDisplayForPlayerBJ(show, td, whichPlayer)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        TimerDialogDisplay(td, show)
    end
end

--===========================================================================
---@type fun(show: boolean, td: timerdialog)
function TimerDialogDisplayBJ(show, td)
    TimerDialogDisplay(td, show)
end

--===========================================================================
---@type fun():timerdialog
function GetLastCreatedTimerDialogBJ()
    return bj_lastCreatedTimerDialog
end



--***************************************************************************
--*
--*  Leaderboard Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(lb: leaderboard)
function LeaderboardResizeBJ(lb)
    local size         = LeaderboardGetItemCount(lb) ---@type integer 

    if (LeaderboardGetLabelText(lb) == "") then
        size = size - 1
    end
    LeaderboardSetSizeByItemCount(lb, size)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, val: integer)
function LeaderboardSetPlayerItemValueBJ(whichPlayer, lb, val)
    LeaderboardSetItemValue(lb, LeaderboardGetPlayerIndex(lb, whichPlayer), val)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, val: string)
function LeaderboardSetPlayerItemLabelBJ(whichPlayer, lb, val)
    LeaderboardSetItemLabel(lb, LeaderboardGetPlayerIndex(lb, whichPlayer), val)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, showLabel: boolean, showValue: boolean, showIcon: boolean)
function LeaderboardSetPlayerItemStyleBJ(whichPlayer, lb, showLabel, showValue, showIcon)
    LeaderboardSetItemStyle(lb, LeaderboardGetPlayerIndex(lb, whichPlayer), showLabel, showValue, showIcon)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, red: number, green: number, blue: number, transparency: number)
function LeaderboardSetPlayerItemLabelColorBJ(whichPlayer, lb, red, green, blue, transparency)
    LeaderboardSetItemLabelColor(lb, LeaderboardGetPlayerIndex(lb, whichPlayer), PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, red: number, green: number, blue: number, transparency: number)
function LeaderboardSetPlayerItemValueColorBJ(whichPlayer, lb, red, green, blue, transparency)
    LeaderboardSetItemValueColor(lb, LeaderboardGetPlayerIndex(lb, whichPlayer), PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(lb: leaderboard, red: number, green: number, blue: number, transparency: number)
function LeaderboardSetLabelColorBJ(lb, red, green, blue, transparency)
    LeaderboardSetLabelColor(lb, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(lb: leaderboard, red: number, green: number, blue: number, transparency: number)
function LeaderboardSetValueColorBJ(lb, red, green, blue, transparency)
    LeaderboardSetValueColor(lb, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(lb: leaderboard, label: string)
function LeaderboardSetLabelBJ(lb, label)
    LeaderboardSetLabel(lb, label)
    LeaderboardResizeBJ(lb)
end

--===========================================================================
---@type fun(lb: leaderboard, showLabel: boolean, showNames: boolean, showValues: boolean, showIcons: boolean)
function LeaderboardSetStyleBJ(lb, showLabel, showNames, showValues, showIcons)
    LeaderboardSetStyle(lb, showLabel, showNames, showValues, showIcons)
end

--===========================================================================
---@type fun(lb: leaderboard):integer
function LeaderboardGetItemCountBJ(lb)
    return LeaderboardGetItemCount(lb)
end

--===========================================================================
---@type fun(lb: leaderboard, whichPlayer: player):boolean
function LeaderboardHasPlayerItemBJ(lb, whichPlayer)
    return LeaderboardHasPlayerItem(lb, whichPlayer)
end

--===========================================================================
---@type fun(lb: leaderboard, toForce: force)
function ForceSetLeaderboardBJ(lb, toForce)
    local index ---@type integer 
    local indexPlayer ---@type player 

    index = 0
    repeat
        indexPlayer = Player(index)
        if IsPlayerInForce(indexPlayer, toForce) then
            PlayerSetLeaderboard(indexPlayer, lb)
        end
        index = index + 1
    until index == bj_MAX_PLAYERS
end

--===========================================================================
---@type fun(toForce: force, label: string):leaderboard
function CreateLeaderboardBJ(toForce, label)
    bj_lastCreatedLeaderboard = CreateLeaderboard()
    LeaderboardSetLabel(bj_lastCreatedLeaderboard, label)
    ForceSetLeaderboardBJ(bj_lastCreatedLeaderboard, toForce)
    LeaderboardDisplay(bj_lastCreatedLeaderboard, true)
    return bj_lastCreatedLeaderboard
end

--===========================================================================
---@type fun(lb: leaderboard)
function DestroyLeaderboardBJ(lb)
    DestroyLeaderboard(lb)
end

--===========================================================================
---@type fun(show: boolean, lb: leaderboard)
function LeaderboardDisplayBJ(show, lb)
    LeaderboardDisplay(lb, show)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard, label: string, value: integer)
function LeaderboardAddItemBJ(whichPlayer, lb, label, value)
    if (LeaderboardHasPlayerItem(lb, whichPlayer)) then
        LeaderboardRemovePlayerItem(lb, whichPlayer)
    end
    LeaderboardAddItem(lb, label, value, whichPlayer)
    LeaderboardResizeBJ(lb)
    --call LeaderboardSetSizeByItemCount(lb, LeaderboardGetItemCount(lb))
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard)
function LeaderboardRemovePlayerItemBJ(whichPlayer, lb)
    LeaderboardRemovePlayerItem(lb, whichPlayer)
    LeaderboardResizeBJ(lb)
end

--===========================================================================
---@type fun(lb: leaderboard, sortType: integer, ascending: boolean)
function LeaderboardSortItemsBJ(lb, sortType, ascending)
    if (sortType == bj_SORTTYPE_SORTBYVALUE) then
        LeaderboardSortItemsByValue(lb, ascending)
    elseif (sortType == bj_SORTTYPE_SORTBYPLAYER) then
        LeaderboardSortItemsByPlayer(lb, ascending)
    elseif (sortType == bj_SORTTYPE_SORTBYLABEL) then
        LeaderboardSortItemsByLabel(lb, ascending)
    else
        -- Unrecognized sort type - ignore the request.
    end
end

--===========================================================================
---@type fun(lb: leaderboard, ascending: boolean)
function LeaderboardSortItemsByPlayerBJ(lb, ascending)
    LeaderboardSortItemsByPlayer(lb, ascending)
end

--===========================================================================
---@type fun(lb: leaderboard, ascending: boolean)
function LeaderboardSortItemsByLabelBJ(lb, ascending)
    LeaderboardSortItemsByLabel(lb, ascending)
end

--===========================================================================
---@type fun(whichPlayer: player, lb: leaderboard):integer
function LeaderboardGetPlayerIndexBJ(whichPlayer, lb)
    return LeaderboardGetPlayerIndex(lb, whichPlayer) + 1
end

--===========================================================================
-- Returns the player who is occupying a specified position in a leaderboard.
-- The position parameter is expected in the range of 1..16.
--
---@type fun(position: integer, lb: leaderboard):player
function LeaderboardGetIndexedPlayerBJ(position, lb)
    local index ---@type integer 
    local indexPlayer ---@type player 

    index = 0
    repeat
        indexPlayer = Player(index)
        if (LeaderboardGetPlayerIndex(lb, indexPlayer) == position - 1) then
            return indexPlayer
        end

        index = index + 1
    until index == bj_MAX_PLAYERS

    return Player(PLAYER_NEUTRAL_PASSIVE)
end

--===========================================================================
---@type fun(whichPlayer: player):leaderboard
function PlayerGetLeaderboardBJ(whichPlayer)
    return PlayerGetLeaderboard(whichPlayer)
end

--===========================================================================
---@type fun():leaderboard
function GetLastCreatedLeaderboard()
    return bj_lastCreatedLeaderboard
end

--***************************************************************************
--*
--*  Multiboard Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(cols: integer, rows: integer, title: string):multiboard
function CreateMultiboardBJ(cols, rows, title)
    bj_lastCreatedMultiboard = CreateMultiboard()
    MultiboardSetRowCount(bj_lastCreatedMultiboard, rows)
    MultiboardSetColumnCount(bj_lastCreatedMultiboard, cols)
    MultiboardSetTitleText(bj_lastCreatedMultiboard, title)
    MultiboardDisplay(bj_lastCreatedMultiboard, true)
    return bj_lastCreatedMultiboard
end

--===========================================================================
---@type fun(mb: multiboard)
function DestroyMultiboardBJ(mb)
    DestroyMultiboard(mb)
end

--===========================================================================
---@type fun():multiboard
function GetLastCreatedMultiboard()
    return bj_lastCreatedMultiboard
end

--===========================================================================
---@type fun(show: boolean, mb: multiboard)
function MultiboardDisplayBJ(show, mb)
    MultiboardDisplay(mb, show)
end

--===========================================================================
---@type fun(minimize: boolean, mb: multiboard)
function MultiboardMinimizeBJ(minimize, mb)
    MultiboardMinimize(mb, minimize)
end

--===========================================================================
---@type fun(mb: multiboard, red: number, green: number, blue: number, transparency: number)
function MultiboardSetTitleTextColorBJ(mb, red, green, blue, transparency)
    MultiboardSetTitleTextColor(mb, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(flag: boolean)
function MultiboardAllowDisplayBJ(flag)
    MultiboardSuppressDisplay(not flag)
end

--===========================================================================
---@type fun(mb: multiboard, col: integer, row: integer, showValue: boolean, showIcon: boolean)
function MultiboardSetItemStyleBJ(mb, col, row, showValue, showIcon)
    local curRow         = 0 ---@type integer 
    local curCol         = 0 ---@type integer 
    local numRows         = MultiboardGetRowCount(mb) ---@type integer 
    local numCols         = MultiboardGetColumnCount(mb) ---@type integer 
    local mbitem                = nil ---@type multiboarditem 

    -- Loop over rows, using 1-based index
    while true do
        curRow = curRow + 1
        if curRow > numRows then break end

        -- Apply setting to the requested row, or all rows (if row is 0)
        if (row == 0 or row == curRow) then
            -- Loop over columns, using 1-based index
            curCol = 0
            while true do
                curCol = curCol + 1
                if curCol > numCols then break end

                -- Apply setting to the requested column, or all columns (if col is 0)
                if (col == 0 or col == curCol) then
                    mbitem = MultiboardGetItem(mb, curRow - 1, curCol - 1)
                    MultiboardSetItemStyle(mbitem, showValue, showIcon)
                    MultiboardReleaseItem(mbitem)
                end
            end
        end
    end
end

--===========================================================================
---@type fun(mb: multiboard, col: integer, row: integer, val: string)
function MultiboardSetItemValueBJ(mb, col, row, val)
    local curRow         = 0 ---@type integer 
    local curCol         = 0 ---@type integer 
    local numRows         = MultiboardGetRowCount(mb) ---@type integer 
    local numCols         = MultiboardGetColumnCount(mb) ---@type integer 
    local mbitem                = nil ---@type multiboarditem 

    -- Loop over rows, using 1-based index
    while true do
        curRow = curRow + 1
        if curRow > numRows then break end

        -- Apply setting to the requested row, or all rows (if row is 0)
        if (row == 0 or row == curRow) then
            -- Loop over columns, using 1-based index
            curCol = 0
            while true do
                curCol = curCol + 1
                if curCol > numCols then break end

                -- Apply setting to the requested column, or all columns (if col is 0)
                if (col == 0 or col == curCol) then
                    mbitem = MultiboardGetItem(mb, curRow - 1, curCol - 1)
                    MultiboardSetItemValue(mbitem, val)
                    MultiboardReleaseItem(mbitem)
                end
            end
        end
    end
end

--===========================================================================
---@type fun(mb: multiboard, col: integer, row: integer, red: number, green: number, blue: number, transparency: number)
function MultiboardSetItemColorBJ(mb, col, row, red, green, blue, transparency)
    local curRow         = 0 ---@type integer 
    local curCol         = 0 ---@type integer 
    local numRows         = MultiboardGetRowCount(mb) ---@type integer 
    local numCols         = MultiboardGetColumnCount(mb) ---@type integer 
    local mbitem                = nil ---@type multiboarditem 

    -- Loop over rows, using 1-based index
    while true do
        curRow = curRow + 1
        if curRow > numRows then break end

        -- Apply setting to the requested row, or all rows (if row is 0)
        if (row == 0 or row == curRow) then
            -- Loop over columns, using 1-based index
            curCol = 0
            while true do
                curCol = curCol + 1
                if curCol > numCols then break end

                -- Apply setting to the requested column, or all columns (if col is 0)
                if (col == 0 or col == curCol) then
                    mbitem = MultiboardGetItem(mb, curRow - 1, curCol - 1)
                    MultiboardSetItemValueColor(mbitem, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
                    MultiboardReleaseItem(mbitem)
                end
            end
        end
    end
end

--===========================================================================
---@type fun(mb: multiboard, col: integer, row: integer, width: number)
function MultiboardSetItemWidthBJ(mb, col, row, width)
    local curRow         = 0 ---@type integer 
    local curCol         = 0 ---@type integer 
    local numRows         = MultiboardGetRowCount(mb) ---@type integer 
    local numCols         = MultiboardGetColumnCount(mb) ---@type integer 
    local mbitem                = nil ---@type multiboarditem 

    -- Loop over rows, using 1-based index
    while true do
        curRow = curRow + 1
        if curRow > numRows then break end

        -- Apply setting to the requested row, or all rows (if row is 0)
        if (row == 0 or row == curRow) then
            -- Loop over columns, using 1-based index
            curCol = 0
            while true do
                curCol = curCol + 1
                if curCol > numCols then break end

                -- Apply setting to the requested column, or all columns (if col is 0)
                if (col == 0 or col == curCol) then
                    mbitem = MultiboardGetItem(mb, curRow - 1, curCol - 1)
                    MultiboardSetItemWidth(mbitem, width/100.0)
                    MultiboardReleaseItem(mbitem)
                end
            end
        end
    end
end

--===========================================================================
---@type fun(mb: multiboard, col: integer, row: integer, iconFileName: string)
function MultiboardSetItemIconBJ(mb, col, row, iconFileName)
    local curRow         = 0 ---@type integer 
    local curCol         = 0 ---@type integer 
    local numRows         = MultiboardGetRowCount(mb) ---@type integer 
    local numCols         = MultiboardGetColumnCount(mb) ---@type integer 
    local mbitem                = nil ---@type multiboarditem 

    -- Loop over rows, using 1-based index
    while true do
        curRow = curRow + 1
        if curRow > numRows then break end

        -- Apply setting to the requested row, or all rows (if row is 0)
        if (row == 0 or row == curRow) then
            -- Loop over columns, using 1-based index
            curCol = 0
            while true do
                curCol = curCol + 1
                if curCol > numCols then break end

                -- Apply setting to the requested column, or all columns (if col is 0)
                if (col == 0 or col == curCol) then
                    mbitem = MultiboardGetItem(mb, curRow - 1, curCol - 1)
                    MultiboardSetItemIcon(mbitem, iconFileName)
                    MultiboardReleaseItem(mbitem)
                end
            end
        end
    end
end



--***************************************************************************
--*
--*  Text Tag Utility Functions
--*
--***************************************************************************

--===========================================================================
-- Scale the font size linearly such that size 10 equates to height 0.023.
-- Screen-relative font heights are harder to grasp and than font sizes.
--
---@type fun(size: number):number
function TextTagSize2Height(size)
    return size * 0.023 / 10
end

--===========================================================================
-- Scale the speed linearly such that speed 128 equates to 0.071.
-- Screen-relative speeds are hard to grasp.
--
---@type fun(speed: number):number
function TextTagSpeed2Velocity(speed)
    return speed * 0.071 / 128
end

--===========================================================================
---@type fun(tt: texttag, red: number, green: number, blue: number, transparency: number)
function SetTextTagColorBJ(tt, red, green, blue, transparency)
    SetTextTagColor(tt, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-transparency))
end

--===========================================================================
---@type fun(tt: texttag, speed: number, angle: number)
function SetTextTagVelocityBJ(tt, speed, angle)
    local vel      = TextTagSpeed2Velocity(speed) ---@type number 
    local xvel      = vel * Cos(angle * bj_DEGTORAD) ---@type number 
    local yvel      = vel * Sin(angle * bj_DEGTORAD) ---@type number 

    SetTextTagVelocity(tt, xvel, yvel)
end

--===========================================================================
---@type fun(tt: texttag, s: string, size: number)
function SetTextTagTextBJ(tt, s, size)
    local textHeight      = TextTagSize2Height(size) ---@type number 

    SetTextTagText(tt, s, textHeight)
end

--===========================================================================
---@type fun(tt: texttag, loc: location, zOffset: number)
function SetTextTagPosBJ(tt, loc, zOffset)
    SetTextTagPos(tt, GetLocationX(loc), GetLocationY(loc), zOffset)
end

--===========================================================================
---@type fun(tt: texttag, whichUnit: unit, zOffset: number)
function SetTextTagPosUnitBJ(tt, whichUnit, zOffset)
    SetTextTagPosUnit(tt, whichUnit, zOffset)
end

--===========================================================================
---@type fun(tt: texttag, flag: boolean)
function SetTextTagSuspendedBJ(tt, flag)
    SetTextTagSuspended(tt, flag)
end

--===========================================================================
---@type fun(tt: texttag, flag: boolean)
function SetTextTagPermanentBJ(tt, flag)
    SetTextTagPermanent(tt, flag)
end

--===========================================================================
---@type fun(tt: texttag, age: number)
function SetTextTagAgeBJ(tt, age)
    SetTextTagAge(tt, age)
end

--===========================================================================
---@type fun(tt: texttag, lifespan: number)
function SetTextTagLifespanBJ(tt, lifespan)
    SetTextTagLifespan(tt, lifespan)
end

--===========================================================================
---@type fun(tt: texttag, fadepoint: number)
function SetTextTagFadepointBJ(tt, fadepoint)
    SetTextTagFadepoint(tt, fadepoint)
end

--===========================================================================
---@type fun(s: string, loc: location, zOffset: number, size: number, red: number, green: number, blue: number, transparency: number):texttag
function CreateTextTagLocBJ(s, loc, zOffset, size, red, green, blue, transparency)
    bj_lastCreatedTextTag = CreateTextTag()
    SetTextTagTextBJ(bj_lastCreatedTextTag, s, size)
    SetTextTagPosBJ(bj_lastCreatedTextTag, loc, zOffset)
    SetTextTagColorBJ(bj_lastCreatedTextTag, red, green, blue, transparency)

    return bj_lastCreatedTextTag
end

--===========================================================================
---@type fun(s: string, whichUnit: unit, zOffset: number, size: number, red: number, green: number, blue: number, transparency: number):texttag
function CreateTextTagUnitBJ(s, whichUnit, zOffset, size, red, green, blue, transparency)
    bj_lastCreatedTextTag = CreateTextTag()
    SetTextTagTextBJ(bj_lastCreatedTextTag, s, size)
    SetTextTagPosUnitBJ(bj_lastCreatedTextTag, whichUnit, zOffset)
    SetTextTagColorBJ(bj_lastCreatedTextTag, red, green, blue, transparency)

    return bj_lastCreatedTextTag
end

--===========================================================================
---@type fun(tt: texttag)
function DestroyTextTagBJ(tt)
    DestroyTextTag(tt)
end

--===========================================================================
---@type fun(show: boolean, tt: texttag, whichForce: force)
function ShowTextTagForceBJ(show, tt, whichForce)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        SetTextTagVisibility(tt, show)
    end
end

--===========================================================================
---@type fun():texttag
function GetLastCreatedTextTag()
    return bj_lastCreatedTextTag
end



--***************************************************************************
--*
--*  Cinematic Utility Functions
--*
--***************************************************************************

--===========================================================================
function PauseGameOn()
    PauseGame(true)
end

--===========================================================================
function PauseGameOff()
    PauseGame(false)
end

--===========================================================================
---@type fun(whichForce: force)
function SetUserControlForceOn(whichForce)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        EnableUserControl(true)
    end
end

--===========================================================================
---@type fun(whichForce: force)
function SetUserControlForceOff(whichForce)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        EnableUserControl(false)
    end
end

--===========================================================================
---@type fun(whichForce: force, fadeDuration: number)
function ShowInterfaceForceOn(whichForce, fadeDuration)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ShowInterface(true, fadeDuration)
    end
end

--===========================================================================
---@type fun(whichForce: force, fadeDuration: number)
function ShowInterfaceForceOff(whichForce, fadeDuration)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        ShowInterface(false, fadeDuration)
    end
end

--===========================================================================
---@type fun(whichForce: force, x: number, y: number, duration: number)
function PingMinimapForForce(whichForce, x, y, duration)
    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PingMinimap(x, y, duration)
        --call StartSound(bj_pingMinimapSound)
    end
end

--===========================================================================
---@type fun(whichForce: force, loc: location, duration: number)
function PingMinimapLocForForce(whichForce, loc, duration)
    PingMinimapForForce(whichForce, GetLocationX(loc), GetLocationY(loc), duration)
end

--===========================================================================
---@type fun(whichPlayer: player, x: number, y: number, duration: number)
function PingMinimapForPlayer(whichPlayer, x, y, duration)
    if (GetLocalPlayer() == whichPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        PingMinimap(x, y, duration)
        --call StartSound(bj_pingMinimapSound)
    end
end

--===========================================================================
---@type fun(whichPlayer: player, loc: location, duration: number)
function PingMinimapLocForPlayer(whichPlayer, loc, duration)
    PingMinimapForPlayer(whichPlayer, GetLocationX(loc), GetLocationY(loc), duration)
end

--===========================================================================
---@type fun(whichForce: force, x: number, y: number, duration: number, style: integer, red: number, green: number, blue: number)
function PingMinimapForForceEx(whichForce, x, y, duration, style, red, green, blue)
    local red255           = PercentTo255(red) ---@type integer 
    local green255         = PercentTo255(green) ---@type integer 
    local blue255          = PercentTo255(blue) ---@type integer 

    if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        -- Prevent 100% red simple and flashy pings, as they become "attack" pings.
        if (red255 == 255) and (green255 == 0) and (blue255 == 0) then
            red255 = 254
        end

        if (style == bj_MINIMAPPINGSTYLE_SIMPLE) then
            PingMinimapEx(x, y, duration, red255, green255, blue255, false)
        elseif (style == bj_MINIMAPPINGSTYLE_FLASHY) then
            PingMinimapEx(x, y, duration, red255, green255, blue255, true)
        elseif (style == bj_MINIMAPPINGSTYLE_ATTACK) then
            PingMinimapEx(x, y, duration, 255, 0, 0, false)
        else
            -- Unrecognized ping style - ignore the request.
        end
        
        --call StartSound(bj_pingMinimapSound)
    end
end

--===========================================================================
---@type fun(whichForce: force, loc: location, duration: number, style: integer, red: number, green: number, blue: number)
function PingMinimapLocForForceEx(whichForce, loc, duration, style, red, green, blue)
    PingMinimapForForceEx(whichForce, GetLocationX(loc), GetLocationY(loc), duration, style, red, green, blue)
end

--===========================================================================
---@type fun(enable: boolean, f: force)
function EnableWorldFogBoundaryBJ(enable, f)
    if (IsPlayerInForce(GetLocalPlayer(), f)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        EnableWorldFogBoundary(enable)
    end
end

--===========================================================================
---@type fun(enable: boolean, f: force)
function EnableOcclusionBJ(enable, f)
    if (IsPlayerInForce(GetLocalPlayer(), f)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.
        EnableOcclusion(enable)
    end
end



--***************************************************************************
--*
--*  Cinematic Transmission Utility Functions
--*
--***************************************************************************

--===========================================================================
-- If cancelled, stop the sound and end the cinematic scene.
--
function CancelCineSceneBJ()
    StopSoundBJ(bj_cineSceneLastSound, true)
    EndCinematicScene()
end

--===========================================================================
-- Init a trigger to listen for END_CINEMATIC events and respond to them if
-- a cinematic scene is in progress.  For performance reasons, this should
-- only be called once a cinematic scene has been started, so that maps
-- lacking such scenes do not bother to register for these events.
--
function TryInitCinematicBehaviorBJ()
    local index ---@type integer 

    if (bj_cineSceneBeingSkipped == nil) then
        bj_cineSceneBeingSkipped = CreateTrigger()
        index = 0
        repeat
            TriggerRegisterPlayerEvent(bj_cineSceneBeingSkipped, Player(index), EVENT_PLAYER_END_CINEMATIC)
            index = index + 1
        until index == bj_MAX_PLAYERS
        TriggerAddAction(bj_cineSceneBeingSkipped, CancelCineSceneBJ)
    end
end

--===========================================================================
---@type fun(soundHandle: sound, portraitUnitId: integer, color: playercolor, speakerTitle: string, text: string, sceneDuration: number, voiceoverDuration: number)
function SetCinematicSceneBJ(soundHandle, portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration)
    bj_cineSceneLastSound = soundHandle
    SetCinematicScene(portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration)
    PlaySoundBJ(soundHandle)
end

--===========================================================================
---@type fun(soundHandle: sound, timeType: integer, timeVal: number):number
function GetTransmissionDuration(soundHandle, timeType, timeVal)
    local duration ---@type number 

    if (timeType == bj_TIMETYPE_ADD) then
        duration = GetSoundDurationBJ(soundHandle) + timeVal
    elseif (timeType == bj_TIMETYPE_SET) then
        duration = timeVal
    elseif (timeType == bj_TIMETYPE_SUB) then
        duration = GetSoundDurationBJ(soundHandle) - timeVal
    else
        -- Unrecognized timeType - ignore timeVal.
        duration = GetSoundDurationBJ(soundHandle)
    end

    -- Make sure we have a non-negative duration.
    if (duration < 0) then
        duration = 0
    end
    return duration
end

--===========================================================================
---@type fun(soundHandle: sound, timeType: integer, timeVal: number)
function WaitTransmissionDuration(soundHandle, timeType, timeVal)
    if (timeType == bj_TIMETYPE_SET) then
        -- If we have a static duration wait, just perform the wait.
        TriggerSleepAction(timeVal)

    elseif (soundHandle == nil) then
        -- If the sound does not exist, perform a default length wait.
        TriggerSleepAction(bj_NOTHING_SOUND_DURATION)

    elseif (timeType == bj_TIMETYPE_SUB) then
        -- If the transmission is cutting off the sound, wait for the sound
        -- to be mostly finished.
        WaitForSoundBJ(soundHandle, timeVal)

    elseif (timeType == bj_TIMETYPE_ADD) then
        -- If the transmission is extending beyond the sound's length, wait
        -- for it to finish, and then wait the additional time.
        WaitForSoundBJ(soundHandle, 0)
        TriggerSleepAction(timeVal)

    else
        -- Unrecognized timeType - ignore.
    end
end

--===========================================================================
---@type fun(unitId: integer, color: playercolor, x: number, y: number, soundHandle: sound, unitName: string, message: string, duration: number)
function DoTransmissionBasicsXYBJ(unitId, color, x, y, soundHandle, unitName, message, duration)
    SetCinematicSceneBJ(soundHandle, unitId, color, unitName, message, duration + bj_TRANSMISSION_PORT_HANGTIME, duration)

    if (unitId ~= 0) then
        PingMinimap(x, y, bj_TRANSMISSION_PING_TIME)
        --call SetCameraQuickPosition(x, y)
    end
end

--===========================================================================
-- Display a text message to a Player Group with an accompanying sound,
-- portrait, speech indicator, and all that good stuff.
--   - Query duration of sound
--   - Play sound
--   - Display text message for duration
--   - Display animating portrait for duration
--   - Display a speech indicator for the unit
--   - Ping the minimap
--
---@type fun(toForce: force, whichUnit: unit, unitName: string, soundHandle: sound, message: string, timeType: integer, timeVal: number, wait: boolean)
function TransmissionFromUnitWithNameBJ(toForce, whichUnit, unitName, soundHandle, message, timeType, timeVal, wait)
    TryInitCinematicBehaviorBJ()

    AttachSoundToUnit(soundHandle, whichUnit)

    -- Ensure that the time value is non-negative.
    timeVal = RMaxBJ(timeVal, 0)

    bj_lastTransmissionDuration = GetTransmissionDuration(soundHandle, timeType, timeVal)
    bj_lastPlayedSound = soundHandle

    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        if (whichUnit == nil) then
            -- If the unit reference is invalid, send the transmission from the center of the map with no portrait.
            DoTransmissionBasicsXYBJ(0, PLAYER_COLOR_RED, 0, 0, soundHandle, unitName, message, bj_lastTransmissionDuration)
        else
            DoTransmissionBasicsXYBJ(GetUnitTypeId(whichUnit), GetPlayerColor(GetOwningPlayer(whichUnit)), GetUnitX(whichUnit), GetUnitY(whichUnit), soundHandle, unitName, message, bj_lastTransmissionDuration)
            if (not IsUnitHidden(whichUnit)) then
                UnitAddIndicator(whichUnit, bj_TRANSMISSION_IND_RED, bj_TRANSMISSION_IND_BLUE, bj_TRANSMISSION_IND_GREEN, bj_TRANSMISSION_IND_ALPHA)
            end
        end
    end

    if wait and (bj_lastTransmissionDuration > 0) then
        -- call TriggerSleepAction(bj_lastTransmissionDuration)
        WaitTransmissionDuration(soundHandle, timeType, timeVal)
    end

end

--===========================================================================
---@type fun(toForce: force, speaker: unit, speakerType: integer, soundHandle: sound, timeType: integer, timeVal: number, wait: boolean):boolean
function PlayDialogueFromSpeakerEx(toForce, speaker, speakerType, soundHandle, timeType, timeVal, wait)
    --Make sure that the runtime unit type and the parameter are the same,
    --otherwise the offline animations will not match and will fail
    if GetUnitTypeId(speaker) ~= speakerType then
        --debug BJDebugMsg(("Attempted to play FacialAnimation with the wrong speaker UnitType - Param: ".. I2S(speakerType) .." Runtime: "..  I2S(GetUnitTypeId(speaker))))
        --return false
    end

    TryInitCinematicBehaviorBJ()

    AttachSoundToUnit(soundHandle, speaker)

    -- Ensure that the time value is non-negative.
    timeVal = RMaxBJ(timeVal, 0)

    bj_lastTransmissionDuration = GetTransmissionDuration(soundHandle, timeType, timeVal)
    bj_lastPlayedSound = soundHandle

    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        SetCinematicSceneBJ(soundHandle, speakerType, GetPlayerColor(GetOwningPlayer(speaker)), GetLocalizedString(GetDialogueSpeakerNameKey(soundHandle)), GetLocalizedString(GetDialogueTextKey(soundHandle)), bj_lastTransmissionDuration + bj_TRANSMISSION_PORT_HANGTIME, bj_lastTransmissionDuration)
    end

    if wait and (bj_lastTransmissionDuration > 0) then
        -- call TriggerSleepAction(bj_lastTransmissionDuration)
        WaitTransmissionDuration(soundHandle, timeType, timeVal)
    end

    return true
end

--===========================================================================
---@type fun(toForce: force, fromPlayer: player, speakerType: integer, loc: location, soundHandle: sound, timeType: integer, timeVal: number, wait: boolean):boolean
function PlayDialogueFromSpeakerTypeEx(toForce, fromPlayer, speakerType, loc, soundHandle, timeType, timeVal, wait)
    TryInitCinematicBehaviorBJ()

    -- Ensure that the time value is non-negative.
    timeVal = RMaxBJ(timeVal, 0)

    bj_lastTransmissionDuration = GetTransmissionDuration(soundHandle, timeType, timeVal)
    bj_lastPlayedSound = soundHandle

    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        SetCinematicSceneBJ(soundHandle, speakerType, GetPlayerColor(fromPlayer), GetLocalizedString(GetDialogueSpeakerNameKey(soundHandle)), GetLocalizedString(GetDialogueTextKey(soundHandle)), bj_lastTransmissionDuration + bj_TRANSMISSION_PORT_HANGTIME, bj_lastTransmissionDuration)
        if(speakerType ~= 0) then
            PingMinimap(GetLocationX(loc), GetLocationY(loc), bj_TRANSMISSION_PING_TIME)
        end
    end

    if wait and (bj_lastTransmissionDuration > 0) then
        -- call TriggerSleepAction(bj_lastTransmissionDuration)
        WaitTransmissionDuration(soundHandle, timeType, timeVal)
    end

    return true
end

--===========================================================================
-- This operates like TransmissionFromUnitWithNameBJ, but for a unit type
-- rather than a unit instance.  As such, no speech indicator is employed.
--
---@type fun(toForce: force, fromPlayer: player, unitId: integer, unitName: string, loc: location, soundHandle: sound, message: string, timeType: integer, timeVal: number, wait: boolean)
function TransmissionFromUnitTypeWithNameBJ(toForce, fromPlayer, unitId, unitName, loc, soundHandle, message, timeType, timeVal, wait)
    TryInitCinematicBehaviorBJ()

    -- Ensure that the time value is non-negative.
    timeVal = RMaxBJ(timeVal, 0)

    bj_lastTransmissionDuration = GetTransmissionDuration(soundHandle, timeType, timeVal)
    bj_lastPlayedSound = soundHandle

    if (IsPlayerInForce(GetLocalPlayer(), toForce)) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        DoTransmissionBasicsXYBJ(unitId, GetPlayerColor(fromPlayer), GetLocationX(loc), GetLocationY(loc), soundHandle, unitName, message, bj_lastTransmissionDuration)
    end

    if wait and (bj_lastTransmissionDuration > 0) then
        -- call TriggerSleepAction(bj_lastTransmissionDuration)
        WaitTransmissionDuration(soundHandle, timeType, timeVal)
    end

end

--===========================================================================
---@type fun():number
function GetLastTransmissionDurationBJ()
    return bj_lastTransmissionDuration
end

--===========================================================================
---@type fun(flag: boolean)
function ForceCinematicSubtitlesBJ(flag)
    ForceCinematicSubtitles(flag)
end


--***************************************************************************
--*
--*  Cinematic Mode Utility Functions
--*
--***************************************************************************

--===========================================================================
-- Makes many common UI settings changes at once, for use when beginning and
-- ending cinematic sequences.  Note that some affects apply to all players,
-- such as game speed.  This is unavoidable.
--   - Clear the screen of text messages
--   - Hide interface UI (letterbox mode)
--   - Hide game messages (ally under attack, etc.)
--   - Disable user control
--   - Disable occlusion
--   - Set game speed (for all players)
--   - Lock game speed (for all players)
--   - Disable black mask (for all players)
--   - Disable fog of war (for all players)
--   - Disable world boundary fog (for all players)
--   - Dim non-speech sound channels
--   - End any outstanding music themes
--   - Fix the random seed to a set value
--   - Reset the camera smoothing factor
--
---@type fun(cineMode: boolean, forForce: force, interfaceFadeTime: number)
function CinematicModeExBJ(cineMode, forForce, interfaceFadeTime)
    -- If the game hasn't started yet, perform interface fades immediately
    if (not bj_gameStarted) then
        interfaceFadeTime = 0
    end

    if (cineMode) then
        -- Save the UI state so that we can restore it later.
        if (not bj_cineModeAlreadyIn) then
            SetCinematicAudio(true)
            bj_cineModeAlreadyIn = true
            bj_cineModePriorSpeed = GetGameSpeed()
            bj_cineModePriorFogSetting = IsFogEnabled()
            bj_cineModePriorMaskSetting = IsFogMaskEnabled()
            bj_cineModePriorDawnDusk = IsDawnDuskEnabled()
            bj_cineModeSavedSeed = GetRandomInt(0, 1000000)
        end

        -- Perform local changes
        if (IsPlayerInForce(GetLocalPlayer(), forForce)) then
            -- Use only local code (no net traffic) within this block to avoid desyncs.
            ClearTextMessages()
            ShowInterface(false, interfaceFadeTime)
            EnableUserControl(false)
            EnableOcclusion(false)
            SetCineModeVolumeGroupsBJ()
        end

        -- Perform global changes
        SetGameSpeed(bj_CINEMODE_GAMESPEED)
        SetMapFlag(MAP_LOCK_SPEED, true)
        FogMaskEnable(false)
        FogEnable(false)
        EnableWorldFogBoundary(false)
        EnableDawnDusk(false)

        -- Use a fixed random seed, so that cinematics play consistently.
        SetRandomSeed(0)
    else
        bj_cineModeAlreadyIn = false
        SetCinematicAudio(false)

        -- Perform local changes
        if (IsPlayerInForce(GetLocalPlayer(), forForce)) then
            -- Use only local code (no net traffic) within this block to avoid desyncs.
            ShowInterface(true, interfaceFadeTime)
            EnableUserControl(true)
            EnableOcclusion(true)
            VolumeGroupReset()
            EndThematicMusic()
            CameraResetSmoothingFactorBJ()
        end

        -- Perform global changes
        SetMapFlag(MAP_LOCK_SPEED, false)
        SetGameSpeed(bj_cineModePriorSpeed)
        FogMaskEnable(bj_cineModePriorMaskSetting)
        FogEnable(bj_cineModePriorFogSetting)
        EnableWorldFogBoundary(true)
        EnableDawnDusk(bj_cineModePriorDawnDusk)
        SetRandomSeed(bj_cineModeSavedSeed)
    end
end

--===========================================================================
---@type fun(cineMode: boolean, forForce: force)
function CinematicModeBJ(cineMode, forForce)
    CinematicModeExBJ(cineMode, forForce, bj_CINEMODE_INTERFACEFADE)
end



--***************************************************************************
--*
--*  Cinematic Filter Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(flag: boolean)
function DisplayCineFilterBJ(flag)
    DisplayCineFilter(flag)
end

--===========================================================================
---@type fun(red: number, green: number, blue: number, duration: number, tex: string, startTrans: number, endTrans: number)
function CinematicFadeCommonBJ(red, green, blue, duration, tex, startTrans, endTrans)
    if (duration == 0) then
        -- If the fade is instant, use the same starting and ending values,
        -- so that we effectively do a set rather than a fade.
        startTrans = endTrans
    end
    EnableUserUI(false)
    SetCineFilterTexture(tex)
    SetCineFilterBlendMode(BLEND_MODE_BLEND)
    SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    SetCineFilterStartUV(0, 0, 1, 1)
    SetCineFilterEndUV(0, 0, 1, 1)
    SetCineFilterStartColor(PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-startTrans))
    SetCineFilterEndColor(PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0-endTrans))
    SetCineFilterDuration(duration)
    DisplayCineFilter(true)
end

--===========================================================================
function FinishCinematicFadeBJ()
    DestroyTimer(bj_cineFadeFinishTimer)
    bj_cineFadeFinishTimer = nil
    DisplayCineFilter(false)
    EnableUserUI(true)
end

--===========================================================================
---@type fun(duration: number)
function FinishCinematicFadeAfterBJ(duration)
    -- Create a timer to end the cinematic fade.
    bj_cineFadeFinishTimer = CreateTimer()
    TimerStart(bj_cineFadeFinishTimer, duration, false, FinishCinematicFadeBJ)
end

--===========================================================================
function ContinueCinematicFadeBJ()
    DestroyTimer(bj_cineFadeContinueTimer)
    bj_cineFadeContinueTimer = nil
    CinematicFadeCommonBJ(bj_cineFadeContinueRed, bj_cineFadeContinueGreen, bj_cineFadeContinueBlue, bj_cineFadeContinueDuration, bj_cineFadeContinueTex, bj_cineFadeContinueTrans, 100)
end

--===========================================================================
---@type fun(duration: number, red: number, green: number, blue: number, trans: number, tex: string)
function ContinueCinematicFadeAfterBJ(duration, red, green, blue, trans, tex)
    bj_cineFadeContinueRed = red
    bj_cineFadeContinueGreen = green
    bj_cineFadeContinueBlue = blue
    bj_cineFadeContinueTrans = trans
    bj_cineFadeContinueDuration = duration
    bj_cineFadeContinueTex = tex

    -- Create a timer to continue the cinematic fade.
    bj_cineFadeContinueTimer = CreateTimer()
    TimerStart(bj_cineFadeContinueTimer, duration, false, ContinueCinematicFadeBJ)
end

--===========================================================================
function AbortCinematicFadeBJ()
    if (bj_cineFadeContinueTimer ~= nil) then
        DestroyTimer(bj_cineFadeContinueTimer)
    end

    if (bj_cineFadeFinishTimer ~= nil) then
        DestroyTimer(bj_cineFadeFinishTimer)
    end
end

--===========================================================================
---@type fun(fadetype: integer, duration: number, tex: string, red: number, green: number, blue: number, trans: number)
function CinematicFadeBJ(fadetype, duration, tex, red, green, blue, trans)
    if (fadetype == bj_CINEFADETYPE_FADEOUT) then
        -- Fade out to the requested color.
        AbortCinematicFadeBJ()
        CinematicFadeCommonBJ(red, green, blue, duration, tex, 100, trans)
    elseif (fadetype == bj_CINEFADETYPE_FADEIN) then
        -- Fade in from the requested color.
        AbortCinematicFadeBJ()
        CinematicFadeCommonBJ(red, green, blue, duration, tex, trans, 100)
        FinishCinematicFadeAfterBJ(duration)
    elseif (fadetype == bj_CINEFADETYPE_FADEOUTIN) then
        -- Fade out to the requested color, and then fade back in from it.
        if (duration > 0) then
            AbortCinematicFadeBJ()
            CinematicFadeCommonBJ(red, green, blue, duration * 0.5, tex, 100, trans)
            ContinueCinematicFadeAfterBJ(duration * 0.5, red, green, blue, trans, tex)
            FinishCinematicFadeAfterBJ(duration)
        end
    else
        -- Unrecognized fadetype - ignore the request.
    end
end

--===========================================================================
---@type fun(duration: number, bmode: blendmode, tex: string, red0: number, green0: number, blue0: number, trans0: number, red1: number, green1: number, blue1: number, trans1: number)
function CinematicFilterGenericBJ(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    AbortCinematicFadeBJ()
    SetCineFilterTexture(tex)
    SetCineFilterBlendMode(bmode)
    SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    SetCineFilterStartUV(0, 0, 1, 1)
    SetCineFilterEndUV(0, 0, 1, 1)
    SetCineFilterStartColor(PercentTo255(red0), PercentTo255(green0), PercentTo255(blue0), PercentTo255(100.0-trans0))
    SetCineFilterEndColor(PercentTo255(red1), PercentTo255(green1), PercentTo255(blue1), PercentTo255(100.0-trans1))
    SetCineFilterDuration(duration)
    DisplayCineFilter(true)
end



--***************************************************************************
--*
--*  Rescuable Unit Utility Functions
--*
--***************************************************************************

--===========================================================================
-- Rescues a unit for a player.  This performs the default rescue behavior,
-- including a rescue sound, flashing selection circle, ownership change,
-- and optionally a unit color change.
--
---@type fun(whichUnit: unit, rescuer: player, changeColor: boolean)
function RescueUnitBJ(whichUnit, rescuer, changeColor)
    if IsUnitDeadBJ(whichUnit) or (GetOwningPlayer(whichUnit) == rescuer) then
        return
    end

    StartSound(bj_rescueSound)
    SetUnitOwner(whichUnit, rescuer, changeColor)
    UnitAddIndicator(whichUnit, 0, 255, 0, 255)
    PingMinimapForPlayer(rescuer, GetUnitX(whichUnit), GetUnitY(whichUnit), bj_RESCUE_PING_TIME)
end

--===========================================================================
function TriggerActionUnitRescuedBJ()
    local theUnit      = GetTriggerUnit() ---@type unit 

    if IsUnitType(theUnit, UNIT_TYPE_STRUCTURE) then
        RescueUnitBJ(theUnit, GetOwningPlayer(GetRescuer()), bj_rescueChangeColorBldg)
    else
        RescueUnitBJ(theUnit, GetOwningPlayer(GetRescuer()), bj_rescueChangeColorUnit)
    end
end

--===========================================================================
-- Attempt to init triggers for default rescue behavior.  For performance
-- reasons, this should only be attempted if a player is set to Rescuable,
-- or if a specific unit is thus flagged.
--
function TryInitRescuableTriggersBJ()
    local index ---@type integer 

    if (bj_rescueUnitBehavior == nil) then
        bj_rescueUnitBehavior = CreateTrigger()
        index = 0
        repeat
            TriggerRegisterPlayerUnitEvent(bj_rescueUnitBehavior, Player(index), EVENT_PLAYER_UNIT_RESCUED, nil)
            index = index + 1
        until index == bj_MAX_PLAYER_SLOTS
        TriggerAddAction(bj_rescueUnitBehavior, TriggerActionUnitRescuedBJ)
    end
end

--===========================================================================
-- Determines whether or not rescued units automatically change color upon
-- being rescued.
--
---@type fun(changeColor: boolean)
function SetRescueUnitColorChangeBJ(changeColor)
    bj_rescueChangeColorUnit = changeColor
end

--===========================================================================
-- Determines whether or not rescued buildings automatically change color
-- upon being rescued.
--
---@type fun(changeColor: boolean)
function SetRescueBuildingColorChangeBJ(changeColor)
    bj_rescueChangeColorBldg = changeColor
end

--===========================================================================
function MakeUnitRescuableToForceBJEnum()
    TryInitRescuableTriggersBJ()
    SetUnitRescuable(bj_makeUnitRescuableUnit, GetEnumPlayer(), bj_makeUnitRescuableFlag)
end

--===========================================================================
---@type fun(whichUnit: unit, isRescuable: boolean, whichForce: force)
function MakeUnitRescuableToForceBJ(whichUnit, isRescuable, whichForce)
    -- Flag the unit as rescuable/unrescuable for the appropriate players.
    bj_makeUnitRescuableUnit = whichUnit
    bj_makeUnitRescuableFlag = isRescuable
    ForForce(whichForce, MakeUnitRescuableToForceBJEnum)
end

--===========================================================================
function InitRescuableBehaviorBJ()
    local index ---@type integer 

    index = 0
    repeat
        -- If at least one player slot is "Rescuable"-controlled, init the
        -- rescue behavior triggers.
        if (GetPlayerController(Player(index)) == MAP_CONTROL_RESCUABLE) then
            TryInitRescuableTriggersBJ()
            return
        end
        index = index + 1
    until index == bj_MAX_PLAYERS
end



--***************************************************************************
--*
--*  Research and Upgrade Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(techid: integer, levels: integer, whichPlayer: player)
function SetPlayerTechResearchedSwap(techid, levels, whichPlayer)
    SetPlayerTechResearched(whichPlayer, techid, levels)
end

--===========================================================================
---@type fun(techid: integer, maximum: integer, whichPlayer: player)
function SetPlayerTechMaxAllowedSwap(techid, maximum, whichPlayer)
    SetPlayerTechMaxAllowed(whichPlayer, techid, maximum)
end

--===========================================================================
---@type fun(maximum: integer, whichPlayer: player)
function SetPlayerMaxHeroesAllowed(maximum, whichPlayer)
    SetPlayerTechMaxAllowed(whichPlayer, FourCC('HERO'), maximum)
end

--===========================================================================
---@type fun(techid: integer, whichPlayer: player):integer
function GetPlayerTechCountSimple(techid, whichPlayer)
    return GetPlayerTechCount(whichPlayer, techid, true)
end

--===========================================================================
---@type fun(techid: integer, whichPlayer: player):integer
function GetPlayerTechMaxAllowedSwap(techid, whichPlayer)
    return GetPlayerTechMaxAllowed(whichPlayer, techid)
end

--===========================================================================
---@type fun(avail: boolean, abilid: integer, whichPlayer: player)
function SetPlayerAbilityAvailableBJ(avail, abilid, whichPlayer)
    SetPlayerAbilityAvailable(whichPlayer, abilid, avail)
end



--***************************************************************************
--*
--*  Campaign Utility Functions
--*
--***************************************************************************

---@type fun(campaignNumber: integer)
function SetCampaignMenuRaceBJ(campaignNumber)
    if (campaignNumber == bj_CAMPAIGN_INDEX_T) then
        SetCampaignMenuRace(RACE_OTHER)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_H) then
        SetCampaignMenuRace(RACE_HUMAN)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_U) then
        SetCampaignMenuRace(RACE_UNDEAD)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_O) then
        SetCampaignMenuRace(RACE_ORC)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_N) then
        SetCampaignMenuRace(RACE_NIGHTELF)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XN) then
        SetCampaignMenuRaceEx(bj_CAMPAIGN_OFFSET_XN)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XH) then
        SetCampaignMenuRaceEx(bj_CAMPAIGN_OFFSET_XH)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XU) then
        SetCampaignMenuRaceEx(bj_CAMPAIGN_OFFSET_XU)
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XO) then
        SetCampaignMenuRaceEx(bj_CAMPAIGN_OFFSET_XO)
    else
        -- Unrecognized campaign - ignore the request
    end
end

--===========================================================================
-- Converts a single campaign mission designation into campaign and mission
-- numbers.  The 1000's digit is considered the campaign index, and the 1's
-- digit is considered the mission index within that campaign.  This is done
-- so that the trigger for this can use a single drop-down to list all of
-- the campaign missions.
--
---@type fun(available: boolean, missionIndex: integer)
function SetMissionAvailableBJ(available, missionIndex)
    local campaignNumber         = missionIndex // 1000 ---@type integer 
    local missionNumber         = missionIndex - campaignNumber * 1000 ---@type integer 

    SetMissionAvailable(campaignNumber, missionNumber, available)
end

--===========================================================================
---@type fun(available: boolean, campaignNumber: integer)
function SetCampaignAvailableBJ(available, campaignNumber)
    local campaignOffset ---@type integer 

    if (campaignNumber == bj_CAMPAIGN_INDEX_H) then
        SetTutorialCleared(true)
    end

    if (campaignNumber == bj_CAMPAIGN_INDEX_XN) then
        campaignOffset = bj_CAMPAIGN_OFFSET_XN
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XH) then
        campaignOffset = bj_CAMPAIGN_OFFSET_XH
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XU) then
        campaignOffset = bj_CAMPAIGN_OFFSET_XU
    elseif (campaignNumber == bj_CAMPAIGN_INDEX_XO) then
        campaignOffset = bj_CAMPAIGN_OFFSET_XO
    else
        campaignOffset = campaignNumber
    end

    SetCampaignAvailable(campaignOffset, available)
    SetCampaignMenuRaceBJ(campaignNumber)
    ForceCampaignSelectScreen()
end

--===========================================================================
---@type fun(available: boolean, cinematicIndex: integer)
function SetCinematicAvailableBJ(available, cinematicIndex)
    if ( cinematicIndex == bj_CINEMATICINDEX_TOP ) then
        SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_T, available )
        PlayCinematic( "TutorialOp" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_HOP) then
        SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_H, available )
        PlayCinematic( "HumanOp" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_HED) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_H, available )
        PlayCinematic( "HumanEd" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_OOP) then
        SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_O, available )
        PlayCinematic( "OrcOp" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_OED) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_O, available )
        PlayCinematic( "OrcEd" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_UOP) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_U, available )
        PlayCinematic( "UndeadOp" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_UED) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_U, available )
        PlayCinematic( "UndeadEd" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_NOP) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_N, available )
        PlayCinematic( "NightElfOp" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_NED) then
        SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_N, available )
        PlayCinematic( "NightElfEd" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_XOP) then
        SetOpCinematicAvailable( bj_CAMPAIGN_OFFSET_XN, available )
        -- call PlayCinematic( "IntroX" )
    elseif (cinematicIndex == bj_CINEMATICINDEX_XED) then
        SetEdCinematicAvailable( bj_CAMPAIGN_OFFSET_XU, available )
        PlayCinematic( "OutroX" )
    else
        -- Unrecognized cinematic - ignore the request.
    end
end

--===========================================================================
---@type fun(campaignFile: string):gamecache
function InitGameCacheBJ(campaignFile)
    bj_lastCreatedGameCache = InitGameCache(campaignFile)
    return bj_lastCreatedGameCache
end

--===========================================================================
---@type fun(cache: gamecache):boolean
function SaveGameCacheBJ(cache)
    return SaveGameCache(cache)
end

--===========================================================================
---@type fun():gamecache
function GetLastCreatedGameCacheBJ()
    return bj_lastCreatedGameCache
end

--===========================================================================
---@type fun():hashtable
function InitHashtableBJ()
    bj_lastCreatedHashtable = InitHashtable()
    return bj_lastCreatedHashtable
end

--===========================================================================
---@type fun():hashtable
function GetLastCreatedHashtableBJ()
    return bj_lastCreatedHashtable
end

--===========================================================================
---@type fun(value: number, key: string, missionKey: string, cache: gamecache)
function StoreRealBJ(value, key, missionKey, cache)
    StoreReal(cache, missionKey, key, value)
end

--===========================================================================
---@type fun(value: integer, key: string, missionKey: string, cache: gamecache)
function StoreIntegerBJ(value, key, missionKey, cache)
    StoreInteger(cache, missionKey, key, value)
end

--===========================================================================
---@type fun(value: boolean, key: string, missionKey: string, cache: gamecache)
function StoreBooleanBJ(value, key, missionKey, cache)
    StoreBoolean(cache, missionKey, key, value)
end

--===========================================================================
---@type fun(value: string, key: string, missionKey: string, cache: gamecache):boolean
function StoreStringBJ(value, key, missionKey, cache)
    return StoreString(cache, missionKey, key, value)
end

--===========================================================================
---@type fun(whichUnit: unit, key: string, missionKey: string, cache: gamecache):boolean
function StoreUnitBJ(whichUnit, key, missionKey, cache)
    return StoreUnit(cache, missionKey, key, whichUnit)
end

--===========================================================================
---@type fun(value: number, key: integer, missionKey: integer, table: hashtable)
function SaveRealBJ(value, key, missionKey, table)
    SaveReal(table, missionKey, key, value)
end

--===========================================================================
---@type fun(value: integer, key: integer, missionKey: integer, table: hashtable)
function SaveIntegerBJ(value, key, missionKey, table)
    SaveInteger(table, missionKey, key, value)
end

--===========================================================================
---@type fun(value: boolean, key: integer, missionKey: integer, table: hashtable)
function SaveBooleanBJ(value, key, missionKey, table)
    SaveBoolean(table, missionKey, key, value)
end

--===========================================================================
---@type fun(value: string, key: integer, missionKey: integer, table: hashtable):boolean
function SaveStringBJ(value, key, missionKey, table)
    return SaveStr(table, missionKey, key, value)
end

--===========================================================================
---@type fun(whichPlayer: player, key: integer, missionKey: integer, table: hashtable):boolean
function SavePlayerHandleBJ(whichPlayer, key, missionKey, table)
    return SavePlayerHandle(table, missionKey, key, whichPlayer)
end

--===========================================================================
---@type fun(whichWidget: widget, key: integer, missionKey: integer, table: hashtable):boolean
function SaveWidgetHandleBJ(whichWidget, key, missionKey, table)
    return SaveWidgetHandle(table, missionKey, key, whichWidget)
end

--===========================================================================
---@type fun(whichDestructable: destructable, key: integer, missionKey: integer, table: hashtable):boolean
function SaveDestructableHandleBJ(whichDestructable, key, missionKey, table)
    return SaveDestructableHandle(table, missionKey, key, whichDestructable)
end

--===========================================================================
---@type fun(whichItem: item, key: integer, missionKey: integer, table: hashtable):boolean
function SaveItemHandleBJ(whichItem, key, missionKey, table)
    return SaveItemHandle(table, missionKey, key, whichItem)
end

--===========================================================================
---@type fun(whichUnit: unit, key: integer, missionKey: integer, table: hashtable):boolean
function SaveUnitHandleBJ(whichUnit, key, missionKey, table)
    return SaveUnitHandle(table, missionKey, key, whichUnit)
end

--===========================================================================
---@type fun(whichAbility: ability, key: integer, missionKey: integer, table: hashtable):boolean
function SaveAbilityHandleBJ(whichAbility, key, missionKey, table)
    return SaveAbilityHandle(table, missionKey, key, whichAbility)
end

--===========================================================================
---@type fun(whichTimer: timer, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTimerHandleBJ(whichTimer, key, missionKey, table)
    return SaveTimerHandle(table, missionKey, key, whichTimer)
end

--===========================================================================
---@type fun(whichTrigger: trigger, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTriggerHandleBJ(whichTrigger, key, missionKey, table)
    return SaveTriggerHandle(table, missionKey, key, whichTrigger)
end

--===========================================================================
---@type fun(whichTriggercondition: triggercondition, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTriggerConditionHandleBJ(whichTriggercondition, key, missionKey, table)
    return SaveTriggerConditionHandle(table, missionKey, key, whichTriggercondition)
end

--===========================================================================
---@type fun(whichTriggeraction: triggeraction, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTriggerActionHandleBJ(whichTriggeraction, key, missionKey, table)
    return SaveTriggerActionHandle(table, missionKey, key, whichTriggeraction)
end

--===========================================================================
---@type fun(whichEvent: event, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTriggerEventHandleBJ(whichEvent, key, missionKey, table)
    return SaveTriggerEventHandle(table, missionKey, key, whichEvent)
end

--===========================================================================
---@type fun(whichForce: force, key: integer, missionKey: integer, table: hashtable):boolean
function SaveForceHandleBJ(whichForce, key, missionKey, table)
    return SaveForceHandle(table, missionKey, key, whichForce)
end

--===========================================================================
---@type fun(whichGroup: group, key: integer, missionKey: integer, table: hashtable):boolean
function SaveGroupHandleBJ(whichGroup, key, missionKey, table)
    return SaveGroupHandle(table, missionKey, key, whichGroup)
end

--===========================================================================
---@type fun(whichLocation: location, key: integer, missionKey: integer, table: hashtable):boolean
function SaveLocationHandleBJ(whichLocation, key, missionKey, table)
    return SaveLocationHandle(table, missionKey, key, whichLocation)
end

--===========================================================================
---@type fun(whichRect: rect, key: integer, missionKey: integer, table: hashtable):boolean
function SaveRectHandleBJ(whichRect, key, missionKey, table)
    return SaveRectHandle(table, missionKey, key, whichRect)
end

--===========================================================================
---@type fun(whichBoolexpr?: boolexpr, key: integer, missionKey: integer, table: hashtable):boolean
function SaveBooleanExprHandleBJ(whichBoolexpr, key, missionKey, table)
    return SaveBooleanExprHandle(table, missionKey, key, whichBoolexpr)
end

--===========================================================================
---@type fun(whichSound: sound, key: integer, missionKey: integer, table: hashtable):boolean
function SaveSoundHandleBJ(whichSound, key, missionKey, table)
    return SaveSoundHandle(table, missionKey, key, whichSound)
end

--===========================================================================
---@type fun(whichEffect: effect, key: integer, missionKey: integer, table: hashtable):boolean
function SaveEffectHandleBJ(whichEffect, key, missionKey, table)
    return SaveEffectHandle(table, missionKey, key, whichEffect)
end

--===========================================================================
---@type fun(whichUnitpool: unitpool, key: integer, missionKey: integer, table: hashtable):boolean
function SaveUnitPoolHandleBJ(whichUnitpool, key, missionKey, table)
    return SaveUnitPoolHandle(table, missionKey, key, whichUnitpool)
end

--===========================================================================
---@type fun(whichItempool: itempool, key: integer, missionKey: integer, table: hashtable):boolean
function SaveItemPoolHandleBJ(whichItempool, key, missionKey, table)
    return SaveItemPoolHandle(table, missionKey, key, whichItempool)
end

--===========================================================================
---@type fun(whichQuest: quest, key: integer, missionKey: integer, table: hashtable):boolean
function SaveQuestHandleBJ(whichQuest, key, missionKey, table)
    return SaveQuestHandle(table, missionKey, key, whichQuest)
end

--===========================================================================
---@type fun(whichQuestitem: questitem, key: integer, missionKey: integer, table: hashtable):boolean
function SaveQuestItemHandleBJ(whichQuestitem, key, missionKey, table)
    return SaveQuestItemHandle(table, missionKey, key, whichQuestitem)
end

--===========================================================================
---@type fun(whichDefeatcondition: defeatcondition, key: integer, missionKey: integer, table: hashtable):boolean
function SaveDefeatConditionHandleBJ(whichDefeatcondition, key, missionKey, table)
    return SaveDefeatConditionHandle(table, missionKey, key, whichDefeatcondition)
end

--===========================================================================
---@type fun(whichTimerdialog: timerdialog, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTimerDialogHandleBJ(whichTimerdialog, key, missionKey, table)
    return SaveTimerDialogHandle(table, missionKey, key, whichTimerdialog)
end

--===========================================================================
---@type fun(whichLeaderboard: leaderboard, key: integer, missionKey: integer, table: hashtable):boolean
function SaveLeaderboardHandleBJ(whichLeaderboard, key, missionKey, table)
    return SaveLeaderboardHandle(table, missionKey, key, whichLeaderboard)
end

--===========================================================================
---@type fun(whichMultiboard: multiboard, key: integer, missionKey: integer, table: hashtable):boolean
function SaveMultiboardHandleBJ(whichMultiboard, key, missionKey, table)
    return SaveMultiboardHandle(table, missionKey, key, whichMultiboard)
end

--===========================================================================
---@type fun(whichMultiboarditem: multiboarditem, key: integer, missionKey: integer, table: hashtable):boolean
function SaveMultiboardItemHandleBJ(whichMultiboarditem, key, missionKey, table)
    return SaveMultiboardItemHandle(table, missionKey, key, whichMultiboarditem)
end

--===========================================================================
---@type fun(whichTrackable: trackable, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTrackableHandleBJ(whichTrackable, key, missionKey, table)
    return SaveTrackableHandle(table, missionKey, key, whichTrackable)
end

--===========================================================================
---@type fun(whichDialog: dialog, key: integer, missionKey: integer, table: hashtable):boolean
function SaveDialogHandleBJ(whichDialog, key, missionKey, table)
    return SaveDialogHandle(table, missionKey, key, whichDialog)
end

--===========================================================================
---@type fun(whichButton: button, key: integer, missionKey: integer, table: hashtable):boolean
function SaveButtonHandleBJ(whichButton, key, missionKey, table)
    return SaveButtonHandle(table, missionKey, key, whichButton)
end

--===========================================================================
---@type fun(whichTexttag: texttag, key: integer, missionKey: integer, table: hashtable):boolean
function SaveTextTagHandleBJ(whichTexttag, key, missionKey, table)
    return SaveTextTagHandle(table, missionKey, key, whichTexttag)
end

--===========================================================================
---@type fun(whichLightning: lightning, key: integer, missionKey: integer, table: hashtable):boolean
function SaveLightningHandleBJ(whichLightning, key, missionKey, table)
    return SaveLightningHandle(table, missionKey, key, whichLightning)
end

--===========================================================================
---@type fun(whichImage: image, key: integer, missionKey: integer, table: hashtable):boolean
function SaveImageHandleBJ(whichImage, key, missionKey, table)
    return SaveImageHandle(table, missionKey, key, whichImage)
end

--===========================================================================
---@type fun(whichUbersplat: ubersplat, key: integer, missionKey: integer, table: hashtable):boolean
function SaveUbersplatHandleBJ(whichUbersplat, key, missionKey, table)
    return SaveUbersplatHandle(table, missionKey, key, whichUbersplat)
end

--===========================================================================
---@type fun(whichRegion: region, key: integer, missionKey: integer, table: hashtable):boolean
function SaveRegionHandleBJ(whichRegion, key, missionKey, table)
    return SaveRegionHandle(table, missionKey, key, whichRegion)
end

--===========================================================================
---@type fun(whichFogState: fogstate, key: integer, missionKey: integer, table: hashtable):boolean
function SaveFogStateHandleBJ(whichFogState, key, missionKey, table)
    return SaveFogStateHandle(table, missionKey, key, whichFogState)
end

--===========================================================================
---@type fun(whichFogModifier: fogmodifier, key: integer, missionKey: integer, table: hashtable):boolean
function SaveFogModifierHandleBJ(whichFogModifier, key, missionKey, table)
    return SaveFogModifierHandle(table, missionKey, key, whichFogModifier)
end

--===========================================================================
---@type fun(whichAgent: agent, key: integer, missionKey: integer, table: hashtable):boolean
function SaveAgentHandleBJ(whichAgent, key, missionKey, table)
    return SaveAgentHandle(table, missionKey, key, whichAgent)
end

--===========================================================================
---@type fun(whichHashtable: hashtable, key: integer, missionKey: integer, table: hashtable):boolean
function SaveHashtableHandleBJ(whichHashtable, key, missionKey, table)
    return SaveHashtableHandle(table, missionKey, key, whichHashtable)
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache):number
function GetStoredRealBJ(key, missionKey, cache)
    --call SyncStoredReal(cache, missionKey, key)
    return GetStoredReal(cache, missionKey, key)
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache):integer
function GetStoredIntegerBJ(key, missionKey, cache)
    --call SyncStoredInteger(cache, missionKey, key)
    return GetStoredInteger(cache, missionKey, key)
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache):boolean
function GetStoredBooleanBJ(key, missionKey, cache)
    --call SyncStoredBoolean(cache, missionKey, key)
    return GetStoredBoolean(cache, missionKey, key)
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache):string
function GetStoredStringBJ(key, missionKey, cache)
    local s ---@type string 

    --call SyncStoredString(cache, missionKey, key)
    s = GetStoredString(cache, missionKey, key)
    if (s == nil) then
        return ""
    else
        return s
    end
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):number
function LoadRealBJ(key, missionKey, table)
    --call SyncStoredReal(table, missionKey, key)
    return LoadReal(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):integer
function LoadIntegerBJ(key, missionKey, table)
    --call SyncStoredInteger(table, missionKey, key)
    return LoadInteger(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):boolean
function LoadBooleanBJ(key, missionKey, table)
    --call SyncStoredBoolean(table, missionKey, key)
    return LoadBoolean(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):string
function LoadStringBJ(key, missionKey, table)
    local s ---@type string 

    --call SyncStoredString(table, missionKey, key)
    s = LoadStr(table, missionKey, key)
    if (s == nil) then
        return ""
    else
        return s
    end
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):player
function LoadPlayerHandleBJ(key, missionKey, table)
    return LoadPlayerHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):widget
function LoadWidgetHandleBJ(key, missionKey, table)
    return LoadWidgetHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):destructable
function LoadDestructableHandleBJ(key, missionKey, table)
    return LoadDestructableHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):item
function LoadItemHandleBJ(key, missionKey, table)
    return LoadItemHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):unit
function LoadUnitHandleBJ(key, missionKey, table)
    return LoadUnitHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):ability
function LoadAbilityHandleBJ(key, missionKey, table)
    return LoadAbilityHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):timer
function LoadTimerHandleBJ(key, missionKey, table)
    return LoadTimerHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):trigger
function LoadTriggerHandleBJ(key, missionKey, table)
    return LoadTriggerHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):triggercondition
function LoadTriggerConditionHandleBJ(key, missionKey, table)
    return LoadTriggerConditionHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):triggeraction
function LoadTriggerActionHandleBJ(key, missionKey, table)
    return LoadTriggerActionHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):event
function LoadTriggerEventHandleBJ(key, missionKey, table)
    return LoadTriggerEventHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):force
function LoadForceHandleBJ(key, missionKey, table)
    return LoadForceHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):group
function LoadGroupHandleBJ(key, missionKey, table)
    return LoadGroupHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):location
function LoadLocationHandleBJ(key, missionKey, table)
    return LoadLocationHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):rect
function LoadRectHandleBJ(key, missionKey, table)
    return LoadRectHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):boolexpr
function LoadBooleanExprHandleBJ(key, missionKey, table)
    return LoadBooleanExprHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):sound
function LoadSoundHandleBJ(key, missionKey, table)
    return LoadSoundHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):effect
function LoadEffectHandleBJ(key, missionKey, table)
    return LoadEffectHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):unitpool
function LoadUnitPoolHandleBJ(key, missionKey, table)
    return LoadUnitPoolHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):itempool
function LoadItemPoolHandleBJ(key, missionKey, table)
    return LoadItemPoolHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):quest
function LoadQuestHandleBJ(key, missionKey, table)
    return LoadQuestHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):questitem
function LoadQuestItemHandleBJ(key, missionKey, table)
    return LoadQuestItemHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):defeatcondition
function LoadDefeatConditionHandleBJ(key, missionKey, table)
    return LoadDefeatConditionHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):timerdialog
function LoadTimerDialogHandleBJ(key, missionKey, table)
    return LoadTimerDialogHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):leaderboard
function LoadLeaderboardHandleBJ(key, missionKey, table)
    return LoadLeaderboardHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):multiboard
function LoadMultiboardHandleBJ(key, missionKey, table)
    return LoadMultiboardHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):multiboarditem
function LoadMultiboardItemHandleBJ(key, missionKey, table)
    return LoadMultiboardItemHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):trackable
function LoadTrackableHandleBJ(key, missionKey, table)
    return LoadTrackableHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):dialog
function LoadDialogHandleBJ(key, missionKey, table)
    return LoadDialogHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):button
function LoadButtonHandleBJ(key, missionKey, table)
    return LoadButtonHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):texttag
function LoadTextTagHandleBJ(key, missionKey, table)
    return LoadTextTagHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):lightning
function LoadLightningHandleBJ(key, missionKey, table)
    return LoadLightningHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):image
function LoadImageHandleBJ(key, missionKey, table)
    return LoadImageHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):ubersplat
function LoadUbersplatHandleBJ(key, missionKey, table)
    return LoadUbersplatHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):region
function LoadRegionHandleBJ(key, missionKey, table)
    return LoadRegionHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):fogstate
function LoadFogStateHandleBJ(key, missionKey, table)
    return LoadFogStateHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):fogmodifier
function LoadFogModifierHandleBJ(key, missionKey, table)
    return LoadFogModifierHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: integer, missionKey: integer, table: hashtable):hashtable
function LoadHashtableHandleBJ(key, missionKey, table)
    return LoadHashtableHandle(table, missionKey, key)
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache, forWhichPlayer: player, loc: location, facing: number):unit
function RestoreUnitLocFacingAngleBJ(key, missionKey, cache, forWhichPlayer, loc, facing)
    --call SyncStoredUnit(cache, missionKey, key)
    bj_lastLoadedUnit = RestoreUnit(cache, missionKey, key, forWhichPlayer, GetLocationX(loc), GetLocationY(loc), facing)
    return bj_lastLoadedUnit
end

--===========================================================================
---@type fun(key: string, missionKey: string, cache: gamecache, forWhichPlayer: player, loc: location, lookAt: location):unit
function RestoreUnitLocFacingPointBJ(key, missionKey, cache, forWhichPlayer, loc, lookAt)
    --call SyncStoredUnit(cache, missionKey, key)
    return RestoreUnitLocFacingAngleBJ(key, missionKey, cache, forWhichPlayer, loc, AngleBetweenPoints(loc, lookAt))
end

--===========================================================================
---@type fun():unit
function GetLastRestoredUnitBJ()
    return bj_lastLoadedUnit
end

--===========================================================================
---@type fun(cache: gamecache)
function FlushGameCacheBJ(cache)
    FlushGameCache(cache)
end

--===========================================================================
---@type fun(missionKey: string, cache: gamecache)
function FlushStoredMissionBJ(missionKey, cache)
    FlushStoredMission(cache, missionKey)
end

--===========================================================================
---@type fun(table: hashtable)
function FlushParentHashtableBJ(table)
    FlushParentHashtable(table)
end

--===========================================================================
---@type fun(missionKey: integer, table: hashtable)
function FlushChildHashtableBJ(missionKey, table)
    FlushChildHashtable(table, missionKey)
end

--===========================================================================
---@type fun(key: string, valueType: integer, missionKey: string, cache: gamecache):boolean
function HaveStoredValue(key, valueType, missionKey, cache)
    if (valueType == bj_GAMECACHE_BOOLEAN) then
        return HaveStoredBoolean(cache, missionKey, key)
    elseif (valueType == bj_GAMECACHE_INTEGER) then
        return HaveStoredInteger(cache, missionKey, key)
    elseif (valueType == bj_GAMECACHE_REAL) then
        return HaveStoredReal(cache, missionKey, key)
    elseif (valueType == bj_GAMECACHE_UNIT) then
        return HaveStoredUnit(cache, missionKey, key)
    elseif (valueType == bj_GAMECACHE_STRING) then
        return HaveStoredString(cache, missionKey, key)
    else
        -- Unrecognized value type - ignore the request.
        return false
    end
end

--===========================================================================
---@type fun(key: integer, valueType: integer, missionKey: integer, table: hashtable):boolean
function HaveSavedValue(key, valueType, missionKey, table)
    if (valueType == bj_HASHTABLE_BOOLEAN) then
        return HaveSavedBoolean(table, missionKey, key)
    elseif (valueType == bj_HASHTABLE_INTEGER) then
        return HaveSavedInteger(table, missionKey, key)
    elseif (valueType == bj_HASHTABLE_REAL) then
        return HaveSavedReal(table, missionKey, key)
    elseif (valueType == bj_HASHTABLE_STRING) then
        return HaveSavedString(table, missionKey, key)
    elseif (valueType == bj_HASHTABLE_HANDLE) then
        return HaveSavedHandle(table, missionKey, key)
    else
        -- Unrecognized value type - ignore the request.
        return false
    end
end

--===========================================================================
---@type fun(show: boolean, whichButton: integer)
function ShowCustomCampaignButton(show, whichButton)
    SetCustomCampaignButtonVisible(whichButton - 1, show)
end

--===========================================================================
---@type fun(whichButton: integer):boolean
function IsCustomCampaignButtonVisibile(whichButton)
    return GetCustomCampaignButtonVisible(whichButton - 1)
end

--===========================================================================
-- Placeholder function for auto save feature
--===========================================================================
---@type fun(mapSaveName: string, doCheckpointHint: boolean)
function SaveGameCheckPointBJ(mapSaveName, doCheckpointHint)
    SaveGameCheckpoint(mapSaveName, doCheckpointHint)
end

--===========================================================================
---@type fun(loadFileName: string, doScoreScreen: boolean)
function LoadGameBJ(loadFileName, doScoreScreen)
    LoadGame(loadFileName, doScoreScreen)
end

--===========================================================================
---@type fun(saveFileName: string, newLevel: string, doScoreScreen: boolean)
function SaveAndChangeLevelBJ(saveFileName, newLevel, doScoreScreen)
    SaveGame(saveFileName)
    ChangeLevel(newLevel, doScoreScreen)
end

--===========================================================================
---@type fun(saveFileName: string, loadFileName: string, doScoreScreen: boolean)
function SaveAndLoadGameBJ(saveFileName, loadFileName, doScoreScreen)
    SaveGame(saveFileName)
    LoadGame(loadFileName, doScoreScreen)
end

--===========================================================================
---@type fun(sourceDirName: string, destDirName: string):boolean
function RenameSaveDirectoryBJ(sourceDirName, destDirName)
    return RenameSaveDirectory(sourceDirName, destDirName)
end

--===========================================================================
---@type fun(sourceDirName: string):boolean
function RemoveSaveDirectoryBJ(sourceDirName)
    return RemoveSaveDirectory(sourceDirName)
end

--===========================================================================
---@type fun(sourceSaveName: string, destSaveName: string):boolean
function CopySaveGameBJ(sourceSaveName, destSaveName)
    return CopySaveGame(sourceSaveName, destSaveName)
end



--***************************************************************************
--*
--*  Miscellaneous Utility Functions
--*
--***************************************************************************

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerStartLocationX(whichPlayer)
    return GetStartLocationX(GetPlayerStartLocation(whichPlayer))
end

--===========================================================================
---@type fun(whichPlayer: player):number
function GetPlayerStartLocationY(whichPlayer)
    return GetStartLocationY(GetPlayerStartLocation(whichPlayer))
end

--===========================================================================
---@type fun(whichPlayer: player):location
function GetPlayerStartLocationLoc(whichPlayer)
    return GetStartLocationLoc(GetPlayerStartLocation(whichPlayer))
end

--===========================================================================
---@type fun(whichRect: rect):location
function GetRectCenter(whichRect)
    return Location(GetRectCenterX(whichRect), GetRectCenterY(whichRect))
end

--===========================================================================
---@type fun(whichPlayer: player, whichState: playerslotstate):boolean
function IsPlayerSlotState(whichPlayer, whichState)
    return GetPlayerSlotState(whichPlayer) == whichState
end

--===========================================================================
---@type fun(seconds: number):integer
function GetFadeFromSeconds(seconds)
    if (seconds ~= 0) then
        return 128 // R2I(seconds)
    end
    return 10000
end

--===========================================================================
---@type fun(seconds: number):number
function GetFadeFromSecondsAsReal(seconds)
    if (seconds ~= 0) then
        return 128.00 / seconds
    end
    return 10000.00
end

--===========================================================================
---@type fun(whichPlayer: player, whichPlayerState: playerstate, delta: integer)
function AdjustPlayerStateSimpleBJ(whichPlayer, whichPlayerState, delta)
    SetPlayerState(whichPlayer, whichPlayerState, GetPlayerState(whichPlayer, whichPlayerState) + delta)
end

--===========================================================================
---@type fun(delta: integer, whichPlayer: player, whichPlayerState: playerstate)
function AdjustPlayerStateBJ(delta, whichPlayer, whichPlayerState)
    -- If the change was positive, apply the difference to the player's
    -- gathered resources property as well.
    if (delta > 0) then
        if (whichPlayerState == PLAYER_STATE_RESOURCE_GOLD) then
            AdjustPlayerStateSimpleBJ(whichPlayer, PLAYER_STATE_GOLD_GATHERED, delta)
        elseif (whichPlayerState == PLAYER_STATE_RESOURCE_LUMBER) then
            AdjustPlayerStateSimpleBJ(whichPlayer, PLAYER_STATE_LUMBER_GATHERED, delta)
        end
    end

    AdjustPlayerStateSimpleBJ(whichPlayer, whichPlayerState, delta)
end

--===========================================================================
---@type fun(whichPlayer: player, whichPlayerState: playerstate, value: integer)
function SetPlayerStateBJ(whichPlayer, whichPlayerState, value)
    local oldValue         = GetPlayerState(whichPlayer, whichPlayerState) ---@type integer 
    AdjustPlayerStateBJ(value - oldValue, whichPlayer, whichPlayerState)
end

--===========================================================================
---@type fun(whichPlayerFlag: playerstate, flag: boolean, whichPlayer: player)
function SetPlayerFlagBJ(whichPlayerFlag, flag, whichPlayer)
    SetPlayerState(whichPlayer, whichPlayerFlag, IntegerTertiaryOp(flag, 1, 0))
end

--===========================================================================
---@type fun(rate: integer, whichResource: playerstate, sourcePlayer: player, otherPlayer: player)
function SetPlayerTaxRateBJ(rate, whichResource, sourcePlayer, otherPlayer)
    SetPlayerTaxRate(sourcePlayer, otherPlayer, whichResource, rate)
end

--===========================================================================
---@type fun(whichResource: playerstate, sourcePlayer: player, otherPlayer: player):integer
function GetPlayerTaxRateBJ(whichResource, sourcePlayer, otherPlayer)
    return GetPlayerTaxRate(sourcePlayer, otherPlayer, whichResource)
end

--===========================================================================
---@type fun(whichPlayerFlag: playerstate, whichPlayer: player):boolean
function IsPlayerFlagSetBJ(whichPlayerFlag, whichPlayer)
    return GetPlayerState(whichPlayer, whichPlayerFlag) == 1
end

--===========================================================================
---@type fun(delta: integer, whichUnit: unit)
function AddResourceAmountBJ(delta, whichUnit)
    AddResourceAmount(whichUnit, delta)
end

--===========================================================================
---@type fun(whichPlayer: player):integer
function GetConvertedPlayerId(whichPlayer)
    return GetPlayerId(whichPlayer) + 1
end

--===========================================================================
---@type fun(convertedPlayerId: integer):player
function ConvertedPlayer(convertedPlayerId)
    return Player(convertedPlayerId - 1)
end

--===========================================================================
---@type fun(r: rect):number
function GetRectWidthBJ(r)
    return GetRectMaxX(r) - GetRectMinX(r)
end

--===========================================================================
---@type fun(r: rect):number
function GetRectHeightBJ(r)
    return GetRectMaxY(r) - GetRectMinY(r)
end

--===========================================================================
-- Replaces a gold mine with a blighted gold mine for the given player.
--
---@type fun(goldMine: unit, whichPlayer: player):unit
function BlightGoldMineForPlayerBJ(goldMine, whichPlayer)
    local mineX ---@type number 
    local mineY ---@type number 
    local mineGold ---@type integer 
    local newMine ---@type unit 

    -- Make sure we're replacing a Gold Mine and not some other type of unit.
    if GetUnitTypeId(goldMine) ~= FourCC('ngol') then
        return nil
    end

    -- Save the Gold Mine's properties and remove it.
    mineX    = GetUnitX(goldMine)
    mineY    = GetUnitY(goldMine)
    mineGold = GetResourceAmount(goldMine)
    RemoveUnit(goldMine)

    -- Create a Haunted Gold Mine to replace the Gold Mine.
    newMine = CreateBlightedGoldmine(whichPlayer, mineX, mineY, bj_UNIT_FACING)
    SetResourceAmount(newMine, mineGold)
    return newMine
end

--===========================================================================
---@type fun(goldMine: unit, whichPlayer: player):unit
function BlightGoldMineForPlayer(goldMine, whichPlayer)
    bj_lastHauntedGoldMine = BlightGoldMineForPlayerBJ(goldMine, whichPlayer)
    return bj_lastHauntedGoldMine
end

--===========================================================================
---@type fun():unit
function GetLastHauntedGoldMine()
    return bj_lastHauntedGoldMine
end

--===========================================================================
---@type fun(where: location):boolean
function IsPointBlightedBJ(where)
    return IsPointBlighted(GetLocationX(where), GetLocationY(where))
end

--===========================================================================
function SetPlayerColorBJEnum()
    SetUnitColor(GetEnumUnit(), bj_setPlayerTargetColor)
end

--===========================================================================
---@type fun(whichPlayer: player, color: playercolor, changeExisting: boolean)
function SetPlayerColorBJ(whichPlayer, color, changeExisting)
    local g ---@type group 

    SetPlayerColor(whichPlayer, color)
    if changeExisting then
        bj_setPlayerTargetColor = color
        g = CreateGroup()
        GroupEnumUnitsOfPlayer(g, whichPlayer, nil)
        ForGroup(g, SetPlayerColorBJEnum)
        DestroyGroup(g)
    end
end

--===========================================================================
---@type fun(unitId: integer, allowed: boolean, whichPlayer: player)
function SetPlayerUnitAvailableBJ(unitId, allowed, whichPlayer)
    if allowed then
        SetPlayerTechMaxAllowed(whichPlayer, unitId, -1)
    else
        SetPlayerTechMaxAllowed(whichPlayer, unitId, 0)
    end
end

--===========================================================================
function LockGameSpeedBJ()
    SetMapFlag(MAP_LOCK_SPEED, true)
end

--===========================================================================
function UnlockGameSpeedBJ()
    SetMapFlag(MAP_LOCK_SPEED, false)
end

--===========================================================================
---@type fun(whichUnit: unit, order: string, targetWidget: widget):boolean
function IssueTargetOrderBJ(whichUnit, order, targetWidget)
    return IssueTargetOrder( whichUnit, order, targetWidget )
end

--===========================================================================
---@type fun(whichUnit: unit, order: string, whichLocation: location):boolean
function IssuePointOrderLocBJ(whichUnit, order, whichLocation)
    return IssuePointOrderLoc( whichUnit, order, whichLocation )
end

--===========================================================================
-- Two distinct trigger actions can't share the same function name, so this
-- dummy function simply mimics the behavior of an existing call.
--
---@type fun(whichUnit: unit, order: string, targetWidget: widget):boolean
function IssueTargetDestructableOrder(whichUnit, order, targetWidget)
    return IssueTargetOrder( whichUnit, order, targetWidget )
end

---@type fun(whichUnit: unit, order: string, targetWidget: widget):boolean
function IssueTargetItemOrder(whichUnit, order, targetWidget)
    return IssueTargetOrder( whichUnit, order, targetWidget )
end

--===========================================================================
---@type fun(whichUnit: unit, order: string):boolean
function IssueImmediateOrderBJ(whichUnit, order)
    return IssueImmediateOrder( whichUnit, order )
end

--===========================================================================
---@type fun(whichGroup: group, order: string, targetWidget: widget):boolean
function GroupTargetOrderBJ(whichGroup, order, targetWidget)
    return GroupTargetOrder( whichGroup, order, targetWidget )
end

--===========================================================================
---@type fun(whichGroup: group, order: string, whichLocation: location):boolean
function GroupPointOrderLocBJ(whichGroup, order, whichLocation)
    return GroupPointOrderLoc( whichGroup, order, whichLocation )
end

--===========================================================================
---@type fun(whichGroup: group, order: string):boolean
function GroupImmediateOrderBJ(whichGroup, order)
    return GroupImmediateOrder( whichGroup, order )
end

--===========================================================================
-- Two distinct trigger actions can't share the same function name, so this
-- dummy function simply mimics the behavior of an existing call.
--
---@type fun(whichGroup: group, order: string, targetWidget: widget):boolean
function GroupTargetDestructableOrder(whichGroup, order, targetWidget)
    return GroupTargetOrder( whichGroup, order, targetWidget )
end

---@type fun(whichGroup: group, order: string, targetWidget: widget):boolean
function GroupTargetItemOrder(whichGroup, order, targetWidget)
    return GroupTargetOrder( whichGroup, order, targetWidget )
end

--===========================================================================
---@type fun():destructable
function GetDyingDestructable()
    return GetTriggerDestructable()
end

--===========================================================================
-- Rally point setting
--
---@type fun(whichUnit: unit, targPos: location)
function SetUnitRallyPoint(whichUnit, targPos)
    IssuePointOrderLocBJ(whichUnit, "setrally", targPos)
end

--===========================================================================
---@type fun(whichUnit: unit, targUnit: unit)
function SetUnitRallyUnit(whichUnit, targUnit)
    IssueTargetOrder(whichUnit, "setrally", targUnit)
end

--===========================================================================
---@type fun(whichUnit: unit, targDest: destructable)
function SetUnitRallyDestructable(whichUnit, targDest)
    IssueTargetOrder(whichUnit, "setrally", targDest)
end

--===========================================================================
-- Utility function for use by editor-generated item drop table triggers.
-- This function is added as an action to all destructable drop triggers,
-- so that a widget drop may be differentiated from a unit drop.
--
function SaveDyingWidget()
    bj_lastDyingWidget = GetTriggerWidget()
end

--===========================================================================
---@type fun(addBlight: boolean, whichPlayer: player, r: rect)
function SetBlightRectBJ(addBlight, whichPlayer, r)
    SetBlightRect(whichPlayer, r, addBlight)
end

--===========================================================================
---@type fun(addBlight: boolean, whichPlayer: player, loc: location, radius: number)
function SetBlightRadiusLocBJ(addBlight, whichPlayer, loc, radius)
    SetBlightLoc(whichPlayer, loc, radius, addBlight)
end

--===========================================================================
---@type fun(abilcode: integer):string
function GetAbilityName(abilcode)
    return GetObjectName(abilcode)
end


--***************************************************************************
--*
--*  Melee Template Visibility Settings
--*
--***************************************************************************

--===========================================================================
function MeleeStartingVisibility()
    -- Start by setting the ToD.
    SetFloatGameState(GAME_STATE_TIME_OF_DAY, bj_MELEE_STARTING_TOD)

    -- call FogMaskEnable(true)
    -- call FogEnable(true)
end



--***************************************************************************
--*
--*  Melee Template Starting Resources
--*
--***************************************************************************

--===========================================================================
function MeleeStartingResources()
    local index ---@type integer 
    local indexPlayer ---@type player 
    local v ---@type version 
    local startingGold ---@type integer 
    local startingLumber ---@type integer 

    v = VersionGet()
    if (v == VERSION_REIGN_OF_CHAOS) then
        startingGold = bj_MELEE_STARTING_GOLD_V0
        startingLumber = bj_MELEE_STARTING_LUMBER_V0
    else
        startingGold = bj_MELEE_STARTING_GOLD_V1
        startingLumber = bj_MELEE_STARTING_LUMBER_V1
    end

    -- Set each player's starting resources.
    index = 0
    repeat
        indexPlayer = Player(index)
        if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
            SetPlayerState(indexPlayer, PLAYER_STATE_RESOURCE_GOLD, startingGold)
            SetPlayerState(indexPlayer, PLAYER_STATE_RESOURCE_LUMBER, startingLumber)
        end

        index = index + 1
    until index == bj_MAX_PLAYERS
end



--***************************************************************************
--*
--*  Melee Template Hero Limit
--*
--***************************************************************************

--===========================================================================
---@type fun(whichPlayer: player, techId: integer, limit: integer)
function ReducePlayerTechMaxAllowed(whichPlayer, techId, limit)
    local oldMax         = GetPlayerTechMaxAllowed(whichPlayer, techId) ---@type integer 

    -- A value of -1 is used to indicate no limit, so check for that as well.
    if (oldMax < 0 or oldMax > limit) then
        SetPlayerTechMaxAllowed(whichPlayer, techId, limit)
    end
end

--===========================================================================
function MeleeStartingHeroLimit()
    local index ---@type integer 

    index = 0
    repeat
        -- max heroes per player
        SetPlayerMaxHeroesAllowed(bj_MELEE_HERO_LIMIT, Player(index))

        -- each player is restricted to a limit per hero type as well
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Hamg'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Hmkg'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Hpal'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Hblm'), bj_MELEE_HERO_TYPE_LIMIT)

        ReducePlayerTechMaxAllowed(Player(index), FourCC('Obla'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ofar'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Otch'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Oshd'), bj_MELEE_HERO_TYPE_LIMIT)

        ReducePlayerTechMaxAllowed(Player(index), FourCC('Edem'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ekee'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Emoo'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ewar'), bj_MELEE_HERO_TYPE_LIMIT)

        ReducePlayerTechMaxAllowed(Player(index), FourCC('Udea'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Udre'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ulic'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ucrl'), bj_MELEE_HERO_TYPE_LIMIT)

        ReducePlayerTechMaxAllowed(Player(index), FourCC('Npbm'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nbrn'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nngs'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nplh'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nbst'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nalc'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Ntin'), bj_MELEE_HERO_TYPE_LIMIT)
        ReducePlayerTechMaxAllowed(Player(index), FourCC('Nfir'), bj_MELEE_HERO_TYPE_LIMIT)

        index = index + 1
    until index == bj_MAX_PLAYERS
end



--***************************************************************************
--*
--*  Melee Template Granted Hero Items
--*
--***************************************************************************

--===========================================================================
---@type fun():boolean
function MeleeTrainedUnitIsHeroBJFilter()
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO)
end

--===========================================================================
-- The first N heroes trained or hired for each player start off with a
-- standard set of items.  This is currently:
--   - 1x Scroll of Town Portal
--
---@type fun(whichUnit: unit)
function MeleeGrantItemsToHero(whichUnit)
    local owner           = GetPlayerId(GetOwningPlayer(whichUnit)) ---@type integer 

    -- If we haven't twinked N heroes for this player yet, twink away.
    if (bj_meleeTwinkedHeroes[owner] < bj_MELEE_MAX_TWINKED_HEROES) then
        UnitAddItemById(whichUnit, FourCC('stwp'))
        bj_meleeTwinkedHeroes[owner] = bj_meleeTwinkedHeroes[owner] + 1
    end
end

--===========================================================================
function MeleeGrantItemsToTrainedHero()
    MeleeGrantItemsToHero(GetTrainedUnit())
end

--===========================================================================
function MeleeGrantItemsToHiredHero()
    MeleeGrantItemsToHero(GetSoldUnit())
end

--===========================================================================
function MeleeGrantHeroItems()
    local index ---@type integer 
    local trig ---@type trigger 

    -- Initialize the twinked hero counts.
    index = 0
    repeat
        bj_meleeTwinkedHeroes[index] = 0

        index = index + 1
    until index == bj_MAX_PLAYER_SLOTS

    -- Register for an event whenever a hero is trained, so that we can give
    -- him/her their starting items.
    index = 0
    repeat
        trig = CreateTrigger()
        TriggerRegisterPlayerUnitEvent(trig, Player(index), EVENT_PLAYER_UNIT_TRAIN_FINISH, filterMeleeTrainedUnitIsHeroBJ)
        TriggerAddAction(trig, MeleeGrantItemsToTrainedHero)

        index = index + 1
    until index == bj_MAX_PLAYERS

    -- Register for an event whenever a neutral hero is hired, so that we
    -- can give him/her their starting items.
    trig = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(trig, Player(PLAYER_NEUTRAL_PASSIVE), EVENT_PLAYER_UNIT_SELL, filterMeleeTrainedUnitIsHeroBJ)
    TriggerAddAction(trig, MeleeGrantItemsToHiredHero)

    -- Flag that we are giving starting items to heroes, so that the melee
    -- starting units code can create them as necessary.
    bj_meleeGrantHeroItems = true
end



--***************************************************************************
--*
--*  Melee Template Clear Start Locations
--*
--***************************************************************************

--===========================================================================
function MeleeClearExcessUnit()
    local theUnit         = GetEnumUnit() ---@type unit 
    local owner           = GetPlayerId(GetOwningPlayer(theUnit)) ---@type integer 

    if (owner == PLAYER_NEUTRAL_AGGRESSIVE) then
        -- Remove any Neutral Hostile units from the area.
        RemoveUnit(GetEnumUnit())
    elseif (owner == PLAYER_NEUTRAL_PASSIVE) then
        -- Remove non-structure Neutral Passive units from the area.
        if not IsUnitType(theUnit, UNIT_TYPE_STRUCTURE) then
            RemoveUnit(GetEnumUnit())
        end
    end
end

--===========================================================================
---@type fun(x: number, y: number, range: number)
function MeleeClearNearbyUnits(x, y, range)
    local nearbyUnits ---@type group 
    
    nearbyUnits = CreateGroup()
    GroupEnumUnitsInRange(nearbyUnits, x, y, range, nil)
    ForGroup(nearbyUnits, MeleeClearExcessUnit)
    DestroyGroup(nearbyUnits)
end

--===========================================================================
function MeleeClearExcessUnits()
    local index ---@type integer 
    local locX ---@type number 
    local locY ---@type number 
    local indexPlayer ---@type player 

    index = 0
    repeat
        indexPlayer = Player(index)

        -- If the player slot is being used, clear any nearby creeps.
        if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
            locX = GetStartLocationX(GetPlayerStartLocation(indexPlayer))
            locY = GetStartLocationY(GetPlayerStartLocation(indexPlayer))

            MeleeClearNearbyUnits(locX, locY, bj_MELEE_CLEAR_UNITS_RADIUS)
        end

        index = index + 1
    until index == bj_MAX_PLAYERS
end



--***************************************************************************
--*
--*  Melee Template Starting Units
--*
--***************************************************************************

--===========================================================================
function MeleeEnumFindNearestMine()
    local enumUnit      = GetEnumUnit() ---@type unit 
    local dist ---@type number 
    local unitLoc ---@type location 

    if (GetUnitTypeId(enumUnit) == FourCC('ngol')) then
        unitLoc = GetUnitLoc(enumUnit)
        dist = DistanceBetweenPoints(unitLoc, bj_meleeNearestMineToLoc)
        RemoveLocation(unitLoc)

        -- If this is our first mine, or the closest thusfar, use it instead.
        if (bj_meleeNearestMineDist < 0) or (dist < bj_meleeNearestMineDist) then
            bj_meleeNearestMine = enumUnit
            bj_meleeNearestMineDist = dist
        end
    end
end

--===========================================================================
---@type fun(src: location, range: number):unit
function MeleeFindNearestMine(src, range)
    local nearbyMines ---@type group 

    bj_meleeNearestMine = nil
    bj_meleeNearestMineDist = -1
    bj_meleeNearestMineToLoc = src

    nearbyMines = CreateGroup()
    GroupEnumUnitsInRangeOfLoc(nearbyMines, src, range, nil)
    ForGroup(nearbyMines, MeleeEnumFindNearestMine)
    DestroyGroup(nearbyMines)

    return bj_meleeNearestMine
end

--===========================================================================
---@type fun(p: player, id1: integer, id2: integer, id3: integer, id4: integer, loc: location):unit
function MeleeRandomHeroLoc(p, id1, id2, id3, id4, loc)
    local hero         = nil ---@type unit 
    local roll ---@type integer 
    local pick ---@type integer 
    local v ---@type version 

    -- The selection of heroes is dependant on the game version.
    v = VersionGet()
    if (v == VERSION_REIGN_OF_CHAOS) then
        roll = GetRandomInt(1,3)
    else
        roll = GetRandomInt(1,4)
    end

    -- Translate the roll into a unitid.
    if roll == 1 then
        pick = id1
    elseif roll == 2 then
        pick = id2
    elseif roll == 3 then
        pick = id3
    elseif roll == 4 then
        pick = id4
    else
        -- Unrecognized id index - pick the first hero in the list.
        pick = id1
    end

    -- Create the hero.
    hero = CreateUnitAtLoc(p, pick, loc, bj_UNIT_FACING)
    if bj_meleeGrantHeroItems then
        MeleeGrantItemsToHero(hero)
    end
    return hero
end

--===========================================================================
-- Returns a location which is (distance) away from (src) in the direction of (targ).
--
---@type fun(src: location, targ: location, distance: number, deltaAngle: number):location
function MeleeGetProjectedLoc(src, targ, distance, deltaAngle)
    local srcX      = GetLocationX(src) ---@type number 
    local srcY      = GetLocationY(src) ---@type number 
    local direction      = Atan2(GetLocationY(targ) - srcY, GetLocationX(targ) - srcX) + deltaAngle ---@type number 
    return Location(srcX + distance * Cos(direction), srcY + distance * Sin(direction))
end

--===========================================================================
---@type fun(val: number, minVal: number, maxVal: number):number
function MeleeGetNearestValueWithin(val, minVal, maxVal)
    if (val < minVal) then
        return minVal
    elseif (val > maxVal) then
        return maxVal
    else
        return val
    end
end

--===========================================================================
---@type fun(src: location, r: rect):location
function MeleeGetLocWithinRect(src, r)
    local withinX      = MeleeGetNearestValueWithin(GetLocationX(src), GetRectMinX(r), GetRectMaxX(r)) ---@type number 
    local withinY      = MeleeGetNearestValueWithin(GetLocationY(src), GetRectMinY(r), GetRectMaxY(r)) ---@type number 
    return Location(withinX, withinY)
end

--===========================================================================
-- Starting Units for Human Players
--   - 1 Town Hall, placed at start location
--   - 5 Peasants, placed between start location and nearest gold mine
--
---@type fun(whichPlayer: player, startLoc: location, doHeroes: boolean, doCamera: boolean, doPreload: boolean)
function MeleeStartingUnitsHuman(whichPlayer, startLoc, doHeroes, doCamera, doPreload)
    local useRandomHero          = IsMapFlagSet(MAP_RANDOM_HERO) ---@type boolean 
    local unitSpacing            = 64.00 ---@type number 
    local nearestMine ---@type unit 
    local nearMineLoc ---@type location 
    local heroLoc ---@type location 
    local peonX ---@type number 
    local peonY ---@type number 
    local townHall          = nil ---@type unit 

    if (doPreload) then
        Preloader( "scripts\\HumanMelee.pld" )
    end

    nearestMine = MeleeFindNearestMine(startLoc, bj_MELEE_MINE_SEARCH_RADIUS)
    if (nearestMine ~= nil) then
        -- Spawn Town Hall at the start location.
        townHall = CreateUnitAtLoc(whichPlayer, FourCC('htow'), startLoc, bj_UNIT_FACING)
        
        -- Spawn Peasants near the mine.
        nearMineLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 320, 0)
        peonX = GetLocationX(nearMineLoc)
        peonY = GetLocationY(nearMineLoc)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 0.00 * unitSpacing, peonY + 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX - 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 0.60 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX - 0.60 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be off to the side of the start location.
        heroLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 384, 45)
    else
        -- Spawn Town Hall at the start location.
        townHall = CreateUnitAtLoc(whichPlayer, FourCC('htow'), startLoc, bj_UNIT_FACING)
        
        -- Spawn Peasants directly south of the town hall.
        peonX = GetLocationX(startLoc)
        peonY = GetLocationY(startLoc) - 224.00
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX + 0.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX - 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('hpea'), peonX - 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be just south of the start location.
        heroLoc = Location(peonX, peonY - 2.00 * unitSpacing)
    end

    if (townHall ~= nil) then
        UnitAddAbilityBJ(FourCC('Amic'), townHall)
        UnitMakeAbilityPermanentBJ(true, FourCC('Amic'), townHall)
    end

    if (doHeroes) then
        -- If the "Random Hero" option is set, start the player with a random hero.
        -- Otherwise, give them a "free hero" token.
        if useRandomHero then
            MeleeRandomHeroLoc(whichPlayer, FourCC('Hamg'), FourCC('Hmkg'), FourCC('Hpal'), FourCC('Hblm'), heroLoc)
        else
            SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
        end
    end

    if (doCamera) then
        -- Center the camera on the initial Peasants.
        SetCameraPositionForPlayer(whichPlayer, peonX, peonY)
        SetCameraQuickPositionForPlayer(whichPlayer, peonX, peonY)
    end
end

--===========================================================================
-- Starting Units for Orc Players
--   - 1 Great Hall, placed at start location
--   - 5 Peons, placed between start location and nearest gold mine
--
---@type fun(whichPlayer: player, startLoc: location, doHeroes: boolean, doCamera: boolean, doPreload: boolean)
function MeleeStartingUnitsOrc(whichPlayer, startLoc, doHeroes, doCamera, doPreload)
    local useRandomHero          = IsMapFlagSet(MAP_RANDOM_HERO) ---@type boolean 
    local unitSpacing            = 64.00 ---@type number 
    local nearestMine ---@type unit 
    local nearMineLoc ---@type location 
    local heroLoc ---@type location 
    local peonX ---@type number 
    local peonY ---@type number 

    if (doPreload) then
        Preloader( "scripts\\OrcMelee.pld" )
    end

    nearestMine = MeleeFindNearestMine(startLoc, bj_MELEE_MINE_SEARCH_RADIUS)
    if (nearestMine ~= nil) then
        -- Spawn Great Hall at the start location.
        CreateUnitAtLoc(whichPlayer, FourCC('ogre'), startLoc, bj_UNIT_FACING)
        
        -- Spawn Peons near the mine.
        nearMineLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 320, 0)
        peonX = GetLocationX(nearMineLoc)
        peonY = GetLocationY(nearMineLoc)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 0.00 * unitSpacing, peonY + 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX - 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 0.60 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX - 0.60 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be off to the side of the start location.
        heroLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 384, 45)
    else
        -- Spawn Great Hall at the start location.
        CreateUnitAtLoc(whichPlayer, FourCC('ogre'), startLoc, bj_UNIT_FACING)
        
        -- Spawn Peons directly south of the town hall.
        peonX = GetLocationX(startLoc)
        peonY = GetLocationY(startLoc) - 224.00
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX + 0.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX - 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('opeo'), peonX - 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be just south of the start location.
        heroLoc = Location(peonX, peonY - 2.00 * unitSpacing)
    end

    if (doHeroes) then
        -- If the "Random Hero" option is set, start the player with a random hero.
        -- Otherwise, give them a "free hero" token.
        if useRandomHero then
            MeleeRandomHeroLoc(whichPlayer, FourCC('Obla'), FourCC('Ofar'), FourCC('Otch'), FourCC('Oshd'), heroLoc)
        else
            SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
        end
    end

    if (doCamera) then
        -- Center the camera on the initial Peons.
        SetCameraPositionForPlayer(whichPlayer, peonX, peonY)
        SetCameraQuickPositionForPlayer(whichPlayer, peonX, peonY)
    end
end

--===========================================================================
-- Starting Units for Undead Players
--   - 1 Necropolis, placed at start location
--   - 1 Haunted Gold Mine, placed on nearest gold mine
--   - 3 Acolytes, placed between start location and nearest gold mine
--   - 1 Ghoul, placed between start location and nearest gold mine
--   - Blight, centered on nearest gold mine, spread across a "large area"
--
---@type fun(whichPlayer: player, startLoc: location, doHeroes: boolean, doCamera: boolean, doPreload: boolean)
function MeleeStartingUnitsUndead(whichPlayer, startLoc, doHeroes, doCamera, doPreload)
    local useRandomHero          = IsMapFlagSet(MAP_RANDOM_HERO) ---@type boolean 
    local unitSpacing            = 64.00 ---@type number 
    local nearestMine ---@type unit
    local nearMineLoc ---@type location 
    local nearTownLoc ---@type location 
    local heroLoc ---@type location 
    local peonX ---@type number 
    local peonY ---@type number 
    local ghoulX ---@type number 
    local ghoulY ---@type number 

    if (doPreload) then
        Preloader( "scripts\\UndeadMelee.pld" )
    end

    nearestMine = MeleeFindNearestMine(startLoc, bj_MELEE_MINE_SEARCH_RADIUS)
    if (nearestMine ~= nil) then
        -- Spawn Necropolis at the start location.
        CreateUnitAtLoc(whichPlayer, FourCC('unpl'), startLoc, bj_UNIT_FACING)
        
        -- Replace the nearest gold mine with a blighted version.
        nearestMine = BlightGoldMineForPlayerBJ(nearestMine, whichPlayer)

        -- Spawn Ghoul near the Necropolis.
        nearTownLoc = MeleeGetProjectedLoc(startLoc, GetUnitLoc(nearestMine), 288, 0)
        ghoulX = GetLocationX(nearTownLoc)
        ghoulY = GetLocationY(nearTownLoc)
        bj_ghoul[GetPlayerId(whichPlayer)] = CreateUnit(whichPlayer, FourCC('ugho'), ghoulX + 0.00 * unitSpacing, ghoulY + 0.00 * unitSpacing, bj_UNIT_FACING)

        -- Spawn Acolytes near the mine.
        nearMineLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 320, 0)
        peonX = GetLocationX(nearMineLoc)
        peonY = GetLocationY(nearMineLoc)
        CreateUnit(whichPlayer, FourCC('uaco'), peonX + 0.00 * unitSpacing, peonY + 0.50 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('uaco'), peonX + 0.65 * unitSpacing, peonY - 0.50 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('uaco'), peonX - 0.65 * unitSpacing, peonY - 0.50 * unitSpacing, bj_UNIT_FACING)

        -- Create a patch of blight around the gold mine.
        SetBlightLoc(whichPlayer,nearMineLoc, 768, true)

        -- Set random hero spawn point to be off to the side of the start location.
        heroLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 384, 45)
    else
        -- Spawn Necropolis at the start location.
        CreateUnitAtLoc(whichPlayer, FourCC('unpl'), startLoc, bj_UNIT_FACING)
        
        -- Spawn Acolytes and Ghoul directly south of the Necropolis.
        peonX = GetLocationX(startLoc)
        peonY = GetLocationY(startLoc) - 224.00
        CreateUnit(whichPlayer, FourCC('uaco'), peonX - 1.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('uaco'), peonX - 0.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('uaco'), peonX + 0.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ugho'), peonX + 1.50 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)

        -- Create a patch of blight around the start location.
        SetBlightLoc(whichPlayer,startLoc, 768, true)

        -- Set random hero spawn point to be just south of the start location.
        heroLoc = Location(peonX, peonY - 2.00 * unitSpacing)
    end

    if (doHeroes) then
        -- If the "Random Hero" option is set, start the player with a random hero.
        -- Otherwise, give them a "free hero" token.
        if useRandomHero then
            MeleeRandomHeroLoc(whichPlayer, FourCC('Udea'), FourCC('Udre'), FourCC('Ulic'), FourCC('Ucrl'), heroLoc)
        else
            SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
        end
    end

    if (doCamera) then
        -- Center the camera on the initial Acolytes.
        SetCameraPositionForPlayer(whichPlayer, peonX, peonY)
        SetCameraQuickPositionForPlayer(whichPlayer, peonX, peonY)
    end
end

--===========================================================================
-- Starting Units for Night Elf Players
--   - 1 Tree of Life, placed by nearest gold mine, already entangled
--   - 5 Wisps, placed between Tree of Life and nearest gold mine
--
---@type fun(whichPlayer: player, startLoc: location, doHeroes: boolean, doCamera: boolean, doPreload: boolean)
function MeleeStartingUnitsNightElf(whichPlayer, startLoc, doHeroes, doCamera, doPreload)
    local useRandomHero          = IsMapFlagSet(MAP_RANDOM_HERO) ---@type boolean 
    local unitSpacing            = 64.00 ---@type number 
    local minTreeDist            = 3.50 * bj_CELLWIDTH ---@type number 
    local minWispDist            = 1.75 * bj_CELLWIDTH ---@type number 
    local nearestMine ---@type unit 
    local nearMineLoc ---@type location 
    local wispLoc ---@type location 
    local heroLoc ---@type location 
    local peonX ---@type number 
    local peonY ---@type number 
    local tree ---@type unit 

    if (doPreload) then
        Preloader( "scripts\\NightElfMelee.pld" )
    end

    nearestMine = MeleeFindNearestMine(startLoc, bj_MELEE_MINE_SEARCH_RADIUS)
    if (nearestMine ~= nil) then
        -- Spawn Tree of Life near the mine and have it entangle the mine.
        -- Project the Tree's coordinates from the gold mine, and then snap
        -- the X and Y values to within minTreeDist of the Gold Mine.
        nearMineLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 650, 0)
        nearMineLoc = MeleeGetLocWithinRect(nearMineLoc, GetRectFromCircleBJ(GetUnitLoc(nearestMine), minTreeDist))
        tree = CreateUnitAtLoc(whichPlayer, FourCC('etol'), nearMineLoc, bj_UNIT_FACING)
        IssueTargetOrder(tree, "entangleinstant", nearestMine)

        -- Spawn Wisps at the start location.
        wispLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 320, 0)
        wispLoc = MeleeGetLocWithinRect(wispLoc, GetRectFromCircleBJ(GetUnitLoc(nearestMine), minWispDist))
        peonX = GetLocationX(wispLoc)
        peonY = GetLocationY(wispLoc)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 0.00 * unitSpacing, peonY + 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX - 1.00 * unitSpacing, peonY + 0.15 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 0.58 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX - 0.58 * unitSpacing, peonY - 1.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be off to the side of the start location.
        heroLoc = MeleeGetProjectedLoc(GetUnitLoc(nearestMine), startLoc, 384, 45)
    else
        -- Spawn Tree of Life at the start location.
        CreateUnitAtLoc(whichPlayer, FourCC('etol'), startLoc, bj_UNIT_FACING)

        -- Spawn Wisps directly south of the town hall.
        peonX = GetLocationX(startLoc)
        peonY = GetLocationY(startLoc) - 224.00
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX - 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX - 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 0.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 1.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)
        CreateUnit(whichPlayer, FourCC('ewsp'), peonX + 2.00 * unitSpacing, peonY + 0.00 * unitSpacing, bj_UNIT_FACING)

        -- Set random hero spawn point to be just south of the start location.
        heroLoc = Location(peonX, peonY - 2.00 * unitSpacing)
    end

    if (doHeroes) then
        -- If the "Random Hero" option is set, start the player with a random hero.
        -- Otherwise, give them a "free hero" token.
        if useRandomHero then
            MeleeRandomHeroLoc(whichPlayer, FourCC('Edem'), FourCC('Ekee'), FourCC('Emoo'), FourCC('Ewar'), heroLoc)
        else
            SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
        end
    end

    if (doCamera) then
        -- Center the camera on the initial Wisps.
        SetCameraPositionForPlayer(whichPlayer, peonX, peonY)
        SetCameraQuickPositionForPlayer(whichPlayer, peonX, peonY)
    end
end

--===========================================================================
-- Starting Units for Players Whose Race is Unknown
--   - 12 Sheep, placed randomly around the start location
--
---@type fun(whichPlayer: player, startLoc: location, doHeroes: boolean, doCamera: boolean, doPreload: boolean)
function MeleeStartingUnitsUnknownRace(whichPlayer, startLoc, doHeroes, doCamera, doPreload)
    local index ---@type integer 

    if (doPreload) then
    end

    index = 0
    repeat
        CreateUnit(whichPlayer, FourCC('nshe'), GetLocationX(startLoc) + GetRandomReal(-256, 256), GetLocationY(startLoc) + GetRandomReal(-256, 256), GetRandomReal(0, 360))
        index = index + 1
    until index == 12

    if (doHeroes) then
        -- Give them a "free hero" token, out of pity.
        SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS)
    end

    if (doCamera) then
        -- Center the camera on the initial sheep.
        SetCameraPositionLocForPlayer(whichPlayer, startLoc)
        SetCameraQuickPositionLocForPlayer(whichPlayer, startLoc)
    end
end

--===========================================================================
function MeleeStartingUnits()
    local index ---@type integer 
    local indexPlayer ---@type player 
    local indexStartLoc ---@type location 
    local indexRace ---@type race 

    Preloader( "scripts\\SharedMelee.pld" )

    index = 0
    repeat
        indexPlayer = Player(index)
        if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
            indexStartLoc = GetStartLocationLoc(GetPlayerStartLocation(indexPlayer))
            indexRace = GetPlayerRace(indexPlayer)

            -- Create initial race-specific starting units
            if (indexRace == RACE_HUMAN) then
                MeleeStartingUnitsHuman(indexPlayer, indexStartLoc, true, true, true)
            elseif (indexRace == RACE_ORC) then
                MeleeStartingUnitsOrc(indexPlayer, indexStartLoc, true, true, true)
            elseif (indexRace == RACE_UNDEAD) then
                MeleeStartingUnitsUndead(indexPlayer, indexStartLoc, true, true, true)
            elseif (indexRace == RACE_NIGHTELF) then
                MeleeStartingUnitsNightElf(indexPlayer, indexStartLoc, true, true, true)
            else
                MeleeStartingUnitsUnknownRace(indexPlayer, indexStartLoc, true, true, true)
            end
        end

        index = index + 1
    until index == bj_MAX_PLAYERS
    
end

--===========================================================================
---@type fun(whichRace: race, whichPlayer: player, loc: location, doHeroes: boolean)
function MeleeStartingUnitsForPlayer(whichRace, whichPlayer, loc, doHeroes)
    -- Create initial race-specific starting units
    if (whichRace == RACE_HUMAN) then
        MeleeStartingUnitsHuman(whichPlayer, loc, doHeroes, false, false)
    elseif (whichRace == RACE_ORC) then
        MeleeStartingUnitsOrc(whichPlayer, loc, doHeroes, false, false)
    elseif (whichRace == RACE_UNDEAD) then
        MeleeStartingUnitsUndead(whichPlayer, loc, doHeroes, false, false)
    elseif (whichRace == RACE_NIGHTELF) then
        MeleeStartingUnitsNightElf(whichPlayer, loc, doHeroes, false, false)
    else
        -- Unrecognized race - ignore the request.
    end
end



--***************************************************************************
--*
--*  Melee Template Starting AI Scripts
--*
--***************************************************************************

--===========================================================================
---@type fun(num: player, s1: string, s2?: string, s3?: string)
function PickMeleeAI(num, s1, s2, s3)
    local pick ---@type integer 

    -- easy difficulty never uses any custom AI scripts
    -- that are designed to be a bit more challenging
    --
    if GetAIDifficulty(num) == AI_DIFFICULTY_NEWBIE then
        StartMeleeAI(num,s1)
        return
    end

    if s2 == nil then
        pick = 1
    elseif s3 == nil then
        pick = GetRandomInt(1,2)
    else
        pick = GetRandomInt(1,3)
    end

    if pick == 1 then
        StartMeleeAI(num,s1)
    elseif pick == 2 then
        StartMeleeAI(num,s2)
    else
        StartMeleeAI(num,s3)
    end
end

--===========================================================================
function MeleeStartingAI()
    local index ---@type integer 
    local indexPlayer ---@type player 
    local indexRace ---@type race 

    index = 0
    repeat
        indexPlayer = Player(index)
        if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
            indexRace = GetPlayerRace(indexPlayer)
            if (GetPlayerController(indexPlayer) == MAP_CONTROL_COMPUTER) then
                -- Run a race-specific melee AI script.
                if (indexRace == RACE_HUMAN) then
                    PickMeleeAI(indexPlayer, "human.ai", nil, nil)
                elseif (indexRace == RACE_ORC) then
                    PickMeleeAI(indexPlayer, "orc.ai", nil, nil)
                elseif (indexRace == RACE_UNDEAD) then
                    PickMeleeAI(indexPlayer, "undead.ai", nil, nil)
                    RecycleGuardPosition(bj_ghoul[index])
                elseif (indexRace == RACE_NIGHTELF) then
                    PickMeleeAI(indexPlayer, "elf.ai", nil, nil)
                else
                    -- Unrecognized race.
                end
                ShareEverythingWithTeamAI(indexPlayer)
            end
        end

        index = index + 1
    until index == bj_MAX_PLAYERS
end

---@type fun(targ: unit)
function LockGuardPosition(targ)
    SetUnitCreepGuard(targ,true)
end


--***************************************************************************
--*
--*  Melee Template Victory / Defeat Conditions
--*
--***************************************************************************

--===========================================================================
---@type fun(playerIndex: integer, opponentIndex: integer):boolean
function MeleePlayerIsOpponent(playerIndex, opponentIndex)
    local thePlayer        = Player(playerIndex) ---@type player 
    local theOpponent        = Player(opponentIndex) ---@type player 

    -- The player himself is not an opponent.
    if (playerIndex == opponentIndex) then
        return false
    end

    -- Unused player slots are not opponents.
    if (GetPlayerSlotState(theOpponent) ~= PLAYER_SLOT_STATE_PLAYING) then
        return false
    end

    -- Players who are already defeated are not opponents.
    if (bj_meleeDefeated[opponentIndex]) then
        return false
    end

    -- Allied players with allied victory set are not opponents.
    if GetPlayerAlliance(thePlayer, theOpponent, ALLIANCE_PASSIVE) then
        if GetPlayerAlliance(theOpponent, thePlayer, ALLIANCE_PASSIVE) then
            if (GetPlayerState(thePlayer, PLAYER_STATE_ALLIED_VICTORY) == 1) then
                if (GetPlayerState(theOpponent, PLAYER_STATE_ALLIED_VICTORY) == 1) then
                    return false
                end
            end
        end
    end

    return true
end

--===========================================================================
-- Count buildings currently owned by all allies, including the player themself.
--
---@type fun(whichPlayer: player):integer
function MeleeGetAllyStructureCount(whichPlayer)
    local playerIndex ---@type integer 
    local buildingCount ---@type integer 
    local indexPlayer ---@type player 

    -- Count the number of buildings controlled by all not-yet-defeated co-allies.
    buildingCount = 0
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)

        -- uncomment to cause defeat even if you have control of ally structures, but yours have been nixed
        --if (PlayersAreCoAllied(whichPlayer, indexPlayer) and not bj_meleeDefeated[playerIndex]) then
        if (PlayersAreCoAllied(whichPlayer, indexPlayer)) then
            buildingCount = buildingCount + GetPlayerStructureCount(indexPlayer, true)
        end
            
        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    return buildingCount
end

--===========================================================================
-- Count allies, excluding dead players and the player themself.
--
---@type fun(whichPlayer: player):integer
function MeleeGetAllyCount(whichPlayer)
    local playerIndex ---@type integer 
    local playerCount ---@type integer 
    local indexPlayer ---@type player 

    -- Count the number of not-yet-defeated co-allies.
    playerCount = 0
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if PlayersAreCoAllied(whichPlayer, indexPlayer) and not bj_meleeDefeated[playerIndex] and (whichPlayer ~= indexPlayer) then
            playerCount = playerCount + 1
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    return playerCount
end

--===========================================================================
-- Counts key structures owned by a player and his or her allies, including
-- structures currently upgrading or under construction.
--
-- Key structures: Town Hall, Great Hall, Tree of Life, Necropolis
--
---@type fun(whichPlayer: player):integer
function MeleeGetAllyKeyStructureCount(whichPlayer)
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local keyStructs ---@type integer 

    -- Count the number of buildings controlled by all not-yet-defeated co-allies.
    keyStructs = 0
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if (PlayersAreCoAllied(whichPlayer, indexPlayer)) then
            keyStructs = keyStructs + BlzGetPlayerTownHallCount(indexPlayer)
        end
            
        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    return keyStructs
end

--===========================================================================
-- Enum: Draw out a specific player.
--
function MeleeDoDrawEnum()
    local thePlayer        = GetEnumPlayer() ---@type player 

    CachePlayerHeroData(thePlayer)
    RemovePlayerPreserveUnitsBJ(thePlayer, PLAYER_GAME_RESULT_TIE, false)
end

--===========================================================================
-- Enum: Victory out a specific player.
--
function MeleeDoVictoryEnum()
    local thePlayer        = GetEnumPlayer() ---@type player 
    local playerIndex         = GetPlayerId(thePlayer) ---@type integer 

    if (not bj_meleeVictoried[playerIndex]) then
        bj_meleeVictoried[playerIndex] = true
        CachePlayerHeroData(thePlayer)
        RemovePlayerPreserveUnitsBJ(thePlayer, PLAYER_GAME_RESULT_VICTORY, false)
    end
end

--===========================================================================
-- Defeat out a specific player.
--
---@type fun(whichPlayer: player)
function MeleeDoDefeat(whichPlayer)
    bj_meleeDefeated[GetPlayerId(whichPlayer)] = true
    RemovePlayerPreserveUnitsBJ(whichPlayer, PLAYER_GAME_RESULT_DEFEAT, false)
end

--===========================================================================
-- Enum: Defeat out a specific player.
--
function MeleeDoDefeatEnum()
    local thePlayer        = GetEnumPlayer() ---@type player 

    -- needs to happen before ownership change
    CachePlayerHeroData(thePlayer)
    MakeUnitsPassiveForTeam(thePlayer)
    MeleeDoDefeat(thePlayer)
end

--===========================================================================
-- A specific player left the game.
--
---@type fun(whichPlayer: player)
function MeleeDoLeave(whichPlayer)
    if (GetIntegerGameState(GAME_STATE_DISCONNECTED) ~= 0) then
        GameOverDialogBJ( whichPlayer, true )
    else
        bj_meleeDefeated[GetPlayerId(whichPlayer)] = true
        RemovePlayerPreserveUnitsBJ(whichPlayer, PLAYER_GAME_RESULT_DEFEAT, true)
    end
end

--===========================================================================
-- Remove all observers
-- 
function MeleeRemoveObservers()
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 

    -- Give all observers the game over dialog
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)

        if (IsPlayerObserver(indexPlayer)) then
            RemovePlayerPreserveUnitsBJ(indexPlayer, PLAYER_GAME_RESULT_NEUTRAL, false)
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
end

--===========================================================================
-- Test all players to determine if a team has won.  For a team to win, all
-- remaining (read: undefeated) players need to be co-allied with all other
-- remaining players.  If even one player is not allied towards another,
-- everyone must be denied victory.
--
---@type fun():force
function MeleeCheckForVictors()
    local playerIndex ---@type integer 
    local opponentIndex ---@type integer 
    local opponentlessPlayers            = CreateForce() ---@type force 
    local gameOver            = false ---@type boolean 

    -- Check to see if any players have opponents remaining.
    playerIndex = 0
    repeat
        if (not bj_meleeDefeated[playerIndex]) then
            -- Determine whether or not this player has any remaining opponents.
            opponentIndex = 0
            repeat
                -- If anyone has an opponent, noone can be victorious yet.
                if MeleePlayerIsOpponent(playerIndex, opponentIndex) then
                    return CreateForce()
                end

                opponentIndex = opponentIndex + 1
            until opponentIndex == bj_MAX_PLAYERS

            -- Keep track of each opponentless player so that we can give
            -- them a victory later.
            ForceAddPlayer(opponentlessPlayers, Player(playerIndex))
            gameOver = true
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    -- Set the game over global flag
    bj_meleeGameOver = gameOver

    return opponentlessPlayers
end

--===========================================================================
-- Test each player to determine if anyone has been defeated.
--
function MeleeCheckForLosersAndVictors()
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local defeatedPlayers            = CreateForce() ---@type force 
    local victoriousPlayers ---@type force 
    local gameOver            = false ---@type boolean 

    -- If the game is already over, do nothing
    if (bj_meleeGameOver) then
        return
    end

    -- If the game was disconnected then it is over, in this case we
    -- don't want to report results for anyone as they will most likely
    -- conflict with the actual game results
    if (GetIntegerGameState(GAME_STATE_DISCONNECTED) ~= 0) then
        bj_meleeGameOver = true
        return
    end

    -- Check each player to see if he or she has been defeated yet.
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)

        if (not bj_meleeDefeated[playerIndex] and not bj_meleeVictoried[playerIndex]) then
            --call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, "Player"..I2S(playerIndex).." has "..I2S(MeleeGetAllyStructureCount(indexPlayer)).." ally buildings.")
            if (MeleeGetAllyStructureCount(indexPlayer) <= 0) then

                -- Keep track of each defeated player so that we can give
                -- them a defeat later.
                ForceAddPlayer(defeatedPlayers, Player(playerIndex))

                -- Set their defeated flag now so MeleeCheckForVictors
                -- can detect victors.
                bj_meleeDefeated[playerIndex] = true
            end
        end
            
        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    -- Now that the defeated flags are set, check if there are any victors
    victoriousPlayers = MeleeCheckForVictors()

    -- Defeat all defeated players
    ForForce(defeatedPlayers, MeleeDoDefeatEnum)

    -- Give victory to all victorious players
    ForForce(victoriousPlayers, MeleeDoVictoryEnum)

    -- If the game is over we should remove all observers
    if (bj_meleeGameOver) then
        MeleeRemoveObservers()
    end
end

--===========================================================================
-- Returns a race-specific "build X or be revealed" message.
--
---@type fun(whichPlayer: player):string
function MeleeGetCrippledWarningMessage(whichPlayer)
    local r      = GetPlayerRace(whichPlayer) ---@type race 

    if (r == RACE_HUMAN) then
        return GetLocalizedString("CRIPPLE_WARNING_HUMAN")
    elseif (r == RACE_ORC) then
        return GetLocalizedString("CRIPPLE_WARNING_ORC")
    elseif (r == RACE_NIGHTELF) then
        return GetLocalizedString("CRIPPLE_WARNING_NIGHTELF")
    elseif (r == RACE_UNDEAD) then
        return GetLocalizedString("CRIPPLE_WARNING_UNDEAD")
    else
        -- Unrecognized Race
        return ""
    end
end

--===========================================================================
-- Returns a race-specific "build X" label for cripple timers.
--
---@type fun(whichPlayer: player):string
function MeleeGetCrippledTimerMessage(whichPlayer)
    local r      = GetPlayerRace(whichPlayer) ---@type race 

    if (r == RACE_HUMAN) then
        return GetLocalizedString("CRIPPLE_TIMER_HUMAN")
    elseif (r == RACE_ORC) then
        return GetLocalizedString("CRIPPLE_TIMER_ORC")
    elseif (r == RACE_NIGHTELF) then
        return GetLocalizedString("CRIPPLE_TIMER_NIGHTELF")
    elseif (r == RACE_UNDEAD) then
        return GetLocalizedString("CRIPPLE_TIMER_UNDEAD")
    else
        -- Unrecognized Race
        return ""
    end
end

--===========================================================================
-- Returns a race-specific "build X" label for cripple timers.
--
---@type fun(whichPlayer: player):string
function MeleeGetCrippledRevealedMessage(whichPlayer)
    return GetLocalizedString("CRIPPLE_REVEALING_PREFIX") .. GetPlayerName(whichPlayer) .. GetLocalizedString("CRIPPLE_REVEALING_POSTFIX")
end

--===========================================================================
---@type fun(whichPlayer: player, expose: boolean)
function MeleeExposePlayer(whichPlayer, expose)
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local toExposeTo         = CreateForce() ---@type force 

    CripplePlayer( whichPlayer, toExposeTo, false )

    bj_playerIsExposed[GetPlayerId(whichPlayer)] = expose
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        if (not PlayersAreCoAllied(whichPlayer, indexPlayer)) then
            ForceAddPlayer( toExposeTo, indexPlayer )
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    CripplePlayer( whichPlayer, toExposeTo, expose )
    DestroyForce(toExposeTo)
end

--===========================================================================
function MeleeExposeAllPlayers()
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local playerIndex2 ---@type integer 
    local indexPlayer2 ---@type player 
    local toExposeTo         = CreateForce() ---@type force 

    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)

        ForceClear( toExposeTo )
        CripplePlayer( indexPlayer, toExposeTo, false )

        playerIndex2 = 0
        repeat
            indexPlayer2 = Player(playerIndex2)

            if playerIndex ~= playerIndex2 then
                if (not PlayersAreCoAllied(indexPlayer, indexPlayer2)) then
                    ForceAddPlayer( toExposeTo, indexPlayer2 )
                end
            end

            playerIndex2 = playerIndex2 + 1
        until playerIndex2 == bj_MAX_PLAYERS

        CripplePlayer( indexPlayer, toExposeTo, true )

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS

    DestroyForce( toExposeTo )
end

--===========================================================================
function MeleeCrippledPlayerTimeout()
    local expiredTimer       = GetExpiredTimer() ---@type timer 
    local playerIndex ---@type integer 
    local exposedPlayer ---@type player 

    -- Determine which player's timer expired.
    playerIndex = 0
    repeat
        if (bj_crippledTimer[playerIndex] == expiredTimer) then
            break
        end

        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
    if (playerIndex == bj_MAX_PLAYERS) then
        return
    end
    exposedPlayer = Player(playerIndex)

    if (GetLocalPlayer() == exposedPlayer) then
        -- Use only local code (no net traffic) within this block to avoid desyncs.

        -- Hide the timer window for this player.
        TimerDialogDisplay(bj_crippledTimerWindows[playerIndex], false)
    end

    -- Display a text message to all players, explaining the exposure.
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, bj_MELEE_CRIPPLE_MSG_DURATION, MeleeGetCrippledRevealedMessage(exposedPlayer))

    -- Expose the player.
    MeleeExposePlayer(exposedPlayer, true)
end

--===========================================================================
---@type fun(whichPlayer: player):boolean
function MeleePlayerIsCrippled(whichPlayer)
    local playerStructures          = GetPlayerStructureCount(whichPlayer, true) ---@type integer 
    local playerKeyStructures         = BlzGetPlayerTownHallCount(whichPlayer) ---@type integer 

    -- Dead players are not considered to be crippled.
    return (playerStructures > 0) and (playerKeyStructures <= 0)
end

--===========================================================================
-- Test each player to determine if anyone has become crippled.
--
function MeleeCheckForCrippledPlayers()
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local crippledPlayers            = CreateForce() ---@type force 
    local isNowCrippled ---@type boolean 
    local indexRace ---@type race 

    -- The "finish soon" exposure of all players overrides any "crippled" exposure
    if bj_finishSoonAllExposed then
        return
    end

    -- Check each player to see if he or she has been crippled or uncrippled.
    playerIndex = 0
    repeat
        indexPlayer = Player(playerIndex)
        isNowCrippled = MeleePlayerIsCrippled(indexPlayer)

        if (not bj_playerIsCrippled[playerIndex] and isNowCrippled) then

            -- Player became crippled; start their cripple timer.
            bj_playerIsCrippled[playerIndex] = true
            TimerStart(bj_crippledTimer[playerIndex], bj_MELEE_CRIPPLE_TIMEOUT, false, MeleeCrippledPlayerTimeout)

            if (GetLocalPlayer() == indexPlayer) then
                -- Use only local code (no net traffic) within this block to avoid desyncs.

                -- Show the timer window.
                TimerDialogDisplay(bj_crippledTimerWindows[playerIndex], true)

                -- Display a warning message.
                DisplayTimedTextToPlayer(indexPlayer, 0, 0, bj_MELEE_CRIPPLE_MSG_DURATION, MeleeGetCrippledWarningMessage(indexPlayer))
            end

        elseif (bj_playerIsCrippled[playerIndex] and not isNowCrippled) then

            -- Player became uncrippled; stop their cripple timer.
            bj_playerIsCrippled[playerIndex] = false
            PauseTimer(bj_crippledTimer[playerIndex])

            if (GetLocalPlayer() == indexPlayer) then
                -- Use only local code (no net traffic) within this block to avoid desyncs.

                -- Hide the timer window for this player.
                TimerDialogDisplay(bj_crippledTimerWindows[playerIndex], false)

                -- Display a confirmation message if the player's team is still alive.
                if (MeleeGetAllyStructureCount(indexPlayer) > 0) then
                    if (bj_playerIsExposed[playerIndex]) then
                        DisplayTimedTextToPlayer(indexPlayer, 0, 0, bj_MELEE_CRIPPLE_MSG_DURATION, GetLocalizedString("CRIPPLE_UNREVEALED"))
                    else
                        DisplayTimedTextToPlayer(indexPlayer, 0, 0, bj_MELEE_CRIPPLE_MSG_DURATION, GetLocalizedString("CRIPPLE_UNCRIPPLED"))
                    end
                end
            end

            -- If the player granted shared vision, deny that vision now.
            MeleeExposePlayer(indexPlayer, false)

        end
            
        playerIndex = playerIndex + 1
    until playerIndex == bj_MAX_PLAYERS
end

--===========================================================================
-- Determine if the lost unit should result in any defeats or victories.
--
---@type fun(lostUnit: unit)
function MeleeCheckLostUnit(lostUnit)
    local lostUnitOwner        = GetOwningPlayer(lostUnit) ---@type player 

    -- We only need to check for mortality if this was the last building.
    if (GetPlayerStructureCount(lostUnitOwner, true) <= 0) then
        MeleeCheckForLosersAndVictors()
    end

    -- Check if the lost unit has crippled or uncrippled the player.
    -- (A team with 0 units is dead, and thus considered uncrippled.)
    MeleeCheckForCrippledPlayers()
end

--===========================================================================
-- Determine if the gained unit should result in any defeats, victories,
-- or cripple-status changes.
--
---@type fun(addedUnit: unit)
function MeleeCheckAddedUnit(addedUnit)
    local addedUnitOwner        = GetOwningPlayer(addedUnit) ---@type player 

    -- If the player was crippled, this unit may have uncrippled him/her.
    if (bj_playerIsCrippled[GetPlayerId(addedUnitOwner)]) then
        MeleeCheckForCrippledPlayers()
    end
end

--===========================================================================
function MeleeTriggerActionConstructCancel()
    MeleeCheckLostUnit(GetCancelledStructure())
end

--===========================================================================
function MeleeTriggerActionUnitDeath()
    if (IsUnitType(GetDyingUnit(), UNIT_TYPE_STRUCTURE)) then
        MeleeCheckLostUnit(GetDyingUnit())
    end
end

--===========================================================================
function MeleeTriggerActionUnitConstructionStart()
    MeleeCheckAddedUnit(GetConstructingStructure())
end

--===========================================================================
function MeleeTriggerActionPlayerDefeated()
    local thePlayer        = GetTriggerPlayer() ---@type player 
    CachePlayerHeroData(thePlayer)

    if (MeleeGetAllyCount(thePlayer) > 0) then
        -- If at least one ally is still alive and kicking, share units with
        -- them and proceed with death.
        ShareEverythingWithTeam(thePlayer)
        if (not bj_meleeDefeated[GetPlayerId(thePlayer)]) then
            MeleeDoDefeat(thePlayer)
        end
    else
        -- If no living allies remain, swap all units and buildings over to
        -- neutral_passive and proceed with death.
        MakeUnitsPassiveForTeam(thePlayer)
        if (not bj_meleeDefeated[GetPlayerId(thePlayer)]) then
            MeleeDoDefeat(thePlayer)
        end
    end
    MeleeCheckForLosersAndVictors()
end

--===========================================================================
function MeleeTriggerActionPlayerLeft()
    local thePlayer        = GetTriggerPlayer() ---@type player 

    -- Just show game over for observers when they leave
    if (IsPlayerObserver(thePlayer)) then
        RemovePlayerPreserveUnitsBJ(thePlayer, PLAYER_GAME_RESULT_NEUTRAL, false)
        return
    end

    CachePlayerHeroData(thePlayer)

    -- This is the same as defeat except the player generates the message 
    -- "player left the game" as opposed to "player was defeated".

    if (MeleeGetAllyCount(thePlayer) > 0) then
        -- If at least one ally is still alive and kicking, share units with
        -- them and proceed with death.
        ShareEverythingWithTeam(thePlayer)
        MeleeDoLeave(thePlayer)
    else
        -- If no living allies remain, swap all units and buildings over to
        -- neutral_passive and proceed with death.
        MakeUnitsPassiveForTeam(thePlayer)
        MeleeDoLeave(thePlayer)
    end
    MeleeCheckForLosersAndVictors()
end

--===========================================================================
function MeleeTriggerActionAllianceChange()
    MeleeCheckForLosersAndVictors()
    MeleeCheckForCrippledPlayers()
end

--===========================================================================
function MeleeTriggerTournamentFinishSoon()
    -- Note: We may get this trigger multiple times
    local playerIndex ---@type integer 
    local indexPlayer ---@type player 
    local timeRemaining            = GetTournamentFinishSoonTimeRemaining() ---@type number 

    if not bj_finishSoonAllExposed then
        bj_finishSoonAllExposed = true

        -- Reset all crippled players and their timers, and hide the local crippled timer dialog
        playerIndex = 0
        repeat
            indexPlayer = Player(playerIndex)
            if bj_playerIsCrippled[playerIndex] then
                -- Uncripple the player
                bj_playerIsCrippled[playerIndex] = false
                PauseTimer(bj_crippledTimer[playerIndex])

                if (GetLocalPlayer() == indexPlayer) then
                    -- Use only local code (no net traffic) within this block to avoid desyncs.

                    -- Hide the timer window.
                    TimerDialogDisplay(bj_crippledTimerWindows[playerIndex], false)
                end

            end
            playerIndex = playerIndex + 1
        until playerIndex == bj_MAX_PLAYERS

        -- Expose all players
        MeleeExposeAllPlayers()
    end

    -- Show the "finish soon" timer dialog and set the real time remaining
    TimerDialogDisplay(bj_finishSoonTimerDialog, true)
    TimerDialogSetRealTimeRemaining(bj_finishSoonTimerDialog, timeRemaining)
end


--===========================================================================
---@type fun(whichPlayer: player):boolean
function MeleeWasUserPlayer(whichPlayer)
    local slotState ---@type playerslotstate 

    if (GetPlayerController(whichPlayer) ~= MAP_CONTROL_USER) then
        return false
    end

    slotState = GetPlayerSlotState(whichPlayer)

    return (slotState == PLAYER_SLOT_STATE_PLAYING or slotState == PLAYER_SLOT_STATE_LEFT)
end

--===========================================================================
---@type fun(multiplier: integer)
function MeleeTournamentFinishNowRuleA(multiplier)
    local playerScore=__jarray(0) ---@type integer[] 
    local teamScore=__jarray(0) ---@type integer[] 
    local teamForce={} ---@type force[] 
    local teamCount ---@type integer 
    local index ---@type integer 
    local indexPlayer ---@type player 
    local index2 ---@type integer 
    local indexPlayer2 ---@type player 
    local bestTeam ---@type integer 
    local bestScore ---@type integer 
    local draw ---@type boolean 

    -- Compute individual player scores
    index = 0
    repeat
        indexPlayer = Player(index)
        if MeleeWasUserPlayer(indexPlayer) then
            playerScore[index] = GetTournamentScore(indexPlayer)
            if playerScore[index] <= 0 then
                playerScore[index] = 1
            end
        else
            playerScore[index] = 0
        end
        index = index + 1
    until index == bj_MAX_PLAYERS

    -- Compute team scores and team forces
    teamCount = 0
    index = 0
    repeat
        if playerScore[index] ~= 0 then
            indexPlayer = Player(index)

            teamScore[teamCount] = 0
            teamForce[teamCount] = CreateForce()

            index2 = index
            repeat
                if playerScore[index2] ~= 0 then
                    indexPlayer2 = Player(index2)

                    if PlayersAreCoAllied(indexPlayer, indexPlayer2) then
                        teamScore[teamCount] = teamScore[teamCount] + playerScore[index2]
                        ForceAddPlayer(teamForce[teamCount], indexPlayer2)
                        playerScore[index2] = 0
                    end
                end

                index2 = index2 + 1
            until index2 == bj_MAX_PLAYERS

            teamCount = teamCount + 1
        end

        index = index + 1
    until index == bj_MAX_PLAYERS

    -- The game is now over
    bj_meleeGameOver = true

    -- There should always be at least one team, but continue to work if not
    if teamCount ~= 0 then

        -- Find best team score
        bestTeam = -1
        bestScore = -1
        index = 0
        repeat
            if teamScore[index] > bestScore then
                bestTeam = index
                bestScore = teamScore[index]
            end

            index = index + 1
        until index == teamCount

        -- Check whether the best team's score is 'multiplier' times better than
        -- every other team. In the case of multiplier == 1 and exactly equal team
        -- scores, the first team (which was randomly chosen by the server) will win.
        draw = false
        index = 0
        repeat
            if index ~= bestTeam then
                if bestScore < (multiplier * teamScore[index]) then
                    draw = true
                end
            end

            index = index + 1
        until index == teamCount

        if draw then
            -- Give draw to all players on all teams
            index = 0
            repeat
                ForForce(teamForce[index], MeleeDoDrawEnum)

                index = index + 1
            until index == teamCount
        else
            -- Give defeat to all players on teams other than the best team
            index = 0
            repeat
                if index ~= bestTeam then
                    ForForce(teamForce[index], MeleeDoDefeatEnum)
                end

                index = index + 1
            until index == teamCount

            -- Give victory to all players on the best team
            ForForce(teamForce[bestTeam], MeleeDoVictoryEnum)
        end
    end

end

--===========================================================================
function MeleeTriggerTournamentFinishNow()
    local rule         = GetTournamentFinishNowRule() ---@type integer 

    -- If the game is already over, do nothing
    if bj_meleeGameOver then
        return
    end

    if (rule == 1) then
        -- Finals games
        MeleeTournamentFinishNowRuleA(1)
    else
        -- Preliminary games
        MeleeTournamentFinishNowRuleA(3)
    end

    -- Since the game is over we should remove all observers
    MeleeRemoveObservers()

end

--===========================================================================
function MeleeInitVictoryDefeat()
    local trig ---@type trigger 
    local index ---@type integer 
    local indexPlayer ---@type player 

    -- Create a timer window for the "finish soon" timeout period, it has no timer
    -- because it is driven by real time (outside of the game state to avoid desyncs)
    bj_finishSoonTimerDialog = CreateTimerDialog(nil)

    -- Set a trigger to fire when we receive a "finish soon" game event
    trig = CreateTrigger()
    TriggerRegisterGameEvent(trig, EVENT_GAME_TOURNAMENT_FINISH_SOON)
    TriggerAddAction(trig, MeleeTriggerTournamentFinishSoon)

    -- Set a trigger to fire when we receive a "finish now" game event
    trig = CreateTrigger()
    TriggerRegisterGameEvent(trig, EVENT_GAME_TOURNAMENT_FINISH_NOW)
    TriggerAddAction(trig, MeleeTriggerTournamentFinishNow)

    -- Set up each player's mortality code.
    index = 0
    repeat
        indexPlayer = Player(index)

        -- Make sure this player slot is playing.
        if (GetPlayerSlotState(indexPlayer) == PLAYER_SLOT_STATE_PLAYING) then
            bj_meleeDefeated[index] = false
            bj_meleeVictoried[index] = false

            -- Create a timer and timer window in case the player is crippled.
            bj_playerIsCrippled[index] = false
            bj_playerIsExposed[index] = false
            bj_crippledTimer[index] = CreateTimer()
            bj_crippledTimerWindows[index] = CreateTimerDialog(bj_crippledTimer[index])
            TimerDialogSetTitle(bj_crippledTimerWindows[index], MeleeGetCrippledTimerMessage(indexPlayer))

            -- Set a trigger to fire whenever a building is cancelled for this player.
            trig = CreateTrigger()
            TriggerRegisterPlayerUnitEvent(trig, indexPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
            TriggerAddAction(trig, MeleeTriggerActionConstructCancel)

            -- Set a trigger to fire whenever a unit dies for this player.
            trig = CreateTrigger()
            TriggerRegisterPlayerUnitEvent(trig, indexPlayer, EVENT_PLAYER_UNIT_DEATH, nil)
            TriggerAddAction(trig, MeleeTriggerActionUnitDeath)

            -- Set a trigger to fire whenever a unit begins construction for this player
            trig = CreateTrigger()
            TriggerRegisterPlayerUnitEvent(trig, indexPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
            TriggerAddAction(trig, MeleeTriggerActionUnitConstructionStart)

            -- Set a trigger to fire whenever this player defeats-out
            trig = CreateTrigger()
            TriggerRegisterPlayerEvent(trig, indexPlayer, EVENT_PLAYER_DEFEAT)
            TriggerAddAction(trig, MeleeTriggerActionPlayerDefeated)

            -- Set a trigger to fire whenever this player leaves
            trig = CreateTrigger()
            TriggerRegisterPlayerEvent(trig, indexPlayer, EVENT_PLAYER_LEAVE)
            TriggerAddAction(trig, MeleeTriggerActionPlayerLeft)

            -- Set a trigger to fire whenever this player changes his/her alliances.
            trig = CreateTrigger()
            TriggerRegisterPlayerAllianceChange(trig, indexPlayer, ALLIANCE_PASSIVE)
            TriggerRegisterPlayerStateEvent(trig, indexPlayer, PLAYER_STATE_ALLIED_VICTORY, EQUAL, 1)
            TriggerAddAction(trig, MeleeTriggerActionAllianceChange)
        else
            bj_meleeDefeated[index] = true
            bj_meleeVictoried[index] = false

            -- Handle leave events for observers
            if (IsPlayerObserver(indexPlayer)) then
                -- Set a trigger to fire whenever this player leaves
                trig = CreateTrigger()
                TriggerRegisterPlayerEvent(trig, indexPlayer, EVENT_PLAYER_LEAVE)
                TriggerAddAction(trig, MeleeTriggerActionPlayerLeft)
            end
        end

        index = index + 1
    until index == bj_MAX_PLAYERS

    -- Test for victory / defeat at startup, in case the user has already won / lost.
    -- Allow for a short time to pass first, so that the map can finish loading.
    TimerStart(CreateTimer(), 2.0, false, MeleeTriggerActionAllianceChange)
end



--***************************************************************************
--*
--*  Player Slot Availability
--*
--***************************************************************************

--===========================================================================
function CheckInitPlayerSlotAvailability()
    local index ---@type integer 

    if (not bj_slotControlReady) then
        index = 0
        repeat
            bj_slotControlUsed[index] = false
            bj_slotControl[index] = MAP_CONTROL_USER
            index = index + 1
        until index == bj_MAX_PLAYERS
        bj_slotControlReady = true
    end
end

--===========================================================================
---@type fun(whichPlayer: player, control: mapcontrol)
function SetPlayerSlotAvailable(whichPlayer, control)
    local playerIndex         = GetPlayerId(whichPlayer) ---@type integer 

    CheckInitPlayerSlotAvailability()
    bj_slotControlUsed[playerIndex] = true
    bj_slotControl[playerIndex] = control
end



--***************************************************************************
--*
--*  Generic Template Player-slot Initialization
--*
--***************************************************************************

--===========================================================================
---@type fun(teamCount: integer)
function TeamInitPlayerSlots(teamCount)
    local index ---@type integer 
    local indexPlayer ---@type player 
    local team ---@type integer 

    SetTeams(teamCount)

    CheckInitPlayerSlotAvailability()
    index = 0
    team = 0
    repeat
        if (bj_slotControlUsed[index]) then
            indexPlayer = Player(index)
            SetPlayerTeam( indexPlayer, team )
            team = team + 1
            if (team >= teamCount) then
                team = 0
            end
        end

        index = index + 1
    until index == bj_MAX_PLAYERS
end

--===========================================================================
function MeleeInitPlayerSlots()
    TeamInitPlayerSlots(bj_MAX_PLAYERS)
end

--===========================================================================
function FFAInitPlayerSlots()
    TeamInitPlayerSlots(bj_MAX_PLAYERS)
end

--===========================================================================
function OneOnOneInitPlayerSlots()
    -- Limit the game to 2 players.
    SetTeams(2)
    SetPlayers(2)
    TeamInitPlayerSlots(2)
end

--===========================================================================
function InitGenericPlayerSlots()
    local gType          = GetGameTypeSelected() ---@type gametype 

    if (gType == GAME_TYPE_MELEE) then
        MeleeInitPlayerSlots()
    elseif (gType == GAME_TYPE_FFA) then
        FFAInitPlayerSlots()
    elseif (gType == GAME_TYPE_USE_MAP_SETTINGS) then
        -- Do nothing; the map-specific script handles this.
    elseif (gType == GAME_TYPE_ONE_ON_ONE) then
        OneOnOneInitPlayerSlots()
    elseif (gType == GAME_TYPE_TWO_TEAM_PLAY) then
        TeamInitPlayerSlots(2)
    elseif (gType == GAME_TYPE_THREE_TEAM_PLAY) then
        TeamInitPlayerSlots(3)
    elseif (gType == GAME_TYPE_FOUR_TEAM_PLAY) then
        TeamInitPlayerSlots(4)
    else
        -- Unrecognized Game Type
    end
end



--***************************************************************************
--*
--*  Blizzard.j Initialization
--*
--***************************************************************************

--===========================================================================
function SetDNCSoundsDawn()
    if bj_useDawnDuskSounds then
        StartSound(bj_dawnSound)
    end
end

--===========================================================================
function SetDNCSoundsDusk()
    if bj_useDawnDuskSounds then
        StartSound(bj_duskSound)
    end
end

--===========================================================================
function SetDNCSoundsDay()
    local ToD      = GetTimeOfDay() ---@type number 

    if (ToD >= bj_TOD_DAWN and ToD < bj_TOD_DUSK) and not bj_dncIsDaytime then
        bj_dncIsDaytime = true

        -- change ambient sounds
        StopSound(bj_nightAmbientSound, false, true)
        StartSound(bj_dayAmbientSound)
    end
end

--===========================================================================
function SetDNCSoundsNight()
    local ToD      = GetTimeOfDay() ---@type number 

    if (ToD < bj_TOD_DAWN or ToD >= bj_TOD_DUSK) and bj_dncIsDaytime then
        bj_dncIsDaytime = false

        -- change ambient sounds
        StopSound(bj_dayAmbientSound, false, true)
        StartSound(bj_nightAmbientSound)
    end
end

--===========================================================================
function InitDNCSounds()
    -- Create sounds to be played at dawn and dusk.
    bj_dawnSound = CreateSoundFromLabel("RoosterSound", false, false, false, 10000, 10000)
    bj_duskSound = CreateSoundFromLabel("WolfSound", false, false, false, 10000, 10000)

    -- Set up triggers to respond to dawn and dusk.
    bj_dncSoundsDawn = CreateTrigger()
    TriggerRegisterGameStateEvent(bj_dncSoundsDawn, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DAWN)
    TriggerAddAction(bj_dncSoundsDawn, SetDNCSoundsDawn)

    bj_dncSoundsDusk = CreateTrigger()
    TriggerRegisterGameStateEvent(bj_dncSoundsDusk, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DUSK)
    TriggerAddAction(bj_dncSoundsDusk, SetDNCSoundsDusk)

    -- Set up triggers to respond to changes from day to night or vice-versa.
    bj_dncSoundsDay = CreateTrigger()
    TriggerRegisterGameStateEvent(bj_dncSoundsDay,   GAME_STATE_TIME_OF_DAY, GREATER_THAN_OR_EQUAL, bj_TOD_DAWN)
    TriggerRegisterGameStateEvent(bj_dncSoundsDay,   GAME_STATE_TIME_OF_DAY, LESS_THAN,             bj_TOD_DUSK)
    TriggerAddAction(bj_dncSoundsDay, SetDNCSoundsDay)

    bj_dncSoundsNight = CreateTrigger()
    TriggerRegisterGameStateEvent(bj_dncSoundsNight, GAME_STATE_TIME_OF_DAY, LESS_THAN,             bj_TOD_DAWN)
    TriggerRegisterGameStateEvent(bj_dncSoundsNight, GAME_STATE_TIME_OF_DAY, GREATER_THAN_OR_EQUAL, bj_TOD_DUSK)
    TriggerAddAction(bj_dncSoundsNight, SetDNCSoundsNight)
end

--===========================================================================
function InitBlizzardGlobals()
    local index ---@type integer 
    local userControlledPlayers ---@type integer 
    local v ---@type version 

    -- Init filter function vars
    filterIssueHauntOrderAtLocBJ = Filter(IssueHauntOrderAtLocBJFilter)
    filterEnumDestructablesInCircleBJ = Filter(EnumDestructablesInCircleBJFilter)
    filterGetUnitsInRectOfPlayer = Filter(GetUnitsInRectOfPlayerFilter)
    filterGetUnitsOfTypeIdAll = Filter(GetUnitsOfTypeIdAllFilter)
    filterGetUnitsOfPlayerAndTypeId = Filter(GetUnitsOfPlayerAndTypeIdFilter)
    filterMeleeTrainedUnitIsHeroBJ = Filter(MeleeTrainedUnitIsHeroBJFilter)
    filterLivingPlayerUnitsOfTypeId = Filter(LivingPlayerUnitsOfTypeIdFilter)

    -- Init force presets
    index = 0
    while index ~= bj_MAX_PLAYER_SLOTS do 
        bj_FORCE_PLAYER[index] = CreateForce()
        ForceAddPlayer(bj_FORCE_PLAYER[index], Player(index))
        index = index + 1
    end

    bj_FORCE_ALL_PLAYERS = CreateForce()
    ForceEnumPlayers(bj_FORCE_ALL_PLAYERS, nil)

    -- Init Cinematic Mode history
    bj_cineModePriorSpeed = GetGameSpeed()
    bj_cineModePriorFogSetting = IsFogEnabled()
    bj_cineModePriorMaskSetting = IsFogMaskEnabled()

    -- Init Trigger Queue
    index = 0
    while index < bj_MAX_QUEUED_TRIGGERS do 
        bj_queuedExecTriggers[index] = nil
        bj_queuedExecUseConds[index] = false
        index = index + 1
    end

    -- Init singleplayer check
    bj_isSinglePlayer = false
    userControlledPlayers = 0
    index = 0
    while index < bj_MAX_PLAYERS do 
        if (GetPlayerController(Player(index)) == MAP_CONTROL_USER and GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING) then
            userControlledPlayers = userControlledPlayers + 1
        end
        index = index + 1
    end
    bj_isSinglePlayer = (userControlledPlayers == 1)

    -- Init sounds
    --set bj_pingMinimapSound = CreateSoundFromLabel("AutoCastButtonClick", false, false, false, 10000, 10000)
    bj_rescueSound = CreateSoundFromLabel("Rescue", false, false, false, 10000, 10000)
    bj_questDiscoveredSound = CreateSoundFromLabel("QuestNew", false, false, false, 10000, 10000)
    bj_questUpdatedSound = CreateSoundFromLabel("QuestUpdate", false, false, false, 10000, 10000)
    bj_questCompletedSound = CreateSoundFromLabel("QuestCompleted", false, false, false, 10000, 10000)
    bj_questFailedSound = CreateSoundFromLabel("QuestFailed", false, false, false, 10000, 10000)
    bj_questHintSound = CreateSoundFromLabel("Hint", false, false, false, 10000, 10000)
    bj_questSecretSound = CreateSoundFromLabel("SecretFound", false, false, false, 10000, 10000)
    bj_questItemAcquiredSound = CreateSoundFromLabel("ItemReward", false, false, false, 10000, 10000)
    bj_questWarningSound = CreateSoundFromLabel("Warning", false, false, false, 10000, 10000)
    bj_victoryDialogSound = CreateSoundFromLabel("QuestCompleted", false, false, false, 10000, 10000)
    bj_defeatDialogSound = CreateSoundFromLabel("QuestFailed", false, false, false, 10000, 10000)

    -- Init corpse creation triggers.
    DelayedSuspendDecayCreate()

    -- Init version-specific data
    v = VersionGet()
    if (v == VERSION_REIGN_OF_CHAOS) then
        bj_MELEE_MAX_TWINKED_HEROES = bj_MELEE_MAX_TWINKED_HEROES_V0
    else
        bj_MELEE_MAX_TWINKED_HEROES = bj_MELEE_MAX_TWINKED_HEROES_V1
    end
end

--===========================================================================
function InitQueuedTriggers()
    bj_queuedExecTimeout = CreateTrigger()
    TriggerRegisterTimerExpireEvent(bj_queuedExecTimeout, bj_queuedExecTimeoutTimer)
    TriggerAddAction(bj_queuedExecTimeout, QueuedTriggerDoneBJ)
end

--===========================================================================
function InitMapRects()
    bj_mapInitialPlayableArea = Rect(GetCameraBoundMinX()-GetCameraMargin(CAMERA_MARGIN_LEFT), GetCameraBoundMinY()-GetCameraMargin(CAMERA_MARGIN_BOTTOM), GetCameraBoundMaxX()+GetCameraMargin(CAMERA_MARGIN_RIGHT), GetCameraBoundMaxY()+GetCameraMargin(CAMERA_MARGIN_TOP))
    bj_mapInitialCameraBounds = GetCurrentCameraBoundsMapRectBJ()
end

--===========================================================================
function InitSummonableCaps()
    local index ---@type integer 

    index = 0
    repeat
        -- upgraded units
        -- Note: Only do this if the corresponding upgrade is not yet researched
        -- Barrage - Siege Engines
        if (not GetPlayerTechResearched(Player(index), FourCC('Rhrt'), true)) then
            SetPlayerTechMaxAllowed(Player(index), FourCC('hrtt'), 0)
        end

        -- Berserker Upgrade - Troll Berserkers
        if (not GetPlayerTechResearched(Player(index), FourCC('Robk'), true)) then
            SetPlayerTechMaxAllowed(Player(index), FourCC('otbk'), 0)
        end

        -- max skeletons per player
        SetPlayerTechMaxAllowed(Player(index), FourCC('uske'), bj_MAX_SKELETONS)

        index = index + 1
    until index == bj_MAX_PLAYERS
end

--===========================================================================
-- Update the per-class stock limits.
--
---@type fun(whichItem: item)
function UpdateStockAvailability(whichItem)
    local iType           = GetItemType(whichItem) ---@type itemtype 
    local iLevel          = GetItemLevel(whichItem) ---@type integer 

    -- Update allowed type/level combinations.
    if (iType == ITEM_TYPE_PERMANENT) then
        bj_stockAllowedPermanent[iLevel] = true
    elseif (iType == ITEM_TYPE_CHARGED) then
        bj_stockAllowedCharged[iLevel] = true
    elseif (iType == ITEM_TYPE_ARTIFACT) then
        bj_stockAllowedArtifact[iLevel] = true
    else
        -- Not interested in this item type - ignore the item.
    end
end

--===========================================================================
-- Find a sellable item of the given type and level, and then add it.
--
function UpdateEachStockBuildingEnum()
    local iteration         = 0 ---@type integer 
    local pickedItemId ---@type integer 

    while true do
        pickedItemId = ChooseRandomItemEx(bj_stockPickedItemType, bj_stockPickedItemLevel)
        if IsItemIdSellable(pickedItemId) then break end

        -- If we get hung up on an entire class/level combo of unsellable
        -- items, or a very unlucky series of random numbers, give up.
        iteration = iteration + 1
        if (iteration > bj_STOCK_MAX_ITERATIONS) then
            return
        end
    end
    AddItemToStock(GetEnumUnit(), pickedItemId, 1, 1)
end

--===========================================================================
---@type fun(iType: itemtype, iLevel: integer)
function UpdateEachStockBuilding(iType, iLevel)
    local g ---@type group 

    bj_stockPickedItemType = iType
    bj_stockPickedItemLevel = iLevel

    g = CreateGroup()
    GroupEnumUnitsOfType(g, "marketplace", nil)
    ForGroup(g, UpdateEachStockBuildingEnum)
    DestroyGroup(g)
end

--===========================================================================
-- Update stock inventory.
--
function PerformStockUpdates()
    local pickedItemId ---@type integer 
    local pickedItemType ---@type itemtype 
    local pickedItemLevel          = 0 ---@type integer 
    local allowedCombinations          = 0 ---@type integer 
    local iLevel ---@type integer 

    -- Give each type/level combination a chance of being picked.
    iLevel = 1
    repeat
        if (bj_stockAllowedPermanent[iLevel]) then
            allowedCombinations = allowedCombinations + 1
            if (GetRandomInt(1, allowedCombinations) == 1) then
                pickedItemType = ITEM_TYPE_PERMANENT
                pickedItemLevel = iLevel
            end
        end
        if (bj_stockAllowedCharged[iLevel]) then
            allowedCombinations = allowedCombinations + 1
            if (GetRandomInt(1, allowedCombinations) == 1) then
                pickedItemType = ITEM_TYPE_CHARGED
                pickedItemLevel = iLevel
            end
        end
        if (bj_stockAllowedArtifact[iLevel]) then
            allowedCombinations = allowedCombinations + 1
            if (GetRandomInt(1, allowedCombinations) == 1) then
                pickedItemType = ITEM_TYPE_ARTIFACT
                pickedItemLevel = iLevel
            end
        end

        iLevel = iLevel + 1
    until iLevel > bj_MAX_ITEM_LEVEL

    -- Make sure we found a valid item type to add.
    if (allowedCombinations == 0) then
        return
    end

    UpdateEachStockBuilding(pickedItemType, pickedItemLevel)
end

--===========================================================================
-- Perform the first update, and then arrange future updates.
--
function StartStockUpdates()
    PerformStockUpdates()
    TimerStart(bj_stockUpdateTimer, bj_STOCK_RESTOCK_INTERVAL, true, PerformStockUpdates)
end

--===========================================================================
function RemovePurchasedItem()
    RemoveItemFromStock(GetSellingUnit(), GetItemTypeId(GetSoldItem()))
end

--===========================================================================
function InitNeutralBuildings()
    local iLevel ---@type integer 

    -- Chart of allowed stock items.
    iLevel = 0
    repeat
        bj_stockAllowedPermanent[iLevel] = false
        bj_stockAllowedCharged[iLevel] = false
        bj_stockAllowedArtifact[iLevel] = false
        iLevel = iLevel + 1
    until iLevel > bj_MAX_ITEM_LEVEL

    -- Limit stock inventory slots.
    SetAllItemTypeSlots(bj_MAX_STOCK_ITEM_SLOTS)
    SetAllUnitTypeSlots(bj_MAX_STOCK_UNIT_SLOTS)

    -- Arrange the first update.
    bj_stockUpdateTimer = CreateTimer()
    TimerStart(bj_stockUpdateTimer, bj_STOCK_RESTOCK_INITIAL_DELAY, false, StartStockUpdates)

    -- Set up a trigger to fire whenever an item is sold.
    bj_stockItemPurchased = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(bj_stockItemPurchased, Player(PLAYER_NEUTRAL_PASSIVE), EVENT_PLAYER_UNIT_SELL_ITEM, nil)
    TriggerAddAction(bj_stockItemPurchased, RemovePurchasedItem)
end

--===========================================================================
function MarkGameStarted()
    bj_gameStarted = true
    DestroyTimer(bj_gameStartedTimer)
end

--===========================================================================
function DetectGameStarted()
    bj_gameStartedTimer = CreateTimer()
    TimerStart(bj_gameStartedTimer, bj_GAME_STARTED_THRESHOLD, false, MarkGameStarted)
end

--===========================================================================
function InitBlizzard()
    -- Set up the Neutral Victim player slot, to torture the abandoned units
    -- of defeated players.  Since some triggers expect this player slot to
    -- exist, this is performed for all maps.
    ConfigureNeutralVictim()

    InitBlizzardGlobals()
    InitQueuedTriggers()
    InitRescuableBehaviorBJ()
    InitDNCSounds()
    InitMapRects()
    InitSummonableCaps()
    InitNeutralBuildings()
    DetectGameStarted()
end



--***************************************************************************
--*
--*  Random distribution
--*
--*  Used to select a random object from a given distribution of chances
--*
--*  - RandomDistReset clears the distribution list
--*
--*  - RandomDistAddItem adds a new object to the distribution list
--*    with a given identifier and an integer chance to be chosen
--*
--*  - RandomDistChoose will use the current distribution list to choose
--*    one of the objects randomly based on the chance distribution
--*  
--*  Note that the chances are effectively normalized by their sum,
--*  so only the relative values of each chance are important
--*
--***************************************************************************

--===========================================================================
function RandomDistReset()
    bj_randDistCount = 0
end

--===========================================================================
---@type fun(inID: integer, inChance: integer)
function RandomDistAddItem(inID, inChance)
    bj_randDistID[bj_randDistCount] = inID
    bj_randDistChance[bj_randDistCount] = inChance
    bj_randDistCount = bj_randDistCount + 1
end

--===========================================================================
---@type fun():integer
function RandomDistChoose()
    local sum         = 0 ---@type integer 
    local chance         = 0 ---@type integer 
    local index ---@type integer 
    local foundID         = -1 ---@type integer 
    local done ---@type boolean 

    -- No items?
    if (bj_randDistCount == 0) then
        return -1
    end

    -- Find sum of all chances
    index = 0
    repeat
        sum = sum + bj_randDistChance[index]

        index = index + 1
    until index == bj_randDistCount

    -- Choose random number within the total range
    chance = GetRandomInt(1, sum)

    -- Find ID which corresponds to this chance
    index = 0
    sum = 0
    done = false
    repeat
        sum = sum + bj_randDistChance[index]

        if (chance <= sum) then
            foundID = bj_randDistID[index]
            done = true
        end

        index = index + 1
        if (index == bj_randDistCount) then
            done = true
        end

    until done == true

    return foundID
end



--***************************************************************************
--*
--*  Drop item
--*
--*  Makes the given unit drop the given item
--*
--*  Note: This could potentially cause problems if the unit is standing
--*        right on the edge of an unpathable area and happens to drop the
--*        item into the unpathable area where nobody can get it...
--*
--***************************************************************************

---@type fun(inUnit: unit, inItemID: integer):item
function UnitDropItem(inUnit, inItemID)
    local x ---@type number 
    local y ---@type number 
    local radius      = 32 ---@type number 
    local unitX ---@type number 
    local unitY ---@type number 
    local droppedItem ---@type item 

    if (inItemID == -1) then
        return nil
    end

    unitX = GetUnitX(inUnit)
    unitY = GetUnitY(inUnit)

    x = GetRandomReal(unitX - radius, unitX + radius)
    y = GetRandomReal(unitY - radius, unitY + radius)

    droppedItem = CreateItem(inItemID, x, y)

    SetItemDropID(droppedItem, GetUnitTypeId(inUnit))
    UpdateStockAvailability(droppedItem)

    return droppedItem
end

--===========================================================================
---@type fun(inWidget: widget, inItemID: integer):item
function WidgetDropItem(inWidget, inItemID)
    local x ---@type number 
    local y ---@type number 
    local radius      = 32 ---@type number 
    local widgetX ---@type number 
    local widgetY ---@type number 

    if (inItemID == -1) then
        return nil
    end

    widgetX = GetWidgetX(inWidget)
    widgetY = GetWidgetY(inWidget)

    x = GetRandomReal(widgetX - radius, widgetX + radius)
    y = GetRandomReal(widgetY - radius, widgetY + radius)

    return CreateItem(inItemID, x, y)
end


--***************************************************************************
--*
--*  Instanced Object Operation Functions
--*
--*  Get/Set specific fields for single unit/item/ability instance
--*
--***************************************************************************

--===========================================================================
---@type fun():boolean
function BlzIsLastInstanceObjectFunctionSuccessful()
    return bj_lastInstObjFuncSuccessful
end

-- Ability
--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitybooleanfield, value: boolean)
function BlzSetAbilityBooleanFieldBJ(whichAbility, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanField(whichAbility, whichField, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityintegerfield, value: integer)
function BlzSetAbilityIntegerFieldBJ(whichAbility, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerField(whichAbility, whichField, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityrealfield, value: number)
function BlzSetAbilityRealFieldBJ(whichAbility, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityRealField(whichAbility, whichField, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitystringfield, value: string)
function BlzSetAbilityStringFieldBJ(whichAbility, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityStringField(whichAbility, whichField, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitybooleanlevelfield, level: integer, value: boolean)
function BlzSetAbilityBooleanLevelFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanLevelField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityintegerlevelfield, level: integer, value: integer)
function BlzSetAbilityIntegerLevelFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerLevelField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityreallevelfield, level: integer, value: number)
function BlzSetAbilityRealLevelFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityRealLevelField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitystringlevelfield, level: integer, value: string)
function BlzSetAbilityStringLevelFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityStringLevelField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, index: integer, value: boolean)
function BlzSetAbilityBooleanLevelArrayFieldBJ(whichAbility, whichField, level, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanLevelArrayField(whichAbility, whichField, level, index, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, index: integer, value: integer)
function BlzSetAbilityIntegerLevelArrayFieldBJ(whichAbility, whichField, level, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerLevelArrayField(whichAbility, whichField, level, index, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, index: integer, value: number)
function BlzSetAbilityRealLevelArrayFieldBJ(whichAbility, whichField, level, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityRealLevelArrayField(whichAbility, whichField, level, index, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, index: integer, value: string)
function BlzSetAbilityStringLevelArrayFieldBJ(whichAbility, whichField, level, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetAbilityStringLevelArrayField(whichAbility, whichField, level, index, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, value: boolean)
function BlzAddAbilityBooleanLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzAddAbilityBooleanLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, value: integer)
function BlzAddAbilityIntegerLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzAddAbilityIntegerLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, value: number)
function BlzAddAbilityRealLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzAddAbilityRealLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, value: string)
function BlzAddAbilityStringLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzAddAbilityStringLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitybooleanlevelarrayfield, level: integer, value: boolean)
function BlzRemoveAbilityBooleanLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzRemoveAbilityBooleanLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityintegerlevelarrayfield, level: integer, value: integer)
function BlzRemoveAbilityIntegerLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzRemoveAbilityIntegerLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilityreallevelarrayfield, level: integer, value: number)
function BlzRemoveAbilityRealLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzRemoveAbilityRealLevelArrayField(whichAbility, whichField, level, value)
end

--===========================================================================
---@type fun(whichAbility: ability, whichField: abilitystringlevelarrayfield, level: integer, value: string)
function BlzRemoveAbilityStringLevelArrayFieldBJ(whichAbility, whichField, level, value)
    bj_lastInstObjFuncSuccessful = BlzRemoveAbilityStringLevelArrayField(whichAbility, whichField, level, value)
end

-- Item 
--=============================================================
---@type fun(whichItem: item, abilCode: integer)
function BlzItemAddAbilityBJ(whichItem, abilCode)
    bj_lastInstObjFuncSuccessful = BlzItemAddAbility(whichItem, abilCode)
end

--===========================================================================
---@type fun(whichItem: item, abilCode: integer)
function BlzItemRemoveAbilityBJ(whichItem, abilCode)
    bj_lastInstObjFuncSuccessful = BlzItemRemoveAbility(whichItem, abilCode)
end

--===========================================================================
---@type fun(whichItem: item, whichField: itembooleanfield, value: boolean)
function BlzSetItemBooleanFieldBJ(whichItem, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetItemBooleanField(whichItem, whichField, value)
end

--===========================================================================
---@type fun(whichItem: item, whichField: itemintegerfield, value: integer)
function BlzSetItemIntegerFieldBJ(whichItem, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetItemIntegerField(whichItem, whichField, value)
end

--===========================================================================
---@type fun(whichItem: item, whichField: itemrealfield, value: number)
function BlzSetItemRealFieldBJ(whichItem, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetItemRealField(whichItem, whichField, value)
end

--===========================================================================
---@type fun(whichItem: item, whichField: itemstringfield, value: string)
function BlzSetItemStringFieldBJ(whichItem, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetItemStringField(whichItem, whichField, value)
end


-- Unit 
--===========================================================================
---@type fun(whichUnit: unit, whichField: unitbooleanfield, value: boolean)
function BlzSetUnitBooleanFieldBJ(whichUnit, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitBooleanField(whichUnit, whichField, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitintegerfield, value: integer)
function BlzSetUnitIntegerFieldBJ(whichUnit, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitIntegerField(whichUnit, whichField, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitrealfield, value: number)
function BlzSetUnitRealFieldBJ(whichUnit, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitRealField(whichUnit, whichField, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitstringfield, value: string)
function BlzSetUnitStringFieldBJ(whichUnit, whichField, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitStringField(whichUnit, whichField, value)
end

-- Unit Weapon
--===========================================================================
---@type fun(whichUnit: unit, whichField: unitweaponbooleanfield, index: integer, value: boolean)
function BlzSetUnitWeaponBooleanFieldBJ(whichUnit, whichField, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponBooleanField(whichUnit, whichField, index, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitweaponintegerfield, index: integer, value: integer)
function BlzSetUnitWeaponIntegerFieldBJ(whichUnit, whichField, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponIntegerField(whichUnit, whichField, index, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitweaponrealfield, index: integer, value: number)
function BlzSetUnitWeaponRealFieldBJ(whichUnit, whichField, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponRealField(whichUnit, whichField, index, value)
end

--===========================================================================
---@type fun(whichUnit: unit, whichField: unitweaponstringfield, index: integer, value: string)
function BlzSetUnitWeaponStringFieldBJ(whichUnit, whichField, index, value)
    bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponStringField(whichUnit, whichField, index, value)
end