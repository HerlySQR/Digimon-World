Debug.beginFile("King Sukamon\\Abilities\\Healling Minions")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0B8')
    local MINION = FourCC('h01H')
    local HEAL_FACTOR = 0.01
    local LIGHTNING_MODEL = "HWPB"
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local INTERVAL = 0.1
    local HEAL_INTERVAL = 4.
    local DISTANCE = 270.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local angle = 0
        for _ = 1, 2 do
            angle = angle + math.pi + math.random() * math.pi/2
            local minion = CreateUnit(owner, MINION, x + DISTANCE*math.cos(angle), y + DISTANCE*math.sin(angle), bj_UNIT_FACING)
            DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, GetUnitX(minion), GetUnitY(minion)))
            local chain = AddLightningEx(LIGHTNING_MODEL, true, GetUnitX(minion), GetUnitY(minion), GetUnitZ(minion) + 50, x, y, GetUnitZ(caster) + 75)
            local counter = 0
            Timed.echo(INTERVAL, function ()
                if not UnitAlive(caster) then
                    KillUnit(minion)
                end
                if UnitAlive(minion) then
                    SetUnitFacing(minion, math.deg(math.atan(GetUnitY(caster) - GetUnitY(minion), GetUnitX(caster) - GetUnitX(minion))))
                    counter = counter + INTERVAL
                    if counter >= HEAL_INTERVAL then
                        counter = 0
                        SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + HEAL_FACTOR * GetUnitState(caster, UNIT_STATE_MAX_LIFE))
                    end
                    MoveLightningEx(chain, true, GetUnitX(minion), GetUnitY(minion), GetUnitZ(minion) + 50, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster) + 75)
                else
                    DestroyLightning(chain)
                    return true
                end
            end)
        end
    end)

    local t = CreateTrigger()
    TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
    TriggerAddAction(t, function ()
        if GetUnitTypeId(udg_DamageEventTarget) == MINION then
            udg_DamageEventAmount = 1.
        end
    end)
end)
Debug.endFile()