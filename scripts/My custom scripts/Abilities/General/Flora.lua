OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02X')
    local DummySpell = FourCC('A02Y')
    local Chance = 5
    local Duration = 3 -- The same as is in the object editor
    local DAMAGE = 10.

    Digimon.postDamageEvent:register(function (info)
        local source = info.source ---@type Digimon
        local target = info.target ---@type Digimon
        if source:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                DummyCast(source:getOwner(), source:getX(), source:getY(), DummySpell, Orders.entanglingroots, 1, CastType.TARGET, target.root)
                local count = Duration
                Timed.echo(1, function ()
                    Damage.apply(source.root, target.root, DAMAGE, false, false, udg_Nature, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                    count = count - 1
                    if count == 0 then
                        return true
                    end
                end)
            end
        end
    end)
end)