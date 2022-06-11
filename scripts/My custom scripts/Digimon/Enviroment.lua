-- Abstraction of the place a digimon is staying
do
    ---@class Environment
    ---@field minimap string
    ---@field place rect
    Environment = {}
    Environment.__index = Environment

    local used = {}

    ---@param place rect
    ---@param minimap string
    ---@return Environment
    function Environment.create(place, minimap)
        if not used[place] then
            local self = setmetatable({}, Environment)

            self.place = place
            self.minimap = minimap

            used[place] = self

            return self
        else
            return used[place]
        end
    end

    ---@param env Environment
    function Environment.apply(env)
        SetCameraBoundsToRect(env.place)
        BlzChangeMinimapTerrainTex(env.minimap)
    end

    OnGlobalInit(function ()
        Environment.allMap = Environment.create(bj_mapInitialCameraBounds, "entireMap.tga")
        BlzChangeMinimapTerrainTex("entireMap.tga")

        -- Just to be detected by the extension
        Environment.initial = nil
        Environment.hospital = nil
    end)

end