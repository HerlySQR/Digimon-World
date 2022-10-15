OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01I')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local DmgPerSecFactor = 0.1

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
        missile:model("Abilities\\Spells\\Other\\FrostBolt\\FrostBoltMissile.mdl")
        missile:speed(1000.)
        missile:arc(0)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            Damage.apply(caster, target, damage, true, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
            -- Ice effect
            DummyCast(missile.owner,
                      GetUnitX(caster), GetUnitY(caster),
                      ICE_SPELL,
                      ICE_ORDER,
                      1,
                      CastType.TARGET,
                      target)
        end
        missile:launch()
    end)
    
end)