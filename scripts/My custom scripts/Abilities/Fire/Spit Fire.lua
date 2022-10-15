OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01G')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local DmgPerSecFactor = 0.1

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 50, GetUnitX(target), GetUnitY(target), 50)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.target = target
        missile.damage = damage
        missile:model("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl")
        missile:speed(1000.)
        missile:arc(10.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            Damage.apply(caster, target, damage, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
            local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl", target, "origin")
            local dmgPerSec = damage * DmgPerSecFactor
            Timed.echo(function (node)
                if node.elapsed < 5. then
                    Damage.apply(caster, target, dmgPerSec, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                else
                    DestroyEffect(eff)
                    return true
                end
            end, 1.)
            return true
        end
        missile:launch()
    end)

end)