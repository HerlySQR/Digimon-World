do
    local cell = bj_CELLWIDTH / 2

    ---@param place rect
    ---@param typ integer
    function PathBlock(place, typ)
        local startX = GetRectMinX(place)
        local startY = GetRectMinY(place)

        local width = (GetRectMaxX(place) - startX) // cell
        local height = (GetRectMaxY(place) - startY) // cell

        local reachedY = startY
        for _ = 0, height do
            local reachedX = startX
            for _ = 0, width do
                if GetTerrainType(reachedX, reachedY) == typ then
                    SetTerrainPathable(reachedX, reachedY, PATHING_TYPE_WALKABILITY, false)
                end
                reachedX = reachedX + cell
            end
            reachedY = reachedY + cell
        end
    end

    -- For GUI
    OnInit(function ()
        udg_PathBlockRun = CreateTrigger()
        TriggerAddAction(udg_PathBlockRun, function ()
            PathBlock(udg_PathBlockRegion, udg_PathBlockType)
            udg_PathBlockRegion = nil
            udg_PathBlockType = 0
        end)
    end)
end