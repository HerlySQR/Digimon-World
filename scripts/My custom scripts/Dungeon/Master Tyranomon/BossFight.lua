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
        returnPlace = gg_rct_MasterTyranomonReturnPlace,
        inner = gg_rct_MasterTyranomonInner,
        entrance = gg_rct_MasterTyranomonEntrance,
        toTeleport = gg_rct_MasterTyranomonToReturn,
        spells = {
            3, Orders.roar, CastType.IMMEDIATE, -- War cry
            0, 852623, CastType.TARGET, -- Hungry
            3, Orders.firebolt, CastType.TARGET, -- Fire ball
            4, Orders.spiritwolf, CastType.IMMEDIATE, -- Tower of fire
            3, 25, Orders.flamestrike, CastType.TARGET, -- Flame wave
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