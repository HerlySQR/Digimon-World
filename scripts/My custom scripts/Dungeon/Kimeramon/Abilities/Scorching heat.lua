Debug.beginFile("Kimeramon\\Abilities\\Scorching heat")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02C')
    local DURATION = 8. -- seconds
    local DAMAGE = 50. -- per second
    local AREA = 300.
    local INTERVAL = 1.0
    local DMG_PER_TICK = DAMAGE * INTERVAL

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", caster, "origin")
        BlzSetSpecialEffectScale(eff, 2.)
        Timed.echo(INTERVAL, DURATION, function ()
            ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), AREA, function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    UnitDamageTarget(caster, u, DMG_PER_TICK, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", u, "chest"))
                end
            end)
        end, function ()
            BlzSetSpecialEffectScale(eff, 0.01)
            DestroyEffect(eff)
        end)
    end)
end)
Debug.endFile()