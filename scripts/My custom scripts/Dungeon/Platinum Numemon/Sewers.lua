Debug.beginFile("Platinum Numemon\\Sewers")
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
    local MAX_TIME = 3600.
    local RESET_SEWERS = FourCC('A0G2')
    local NPC = gg_unit_N02H_0159 ---@type unit
    local RAREMON = FourCC('O02C')
    local DRAGOMON = FourCC('O023')
    local BLACK_KING_NUMEMON = FourCC('O03Q')
    local RAREMON_SUMMON_EFFECT = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
    local MAX_RAREMON_PER_RECT = 20
    local BOSSFIGHT_PLACE = gg_rct_PlatinumNumemon_1 ---@type rect
    local RAREMON_BAIT = FourCC('A0G0')
    local ESNARE = FourCC('A0G3')
    local ESNARE_BUFF = FourCC('Beng')
    local ESNARE_ORDER = Orders.ensnare
    local SUMMON_RAREMON_TICK = 2. -- seconds
    local EXTRA_HEALTH_FACTOR = 3.
    local EXTRA_DMG_FACTOR = 3.
    local EXTRA_ARMOR = 15
    local EXTRA_MANA_REGEN = 5
    local RAREMON_EXPLOSION_DAMAGE = 500.
    local FRENZY = FourCC('A0G8')
    local FRENZY_BUFF = FourCC('B02S')

    local boss = gg_unit_H04V_0175 ---@type unit
    local place = gg_rct_Sewers ---@type rect
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
    local summonings = MDTable.create(2) ---@type Digimon[][]
    local summonPlaces = {gg_rct_Sewers_Summons_1, gg_rct_Sewers_Summons_2, gg_rct_Sewers_Summons_3, gg_rct_Sewers_Summons_4} ---@type rect[]
    local summonPlacesCheck = {} ---@type rect[]
    local summonCounts = __jarray(0) ---@type integer[]
    local exploding =  __jarray(false) ---@type table<Digimon, boolean>
    local dragomons = {} ---@type unit[]
    local dragomonsPos = {} ---@type table<unit, location>
    local wall = {gg_dest_B082_53390, gg_dest_Dofw_53389} ---@type destructable[]
    local canReset = false
    local summonRaremonCurrent = 0.

    for i, r in ipairs(summonPlaces) do
        local w, h = GetRectWidthBJ(r), GetRectHeightBJ(r)
        summonPlacesCheck[i] = Rect(GetRectMinX(r) - w, GetRectMinY(r) - h, GetRectMaxX(r) + w, GetRectMaxY(r) + h)
    end

    ForUnitsInRect(place, function (u)
        if GetOwningPlayer(u) == Digimon.NEUTRAL then
            table.insert(creeps, u)
            table.insert(creepTypes, GetUnitTypeId(u))
            table.insert(creepLevels, GetHeroLevel(u))
            table.insert(creepLocs, GetUnitLoc(u))
            table.insert(creepFacings, GetUnitFacing(u))
            ZTS_AddThreatUnit(u, false)
            AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)

            if GetUnitTypeId(u) == DRAGOMON then
                table.insert(dragomons, u)
                dragomonsPos[u] = GetUnitLoc(u)
                UnitAddAbility(u, ESNARE)
            elseif GetUnitTypeId(u) == BLACK_KING_NUMEMON then
                AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetBaseAttack(u) * EXTRA_DMG_FACTOR))
                AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)
                AddUnitBonus(u, BONUS_MANA_REGEN, EXTRA_MANA_REGEN)
                SetUnitScale(u, 1.5, 0, 0)
                SetUnitVertexColor(u, 255, 100, 100, 255)
            end
        end
    end)

    local text = CreateTextTag()
    SetTextTagPos(text, GetUnitX(NPC), GetUnitY(NPC), 128.)
    SetTextTagVisibility(text, false)

    local tm = CreateTimer()
    --local window = CreateTimerDialog(tm)
    --TimerDialogSetTitle(window, "Defeat the boss in: ")

    local function resetSewers()
        started = false
        SetTextTagVisibility(text, false)
        UnitRemoveAbility(NPC, RESET_SEWERS)
        --TimerDialogDisplay(window, false)

        if not UnitAlive(boss) then
            ReviveHero(boss, GetUnitX(boss), GetUnitY(boss), true)
        end

        for i, u in ipairs(creeps) do
            if UnitAlive(u) then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitPositionLoc(u, creepLocs[i])
                BlzSetUnitFacingEx(u, creepFacings[i])
            else
                if GetUnitTypeId(u) ~= 0 then
                    RemoveUnit(u)
                end
                u = CreateUnitAtLoc(Digimon.NEUTRAL, creepTypes[i], creepLocs[i], creepFacings[i])
                SetHeroLevel(u, creepLevels[i], false)
                ZTS_AddThreatUnit(u, false)
                AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)
                creeps[i] = u

                if GetUnitTypeId(u) == DRAGOMON then
                    table.insert(dragomons, u)
                    dragomonsPos[u] = GetUnitLoc(u)
                    UnitAddAbility(u, ESNARE)
                elseif GetUnitTypeId(u) == BLACK_KING_NUMEMON then
                    AddUnitBonus(u, BONUS_STRENGTH, math.floor(GetHeroStr(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_AGILITY, math.floor(GetHeroAgi(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_INTELLIGENCE, math.floor(GetHeroInt(u, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetBaseAttack(u) * EXTRA_DMG_FACTOR))
                    AddUnitBonus(u, BONUS_ARMOR, EXTRA_ARMOR)
                    AddUnitBonus(u, BONUS_MANA_REGEN, EXTRA_MANA_REGEN)
                    SetUnitScale(u, 1.5, 0, 0)
                    SetUnitVertexColor(u, 255, 100, 100, 255)
                end
            end
            SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
        end

        for i = 1, #summonPlaces do
            for j = summonCounts[i], 1, -1 do
                local d = summonings[i][j]
                if d:isAlive() then
                    d:destroy()
                end
                table.remove(summonings[i], j)
            end
            summonCounts[i] = 0
        end

        if IsDestructableDeadBJ(wall[1]) then
            for _, d in ipairs(wall) do
                ModifyGateBJ(bj_GATEOPERATION_CLOSE, d)
            end
        end
    end

    local function startSewers()
        started = true
        TimerStart(tm, MAX_TIME, false, resetSewers)
        SetTextTagVisibility(text, true)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, NPC, EVENT_UNIT_SPELL_EFFECT)
        TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == RESET_SEWERS end))
        TriggerAddAction(t, function ()
            PauseTimer(tm)
            resetSewers()
        end)
    end

    local function check(d)
        local p = d.owner
        if IsPlayerInGame(p) and IsUnitType(d.root, UNIT_TYPE_HERO) then
            actHeros:addSingle(d)
            players:addSingle(p)
            heros[p] = heros[p] + 1
        end
    end

    Timed.echo(1.5, function ()
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

        if not players:isEmpty() then
            players:clear()
        end

        Digimon.enumInRect(place, check)

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

        --if UnitAlive(boss) then
            --TimerDialogDisplay(window, players:contains(GetLocalPlayer()))
        --end

        if not started and players:size() > 0 then
            startSewers()
        end

        if started then
            if players:isEmpty() then
                if not canReset then
                    canReset = true
                    UnitAddAbility(NPC, RESET_SEWERS)
                end
            else
                if canReset then
                    canReset = false
                    UnitRemoveAbility(NPC, RESET_SEWERS)
                end
            end
        end

        -- Summon raremons
        summonRaremonCurrent = summonRaremonCurrent + 1
        if summonRaremonCurrent >= SUMMON_RAREMON_TICK then
            summonRaremonCurrent = 0

            for i, r in ipairs(summonPlacesCheck) do
                local summoned = false
                ForUnitsInRect(r, function (u)
                    if not summoned and summonCounts[i] < MAX_RAREMON_PER_RECT and RectContainsUnit(place, u) and not RectContainsUnit(BOSSFIGHT_PLACE, u) and IsPlayerInGame(GetOwningPlayer(u)) then
                        local l = GetRandomLocInRect(summonPlaces[i])
                        local d = Digimon.create(Digimon.NEUTRAL, RAREMON, GetLocationX(l), GetLocationY(l), GetRandomReal(0, 360))
                        DestroyEffect(AddSpecialEffectLoc(RAREMON_SUMMON_EFFECT, l))
                        RemoveLocation(l)

                        d.isSummon = true
                        d:setLevel(85)
                        SetUnitMoveSpeed(d.root, 250)
                        SetUnitScale(d.root, 0.6 * BlzGetUnitRealField(d.root, UNIT_RF_SCALING_VALUE), 0, 0)
                        ZTS_AddThreatUnit(d.root, false)
                        SetUnitState(d.root, UNIT_STATE_MANA, 0)
                        BlzSetUnitRealField(d.root, UNIT_RF_SELECTION_SCALE, 0.6 * BlzGetUnitRealField(d.root, UNIT_RF_SELECTION_SCALE))
                        BlzSetUnitRealField(d.root, UNIT_RF_MANA_REGENERATION, 0)
                        BlzSetUnitRealField(d.root, UNIT_RF_SHADOW_IMAGE_WIDTH, 0.6 * BlzGetUnitRealField(d.root, UNIT_RF_SHADOW_IMAGE_WIDTH))
                        BlzSetUnitRealField(d.root, UNIT_RF_SHADOW_IMAGE_HEIGHT, 0.6 * BlzGetUnitRealField(d.root, UNIT_RF_SHADOW_IMAGE_HEIGHT))
                        BlzSetUnitRealField(d.root, UNIT_RF_SELECTION_SCALE, 0.6 * BlzGetUnitRealField(d.root, UNIT_RF_SELECTION_SCALE))
                        AddUnitBonus(d.root, BONUS_DAMAGE, 15)

                        summonCounts[i] = summonCounts[i] + 1
                        summonings[i][summonCounts[i]] = d
                        summoned = true
                    end
                    for j = summonCounts[i], 1, -1 do
                        local d = summonings[i][j]
                        ZTS_ModifyThreat(u, d.root, 10., true)
                    end
                end)

                for j = summonCounts[i], 1, -1 do
                    local d = summonings[i][j]
                    local remove = false

                    if not exploding[d] then
                        if math.random(10) == 1 then
                            exploding[d] = true
                            d:pause()
                            local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl", d.root, "overhead")
                            BlzSetSpecialEffectScale(eff, 3.)
                            DestroyEffectTimed(eff, SUMMON_RAREMON_TICK)
                        end
                    else
                        if d:isAlive() then
                            local x, y = d:getPos()
                            ForUnitsInRange(x, y, 300., function (u)
                                if IsUnitEnemy(d.root, GetOwningPlayer(u)) then
                                    Damage.apply(d.root, u, RAREMON_EXPLOSION_DAMAGE, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                                elseif GetUnitTypeId(u) == RAREMON then
                                    SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) - RAREMON_EXPLOSION_DAMAGE)
                                end
                            end)
                            DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Demon\\DemonLargeDeathExplode\\DemonLargeDeathExplode.mdl", x, y))
                            DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\Mortar\\MortarMissile.mdl", x, y))
                        end
                        d:destroy()
                    end

                    if not d:isAlive() then
                        remove = true
                    elseif not ZTS_GetCombatState(d.root) then
                        d:destroy()
                        remove = true
                    end

                    if remove then
                        table.remove(summonings[i], j)
                        summonCounts[i] = summonCounts[i] - 1
                        exploding[d] = nil
                    end
                end
            end
        end

        if not prevHeros:isEmpty() then
            prevHeros:clear()
        end
        if not actHeros:isEmpty() then
            prevHeros:addAll(actHeros)
            actHeros:clear()
        end
    end)

    local attractionPoints = SyncedTable.create() ---@type table<Digimon, {remain: number, x: number, y: number}>

    -- Raremon bait
    RegisterSpellEffectEvent(RAREMON_BAIT, function ()
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        Digimon.enumInRange(x, y, 1500., function (d)
            if d:getTypeId() == RAREMON and d:getOwner() == Digimon.NEUTRAL then
                if not attractionPoints[d] then
                    attractionPoints[d] = {}
                end
                attractionPoints[d].remain = 6.
                attractionPoints[d].x = x
                attractionPoints[d].y = y
            end
        end)
    end)

    Timed.echo(1.5, function ()
        for d, data in pairs(attractionPoints) do
            d:issueOrder(Orders.move, data.x, data.y)
            data.remain = data.remain - 0.5
            if data.remain <= 0 then
                attractionPoints[d] = nil
            end
        end
    end)

    -- Cast esnare

    local inRange = MDTable.create(2, false) ---@type table<unit, table<unit, boolean>>

    Timed.echo(2., function ()
        for i = #dragomons, 1, -1 do
            if UnitAlive(dragomons[i]) then
                local x, y = GetLocationX(dragomonsPos[dragomons[i]]), GetLocationY(dragomonsPos[dragomons[i]])
                ForUnitsInRange(x, y, 900, function (u)
                    if IsPlayerInGame(GetOwningPlayer(u)) then
                        local d = DistanceBetweenCoords(x, y, GetUnitX(u), GetUnitY(u))
                        if d < 700. then
                            inRange[dragomons[i]][u] = true
                        elseif inRange[dragomons[i]][u] and not UnitHasBuffBJ(u, ESNARE_BUFF) then
                            inRange[dragomons[i]] = nil
                            IssueTargetOrderById(dragomons[i], ESNARE_ORDER, u)
                        end
                    end
                end)
            else
                RemoveLocation(dragomonsPos[dragomons[i]])
                dragomonsPos[dragomons[i]] = nil
                table.remove(dragomons, i)
            end
        end
    end)

    -- Drop items
    do
        local t = CreateTrigger()
        TriggerRegisterPlayerUnitEvent(t, Digimon.NEUTRAL, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(t, Condition(function () return RectContainsUnit(place, GetDyingUnit()) end))
        TriggerAddAction(t, function ()
            if not GetKillingUnit() then
                return
            end
            if GetUnitTypeId(GetDyingUnit()) == BLACK_KING_NUMEMON then
                if math.random(5) == 1 then
                    CreateItem(udg_SewersItems[math.random(#udg_SewersItems)], GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()))
                end

                local open = true
                ForUnitsInRect(place, function (u)
                    if GetUnitTypeId(u) == BLACK_KING_NUMEMON and UnitAlive(u) then
                        open = false
                    end
                end)

                if open then
                    for _, d in ipairs(wall) do
                        ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
                    end
                end
            else
                if math.random(20) == 1 then
                    CreateItem(udg_SewersItems[math.random(#udg_SewersItems)], GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()))
                end
            end
        end)
    end

    -- Frenzy

    Timed.echo(2., function ()
        local function checkFrenzy(u)
            if GetUnitTypeId(u) == BLACK_KING_NUMEMON then
                if GetUnitHPRatio(u) < 0.55 then
                    if GetUnitAbilityLevel(u, FRENZY) == 0 then
                        UnitAddAbility(u, FRENZY)
                    end
                else
                    if GetUnitAbilityLevel(u, FRENZY) > 0 then
                        UnitRemoveAbility(u, FRENZY)
                    end
                end
            end
        end

        ForUnitsInRect(place, checkFrenzy)
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterPlayerUnitEvent(t, Digimon.NEUTRAL, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        TriggerRegisterPlayerUnitEvent(t, Digimon.NEUTRAL, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
        TriggerRegisterPlayerUnitEvent(t, Digimon.NEUTRAL, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
        TriggerAddCondition(t, Condition(function ()
            return GetUnitTypeId(GetOrderedUnit()) == BLACK_KING_NUMEMON and GetUnitAbilityLevel(GetOrderedUnit(), FRENZY) > 0
        end))
        TriggerAddAction(t, function ()
            if not ZTS_IsEvent() then
                return
            end
            DisableTrigger(t)
            IssueImmediateOrderById(GetOrderedUnit(), Orders.frenzy)
            EnableTrigger(t)
        end)
    end

    local counters = __jarray(0) ---@type table<unit, integer>
    RegisterSpellEffectEvent(FRENZY, function ()
        local caster = GetSpellAbilityUnit()
        if counters[caster] <= 0 then
            AddUnitBonus(caster, BONUS_DAMAGE, 15)
            AddUnitBonus(caster, BONUS_ARMOR, 10)
            SetUnitScale(caster, 2., 0, 0)
            SetUnitVertexColor(caster, 255, 20, 20, 255)
            Timed.echo(1., function ()
                counters[caster] = counters[caster] - 1
                if counters[caster] <= 0 or not UnitAlive(caster) then
                    AddUnitBonus(caster, BONUS_DAMAGE, -15)
                    AddUnitBonus(caster, BONUS_ARMOR, -10)
                    SetUnitVertexColor(caster, 255, 100, 100, 255)
                    SetUnitScale(caster, 1.5, 0, 0)
                    return true
                end
            end)
        end
        counters[caster] = math.floor(BlzGetAbilityRealLevelField(GetSpellAbility(), ABILITY_RLF_DURATION_NORMAL, 0))
    end)

    -- Reset when the boss dies
    do
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, boss, EVENT_UNIT_DEATH)
        TriggerAddAction(t, function ()
            PauseTimer(tm)
            --TimerDialogDisplay(window, false)
            Timed.call(16., function ()
                ReviveHero(boss, GetUnitX(boss), GetUnitY(boss), true)
                resetSewers()
            end)
        end)
    end
end)
Debug.endFile()