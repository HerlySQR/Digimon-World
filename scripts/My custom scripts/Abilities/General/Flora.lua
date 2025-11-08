OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02X')
    local DummyEsnare = FourCC('A02Y')
    local DummySlow = FourCC('A0IJ')
    local Chance = 15
    local Duration = 2 -- The same as is in the object editor
    local IntDmgFactor = 0.25

    Digimon.postDamageEvent:register(function (info)
        local source = info.source ---@type Digimon
        local target = info.target ---@type Digimon
        if source:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                if IsUnitType(target.root, UNIT_TYPE_ANCIENT) then
                    DummyCast(source:getOwner(), source:getX(), source:getY(), DummySlow, Orders.slow, 1, CastType.TARGET, target.root)
                else
                    DummyCast(source:getOwner(), source:getX(), source:getY(), DummyEsnare, Orders.entanglingroots, 1, CastType.TARGET, target.root)
                end
                local dmg = (1 + IntDmgFactor * GetHeroInt(source.root, true))
                local count = Duration
                Timed.echo(1, function ()
                    Damage.apply(source.root, target.root, dmg, false, false, udg_Nature, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                    count = count - 1
                    if count == 0 then
                        return true
                    end
                end)
            end
        end
    end)
end)