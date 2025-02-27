Debug.beginFile("Master Tyranomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O008_0081 ---@type unit

    local hungry = FourCC('A0AG')

    InitBossFight({
        name = "MasterTyranomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_12250},
        inner = gg_rct_MasterTyranomonInner,
        entrance = gg_rct_MasterTyranomonEntrance,
        spells = {
            FourCC('A07L'), 3, Orders.roar, CastType.IMMEDIATE, -- War cry
            FourCC('A0AG'), 0, 852623, CastType.TARGET, -- Hungry
            FourCC('A02A'), 3, Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A0B2'), 4, Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Tyranomon
            FourCC('A0B1'), 4, Orders.roar, CastType.IMMEDIATE, -- Tower of fire
            FourCC('A0E3'), 3, Orders.flamestrike, CastType.TARGET, -- Flame wave
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, hungry)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, hungry)
        end
    })
end)
Debug.endFile()