-- Abstraction of the place a digimon is staying
do
    local LocalPlayer = nil ---@type player

    ---@class Environment
    ---@field name string
    ---@field minimap string
    ---@field place rect
    Environment = {}
    Environment.__index = Environment

    local used = {}

    ---The camera bounds is not the same as the region that appears in the minimap
    ---@param place rect
    ---@return real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4
    local function FixedCameraBounds(place)
        local minX = GetRectMinX(place) + 512
        local maxX = GetRectMaxX(place) - 384
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

    local Enviroments = {} ---@type Environment[player]

    ---@param p player
    ---@return Environment
    function GetPlayerEnviroment(p)
        return Enviroments[p]
    end

    local InTranssition = __jarray(false) ---@type boolean[player]

    ---This function should be in a "if player == GetLocalPlayer() then" block
    ---@param env Environment
    local function internalApply(env)
        if InTranssition[LocalPlayer] then -- Prevents that the player changes enviroment when is transsitioning
            return
        end
        if env.name ~= "" then
            print("|cffffff00[" .. env.name .. "]|r")
        end
        SetCameraBounds(FixedCameraBounds(env.place))
        BlzChangeMinimapTerrainTex(env.minimap)
    end

    ---@param env Environment
    ---@param p player
    ---@param fade? boolean
    function Environment.apply(env, p, fade)
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
        Enviroments[p] = env
    end

    ---@param texture string
    ---@param duration real
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
    ---@param duration real
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

    OnGlobalInit(function ()
        LocalPlayer = GetLocalPlayer()

        Environment.allMap = Environment.create("", bj_mapInitialPlayableArea, "entireMap.tga")
        BlzChangeMinimapTerrainTex("entireMap.tga")

        -- Just to be detected by the extension
        Environment.jijimon = nil
        Environment.initial = nil
        Environment.hospital = nil
    end)

end