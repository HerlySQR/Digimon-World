Debug.beginFile("Tonosama Gekomon\\Abilities\\Sound Wave")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0E4')
    local DISTANCE = 700. -- The same as in the object editor
    local DAMAGE = 650.
    local DAMAGE_PER_SEC = 20.
    local AREA = 156.
    local DELAY = 2. -- Same as object editor
    local birdOfFireOrder = Orders.flamestrike

    RegisterSpellChannelEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) or GetUnitCurrentOrder(caster) ~= birdOfFireOrder then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            bar:destroy()
        end)
    end)

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local angle = math.atan(ty - y, tx - x)
        local missile = Missiles:create(x, y, 50., x + DISTANCE * math.cos(angle), y + DISTANCE * math.sin(angle), 50.)
        missile:model("Missile\\SoundWave.mdx")
        missile:speed(800.)
        missile:scale(1.)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.collision = AREA
        missile.onHit = function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                UnitDamageTarget(caster, u, DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                local eff = AddSpecialEffectTarget("Effect\\SparkleStampedeMissileDeath.mdx", u, "chest")
                Timed.echo(1., 4., function ()
                    UnitDamageTarget(caster, u, DAMAGE_PER_SEC, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                end, function ()
                    DestroyEffect(eff)
                end)
            end
        end
        missile:launch()
    end)
end)
Debug.endFile()