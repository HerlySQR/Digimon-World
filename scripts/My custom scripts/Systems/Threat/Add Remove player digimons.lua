Debug.beginFile("Add player threat units")
OnInit(function ()
    Require "Digimon"
    Require "Threat System"

    Digimon.createEvent:register(function (new)
        if GetPlayerController(new:getOwner()) == MAP_CONTROL_USER then
            Threat.addPlayerUnit(new.root)
        end
    end)

    Digimon.changeOwnerEvent:register(function (d, newOwner)
        if IsPlayerInForce(newOwner, FORCE_PLAYING) then
            Threat.addPlayerUnit(d.root)
        end
    end)

    Digimon.evolutionEvent:register(function (new)
        if GetPlayerController(new:getOwner()) == MAP_CONTROL_USER then
            Threat.addPlayerUnit(new.root)
        end
    end)

    Digimon.destroyEvent:register(function (old)
        if GetPlayerController(old:getOwner()) == MAP_CONTROL_USER then
            Threat.removePlayerUnit(old.root)
        else
            Threat.removeNPC(old.root)
        end
    end)
end)
Debug.endFile()