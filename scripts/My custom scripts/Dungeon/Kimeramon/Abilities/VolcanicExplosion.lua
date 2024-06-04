Debug.beginFile("Kimeramon\\Abilities\\VolcanicExplosion")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A0GA')
    local MIN_RANGE = 50.
    local MAX_RANGE = 325.
    local AREA = 128.
    local DMG = 100.
    local ROCK = "Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local i = -1
        Timed.echo(0.02, 0.09, function ()
            i = i + 1
            Timed.echo(0.02, 0.09, function ()
                local angle = math.pi/2 * (i + math.random())
                local dist = GetRandomReal(MIN_RANGE, MAX_RANGE)
                local x, y = GetUnitX(caster), GetUnitY(caster)

                local rock = Missiles:create(x, y, 160., x + dist * math.cos(angle), y + dist * math.sin(angle), 0)
                rock:model(ROCK)
                rock.owner = owner
                rock:speed(300.)
                rock:arc(53.)
                rock.damage = DMG + 0.5 * GetHeroStr(caster, true)
                rock.onFinish = function ()
                    ForUnitsInRange(rock.x, rock.y, AREA, function (u)
                        if IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                            Damage.apply(caster, u, rock.damage, false, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                            -- Stun
                            DummyCast(
                                owner,
                                GetUnitX(caster), GetUnitY(caster),
                                STUN_SPELL,
                                STUN_ORDER,
                                2,
                                CastType.TARGET,
                                u
                            )
                        end
                    end)
                end
                rock:launch()
            end)
        end)
    end)
end)
Debug.endFile()