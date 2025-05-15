Debug.beginFile("Datamon\\Abilities\\Shocking Orbs")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0JN')
    local DELAY = 2.5
    local DAMAGE_PER_ORB = {300., 800.}
    local ORBS = {4, 5}
    local COLISION = 192.
    local MISSILE_MODEL = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl"
    local MAX_DISTANCE = 900.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)

        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_CYAN)
        bar:setZOffset(450)
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
                PauseUnit(caster, false)
                SetUnitAnimation(caster, "spell throw")
                local count = ORBS[GetUnitAbilityLevel(caster, SPELL)]
                local x = GetUnitX(caster)
                local y = GetUnitY(caster)
                for i = 1, count do
                    local angle = (i + math.random()) * (2 * math.pi / count)
                    local tx = x + MAX_DISTANCE * math.cos(angle)
                    local ty = y + MAX_DISTANCE * math.sin(angle)
                    local missile = Missiles:create(x, y, 25, tx, ty, 25)
                    missile.source = caster
                    missile.owner = owner
                    missile.damage = DAMAGE_PER_ORB[GetUnitAbilityLevel(caster, SPELL)]
                    missile.collision = COLISION
                    missile:model(MISSILE_MODEL)
                    missile:arc(0.)
                    missile:speed(200.)
                    missile.onPeriod = function ()
                        if missile.Speed < 900. then
                            missile:speed(missile.Speed + 25.)
                        end
                    end
                    missile.onHit = function (u)
                        if IsUnitEnemy(u, missile.owner) then
                            Damage.apply(caster, u, missile.damage, true, false, udg_Machine, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                            DummyCast(owner, GetUnitX(u), GetUnitY(u), PURGE_SPELL, PURGE_ORDER, 1, CastType.TARGET, u)
                        end
                    end
                    missile:launch()
                end
            end
        end)
    end)
end)
Debug.endFile()