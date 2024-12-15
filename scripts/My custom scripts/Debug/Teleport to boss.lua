Debug.beginFile("Teleport to boss")
OnInit(function ()
    Require "DigimonBank"

    local points = {
        ["Numemon"] = {11773, -29682, "Sewers"},
        ["PlatinumNumemon"] = {11773, -29682, "Sewers"},
        ["Crabmon"] = {-3712, -8452, "Native Forest"},
        ["Drimogemon"] = {-30469, -30719, "Drill Tunnel"},
        ["Flymon"] = {8096, -12800, "Native Forest"},
        ["Gekomon"] = {-29319, 8580, "Geko Swamp"},
        ["TonosamaGekomon"] = {-29319, 8580, "Geko Swamp"},
        ["Sukamon"] = {-30209, 900, "Trash Mountain"},
        ["KingSukamon"] = {-30209, 900, "Trash Mountain"},
        ["Meramon"] = {-25092, -21754, "Lava Tunnel"},
        ["Tyranomon"] = {26876, -16000, "Ancient Dino Region"},
        ["Cherrymon"] = {-25217, 20604, "Misty Trees"},
        ["Datamon"] = {-26241, -10616, "Factorial Town"},
        ["Garudamon"] = {17784, 20355, "Great Canyon"},
        ["Kimeramon"] = {26000, 4857, "Ancient Speedy Zone"},
        ["Mamemon"] = {-8963, 6390, "Gear Savanna"},
        ["MegaSeadramon"] = {18809, -3453, "Tropical Jungle"},
        ["Seadramon"] = {18809, -3453, "Tropical Jungle"},
        ["Panjyamon"] = {-6660, 22799, "Freezeland"},
        ["Skull Satamon"] = {-9614, -16125, "Bettleland"},
        ["Satamon"] = {-9614, -16125, "Bettleland"}
    }

    local t = CreateTrigger()
    ForForce(bj_FORCE_ALL_PLAYERS, function ()
        TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-boss ", false)
    end)
    TriggerAddCondition(t, Condition(function ()
        return GetEventPlayerChatString():sub(1, 6) == "-boss "
    end))
    TriggerAddAction(t, function ()
        local data = points[GetEventPlayerChatString():sub(7)]
        if data then
            local p = GetTriggerPlayer()
            local list = GetUsedDigimons(p)
            if #list > 0 then
                for _, d in ipairs(list) do
                    d.environment = Environment.get(data[3])
                    d:setPos(data[1], data[2])
                end
                Environment.apply(data[3], p, true)
                PanCameraToTimedForPlayer(p, data[1], data[2], 0)
            end
        end
    end)
end)
Debug.endFile()