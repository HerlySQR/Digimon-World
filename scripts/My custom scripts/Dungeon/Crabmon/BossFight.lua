Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local aquaMagicOrder = Orders.innerfire

    InitBossFight({
        name = "Crabmon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52786},
        returnPlace = gg_rct_CrabmonReturnPlace,
        inner = gg_rct_CrabmonInner,
        entrance = gg_rct_CrabmonEntrance,
        toTeleport = gg_rct_Beach_of_Dragon,
        spells = {
            1, Orders.chainlightning, CastType.TARGET, -- Scissor Magic
            3, Orders.berserk, CastType.IMMEDIATE, -- Berserk
            2, Orders.clusterrockets, CastType.POINT, -- Scissor Magic Chaos
            3, Orders.breathoffire, CastType.TARGET, -- Cutting pliers
        },
        actions = function (u)
            if not BossStillCasting(boss) and GetUnitHPRatio(boss) < 0.5 then
                IssueTargetOrderById(boss, aquaMagicOrder, boss)
            end
        end
    })
end)
Debug.endFile()