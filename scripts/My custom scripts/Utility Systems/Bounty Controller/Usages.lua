OnInit(function ()
    Require "BountyController"

    Bounty.OnDead(function (bounty)
        local dead = Digimon.getInstance(bounty.DyingUnit)
        if dead then
            bounty.Amount = dead:getLevel() * 2 + math.random(1, 5)
        end
    end)
end)