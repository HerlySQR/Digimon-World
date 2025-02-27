Debug.beginFile("Abilities\\Dash")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02E')
    local MAX_DIST = 400.
    local KB_DIST = 150.
    local DAMAGE = 85.
    local COLLISION = 192.
    local INTERVAL = 0.03125

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local angle = math.atan(GetSpellTargetY() - GetUnitY(caster), GetSpellTargetX() - GetUnitX(caster))
        local affected = Set.create()
        BossIsCasting(caster, true)
        local reached = 0
        Timed.echo(INTERVAL, function ()
            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            SetUnitAnimation(caster, "spell three")
            if reached < MAX_DIST then
                x = x + 50 * math.cos(angle)
                y = y + 50 * math.sin(angle)
                if not IsTerrainWalkable(x, y) then
                    ResetUnitAnimation(caster)
                    BossIsCasting(caster, false)
                    return true
                else
                    SetUnitPosition(caster, x, y)
                    ForUnitsInRange(x, y, COLLISION, function (u)
                        if not affected:contains(u) and IsUnitEnemy(u, owner) then
                            affected:addSingle(u)
                            Damage.apply(caster, u, DAMAGE, true, false, udg_Dark, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                            -- Knockback
                            if not IsUnitType(u, UNIT_TYPE_GIANT) then
                                Knockback(
                                    u,
                                    math.atan(GetUnitY(u) - GetUnitY(caster), GetUnitX(u) - GetUnitX(caster)),
                                    KB_DIST,
                                    500.,
                                    "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl",
                                    nil
                                )
                            end
                        end
                    end)
                end
            else
                ResetUnitAnimation(caster)
                BossIsCasting(caster, false)
                return true
            end
            reached = reached + 50
        end)
    end)

end)
Debug.endFile()