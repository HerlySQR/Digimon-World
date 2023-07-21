Debug.beginFile("Tonosama Gekomon\\Abilities\\Sonic Wave")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BG')
    local RANGE = 900.
    local DAMAGE = 70.
    local DISTANCE_PUSH = 250.
    local AREA = 250.
    local MISSILE_MODEL = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
    local PUSH_MODEL = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local angle = math.atan(ty - y, tx - x)
        local missile = Missiles:create(x, y, 50., x + RANGE * math.cos(angle), y + RANGE * math.sin(angle), 50.)
        missile:model(MISSILE_MODEL)
        missile:speed(900.)
        missile:scale(2.5)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.collision = AREA
        missile:alpha(127)
        missile.onHit = function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                UnitDamageTarget(caster, u, DAMAGE, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                -- Knockback
                if not IsUnitType(u, UNIT_TYPE_GIANT) then
                    Knockback(
                        u,
                        math.atan(GetUnitY(u) - missile.y, GetUnitX(u) - missile.x),
                        DISTANCE_PUSH,
                        500.,
                        PUSH_MODEL,
                        nil
                    )
                end
            end
        end
        missile:launch()
    end)
end)
Debug.endFile()