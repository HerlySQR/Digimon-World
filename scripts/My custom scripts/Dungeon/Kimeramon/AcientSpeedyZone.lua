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
    local TRICERAMON = FourCC('O054')
    local VERMILIMON = FourCC('O064')
    local METEORMON = FourCC('O036')
    local VOLCAMON = FourCC('O056')
    local EXTRA_HEALTH_FACTOR = 0.75
    local EXTRA_DMG_FACTOR = 1.25
    local SLOW = FourCC('')

    local place = gg_rct_Ancient_Speedy_Zone ---@type rect
    local started = false
    local players = Set.create()
    local creeps = {} ---@type unit[]
    local creepTypes = __jarray(0) ---@type integer[]
    local creepLevels = __jarray(0) ---@type integer[]
    local creepLocs = {} ---@type location[]
    local creepFacings = __jarray(0) ---@type number[]
    local triceramons = {} ---@type unit[]
    local triceramonLocs = {} ---@type location[]
    local wall = {gg_dest_Dofw_53415} ---@type destructable[]

    ForUnitsInRect(place, function (u)
        if GetOwningPlayer(u) == Digimon.NEUTRAL then
            table.insert(creeps, u)
            table.insert(creepTypes, GetUnitTypeId(u))
            table.insert(creepLevels, GetHeroLevel(u))
            table.insert(creepLocs, GetUnitLoc(u))
            table.insert(creepFacings, GetUnitFacing(u))
            ZTS_AddThreatUnit(u, false)
            AddUnitBonus(u, BONUS_HEALTH, math.floor(GetUnitState(u, UNIT_STATE_MAX_LIFE) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetAvarageAttack(u) * EXTRA_DMG_FACTOR))

            if GetUnitTypeId(u) == TRICERAMON then
                table.insert(triceramons, u)
                triceramonLocs[u] = GetUnitLoc(u)
                UnitAddAbility(u, SLOW)
            end
        end
    end)

    local text = CreateTextTag()
    SetTextTagPos(text, GetUnitX(NPC), GetUnitY(NPC), 128.)
    SetTextTagVisibility(text, false)

    local tm = CreateTimer()
    local window = CreateTimerDialog(tm)
    TimerDialogSetTitle(window, "Defeat the boss in: ")

    local function resetSewers()
        started = false
        SetTextTagVisibility(text, false)
        UnitRemoveAbility(NPC, RESET_SEWERS)
        TimerDialogDisplay(window, false)

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
                AddUnitBonus(u, BONUS_HEALTH, math.floor(GetUnitState(u, UNIT_STATE_MAX_LIFE) * EXTRA_HEALTH_FACTOR))
                AddUnitBonus(u, BONUS_DAMAGE, math.floor(GetAvarageAttack(u) * EXTRA_DMG_FACTOR))
                creeps[i] = u

                if GetUnitTypeId(u) == DRAGOMON then
                    table.insert(dragomons, u)
                    dragomonsPos[u] = GetUnitLoc(u)
                    UnitAddAbility(u, ESNARE)
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
end)
Debug.endFile()