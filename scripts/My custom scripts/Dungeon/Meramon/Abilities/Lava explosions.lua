OnLibraryInit("BossFightUtils", function ()
    local SPELL = FourCC('A02B')
    local DURATION = 10. -- seconds
    local DAMAGE = 100. -- per explosion
    local MIN_DIST = 128.
    local AREA = 500.
    local AREA_EXP = 150.
    local INTERVAL = 0.5

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        BossIsCasting(caster, true)
        Timed.echo(function (node)
            if node.elapsed < DURATION then
                for _ = 1, math.random(1, 4) do
                    local angle = 2 * math.pi * math.random()
                    local dist = MIN_DIST + AREA * math.random()
                    local x = GetUnitX(caster) + dist * math.cos(angle)
                    local y = GetUnitY(caster) + dist * math.sin(angle)
        
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl", x, y))
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl", x, y))
        
                    ForUnitsInRange(x, y, AREA_EXP, function (u)
                        if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                            UnitDamageTarget(caster, u, DAMAGE, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                end
            else
                BossIsCasting(caster, false)
                return true
            end
        end, INTERVAL)
    end)
end)