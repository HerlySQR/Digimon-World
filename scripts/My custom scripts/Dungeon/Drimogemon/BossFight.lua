OnMapInit(function ()
    local boss = gg_unit_O060_0442 ---@type unit
    local battlefield = {} ---@type rect[]
    local INTERVAL = 2. -- seconds

    local initialPos = GetUnitLoc(boss)

    local numRect = 1
    while true do
        local r = rawget(_G, "gg_rct_Drimogemon_" .. numRect) -- To not display the error message
        if r then
            battlefield[numRect] = r
        else
            break
        end
        numRect = numRect + 1
    end

    local dashOrder = Orders.battleroar
    local movingEarthquake = Orders.earthquake
    local burrowOrder = Orders.burrow

    local unitsInTheField = {}

    local enterTrigger = nil ---@type trigger
    local lowHP = nil ---@type trigger
    local currentTimer = nil ---@type timedNode

    local function BossFightActions()
        -- Check if are units in the battlefield
        unitsInTheField = {}

        for i = 1, numRect do
            ForUnitsInRect(battlefield[i], function (u)
                if u ~= boss and UnitAlive(u) and IsUnitType(u, UNIT_TYPE_HERO) then
                    table.insert(unitsInTheField, u)
                end
            end)
        end

        if #unitsInTheField == 0 then
            -- Reset the boss
            SetWidgetLife(boss, GetUnitState(boss, UNIT_STATE_MAX_LIFE))
            SetUnitState(boss, UNIT_STATE_MANA, GetUnitState(boss, UNIT_STATE_MAX_MANA))
            UnitResetCooldown(boss)
            IssuePointOrderByIdLoc(boss, Orders.move, initialPos)
            INTERVAL = 2.

            EnableTrigger(enterTrigger)
            --EnableTrigger(lowHP)
            currentTimer = nil
            return true
        end

        -- Spells
        local spellChance = math.random(0, 100)
        if spellChance <= 35 then
            IssueTargetOrderById(boss, dashOrder, unitsInTheField[math.random(1, #unitsInTheField)])
        elseif spellChance > 35 and spellChance <= 45 then
            local u = unitsInTheField[math.random(1, #unitsInTheField)]
            IssuePointOrderById(boss, movingEarthquake, GetUnitX(u), GetUnitY(u))
        end
        if not BossStillCasting(boss) then
            if math.random(0, 100) <= 25 then
                IssueImmediateOrderById(boss, burrowOrder)
            end
        end
    end

    -- Enter the boss area
    enterTrigger = CreateTrigger()
    for j = 1, numRect do
        TriggerRegisterEnterRectSimple(enterTrigger, battlefield[j])
    end
    TriggerAddAction(enterTrigger, function ()
        if GetEnteringUnit() ~= boss then
            IssuePointOrderById(boss, Orders.attackground, GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit()))
            -- Start the check timer
            if not currentTimer then
                currentTimer = Timed.echo(BossFightActions, INTERVAL)
            end
            DisableTrigger(enterTrigger)
        end
    end)

    -- Off the triggers and the timer when the boss dies
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(t, function ()
        if GetDyingUnit() == boss then
            if currentTimer then
                currentTimer:remove()
                currentTimer = nil
            end
            unitsInTheField = {} -- Clear
            DisableTrigger(enterTrigger)
        end
    end)

    -- The chances of casting increases when has low hp
    local halfHP = BlzGetUnitMaxHP(boss) / 2
    lowHP = CreateTrigger()
    TriggerRegisterUnitLifeEvent(lowHP, boss, LESS_THAN_OR_EQUAL, halfHP)
    TriggerAddAction(lowHP, function ()
        INTERVAL = 1.
        currentTimer:remove()
        currentTimer = Timed.echo(BossFightActions, INTERVAL)
        DisableTrigger(lowHP)
    end)

end)