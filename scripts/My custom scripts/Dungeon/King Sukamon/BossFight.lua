Debug.beginFile("King Sukamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00X_0101 ---@type unit
    local healingMinions = FourCC('A0B8')

    InitBossFight({
        name = "KingSukamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52792, gg_dest_Dofw_12379},
        inner = gg_rct_KingSukamonInner,
        entrance = gg_rct_KingSukamonEntrance,
        spells = {
            FourCC('A0B9'), 3, Orders.firebolt, CastType.TARGET, -- Generic Missile
            FourCC('A0BB'), 4, Orders.healingward, CastType.POINT, -- Ward of damage
            FourCC('A0B8'), 0, Orders.spiritwolf, CastType.IMMEDIATE, -- Healing Minions
            FourCC('A0D4'), 5, Orders.blackarrow, CastType.POINT -- Poop Chaos
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, healingMinions)
            end
        end,
        onStart = function ()
            -- Delay the use of the Healing Minions
            UnitRemoveAbility(boss, healingMinions)
        end
    })
end)
Debug.endFile()