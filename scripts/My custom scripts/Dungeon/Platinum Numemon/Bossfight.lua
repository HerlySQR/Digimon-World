Debug.beginFile("Platinum Numemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_H04V_0175 ---@type unit

    InitBossFight({
        name = "PlatinumNumemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_B082_53321},
        returnPlace = gg_rct_Leave_Sewers,
        inner = gg_rct_PlatinumNumemonInner,
        entrance = gg_rct_PlatinumNumemonEntrance,
        toTeleport = gg_rct_Sewers,
        actions = function (u)
        end,
        onDeath = function ()
            local owners = CreateForce()
            ForUnitsInRect(gg_rct_PlatinumNumemon_1, function (u)
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    ForceAddPlayer(owners, GetOwningPlayer(u))
                end
            end)
            ForForce(owners, function ()
                CreateItem(RARE_DATA, GetUnitX(boss), GetUnitY(boss))
            end)
            DestroyForce(owners)
        end
    })
end)
Debug.endFile()