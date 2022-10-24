OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01Q')
    local StrDmgFactor = 0.30
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local TargetUnitModel = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        Damage.apply(caster, target, damage, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
        DestroyEffect(AddSpecialEffect(TargetUnitModel, GetUnitX(target), GetUnitY(target)))
        -- Reduce armor
        DummyCast(GetOwningPlayer(caster),
                  GetUnitX(caster), GetUnitY(caster),
                  ARMOR_REDUCE_SPELL,
                  ARMOR_REDUCE_ORDER,
                  1,
                  CastType.TARGET,
                  target)
    end)

end)