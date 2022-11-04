OnLibraryInit({name = "BountyControllerUsages", "BountyController"}, function ()
    Bounty.OnDead(function (bounty)
        local dead = Digimon.getInstance(bounty.DyingUnit)
        if dead then
            bounty.Amount = dead:getLevel() * 2 + math.random(1, 5)
        end
        print("aaaaa")
    end)
end)