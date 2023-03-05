Debug.beginFile("Tonosama Gekomon\\Abilities\\Summon Otamamon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BJ')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local MINION = FourCC('h01T')
    local HEAL = FourCC('A0BI')
    local HEAL_FACTOR = 0.05
    local INTERVAL = 6.
    local DISTANCE = 270.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local angle = 0
        -- Create the Gekomon
        for _ = 1, 2 do
            angle = angle + math.pi + math.random() * math.pi/2
            local minion = CreateUnit(owner, MINION, x + DISTANCE*math.cos(angle), y + DISTANCE*math.sin(angle), bj_UNIT_FACING)
            DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, GetUnitX(minion), GetUnitY(minion)))
            Timed.echo(INTERVAL, function ()
                if not UnitAlive(caster) then
                    KillUnit(minion)
                end
                if UnitAlive(minion) then
                    IssueTargetOrderById(minion, Orders.heal, caster)
                else
                    return true
                end
            end)
        end
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            if GetUnitTypeId(udg_DamageEventTarget) == MINION then
                udg_DamageEventAmount = 1.
            end
        end)
    end

    RegisterSpellEffectEvent(HEAL, function ()
        local target = GetSpellTargetUnit()
        SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + HEAL_FACTOR * GetUnitState(target, UNIT_STATE_MAX_LIFE))
    end)

end)
Debug.endFile()