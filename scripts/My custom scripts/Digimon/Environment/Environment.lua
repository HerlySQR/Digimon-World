Debug.beginFile("Environment")
-- Abstraction of the place a digimon is staying
OnInit("Environment", function ()
    Require "FrameEffects"
    Require "FrameLoader"
    Require "SaveHelper"
    Require "EventListener"

    local MAX_REGIONS = 30

    local SeeMap = nil ---@type framehandle
    local BackdropSeeMap = nil ---@type framehandle
    local MapBackdrop = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local Sprite = nil ---@type framehandle

    local LocalPlayer = GetLocalPlayer()
    local TopMsg = nil ---@type framehandle
    local camera = gg_cam_SeeTheMap ---@type camerasetup
    local onSeeMapClicked = EventListener.create()
    local onSeeMapClosed = EventListener.create()

    local mapPortions = {} ---@type table<string, Environment>
    local vistedPlaces = {} ---@type table<player, table<integer, framehandle>>
    local canBeVisted = {} ---@type table<integer, framehandle>

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        vistedPlaces[Player(i)] = {}
    end

    ---@class Environment
    ---@field name string
    ---@field minimap string
    ---@field place rect
    ---@field mapPortion framehandle?
    ---@field mapPortionGlow framehandle?
    ---@field id integer?
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
    ---@return Environment
    function Environment.create(name, place, minimap, mapPortion, glowOffset, id)
        if not used[name] then
            local self = setmetatable({}, Environment)

            self.name = name
            self.place = place
            self.minimap = minimap

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
    ---@param expectator? boolean
    local function internalApply(env, expectator)
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

        if not expectator and env.mapPortion then
            BlzFrameSetVisible(env.mapPortion, true)
            BlzFrameSetVisible(env.mapPortionGlow, true)
        end
    end

    ---@param env Environment|string
    ---@param p player
    ---@param fade? boolean
    ---@param expectator? boolean
    ---@return boolean success
    function Environment.apply(env, p, fade, expectator)
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
                internalApply(env, expectator)
                FadeIn("ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0.25)
            end
        else
            if p == LocalPlayer then
                internalApply(env, expectator)
            end
        end

        Timed.call(4.25, function ()
            FrameFadeOut(TopMsg, 1., p)
        end)

        Environments[p] = env
        if not expectator and env.mapPortion then
            if not vistedPlaces[p][env.id] then
                vistedPlaces[p][env.id] = env.mapPortion
                if p == LocalPlayer then
                    BlzFrameSetVisible(Sprite, true)
                    BlzFrameSetSpriteAnimate(Sprite, 1, 0)
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
        local oldEnv = GetPlayerEnviroment(p)
        Environment.map:apply(p)
        LockEnvironment(p, true)
        oldEnv:apply(p)
        SaveSelectedUnits(p)
        if p == LocalPlayer then
            AddButtonToEscStack(Exit)
            HideMenu(true)
            BlzFrameSetVisible(MapBackdrop, true)
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
        end
        RestartSelectedUnits(p)
        onSeeMapClosed:run(p)
    end

    local function InitFrames()
        local t

        TopMsg = BlzCreateFrameByType("TEXT", "name", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetAllPoints(TopMsg, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0))
        BlzFrameSetText(TopMsg, "")
        BlzFrameSetScale(TopMsg, 2.)
        BlzFrameSetTextAlignment(TopMsg, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetAlpha(TopMsg, 0)

        SeeMap = BlzCreateFrame("IconButtonTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(SeeMap, FRAMEPOINT_TOPLEFT, 0.395000, 0.180000)
        BlzFrameSetAbsPoint(SeeMap, FRAMEPOINT_BOTTOMRIGHT, 0.430000, 0.145000)
        AddFrameToMenu(SeeMap)
        AddDefaultTooltip(SeeMap, "See the map", "Look at the places you visited.")
        BlzFrameSetVisible(SeeMap, false)

        BackdropSeeMap = BlzCreateFrameByType("BACKDROP", "BackdropSeeMap", SeeMap, "", 0)
        BlzFrameSetAllPoints(BackdropSeeMap, SeeMap)
        BlzFrameSetTexture(BackdropSeeMap, "ReplaceableTextures\\CommandButtons\\BTNSpy.blp", 0, true)
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
    ---@param slot integer
    ---@return boolean[]
    function SaveVisitedPlaces(p, slot)
        local list = __jarray(0)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\VistedPlaces\\Slot_" .. slot .. ".pld"
        local savecode = Savecode.create()

        for i = 1, MAX_REGIONS do
            if vistedPlaces[p][i] then
                savecode:Encode(1, 2) -- Save that id of the place is visted
                list[i] = true
            else
                savecode:Encode(0, 2) -- Save that id of the place is not visted
                list[i] = false
            end
        end

        local s = savecode:Save(p, 1)

        if p == LocalPlayer then
            FileIO.Write(path, s)
        end

        savecode:destroy()

        return list
    end

    ---@param p player
    ---@param slot integer
    ---@return boolean[]
    function LoadVisitedPlaces(p, slot)
        local list = __jarray(0)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\VistedPlaces\\Slot_" .. slot .. ".pld"
        local savecode = Savecode.create()
        if savecode:Load(p, GetSyncedData(p, FileIO.Read, path), 1) then
            for i = MAX_REGIONS, 1, -1 do
                list[i] = savecode:Decode(2) == 1 -- Load if id of the place is visted
            end
        end

        savecode:destroy()

        return list
    end

    ---@param p player
    ---@param list boolean[]
    function ApplyVisitedPlaces(p, list)
        for i = 1, MAX_REGIONS do
            if list[i] then
                vistedPlaces[p][i] = canBeVisted[i]
                BlzFrameSetVisible(canBeVisted[i], true)
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

end)
Debug.endFile()