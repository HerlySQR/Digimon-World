Debug.beginFile("Crabmon\\Abilities\\Scissor Magic Chaos")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0C4')
    local DELAY = 2.5
    local DAMAGE_PER_SHOT = 32.
    local MAX_SHOTS = 12
    local AREA = 175.
    local MISSILE_MODEL = "Missile\\BubbleMissile.mdx"
    local INTERVAL = 0.03125

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetSpellTargetX()
        local y = GetSpellTargetY()

        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(250)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            bar:destroy()
            if UnitAlive(caster) then
                local counter = MAX_SHOTS
                Timed.echo(INTERVAL, function ()
                    if counter == 0 then
                        PauseUnit(caster, false)
                        ResetUnitAnimation(caster)
                        return true
                    end
                    SetUnitAnimation(caster, "spell throw")

                    local angle = 2 * math.pi * math.random()
                    local dist = AREA * math.random()
                    local tx = x + dist * math.cos(angle)
                    local ty = y + dist * math.sin(angle)
                    local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, tx, ty, 0)
                    missile.source = caster
                    missile.owner = owner
                    missile.damage = DAMAGE_PER_SHOT
                    missile:model(MISSILE_MODEL)
                    missile:speed(900.)
                    missile:arc(60.)
                    missile.onFinish = function ()
                        ForUnitsInRange(missile.x, missile.y, 128., function (u)
                            if IsUnitEnemy(u, missile.owner) then
                                Damage.apply(caster, u, DAMAGE_PER_SHOT, true, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                    end
                    missile:launch()
                    counter = counter - 1
                end)
            end
        end)
    end)
end)
Debug.endFile()