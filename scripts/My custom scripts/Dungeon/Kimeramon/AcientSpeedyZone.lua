Debug.beginFile("AcientSpeedyZone")
OnInit.final(function ()
    Require "DigimonBank"
    Require "Set"
    Require "GameStatus"
    Require "MDTable"
    Require "SyncedTable"
    Require "NewBonus"
    Require "PlayerUtils"
    Require "AbilityUtils"

    local MAX_HEROS = 2
    local MAX_TIME = 5400.
    local NPC = gg_unit_N02I_0192 ---@type unit
    local BOSS = gg_unit_O06V_0193 ---@type unit
    local ENTER = FourCC('I05Y')
    local TRICERAMON = FourCC('O054')
    local VERMILIMON = FourCC('O064')
    local METEORMON = FourCC('O036')
    local VOLCAMON = FourCC('O056')
    local EXTRA_HEALTH_FACTOR = 0.75
    local EXTRA_DMG_FACTOR = 6.25
    local EXTRA_ARMOR = 5
    local EXTRA_MANA_REGEN = 5
    local SLOW = FourCC('A0G9')
    local SLOW_BUFF = FourCC('B02T')
    local THROW_ROCK = FourCC('ACtb')
    local STUN = FourCC('BPSE')
    local VOLCANIC_EXPLOSION = FourCC('A0GA')
    local VOLCANIC_EXPLOSION_ORDER = Orders.summongrizzly

    local boss = gg_unit_O06V_0193 ---@type unit
    local place = gg_rct_Ancient_Speedy_Zone ---@type rect
    local started = false
    local players = Set.create()
    local heros = __jarray(0) ---@type integer[]
    local prevHeros = Set.create()
    local actHeros = Set.create()
    local creeps = {} ---@type unit[]
    local creepTypes = __jarray(0) ---@type integer[]
    local creepLevels = __jarray(0) ---@type integer[]
    local creepLocs = {} ---@type location[]
    local creepFacings = __jarray(0) ---@type number[]
    local specialCasters = {} ---@type unit[]
    local specialCastersLocs = {} ---@type table<unit, location>
    local specialCasterSpells = {[TRICERAMON] = SLOW, [METEORMON] = THROW_ROCK} ---@type table<integer, integer>
    local specialCasterOrders = {[TRICERAMON] = Orders.slow, [METEORMON] = Orders.creepthunderbolt} ---@type table<integer, integer>
    local specialCasterBuffs = {[TRICERAMON] = SLOW_BUFF, [METEORMON] = STUN} ---@type table<integer, integer>
    local volcamons = {} ---@type unit[]
    local wall = {gg_dest_Dofw_53415} ---@type destructable[]
    local summonPlace = gg_rct_ASRSummonCreeps
    local summonTrigger = gg_rct_ASRSummonCreepsTrigger
    local ambushed = false
    local ambushUnits = CreateGroup()

    do
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, BOSS, EVENT_UNIT_DEATH)
        TriggerAddAction(t, function ()
            RemoveItemFromStock(NPC, ENTER)
        end)

        t = CreateTrigger()
        TriggerRegisterUnitEvent(t, BOSS, EVENT_UNIT_HERO_REVIVE_FINISH)
        TriggerAddAction(t, function ()
            AddItemToStock(NPC, ENTER, 1, 1)
        end)
    end

    ForUnitsInRect(place, function (u)
        if GetOwningPlayer(u) == Digimon.NEUTRAL then
            local typ = GetUnitTypeId(u)

            table.insert(creeps, u)
            table.insert(creepTypes, typ)
            table.insert(creepLevels, GetHeroLevel(u))
            table.insert(creepLocs, GetUnitLoc(u))
            table.insert(creepFacings, GetUnitFacing(u))
            ZTS_AddThreatUnit(u, false)
            AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetAvarageAttack(u) * EXTRA_DMG_FACTOR))

            if typ == TRICERAMON or typ == METEORMON then
                table.insert(specialCasters, u)
                specialCastersLocs[u] = GetUnitLoc(u)
                UnitAddAbility(u, specialCasterSpells[typ])
            elseif typ == VOLCAMON then
                table.insert(volcamons, u)
                UnitAddAbility(u, VOLCANIC_EXPLOSION)
                AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetBaseAttack(u) * EXTRA_DMG_FACTOR))
                AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)
                AddUnitBonus(u, BONUS_MANA_REGEN, EXTRA_MANA_REGEN)
                SetUnitScale(u, 1.2, 0, 0)
                SetUnitVertexColor(u, 255, 100, 100, 255)
            end
        end
    end)

    local text = CreateTextTag()
    SetTextTagPos(text, GetUnitX(NPC), GetUnitY(NPC), 128.)
    SetTextTagVisibility(text, false)

    local tm = CreateTimer()
    local window = CreateTimerDialog(tm)
    TimerDialogSetTitle(window, "Defeat the boss in: ")

    local function resetAcientSpeedyZone()
        started = false
        PauseTimer(tm)
        SetTextTagVisibility(text, false)
        TimerDialogDisplay(window, false)

        if not UnitAlive(boss) then
            ReviveHero(boss, GetUnitX(boss), GetUnitY(boss), true)
        end

        for i, u in ipairs(creeps) do
            if UnitAlive(u) then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitPositionLoc(u, creepLocs[i])
                BlzSetUnitFacingEx(u, creepFacings[i])
            else
                local typ = GetUnitTypeId(u)

                if typ ~= 0 then
                    RemoveUnit(u)
                end

                u = CreateUnitAtLoc(Digimon.NEUTRAL, creepTypes[i], creepLocs[i], creepFacings[i])
                SetHeroLevel(u, creepLevels[i], false)
                ZTS_AddThreatUnit(u, false)
                AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetAvarageAttack(u) * EXTRA_DMG_FACTOR))
                creeps[i] = u

                if typ == TRICERAMON or typ == METEORMON then
                    table.insert(specialCasters, u)
                    specialCastersLocs[u] = GetUnitLoc(u)
                    UnitAddAbility(u, specialCasterSpells[typ])
                elseif typ == VOLCAMON then
                    table.insert(volcamons, u)
                    UnitAddAbility(u, VOLCANIC_EXPLOSION)
                    AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetBaseAttack(u) * EXTRA_DMG_FACTOR))
                    AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)
                    AddUnitBonus(u, BONUS_MANA_REGEN, EXTRA_MANA_REGEN)
                    SetUnitScale(u, 1.2, 0, 0)
                    SetUnitVertexColor(u, 255, 100, 100, 255)
                end
            end
            SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
        end

        if IsDestructableDeadBJ(wall[1]) then
            for _, d in ipairs(wall) do
                ModifyGateBJ(bj_GATEOPERATION_CLOSE, d)
            end
        end

        ambushed = false

        local u = FirstOfGroup(ambushUnits)
        while u do
            GroupRemoveUnit(ambushUnits, u)
            RemoveUnit(u)
            u = FirstOfGroup(ambushUnits)
        end
    end

    local function startAcientSpeedyZone()
        started = true
        TimerStart(tm, MAX_TIME, false, resetAcientSpeedyZone)
        SetTextTagVisibility(text, true)
    end

    Timed.echo(1., function ()
        -- Set time
        local time = TimerGetRemaining(tm)
        if time > 0 then
            local hours = math.floor(time/3600);
            local mins = math.floor(time/60 - (hours*60));
            local secs = math.floor(time - hours*3600 - mins *60);
            SetTextTagText(text, ("\x2502.f:\x2502.f:\x2502.f"):format(hours, mins, secs), 0.023)
        end

        -- Check player units in region
        for p in players:elements() do
            SetMaxUsableDigimons(p)
            heros[p] = 0
        end

        players:clear()

        Digimon.enumInRect(place, function (d)
            local p = d.owner
            if IsPlayerInGame(p) and IsUnitType(d.root, UNIT_TYPE_HERO) then
                actHeros:addSingle(d)
                players:addSingle(p)
                heros[p] = heros[p] + 1
            end
        end)

        local newHeros = actHeros:except(prevHeros)
        for d in newHeros:elements() do
            local p = d.owner
            if heros[p] > MAX_HEROS then
                heros[p] = heros[p] - 1
                StoreToBank(p, d, true)
            end
        end

        for p in players:elements() do
            if heros[p] == 0 then
                players:removeSingle(p)
            else
                SetMaxUsableDigimons(p, MAX_HEROS)
            end
        end

        if UnitAlive(boss) then
            TimerDialogDisplay(window, players:contains(GetLocalPlayer()))
        end

        if not started and players:size() > 0 then
            startAcientSpeedyZone()
        end

        if started then
            if players:isEmpty() then
                resetAcientSpeedyZone()
            end
        end

        -- Move creeps
        for _, u in ipairs(creeps) do
            local typ = GetUnitTypeId(u)
            if (typ == TRICERAMON or typ == VERMILIMON) and not ZTS_GetCombatState(u) and GetUnitCurrentOrder(u) == 0 and math.random(5) == 1 then
                local angle = 2*math.pi*math.random()
                local dist = GetRandomReal(200., 600.)
                local newX, newY = GetUnitX(u) + dist*math.cos(angle), GetUnitY(u) + dist*math.sin(angle)

                if IsTerrainWalkable(newX, newY) then
                    IssuePointOrderById(u, Orders.smart, newX, newY)
                end
            end
        end

        prevHeros:clear()
        prevHeros:addAll(actHeros)
        actHeros:clear()
    end)

    -- Drop items
    do
        local t = CreateTrigger()
        TriggerRegisterPlayerUnitEvent(t, Digimon.NEUTRAL, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(t, Condition(function () return GetUnitTypeId(GetDyingUnit()) == VOLCAMON end))
        TriggerAddAction(t, function ()
            CreateItem(udg_AcientSpeedyZoneItems[math.random(#udg_AcientSpeedyZoneItems)], GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()))

            local open = true
            ForUnitsInRect(place, function (u)
                if GetUnitTypeId(u) == VOLCAMON and UnitAlive(u) then
                    open = false
                end
            end)

            if open then
                for _, d in ipairs(wall) do
                    ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
                end
            end
        end)
    end

    -- Cast spells

    local inRange = MDTable.create(2, false) ---@type table<unit, table<unit, boolean>>

    Timed.echo(1., function ()
        for i = #specialCasters, 1, -1 do
            if UnitAlive(specialCasters[i]) then
                local typ = GetUnitTypeId(specialCasters[i])
                local x, y = GetLocationX(specialCastersLocs[specialCasters[i]]), GetLocationY(specialCastersLocs[specialCasters[i]])
                ForUnitsInRange(x, y, 900, function (u)
                    if IsPlayerInGame(GetOwningPlayer(u)) then
                        local d = DistanceBetweenCoords(x, y, GetUnitX(u), GetUnitY(u))
                        if d < 700. then
                            inRange[specialCasters[i]][u] = true
                        elseif inRange[specialCasters[i]][u] and not UnitHasBuffBJ(u, specialCasterBuffs[typ]) then
                            inRange[specialCasters[i]] = nil
                            IssueTargetOrderById(specialCasters[i], specialCasterOrders[typ], u)
                        end
                    end
                end)
            else
                RemoveLocation(specialCastersLocs[specialCasters[i]])
                specialCastersLocs[specialCasters[i]] = nil
                table.remove(specialCasters, i)
            end
        end
        for i = #volcamons, 1, -1 do
            if UnitAlive(volcamons[i]) then
                local x, y = GetUnitX(volcamons[i]), GetUnitY(volcamons[i])
                local cast = false
                if GetUnitHPRatio(volcamons[i]) < 0.9 then
                    ForUnitsInRange(x, y, 275., function (u)
                        if IsUnitEnemy(u, Digimon.NEUTRAL) then
                            cast = true
                        end
                    end)
                end
                if cast then
                    IssueImmediateOrderById(volcamons[i], VOLCANIC_EXPLOSION_ORDER)
                end
            else
                table.remove(volcamons, i)
            end
        end
    end)

    -- Summon ambush
    do
        local t = CreateTrigger()
        TriggerRegisterEnterRectSimple(t, summonTrigger)
        TriggerAddCondition(t, Condition(function ()
            return not ambushed and IsPlayerInGame(GetOwningPlayer(GetEnteringUnit()))
        end))
        TriggerAddAction(t, function ()
            ambushed = true
            local sep = math.random(5)
            for i = 1, 5 do
                local u = CreateUnit(Digimon.NEUTRAL, i <= sep and TRICERAMON or VERMILIMON, GetRectCenterX(summonTrigger), GetRectCenterY(summonTrigger), bj_UNIT_FACING)
                SetHeroLevel(u, 95, false)
                AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetAvarageAttack(u) * EXTRA_DMG_FACTOR))
                GroupAddUnit(ambushUnits, u)
                ZTS_AddThreatUnit(u, true)
                ZTS_ModifyThreat(GetEnteringUnit(), u, 1, true)
                SetUnitX(u, GetRectCenterX(summonPlace))
                SetUnitY(u, GetRectCenterY(summonPlace))
            end
            GroupPointOrderById(ambushUnits, Orders.attack, GetRectCenterX(summonTrigger), GetRectCenterY(summonTrigger))
        end)
    end
end)
Debug.endFile()