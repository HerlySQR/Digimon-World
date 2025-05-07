Debug.beginFile("Creep Spawn System")
OnInit(function ()
    Require "Timed"
    Require "LinkedList"
    Require "Set"
    Require "AbilityUtils"
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
    local NEIGHBOURHOOD         ---@type number
    local INTERVAL              ---@type number
    local CHANCE_COMMON = 1.
    local CHANCE_UNCOMMON       ---@type number
    local CHANCE_RARE           ---@type number
    local CHANCE_LEGENDARY      ---@type number
    local ITEM_DROP_CHANCE      ---@type integer
    local PARTITIONS = 4

    ---@class Creep : Digimon
    ---@field remaining number
    ---@field captured boolean
    ---@field reduced boolean
    ---@field returning boolean
    ---@field spawnpoint {x: number, y: number}
    ---@field rd RegionData
    ---@field patrolling boolean

    ---@class RegionData
    ---@field rectID table
    ---@field spawnpoint {x: number, y: number}
    ---@field types unitpool
    ---@field weight number
    ---@field inDay boolean
    ---@field inNight boolean
    ---@field minLevel integer
    ---@field maxLevel integer
    ---@field inregion boolean
    ---@field delay number
    ---@field waitToSpawn number
    ---@field creeps Creep[]
    ---@field neighbourhood Set
    ---@field sameRegion Set
    ---@field someoneClose boolean
    ---@field itemTable integer[]
    ---@field queued boolean
    ---@field storedLvl integer
    ---@field storedPlayerInRegion integer

    ---@param rd RegionData
    ---@return Creep
    local function CreateCreep(rd)
        local creep = Digimon.add(PlaceRandomUnit(rd.types, Digimon.NEUTRAL, rd.spawnpoint.x, rd.spawnpoint.y, bj_UNIT_FACING)) ---@type Creep

        creep.captured = false
        creep.reduced = false
        creep.returning = false
        creep.remaining = LIFE_SPAN
        creep.spawnpoint = rd.spawnpoint
        creep.patrolling = true
        creep.rd = rd

        ZTS_AddThreatUnit(creep.root, true)

        return creep
    end

    -- The system

    local All = {} ---@type RegionData[]

    ---@param types integer[]
    ---@return unitpool, number
    local function GenerateCreepPool(types)
        local pool = CreateUnitPool()
        local weight = 0

        local commons = {}
        local uncommons = {}
        local rares = {}
        local legendaries = {}

        for i = 1, #types do
            local id = types[i]
            local rarity = Digimon.getRarity(id)

            if rarity == Rarity.COMMON then
                weight = weight + CHANCE_COMMON
                table.insert(commons, id)
            elseif rarity == Rarity.UNCOMMON then
                weight = weight + CHANCE_UNCOMMON
                table.insert(uncommons, id)
            elseif rarity == Rarity.RARE then
                weight = weight + CHANCE_RARE
                table.insert(rares, id)
            elseif rarity == Rarity.LEGENDARY then
                weight = weight + CHANCE_LEGENDARY
                table.insert(legendaries, id)
            end
        end
        weight = weight/#types

        local chanceCommon = 1
        if CHANCE_LEGENDARY > 0 and #legendaries > 0 then
            chanceCommon = chanceCommon - CHANCE_LEGENDARY
            for _, v in ipairs(legendaries) do
                UnitPoolAddUnitType(pool, v, CHANCE_LEGENDARY/#legendaries)
            end
        end
        if CHANCE_RARE > 0 and #rares > 0 then
            chanceCommon = chanceCommon - CHANCE_RARE
            for _, v in ipairs(rares) do
                UnitPoolAddUnitType(pool, v, CHANCE_RARE/#rares)
            end
        end
        if CHANCE_UNCOMMON > 0 and #uncommons > 0 then
            chanceCommon = chanceCommon - CHANCE_UNCOMMON
            for _, v in ipairs(uncommons) do
                UnitPoolAddUnitType(pool, v, CHANCE_UNCOMMON/#uncommons)
            end
        end
        for _, v in ipairs(commons) do
            UnitPoolAddUnitType(pool, v, chanceCommon/#commons)
        end

        return pool, weight
    end

    ---@param re rect
    ---@param types integer[]
    ---@param inDay boolean
    ---@param inNight boolean
    ---@param minLevel integer
    ---@param maxLevel integer
    ---@param itemTable integer[]
    ---@return RegionData
    local function Create(re, types, inDay, inNight, minLevel, maxLevel, itemTable)
        assert(re, "You are trying to create an spawn in a nil region")
        local x, y = GetRectCenterX(re), GetRectCenterY(re)
        local typs, weight = GenerateCreepPool(types)
        local this = { ---@type RegionData
            rectID = re,
            spawnpoint = {x = x, y = y},
            types = typs,
            weight = weight,
            inDay = inDay,
            inNight = inNight,
            minLevel = minLevel,
            maxLevel = maxLevel,
            itemTable = itemTable,

            inregion = false,
            delay = 0.,
            waitToSpawn = 0.,
            creeps = {},
            neighbourhood = Set.create(),
            sameRegion = Set.create(),
            someoneClose = false,
            queued = false,
            storedLvl = 1
        }

        table.insert(All, this)

        for i = 1, #All do
            local r = All[i]
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
            if #list == 1 then
                local j = 1
                for n in r.neighbourhood:elements() do
                    j = j + 1
                end
                return list[1]
            else
                local weights = {}
                local maxWeight = 0.

                for i = 1, #list do
                    maxWeight = maxWeight + list[i].weight
                    weights[i] = maxWeight
                end

                local rand = maxWeight * math.random()
                local l = 1
                for i = 1, #list-1 do
                    if rand > weights[i] then
                        l = l + 1
                    else
                        break
                    end
                end
                return list[l]
            end
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
    local spawnQueue = {} ---@type RegionData[] 
    local regionData, lvl, bossNearby

    local function checkForPlayerUnits(u)
        if GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
            regionData.someoneClose = true
            regionData.inregion = true
            PlayersInRegion:addSingle(GetOwningPlayer(u))
            lvl = math.max(lvl, GetHeroLevel(u))
        end
    end

    local function checkForSomeoneClose(u)
        if not regionData.someoneClose and GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
            regionData.someoneClose = true
        end
    end

    local function checkForBossNearby(u)
        if GetOwningPlayer(u) == Digimon.VILLAIN then
            bossNearby = true
        end
    end

    local function Update(start, finish)
        for node = start, finish do
            regionData = All[node]
            -- Check if the unit nearby the spawn region belongs to a player
            regionData.inregion = false
            lvl = 1
            ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_1, checkForPlayerUnits)
            -- Check if a unit is still nearby the spawn region
            regionData.someoneClose = true
            -- Control the creep or the spawn
            if regionData.inregion then
                if not regionData.queued and regionData.delay <= 0. then
                    table.insert(spawnQueue, regionData)
                    for r in regionData.neighbourhood:elements() do
                        r.storedLvl = lvl
                        r.storedPlayerInRegion = PlayersInRegion:size()
                        r.queued = true
                    end
                end
                regionData.delay = regionData.delay - INTERVAL
                regionData.waitToSpawn = regionData.waitToSpawn - INTERVAL
            else
                regionData.someoneClose = false
                ForUnitsInRange(regionData.spawnpoint.x, regionData.spawnpoint.y, RANGE_LEVEL_2, checkForSomeoneClose)
                regionData.delay = math.max(regionData.delay, DELAY_NORMAL)
            end

            for _, creep in ipairs(regionData.creeps) do
                if creep.rd == regionData then
                    creep.patrolling = not ZTS_GetCombatState(creep.root)
                    if creep.patrolling then
                        creep.remaining = creep.remaining - INTERVAL
                    end

                    --If there is no nearby unit in the RANGE_LEVEL_2 then reduce once the duration
                    if not regionData.someoneClose and not creep.reduced then
                        creep.remaining = creep.remaining - LIFE_REDUCED
                        creep.reduced = true
                    end
                end
            end

            for i = #regionData.creeps, 1, -1 do
                local creep = regionData.creeps[i]
                if creep.rd == regionData then
                    if creep.captured or creep.remaining <= 0. then
                        if creep.remaining <= 0. then
                            regionData.delay = DELAY_NORMAL
                            creep:destroy()
                        elseif creep.captured  then
                            regionData.delay = DELAY_DEATH
                        end
                        for r2 in regionData.sameRegion:elements() do
                            table.remove(r2.creeps, i)
                        end
                        creep.rd = nil
                    end
                end

                bossNearby = false
                ForUnitsInRange(creep:getX(), creep:getY(), 1000., checkForBossNearby)

                if not bossNearby then
                    if GetUnitCurrentOrder(creep.root) == 0 and math.random(10) == 1 then
                        local dist = GetRandomReal(128, 384)
                        local angle = GetRandomReal(0, 2*math.pi)
                        local x, y = creep:getX() + dist * math.cos(angle), creep:getY() + dist * math.sin(angle)
                        if IsTerrainWalkable(x, y) then
                            creep:issueOrder(Orders.attack, x, y)
                        end
                    end
                else
                    creep:issueOrder(Orders.smart, regionData.spawnpoint.x, regionData.spawnpoint.y)
                end
            end
            if not PlayersInRegion:isEmpty() then
                PlayersInRegion:clear()
            end
        end

        while true do
            regionData = table.remove(spawnQueue)
            if not regionData then break end
            for r in regionData.neighbourhood:elements() do
                r.queued = false
            end
            -- Spawn per neighbourhood instead per region
            local r = GetFreeNeighbour(regionData, math.min(CREEPS_PER_REGION, CREEPS_PER_PLAYER * regionData.storedPlayerInRegion)) -- If don't have neighbours, then just use the same region
            if r then
                local creep = CreateCreep(r)
                creep:setLevel(GetProccessedLevel(regionData.storedLvl, r.minLevel, r.maxLevel))
                for r2 in r.sameRegion:elements() do
                    table.insert(r2.creeps, creep)
                end
                -- They share the same delay
                for n in regionData.neighbourhood:elements() do
                    n.waitToSpawn = math.max(DELAY_SPAWN, n.waitToSpawn)
                end
            end
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
        INTERVAL = udg_UPDATE_INTERVAL
        NEIGHBOURHOOD = udg_NEIGHBOURHOOD
        CHANCE_UNCOMMON = math.max(udg_CHANCE_UNCOMMON, 0.001)
        CHANCE_RARE = math.max(udg_CHANCE_RARE, 0.001)
        CHANCE_LEGENDARY = math.max(udg_CHANCE_LEGENDARY, 0.001)
        ITEM_DROP_CHANCE = udg_ITEM_DROP_CHANCE

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
        udg_ITEM_DROP_CHANCE = nil

        TriggerClearActions(gg_trg_Creep_Spawn_System_Config)
        DestroyTrigger(gg_trg_Creep_Spawn_System_Config)
        gg_trg_Creep_Spawn_System_Config = nil
    end)

    OnInit.final(function ()
        if #All < PARTITIONS then
            Timed.echo(INTERVAL, function ()
                Update(1, #All)
            end)
        else
            local delay = INTERVAL / PARTITIONS
            local delta = #All//PARTITIONS
            local parts = {
                1, delta,
                delta+1, 2*delta,
                2*delta+1, 3*delta,
                3*delta+1, #All
            }
            TimerStart(CreateTimer(), INTERVAL, true, function ()
                Update(parts[1], parts[2])
            end)
            Timed.call(delay, function ()
                TimerStart(CreateTimer(), INTERVAL, true, function ()
                    Update(parts[3], parts[4])
                end)
                Timed.call(delay, function ()
                    TimerStart(CreateTimer(), INTERVAL, true, function ()
                        Update(parts[5], parts[6])
                    end)
                    Timed.call(delay, function ()
                        TimerStart(CreateTimer(), INTERVAL, true, function ()
                            Update(parts[7], parts[8])
                        end)
                    end)
                end)
            end)
        end
    end)

    Digimon.capturedEvent:register(function (info)
        local target = info.target ---@type Creep
        target.captured = true
        ZTS_RemoveThreatUnit(target.root)
        ZTS_AddPlayerUnit(target.root)
    end)
    Digimon.deathEvent:register(function (info)
        local target = info.target ---@type Creep
        if target.rd then
            ZTS_RemoveThreatUnit(target.root)
            target.captured = true
            local itm = target.rd.itemTable[math.random(#target.rd.itemTable)]
            if itm then
                if math.random(100) <= ITEM_DROP_CHANCE then
                    CreateItem(itm, target:getPos())
                end
            end
        end
    end)

    function RerollCreepItem(creep)
        if creep.rd then
            ZTS_RemoveThreatUnit(creep.root)
            creep.captured = true
            local itm = creep.rd.itemTable[math.random(#creep.rd.itemTable)]
            if itm then
                if math.random(100) <= ITEM_DROP_CHANCE then
                    CreateItem(itm, creep:getPos())
                end
            end
        end
    end

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
            udg_CreepSpawnItemTable)
        udg_CreepSpawnRegion = nil
        udg_CreepSpawnTypes = __jarray(0)
        udg_CreepSpawnInDay = true
        udg_CreepSpawnInNight = true
        udg_CreepSpawnMinLevel = 1
        udg_CreepSpawnMaxLevel = 1
        udg_CreepSpawnItemTable = __jarray(0)
    end)
end)
Debug.endFile()