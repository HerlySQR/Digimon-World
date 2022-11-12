OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A035')
    local Chance = 20

    Digimon.postDamageEvent(function (info)
        local source = info.source ---@type Digimon
        if source:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                -- Purge
                DummyCast(source:getOwner(),
                source:getX(), source:getY(),
                PURGE_SPELL,
                PURGE_ORDER,
                1,
                CastType.TARGET,
                info.target.root)
            end
        end
    end)
end)