Debug.beginFile("GenerateSpecialArena")
OnInit(function ()
    Require "Noise"
    Require "Timed"
    Require "AbilityUtils"
    Require "Pathfinder"
    Require "MDTable"

    local arena = gg_rct_SpecialArena ---@type rect
    local minX, minY, maxX, maxY = GetRectMinX(arena), GetRectMinY(arena), GetRectMaxX(arena), GetRectMaxY(arena)
    local centerX, centerY = GetRectCenterX(arena), GetRectCenterY(arena)
    local height = maxY - minY
    local effects = {} ---@type effect[][]
    local terrainDeformations = {} ---@type terraindeformation[][]
    local bannedCells = __jarray(false) ---@type table<integer, boolean>
    local weather = nil ---@type weathereffect
    local pointIndex = MDTable.create(2) ---@type integer[][]

    local VOID = FourCC('Zsan')
    local CONVERSOR = 1 / (bj_CELLWIDTH * 10)
    local CELL_SIZE = bj_CELLWIDTH / 2
    local ROW_SIZE = (maxY - minY) // CELL_SIZE
    local MAX_CHANCE_TO_CREATE_PATH = 10

    ---@param func fun(x: number, y: number, i: integer)
    local function forEachCell(func)
        local co = coroutine.running()
        local i = 0
        local x = minX
        Timed.echo(0.02, function ()
            if x <= maxX then
                local xVase = x
                local y = minY
                local nowEnd = false
                Timed.echo(0.02, function ()
                    if y <= maxY then
                        i = i + 1
                        func(xVase, y, i)
                        y = y + CELL_SIZE
                    else
                        if nowEnd then
                            coroutine.resume(co)
                        end
                        return true
                    end
                end)
                x = x + CELL_SIZE
                if x > maxX then
                    nowEnd = true
                end
            else
                return true
            end
        end)
        coroutine.yield()
    end

    ---@return boolean
    local function checkPath()
        local co = coroutine.running()
        local pf = Pathfinder.create(maxX - 64., centerY, minX + 64., centerY)
        pf.stepDelay = 1
        pf.outputPath = false
        pf.debug = true
        pf:setCond(function (x, y)
            return RectContainsCoords(arena, x, y) and IsTerrainWalkable(x, y)
        end)
        pf:search(function (sucess, _)
            coroutine.resume(co, sucess)
        end)
        print("check path")
        return coroutine.yield()
    end

    local function createPath()
        local co = coroutine.running()

        for _ = 0, MAX_CHANCE_TO_CREATE_PATH do
            local exit = false
            local pf = Pathfinder.create(maxX - 64., centerY, minX + 64., centerY)
            pf.stepDelay = 1
            pf.outputPath = true
            pf.debug = true
            pf:setCond(function (x, y)
                return RectContainsCoords(arena, x, y) and Noise.octavePerlin2D(x * CONVERSOR * 0.5, y * CONVERSOR * 0.5, 3, 0.1) * bj_CLIFFHEIGHT > 0.09
            end)
            pf:search(function (sucess, path)
                if sucess then
                    exit = true
                    for _, n in ipairs(path) do
                        SetTerrainPathable(n.posX, n.posY, PATHING_TYPE_WALKABILITY, true)
                    end
                end
                coroutine.resume(co)
            end)
            print("create path")
            coroutine.yield()
            if exit then
                return
            end
            Noise.generatePermutationTable()
        end
        print("An acceptable path between the 2 players couldn't be created in the expected time.")
    end

    coroutine.wrap(function ()
        local radius = height / 3
        forEachCell(function (x, y, i)
            if DistanceBetweenCoords(x, y, maxX, centerY) < radius or DistanceBetweenCoords(x, y, minX, centerY) < radius then
                bannedCells[i] = true
            end
            pointIndex[math.floor(x)][math.floor(y)] = i
        end)
    end)()

    ---@param e effect
    local function InsertEffect(e)
        if #effects == 0 or #effects[#effects] == ROW_SIZE then
            table.insert(effects, {})
        end
        table.insert(effects[#effects], e)
    end

    ---@param t terraindeformation
    local function InsertTerrainDeformation(t)
        if #terrainDeformations == 0 or #terrainDeformations[#terrainDeformations] == ROW_SIZE then
            table.insert(terrainDeformations, {})
        end
        table.insert(terrainDeformations[#terrainDeformations], t)
    end

    function GenerateNativeForestArena()
        forEachCell(function (x, y, i)
            local a = Noise.openSimplex2D(x * udg_NativeForestAmplitude * CONVERSOR, y * udg_NativeForestAmplitude * CONVERSOR)
            if a < 0.03 then
                SetTerrainType(x, y, udg_NativeForestRoadTile, -1, 1, 1)
            else
                SetTerrainType(x, y, udg_NativeForestSideWalkTile, -1, 1, 1)
                if a >= 0.25 and a <= 0.35 then
                    if math.random() < 0.05 then
                        local f = AddSpecialEffect(udg_NativeForestUncommonDecoration, x, y)
                        BlzSetSpecialEffectScale(f, GetRandomReal(0.8, 1.2))
                        BlzSetSpecialEffectYaw(f, GetRandomReal(0, 2*math.pi))
                        InsertEffect(f)
                    end
                    if math.random() < 0.5 then
                        local g = AddSpecialEffect(udg_NativeForestCommonDecoration, x, y)
                        BlzSetSpecialEffectScale(g, GetRandomReal(1.9, 2.1))
                        BlzSetSpecialEffectYaw(g, GetRandomReal(0, 2*math.pi))
                        InsertEffect(g)
                    end
                end
                if a > 0.4 then
                    if not bannedCells[i] then
                        if i & 2 == 0 then
                            local d = AddSpecialEffect(udg_NativeForestMainDestructable, x, y)
                            BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                            BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                            InsertEffect(d)
                        else
                            if math.random() < 0.5 then
                                local s = AddSpecialEffect(udg_NativeForestExtraDecoration, x, y)
                                BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                                BlzSetSpecialEffectScale(s, GetRandomReal(1.6, 1.8))
                                InsertEffect(s)
                            end
                        end
                        SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
                    end
                elseif a >= 0.3 and a < 0.4 then
                    if math.random() < 0.5 then
                        if i & 2 == 0 then
                            if not bannedCells[i] then
                                local d = AddSpecialEffect(udg_NativeForestMainDestructable, x, y)
                                BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                                BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                                InsertEffect(d)
                                SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
                            end
                        else
                            if math.random() < 0.5 then
                                local s = AddSpecialEffect(udg_NativeForestExtraDecoration, x, y)
                                BlzSetSpecialEffectScale(s, GetRandomReal(1.6, 1.8))
                                BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                                InsertEffect(s)
                            end
                        end
                    end
                end
            end
        end)
    end

    function GenerateGearSavannaArena()
        forEachCell(function (x, y, i)
            local a = Noise.openSimplex2D(x * udg_GearSavannaAmplitude * CONVERSOR, y * udg_GearSavannaAmplitude * CONVERSOR * 1.4)

            if i == 1 then
                local o = Noise.octavePerlin2D(x * CONVERSOR, y * CONVERSOR, 3, 1)
                InsertTerrainDeformation(TerrainDeformCrater(x, y, 639, -o*bj_CLIFFHEIGHT, 0, true))
            end

            if a < -0.2 then
                SetTerrainType(x, y, udg_GearSavannaRoadTile, -1, 1, 1)
            else
                SetTerrainType(x, y, udg_GearSavannaSideWalkTile, -1, 1, 1)
                if a > 0.3 then
                    local dont = false
                    ForEachCellInRange(x, y, 448, function (x2, y2)
                        if not IsTerrainWalkable(x2, y2) then
                            dont = true
                            return true
                        end
                    end)
                    if dont then
                        return
                    end
                    local r = math.random()
                    if r < 0.03 then
                        if not bannedCells[i] then
                            local d = AddSpecialEffect(udg_GearSavannaMainDestructable, x, y)
                            BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                            BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                            InsertEffect(d)

                            SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
                        end

                        ForEachCellInRange(x, y, 256, function (x2, y2)
                            local s = AddSpecialEffect(udg_GearSavannaCommonDecoration, x2, y2)
                            BlzSetSpecialEffectScale(s, GetRandomReal(1.6, 2.))
                            BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                            InsertEffect(s)
                        end)
                    elseif r < 0.06 then
                        if not bannedCells[i] then
                            local g = AddSpecialEffect(udg_GearSavannaExtraDecoration, x, y)
                            BlzSetSpecialEffectYaw(g, GetRandomReal(0, 2*math.pi))
                            BlzSetSpecialEffectScale(g, GetRandomReal(1.6, 3.1))
                            InsertEffect(g)

                            ForEachCellInArea(x, y, 64., function (x2, y2)
                                SetTerrainPathable(x2, y2, PATHING_TYPE_WALKABILITY, false)
                            end, 0.5)
                        end

                        if not bannedCells[i] then
                            ForEachCellInRange(x, y, 128, function (x2, y2)
                                if math.random() < 0.5 then
                                    local s = AddSpecialEffect(udg_GearSavannaSecondDestructable, x2, y2)
                                    BlzSetSpecialEffectScale(s, GetRandomReal(1.5, 2.))
                                    BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                                    InsertEffect(s)

                                    ForEachCellInArea(x2, y2, 96., function (x3, y3)
                                        SetTerrainPathable(x3, y3, PATHING_TYPE_WALKABILITY, false)
                                    end, 0.5)
                                end
                            end)
                        end
                    elseif r < 0.09 then

                    elseif r < 0.12 then

                    end
                end
            end
        end)
    end

    function GenerateMistyTreesArena()
        local alreadyAMist = {} ---@type location[]
        weather = AddWeatherEffect(arena, FourCC('WOlw')) -- Outland wind light
        forEachCell(function (x, y, i)
            local a = Noise.openSimplex2D(x * udg_MistyTreesAmplitude * CONVERSOR, y * udg_MistyTreesAmplitude * CONVERSOR)

            if a < -0.25 then
                SetTerrainType(x, y, udg_MistyTreesRoadTile, -1, 1, 1)
            else
                SetTerrainType(x, y, udg_MistyTreesSideWalkTile, -1, 1, 1)
                if a > 0.2 then
                    if not bannedCells[i] then
                        local r
                        local rd = math.random()
                        if rd < 0.6 then
                            r = udg_MistyTreesMainDestructable
                        elseif rd < 0.8 then
                            r = udg_MistyTreesSecondDestructable
                        else
                            r = udg_MistyTreesThirdDestructable
                        end
                        local d = AddSpecialEffect(r, x, y)
                        BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                        if r == udg_MistyTreesSecondDestructable then
                            BlzSetSpecialEffectColor(d, 180, 180, 255)
                            BlzSetSpecialEffectScale(d, GetRandomReal(0.6, 0.8))
                        else
                            BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                        end
                        if r == udg_MistyTreesThirdDestructable then
                            BlzSetSpecialEffectColor(d, 100, 140, 100)
                            ForEachCellInArea(x, y, 96., function (x2, y2)
                                SetTerrainPathable(x2, y2, PATHING_TYPE_WALKABILITY, false)
                            end, 0.5)
                        else
                            SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
                        end
                        InsertEffect(d)

                        if a > 0.4 then
                            local yes = true
                            for j = 1, #alreadyAMist do
                                if DistanceBetweenCoords(x, y, GetLocationX(alreadyAMist[j]), GetLocationY(alreadyAMist[j])) < 500 then
                                    yes = false
                                    break
                                end
                            end
                            if yes then
                                local m = AddSpecialEffect(udg_MistyTreesCommonDecoration, x, y)
                                BlzSetSpecialEffectYaw(m, GetRandomReal(0, 2*math.pi))
                                BlzSetSpecialEffectScale(m, 15.)
                                InsertEffect(m)
                                table.insert(alreadyAMist, Location(x, y))
                            end
                        end
                    end
                end
            end
        end)
        for j = 1, #alreadyAMist do
            RemoveLocation(alreadyAMist[j])
        end
        print(checkPath())
        if false then
            createPath()
        end
    end

    function RestartSpecialArena()
        if weather then
            RemoveWeatherEffect(weather)
            weather = nil
        end
        forEachCell(function (x, y)
            SetTerrainType(x, y, VOID, 0, 1, 0)
            SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, true)
        end)

        local e_i = #effects
        local t_i = #terrainDeformations
        local co = coroutine.running()
        Timed.echo(0.02, function ()
            if e_i >= 1 or t_i >= 1 then
                local eVase = e_i
                local tVase = t_i
                local e_j = eVase > 0 and #effects[eVase] or 0
                local t_j = tVase > 0 and #terrainDeformations[tVase] or 0
                Timed.echo(0.02, function ()
                    if e_j >= 1 or t_j >= 1 then
                        local e = effects[eVase] and effects[eVase][e_j]
                        if e then
                            DestroyEffect(e)
                            table.remove(effects[eVase], e_j)
                        end
                        local t = terrainDeformations[tVase] and terrainDeformations[tVase][t_j]
                        if t then
                            TerrainDeformStop(t, 0)
                            table.remove(terrainDeformations[tVase], t_j)
                        end
                        e_j = e_j - 1
                        t_j = t_j - 1
                    else
                        table.remove(effects)
                        table.remove(terrainDeformations)
                        return true
                    end
                end)
                e_i = e_i - 1
                t_i = t_i - 1
            else
                coroutine.resume(co)
                return true
            end
        end)
        coroutine.yield()
        Noise.generatePermutationTable()
    end

    -- Tests
    if false then return end

    math.randomseed(os.time())

    OnInit.final(function ()
        local g = true
        local f
        f = function ()
            if g then
                GenerateMistyTreesArena()
                --[[local r = math.random()
                if r < 0.33 then
                    GenerateNativeForestArena()
                elseif r < 0.66 then
                    GenerateGearSavannaArena()
                else
                end]]
            else
                RestartSpecialArena()
            end
            g = not g

            PolledWait(10.)

            f()
        end
        f()
    end)
end)
Debug.endFile()