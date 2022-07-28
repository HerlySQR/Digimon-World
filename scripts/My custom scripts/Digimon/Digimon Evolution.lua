do
    local EvolveDialog = {} ---@type table<player, dialog>
    local EvolveClicked = __jarray(-1) ---@type table<player, integer>
    local EvolveOption = {} ---@type table<player, button>[]

    -- Evolution abilities

    EvolveAbil = FourCC('A02H')
    EvolveAbilDis = FourCC('A02I')

    -- Register when a digimon enters/leaves in a rect for evolution

    local rectsE = {} ---@type table<rect, trigger>

    ---@param r rect
    ---@param callback fun(evolve: Digimon)
    local function RegisterEnterRect(r, callback)
        local t = rectsE[r]
        if not t then
            t = CreateTrigger()
            TriggerRegisterEnterRectSimple(t, r)
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
            TriggerRegisterLeaveRectSimple(t, r)
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

    ---The conditions to evolve (to ignore level just set the param level to 0)
    ---@param initial integer
    ---@param toEvolve integer
    ---@param level integer
    ---@param place rect nilable
    ---@param stone integer nilable
    local function CreateSpecificCondtions(initial, toEvolve, level, place, stone)
        ---Unlock evolve
        ---@param evolve Digimon
        ---@param otherCond? fun(evo: Digimon) is an aditional condition that uses evolve as parameter, if is not set, then is ignored
        local function active(evolve, otherCond)
            local p = evolve:getOwner()
            if p ~= Digimon.NEUTRAL and p ~= Digimon.PASSIVE and evolve:getTypeId() == initial and evolve:getLevel() >= level and (not otherCond or otherCond(evolve)) then
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

        -- Case 1: Only level
        if not place and not stone then
            Digimon.levelUpEvent(active)
        end

        -- Case 2: Level and place
        if place and not stone then
            Digimon.levelUpEvent(function (evolve)
                active(evolve, function (evo)
                    return RectContainsCoords(place, evo:getX(), evo:getY())
                end)
            end)
            RegisterEnterRect(place, active)
            RegisterLeaveRect(place, deactive)
        end

        -- Case 3: Level and stone
        if not place and stone then
            Digimon.levelUpEvent(function (evolve)
                active(evolve, function (evo)
                    return UnitHasItemOfTypeBJ(evo.root, stone)
                end)
            end)
            RegisterItemPick(stone, active)
            RegisterItemDrop(stone, deactive)
        end

        -- Case 4: Level, place and stone
        if place and stone then
            Digimon.levelUpEvent(function (evolve)
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

    OnGameStart(function ()
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

        -- Add the evolution ability to the new digimon
        local function AddAbility(new)
            local p = new:getOwner()
            if p ~= Digimon.NEUTRAL and p ~= Digimon.PASSIVE then
                new:addAbility(EvolveAbilDis)
            end
        end
        Digimon.createEvent(AddAbility)
        Digimon.capturedEvent(AddAbility)

        -- Remove the evolution ability to destroyed digimon
        Digimon.destroyEvent(function (old)
            old:removeAbility(EvolveAbil)
            old:removeAbility(EvolveAbilDis)
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

                local cur = Transmission.create(Force(p))
                cur.isSkippable = false
                cur:AddLine(u, nil, GetHeroProperName(u), nil, "is digievolving into...", Transmission.SET, time, true)
                cur:AddActions(function ()
                    SetUnitInvulnerable(u, true)
                    PauseUnit(u, true)
                    DestroyEffectTimed(AddSpecialEffect("Digievolution1.mdx", GetUnitX(u), GetUnitY(u)), time * 2.)

                    evolve:evolveTo(toEvolve) -- Here I added the more important things
                    u = evolve.root -- Have to refresh
                    DestroyEffectTimed(AddSpecialEffectTarget("origin", u, "Digievolution2.mdx"), time * 1.5)

                    cur:AddLine(u, nil, GetHeroProperName(u), nil, GetHeroProperName(u), Transmission.SET, time, true)
                end)
                cur:AddEnd(function ()
                    PauseUnit(u, false)
                end)
                cur:Start()
            end)
        end
    end)

    -- For GUI
    OnTrigInit(function ()
        udg_CreateEvolutionCondition = CreateTrigger()
        TriggerAddAction(udg_CreateEvolutionCondition, function ()
            CreateSpecificCondtions(udg_InitialForm, udg_EvolvedForm, udg_EvolveLevelCondition, udg_EvolveRegionCondition, udg_EvolveItemCondition)
            udg_InitialForm = 0
            udg_EvolvedForm = 0
            udg_EvolveLevelCondition = 0
            udg_EvolveRegionCondition = nil
            udg_EvolveItemCondition = nil
        end)
    end)

end