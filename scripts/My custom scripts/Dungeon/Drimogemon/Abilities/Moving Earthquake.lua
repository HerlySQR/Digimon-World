-- Moving Earthquake
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02F')
    local AREA = 300.
    local DURATION = 14.
    local ROCK_ID = FourCC('o063')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local rock = CreateUnit(owner, ROCK_ID, GetSpellTargetX(), GetSpellTargetY(), 0)
        SetUnitAnimation(rock, "death")
        local eff = AddSpecialEffect("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", GetSpellTargetX(), GetSpellTargetY())
        Timed.echo(1., DURATION, function ()
            SetUnitAnimation(rock, "stand")
            local x, y = GetUnitX(rock), GetUnitY(rock)
            ForUnitsInRange(x, y, AREA, function (u)
                if GetUnitTypeId(u) ~= ROCK_ID then
                    -- Change its target
                    if math.random(100) <= 50 then
                        IssueTargetOrderById(rock, Orders.smart, GetRandomUnitOnRange(x, y, 4*AREA, function (u2) return GetUnitTypeId(u2) ~= ROCK_ID end))
                    end
                    -- Slow
                    if not UnitHasBuffBJ(u, FourCC('Bchd')) then
                        DummyCast( owner, x, y, SLOW_SPELL, SLOW_ORDER, 1, CastType.TARGET, u)
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