Debug.beginFile("Fishing")
OnInit(function ()
    Require "AbilityUtils"
    Require "RegisterSpellEffectEvent"
    Require "ErrorMessage"
    Require "FrameLoader"
    Require "Menu"

    local DIGI_ANCHOVY = FourCC('I07N')
    local DIGI_SEABASS = FourCC('I07P')
    local DIGI_SPEAR_FISH = FourCC('I07O')
    local DIGI_SNAPPER = FourCC('I07Q')
    local DIGI_TROUT = FourCC('I07S')
    local DIGI_CARP = FourCC('I07R')
    local DIGI_TUNA = FourCC('I07T')
    local DIGI_DRAGON_FISH = FourCC('I07U')
    local DIGI_DRAGON_FISH_OTHER = FourCC('I08K')

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == DIGI_DRAGON_FISH_OTHER end))
        TriggerAddAction(t, function ()
            UnitAddItemById(GetManipulatingUnit(), DIGI_DRAGON_FISH)
            RemoveItem(GetManipulatedItem())
        end)
    end

    local FISHING = FourCC('A0IL')
    local ROD = {
        FourCC('I07W'),
        FourCC('I07M'),
        FourCC('I07Y'),
        FourCC('I07X')
    }
    local FISHES = {
        [1] = {
            [DIGI_ANCHOVY] = 1,
            [DIGI_SEABASS] = 1,
            [DIGI_SNAPPER] = 1,
            [DIGI_TROUT] = 1,
            [DIGI_TUNA] = 1
        },
        [2] = {
            [DIGI_ANCHOVY] = 0.85,
            [DIGI_SEABASS] = 0.85,
            [DIGI_SPEAR_FISH] = 0.13,
            [DIGI_SNAPPER] = 0.85,
            [DIGI_TROUT] = 0.85,
            [DIGI_CARP] = 0.13,
            [DIGI_TUNA] = 0.85,
            [DIGI_DRAGON_FISH_OTHER] = 0.01
        },
        [3] = {
            [DIGI_ANCHOVY] = 0.75,
            [DIGI_SEABASS] = 0.75,
            [DIGI_SPEAR_FISH] = 0.20,
            [DIGI_SNAPPER] = 0.75,
            [DIGI_TROUT] = 0.75,
            [DIGI_CARP] = 0.20,
            [DIGI_TUNA] = 0.75,
            [DIGI_DRAGON_FISH_OTHER] = 0.025
        },
        [4] = {
            [DIGI_ANCHOVY] = 0.6,
            [DIGI_SEABASS] = 0.6,
            [DIGI_SPEAR_FISH] = 0.3,
            [DIGI_SNAPPER] = 0.6,
            [DIGI_TROUT] = 0.6,
            [DIGI_CARP] = 0.3,
            [DIGI_TUNA] = 0.6,
            [DIGI_DRAGON_FISH_OTHER] = 0.04
        }
    }
    local PLACES = {
        ["All"] = {DIGI_DRAGON_FISH_OTHER},
        ["File City"] = {DIGI_ANCHOVY, DIGI_SPEAR_FISH},
        ["Gear Savanna"] = {DIGI_SEABASS, DIGI_SPEAR_FISH},
        ["Tropical Jungle"] = {DIGI_SEABASS, DIGI_SPEAR_FISH},
        ["Ancient Dino Region"] = {DIGI_SNAPPER, DIGI_CARP},
        ["Freezeland"] = {DIGI_TROUT, DIGI_CARP},
        ["Bettleland"] = {DIGI_TUNA},
        ["Geko Swamp"] = {DIGI_SNAPPER, DIGI_CARP}
    }
    PLACES["Native Forest"] = PLACES["File City"]
    local CATCH_AREA_LENGTH = 0.48
    local GREEN_AREA_START = 0.21
    local GREEN_AREA_END = 0.27
    local YELLOW_AREA_START = 0.23
    local YELLOW_AREA_END = 0.25
    local RED_LINE_INTERVAL = 0.02 -- seconds
    local RED_LINE_SPEED = 0.57 * CATCH_AREA_LENGTH * RED_LINE_INTERVAL
    local CATCH_TIME = (CATCH_AREA_LENGTH/RED_LINE_SPEED) * RED_LINE_INTERVAL

    ---@alias catchState
    ---| 0 # None
    ---| 1 # Success
    ---| 2 # Fail
    ---| 3 # SuccessEx

    local LocalPlayer = GetLocalPlayer()
    local fishers = {} ---@type table<player, unit[]>
    local fishing = __jarray(false) ---@type table<unit, boolean>
    local lines = {} ---@type table<unit, lightning>
    local linePos = __jarray(0) ---@type table<unit, number>
    local catch = __jarray(0) ---@type table<unit, catchState>
    local usedRedLine = __jarray(0) ---@type table<unit, integer>
    local allowedRedLine = __jarray(true) ---@type table<integer, boolean>

    local FishBackdrop = nil ---@type framehandle
    local ProgressBar = nil ---@type framehandle
    local Ready = nil ---@type framehandle
    local BackdropReady = nil ---@type framehandle
    local RedLines = {} ---@type framehandle[]
    local Fisher = {} ---@type framehandle[]
    local GreenArea = nil ---@type framehandle
    local YellowArea = nil ---@type framehandle

    for i = 0, bj_MAX_PLAYERS - 1 do
        fishers[Player(i)] = {}
    end

    ---@param u unit
    ---@return integer?
    local function getRod(u)
        for i = 1, #ROD do
            if UnitHasItemOfTypeBJ(u, ROD[i]) then
                return i
            end
        end
    end

    ---@param u unit
    ---@return integer?
    local function getRandomFish(u)
        local whatRod = getRod(u)

        if whatRod then
            local env = Digimon.getInstance(u) and Digimon.getInstance(u).environment
            if not env then
                return
            end

            local fishes = Set.create()
            for _, fish in ipairs(PLACES[env.name]) do
                if FISHES[whatRod][fish] then
                    fishes:addSingle(fish)
                end
            end
            for _, fish in ipairs(PLACES["All"]) do
                if FISHES[whatRod][fish] then
                    fishes:addSingle(fish)
                end
            end

            local chances = {}
            local whatFishes = {}
            local maxWeight = 0
            local i = 0
            for fish in fishes:elements() do
                i = i + 1
                local weight = FISHES[whatRod][fish]
                if weight < 0.5 and catch[u] == 3 then
                    weight = weight * 2
                end
                maxWeight = maxWeight + weight
                whatFishes[i] = fish
                chances[i] = maxWeight
            end

            local r = maxWeight * math.random()
            for j = 1, i do
                if r <= chances[j] then
                    return whatFishes[j]
                end
            end
        end
    end

    ---@param u unit
    local function abortFish(u)
        if fishing[u] then
            fishing[u] = false
            if lines[u] then
                DestroyLightning(lines[u])
                lines[u] = nil
            end
            UnitAbortCurrentOrder(u)
            local p = GetOwningPlayer(u)
            for i = #fishers[p], 1, -1 do
                if fishers[p][i] == u then
                    table.remove(fishers[p], i)
                    break
                end
            end
            if p == LocalPlayer then
                BlzFrameSetVisible(RedLines[usedRedLine[u]], false)
                if #fishers[p] == 0 then
                    BlzFrameSetVisible(FishBackdrop, false)
                end
                allowedRedLine[usedRedLine[u]] = true
                usedRedLine[u] = 0
            end
            catch[u] = 0
        end
    end

    ---@param u unit
    ---@param p player
    ---@param line lightning
    local function startFishing(u, p, line)
        Timed.call(2 + 2*math.random(), function ()
            if lines[u] ~= line then
                return
            end

            local index = 0
            if p == LocalPlayer then
                index = usedRedLine[u]
                BlzFrameSetVisible(FishBackdrop, true)
                BlzFrameSetPoint(RedLines[index], FRAMEPOINT_CENTER, ProgressBar, FRAMEPOINT_LEFT, 0.000, 0.00000)
                BlzFrameSetVisible(RedLines[index], true)
                BlzFrameSetVisible(YellowArea, getRod(u) > 1)
            end
            linePos[u] = 0.
            Timed.echo(RED_LINE_INTERVAL, CATCH_TIME, function ()
                if lines[u] ~= line then
                    return true
                end

                linePos[u] = linePos[u] + RED_LINE_SPEED
                if p == LocalPlayer then
                    BlzFrameSetPoint(RedLines[index], FRAMEPOINT_CENTER, ProgressBar, FRAMEPOINT_LEFT, linePos[u], 0.00000)
                end

                if catch[u] ~= 0 then
                    if p == LocalPlayer then
                        BlzFrameSetVisible(RedLines[index], false)
                        if #fishers[p] == 1 then
                            BlzFrameSetVisible(FishBackdrop, false)
                        end
                    end
                    if catch[u] == 2 then
                        abortFish(u)
                    end
                    return true
                end
            end, function ()
                if p == LocalPlayer then
                    BlzFrameSetVisible(RedLines[index], false)
                end
                startFishing(u, p, line)
            end)
        end)
    end

    local hasRod = Condition(function ()
        for i = 1, #ROD do
            if GetItemTypeId(GetManipulatedItem()) == ROD[i] then
                return true
            end
        end
        return false
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, hasRod)
        TriggerAddAction(t, function ()
            local u = GetManipulatingUnit()
            local m = GetManipulatedItem()
            local typ = GetItemTypeId(m)
            local uHasRod = false
            for i = 1, #ROD do
                if typ ~= ROD[i] and UnitHasItemOfTypeBJ(u, ROD[i]) then
                    uHasRod = true
                    break
                end
            end
            if uHasRod then
                ErrorMessage("You already have a fishing rod", GetOwningPlayer(u))
                UnitRemoveItem(u, m)
            else
                UnitAddAbility(u, FISHING)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DROP_ITEM)
        TriggerAddCondition(t, hasRod)
        TriggerAddAction(t, function ()
            local u = GetManipulatingUnit()
            Timed.call(function ()
                local doesntHaveRod = true
                for i = 1, #ROD do
                    if UnitHasItemOfTypeBJ(u, ROD[i]) then
                        doesntHaveRod = false
                        break
                    end
                end
                if doesntHaveRod then
                    UnitRemoveAbility(u, FISHING)
                    abortFish(u)
                end
            end)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
        TriggerAddCondition(t, Condition(function () return fishing[GetOrderedUnit()] end))
        TriggerAddAction(t, function ()
            abortFish(GetOrderedUnit())
        end)
    end

    RegisterSpellEffectEvent(FISHING, function ()
        local u = GetSpellAbilityUnit()

        abortFish(u)

        local targetX, targetY
        ForEachCellInArea(GetUnitX(u), GetUnitY(u), 128, function (x, y)
            if not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainWalkable(x, y) then
                targetX, targetY = x, y
            end
        end)
        if targetX then
            fishing[u] = true
            local p = GetOwningPlayer(u)
            table.insert(fishers[p], u)

            local angle = math.atan(targetY - GetUnitY(u), targetX - GetUnitX(u))
            SetUnitFacing(u, math.deg(angle))

            local actX = GetUnitX(u)
            local actY = GetUnitY(u)
            local actZ = GetUnitZ(u, true) + 50.

            local step = DistanceBetweenCoords(GetUnitX(u), GetUnitY(u), targetX, targetY) / 50
            local stepX = step * math.cos(angle) * 1.25
            local stepY = step * math.sin(angle) * 1.25
            local stepZ = (GetPosZ(targetX, targetY) - actZ) / 40

            local line = AddLightningEx( "LEAS", true, actX, actY, actZ, actX, actY, actZ)
            SetLightningColor(line, 0.5, 1., 1., 1.)

            Timed.echo(0.02, 1., function ()
                if lines[u] ~= line then
                    return true
                end
                actX = actX + stepX
                actY = actY + stepY
                actZ = actZ + stepZ
                MoveLightningEx(line, true, GetUnitX(u), GetUnitY(u), GetUnitZ(u, true) + 50., actX, actY, actZ)
            end, function ()
                if p == LocalPlayer then
                    local index = 0
                    for i = 1, #RedLines do
                        if allowedRedLine[i] then
                            index = i
                            break
                        end
                    end
                    usedRedLine[u] = index
                    allowedRedLine[index] = false
                    BlzFrameSetTexture(Fisher[index], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)
                end

                startFishing(u, p, line)

                Timed.echo(0.02, function ()
                    if lines[u] ~= line then
                        return true
                    end
                    if DistanceBetweenCoordsSq(actX, actY, GetUnitX(u), GetUnitY(u)) > 90000. then
                        abortFish(u)
                    end
                    if catch[u] == 0 then
                        if math.random(1, 50) == 1 then
                            local angle2 = math.random() * 2 * math.pi
                            DestroyEffectTimed(AddSpecialEffect("Doodads\\Ruins\\Water\\BubbleGeyser\\BubbleGeyser.mdl", actX + 50.*math.random() * math.cos(angle2), actY + 50.*math.random() * math.sin(angle2)), 1.)
                        end
                    elseif catch[u] == 1 or catch[u] == 3 then
                        actX = actX - stepX
                        actY = actY - stepY
                        actZ = actZ - stepZ
                        MoveLightningEx(line, true, GetUnitX(u), GetUnitY(u), GetUnitZ(u, true) + 50., actX, actY, actZ)

                        if DistanceBetweenCoordsSq(actX, actY, GetUnitX(u), GetUnitY(u)) < 2500 then
                            local whatFish = getRandomFish(u)
                            if whatFish then
                                CreateItem(whatFish, GetUnitX(u), GetUnitY(u))
                            end
                            abortFish(u)
                        end
                    end
                end)
            end)
            lines[u] = line
        else
            ErrorMessage("No fishing spot found", GetOwningPlayer(u))
        end
    end)

    local function ReadyFunc(p)
        table.sort(fishers[p], function (a, b) return linePos[a] > linePos[b] end)

        for i = 1, #fishers[p] do
            local u = fishers[p][i]
            if linePos[u] < CATCH_AREA_LENGTH then
                local tt = CreateTextTag()
                SetTextTagPosUnit(tt, u, 128)
                SetTextTagPermanent(tt, false)
                SetTextTagLifespan(tt, 2.)
                SetTextTagVisibility(tt, p == LocalPlayer)

                if linePos[u] >= GREEN_AREA_START and linePos[u] <= GREEN_AREA_END then
                    if getRod(u) > 1 and linePos[u] >= YELLOW_AREA_START and linePos[u] <= YELLOW_AREA_END then
                        catch[u] = 3
                        SetTextTagText(tt, "Success!", 0.030)
                        SetTextTagColor(tt, 255, 127, 0, 255)
                        if p == LocalPlayer then
                            StartSound(bj_questHintSound)
                        end
                    else
                        catch[u] = 1
                        SetTextTagText(tt, "Success!", 0.023)
                        SetTextTagColor(tt, 0, 255, 0, 255)
                        if p == LocalPlayer then
                            StartSound(bj_questItemAcquiredSound)
                        end
                    end
                else
                    catch[u] = 2
                    SetTextTagText(tt, "Fail!", 0.023)
                    SetTextTagColor(tt, 255, 0, 0, 255)
                    if p == LocalPlayer then
                        StartSound(bj_questFailedSound)
                    end
                end
                break
            end
        end
    end

    FrameLoaderAdd(function ()
        FishBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
        BlzFrameSetAbsPoint(FishBackdrop, FRAMEPOINT_TOPLEFT, 0.160000, 0.460000)
        BlzFrameSetAbsPoint(FishBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.660000, 0.180000)
        BlzFrameSetTexture(FishBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(FishBackdrop, false)
        AddFrameToMenu(FishBackdrop)

        ProgressBar = BlzCreateFrame("QuestButtonBaseTemplate", FishBackdrop, 0, 0)
        BlzFrameSetPoint(ProgressBar, FRAMEPOINT_TOPLEFT, FishBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.13000)
        BlzFrameSetSize(ProgressBar, CATCH_AREA_LENGTH, 0.03)

        Ready = BlzCreateFrame("IconButtonTemplate", FishBackdrop, 0, 0)
        BlzFrameSetPoint(Ready, FRAMEPOINT_TOPLEFT, FishBackdrop, FRAMEPOINT_TOPLEFT, 0.22500, -0.21000)
        BlzFrameSetPoint(Ready, FRAMEPOINT_BOTTOMRIGHT, FishBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22500, 0.020000)

        BackdropReady = BlzCreateFrameByType("BACKDROP", "BackdropReady", Ready, "", 0)
        BlzFrameSetAllPoints(BackdropReady, Ready)
        BlzFrameSetTexture(BackdropReady, "ReplaceableTextures\\CommandButtons\\BTNFishing1.blp", 0, true)
        OnClickEvent(Ready, ReadyFunc)

        for i = 1, udg_MAX_USED_DIGIMONS do
            RedLines[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ProgressBar, "", 1)
            BlzFrameSetPoint(RedLines[i], FRAMEPOINT_CENTER, ProgressBar, FRAMEPOINT_LEFT, 0.00000, 0.00000)
            BlzFrameSetSize(RedLines[i], 0.00500, 0.10000)
            BlzFrameSetTexture(RedLines[i], "war3mapImported\\red.blp", 0, true)
            BlzFrameSetLevel(RedLines[i], 3)
            BlzFrameSetVisible(RedLines[i], false)

            Fisher[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", RedLines[i], "", 1)
            BlzFrameSetPoint(Fisher[i], FRAMEPOINT_TOPLEFT, RedLines[i], FRAMEPOINT_TOPLEFT, -0.010000, -0.10000)
            BlzFrameSetPoint(Fisher[i], FRAMEPOINT_BOTTOMRIGHT, RedLines[i], FRAMEPOINT_BOTTOMRIGHT, 0.010000, -0.030000)
            BlzFrameSetTexture(Fisher[i], "", 0, true)
        end

        GreenArea = BlzCreateFrameByType("BACKDROP", "BACKDROP", ProgressBar, "", 1)
        BlzFrameSetPoint(GreenArea, FRAMEPOINT_TOPLEFT, ProgressBar, FRAMEPOINT_TOPLEFT, GREEN_AREA_START, 0.0000)
        BlzFrameSetSize(GreenArea, GREEN_AREA_END - GREEN_AREA_START, 0.03)
        BlzFrameSetTexture(GreenArea, "war3mapImported\\GreenArea.blp", 0, true)
        BlzFrameSetLevel(GreenArea, 1)

        YellowArea = BlzCreateFrameByType("BACKDROP", "BACKDROP", ProgressBar, "", 1)
        BlzFrameSetPoint(YellowArea, FRAMEPOINT_TOPLEFT, ProgressBar, FRAMEPOINT_TOPLEFT, YELLOW_AREA_START, 0.0000)
        BlzFrameSetSize(YellowArea, YELLOW_AREA_END - YELLOW_AREA_START, 0.03)
        BlzFrameSetTexture(YellowArea, "war3mapImported\\YellowArea.blp", 0, true)
        BlzFrameSetLevel(YellowArea, 2)
    end)
end)
Debug.endFile()