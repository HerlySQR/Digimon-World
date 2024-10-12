Debug.beginFile("Tonosama Gekomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O012_0067 ---@type unit

    local summonOtamamon = FourCC('A0DM')
    local aquaMagic = FourCC('A0AC')

    InitBossFight({
        name = "TonosamaGekomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_B082_12252, gg_dest_B082_12254},
        inner = gg_rct_TonosamaGekomonInner,
        entrance = gg_rct_TonosamaGekomonEntrance,
        spells = {
            3, Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Gekomon
            0, Orders.howlofterror, CastType.IMMEDIATE, -- Howl
            3, Orders.inferno, CastType.POINT, -- Big leap
            4, Orders.summonwareagle, CastType.IMMEDIATE, -- Summon Otamamon
            4, Orders.shockwave, CastType.TARGET -- Sonic wave
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, aquaMagic)
                UnitAddAbility(boss, summonOtamamon)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, aquaMagic)
            UnitRemoveAbility(boss, summonOtamamon)
        end
    })
end)
Debug.endFile()