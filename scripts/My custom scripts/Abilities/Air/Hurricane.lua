OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A01T')
    local StrDmgFactor = 0.45
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local Area = 350.
    local PushDist = 350.
    local CasterEffect = "Abilities\\Spells\\Other\\Tornado\\TornadoElemental.mdl"
    local TargetUnitEffect1 = "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl"
    local TargetUnitEffect2 = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        local eff = AddSpecialEffect(CasterEffect, x, y)
        BlzSetSpecialEffectZ(eff, -150.)
        DestroyEffect(eff)
        -- --
        ForUnitsInRange(x, y, Area, function (u)
            if IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, damage, true, false, udg_Air, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                -- Push the target
                if not IsUnitType(u, UNIT_TYPE_GIANT) then
                    Knockback(
                        u,
                        math.atan(GetUnitY(u) - GetUnitY(caster), GetUnitX(u) - GetUnitX(caster)),
                        PushDist,
                        2000.,
                        TargetUnitEffect1,
                        TargetUnitEffect2
                    )
                end
            end
        end)
    end)

end)