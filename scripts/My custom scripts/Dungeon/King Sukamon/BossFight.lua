Debug.beginFile("King Sukamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00X_0101 ---@type unit

    local missileOrder = Orders.firebolt

    InitBossFight({
        name = "KingSukamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52792, gg_dest_Dofw_12379},
        returnPlace = gg_rct_KingSukamonReturnPlace,
        inner = gg_rct_KingSukamonInner,
        entrance = gg_rct_KingSukamonEntrance,
        toTeleport = gg_rct_KingSukamonToReturn,
        spells = {
            FourCC('A0B8'), 30, Orders.spiritwolf, CastType.IMMEDIATE, -- Healing Minions
            FourCC('A0D4'), 40, Orders.blackarrow, CastType.POINT, -- Poop Chaos
            FourCC('A0BB'), 30, Orders.healingward, CastType.POINT -- Ward of damage
        },
        actions = function (u)
            if not BossStillCasting(boss) then
                IssueTargetOrderById(boss, missileOrder, u)
            end
        end,
        onStart = function ()
            -- Delay the use of the Healing Minions
            BlzStartUnitAbilityCooldown(boss, FourCC('A0B8'), 80.)
        end
    })
end)
Debug.endFile()