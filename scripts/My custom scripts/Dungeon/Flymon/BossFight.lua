Debug.beginFile("Flymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O067_0406 ---@type unit

    local CycloneOrder = Orders.cyclone
    local BeserkOrder = Orders.berserk

    InitBossFight({
        name = "Flymon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52785},
        returnPlace = gg_rct_FlymonReturnPlace,
        inner = gg_rct_FlymonInner,
        entrance = gg_rct_FlymonEntrance,
        toTeleport = gg_rct_FlymonToReturn,
        spells = {
            FourCC('A06Z'), 100, Orders.charm, CastType.TARGET, -- Stinger
            FourCC('A06Y'), 50, Orders.blackarrow, CastType.POINT, -- Stinger Shots
            FourCC('A070'), 20, Orders.cloudoffog, CastType.TARGET -- Poison Powder
        },
        actions = function (u)
            if not BossStillCasting(boss) then
                if math.random(0, 100) >= 80 then
                    IssueTargetOrderById(boss, CycloneOrder, u)
                else
                    IssueImmediateOrderById(boss, BeserkOrder)
                end
            end
        end
    })
end)
Debug.endFile()