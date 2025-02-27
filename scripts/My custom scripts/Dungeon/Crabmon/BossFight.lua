Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local aquaMagicOrder = Orders.innerfire
    local aquaMagicBuff = FourCC('B01D')

    InitBossFight({
        name = "Crabmon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52786},
        inner = gg_rct_CrabmonInner,
        entrance = gg_rct_CrabmonEntrance,
        spells = {
            FourCC('A0H6'), 1, Orders.chainlightning, CastType.TARGET, -- Scissor Magic
            FourCC('A074'), 3, Orders.berserk, CastType.IMMEDIATE, -- Berserk
            FourCC('A0C4'), 2, Orders.clusterrockets, CastType.POINT, -- Scissor Magic Chaos
            FourCC('A0GV'), 3, Orders.breathoffire, CastType.TARGET, -- Cutting pliers
        },
        actions = function (u)
            if not BossStillCasting(boss) and GetUnitAbilityLevel(boss, aquaMagicBuff) == 0 and GetUnitHPRatio(boss) < 0.5 then
                IssueTargetOrderById(boss, aquaMagicOrder, boss)
            end
        end
    })
end)
Debug.endFile()