Debug.beginFile("Sleep")
OnInit(function ()
    Require "Digimon"
    Require "RegisterSpellEffectEvent"
    Require "MotionSensor"

    local SLEEP = FourCC('A0GO')
    local SLEEP_DISABLED = FourCC('A0GP')

    local sleeping = __jarray(false) ---@type table<unit, boolean>
    local effects = __jarray(false) ---@type table<unit, effect>
    local callbacks = {} ---@type table<unit, function>

    RegisterSpellEffectEvent(SLEEP, function ()
        local u = GetSpellAbilityUnit()
        if not sleeping[u] then
            sleeping[u] = true
            effects[u] = AddSpecialEffect("Abilities\\Spells\\Other\\CreepSleep\\CreepSleepTarget.mdl", GetUnitX(u), GetUnitY(u))
            BlzSetSpecialEffectZ(effects[u], BlzGetUnitRealField(u, UNIT_RF_SHADOW_IMAGE_HEIGHT) + GetUnitZ(u, true))
            BlzSetSpecialEffectScale(effects[u], BlzGetUnitRealField(u, UNIT_RF_SCALING_VALUE))
            callbacks[u] = Timed.echo(1., function ()
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) + 0.02*GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MANA) + 0.02*GetUnitState(u, UNIT_STATE_MAX_MANA))
            end)
            MotionSensor.addUnit(u)
        end
    end)

    ---@param d Digimon
    local function abortSleep(d)
        if sleeping[d.root] then
            UnitAbortCurrentOrder(d.root)
            sleeping[d.root] = false
            DestroyEffect(effects[d.root])
            effects[d.root] = nil
            callbacks[d.root]()
        end
    end

    Digimon.postDamageEvent:register(function (info)
        abortSleep(info.target)
    end)

    Digimon.issueOrderEvent:register(abortSleep)
    Digimon.issuePointOrderEvent:register(abortSleep)
    Digimon.issueTargetOrderEvent:register(abortSleep)

    MotionSensor.changeEvent:register(function (sensor)
        if Digimon.getInstance(sensor.main) then
            abortSleep(Digimon.getInstance(sensor.main))
        end
        if not RectContainsUnit(sensor.main, gg_rct_Invisible_Bridge) then
            MotionSensor.removeUnit(sensor.main)
        end
    end)

    -- Add the evolution ability to the new digimon
    Digimon.createEvent:register(function (new)
        if new:getOwner() ~= Digimon.CITY and new:getOwner() ~= Digimon.PASSIVE then
            new:addAbility(SLEEP)
        end
    end)

    Digimon.evolutionEvent:register(function (d)
        if d:getOwner() ~= Digimon.CITY and d:getOwner() ~= Digimon.PASSIVE then
            d:addAbility(SLEEP)
        end
    end)

    -- Remove the evolution ability to destroyed digimon
    Digimon.destroyEvent:register(function (old)
        old:removeAbility(SLEEP)
        old:removeAbility(SLEEP_DISABLED)
    end)

    Digimon.onCombatEvent:register(function (d)
        d:removeAbility(SLEEP)
        d:addAbility(SLEEP_DISABLED)
    end)

    Digimon.offCombatEvent:register(function (d)
        d:removeAbility(SLEEP_DISABLED)
        d:addAbility(SLEEP)
    end)
end)
Debug.endFile()