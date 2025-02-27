-- Fire Ball attack
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02A')
    local StrDmgFactor = 0.07
    local AgiDmgFactor = 0.07
    local IntDmgFactor = 0.07
    local DmgPerTickFactor = 0.5
    local RANGE = 400. -- The same as in the object editor
    local DAMAGE = 1.0 -- per tick
    local AREA = 128.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local damagen = (GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) + DAMAGE) * DmgPerTickFactor
        local angle = math.atan(ty - y, tx - x)
        local missile = Missiles:create(x, y, 100., x + RANGE * math.cos(angle), y + RANGE * math.sin(angle), 100.)
        missile:model("Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
        missile:speed(500.)
        missile:scale(2.)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.collision = AREA
        missile.onHit = function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                UnitDamageTarget(caster, u, damagen, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                missile:flush(u)
            end
        end
        missile:launch()
    end)
end)