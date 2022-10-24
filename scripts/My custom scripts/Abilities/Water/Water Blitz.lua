OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01M')
    local StrDmgFactor = 0.
    local AgiDmgFactor = 0.30
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local Area = 300.
    local MissileModel = "units\\human\\WaterElemental\\WaterElemental.mdl"
    local TargetPointEffect = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
    local TargetEffectUnit = "Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(x, y, 25, GetSpellTargetX(), GetSpellTargetY(), 25)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.damage = damage
        missile:model(MissileModel)
        missile:color(0, 0, 255)
        missile:speed(1100.)
        missile:arc(20.)
        missile.collision = 96.
        missile.collideZ = true
        local function onHitOrFinish(u)
            if not u or (IsUnitEnemy(u, missile.owner) and GetUnitAbilityLevel(u, LOCUST_ID) == 0) then
                DestroyEffect(AddSpecialEffect(TargetPointEffect, missile.x, missile.y))
                ForUnitsInRange(missile.x, missile.y, Area, function (u2)
                    if IsUnitEnemy(u2, missile.owner) then
                        Damage.apply(caster, u, damage, true, false, udg_Water, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                        DestroyEffect(AddSpecialEffectTarget(TargetEffectUnit, u2, "chest"))
                    end
                end)
                return true
            end
        end
        missile.onHit = onHitOrFinish
        missile.onFinish = onHitOrFinish
        missile:launch()
    end)

end)