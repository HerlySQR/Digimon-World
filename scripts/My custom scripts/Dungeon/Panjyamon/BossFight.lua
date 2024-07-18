Debug.beginFile("Panjyamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O037_0096 ---@type unit

    local iceStompOrder = Orders.stomp

    InitBossFight({
        name = "Panjyamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_13463, gg_dest_Dofv_13464},
        inner = gg_rct_PanjyamonInner,
        entrance = gg_rct_PanjyamonEntrance,
        spells = {
            FourCC('A0DJ'), 20, Orders.breathoffrost, CastType.POINT, -- Ice fist
            FourCC('A0DL'), 20, Orders.berserk, CastType.IMMEDIATE, -- Punch rush
            FourCC('A0DM'), 20, Orders.breathoffire, CastType.POINT, -- Mammothmon rush
            FourCC('A0DN'), 20, Orders.shadowstrike, CastType.TARGET -- Cat jump
        },
        actions = function (u)
            if not BossStillCasting(boss) then
                if math.random(0, 100) <= 20 and DistanceBetweenCoords(GetUnitX(boss), GetUnitY(boss), GetUnitX(u), GetUnitY(u)) <= 300. then
                    IssueImmediateOrderById(boss, iceStompOrder)
                end
            end
        end,
        onStart = function ()
            BlzStartUnitAbilityCooldown(boss, FourCC('A0DM'), 60.)
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