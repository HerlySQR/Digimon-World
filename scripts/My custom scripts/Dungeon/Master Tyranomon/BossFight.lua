Debug.beginFile("Master Tyranomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O008_0081 ---@type unit

    local towerOfFireOrder = Orders.roar

    InitBossFight({
        name = "MasterTyranomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_12250},
        returnPlace = gg_rct_MasterTyranomonReturnPlace,
        inner = gg_rct_MasterTyranomonInner,
        entrance = gg_rct_MasterTyranomonEntrance,
        toTeleport = gg_rct_MasterTyranomonToReturn,
        spells = {
            FourCC('A02A'), 25, Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A0E3'), 25, Orders.flamestrike, CastType.TARGET, -- Flame wave
            FourCC('A0B2'), 25, Orders.spiritwolf, CastType.IMMEDIATE -- Tower of fire
        },
        actions = function (u)
            if not BossStillCasting(boss) then
                if math.random(0, 100) <= 25 then
                    local face = math.deg(math.atan(GetUnitY(u) - GetUnitY(boss), GetUnitX(u) - GetUnitX(boss)))
                    SetUnitFacing(boss, face)
                    Timed.call(0.9, function ()
                        IssueImmediateOrderById(boss, towerOfFireOrder)
                    end)
                end
            end
        end
    })
end)
Debug.endFile()