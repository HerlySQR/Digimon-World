OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A03B')
    local AgiDmgFactor = 1.
    local Duration = 3
    local Chance = 15

    Digimon.postDamageEvent:register(function (info)
        local source = info.source ---@type Digimon

        if udg_IsDamageAttack and source:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                local target = info.target.root
                source = source.root ---@type unit
                local count = Duration
                -- Slow
                DummyCast(GetOwningPlayer(source), GetUnitX(source), GetUnitY(source), SLOW_SPELL, SLOW_ORDER, 2, CastType.TARGET, target)
                -- --
                Timed.echo(function ()
                    Damage.apply(source, target, AgiDmgFactor * GetHeroAgi(source), false, false, udg_Beast, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    count = count - 1
                    if count <= 0 then
                        return true
                    end
                end, 1.)
            end
        end
    end)
end)