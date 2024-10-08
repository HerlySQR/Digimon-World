Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local ScissorMagicOrder = Orders.chainlightning
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
            FourCC('A0C4'), 29, Orders.clusterrockets, CastType.POINT, -- Scissor Magic Chaos
            FourCC('A07A'), 32, Orders.berserk, CastType.IMMEDIATE, -- Berserk
            FourCC('A0GV'), 40, Orders.breathoffire, CastType.TARGET, -- Cutting pliers
        },
        actions = function (u)
            if not BossStillCasting(boss) then
                if not IssueTargetOrderById(boss, ScissorMagicOrder, u) then
                    IssueTargetOrderById(boss, aquaMagicOrder, boss)
                end
            end
        end
    })
end)
Debug.endFile()