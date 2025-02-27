Debug.beginFile("Panjyamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O037_0096 ---@type unit

    local iceFist = FourCC('A0DJ')
    local iceStomp = FourCC('A0DK')

    InitBossFight({
        name = "Panjyamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_13463, gg_dest_Dofv_13464},
        inner = gg_rct_PanjyamonInner,
        entrance = gg_rct_PanjyamonEntrance,
        spells = {
            FourCC('A0DN'), 6, Orders.shadowstrike, CastType.TARGET, -- Cat jump
            FourCC('A0DL'), 2, Orders.berserk, CastType.IMMEDIATE, -- Punch rush
            FourCC('A0DJ'), 0, Orders.breathoffrost, CastType.POINT, -- Ice fist
            FourCC('A0DN'), 5, Orders.shadowstrike, CastType.TARGET, -- Cat jump
            FourCC('A0DK'), 0, Orders.stomp, CastType.IMMEDIATE, -- Ice stomp
            FourCC('A0DM'), 2, Orders.breathoffire, CastType.POINT -- Mammothmon rush
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, iceFist)
                UnitAddAbility(boss, iceStomp)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, iceFist)
            UnitRemoveAbility(boss, iceStomp)
        end
    })

    -- Ice aura
    local BUFF = FourCC('B01N')
    local owner = GetOwningPlayer(boss)
    local battlefield = {} ---@type rect[]
    local i = 1
    while true do
        -- To be sure that the target is inside the bossfight area
        if not rawget(_G, "gg_rct_Panjyamon_" .. i) then
            break
        end
        battlefield[i] = rawget(_G, "gg_rct_Panjyamon_" .. i)
        i = i + 1
    end

    ---@param u unit
    local function CheckEnemies(u)
        if IsUnitEnemy(u, owner) and not UnitHasBuffBJ(u, BUFF) then
            DummyCast(owner, GetUnitX(u), GetUnitY(u), SLOW_SPELL, SLOW_ORDER, 3, CastType.TARGET, u)
            Damage.apply(boss, u, 2.5, false, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
        end
    end

    Timed.echo(0.5, function ()
        if UnitAlive(boss) then
            for j = 1, #battlefield do
                ForUnitsInRect(battlefield[j], CheckEnemies)
            end
        end
    end)
end)
Debug.endFile()