if Debug then Debug.beginFile("BitSet") end
OnInit("BitSet", function ()
    ---A bitset is a set of small integers represented by a single int
    ---@class BitSet
    ---@field private val integer
    BitSet = {}
    BitSet.__index = BitSet

    ---Returns a bitset
    ---@param val? integer
    ---@return BitSet
    function BitSet.create(val)
        return setmetatable({val = val or 0}, BitSet)
    end

    ---@param pow integer
    ---@return boolean
    function BitSet:containsPow(pow)
        return ModuloInteger(self.val, pow * 2) >= pow
    end

    ---Returns the value of the bit with the specified index.
    ---@param index integer
    ---@return boolean
    function BitSet:get(index)
        return self:containsPow(math.floor(2^index))
    end

    ---Sets the bit at the specified index to true.
    ---@param index integer
    ---@return BitSet
    function BitSet:set(index)
        local pow = math.floor(2^index)
        if not self:containsPow(pow) then
            self.val = self.val + pow
        end
        return self
    end

    ---Sets the bit at the specified index to false.
    ---@param index integer
    ---@return BitSet
    function BitSet:reset(index)
        local pow = math.floor(2^index)
        if self:containsPow(pow) then
            self.val = self.val - pow
        end
        return self
    end

    ---Returns an integer representation of the data.
    ---@return integer
    function BitSet:toInt()
        return self.val
    end

    -- Tests:

    local function testContains()
        if not BitSet.create(45):get(0) then
            return false, "a"
        end
        if BitSet.create(45):get(1) then
            return false, "b"
        end
        if not BitSet.create(45):get(2) then
            return false, "c"
        end
        if not BitSet.create(45):get(3) then
            return false, "d"
        end
        if BitSet.create(45):get(4) then
            return false, "e"
        end
        if not BitSet.create(45):get(5) then
            return false, "f"
        end
        return true, ""
    end

    local function testAdd()
        return BitSet.create():set(0):set(2):set(3):set(5):toInt() == 45
    end

    local function testRemove()
        return BitSet.create(45):reset(3):toInt() == 37
    end

    OnInit.final(function ()
        local v, c = testContains()
        assert(v, "Failed testContains " .. c)
        assert(testAdd(), "Failed testAdd")
        assert(testRemove(), "Failed testRemove")
    end)
end)
if Debug then Debug.endFile() end