OnMapInit(function ()
    local Spell = FourCC('A01F')
    local StrDmgFactor = 0.30
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local MaxRange = 700.
    local FreezeChance = 25
    -- The ice slow is a gameplay constant

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local angle = math.atan(GetSpellTargetY() - y, GetSpellTargetX() - x)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(x, y, 25, x + MaxRange * math.cos(angle), y + MaxRange * math.sin(angle), 25)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.damage = damage
        missile:model("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveMissile.mdl")
        missile:speed(1050.)
        missile:arc(0)
        missile.collision = 150.
        missile:scale(1.)
        missile.collideZ = true
        missile.onPeriod = function ()
            --[[
                Grow the wave up to the double of the original size
                The calculations are (considering the period = 0.025 seconds)
                700 max range / 1050 speed / period = aprox 27 instances

                150 / 27 = aprox 5.56
                1 / 27 = aprox 0.04
            ]]
            missile.collision = missile.collision + 5.56
            missile:scale(missile.Scale + 0.04)
        end
        missile.onHit = function (u)
            if IsUnitEnemy(u, missile.owner) and GetUnitAbilityLevel(u, LOCUST_ID) == 0 then
                Damage.apply(caster, u, damage, true, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                -- Ice effect
                DummyCast(missile.owner, GetUnitX(caster), GetUnitY(caster), ICE_SPELL, ICE_ORDER, 1, CastType.TARGET, u)
                -- Freeze effect
                local chance = math.random(0, 100)
                if chance <= FreezeChance then
                    DummyCast(missile.owner, GetUnitX(caster), GetUnitY(caster), FREEZE_SPELL, FREEZE_ORDER, 1, CastType.TARGET, u)
                end
            end
        end
        missile:launch()
    end)

end)