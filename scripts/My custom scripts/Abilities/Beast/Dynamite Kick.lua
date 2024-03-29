OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A01N')
    local StrDmgFactor = 0.30
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local PushDist = 325.
    local CasterEffect = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl"
    local TargetUnitEffect = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        Damage.apply(caster, target, damage, true, false, udg_Beast, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
        -- XD
        local eff = AddSpecialEffect(CasterEffect, GetUnitX(caster), GetUnitY(caster))
        BlzSetSpecialEffectScale(eff, 2.)
        DestroyEffect(eff)
        -- Push the target
        if not IsUnitType(target, UNIT_TYPE_GIANT) then
            Knockback(
                target,
                math.atan(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)),
                PushDist,
                2500.,
                TargetUnitEffect,
                nil)
        end
    end)

end)