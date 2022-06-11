do
    ---prefer algebraic approach because of real subtraction issues
    ---@param y real
    ---@param base real
    ---@return real
    function log(y, base)
        local factor = 1.0
        local logy = 0.0
        local sign = 1.0

        if y < 0. then
            return 0.0
        end

        if(y < 1.) then
            y = 1.0/y
            sign = -1.0
        end

        --Chop out powers of the base
        while not (y < 1.0001) do    -- decrease this (bounded below by 1) to improve precision
            if y > base then
                y = y / base
                logy = logy + factor
            else
                base = SquareRoot(base)     -- If you use just one base a lot, precompute its squareroots
                factor = factor / 2.
            end
        end
        return sign * logy
    end

    --Conversion by vJass2Lua v0.7.0.2

    ---@class BigNum_l
    ---@field leaf integer
    ---@field next BigNum_l
    BigNum_l = {}
    BigNum_l.__index = BigNum_l

    ---@return BigNum_l
    function BigNum_l.create()
        local bl = setmetatable({}, BigNum_l)
        bl.next = nil
        bl.leaf = 0
        return bl
    end

    function BigNum_l:destroy()
        self.leaf = nil
        self.next = nil
    end

    ---@return boolean wantDestroy
    function BigNum_l:Clean()
        if not self.next and self.leaf == 0 then
            return true
        elseif self.next and self.next:Clean() then
            self.next:destroy()
            self.next = nil
            return self.leaf == 0
        else
            return false
        end
    end

    ---@param base integer
    ---@param denom integer
    ---@return integer
    function BigNum_l:DivSmall(base, denom)
        local remainder = 0

        if self.next then
            remainder = self.next:DivSmall(base, denom)
        end

        local num = self.leaf + remainder * base
        local quotient = num // denom
        remainder = num - quotient * denom
        self.leaf = quotient

        return remainder
    end

    ---@class BigNum
    ---@field list BigNum_l
    ---@field base integer
    BigNum = {}
    BigNum.__index = BigNum

    ---@param base integer
    ---@return BigNum
    function BigNum.create(base)
        local b = setmetatable({}, BigNum)
        b.list = nil
        b.base = base
        return b
    end

    function BigNum:destroy()
        local cur = self.list
        while cur do
            local next = cur.next
            cur:destroy()
            cur = next
        end
    end

    ---@return boolean
    function BigNum:IsZero()
        local cur = self.list
        while cur do
            if cur.leaf ~= 0 then
                return false
            end
            cur = cur.next
        end
        return true
    end

    function BigNum:Dump()
        local s = ""
        local cur = self.list
        while cur do
            s = cur.leaf .. " " .. s
            cur = cur.next
        end
        print(s)
    end

    function BigNum:Clean()
        self.list:Clean()
    end

	---fails if bignum is nil,
	---BASE() + carry must be less than MAXINT()
    ---@param carry integer
	function BigNum:AddSmall(carry)
		local cur = self.list

		if not cur then
			cur = BigNum_l.create()
			self.list = cur
		end

		while carry ~= 0 do
            local sum = cur.leaf + carry
			carry = sum // self.base
			sum = sum - carry * self.base
			cur.leaf = sum

			if not cur.next then
				cur.next = BigNum_l.create()
			end
			cur = cur.next
		end
	end

	---x*BASE() must be less than MAXINT()
    ---@param x integer
	function BigNum:MulSmall(x)
		local cur = self.list
		local carry = 0
		while cur or carry ~= 0 do
            local product = x * cur.leaf + carry
			carry = product // self.base
            local remainder = product - carry * self.base
			cur.leaf = remainder
			if not cur.next and carry ~= 0 then
				cur.next = BigNum_l.create()
			end
			cur = cur.next
		end
	end

	---Returns remainder
    ---@param denom integer
    ---@return integer
	function BigNum:DivSmall(denom)
		return self.list:DivSmall(self.base, denom)
	end

    ---@return integer
	function BigNum:LastDigit()
		local cur = self.list
		while true do
		    local next = cur.next
            if not next then break end
			cur = next
		end
		return cur.leaf
	end

    ---@return boolean
    local function prop_Allocator1()
        local b1 = nil ---@type BigNum
        local b2 = nil ---@type BigNum
        b1 = BigNum.create(37)
        b1:destroy()
        b2 = BigNum.create(37)
        b2:destroy()
        return b1 == b2
    end

    ---@return boolean
    local function prop_Allocator2()
        local b1 = nil ---@type BigNum
        local b  = false ---@type boolean
        b1 = BigNum.create(37)
        b1:AddSmall(17)
        b1:MulSmall(19)
        --if BigNum_l.nalloc < 1 then
        --return false
        --endif
        b1:destroy()
        -- b = BigNum_l.nalloc == 0
        return b
    end

    ---@return boolean
    local function prop_Arith()
        local b1 = nil ---@type BigNum
        b1 = BigNum.create(37)
        b1:AddSmall(73)
        b1:MulSmall(39)
        b1:AddSmall(17)
        --n = 2864
        if b1:DivSmall(100) ~= 64 then
            return false
        elseif b1:DivSmall(7) ~= 0 then
            return false
        elseif b1:IsZero() then
            return false
        elseif b1:DivSmall(3) ~= 1 then
            return false
        elseif b1:DivSmall(3) ~= 1 then
            return false
        elseif not b1:IsZero() then
            return false
        end
        return true
    end
end