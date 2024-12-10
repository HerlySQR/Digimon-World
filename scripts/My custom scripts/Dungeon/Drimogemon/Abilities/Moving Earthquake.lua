Debug.beginFile("Abilities\\Drimogemon\\Moving Earthquake")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02F')
    local AREA = 300.
    local DURATION = 14.
    local ROCK_ID = FourCC('o063')

    local nodes = GetRects("MovingEarthQuakeNode")

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local rock = CreateUnit(owner, ROCK_ID, GetSpellTargetX(), GetSpellTargetY(), 0)
        SetUnitAnimation(rock, "death")
        local eff = AddSpecialEffect("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", GetSpellTargetX(), GetSpellTargetY())
        local actNode = 0
        local options = Set.create()
        Timed.echo(1., DURATION, function ()
            SetUnitAnimation(rock, "stand")
            if math.random(3) == 3 then
                for i = 1, #nodes do
                    if i ~= actNode then
                        options:addSingle(i)
                    end
                end
                actNode = options:random()
                IssuePointOrderById(rock, Orders.move, GetRectCenterX(nodes[actNode]), GetRectCenterY(nodes[actNode]))
            end
            local x, y = GetUnitX(rock), GetUnitY(rock)
            ForUnitsInRange(x, y, AREA, function (u)
                if IsUnitEnemy(u, owner) then
                    -- Slow
                    if not UnitHasBuffBJ(u, FourCC('Bchd')) then
                        DummyCast(owner, x, y, SLOW_SPELL, SLOW_ORDER, 1, CastType.TARGET, u)
                    end
                end
            end)
            BlzSetSpecialEffectPosition(eff, x, y, BlzGetLocalSpecialEffectZ(eff))
        end, function ()
            DestroyEffect(eff)
            KillUnit(rock)
        end)
    end)
end)
Debug.endFile()