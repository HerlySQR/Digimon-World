OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A070')
    local DAMAGE_PER_SEC = 15.
    local DURATION = 8.
    local AREA = 300.
    local CLOUD_MODEL = "Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl"
    local INTERVAL = 1.0

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetSpellTargetX()
        local y = GetSpellTargetY()

        local eff = AddSpecialEffect(CLOUD_MODEL, x, y)
        Timed.echo(INTERVAL, DURATION, function ()
            ForUnitsInRange(x, y, AREA, function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, DAMAGE_PER_SEC, true, false, udg_Nature, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                    -- Poison
                    if not UnitHasBuffBJ(u, POISON_BUFF) then
                        PoisonUnit(caster, u)
                    end
                end
            end)
        end, function ()
            DestroyEffect(eff)
        end)
    end)

end)