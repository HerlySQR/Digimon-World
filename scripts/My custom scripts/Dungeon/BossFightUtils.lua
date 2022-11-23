OnInit("BossFightUtils", function ()
    Require "AbilityUtils"

    local castDelay = 5. -- seconds
    local isCasting = {} ---@type boolean[]

    ---Don't cast timed duration spells when other timed duration spell is casted
    ---@param caster unit
    ---@param flag boolean
    function BossIsCasting(caster, flag)
        if flag then
            isCasting[caster] = true
        else
            Timed.call(castDelay, function () isCasting[caster] = false end)
        end
    end

    ---@param caster unit
    ---@return boolean
    function BossStillCasting(caster)
        return isCasting[caster]
    end

    ---@param name string
    ---@param boss unit
    ---@param actions fun(unitsInTheField: unit[])
    function InitBossFight(name, boss, actions)
        local battlefield = {} ---@type rect[]
        local INTERVAL = 2. -- seconds

        local initialPos = GetUnitLoc(boss)

        local numRect = 1
        while true do
            local r = rawget(_G, "gg_rct_" .. name .. "_" .. numRect) -- To not display the error message
            if r then
                battlefield[numRect] = r
            else
                break
            end
            numRect = numRect + 1
        end
        numRect = numRect - 1

        local unitsInTheField = {}

        local enterTrigger = nil ---@type trigger
        local lowHP = nil ---@type trigger
        local currentTimer = nil ---@type function

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
            actions(unitsInTheField)
        end

        -- Enter the boss area
        enterTrigger = CreateTrigger()
        for j = 1, numRect do
            TriggerRegisterEnterRectSimple(enterTrigger, battlefield[j])
        end
        TriggerAddAction(enterTrigger, function ()
            if GetEnteringUnit() ~= boss then
                local x, y = GetUnitX(GetEnteringUnit()), GetUnitY(GetEnteringUnit())
                Timed.call(2., function ()
                    IssuePointOrderById(boss, Orders.attack, x, y)
                end)
                -- Start the check timer
                if not currentTimer then
                    currentTimer = Timed.echo(INTERVAL, BossFightActions)
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
                    currentTimer()
                    currentTimer = nil
                end
                unitsInTheField = {} -- Clear
                DisableTrigger(enterTrigger)

                Timed.call(360., function ()
                    ReviveHeroLoc(boss, initialPos, true)
                    EnableTrigger(enterTrigger)
                end)
            end
        end)

        -- The chances of casting increases when has low hp
        local halfHP = BlzGetUnitMaxHP(boss) / 2
        lowHP = CreateTrigger()
        TriggerRegisterUnitLifeEvent(lowHP, boss, LESS_THAN_OR_EQUAL, halfHP)
        TriggerAddAction(lowHP, function ()
            INTERVAL = 1.
            currentTimer()
            currentTimer = Timed.echo(INTERVAL, BossFightActions)
            DisableTrigger(lowHP)
        end)
    end
end)