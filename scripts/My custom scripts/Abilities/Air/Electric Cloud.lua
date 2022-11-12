OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A01P')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.30
    local AttackFactor = 0.5
    local TargetPointEffect = "Abilities\\Spells\\Other\\Monsoon\\MonsoonRain.mdl"
    local TargetUnitEffect = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl"
    -- The same as it is in the object editor
    local Area = 400.

    RegisterSpellCastEvent(Spell, function ()
        DestroyEffectTimed(AddSpecialEffect(TargetPointEffect, GetSpellTargetX(), GetSpellTargetY()), 3.)
    end)

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Enum the enemies
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        Timed.call(1.5, function ()
            ForUnitsInRange(tx, ty, Area, function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Air, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffect(TargetUnitEffect, GetUnitX(u), GetUnitY(u)))
                    -- Stun
                    DummyCast(owner,
                              GetUnitX(caster), GetUnitY(caster),
                              STUN_SPELL,
                              STUN_ORDER,
                              1,
                              CastType.TARGET,
                              u)
                end
            end)
        end)
    end)

end)