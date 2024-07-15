Debug.beginFile("Kimeramon\\Abilities\\CycloneClap")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0GC')
    local DELAY = 1.5 -- Same as object editor
    local DISTANCE = 1100.
    local TORNADO = "Abilities\\Spells\\Other\\Tornado\\TornadoElemental.mdl"
    local DUMMY_CYCLONE = FourCC('A0GD')

    local t = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(t, Digimon.VILLAIN, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == SPELL end))
    TriggerAddAction(t, function ()
        local caster = GetSpellAbilityUnit()
        BossIsCasting(caster, true)
        SetUnitAnimation(caster, "spell")

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_AQUA)
        bar:setZOffset(300)
        bar:setSize(1.5)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                BossIsCasting(caster, false)
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            BossIsCasting(caster, false)
            bar:destroy()
        end)
    end)

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local tx, ty = GetSpellTargetX(), GetSpellTargetY()
        local angle = math.atan(ty - y, tx - x)
        for _ = 0, 2 do
            local tornado = Missiles:create(x, y, 0, tx + DISTANCE*math.cos(angle), ty + DISTANCE*math.sin(angle), 0)
            tornado.source = caster
            tornado.owner = GetOwningPlayer(caster)
            tornado:scale(1.2)
            tornado:model(TORNADO)
            tornado:speed(900.)
            tornado.collision = 200.
            tornado.onHit = function (u)
                if IsUnitEnemy(u, tornado.owner) then
                    DummyCast(tornado.owner, GetUnitX(u), GetUnitY(u), DUMMY_CYCLONE, Orders.cyclone, 1, CastType.TARGET, u)
                end
            end
            tornado:launch()
            angle = angle + GetRandomReal(math.pi/6, math.pi/3)
        end
    end)

end)
Debug.endFile()