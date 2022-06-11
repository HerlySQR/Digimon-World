OnMapInit(function ()
    local Spell = FourCC('A025')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local DmgPerSecFactor = 0.15
    -- The same as it is in the object editor
    local Area = 400.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetSpellTargetX(), GetSpellTargetY(), 0)
        missile.source = caster
        missile.owner = owner
        missile.damage = damage
        missile:model("Abilities\\Weapons\\Mortar\\MortarMissile.mdl")
        missile:speed(900.)
        missile:arc(25.)
        missile.collision = 96.
        missile.collideZ = true
        missile.onFinish = function ()
            ForUnitsInRange(missile.x, missile.y, Area, function (u)
                if IsUnitEnemy(u, missile.owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                end
            end)
            -- Start the spell
            local mx = missile.x
            local my = missile.y
            local dur = 5
            local offset = Area * 0.75
            local dmgPerSec = damage * DmgPerSecFactor
            Timed.echo(function ()
                if dur > 0 then
                    dur = dur - 1
                    -- Effects
                    DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl", mx, my))
                    for i = 1, 6 do
                        local angle = (math.pi / 3) * i
                        local x = mx + offset * math.cos(angle)
                        local y = my + offset * math.sin(angle)
                        DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\FlyingMachine\\FlyingMachineImpact.mdl", x, y))
                    end
                    -- Enum the enemies
                    ForUnitsInRange(mx, my, Area, function (u)
                        if IsUnitEnemy(u, missile.owner) then
                            Damage.apply(caster, u, dmgPerSec, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                else
                    return true
                end
            end, 1.)
        end
        missile:launch()
    end)

end)