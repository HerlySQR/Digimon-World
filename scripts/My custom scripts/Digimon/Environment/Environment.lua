Debug.beginFile("Environment")
-- Abstraction of the place a digimon is staying
OnInit("Environment", function ()
    Require "FrameEffects"
    Require "FrameLoader"
    Require "SaveHelper"
    Require "EventListener"
    Require "GetSyncedData"

    local MAX_REGIONS = 30

    local SeeMap = nil ---@type framehandle
    local BackdropSeeMap = nil ---@type framehandle
    local MapBackdrop = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local Sprite = nil ---@type framehandle

    local LocalPlayer = GetLocalPlayer()
    local TopMsg = nil ---@type framehandle
    local camera = gg_cam_SeeTheMap ---@type camerasetup
    local inMenu = false
    local onSeeMapClicked = EventListener.create()
    local onSeeMapClosed = EventListener.create()
    local notChangeMusic = false

    local mapPortions = {} ---@type table<string, Environment>
    local vistedPlaces = {} ---@type table<player, table<integer, framehandle>>
    local canBeVisted = {} ---@type table<integer, framehandle>

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        vistedPlaces[Player(i)] = {}
    end

    Timed.echo(0.02, function ()
        if inMenu then
            CameraSetupApplyForceDuration(camera, false, 0)
        end
    end)

    ---@class Environment
    ---@field name string
    ---@field minimap string
    ---@field place rect
    ---@field mapPortion framehandle?
    ---@field mapPortionGlow framehandle?
    ---@field id integer?
    ---@field soundtrackDay string?
    ---@field soundtrackNight string?
    Environment = {}
    Environment.__index = Environment

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
    ---@param place rect
    ---@param minimap string
    ---@param mapPortion string?
    ---@param glowOffset location
    ---@param id integer
    ---@param soundtrackDay string?
    ---@param soundtrackNight string?
    ---@return Environment
    function Environment.create(name, place, minimap, mapPortion, glowOffset, id, soundtrackDay, soundtrackNight)
        if not used[name] then
            local self = setmetatable({}, Environment)

            self.name = name
            self.place = place
            self.minimap = minimap
            self.soundtrackDay = soundtrackDay
            self.soundtrackNight = soundtrackNight

            if mapPortion then
                FrameLoaderAdd(function ()
                    if not mapPortions[mapPortion] then
                        self.mapPortion = BlzCreateFrameByType("BACKDROP", "BACKDROP", MapBackdrop, "", 1)
                        BlzFrameSetPoint(self.mapPortion, FRAMEPOINT_TOPLEFT, MapBackdrop, FRAMEPOINT_TOPLEFT, 0.10000, 0.0000)
                        BlzFrameSetPoint(self.mapPortion, FRAMEPOINT_BOTTOMRIGHT, MapBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.0000)
                        BlzFrameSetTexture(self.mapPortion, mapPortion, 0, true)
                        BlzFrameSetVisible(self.mapPortion, false)

                        self.mapPortionGlow = BlzCreateFrameByType("BACKDROP", "BACKDROP", self.mapPortion, "", 1)
                        BlzFrameSetPoint(self.mapPortionGlow, FRAMEPOINT_CENTER, self.mapPortion, FRAMEPOINT_TOPLEFT, GetLocationX(glowOffset), GetLocationY(glowOffset))
                        BlzFrameSetSize(self.mapPortionGlow, 0.125, 0.15)
                        BlzFrameSetTexture(self.mapPortionGlow, "ReplaceableTextures\\Selection\\SelectionCircleLarge.blp", 0, true)
                        BlzFrameSetVisible(self.mapPortionGlow, false)

                        RemoveLocation(glowOffset)

                        mapPortions[mapPortion] = self

                        self.id = id

                        if canBeVisted[id] then
                            error("You are re-using the id: " .. id .. " in " .. name)
                        end
                        canBeVisted[id] = self.mapPortion
                    else
                        self.mapPortion = mapPortions[mapPortion].mapPortion
                        self.mapPortionGlow = mapPortions[mapPortion].mapPortionGlow
                        self.id = mapPortions[mapPortion].id
                    end
                end)
            end

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

        BlzFrameSetVisible(TopMsg, true)
        BlzFrameSetText(TopMsg, "|cffffff00[" .. env.name .. "]|r")
        BlzFrameSetAlpha(TopMsg, 255)
        -- Prevent bad camera bounds if the player has the camera rotated
        local rotation = GetCameraField(CAMERA_FIELD_ROTATION)*bj_RADTODEG
        SetCameraField(CAMERA_FIELD_ROTATION, 90, 0)
        SetCameraBounds(FixedCameraBounds(env.place))
        SetCameraField(CAMERA_FIELD_ROTATION, rotation, 0)

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
        if p == LocalPlayer and env ~= Environment.map and prevEnv[p] and prevEnv[p].mapPortion then
            BlzFrameSetVisible(prevEnv[p].mapPortionGlow, false)
        end

        prevEnv[p] = env

        if p == LocalPlayer then
            if not notChangeMusic then
                ClearMapMusic()
            end
            if GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK then
                if env.soundtrackDay ~= "inherit" then
                    if actMusic ~= env.soundtrackDay then
                        actMusic = env.soundtrackDay
                        if not notChangeMusic then
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
            FrameFadeOut(TopMsg, 1., p)
        end)

        Environments[p] = env
        if not _spect and env.mapPortion then
            if p == LocalPlayer then
                BlzFrameSetVisible(env.mapPortionGlow, true)
            end
            if not vistedPlaces[p][env.id] then
                vistedPlaces[p][env.id] = env.mapPortion
                if p == LocalPlayer then
                    BlzFrameSetVisible(Sprite, true)
                    BlzFrameSetSpriteAnimate(Sprite, 1, 0)
                    BlzFrameSetVisible(env.mapPortion, true)
                end
                Timed.call(8., function ()
                    if p == LocalPlayer then
                        BlzFrameSetVisible(Sprite, false)
                    end
                end)
            end
        end

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

    local function SeeMapFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            SaveCameraSetup()
        end
        local oldEnv = Environments[p]
        Environment.map:apply(p)
        LockEnvironment(p, true)
        oldEnv:apply(p)
        SaveSelectedUnits(p)
        if p == LocalPlayer then
            AddButtonToEscStack(Exit)
            HideMenu(true)
            BlzFrameSetVisible(MapBackdrop, true)
            inMenu = true
        end
        onSeeMapClicked:run(p)
    end

    local function ExitFunc()
        local p = GetTriggerPlayer()
        LockEnvironment(p, false)
        if p == LocalPlayer then
            RemoveButtonFromEscStack(Exit)
            ShowMenu(true)
            BlzFrameSetVisible(MapBackdrop, false)
            RestartToPreviousCamera()
            inMenu = false
        end
        RestartSelectedUnits(p)
        onSeeMapClosed:run(p)
    end

    local function InitFrames()
        local t

        TopMsg = BlzCreateFrameByType("TEXT", "name", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetPoint(TopMsg, FRAMEPOINT_TOPLEFT, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0), FRAMEPOINT_TOPLEFT, 0, -0.00625)
        BlzFrameSetPoint(TopMsg, FRAMEPOINT_BOTTOMRIGHT, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0), FRAMEPOINT_BOTTOMRIGHT, 0, -0.00625)
        BlzFrameSetText(TopMsg, "")
        BlzFrameSetScale(TopMsg, 2.)
        BlzFrameSetTextAlignment(TopMsg, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetAlpha(TopMsg, 0)

        SeeMap = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(SeeMap, 7)
        AddFrameToMenu(SeeMap)
        AddDefaultTooltip(SeeMap, "See the map", "Look at the places you visited.")
        BlzFrameSetVisible(SeeMap, false)

        BackdropSeeMap = BlzCreateFrameByType("BACKDROP", "BackdropSeeMap", SeeMap, "", 0)
        BlzFrameSetAllPoints(BackdropSeeMap, SeeMap)
        BlzFrameSetTexture(BackdropSeeMap, "ReplaceableTextures\\CommandButtons\\BTNMap.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SeeMap, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SeeMapFunc)

        Sprite = BlzCreateFrameByType("SPRITE", "Sprite", SeeMap, "", 0)
        BlzFrameSetAllPoints(Sprite, SeeMap)
        BlzFrameSetModel(Sprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameSetScale(Sprite, BlzFrameGetWidth(Sprite)/0.039)
        BlzFrameSetVisible(Sprite, false)

        MapBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
        BlzFrameSetAbsPoint(MapBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.600000)
        BlzFrameSetAbsPoint(MapBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.00000)
        BlzFrameSetTexture(MapBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(MapBackdrop, false)

        Exit = BlzCreateFrame("ScriptDialogButton", MapBackdrop, 0, 0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, MapBackdrop, FRAMEPOINT_TOPLEFT, 0.71000, -0.030000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, MapBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.54000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetScale(Exit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)
    end

    FrameLoaderAdd(InitFrames)

    ---@param p player
    ---@param flag boolean
    function ShowMapButton(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SeeMap, flag)
        end
    end

    ---@param p player
    ---@return boolean[]
    function GetVisitedPlaces(p)
        local list = {}
        for i = 1, MAX_REGIONS do
            list[i] = vistedPlaces[p][i] ~= nil
        end
        return list
    end

    ---@param p player
    ---@param list boolean[]
    function ApplyVisitedPlaces(p, list)
        for i = 1, MAX_REGIONS do
            if list[i] then
                vistedPlaces[p][i] = canBeVisted[i]
                BlzFrameSetVisible(canBeVisted[i], true)
            else
                BlzFrameSetVisible(canBeVisted[i], false)
            end
        end
    end

    ---@param func fun(p: player)
    function OnSeeMapClicked(func)
        onSeeMapClicked:register(func)
    end

    ---@param func fun(p: player)
    function OnSeeMapClosed(func)
        onSeeMapClosed:register(func)
    end

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

    Environment.allMap = Environment.create("", bj_mapInitialPlayableArea, "entireMap.tga")
    BlzChangeMinimapTerrainTex("entireMap.tga")

    -- Just to be detected by the extension
    Environment.jijimon = nil ---@type Environment
    Environment.initial = nil ---@type Environment
    Environment.hospital = nil ---@type Environment
    Environment.gymLobby = nil ---@type Environment
    Environment.gymArena = {} ---@type Environment[]
    Environment.cosmeticModel = nil ---@type Environment
    Environment.map = nil ---@type Environment

    udg_MapPortion = nil
    udg_MapPortionGlowOffset = nil
    udg_MapId = nil
    udg_SoundtrackDay = nil
    udg_SoundtrackNight = nil

    udg_EnvironmentCreate = CreateTrigger()
    TriggerAddAction(udg_EnvironmentCreate, function ()
        LastCreatedEnvironment = Environment.create(
            udg_Name,
            udg_Place,
            udg_Minimap,
            udg_MapPortion,
            udg_MapPortionGlowOffset,
            udg_MapId,
            udg_SoundtrackDay,
            udg_SoundtrackNight
        )

        udg_Name = ""
        udg_Place = nil
        udg_Minimap = ""
        udg_MapPortion = nil
        udg_MapPortionGlowOffset = nil
        udg_MapId = nil
        udg_SoundtrackDay = nil
        udg_SoundtrackNight = nil
    end)

end)
Debug.endFile()