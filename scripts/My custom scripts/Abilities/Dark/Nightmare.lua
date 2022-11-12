OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A022')
    local StrDmgFactor = 0.
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.45
    local AttackFactor = 0.5
    local DmgPerSecFactor = 0.3
    local TargetUnitEffect = "Abilities\\Spells\\Undead\\Sleep\\SleepSpecialArt.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        DestroyEffect(AddSpecialEffectTarget(TargetUnitEffect, target, "origin"))
        -- Sleep
        DummyCast(GetOwningPlayer(caster),
            GetUnitX(caster), GetUnitY(caster),
            SLEEP_SPELL,
            SLEEP_ORDER,
            1,
            CastType.TARGET,
            target)
        -- Damage over time
        local dmg = damage * DmgPerSecFactor
        Timed.echo(1., 5., function ()
            Damage.apply(caster, target, dmg, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
        end)
    end)

end)