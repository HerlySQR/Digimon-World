Debug.beginFile("Digimon Evolution")
OnInit("DigimonEvolution", function ()
    Require "Digimon"
    Require "Digimon Capture"
    Require "Timed"
    Require "PlayerUtils"
    Require "PlayerDigimons"

    local EvolveDialog = {} ---@type table<player, dialog>
    local EvolveClicked = __jarray(-1) ---@type table<player, integer>
    local EvolveOption = {} ---@type table<player, button>[]

    -- Evolution abilities

    EvolveAbil = FourCC('A02H')
    EvolveAbilDis = FourCC('A02I')

    ---@class EvolutionCondition
    ---@field toEvolve integer
    ---@field level integer
    ---@field place rect nilable
    ---@field stone integer nilable
    ---@field onlyDay boolean
    ---@field onlyNight boolean

    local EvolutionConditions = {} ---@type table<integer, EvolutionCondition[]>

    local PossibleEvolution = {} ---@type table<Digimon, Set>

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

    local function CheckDigimonEvolutionConditions()
        ForForce(FORCE_PLAYING, function ()
            for _, d in ipairs(GetDigimons(GetEnumPlayer())) do
                local initial = d:getTypeId()
                if EvolutionConditions[initial] then
                    for _, cond in ipairs(EvolutionConditions[initial]) do
                        local canEvolve = true
                        -- Check lvl
                        canEvolve = canEvolve and d:getLevel() >= cond.level
                        -- Check place
                        if cond.place then
                            canEvolve = canEvolve and RectContainsUnit(cond.place, d.root)
                        end
                        -- Check stone
                        if cond.stone then
                            canEvolve = canEvolve and UnitHasItemOfTypeBJ(d.root, cond.stone)
                        end
                        -- Check day/night
                        if cond.onlyDay then
                            canEvolve = canEvolve and (GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK)
                        elseif cond.onlyNight then
                            canEvolve = canEvolve and (GetTimeOfDay() < bj_TOD_DAWN or GetTimeOfDay() >= bj_TOD_DUSK)
                        end

                        if canEvolve then
                            AddPossibleEvolution(d, cond.toEvolve)
                        else
                            RemovePossibleEvolution(d, cond.toEvolve)
                        end
                    end
                end
            end
        end)
    end

    OnInit.final(function ()
        Timed.echo(0.5, CheckDigimonEvolutionConditions)
    end)

    ---The conditions to evolve (to ignore level just set the param level to 0)
    ---@param initial integer
    ---@param toEvolve integer
    ---@param level integer
    ---@param place rect | nil
    ---@param stone integer | nil
    ---@param onlyDay boolean
    ---@param onlyNight boolean
    local function CreateSpecificCondtions(initial, toEvolve, level, place, stone, onlyDay, onlyNight)
        if onlyDay and onlyNight then
            error("Digimon Evolution: Contradiction with time day condition in " .. GetObjectName(initial) .. " to " .. GetObjectName(toEvolve))
        end

        if not EvolutionConditions[initial] then
            EvolutionConditions[initial] = {}
        end

        table.insert(EvolutionConditions[initial], {
            toEvolve = toEvolve,
            level = level,
            place = place,
            stone = stone,
            onlyDay = onlyDay,
            onlyNight = onlyNight
        })
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

    -- Add the evolution ability to the new digimon
    Digimon.createEvent:register(function (new)
        new:addAbility(EvolveAbilDis)
    end)

    -- Remove the evolution ability to destroyed digimon
    Digimon.destroyEvent:register(function (old)
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

            SetUnitInvulnerable(u, true)
            PauseUnit(u, true)
            SetUnitVertexColor(u,
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_RED),
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_GREEN),
                BlzGetUnitIntegerField(u, UNIT_IF_TINTING_COLOR_BLUE),
                127)

            local s = CreateSound("war3mapImported\\Evolution_1", false, true, true, 1, 1, "DefaultEAXON")
            SetSoundVolume(s, 127)
            StartSound(s)
            KillSoundWhenDone(s)

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

    -- Preload sound
    OnInit.map(function ()
        SetSoundVolume(gg_snd_Evolution_1, 0)
        StartSound(gg_snd_Evolution_1)
        Timed.call(GetSoundDurationBJ(gg_snd_Evolution_1), function ()
            SetSoundVolume(gg_snd_Evolution_1, 127)
        end)
    end)

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
Debug.endFile()