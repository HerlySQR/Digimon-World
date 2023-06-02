Debug.beginFile("Creep Spawn System")
OnInit(function ()
    Require "Timed"
    Require "LinkedList"
    Require "Set"
    Require "AbilityUtils"
    Require "Vec2"
    Require "SyncedTable"
    Require "Digimon Capture"
    Require "ZTS"

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
    local CHANCE_UNCOMMON       ---@type integer
    local CHANCE_RARE           ---@type integer
    local CHANCE_LEGENDARY      ---@type integer

    ---@class Creep : Digimon
    ---@field remaining number
    ---@field captured boolean
    ---@field reduced boolean
    ---@field returning boolean
    ---@field spawnpoint Vec2
    ---@field rd RegionData

    ---@class RegionData
    ---@field rectID table
    ---@field spawnpoint Vec2
    ---@field types unitpool
    ---@field inDay boolean
    ---@field inNight boolean
    ---@field minLevel integer
    ---@field maxLevel integer
    ---@field isDungeon boolean
    ---@field inregion boolean
    ---@field delay number
    ---@field waitToSpawn number
    ---@field creeps Creep[]
    ---@field neighbourhood Set
    ---@field sameRegion Set
    ---@field checked boolean

    ---@param pool unitpool
    ---@param pos Vec2
    ---@return Creep
    local function CreateCreep(pool, pos)
        local creep = Digimon.add(PlaceRandomUnit(pool, Digimon.NEUTRAL, pos.x, pos.y, bj_UNIT_FACING)) ---@type Creep

        creep.captured = false
        creep.reduced = false
        creep.returning = false
        creep.remaining = LIFE_SPAN
        creep.spawnpoint = pos

        return creep
    end

    -- The system

    local All = LinkedList.create()

    ---@param types Creep[]
    ---@return unitpool
    local function GenerateCreepPool(types)
        local pool = CreateUnitPool()

        local commons = {}
        local uncommons = {}
        local rares = {}
        local legendaries = {}

        for i = 1, #types do
            local id = types[i]
            local rarity = Digimon.getRarity(id)

            if rarity == Rarity.COMMON then
                table.insert(commons, id)
            elseif rarity == Rarity.UNCOMMON then
                table.insert(uncommons, id)
            elseif rarity == Rarity.RARE then
                table.insert(rares, id)
            elseif rarity == Rarity.LEGENDARY then
                table.insert(legendaries, id)
            end
        end

        local chanceCommon = 1
        if #legendaries > 0 then
            chanceCommon = chanceCommon - CHANCE_LEGENDARY
            for _, v in ipairs(legendaries) do
                UnitPoolAddUnitType(pool, v, CHANCE_LEGENDARY/#legendaries)
            end
        end
        if #rares > 0 then
            chanceCommon = chanceCommon - CHANCE_RARE
            for _, v in ipairs(rares) do
                UnitPoolAddUnitType(pool, v, CHANCE_RARE/#rares)
            end
        end
        if #uncommons > 0 then
            chanceCommon = chanceCommon - CHANCE_UNCOMMON
            for _, v in ipairs(uncommons) do
                UnitPoolAddUnitType(pool, v, CHANCE_UNCOMMON/#uncommons)
            end
        end
        for _, v in ipairs(commons) do
            UnitPoolAddUnitType(pool, v, chanceCommon/#commons)
        end

        return pool
    end

    ---@param re rect
    ---@param types integer[]
    ---@param inDay boolean
    ---@param inNight boolean
    ---@param minLevel integer
    ---@param maxLevel integer
    ---@param isDungeon boolean
    ---@return RegionData
    local function Create(re, types, inDay, inNight, minLevel, maxLevel, isDungeon)
        assert(re, "You are trying to create an spawn in a nil region")
        local x, y = GetRectCenterX(re), GetRectCenterY(re)
        local this = { ---@type RegionData
            rectID = re,
            spawnpoint = Vec2.new(x, y),
            types = GenerateCreepPool(types),
            inDay = inDay,
            inNight = inNight,
            minLevel = minLevel,
            maxLevel = maxLevel,
            isDungeon = isDungeon,

            inregion = false,
            delay = 0.,
            waitToSpawn = 0.,
            creeps = {},
            neighbourhood = Set.create(),
            sameRegion = Set.create()
        }

        All:insert(this)

        for node in All:loop() do
            local r = node.value ---@type RegionData
            if DistanceBetweenCoords(x, y, r.spawnpoint.x, r.spawnpoint.y) <= NEIGHBOURHOOD then
                this.neighbourhood:addSingle(r)
                r.neighbourhood:addSingle(this)
                if this.rectID == r.rectID then
                    this.sameRegion:addSingle(r)
                    r.sameRegion:addSingle(this)
                end
            end
        end

        return this
    end

    ---Returns a random neighbour that didn't reach its limit and is not in cooldown, if there is not, then return nil
    ---@param r RegionData
    ---@param quantity integer
    ---@return RegionData | nil
    local function GetFreeNeighbour(r, quantity)
        local list = {} ---@type RegionData[]

        for n in r.neighbourhood:elements() do
            if #n.creeps < quantity and n.waitToSpawn <= 0. and n.delay <= 0
                and ((n.inDay and GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK)
                or (n.inNight and (GetTimeOfDay() < bj_TOD_DAWN or GetTimeOfDay() >= bj_TOD_DUSK))) then

                table.insert(list, n)
            end
        end

        if #list > 0 then
            return list[math.random(#list)]
        end
    end

    ---Returns a random integer between min and max
    ---but has more chance to get a closer integer to lvl
    ---@param lvl integer
    ---@param min integer
    ---@param max integer
    ---@return integer
    local function GetProccessedLevel(lvl, min, max)
        if min >= max then
            return min
        end

        local weights = {}
        local maxWeight = 0

        for x = min, max do
            local weight = 1/(1+(x-lvl)^2)
            maxWeight = maxWeight + weight
            weights[x] = maxWeight
        end

        local r = maxWeight * math.random()
        local l = min
        for x = min, max-1 do
            if r > weights[x] then
                l = l + 1
            else
                break
            end
        end

        return l
    end

    local PlayersInRegion = Set.create()
    local regionData, lvl ---@type RegionData, integer
    local function checkForUnit(u)
        if GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
            regionData.someoneClose = true
            regionData.inregion = true
            PlayersInRegion:addSingle(GetOwningPlayer(u))
            lvl = math.max(lvl, GetHeroLevel(u))
        end
    end

    local function checkNearby(u)
        if not regionData.someoneClose and GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
            regionData.someoneClose = true
        end
    end

    local function Update()
        for node in All:loop() do
            regionData = node.value ---@type RegionData
            -- Check if the unit nearby the spawn region belongs to a player
            regionData.inregion = false
            lvl = 1
            ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_1, checkForUnit)
            -- Control the creep or the spawn
            if regionData.inregion then
                regionData.delay = regionData.delay - INTERVAL
                regionData.waitToSpawn = regionData.waitToSpawn - INTERVAL
                if regionData.delay <= 0. then
                    -- Spawn per neighbourhood instead per region
                    local r = GetFreeNeighbour(regionData, math.min(CREEPS_PER_REGION, CREEPS_PER_PLAYER * PlayersInRegion:size())) -- If don't have neighbours, then just use the same region
                    if r then
                        local creep = CreateCreep(r.types, r.spawnpoint)
                        if regionData.isDungeon then
                            ZTS_AddThreatUnit(creep.root, true)
                        end
                        creep:setLevel(GetProccessedLevel(lvl, r.minLevel, r.maxLevel))
                        creep.rd = regionData
                        for r2 in r.sameRegion:elements() do
                            table.insert(r2.creeps, creep)
                        end
                        -- They share the same delay
                        for n in regionData.neighbourhood:elements() do
                            n.waitToSpawn = math.max(DELAY_SPAWN, n.waitToSpawn)
                        end
                    end
                end
            else
                -- Check if a unit is still nearby the spawn region
                regionData.someoneClose = false
                ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_2, checkNearby)
                for _, creep in ipairs(regionData.creeps) do
                    if creep.rd == regionData then
                        creep.remaining = creep.remaining - INTERVAL

                        --If there is no nearby unit in the RANGE_LEVEL_2 then reduce once the duration
                        if not regionData.someoneClose and not creep.reduced then
                            creep.remaining = creep.remaining - LIFE_REDUCED
                            creep.reduced = true
                        end
                    end
                end
                regionData.delay = math.max(regionData.delay, DELAY_NORMAL)
            end

            for i = #regionData.creeps, 1, -1 do
                local creep = regionData.creeps[i] ---@type Creep
                if creep.rd == regionData then
                    if creep.captured or creep.remaining <= 0. then
                        if creep.remaining <= 0. then
                            regionData.delay = DELAY_NORMAL
                            if regionData.isDungeon then
                                ZTS_RemoveThreatUnit(creep.root)
                            end
                            creep:destroy()
                        elseif creep.captured  then
                            regionData.delay = DELAY_DEATH
                        end
                        for r2 in regionData.sameRegion:elements() do
                            table.remove(r2.creeps, i)
                        end
                    else
                        if not regionData.isDungeon then
                            local distance = creep.spawnpoint:dist(creep:getPos())
                            if distance > RANGE_RETURN then
                                creep:issueOrder(Orders.smart, creep.spawnpoint.x, creep.spawnpoint.y)
                                creep.returning = true
                            end
                            if distance <= RANGE_IN_HOME then
                                creep.returning = false
                            end
                        end
                    end
                end
            end
            PlayersInRegion:clear()
        end
    end

    OnInit.trig(function ()
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
        INTERVAL = udg_UPDATE_INTERVAL
        NEIGHBOURHOOD = udg_NEIGHBOURHOOD
        CHANCE_UNCOMMON = udg_CHANCE_UNCOMMON
        CHANCE_RARE = udg_CHANCE_RARE
        CHANCE_LEGENDARY = udg_CHANCE_LEGENDARY

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
        udg_UPDATE_INTERVAL = nil
        udg_NEIGHBOURHOOD = nil
        udg_CHANCE_UNCOMMON = nil
        udg_CHANCE_RARE = nil
        udg_CHANCE_LEGENDARY = nil

        TriggerClearActions(gg_trg_Creep_Spawn_System_Config)
        DestroyTrigger(gg_trg_Creep_Spawn_System_Config)
        gg_trg_Creep_Spawn_System_Config = nil
    end)

    OnInit.final(function ()
        Timed.echo(INTERVAL, Update)
    end)

    Digimon.capturedEvent:register(function (info)
        local target = info.target ---@type Creep
        target.captured = true
        if target.rd and target.rd.isDungeon then
            ZTS_RemoveThreatUnit(target.root)
        end
        ZTS_AddPlayerUnit(target.root)
    end)
    Digimon.killEvent:register(function (info)
        info.target.captured = true
    end)

    Digimon.postDamageEvent:register(function (info)
        local creep = info.target ---@type Creep
        if creep.returning then
            creep:issueOrder(Orders.smart, creep.spawnpoint.x, creep.spawnpoint.y)
        end
    end)

    -- For GUI
    udg_CreepSpawnCreate = CreateTrigger()
    TriggerAddAction(udg_CreepSpawnCreate, function ()
        Create(
            udg_CreepSpawnRegion,
            udg_CreepSpawnTypes,
            udg_CreepSpawnInDay,
            udg_CreepSpawnInNight,
            udg_CreepSpawnMinLevel,
            udg_CreepSpawnMaxLevel,
            udg_CreepSpawnIsDungeon)
        udg_CreepSpawnRegion = nil
        udg_CreepSpawnTypes = __jarray(0)
        udg_CreepSpawnInDay = true
        udg_CreepSpawnInNight = true
        udg_CreepSpawnMinLevel = 1
        udg_CreepSpawnMaxLevel = 1
        udg_CreepSpawnIsDungeon = false
    end)
end)
Debug.endFile()