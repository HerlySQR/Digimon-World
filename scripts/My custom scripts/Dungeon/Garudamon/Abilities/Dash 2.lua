Debug.beginFile("Garudamon\\Abilities\\Dash 2")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BN')
    local MAX_DIST = 700.
    local DAMAGE = 270.
    local COLLISION = 192.
    local INTERVAL = 0.03125

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local angle = math.atan(GetSpellTargetY() - GetUnitY(caster), GetSpellTargetX() - GetUnitX(caster))
        local affected = Set.create()
        SetUnitPathing(caster, false)
        local reached = 0
        Timed.echo(INTERVAL, 1, function ()
            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            SetUnitAnimation(caster, "walk")
            if reached < MAX_DIST then
                x = x + 50 * math.cos(angle)
                y = y + 50 * math.sin(angle)
                if not IsTerrainWalkable(x, y) then
                    ResetUnitAnimation(caster)
                    return true
                else
                    SetUnitPosition(caster, x, y)
                    ForUnitsInRange(x, y, COLLISION, function (u)
                        if not affected:contains(u) and IsUnitEnemy(u, owner) then
                            affected:addSingle(u)
                            Damage.apply(caster, u, DAMAGE, true, false, udg_Air, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                            -- Slow
                            DummyCast(owner, GetUnitX(caster), GetUnitY(caster), SLOW_SPELL, SLOW_ORDER, 2, CastType.TARGET, u)
                        end
                    end)
                end
            else
                ResetUnitAnimation(caster)
                SetUnitPathing(caster, true)
                return true
            end
            reached = reached + 50
        end)
    end)

end)
Debug.endFile()