Debug.beginFile("Environment")
-- Abstraction of the place a digimon is staying
OnInit("Environment", function ()
    Require "FrameEffects"
    Require "FrameLoader"
    Require "SaveHelper"
    Require "EventListener"
    Require "GetSyncedData"
    Require "Hotkeys"

    local MAX_REGIONS = 30

    local SeeMap = nil ---@type framehandle
    local BackdropSeeMap = nil ---@type framehandle
    local MapBackdrop = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local Sprite = nil ---@type framehandle
    local DigimonIcons = {} ---@type framehandle[]

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

    local MAX_DIST = 0.08

    ---@param quantity integer
    ---@param dist number
    ---@param center location
    ---@return number[] xVals, number[] yVals
    local function createDistribution(quantity, dist, center)
        if quantity == 0 then
            error("You are distributing 0 elements")
        end

        local xVals = __jarray(0)
        local yVals = __jarray(0)

        if quantity == 1 then
            table.insert(xVals, GetLocationX(center))
            table.insert(yVals, GetLocationY(center))
            return xVals, yVals
        end

        local rows = __jarray(0)
        local maxSize = math.floor(MAX_DIST/dist) + 1

        local remain = quantity

        rows[0] = 1
        remain = remain - 1

        -- Create the distribution

        local rowsNumber = 0

        while remain > 0 do
            if rows[0] < maxSize then
                local isSpace = false
                for i = 0, rowsNumber - 1 do
                    local nextRow = i+1
                    if rows[nextRow] < rows[i] - nextRow then
                        isSpace = true
                        rows[nextRow] = rows[nextRow] + 1
                        remain = remain - 1
                        break
                    elseif rows[-nextRow] < rows[i] - nextRow then
                        isSpace = true
                        rows[-nextRow] = rows[-nextRow] + 1
                        remain = remain - 1
                        break
                    end
                end
                if not isSpace then
                    if rows[rowsNumber + 1] < rows[rowsNumber] - (rowsNumber + 1) then
                        rowsNumber = rowsNumber + 1
                    else
                        rows[0] = rows[0] + 1
                        remain = remain - 1
                    end
                end
            else
                for i = 1, rowsNumber do
                    if rows[i] < rows[i-1] then
                        rows[i] = rows[i] + 1
                        remain = remain - 1
                    elseif rows[-i] < rows[i+1] then
                        rows[-i] = rows[-i] + 1
                        remain = remain - 1
                    else
                        rowsNumber = rowsNumber + 1
                    end
                end
            end
        end

        -- Place the locations

        for row = rowsNumber, -rowsNumber, -1 do
            local size = rows[row]
            if size ~= 0 then
                local width = (size - 1) / 2
                local j = -width - 1.
                while j < width do
                    j = j + 1.
                    table.insert(xVals, dist * j + GetLocationX(center))
                    table.insert(yVals, dist * row + GetLocationY(center))
                end
            end
        end

        return xVals, yVals
    end

    Timed.echo(0.02, function ()
        if inMenu then
            CameraSetupApplyForceDuration(camera, false, 0)
        end
    end)

    Timed.echo(1., function ()
        if inMenu then
            for i = 1, udg_MAX_USED_DIGIMONS do
                BlzFrameSetVisible(DigimonIcons[i], false)
            end

            local list = GetUsedDigimons(LocalPlayer)
            local groups = SyncedTable.create() ---@type table<location, Digimon[]>

            for i = 1, #list do
                local pos = list[i].environment.iconPos
                if pos then
                    groups[pos] = groups[pos] or {}
                    table.insert(groups[pos], list[i])
                end
            end

            local j = 0
            for pos, digimons in pairs(groups) do
                local xVals, yVals = createDistribution(#digimons, 0.02, pos)
                for i = 1, #digimons do
                    j = j + 1
                    BlzFrameSetAbsPoint(DigimonIcons[j], FRAMEPOINT_CENTER, xVals[i], yVals[i])
                    BlzFrameSetTexture(DigimonIcons[j], BlzGetAbilityIcon(digimons[i]:getTypeId()), 0, true)
                    BlzFrameSetVisible(DigimonIcons[j], true)
                end
            end
        end
    end)

    ---@class Environment
    ---@field name string
    ---@field displayName string
    ---@field minimap string
    ---@field place rect
    ---@field mapPortion framehandle?
    ---@field iconPos location?
    ---@field id integer?
    ---@field soundtrackDay string?
    ---@field soundtrackNight string?
    ---@field sky string
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
    ---@param displayName string?
    ---@param place rect
    ---@param minimap string
    ---@param mapPortion string?
    ---@param glowOffset location?
    ---@param id integer
    ---@param soundtrackDay string?
    ---@param soundtrackNight string?
    ---@param sky string
    ---@return Environment
    function Environment.create(name, displayName, place, minimap, mapPortion, glowOffset, id, soundtrackDay, soundtrackNight, sky)
        if not used[name] then
            local self = setmetatable({}, Environment)

            self.name = name
            self.displayName = displayName or name
            self.place = place
            self.minimap = minimap
            self.soundtrackDay = soundtrackDay
            self.soundtrackNight = soundtrackNight
            self.sky = sky

            if glowOffset then
                for _, env in pairs(used) do
                    if env.iconPos then
                        if DistanceBetweenPoints(env.iconPos, glowOffset) < 0.01 then
                            self.iconPos = env.iconPos
                            break
                        end
                    end
                end
                if self.iconPos then
                    RemoveLocation(glowOffset)
                else
                    self.iconPos = glowOffset
                end
            end

            if mapPortion then
                FrameLoaderAdd(function ()
                    if not mapPortions[mapPortion] then
                        self.mapPortion = BlzCreateFrameByType("BACKDROP", "BACKDROP", MapBackdrop, "", 1)
                        BlzFrameSetPoint(self.mapPortion, FRAMEPOINT_TOPLEFT, MapBackdrop, FRAMEPOINT_TOPLEFT, 0.10000, 0.0000)
                        BlzFrameSetPoint(self.mapPortion, FRAMEPOINT_BOTTOMRIGHT, MapBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.0000)
                        BlzFrameSetTexture(self.mapPortion, mapPortion, 0, true)
                        BlzFrameSetVisible(self.mapPortion, false)

                        mapPortions[mapPortion] = self

                        self.id = id

                        if canBeVisted[id] then
                            error("You are re-using the id: " .. id .. " in " .. name)
                        end
                        canBeVisted[id] = self.mapPortion
                    else
                        self.mapPortion = mapPortions[mapPortion].mapPortion
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
            if env.displayName ~= "" then
                FrameFadeOut(TopMsg, 1., p)
            end
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
            for i = 1, udg_MAX_USED_DIGIMONS do
                BlzFrameSetVisible(DigimonIcons[i], false)
            end
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
        SetFrameHotkey(SeeMap, "V")
        AddDefaultTooltip(SeeMap, "See the map", "Look at the places you visited.")
        BlzFrameSetVisible(SeeMap, false)

        BackdropSeeMap = BlzCreateFrameByType("BACKDROP", "BackdropSeeMap", SeeMap, "", 0)
        BlzFrameSetAllPoints(BackdropSeeMap, SeeMap)
        BlzFrameSetTexture(BackdropSeeMap, "ReplaceableTextures\\CommandButtons\\BTNMap.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SeeMap, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SeeMapFunc)

        Sprite = BlzCreateFrameByType("SPRITE", "Sprite", SeeMap, "", 0)
        BlzFrameSetModel(Sprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameClearAllPoints(Sprite)
        BlzFrameSetPoint(Sprite, FRAMEPOINT_BOTTOMLEFT, SeeMap, FRAMEPOINT_BOTTOMLEFT, -0.00125, -0.00375)
        BlzFrameSetSize(Sprite, 0.00001, 0.00001)
        BlzFrameSetScale(Sprite, 1.25)
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

        for i = 1, udg_MAX_USED_DIGIMONS do
            DigimonIcons[i] = BlzCreateFrameByType("BACKDROP", "DigimonIcons[" .. i .. "]", MapBackdrop, "", 1)
            BlzFrameSetTexture(DigimonIcons[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            BlzFrameSetLevel(DigimonIcons[i], 10)
            BlzFrameSetVisible(DigimonIcons[i], false)
            BlzFrameSetSize(DigimonIcons[i], 0.02, 0.02)
        end
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
            udg_MapPortion,
            udg_MapPortionGlowOffset,
            udg_MapId,
            udg_SoundtrackDay,
            udg_SoundtrackNight,
            udg_Sky
        )

        udg_Name = ""
        udg_DisplayName = nil
        udg_Place = nil
        udg_Minimap = ""
        udg_MapPortion = nil
        udg_MapPortionGlowOffset = nil
        udg_MapId = nil
        udg_SoundtrackDay = nil
        udg_SoundtrackNight = nil
        udg_Sky = ""
    end)

end)
Debug.endFile()