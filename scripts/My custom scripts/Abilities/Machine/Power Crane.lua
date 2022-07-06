OnMapInit(function ()
    local Spell = FourCC('A023')
    local StrDmgFactor = 0.45
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local PushDist = 400.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        Damage.apply(caster, target, damage, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
        -- Push the target
        if not IsUnitType(target, UNIT_TYPE_GIANT) then
            Knockback(
                target,
                math.atan(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)),
                PushDist,
                2000.,
                "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl",
                nil,
                true
            )
        end
    end)

end)