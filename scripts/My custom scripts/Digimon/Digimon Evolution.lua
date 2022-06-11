do
    -- I don't know why isn't this in normal W3
    PLAYER_COLOR_UNKNOWN1 = ConvertPlayerColor(bj_PLAYER_NEUTRAL_VICTIM)
    PLAYER_COLOR_BLACK_PASSIVE = ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE)

    local TOTAL = 74

    local function Start(data, normalForm, EvolveForm, color, level, useStone)
        data.normalForm = normalForm
        data.EvolveForm = EvolveForm
        data.color = color
        data.level = level
        data.useStone = useStone
    end

    local EvolutionData = {}

    local function Get(digimon)
        local id = digimon:getTypeId()
        for i = 1, TOTAL do
            if EvolutionData[i].normalForm == id then
                return EvolutionData[i]
            end
        end
        return nil
    end

    -- Evolve Setup

    OnMapInit(function ()
        for i = 1 , TOTAL do EvolutionData[i] = {} end
        -- Agumon -> Graymon
        Start(EvolutionData[1], FourCC('H000'), FourCC('O01F'), PLAYER_COLOR_ORANGE, 20, false)
        -- Aruraumon -> Redvegiemon
        Start(EvolutionData[2], FourCC('H002'), FourCC('O02D'), PLAYER_COLOR_PURPLE, 20, false)
        -- Betamon -> Seadramon
        Start(EvolutionData[3], FourCC('H001'), FourCC('O02H'), PLAYER_COLOR_VIOLET, 20, false)
        -- Kunemon -> Kuwamon
        Start(EvolutionData[4], FourCC('H00Z'), FourCC('O01T'), PLAYER_COLOR_RED, 20, false)
        -- Floramon -> Vegiemon
        Start(EvolutionData[5], FourCC('H00I'), FourCC('O033'), PLAYER_COLOR_CYAN, 20, false)
        -- Aruraumon -> Armadilomon
        Start(EvolutionData[6], FourCC('H002'), FourCC('H003'), PLAYER_COLOR_BLUE, 25, false)
        -- Armadilomon -> Biyomon
        Start(EvolutionData[7], FourCC('H003'), FourCC('H004'), PLAYER_COLOR_BLUE, 45, false)
        -- Mushroomon -> Otamamon
        Start(EvolutionData[8], FourCC('H016'), FourCC('H017'), PLAYER_COLOR_RED, 40, false)
        -- Terriermon -> Toyagumon
        Start(EvolutionData[9], FourCC('H01O'), FourCC('H01P'), PLAYER_COLOR_RED, 50, false)
        -- Black Agumon -> Candlemon
        Start(EvolutionData[10], FourCC('H006'), FourCC('H007'), PLAYER_COLOR_CYAN, 45, false)
        -- Gabumon -> Gizamon
        Start(EvolutionData[11], FourCC('H00J'), FourCC('H00M'), PLAYER_COLOR_UNKNOWN1, 9, false)
        -- Gizamon -> Goburimon
        Start(EvolutionData[12], FourCC('H00M'), FourCC('H00N'), PLAYER_COLOR_UNKNOWN1, 18, false)
        -- Gaomon -> Gazimon
        Start(EvolutionData[13], FourCC('H00K'), FourCC('H00L'), PLAYER_COLOR_UNKNOWN1, 9, false)
        -- Gazimon -> Gomamon
        Start(EvolutionData[14], FourCC('H00L'), FourCC('H00O'), PLAYER_COLOR_UNKNOWN1, 18, false)
        -- Gotsumon -> Guilmon
        Start(EvolutionData[15], FourCC('H00P'), FourCC('H00Q'), PLAYER_COLOR_BLUE, 16, false)
        -- Guilmon -> Hackmon
        Start(EvolutionData[16], FourCC('H00Q'), FourCC('H00R'), PLAYER_COLOR_NAVY, 40, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[17], FourCC('H022'), FourCC('H023'), PLAYER_COLOR_UNKNOWN1, 22, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[18], FourCC('H023'), FourCC('H024'), PLAYER_COLOR_UNKNOWN1, 34, false)
        -- Clearagumon -> Demidevimon
        Start(EvolutionData[19], FourCC('H008'), FourCC('H00A'), PLAYER_COLOR_MAROON, 15, false)
        -- Demidevimon -> Crabmon
        Start(EvolutionData[20], FourCC('H00A'), FourCC('H009'), PLAYER_COLOR_MAROON, 28, false)
        -- SnowGoburimon -> Solamon
        Start(EvolutionData[21], FourCC('H01I'), FourCC('H01J'), PLAYER_COLOR_ORANGE, 22, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[22], FourCC('H02B'), FourCC('H02A'), PLAYER_COLOR_UNKNOWN1, 35, false)
        -- Lopmon -> Lucemon
        Start(EvolutionData[23], FourCC('H012'), FourCC('H013'), PLAYER_COLOR_COAL, 16, false)
        -- Lucemon -> Modokibetamon
        Start(EvolutionData[24], FourCC('H013'), FourCC('H014'), PLAYER_COLOR_COAL, 40, false)
        -- Agumon -> Armadilomon
        Start(EvolutionData[25], FourCC('H000'), FourCC('H003'), PLAYER_COLOR_LIGHT_BLUE, 50, false)
        -- Falcomon -> Fanbeemon
        Start(EvolutionData[26], FourCC('H00G'), FourCC('H00H'), PLAYER_COLOR_PEANUT, 15, false)
        -- Arkadimon -> Commandramon
        Start(EvolutionData[27], FourCC('H01S'), FourCC('H01T'), PLAYER_COLOR_PEACH, 15, false)
        -- Commandramon -> Veemon
        Start(EvolutionData[28], FourCC('H01T'), FourCC('H01U'), PLAYER_COLOR_BROWN, 25, false)
        -- Fanbeemon -> Floramon
        Start(EvolutionData[29], FourCC('H00H'), FourCC('H00I'), PLAYER_COLOR_NAVY, 25, false)
        -- (Unused) Terriermon -> Veemon
        Start(EvolutionData[30], FourCC('H01O'), FourCC('H01U'), PLAYER_COLOR_VIOLET, 45, false)
        -- Dokunemon -> Dorumon
        Start(EvolutionData[31], FourCC('H00B'), FourCC('H00C'), PLAYER_COLOR_BROWN, 16, false)
        -- Dorumon -> Dracmon
        Start(EvolutionData[32], FourCC('H00C'), FourCC('H00D'), PLAYER_COLOR_BROWN, 40, false)
        -- Hawkmon -> Hagurumon
        Start(EvolutionData[33], FourCC('H00T'), FourCC('H00S'), PLAYER_COLOR_SNOW, 24, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[34], FourCC('H038'), FourCC('H039'), PLAYER_COLOR_PEACH, 26, false)
        -- Kudamon -> Kunemon
        Start(EvolutionData[35], FourCC('H00Y'), FourCC('H00Z'), PLAYER_COLOR_VIOLET, 35, false)
        -- Mega Digimon -> Air
        Start(EvolutionData[36], FourCC('H030'), FourCC('Hmkg'), PLAYER_COLOR_UNKNOWN1, 20, false)
        -- (Unused) Machine -> Air
        Start(EvolutionData[37], FourCC('Hpal'), FourCC('Hmkg'), PLAYER_COLOR_UNKNOWN1, 22, false)
        -- Renamon -> Ryudamon
        Start(EvolutionData[38], FourCC('H01E'), FourCC('H01F'), PLAYER_COLOR_TURQUOISE, 24, false)
        -- Labramon -> Lalamon
        Start(EvolutionData[39], FourCC('H010'), FourCC('H011'), PLAYER_COLOR_EMERALD, 28, false)
        -- Shamamon -> Salamon
        Start(EvolutionData[40], FourCC('H01H'), FourCC('H01G'), PLAYER_COLOR_NAVY, 26, false)
        -- Patamon -> Pawnchessmon B
        Start(EvolutionData[41], FourCC('H019'), FourCC('H01A'), PLAYER_COLOR_MAROON, 40, false)
        -- Impmon -> SnowAgumon
        Start(EvolutionData[42], FourCC('H00V'), FourCC('H00U'), PLAYER_COLOR_SNOW, 40, false)
        -- (Unused) Aquatic -> Nature
        Start(EvolutionData[43], FourCC('Hamg'), FourCC('Hblm'), PLAYER_COLOR_AQUA, 46, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[44], FourCC('H027'), FourCC('H028'), PLAYER_COLOR_UNKNOWN1, 48, false)
        -- Pawnchessmon W -> Penguimon
        Start(EvolutionData[45], FourCC('H01B'), FourCC('H01C'), PLAYER_COLOR_PEACH, 26, false)
        -- Penguimon -> Psychemon
        Start(EvolutionData[46], FourCC('H01C'), FourCC('H01D'), PLAYER_COLOR_PEACH, 36, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[47], FourCC('H02S'), FourCC('H02T'), PLAYER_COLOR_MAROON, 48, false)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[48], FourCC('H03Q'), FourCC('H03R'), PLAYER_COLOR_AQUA, 24, false)
        -- (Unused) Mega Digimon -> Air
        Start(EvolutionData[49], FourCC('H026'), FourCC('Hmkg'), PLAYER_COLOR_AQUA, 27, false)
        -- These Monsters use Evolution Stones
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[50], FourCC('H02W'), FourCC('H02X'), PLAYER_COLOR_PEACH, 999, true)
        -- Solarmon -> Swimmon
        Start(EvolutionData[51], FourCC('H01J'), FourCC('H01K'), PLAYER_COLOR_ORANGE, 999, true)
        -- Machine -> Aquatic
        Start(EvolutionData[52], FourCC('Hpal'), FourCC('Hamg'), PLAYER_COLOR_MAROON, 999, true)
        -- Kamemon -> Kotemon
        Start(EvolutionData[53], FourCC('H00W'), FourCC('H00X'), PLAYER_COLOR_NAVY, 999, true)
        -- Mega Digimon -> Nature
        Start(EvolutionData[54], FourCC('H03S'), FourCC('Hblm'), PLAYER_COLOR_MAROON, 999, true)
        -- Tsukaimon -> Wormon
        Start(EvolutionData[55], FourCC('H01Q'), FourCC('H01R'), PLAYER_COLOR_PEANUT, 999, true)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[56], FourCC('H02U'), FourCC('H02V'), PLAYER_COLOR_MINT, 999, true)
        -- Dracomon -> Elecmon
        Start(EvolutionData[57], FourCC('H00E'), FourCC('H00F'), PLAYER_COLOR_EMERALD, 999, true)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[58], FourCC('H027'), FourCC('H028'), PLAYER_COLOR_RED, 999, true)
        -- Mega Digimon -> Mega Digimon
        Start(EvolutionData[59], FourCC('H02A'), FourCC('H02C'), PLAYER_COLOR_BLACK_PASSIVE, 999, true)
        -- Air -> Machine
        Start(EvolutionData[60], FourCC('Hmkg'), FourCC('Hpal'), PLAYER_COLOR_VIOLET, 999, true)
        -- Nature -> Aquatic
        Start(EvolutionData[61], FourCC('Hblm'), FourCC('Hamg'), PLAYER_COLOR_NAVY, 999, true)
        -- Machine -> Machine
        Start(EvolutionData[62], FourCC('Hpal'), FourCC('Hpal'), PLAYER_COLOR_LIGHT_BLUE, 999, true)
        -- Nature -> Machine
        Start(EvolutionData[63], FourCC('Hblm'), FourCC('Hpal'), PLAYER_COLOR_ORANGE, 999, true)
        -- Nature -> Aquatic
        Start(EvolutionData[64], FourCC('Hblm'), FourCC('Hamg'), PLAYER_COLOR_VIOLET, 48, false)
        -- Machine -> Aquatic
        Start(EvolutionData[65], FourCC('Hpal'), FourCC('Hamg'), PLAYER_COLOR_BROWN, 46, false)
        -- Nature -> Aquatic
        Start(EvolutionData[66], FourCC('Hblm'), FourCC('Hamg'), PLAYER_COLOR_WHEAT, 49, false)
        -- Nature -> Machine
        Start(EvolutionData[67], FourCC('Hblm'), FourCC('Hpal'), PLAYER_COLOR_SNOW, 50, false)
        -- Nature -> Machine
        Start(EvolutionData[68], FourCC('Hblm'), FourCC('Hpal'), PLAYER_COLOR_LIGHT_BLUE, 46, false)
        -- Air -> Nature
        Start(EvolutionData[69], FourCC('Hmkg'), FourCC('Hblm'), PLAYER_COLOR_LIGHT_BLUE, 46, false)
        -- Machine -> Nature
        Start(EvolutionData[70], FourCC('Hpal'), FourCC('Hblm'), PLAYER_COLOR_SNOW, 51, false)
        -- Nature -> Machine
        Start(EvolutionData[71], FourCC('Hblm'), FourCC('Hpal'), PLAYER_COLOR_SNOW, 47, false)
        -- Air -> Aquatic
        Start(EvolutionData[72], FourCC('Hmkg'), FourCC('Hamg'), PLAYER_COLOR_SNOW, 51, false)
        -- Air -> Machine
        Start(EvolutionData[73], FourCC('Hmkg'), FourCC('Hpal'), PLAYER_COLOR_LIGHT_BLUE, 47, false)
        -- Nature -> Machine
        Start(EvolutionData[74], FourCC('Hblm'), FourCC('Hpal'), PLAYER_COLOR_BLUE, 49, false)
    end)

    -- Evolve Run

    OnMapInit(function ()
        Digimon.levelUpEvent(function (evolve)
            if evolve:getOwner() ~= Digimon.NEUTRAL then
                local data = Get(evolve)

                if data and evolve:getLevel() >= data.level then
                    local u = evolve.root
                    local p = GetOwningPlayer(u)
                    --local camera = GetCurrentCameraSetup()

                    local f = GetForceOfPlayer(p)
                    TransmissionFromUnitWithNameBJ(f, u, GetHeroProperName(u), nil, "is digievolving into...", bj_TIMETYPE_SET, 2.00, true)

                    SetUnitInvulnerable(u, true)
                    PauseUnit(u, true)
                    DestroyEffectTimed(AddSpecialEffect("Digievolution1.mdx", GetUnitX(u), GetUnitY(u)), 4.00) -- If the unit is hidden, the effect won't be shown

                    evolve:evolveTo(data.EvolveForm) -- Here I added the more important things
                    u = evolve.root -- Have to refresh
                    DestroyEffectTimed(AddSpecialEffectTarget("origin", u, "Digievolution2.mdx"), 3.00)
                    TransmissionFromUnitWithNameBJ(f, u, GetHeroProperName(u), nil, GetHeroProperName(u), bj_TIMETYPE_SET, 2.00, true)

                    PauseUnit(u, false)

                    SetUnitColor(u, data.color)
                    DestroyForce(f)
                end
            end
        end)
    end)

end