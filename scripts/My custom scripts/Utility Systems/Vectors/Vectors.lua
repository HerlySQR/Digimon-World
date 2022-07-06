do

    ---Vector 2D
    ---@class Vec2
    ---@field x real
    ---@field y real
    Vec2 = {}

    Vec2.__index = Vec2

    ---Creates a new Vec2
    ---@param x real
    ---@param y real
    ---@return Vec2
    function Vec2.new(x, y)
        return setmetatable({x = x, y = y}, Vec2)
    end

    -- Operators

    function Vec2:__unm()
        return Vec2.new(-self.x, -self.y)
    end

    function Vec2:__add(other)
        return Vec2.new(self.x + other.x, self.y + other.y)
    end

    function Vec2:__sub(other)
        return Vec2.new(self.x - other.x, self.y - other.y)
    end

    function Vec2:__mul(other)
        if type(other == "number") then
            return Vec2.new(self.x * other, self.y * other)
        else
            return Vec2.new(self.x * other.x, self.y * other.y)
        end
    end

    function Vec2:__div(other)
        if type(other == "number") then
            return Vec2.new(self.x / other, self.y / other)
        else
            return Vec2.new(self.x / other.x, self.y / other.y)
        end
    end

    function Vec2:__idiv(other)
        if type(other == "number") then
            return Vec2.new(self.x // other, self.y // other)
        else
            return Vec2.new(self.x // other.x, self.y // other.y)
        end
    end

    function Vec2:__eq(other)
        return self.x == other.x and self.y == other.y
    end

    function Vec2:__concat(other)
        return self.x * other.x + self.y * other.y
    end

    -- Functions

    ---@return Vec2
    function Vec2:getCopy()
        return Vec2.new(self.x, self.y)
    end

    ---@return real
    function Vec2:getSize()
        return math.sqrt(self.x^2 + self.y^2)
    end

    ---@return real
    function Vec2:getSizeSq()
        return self.x^2 + self.y^2
    end

    ---@return Vec2
    function Vec2:getNormalized()
        local size = self:getSize()
        return Vec2.new(self.x / size, self.y / size)
    end

    -- Math

    ---@param vec1 Vec2
    ---@param vec2 Vec2
    ---@return real
    function Vec2.dist(vec1, vec2)
        return math.sqrt((vec1.x - vec2.x)^2 + (vec1.y - vec2.y)^2)
    end

    ---@param vec1 Vec2
    ---@param vec2 Vec2
    ---@return real
    function Vec2.distSq(vec1, vec2)
        return (vec1.x - vec2.x)^2 + (vec1.y - vec2.y)^2
    end

    ---Angle between points
    ---@param vec1 Vec2
    ---@param vec2 Vec2
    ---@return real
    function Vec2.angleTo(vec1, vec2)
        return math.atan(vec2.y - vec1.y, vec2.x - vec1.x)
    end

    ---Angle between vectors
    ---@param vec1 Vec2
    ---@param vec2 Vec2
    ---@return real
    function Vec2.angleBetween(vec1, vec2)
        return math.acos((vec1 .. vec2) / (vec1:getSize() * vec2:getSize()))
    end

    ---Linear interpolation
    ---@param min Vec2
    ---@param max Vec2
    ---@param ratio real
    ---@return Vec2
    function Vec2.lerp(min, max, ratio)
        return min + (max - min) * ratio
    end

    ---Polar projection
    ---@param vec Vec2
    ---@param dist real
    ---@param angle real
    ---@return Vec2
    function Vec2.polar(vec, dist, angle)
        return Vec2.new(vec.x + dist * math.cos(angle), vec.y + dist * math.sin(angle))
    end

end