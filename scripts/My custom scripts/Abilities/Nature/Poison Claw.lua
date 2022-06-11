OnMapInit(function ()
    local Spell = FourCC('A01V')
    local StrDmgFactor = 0.
    local AgiDmgFactor = 0.30
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        Damage.apply(caster, target, damage, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
        DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\ChimaeraAcidMissile\\ChimaeraAcidMissile.mdl", GetUnitX(target), GetUnitY(target)))
        -- Poison
        DummyCast(GetOwningPlayer(caster),
                  GetUnitX(caster), GetUnitY(caster),
                  POISON_SPELL,
                  POISON_ORDER,
                  1,
                  CastType.TARGET,
                  target)
    end)

end)