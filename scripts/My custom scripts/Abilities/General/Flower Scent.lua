OnMapInit(function ()
    local Spell = FourCC('A03D')
    local Chance = 15
    local IntDmgFactor = 0.5
    local Duration = 2. -- The same as is in the object editor

    Digimon.postDamageEvent(function (info)
        local target = info.target ---@type Digimon
        if target:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                local source = info.source.root ---@type unit
                target = target.root ---@type unit
                -- Sleep
                DummyCast(GetOwningPlayer(target),
                    GetUnitX(target), GetUnitY(target),
                    SLEEP_SPELL,
                    SLEEP_ORDER,
                    2,
                    CastType.TARGET,
                    source)
                -- Damage over time
                local dmg = IntDmgFactor * GetHeroInt(target, true)
                Timed.echo(function (node)
                    if node.elapsed < Duration then
                        Damage.apply(target, source, dmg, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
                    else
                        return true
                    end
                end, 1.)
            end
        end
    end)
end)