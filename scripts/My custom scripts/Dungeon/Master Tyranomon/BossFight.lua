Debug.beginFile("Master Tyranomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O008_0081 ---@type unit

    local towerOfFireOrder = Orders.roar
    local fireBallOrder = Orders.firebolt
    local summonTyranomonOrder = Orders.spiritwolf
    local birdOfFireOrder = Orders.flamestrike

    InitBossFight({
        name = "MasterTyranomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_12250},
        returnPlace = gg_rct_MasterTyranomonReturnPlace,
        inner = gg_rct_MasterTyranomonInner,
        entrance = gg_rct_MasterTyranomonEntrance,
        toTeleport = gg_rct_MasterTyranomonToReturn,
        actions = function (u)
            if not BossStillCasting(boss) then
                local rad = math.random(0, 100)
                if rad <= 25 then
                    local face = math.deg(math.atan(GetUnitY(u) - GetUnitY(boss), GetUnitX(u) - GetUnitX(boss)))
                    SetUnitFacing(boss, face)
                    Timed.call(0.9, function ()
                        IssueImmediateOrderById(boss, towerOfFireOrder)
                    end)
                elseif rad > 25 and rad <= 50 then
                    IssueTargetOrderById(boss, fireBallOrder, u)
                elseif rad > 50 and rad <= 75 then
                    IssueTargetOrderById(boss, birdOfFireOrder, u)
                elseif rad > 75 then
                    IssueImmediateOrderById(boss, summonTyranomonOrder)
                end
            end
        end
    })
end)
Debug.endFile()