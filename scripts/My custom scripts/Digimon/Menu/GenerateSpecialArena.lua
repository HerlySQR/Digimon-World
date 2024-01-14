Debug.beginFile("GenerateSpecialArena")
OnInit(function ()
    Require "Noise"
    Require "Timed"

    local arena = gg_rct_SpecialArena ---@type rect
    local minX, minY, maxX, maxY = GetRectMinX(arena), GetRectMinY(arena), GetRectMaxX(arena), GetRectMaxY(arena)
    local effects = {} ---@type effect[][]
    local terrainDeformations = {} ---@type terraindeformation[][]

    local VOID = FourCC('Zsan')
    local CONVERSOR = 1 / (bj_CELLWIDTH * 10)
    local CELL_SIZE = bj_CELLWIDTH / 2
    local ROW_SIZE = (maxY - minY) // CELL_SIZE

    ---@param func fun(x: number, y: number, i: integer)
    local function forEachCell(func)
        local co = coroutine.running()
        local i = 0
        local x = minX
        Timed.echo(0.02, function ()
            if x <= maxX then
                local xVase = x
                local y = minY
                Timed.echo(0.02, function ()
                    if y <= maxY then
                        i = i + 1
                        func(xVase, y, i)
                        y = y + CELL_SIZE
                    else
                        return true
                    end
                end)
                x = x + CELL_SIZE
            else
                coroutine.resume(co)
                return true
            end
        end)
        coroutine.yield()
    end

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
                elseif a >= 0.3 and a < 0.4 then
                    if math.random() < 0.5 then
                        if i & 2 == 0 then
                            local d = AddSpecialEffect(udg_NativeForestMainDestructable, x, y)
                            BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                            BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                            InsertEffect(d)
                            SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)
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
            local a = Noise.openSimplex2D(x * udg_NativeForestAmplitude * CONVERSOR, y * udg_NativeForestAmplitude * CONVERSOR)
            
            local o = Noise.octavePerlin2D(x * CONVERSOR, y * CONVERSOR, 3, 1)
            InsertTerrainDeformation(TerrainDeformCrater(x, y, 63, -o*bj_CLIFFHEIGHT, 0, true))

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
                        local d = AddSpecialEffect(udg_GearSavannaMainDestructable, x, y)
                        BlzSetSpecialEffectYaw(d, GetRandomReal(0, 2*math.pi))
                        BlzSetSpecialEffectScale(d, GetRandomReal(0.8, 1.2))
                        InsertEffect(d)

                        SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)

                        ForEachCellInRange(x, y, 256, function (x2, y2)
                            local s = AddSpecialEffect(udg_NativeForestCommonDecoration, x2, y2)
                            BlzSetSpecialEffectScale(s, GetRandomReal(1.6, 2.))
                            BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                            InsertEffect(s)
                        end)
                    elseif r < 0.06 then
                        local g = AddSpecialEffect(udg_GearSavannaExtraDecoration, x, y)
                        BlzSetSpecialEffectYaw(g, GetRandomReal(0, 2*math.pi))
                        BlzSetSpecialEffectScale(g, GetRandomReal(0.8, 1.2))
                        InsertEffect(g)

                        SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, false)

                        ForEachCellInRange(x, y, 256, function (x2, y2)
                            local s = AddSpecialEffect(udg_NativeForestCommonDecoration, x2, y2)
                            BlzSetSpecialEffectScale(s, GetRandomReal(1.6, 2.))
                            BlzSetSpecialEffectYaw(s, GetRandomReal(0, 2*math.pi))
                            InsertEffect(s)
                        end)
                    elseif r < 0.09 then

                    elseif r < 0.12 then

                    end
                end
            end
        end)
    end

    function RestartSpecialArena()
        forEachCell(function (x, y)
            SetTerrainType(x, y, VOID, 0, 1, 0)
            SetTerrainPathable(x, y, PATHING_TYPE_WALKABILITY, true)
        end)

        local e_i = #effects
        local t_i = #terrainDeformations
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
                return true
            end
        end)
    end

    -- Tests
    if false then return end

    OnInit.final(function ()
        GenerateGearSavannaArena()
    end)
end)
Debug.endFile()