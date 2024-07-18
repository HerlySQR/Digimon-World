Debug.beginFile("Tonosama Gekomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O012_0067 ---@type unit

    InitBossFight({
        name = "TonosamaGekomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_B082_12252, gg_dest_B082_12254},
        inner = gg_rct_TonosamaGekomonInner,
        entrance = gg_rct_TonosamaGekomonEntrance,
        spells = {
            FourCC('A0BG'), 20, Orders.shockwave, CastType.TARGET, -- Sonic wave
            FourCC('A0BH'), 20, Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Gekomon
            FourCC('A0DM'), 20, Orders.summonwareagle, CastType.IMMEDIATE, -- Summon Otamamon
            FourCC('A0BK'), 20, Orders.inferno, CastType.POINT -- Big leap
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()