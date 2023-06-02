OnInit(function ()
    Require "Digimon"
    Require "ZTS"

    Digimon.createEvent:register(function (new)
        if GetPlayerController(new:getOwner()) == MAP_CONTROL_USER then
            ZTS_AddPlayerUnit(new.root)
        end
    end)

    Digimon.destroyEvent:register(function (old)
        if GetPlayerController(old:getOwner()) == MAP_CONTROL_USER then
            ZTS_RemovePlayerUnit(old.root)
        end
    end)
end)