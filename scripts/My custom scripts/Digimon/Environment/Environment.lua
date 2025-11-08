Debug.beginFile("Environment")
-- Abstraction of the place a digimon is staying
OnInit("Environment", function ()
    Require "FrameEffects"
    Require "FrameLoader"
    Require "SaveHelper"
    Require "EventListener"
    Require "GetSyncedData"
    Require "Hotkeys"

    local LocalPlayer = GetLocalPlayer()
    local TopMsg = nil ---@type framehandle
    local notChangeMusic = false

    ---@class Environment
    ---@field name string
    ---@field displayName string
    ---@field minimap string
    ---@field place rect
    ---@field iconPos location?
    ---@field soundtrackDay string?
    ---@field soundtrackNight string?
    ---@field sky string
    Environment = {}
    Environment.__index = Environment

    local onEnvApplied = {} ---@type table<string, EventListener>

    ---@param name string
    ---@param func fun(p: player)
    function OnEnvApplied(name, func)
        assert(onEnvApplied[name], "The env " .. name .. " doesn't have an event.")
        onEnvApplied[name]:register(func)
    end

    local used = {} ---@type table<string, Environment>

    ---The camera bounds is not the same as the region that appears in the minimap
    ---@param place rect
    ---@return number x1, number y1, number x2, number y2, number x3, number y3, number x4, number y4
    local function FixedCameraBounds(place)
        local minX = GetRectMinX(place) + 512
        local maxX = GetRectMaxX(place) - 512
        local minY = GetRectMinY(place) + 256
        local maxY = GetRectMaxY(place) - 256
        return minX, minY, minX, maxY, maxX, maxY, maxX, minY
    end

    ---@param name string
    ---@param displayName string?
    ---@param place rect
    ---@param minimap string
    ---@param soundtrackDay string?
    ---@param soundtrackNight string?
    ---@param sky string
    ---@return Environment
    function Environment.create(name, displayName, place, minimap, soundtrackDay, soundtrackNight, sky)
        if not used[name] then
            local self = setmetatable({}, Environment)

            self.name = name
            self.displayName = displayName or name
            self.place = place
            self.minimap = minimap
            self.soundtrackDay = soundtrackDay
            self.soundtrackNight = soundtrackNight
            self.sky = sky

            onEnvApplied[name] = EventListener.create()

            used[name] = self

            return self
        else
            return used[name]
        end
    end

    ---Returns the enviroment that has the specified name
    ---@param name string
    ---@return Environment
    function Environment.get(name)
        return used[name] or Environment.allMap
    end

    local Environments = {} ---@type table<player, Environment>
    local locked = {} ---@type table<player, boolean>
    local prevEnv = {} ---@type table<player, Environment>
    local actMusic = ""

    ---@param p player
    ---@return Environment
    function GetPlayerEnviroment(p)
        return Environments[p]
    end

    ---@param p player
    ---@param flag boolean
    function LockEnvironment(p, flag)
        locked[p] = flag
        if not flag then
            prevEnv[p]:apply(p)
        end
    end

    local InTranssition = __jarray(false) ---@type table<player, boolean>

    ---This function should be in a "if player == GetLocalPlayer() then" block
    ---@param env Environment
    local function internalApply(env)
        if InTranssition[LocalPlayer] then -- Prevents that the player changes enviroment when is transsitioning
            return
        end

        if env.displayName ~= "" then
            BlzFrameSetVisible(TopMsg, true)
            BlzFrameSetText(TopMsg, "|cffffff00[" .. env.displayName .. "]|r")
            BlzFrameSetAlpha(TopMsg, 255)
        end
        -- Prevent bad camera bounds if the player has the camera rotated
        local rotation = GetCameraField(CAMERA_FIELD_ROTATION)*bj_RADTODEG
        SetCameraField(CAMERA_FIELD_ROTATION, 90, 0)
        SetCameraBounds(FixedCameraBounds(env.place))
        SetCameraField(CAMERA_FIELD_ROTATION, rotation, 0)

        SetSkyModel(env.sky)

        BlzChangeMinimapTerrainTex(env.minimap)
    end

    ---@param env Environment|string
    ---@param p player
    ---@param fade? boolean
    ---@return boolean success
    function Environment.apply(env, p, fade, _spect)
        if type(env) == "string" then
            env = used[env]
        end
        if Environments[p] == env then
            return false
        end

        prevEnv[p] = env

        if p == LocalPlayer then
            if GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK then
                if env.soundtrackDay ~= "inherit" then
                    if actMusic ~= env.soundtrackDay then
                        actMusic = env.soundtrackDay
                        if not notChangeMusic then
                            ClearMapMusic()
                            StopMusic(false)
                            if actMusic then
                                PlayMusic(actMusic)
                            end
                        end
                    end
                end
            elseif GetTimeOfDay() < bj_TOD_DAWN or GetTimeOfDay() >= bj_TOD_DUSK then
                if env.soundtrackNight ~= "inherit" then
                    if actMusic ~= env.soundtrackNight then
                        actMusic = env.soundtrackNight
                        if not notChangeMusic then
                            ClearMapMusic()
                            StopMusic(false)
                            if actMusic then
                                PlayMusic(actMusic)
                            end
                        end
                    end
                end
            end
        end

        if locked[p] then
            return false
        end

        if fade then
            if p == LocalPlayer then
                FadeOut("ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0.25)
            end

            InTranssition[p] = true
            PolledWait(0.25)
            InTranssition[p] = false

            if p == LocalPlayer then
                internalApply(env)
                FadeIn("ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0.25)
            end
        else
            if p == LocalPlayer then
                internalApply(env)
            end
        end

        Timed.call(4.25, function ()
            if env.displayName ~= "" then
                FrameFadeOut(TopMsg, 1., p)
            end
        end)

        Environments[p] = env

        onEnvApplied[env.name]:run(p, _spect)

        return true
    end

    ---@param p player
    ---@param ally player
    function Environment.spect(p, ally)
        local pos = GetSyncedData(ally, locked[ally] and GetSavedCameraTarget or {GetCameraTargetPositionX, nil, GetCameraTargetPositionY});
        (locked[ally] and prevEnv[ally] or Environments[ally]):apply(p, true, true)
        if p == LocalPlayer then
            PanCameraToTimed(pos[1], pos[2], 0)
        end
    end

    do
        local t = CreateTrigger()
        TriggerRegisterGameStateEvent(t, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DAWN)
        TriggerAddAction(t, function ()
            if Environments[LocalPlayer] and Environments[LocalPlayer].soundtrackDay and (Environments[LocalPlayer].soundtrackDay ~= Environments[LocalPlayer].soundtrackNight) then
                actMusic = Environments[LocalPlayer].soundtrackDay
                if not notChangeMusic then
                    ClearMapMusic()
                    StopMusic(false)
                    PlayMusic(actMusic)
                end
            end
        end)

        t = CreateTrigger()
        TriggerRegisterGameStateEvent(t, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DUSK)
        TriggerAddAction(t, function ()
            if Environments[LocalPlayer] and Environments[LocalPlayer].soundtrackNight and (Environments[LocalPlayer].soundtrackNight ~= Environments[LocalPlayer].soundtrackDay) then
                actMusic = Environments[LocalPlayer].soundtrackNight
                if not notChangeMusic then
                    ClearMapMusic()
                    StopMusic(false)
                    PlayMusic(actMusic)
                end
            end
        end)
    end

    ---@param texture string
    ---@param duration number
    function FadeOut(texture, duration)
        SetCineFilterTexture(texture)
        SetCineFilterBlendMode(BLEND_MODE_BLEND)
        SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
        SetCineFilterStartUV(0, 0, 1, 1)
        SetCineFilterEndUV(0, 0, 1, 1)
        SetCineFilterStartColor(255, 255, 255, 0)
        SetCineFilterEndColor(255, 255, 255, 255)
        SetCineFilterDuration(duration)
        DisplayCineFilter(true)
    end

    ---@param texture string
    ---@param duration number
    function FadeIn(texture, duration)
        SetCineFilterTexture(texture)
        SetCineFilterBlendMode(BLEND_MODE_BLEND)
        SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
        SetCineFilterStartUV(0, 0, 1, 1)
        SetCineFilterEndUV(0, 0, 1, 1)
        SetCineFilterStartColor(255, 255, 255, 255)
        SetCineFilterEndColor(255, 255, 255, 0)
        SetCineFilterDuration(duration)
        DisplayCineFilter(true)
    end

    local function InitFrames()
        TopMsg = BlzCreateFrameByType("TEXT", "name", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetPoint(TopMsg, FRAMEPOINT_TOPLEFT, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0), FRAMEPOINT_TOPLEFT, 0, -0.00625)
        BlzFrameSetPoint(TopMsg, FRAMEPOINT_BOTTOMRIGHT, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0), FRAMEPOINT_BOTTOMRIGHT, 0, -0.00625)
        BlzFrameSetText(TopMsg, "")
        BlzFrameSetScale(TopMsg, 2.)
        BlzFrameSetTextAlignment(TopMsg, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetAlpha(TopMsg, 0)
    end

    FrameLoaderAdd(InitFrames)

    ---@param music string
    function ChangeMusic(music)
        notChangeMusic = true
        ClearMapMusic()
        PlayMusic(music)
    end

    function RestartMusic()
        notChangeMusic = false
        local env = prevEnv[LocalPlayer]
        ClearMapMusic()
        StopMusic(false)
        local sound
        if GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK then
            if env.soundtrackDay ~= "inherit" then
                sound = env.soundtrackDay
            else
                sound = actMusic
            end
        elseif GetTimeOfDay() < bj_TOD_DAWN or GetTimeOfDay() >= bj_TOD_DUSK then
            if env.soundtrackNight ~= "inherit" then
                sound = env.soundtrackNight
            else
                sound = actMusic
            end
        end
        if sound then
            PlayMusic(sound)
        end
    end

    Environment.allMap = Environment.create("", nil, bj_mapInitialPlayableArea, "entireMap.tga")
    BlzChangeMinimapTerrainTex("entireMap.tga")

    -- Just to be detected by the extension
    Environment.jijimon = nil ---@type Environment
    Environment.initial = nil ---@type Environment
    Environment.hospital = nil ---@type Environment
    Environment.gymLobby = nil ---@type Environment
    Environment.gymArena = {} ---@type Environment[]
    Environment.cosmeticModel = nil ---@type Environment
    Environment.map = nil ---@type Environment
    Environment.whamonAnimation = nil ---@type Environment
    Environment.birdramonAnimation = nil ---@type Environment
    Environment.drimogemonAnimation = nil ---@type Environment

    udg_DisplayName = nil
    udg_MapPortion = nil
    udg_MapPortionGlowOffset = nil
    udg_MapId = nil
    udg_SoundtrackDay = nil
    udg_SoundtrackNight = nil

    udg_EnvironmentCreate = CreateTrigger()
    TriggerAddAction(udg_EnvironmentCreate, function ()
        LastCreatedEnvironment = Environment.create(
            udg_Name,
            udg_DisplayName,
            udg_Place,
            udg_Minimap,
            udg_SoundtrackDay,
            udg_SoundtrackNight,
            udg_Sky
        )

        udg_Name = ""
        udg_DisplayName = nil
        udg_Place = nil
        udg_Minimap = ""
        udg_SoundtrackDay = nil
        udg_SoundtrackNight = nil
        udg_Sky = ""
    end)

end)
Debug.endFile()