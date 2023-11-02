Debug.beginFile("Test")
OnInit(function ()

    ---Returns the distance between the given coords
    ---@param x1 number
    ---@param y1 number
    ---@param x2 number
    ---@param y2 number
    ---@return number
    function DistanceBetweenCoords(x1, y1, x2, y2)
        return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
    end

    ---@param num number
    ---@return number
    local function roundUp(num)
        local remainder = ModuloReal(math.abs(num), bj_CELLWIDTH)
        if remainder == 0. then
            return num
        end

        if num < 0 then
            return -(math.abs(num) - remainder);
        else
            return num + bj_CELLWIDTH - remainder;
        end
    end

    ---@param centerX number
    ---@param centerY number
    ---@param range number
    ---@param callback fun(x: number, y: number)
    function ForEachCellInRange(centerX, centerY, range, callback)
        centerX = roundUp(centerX)
        centerY = roundUp(centerY)

        -- Iterate over the center
        callback(centerX, centerY)

        local n = math.ceil(range / bj_CELLWIDTH)

        for i = 1, n do
            -- Iterate over the axis
            local xOffset = i * bj_CELLWIDTH
            callback(centerX + xOffset, centerY)
            callback(centerX, centerY + xOffset)
            callback(centerX - xOffset, centerY)
            callback(centerX, centerY - xOffset)
            -- Iterate over each quadrant
            for j = 1, n do
                local yOffset = j * bj_CELLWIDTH
                if DistanceBetweenCoords(centerX, centerY, centerX + xOffset, centerY + yOffset) <= range then
                    callback(centerX + xOffset, centerY + yOffset)
                    callback(centerX + xOffset, centerY - yOffset)
                    callback(centerX - xOffset, centerY + yOffset)
                    callback(centerX - xOffset, centerY - yOffset)
                end
            end
        end
    end

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "g", true)
    TriggerAddAction(t, function ()
        ForEachCellInRange(GetUnitX(gg_unit_hpea_0000), GetUnitY(gg_unit_hpea_0000), 512, function (x, y)
            SetTerrainType(x, y, FourCC("Lgrs"), -1, 1, 0)
        end)
    end)

    t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "s", true)
    TriggerAddAction(t, function ()
        ForEachCellInRange(GetUnitX(gg_unit_hpea_0000), GetUnitY(gg_unit_hpea_0000), 512, function (x, y)
            CreateUnit(Player(0), FourCC('hpea'), x, y, math.random(0, 360))
        end)
    end)
end)
Debug.endFile()