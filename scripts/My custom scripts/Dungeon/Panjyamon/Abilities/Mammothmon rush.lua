Debug.beginFile("Panjyamon\\Abilities\\Mammothmon rush")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DM')
    local DAMAGE = 500.
    local DURATION = 8. -- Same as object editor
    local MAMOTHMON_SPEED = 200.
    local MAMOTHMON_MODEL = "war3mapImported\\MammonDMO - optimized.mdl"
    local EXPLOSION_MODEL = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    local MAX_DIST = 1050.
    local MAX_DIST_2 = MAX_DIST/2
    local ORDER = Orders.breathoffire

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local face = math.rad(GetUnitFacing(caster))

        BossIsCasting(caster, true)

        Timed.echo(0.4, DURATION, function ()
            if not UnitAlive(caster) or GetUnitCurrentOrder(caster) ~= ORDER then
                BossIsCasting(caster, false)
                return true
            end
            local angle = math.pi/4 * (-1 + 2*math.random())
            local convAngle = angle + face
            local oppConvAngle = math.pi - angle + face
            local mammothmon = Missiles:create(x + MAX_DIST_2*math.cos(oppConvAngle), y + MAX_DIST_2*math.sin(oppConvAngle), 0,
                                               x + MAX_DIST_2*math.cos(convAngle), y + MAX_DIST_2*math.sin(convAngle), 0)
            mammothmon:model(MAMOTHMON_MODEL)
            mammothmon:speed(MAMOTHMON_SPEED)
            mammothmon:scale(0.4)
            mammothmon:animation(5)
            mammothmon.collision = 32.
            mammothmon.owner = owner
            mammothmon.source = caster
            mammothmon:color(127, 127, 127)
            mammothmon.onHit = function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, DAMAGE, false, false, udg_Beast, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffect(EXPLOSION_MODEL, mammothmon.x, mammothmon.y))
                    mammothmon:alpha(0)
                    return true
                end
            end
            mammothmon.onFinish = function ()
                mammothmon:alpha(0)
            end
            mammothmon:launch()
        end, function ()
            BossIsCasting(caster, false)
        end)
    end)
end)
Debug.endFile()