Debug.beginFile("Megaseadramon\\Abilities\\Cold Storm")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A00Z')
    local EFF1 = FourCC('SNhs') -- Northrend snow (heavy)
    local EFF2 = FourCC('WOcw') -- Outland wind (heavy)
    local AREA = 600.
    local DAMAGE = 10.
    local DURATION = 10.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the storm
        local re = Rect(x - 512, y - 512, x + 512, y + 512)
        local eff1 = AddWeatherEffect(re, EFF1)
        local eff2 = AddWeatherEffectSaveLast(re, EFF2)
        EnableWeatherEffect(eff1, true)
        EnableWeatherEffect(eff2, true)

        Timed.call(1., function ()
            Timed.echo(1., DURATION, function ()
                ForUnitsInRange(x, y, AREA, function (u)
                    if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                        Damage.apply(caster, u, DAMAGE, true, false, udg_Water, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                        DummyCast(owner, GetUnitX(u), GetUnitY(u), ICE_SPELL, ICE_ORDER, 2, CastType.TARGET, u)
                    end
                end)
            end, function ()
                RemoveWeatherEffect(eff1)
                RemoveWeatherEffect(eff2)
                RemoveRect(re)
            end)
        end)
    end)

end)
Debug.endFile()