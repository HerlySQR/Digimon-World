Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local ScissorMagicChaosOrder = Orders.blackarrow
    local ScissorMagicOrder = Orders.chainlightning
    local InnerFireOrder = Orders.innerfire
    local BeserkOrder = Orders.berserk

    InitBossFight({
        name = "Crabmon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52786},
        returnPlace = gg_rct_CrabmonReturnPlace,
        inner = gg_rct_CrabmonInner,
        entrance = gg_rct_CrabmonEntrance,
        toTeleport = gg_rct_Beach_of_Dragon,
        actions = function (u)
            if not BossStillCasting(boss) then
                local rad = math.random(0, 100)
                if not IssueTargetOrderById(boss, ScissorMagicOrder, u) then
                    if rad <= 29 then
                        IssuePointOrderById(boss, ScissorMagicChaosOrder, GetUnitX(u), GetUnitY(u))
                      elseif 30 <= rad and rad <= 67 then
                        IssueTargetOrderById(boss, InnerFireOrder, boss)
                    elseif rad <= 68 then
                        IssueImmediateOrderById(boss, BeserkOrder)
                      end
                    end
                end
            end
    })
end)
Debug.endFile()