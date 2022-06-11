OnMapInit(function ()
    local SPELL = FourCC('A02A')
    local RANGE = 900. -- The same as in the object editor
    local DAMAGE = 5. -- per tick
    local AREA = 128.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local angle = math.atan(ty - y, tx - x)
        local missile = Missiles:create(x, y, 100., x + RANGE * math.cos(angle), y + RANGE * math.sin(angle), 100.)
        missile:model("Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl")
        missile:speed(500.)
        missile:scale(2.)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.collision = AREA
        missile.onHit = function (u)
            missile:flush(u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                UnitDamageTarget(caster, u, DAMAGE, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
            end
        end
        missile:launch()
    end)

end)