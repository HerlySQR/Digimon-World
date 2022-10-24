OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01H')
    local StrDmgFactor = 0.30
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local MissileModel = "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl"
    -- The same as it is in the object editor
    local Area = 400.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetSpellTargetX(), GetSpellTargetY(), 0)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.damage = damage
        missile:model(MissileModel)
        missile:speed(1100.)
        missile:arc(20.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            ForUnitsInRange(missile.x, missile.y, Area, function (u)
                if IsUnitEnemy(u, missile.owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                end
            end)
        end
        missile:launch()
    end)

end)