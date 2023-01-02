OnInit("DigimonEvolution", function ()
    Require "Digimon"
    Require "Digimon Capture"

    local EvolveDialog = {} ---@type table<player, dialog>
    local EvolveClicked = __jarray(-1) ---@type table<player, integer>
    local EvolveOption = {} ---@type table<player, button>[]

    -- Evolution abilities

    EvolveAbil = FourCC('A02H')
    EvolveAbilDis = FourCC('A02I')

    -- Register when a digimon enters/leaves in a rect for evolution

    local regions = {} ---@type table<rect, region>

    local rectsE = {} ---@type table<rect, trigger>

    ---@param r rect
    ---@param callback fun(evolve: Digimon)
    local function RegisterEnterRect(r, callback)
        local t = rectsE[r]
        if not t then
            t = CreateTrigger()
            local rg = regions[r]
            if not rg then
                rg = CreateRegion()
                RegionAddRect(rg, r)
                regions[r] = rg
            end
            TriggerRegisterEnterRegion(t, rg)
            rectsE[r] = t
        end
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetEnteringUnit())
            if d then
                callback(d)
            end
        end)
    end

    local rectsL = {} ---@type table<rect, trigger>

    ---@param r rect
    ---@param callback fun(evolve: Digimon)
    local function RegisterLeaveRect(r, callback)
        local t = rectsL[r]
        if not t then
            t = CreateTrigger()
            local rg = regions[r]
            if not rg then
                rg = CreateRegion()
                RegionAddRect(rg, r)
                regions[r] = rg
            end
            TriggerRegisterLeaveRegion(t, rg)
            rectsL[r] = t
        end
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetLeavingUnit())
            if d then
                callback(d)
            end
        end)
    end

    -- Register when a digimon acquires/loses an item for evolution

    local itemsP = {} ---@type table<integer, trigger>

    ---@param m integer
    ---@param callback fun(evolve: Digimon)
    local function RegisterItemPick(m, callback)
        local t = itemsP[m]
        if not t then
            t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
            TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == m end))
            itemsP[m] = t
        end
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetTriggerUnit())
            if d then
                callback(d)
            end
        end)
    end

    local itemsD = {} ---@type table<integer, trigger>

    ---@param m integer
    ---@param callback fun(evolve: Digimon)
    local function RegisterItemDrop(m, callback)
        local t = itemsD[m]
        if not t then
            t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DROP_ITEM)
            TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == m end))
            itemsD[m] = t
        end
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetTriggerUnit())
            if d then
                callback(d)
            end
        end)
    end

    local PossibleEvolution = {} ---@type Set[]

    ---@param evolve Digimon
    ---@param toEvolve integer
    local function AddPossibleEvolution(evolve, toEvolve)
        local set = PossibleEvolution[evolve]
        if not set then
            set = Set.create()
            PossibleEvolution[evolve] = set
        end
        if set:contains(toEvolve) then
            return
        end
        set:addSingle(toEvolve)
        if set:size() == 1 then
            evolve:removeAbility(EvolveAbilDis)
            evolve:addAbility(EvolveAbil)
        end
    end

    ---@param evolve Digimon
    ---@param toEvolve integer
    local function RemovePossibleEvolution(evolve, toEvolve)
        local set = PossibleEvolution[evolve]
        if not set or not set:contains(toEvolve)then
            return
        end
        set:removeSingle(toEvolve)
        if set:isEmpty() then
            evolve:removeAbility(EvolveAbil)
            evolve:addAbility(EvolveAbilDis)
        end
    end

    ---@param evolve Digimon
    local function ClearPossibleEvolutions(evolve)
        PossibleEvolution[evolve]:clear()
        evolve:removeAbility(EvolveAbil)
        evolve:addAbility(EvolveAbilDis)
    end

    local onlyDayTypes = {} ---@type table<integer, fun(evolve: Digimon)>
    local onlyNightTypes = {} ---@type table<integer, fun(evolve: Digimon)>

    ---Consider day or night time
    ---@return boolean
    local function isTime(onlyDay, onlyNight)
        return (not onlyDay or (GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK))
        and (not onlyNight or (GetTimeOfDay() < bj_TOD_DAWN or GetTimeOfDay() >= bj_TOD_DUSK))
    end

    ---The conditions to evolve (to ignore level just set the param level to 0)
    ---@param initial integer
    ---@param toEvolve integer
    ---@param level integer
    ---@param place rect nilable
    ---@param stone integer nilable
    ---@param onlyDay boolean
    ---@param onlyNight boolean
    local function CreateSpecificCondtions(initial, toEvolve, level, place, stone, onlyDay, onlyNight)
        if onlyDay and onlyNight then
            error("Digimon Evolution: Contradiction with time day condition in " .. GetObjectName(initial) .. " to " .. GetObjectName(toEvolve))
        end
        ---Unlock evolve
        ---@param evolve Digimon
        ---@param otherCond? fun(evo: Digimon):boolean is an aditional condition that uses evolve as parameter, if is not set, then is ignored
        local function active(evolve, otherCond)
            local p = evolve:getOwner()
            if p ~= Digimon.NEUTRAL and p ~= Digimon.PASSIVE and evolve:getTypeId() == initial and evolve:getLevel() >= level and isTime(onlyDay, onlyNight) and (not otherCond or otherCond(evolve)) then
                AddPossibleEvolution(evolve, toEvolve)
            end
        end

        ---Lock evolve
        ---@param evolve Digimon
        local function deactive(evolve)
            local p = evolve:getOwner()
            if p ~= Digimon.NEUTRAL and p ~= Digimon.PASSIVE and evolve:getTypeId() == initial then
                RemovePossibleEvolution(evolve, toEvolve)
            end
        end

        if onlyDay then
            onlyDayTypes[initial] = deactive
        elseif onlyNight then
            onlyNightTypes[initial] = deactive
        end

        -- Case 1: Only level
        if not place and not stone then
            Digimon.levelUpEvent:register(active)
        end

        -- Case 2: Level and place
        if place and not stone then
            Digimon.levelUpEvent:register(function (evolve)
                active(evolve, function (evo)
                    return RectContainsCoords(place, evo:getX(), evo:getY())
                end)
            end)
            RegisterEnterRect(place, active)
            RegisterLeaveRect(place, deactive)
        end

        -- Case 3: Level and stone
        if not place and stone then
            Digimon.levelUpEvent:register(function (evolve)
                active(evolve, function (evo)
                    return UnitHasItemOfTypeBJ(evo.root, stone)
                end)
            end)
            RegisterItemPick(stone, active)
            RegisterItemDrop(stone, deactive)
        end

        -- Case 4: Level, place and stone
        if place and stone then
            Digimon.levelUpEvent:register(function (evolve)
                active(evolve, function (evo)
                    return RectContainsCoords(place, evo:getX(), evo:getY()) and UnitHasItemOfTypeBJ(evo.root, stone)
                end)
            end)

            RegisterEnterRect(place, function (evolve)
                active(evolve, function (evo)
                    return UnitHasItemOfTypeBJ(evo.root, stone)
                end)
            end)
            RegisterLeaveRect(place, deactive)

            RegisterItemPick(stone, function (evolve)
                active(evolve, function (evo)
                    return RectContainsCoords(place, evo:getX(), evo:getY())
                end)
            end)
            RegisterItemDrop(stone, deactive)
        end
    end

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        local p = Player(i)
        EvolveDialog[p] = DialogCreate()
        EvolveOption[p] = {}
    end

    -- Press the evolve button
    RegisterSpellEffectEvent(EvolveAbil, function ()
        local u = GetSpellAbilityUnit()
        local p = GetOwningPlayer(u)
        EvolveClicked[p] = GetBankIndex(p, Digimon.getInstance(u))

        -- Update dialog
        DialogClear(EvolveDialog[p])
        DialogSetMessage(EvolveDialog[p], "What digimon you choose for " .. GetHeroProperName(u) .. "?")
        EvolveOption[p] = {}

        local set = PossibleEvolution[Digimon.getInstance(u)]
        if set then
            local j = 0
            for v in set:elements() do
                j = j + 1
                local u2 = GetRecycledHero(Digimon.PASSIVE, v, 0, 0, 0)
                EvolveOption[p][j] = DialogAddButton(EvolveDialog[p], GetHeroProperName(u2), 0)
                RecycleHero(u2)
            end
        end
        DialogAddButton(EvolveDialog[p], "Cancel", 0)

        DialogDisplay(p, EvolveDialog[p], true)
    end)

    -- Consider day and night

    local isNotDayEvent = EventListener.create()
    local isNotNightEvent = EventListener.create()

    local triggerDay = CreateTrigger()
    TriggerRegisterGameStateEventTimeOfDay(triggerDay, GREATER_THAN, bj_TOD_DUSK)
    TriggerRegisterGameStateEventTimeOfDay(triggerDay, LESS_THAN_OR_EQUAL, bj_TOD_DAWN)
    TriggerAddAction(triggerDay, function () isNotDayEvent:run() end)

    local triggerNight = CreateTrigger()
    TriggerRegisterGameStateEventTimeOfDay(triggerNight, GREATER_THAN, bj_TOD_DAWN)
    TriggerAddCondition(triggerNight, Condition(function () return GetTimeOfDay() <= bj_TOD_DUSK end))
    TriggerAddAction(triggerNight, function () isNotNightEvent:run() end)

    local callbacks = {} ---@type table<Digimon, fun(d: Digimon)>

    -- Add the evolution ability to the new digimon
    Digimon.createEvent:register(function (new)
        new:addAbility(EvolveAbilDis)
        local typ = new:getTypeId()
        if onlyDayTypes[typ] then
            callbacks[new] = function () onlyDayTypes[typ](new) end
            isNotDayEvent:register(callbacks[new])
        elseif onlyNightTypes[typ] then
            callbacks[new] = function () onlyNightTypes[typ](new) end
            isNotNightEvent:register(callbacks[new])
        end
    end)

    -- Remove the evolution ability to destroyed digimon
    Digimon.destroyEvent:register(function (old)
        old:removeAbility(EvolveAbil)
        old:removeAbility(EvolveAbilDis)
        local typ = old:getTypeId()
        if onlyDayTypes[typ] then
            isNotDayEvent:unregister(callbacks[old])
            callbacks[old] = nil
        elseif onlyNightTypes[typ] then
            isNotNightEvent:unregister(callbacks[old])
            callbacks[old] = nil
        end
    end)

    -- Evolve Run

    -- Press one of the options
    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        local p = Player(i)
        local t = CreateTrigger()
        TriggerRegisterDialogEvent(t, EvolveDialog[p])
        TriggerAddAction(t, function ()
            local evolve = GetBankDigimon(p, EvolveClicked[p])

            -- Get clicked button
            local index = 0
            local toEvolve = nil
            for v in PossibleEvolution[evolve]:elements() do
                index = index + 1
                if GetClickedButton() == EvolveOption[p][index] then
                    toEvolve = v
                    break
                end
            end

            if not toEvolve then
                return
            end

            ClearPossibleEvolutions(evolve)
            local time = evolve.onCombat and 2. or 4.
            local u = evolve.root

            SetUnitInvulnerable(u, true)
            PauseUnit(u, true)
            SetUnitVertexColor(u,
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_RED),
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_GREEN),
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_BLUE),
                127)

            local cur = Transmission.create(Force(p))
            cur.isSkippable = false
            cur:AddLine(u, nil, GetHeroProperName(u), nil, "is digievolving into...", Transmission.SET, time, true)
            cur:AddActions(function ()
                DestroyEffectTimed(AddSpecialEffect("Digievolution1.mdx", GetUnitX(u), GetUnitY(u)), time * 2.)

                evolve:evolveTo(toEvolve) -- Here I added the more important things
                u = evolve.root -- Have to refresh
                DestroyEffectTimed(AddSpecialEffectTarget("origin", u, "Digievolution2.mdx"), time * 1.5)

                cur:AddLine(u, nil, GetHeroProperName(u), nil, GetHeroProperName(u), Transmission.SET, time, true)
            end)
            cur:AddEnd(function ()
                SetUnitInvulnerable(u, false)
                PauseUnit(u, false)
            end)
            cur:Start()
        end)
    end

    -- For GUI
    udg_CreateEvolutionCondition = CreateTrigger()
    TriggerAddAction(udg_CreateEvolutionCondition, function ()
        CreateSpecificCondtions(udg_InitialForm,
            udg_EvolvedForm,
            udg_EvolveLevelCondition,
            rawget(_G, "udg_EvolveRegionCondition"),
            rawget(_G, "udg_EvolveItemCondition"),
            udg_EvolveOnlyDayCondition,
            udg_EvolveOnlyNightCondition
        )
        udg_InitialForm = 0
        udg_EvolvedForm = 0
        udg_EvolveLevelCondition = 0
        udg_EvolveRegionCondition = nil
        udg_EvolveItemCondition = nil
        udg_EvolveOnlyDayCondition = false
        udg_EvolveOnlyNightCondition = false
    end)

end)