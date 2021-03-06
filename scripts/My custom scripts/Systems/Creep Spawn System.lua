do
    local CREEPS_PER_PLAYER     ---@type integer
    local CREEPS_PER_REGION     ---@type integer
    local LIFE_SPAN             ---@type real
    local LIFE_REDUCED          ---@type real
    local DELAY_SPAWN           ---@type real
    local DELAY_NORMAL          ---@type real
    local DELAY_DEATH           ---@type real
    local RANGE_LEVEL_1         ---@type real
    local RANGE_LEVEL_2         ---@type real
    local NEIGHBOURHOOD         ---@type real
    local INTERVAL              ---@type real

    ---@class Creep : Digimon
    ---@field remaining real
    ---@field captured boolean
    ---@field reduced boolean

    local function CreateCreep(unitid, x, y)
        local creep = Digimon.create(Digimon.NEUTRAL, unitid, x, y, bj_UNIT_FACING) ---@type Creep

        creep.captured = false
        creep.reduced = false
        creep.remaining = LIFE_SPAN

        return creep
    end

    -- The system

    local All = LinkedList.create()

    local function Create(x, y, types)
        local this = {
            x = x,
            y = y,

            types = types,
            inregion = false,

            delay = 0.,
            waitToSpawn = 0.,

            creeps = {},
            neighbourhood = Set.create()
        }

        All:insert(this)

        for r in All:loop() do
            if DistanceBetweenCoords(x, y, r.x, r.y) <= NEIGHBOURHOOD then
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
            -- Check if the unit nearby the spawn region belongs to a player
            node.inregion = false
            ForUnitsInRange(node.x, node.y, RANGE_LEVEL_1, function (u)
                if GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
                    node.someoneClose = true
                    node.inregion = true
                    PlayersInRegion:addSingle(GetOwningPlayer(u))
                end
            end)
            -- Control the creep or the spawn
            if node.inregion then
                node.delay = node.delay - INTERVAL
                node.waitToSpawn = node.waitToSpawn - INTERVAL
                if node.delay <= 0. then
                    -- Spawn per neighbourhood instead per region
                    local r = GetFreeNeighbour(node, math.min(CREEPS_PER_REGION, CREEPS_PER_PLAYER * PlayersInRegion:size())) -- If don't have neighbours, then just use the same region
                    if r then
                        table.insert(r.creeps, CreateCreep(r.types[math.random(#r.types)], r.x, r.y))
                        -- They share the same delay
                        for n in node.neighbourhood:elements() do
                            n.waitToSpawn = math.max(DELAY_SPAWN, n.waitToSpawn)
                        end
                    end
                end
            else
                for _, creep in ipairs(node.creeps) do
                    creep.remaining = creep.remaining - INTERVAL
                    -- Check if a unit is still nearby the spawn region
                    if not creep.reduced then
                        node.someoneClose = false
                        ForUnitsInRange(node.x, node.y, RANGE_LEVEL_2, function (u)
                            if not node.someoneClose and GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER then
                                node.someoneClose = true
                            end
                        end)
                    end

                    --If there is no nearby unit in the RANGE_LEVEL_2 then reduce once the duration
                    if not node.someoneClose and not creep.reduced then
                        creep.remaining = creep.remaining - LIFE_REDUCED
                        creep.reduced = true
                    end
                end
                node.delay = math.max(node.delay, DELAY_NORMAL)
            end
            PlayersInRegion:clear()

            for i = #node.creeps, 1, -1 do
                local creep = node.creeps[i]
                if creep.captured or creep.remaining <= 0. then
                    if creep.remaining <= 0. then
                        node.delay = DELAY_NORMAL
                        creep:destroy()
                    elseif creep.captured  then
                        node.delay = DELAY_DEATH
                    end
                    table.remove(node.creeps, i)
                end
            end
        end
    end

    OnGameStart(function ()
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
        udg_SPAWN_INTERVAL = nil
        udg_NEIGHBOURHOOD = nil

        TriggerClearActions(gg_trg_Creep_Spawn_System_Config)
        DestroyTrigger(gg_trg_Creep_Spawn_System_Config)
        gg_trg_Creep_Spawn_System_Config = nil
    end)

    OnTrigInit(function ()
        local function killedOrCapturedfunction(_, target)
            target.captured = true
        end
        Digimon.capturedEvent(killedOrCapturedfunction)
        Digimon.killEvent(killedOrCapturedfunction)
        -- For GUI
        udg_CreepSpawnCreate = CreateTrigger()
        TriggerAddAction(udg_CreepSpawnCreate, function ()
            Create(GetRectCenterX(udg_CreepSpawnRegion), GetRectCenterY(udg_CreepSpawnRegion), udg_CreepSpawnTypes)
            udg_CreepSpawnTypes = __jarray(0)
            udg_CreepSpawnRegion = nil
        end)
    end)

end