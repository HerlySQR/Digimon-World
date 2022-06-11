do
    UnitEnum = true

    local ENUM_GROUP = CreateGroup()
    local LOCUST_ID = FourCC('Aloc')

    ---@param x real
    ---@param y real
    ---@param radius real
    ---@param callback fun(u:unit)
    ---@param includeLocust? boolean
    function ForUnitsInRange(x, y, radius, callback, includeLocust)
        local be = Filter(function ()
            local u = GetFilterUnit()
            if not includeLocust or GetUnitAbilityLevel(u, LOCUST_ID) > 0 then
                callback(u)
            end
        end)
        GroupEnumUnitsInRange(ENUM_GROUP, x, y, radius, be)
        DestroyBoolExpr(be)
    end

    ---@param where rect
    ---@param callback fun(u:unit)
    ---@param includeLocust? boolean
    function ForUnitsInRect(where, callback, includeLocust)
        local be = Filter(function ()
            local u = GetFilterUnit()
            if not includeLocust or GetUnitAbilityLevel(u, LOCUST_ID) > 0 then
                callback(u)
            end
        end)
        GroupEnumUnitsInRect(ENUM_GROUP, where, be)
        DestroyBoolExpr(be)
    end

    ---@param whichPlayer player
    ---@param callback fun(u:unit)
    function ForUnitsOfPlayer(whichPlayer, callback)
        local be = Filter(function () callback(GetFilterUnit()) end)
        GroupEnumUnitsOfPlayer(ENUM_GROUP, whichPlayer, be)
        DestroyBoolExpr(be)
    end

    ---@param unitname string
    ---@param callback fun(u:unit)
    function ForUnitsOfType(unitname, callback)
        local be = Filter(function () callback(GetFilterUnit()) end)
        GroupEnumUnitsOfType(ENUM_GROUP, unitname, be)
        DestroyBoolExpr(be)
    end

    ---@param whichPlayer player
    ---@param callback fun(u:unit)
    function ForUnitsSelected(whichPlayer, callback)
        local be = Filter(function () callback(GetFilterUnit()) end)
        GroupEnumUnitsSelected(ENUM_GROUP, whichPlayer, be)
        DestroyBoolExpr(be)
    end

    ---@param x real
    ---@param y real
    ---@param radius real
    ---@param includeLocust? boolean
    ---@return unit
    function GetRandomUnitOnRange(x, y, radius, includeLocust)
        local units = {}
        ForUnitsInRange(x, y, radius, function (u)
            table.insert(units, u)
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
end