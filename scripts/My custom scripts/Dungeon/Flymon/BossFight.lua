OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O067_0406 ---@type unit

    local brownStingerShotsOrder = Orders.blackarrow
    local brownStingerOrder = Orders.charm
    local poisonPowderOrder = Orders.cloudoffog
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
        actions = function (u)
            if not BossStillCasting(boss) then
                if not IssueTargetOrderById(boss, brownStingerOrder, u) then
                local rad = math.random(0, 100)
                    if rad <= 50 then
                        IssuePointOrderById(boss, brownStingerShotsOrder, GetUnitX(u), GetUnitY(u))
                    elseif rad > 50 and rad < 80 then
                        IssueImmediateOrderById(boss, BeserkOrder)
                    elseif rad >= 80 then
                        IssueTargetOrderById(boss, CycloneOrder, u)
                    end
                end
            end
        end
    })
end)