OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A06Y')
    local DELAY = 2.
    local DAMAGE_PER_SHOT = 15.
    local MAX_SHOTS = 20
    local AREA = 300.
    local MISSILE_MODEL = "Abilities\\Weapons\\HarpyMissile\\HarpyMissile.mdl"
    local INTERVAL = 0.03125

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local cx = GetUnitX(caster)
        local cy = GetUnitY(caster)
        local x = GetSpellTargetX()
        local y = GetSpellTargetY()

        BossIsCasting(caster, true)
        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
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
                        BossIsCasting(caster, false)
                        return true
                    end
                    SetUnitAnimation(caster, "spell throw")

                    local angle = 2 * math.pi * math.random()
                    local dist = AREA * math.random()
                    local tx = x + dist * math.cos(angle)
                    local ty = y + dist * math.sin(angle)
                    local missile = Missiles:create(cx, cy, 25, tx, ty, 0)
                    missile.source = caster
                    missile.owner = owner
                    missile.damage = DAMAGE_PER_SHOT
                    missile:model(MISSILE_MODEL)
                    missile:speed(900.)
                    missile:arc(60.)
                    missile.onFinish = function ()
                        ForUnitsInRange(missile.x, missile.y, 128., function (u)
                            if IsUnitEnemy(u, missile.owner) then
                                Damage.apply(caster, u, DAMAGE_PER_SHOT, true, false, udg_Nature, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
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