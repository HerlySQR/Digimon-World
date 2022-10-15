OnLibraryInit({name = "CreepSpawn", "Timed", "LinkedList", "Set", "AbilityUtils", "Vec2"}, function ()
    local CREEPS_PER_PLAYER     ---@type integer
    local CREEPS_PER_REGION     ---@type integer
    local LIFE_SPAN             ---@type number
    local LIFE_REDUCED          ---@type number
    local DELAY_SPAWN           ---@type number
    local DELAY_NORMAL          ---@type number
    local DELAY_DEATH           ---@type number
    local RANGE_LEVEL_1         ---@type number
    local RANGE_LEVEL_2         ---@type number
    local RANGE_RETURN          ---@type number
    local RANGE_IN_HOME         ---@type number
    local NEIGHBOURHOOD         ---@type number
    local INTERVAL              ---@type number

    ---@class Creep : Digimon
    ---@field remaining number
    ---@field captured boolean
    ---@field reduced boolean
    ---@field returning boolean
    ---@field spawnpoint Vec2

    local function CreateCreep(unitid, pos)
        local creep = Digimon.create(Digimon.NEUTRAL, unitid, pos.x, pos.y, bj_UNIT_FACING) ---@type Creep

        creep.captured = false
        creep.reduced = false
        creep.returning = false
        creep.remaining = LIFE_SPAN
        creep.spawnpoint = pos

        return creep
    end

    -- The system

    local All = LinkedList.create()

    local function Create(x, y, types)
        local this = {
            spawnpoint = Vec2.new(x, y),

            types = types,
            inregion = false,

            delay = 0.,
            waitToSpawn = 0.,

            creeps = {},
            neighbourhood = Set.create()
        }

        All:insert(this)

        for node in All:loop() do
            local r = node.value
            if DistanceBetweenCoords(x, y, r.spawnpoint.x, r.spawnpoint.y) <= NEIGHBOURHOOD then
                this.neighbourhood:addSingle(r)
                r.neighbourhood:addSingle(this)
            end
        end

        return this
    end

    local list = nil

    ---Returns a random neighbour that didn't reach its limit and is not in cooldown, if there is not, then return nil
    local function GetFreeNeighbour(r, quantity)
        list = {}
        for n in r.neighbourhood:elements() do
            if #n.creeps < quantity and n.waitToSpawn <= 0. then
                table.insert(list, n)
            end
        end
        if #list > 0 then
            return list[math.random(#list)]
        end
    end

    local PlayersInRegion = Set.create()

    local function Update()
        for node in All:loop() do
            local regionData = node.value
            -- Check if the unit nearby the spawn region belongs to a player
            regionData.inregion = false
            ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_1, function (u)
                if GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
                    regionData.someoneClose = true
                    regionData.inregion = true
                    PlayersInRegion:addSingle(GetOwningPlayer(u))
                end
            end)
            -- Control the creep or the spawn
            if regionData.inregion then
                regionData.delay = regionData.delay - INTERVAL
                regionData.waitToSpawn = regionData.waitToSpawn - INTERVAL
                if regionData.delay <= 0. then
                    -- Spawn per neighbourhood instead per region
                    local r = GetFreeNeighbour(regionData, math.min(CREEPS_PER_REGION, CREEPS_PER_PLAYER * PlayersInRegion:size())) -- If don't have neighbours, then just use the same region
                    if r then
                        table.insert(r.creeps, CreateCreep(r.types[math.random(#r.types)], r.spawnpoint))
                        -- They share the same delay
                        for n in regionData.neighbourhood:elements() do
                            n.waitToSpawn = math.max(DELAY_SPAWN, n.waitToSpawn)
                        end
                    end
                end
            else
                -- Check if a unit is still nearby the spawn region
                regionData.someoneClose = false
                ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_2, function (u)
                    if not regionData.someoneClose and GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
                        regionData.someoneClose = true
                    end
                end)
                for _, creep in ipairs(regionData.creeps) do
                    creep.remaining = creep.remaining - INTERVAL

                    --If there is no nearby unit in the RANGE_LEVEL_2 then reduce once the duration
                    if not regionData.someoneClose and not creep.reduced then
                        creep.remaining = creep.remaining - LIFE_REDUCED
                        creep.reduced = true
                    end
                end
                regionData.delay = math.max(regionData.delay, DELAY_NORMAL)
            end

            for i = #regionData.creeps, 1, -1 do
                local creep = regionData.creeps[i] ---@type Creep
                local distance = creep.spawnpoint:dist(creep:getPos())
                if distance > RANGE_RETURN then
                    creep:issueOrder(Orders.move, creep.spawnpoint.x, creep.spawnpoint.y)
                    creep.returning = true
                end
                if distance <= RANGE_IN_HOME then
                    creep.returning = false
                end
                if creep.captured or creep.remaining <= 0. then
                    if creep.remaining <= 0. then
                        regionData.delay = DELAY_NORMAL
                        creep:destroy()
                    elseif creep.captured  then
                        regionData.delay = DELAY_DEATH
                    end
                    table.remove(regionData.creeps, i)
                end
            end
        end
        PlayersInRegion:clear()
    end

    OnMapInit(function ()
        Timed.call(function ()
            TriggerExecute(gg_trg_Creep_Spawn_System_Config)
    
            CREEPS_PER_PLAYER = udg_CREEPS_PER_PLAYER
            CREEPS_PER_REGION = udg_CREEPS_PER_REGION
            LIFE_SPAN = udg_LIFE_SPAN
            LIFE_REDUCED = udg_LIFE_REDUCED
            DELAY_SPAWN = udg_DELAY_SPAWN
            DELAY_NORMAL = udg_DELAY_NORMAL
            DELAY_DEATH = udg_DELAY_DEATH
            RANGE_LEVEL_1 = udg_RANGE_LEVEL_1
            RANGE_LEVEL_2 = udg_RANGE_LEVEL_2
            RANGE_RETURN = udg_RANGE_RETURN
            RANGE_IN_HOME = udg_RANGE_IN_HOME
            INTERVAL = udg_SPAWN_INTERVAL
            NEIGHBOURHOOD = udg_NEIGHBOURHOOD

            Timed.echo(Update, INTERVAL)

            -- Clear
            udg_CREEPS_PER_PLAYER = nil
            udg_CREEPS_PER_REGION = nil
            udg_LIFE_SPAN = nil
            udg_LIFE_REDUCED = nil
            udg_DELAY_SPAWN = nil
            udg_DELAY_NORMAL = nil
            udg_DELAY_DEATH = nil
            udg_RANGE_LEVEL_1 = nil
            udg_RANGE_LEVEL_2 = nil
            udg_RANGE_RETURN = nil
            udg_RANGE_IN_HOME = nil
            udg_SPAWN_INTERVAL = nil
            udg_NEIGHBOURHOOD = nil

            TriggerClearActions(gg_trg_Creep_Spawn_System_Config)
            DestroyTrigger(gg_trg_Creep_Spawn_System_Config)
            gg_trg_Creep_Spawn_System_Config = nil
        end)
    end)

    OnTrigInit(function ()
        local function killedOrCapturedfunction(_, target)
            target.captured = true
        end
        Digimon.capturedEvent(killedOrCapturedfunction)
        Digimon.killEvent(killedOrCapturedfunction)

        Digimon.postDamageEvent(function (info)
            local creep = info.target ---@type Creep
            if creep.returning then
                creep:issueOrder(Orders.attack, creep.spawnpoint.x, creep.spawnpoint.y)
            end
        end)

        -- For GUI
        udg_CreepSpawnCreate = CreateTrigger()
        TriggerAddAction(udg_CreepSpawnCreate, function ()
            Create(GetRectCenterX(udg_CreepSpawnRegion), GetRectCenterY(udg_CreepSpawnRegion), udg_CreepSpawnTypes)
            udg_CreepSpawnTypes = __jarray(0)
            udg_CreepSpawnRegion = nil
        end)
    end)

end)