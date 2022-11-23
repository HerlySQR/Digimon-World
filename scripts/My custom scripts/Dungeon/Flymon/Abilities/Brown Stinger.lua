OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A06Z')
    local DAMAGE = 80.
    local MISSILE_MODEL = "Abilities\\Weapons\\PoisonArrow\\PoisonArrowMissile.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetUnitX(target), GetUnitY(target), 25)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.target = target
        missile.damage = DAMAGE
        missile:model(MISSILE_MODEL)
        missile:speed(1500.)
        missile:arc(15.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            Damage.apply(caster, target, DAMAGE, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
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