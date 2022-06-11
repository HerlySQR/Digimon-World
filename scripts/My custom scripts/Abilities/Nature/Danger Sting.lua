OnMapInit(function ()
    local Spell = FourCC('A01X')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5

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
        missile:model("Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl")
        missile:speed(1500.)
        missile:arc(15.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            Damage.apply(caster, target, damage, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
            -- Poison
            DummyCast(GetOwningPlayer(caster),
                GetUnitX(caster), GetUnitY(caster),
                POISON_SPELL,
                POISON_ORDER,
                1,
                CastType.TARGET,
                target)
        end
        missile:launch()
    end)

end)