OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A01Z')
    local StrDmgFactor = 0.
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.30
    local AttackFactor = 0.5
    local MissileModel = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetUnitX(target), GetUnitY(target), 25)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.target = target
        missile.damage = damage
        missile:model(MissileModel)
        missile:speed(1200.)
        missile:arc(0.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            Damage.apply(caster, target, damage, true, false, udg_Dark, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
            -- Poison
            DummyCast(GetOwningPlayer(caster),
                GetUnitX(caster), GetUnitY(caster),
                CURSE_SPELL,
                CURSE_ORDER,
                1,
                CastType.TARGET,
                target)
        end
        missile:launch()
    end)

end)