if Debug then Debug.beginFile("GetMainSelectedUnit") end
OnInit("GetMainSelectedUnit", function ()
    ---Returns the local current main selected unit, using it in a sync gamestate relevant manner breaks the game.
    ---@return unit
    function GetMainSelectedUnitEx()
        return GetMainSelectedUnit(GetSelectedUnitIndex())
    end

    local containerFrame
    local frames = {}
    local group
    local units = {}
    local filter = Filter(function()
        local unit = GetFilterUnit()
        local prio = BlzGetUnitRealField(unit, UNIT_RF_PRIORITY)
        local found = false
        -- compare the current unit with allready found, to place it in the right slot
        for index, value in ipairs(units) do
            -- higher prio than this take it's slot
            if BlzGetUnitRealField(value, UNIT_RF_PRIORITY) < prio then
                table.insert(units, index, unit)
                found = true
                break
            -- equal prio and better colisions Value
            elseif BlzGetUnitRealField(value, UNIT_RF_PRIORITY) == prio and GetUnitOrderValue(value) > GetUnitOrderValue(unit) then
                table.insert( units, index, unit)
                found = true
                break
            end
        end
        -- not found add it at the end
        if not found then
            table.insert(units, unit)
        end

        unit = nil
        return false
    end)

    ---@return integer | nil
    function GetSelectedUnitIndex()
        -- local player is in group selection?
        if BlzFrameIsVisible(containerFrame) then
            -- find the first visible yellow Background Frame
            for int = 0, #frames do
                if BlzFrameIsVisible(frames[int]) then
                    return int
                end
            end
        end

        return nil
    end

    ---@param unit unit
    ---@return integer
    function GetUnitOrderValue(unit)
        --heroes use the handleId
        if IsUnitType(unit, UNIT_TYPE_HERO) then
            return GetHandleId(unit)
        else
            --units use unitCode
            return GetUnitTypeId(unit)
        end
    end

    ---@param index integer | nil
    ---@return unit
    function GetMainSelectedUnit(index)
        if index then
            GroupEnumUnitsSelected(group, GetLocalPlayer(), filter)
            local unit = units[index + 1]
            --clear table
            repeat until not table.remove(units)
            return unit
        else
            GroupEnumUnitsSelected(group, GetLocalPlayer(), nil)
            return FirstOfGroup(group)
        end
    end

    --init
    local bottomUI = BlzFrameGetParent(BlzGetFrameByName("SimpleInfoPanelUnitDetail", 0))
    local groupframe = BlzFrameGetChild(bottomUI, 5)
    --globals
    containerFrame = BlzFrameGetChild(groupframe, 0)
    group = CreateGroup()
    -- give this frames a handleId
    for int = 0, BlzFrameGetChildrenCount(containerFrame) - 1 do
        local buttonContainer = BlzFrameGetChild(containerFrame, int)
        frames[int] = BlzFrameGetChild(buttonContainer, 0)
    end
end)
if Debug then Debug.endFile() end