OnInit("UnitEnum", function ()

    local ENUM_GROUP = CreateGroup()
    local LOCUST_ID = FourCC('Aloc')

    local callbacks = {} ---@type fun(u: unit)[]
    local filter = Filter(function () callbacks[#callbacks](GetFilterUnit())  end)

    ---@param x number
    ---@param y number
    ---@param radius number
    ---@param callback fun(u:unit)
    ---@param includeLocust? boolean
    function ForUnitsInRange(x, y, radius, callback, includeLocust)
        table.insert(callbacks, function (u)
            if not includeLocust or GetUnitAbilityLevel(u, LOCUST_ID) > 0 then
                callback(u)
            end
        end)
        GroupEnumUnitsInRange(ENUM_GROUP, x, y, radius, filter)
        table.remove(callbacks)
    end

    ---@param where rect
    ---@param callback fun(u:unit)
    ---@param includeLocust? boolean
    function ForUnitsInRect(where, callback, includeLocust)
        table.insert(callbacks, function (u)
            if not includeLocust or GetUnitAbilityLevel(u, LOCUST_ID) > 0 then
                callback(u)
            end
        end)
        GroupEnumUnitsInRect(ENUM_GROUP, where, filter)
        table.remove(callbacks)
    end

    ---@param whichPlayer player
    ---@param callback fun(u:unit)
    function ForUnitsOfPlayer(whichPlayer, callback)
        table.insert(callbacks, callback)
        GroupEnumUnitsOfPlayer(ENUM_GROUP, whichPlayer, filter)
        table.remove(callbacks)
    end

    ---@param unitname string
    ---@param callback fun(u:unit)
    function ForUnitsOfType(unitname, callback)
        table.insert(callbacks, callback)
        GroupEnumUnitsOfType(ENUM_GROUP, unitname, filter)
        table.remove(callbacks)
    end

    ---@param whichPlayer player
    ---@param callback fun(u:unit)
    function ForUnitsSelected(whichPlayer, callback)
        table.insert(callbacks, callback)
        GroupEnumUnitsSelected(ENUM_GROUP, whichPlayer, filter)
        table.remove(callbacks)
    end

    ---@param x number
    ---@param y number
    ---@param radius number
    ---@param matching? fun(u: unit): boolean
    ---@param includeLocust? boolean
    ---@return unit
    function GetRandomUnitOnRange(x, y, radius, matching, includeLocust)
        local units = {}
        ForUnitsInRange(x, y, radius, function (u)
            if not matching or matching(u) then
                table.insert(units, u)
            end
        end, includeLocust)
        return units[math.random(#units)]
    end

    ---@param where rect
    ---@param includeLocust? boolean
    ---@return unit
    function GetRandomUnitOnRect(where, includeLocust)
        local units = {}
        ForUnitsInRect(where, function (u)
            table.insert(units, u)
        end, includeLocust)
        return units[math.random(#units)]
    end
end)