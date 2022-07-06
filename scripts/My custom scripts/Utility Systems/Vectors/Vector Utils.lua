if Vec2 then
    -- This library overwrites all the location functions to use Vec2 instead

    ---@class location : Vec2

    ---@param x real
    ---@param y real
    ---@return Vec2
    function Location(x, y)
        return Vec2.new(x, y)
    end

    ---@param whichLocation Vec2
    ---@return real
    function GetLocationX(whichLocation)
        return whichLocation.x
    end

    ---@param whichLocation Vec2
    ---@return real
    function GetLocationY(whichLocation)
        return whichLocation.y
    end

    ---@param whichLocation Vec2
    function RemoveLocation(whichLocation)
    end

    ---@param locA Vec2
    ---@param locB Vec2
    ---@return real
    function AngleBetweenPoints(locA, locB)
        return bj_RADTODEG * locA:angleTo(locB)
    end

    ---@param locA Vec2
    ---@param locB Vec2
    ---@return real
    function DistanceBetweenPoints(locA, locB)
        return locA:dist(locB)
    end

    ---@param source Vec2
    ---@param dist real
    ---@param angle real
    ---@return Vec2
    function PolarProjectionBJ(source, dist, angle)
        return source:polar(dist, bj_DEGTORAD * angle)
    end

    ---@param loc Vec2
    ---@param dx real
    ---@param dy real
    ---@return Vec2
    function OffsetLocation(loc, dx, dy)
        return Vec2.new(loc.x + dx, loc.y + dy)
    end
end