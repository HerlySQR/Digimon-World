Debug.beginFile("Environment")
-- Abstraction of the place a digimon is staying
OnInit("Environment", function ()
    Require "FrameEffects"
    Require "FrameLoader"

    local LocalPlayer = GetLocalPlayer()
    local TopMsg = nil ---@type framehandle

    ---@class Environment
    ---@field name string
    ---@field minimap string
    ---@field place rect
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
    ---@return Environment
    function Environment.create(name, place, minimap)
        if not used[name] then
            local self = setmetatable({}, Environment)

            self.name = name
            self.place = place
            self.minimap = minimap

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

    ---@param p player
    ---@return Environment
    function GetPlayerEnviroment(p)
        return Environments[p]
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
    function Environment.apply(env, p, fade)
        if type(env) == "string" then
            env = used[env]
        end
        if Environments[p] == env then
            return
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
        BlzFrameSetAllPoints(TopMsg, BlzGetOriginFrame(ORIGIN_FRAME_TOP_MSG, 0))
        BlzFrameSetText(TopMsg, "")
        BlzFrameSetScale(TopMsg, 2.)
        BlzFrameSetTextAlignment(TopMsg, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetAlpha(TopMsg, 0)
    end

    FrameLoaderAdd(InitFrames)

    Environment.allMap = Environment.create("", bj_mapInitialPlayableArea, "entireMap.tga")
    BlzChangeMinimapTerrainTex("entireMap.tga")

    -- Just to be detected by the extension
    Environment.jijimon = nil ---@type Environment
    Environment.initial = nil ---@type Environment
    Environment.hospital = nil ---@type Environment
    Environment.gymLobby = nil ---@type Environment
    Environment.gymArena = {} ---@type Environment[]

end)
Debug.endFile()