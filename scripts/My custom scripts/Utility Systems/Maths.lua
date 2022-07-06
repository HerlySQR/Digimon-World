do
    --[[ Library based on Advanced Mathematics v 1.2.0.0 by looking_for_help
    **********************************************************************************
    *
    *   This system provides a large amount of standard mathematical functions that
    *   miss in standard W3 and Lua like logarithmic, hyperbolic, typecheck or rounding
    *   functions that are added to the Lua math library.
    *
    ***********************************************************************************
    *
    *   Implementation
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *   To use this system, just copy this script to your trigger editor, then you
    *   can use it straight away. To see how the evaluation function works, compare
    *   the example IngameCalculator trigger.
    *
    **********************************************************************************
    *
    *   System API
    *   ¯¯¯¯¯¯¯¯¯¯
    *
    *       real math.E
    *           - Refer to this field for the number E, the base of the natural
    *             exponential function.
    *
    *       real math.Phi
    *           - Refer to this field for the number Phi, the golden ratio.
    *
    *       real math.Inf
    *           - Refer to this field for 2^128, the biggest real number Wc3 can 
    *             handle. You can use -Math.Inf to get the smallest real number.
    *
    *       function math.sig(real r) returns real
    *           - Extracts the sign of a real number.
    *
    *       function math.max(real r1, real r2) returns real
    *           - Returns the bigger of two values r1 and r2.
    *
    *       function math.min(real r1, real r2) returns real
    *           - Returns the smaller of two values r1 and r2.
    *
    *       function math.mod(real r1, real r2 ) returns real
    *           - Computes the rest of the division r1/r2.
    *
    *       function math.modInt(integer n1, integer n2) returns integer
    *           - Computes the modulo of n1/n2.
    *
    *       function math.multiMod(integer n1, integer n2, integer mod) returns integer
    *           - Computes the modulo of n1*n2/mod. Use this to compute the
    *             modulo of very large numbers.
    *
    *       function math.expMod(integer x, integer n, integer modulo) returns integer
    *           - Computes the modulo of x^n/modulo. Use this to compute the
    *             modulo of extremly large numbers.
    *
    *       function math.digits(real r) returns integer
    *           - Returns the number of digits before the comma of a given real number.
    *
    *       function math.isDigit(string s) returns boolean
    *           - Determines whether a string is a digit or not.
    *
    *       function math.isInteger(real r) returns boolean
    *           - Determines whether a real is integer or not.
    *
    *       function math.isEven(real r) returns boolean
    *           - Determines the parity of a real number.
    *
    *       function math.isPrime(real r) returns boolean
    *           - Determines whether a number is a prime or not by using a deterministic
    *             version of the Miller-Rabin test.
    *
    *       function math.sinh(real r) returns real
    *           - Computes the hyperbolic sine of a real number.
    *
    *       function math.cosh(real r) returns real
    *           - Computes the hyperbolic cosine of a real number.
    *
    *       function math.tanh(real r) returns real
    *           - Computes the hyperbolic tangent of a real number.
    *
    *       function math.asinh(real r) returns real
    *           - Computes the inverse hyperbolic sine of a real number.
    *
    *       function math.acosh(real r) returns real
    *           - Computes the inverse hyperbolic cosine of a real number.
    *
    *       function math.atanh(real r) returns real
    *           - Computes the inverse hyperbolic tangent of a real number.
    *
    *       function math.round(real r) returns real
    *           - Rounds a number to the nearest whole number.
    *
    *       function math.fractional(real r) returns real
    *           - Computes the fractional part of a number.
    *
    *       function math.mergeFloat(real r) returns real
    *           - Merges the fracional and the non fractional parts of a number
    *             together to an integer number.
    *
    *       function math.factorial(real r) returns real
    *           - Computes the factorial of a number r. If r is not a natural
    *             number, the gamma function as an extension to the factorial
    *             function is used.
    *
    ********************************************************************************]]
    --[[
    *************************************************************************
    *   Customizable values
    *************************************************************************
    ]]

    -- Do you want the system to store primes that were once detected?
    local STORE_DETECTED_PRIMES = true

    --[[
    ************************************************************************
    *   End of customizable values
    ************************************************************************
    ]]

    -- For easy localization
    local math = math
    local string = string

    ---Refer to this field for the number E, the base of the natural exponential function.
    math.E = 2.718282
    ---Refer to this field for the number Phi, the golden ratio.
    math.Phi = 1.618034
    ---Refer to this field for 2^128, the biggest real number Wc3 can handle. You can use -Math.Inf to get the smallest real number.
    math.Inf = 2^128

    ---Extracts the sign of a number.
    ---@param r number
    ---@return integer
    function math.sig(r)
        return r < 0 and -1 or (r > 0 and 1 or 0)
    end

    ---Computes the rest of the division r1/r2.
    ---@param r1 real
    ---@param r2 real
    ---@return real
    function math.mod(r1, r2)
        local modulus = r1 - I2R(R2I(r1/r2))*r2

        if modulus < 0 then
            modulus = modulus + r2
        end
        return modulus
    end

    ---Computes the modulo of n1/n2.
    ---
    ---The normal mod simbol is cursed
    ---@param n1 integer
    ---@param n2 integer
    ---@return integer
    function math.modInt(n1, n2)
        local modulus = n1 - (n1//n2)*n2
        if modulus < 0 then
            modulus = modulus + n2
        end
        return modulus
    end

    ---Computes the modulo of n1*n2/mod. Use this to compute the modulo of very large numbers.
    ---@param n1 integer
    ---@param n2 integer
    ---@param mod integer
    ---@return integer
    function math.multiMod(n1, n2, mod)
        local factor1 = math.floor(n1/mod)
        local factor2 = math.floor(n2/mod)

        if factor1 == 0 then
            factor1 = 1
        end
        if factor2 == 0 then
            factor2 = 1
        end

        if n1 > mod/2 and n2 > mod/2 then
            n1 = (n1 - factor1*mod)*(n2 - factor2*mod)
        else
            n1 = n1*n2
        end
        n2 = mod

        local modulus = n1 - (n1/n2)*n2
        if modulus < 0 then
            modulus = modulus + n2
        end

        return modulus
    end

    ---Computes the modulo of x^n/modulo. Use this to compute the modulo of extremly large numbers.
    ---@param x integer
    ---@param n integer
    ---@param modulo integer
    ---@return integer
    function math.expMod(x, n, modulo)
        local exponent = ""

        repeat
            if math.modInt(n, 2) == 1 then
                exponent = "1" .. exponent
            else
                exponent = "0" .. exponent
            end
            n = n/2
        until n < 1

        local result = 1
        for i = 1, string.len(exponent) do
            result = math.multiMod(result, result, modulo)
            if string.sub(exponent, i, i) == "1" then
                result = math.multiMod(result, x, modulo)
            end
        end

        return result
    end

    ---Returns the number of digits before the comma of a given real number.
    ---@param r number
    ---@return integer
    function math.digits(r)
        local s = tostring(r)
        local i = 1
        while string.sub(s, i, i) ~= "." do
            i = i + 1
        end
        if r < 0 then
            return i - 1
        end
        return i
    end

    ---Computes the hyperbolic sine of a real number.
    ---
    ---This function was deprecated in Lua 5.3
    ---@param r real
    ---@return real
    function math.sinh(r)
        return (math.exp(r) - math.exp(-r)) / 2
    end

    ---Computes the hyperbolic cosine of a real number.
    ---
    ---This function was deprecated in Lua 5.3
    ---@param r real
    ---@return real
    function math.cosh(r)
        return (math.exp(r) + math.exp(-r)) / 2
    end

    ---Computes the hyperbolic tangent of a real number.
    ---
    ---This function was deprecated in Lua 5.3
    ---@param r real
    ---@return real
    function math.tanh(r)
        return math.sinh(r) / math.cosh(r)
    end

    ---Computes the inverse hyperbolic sine of a real number.
    ---@param r real
    ---@return real
    function math.asinh(r)
        return math.log(r + math.sqrt(r^2 + 1))
    end

    ---Computes the inverse hyperbolic cosine of a real number.
    ---@param r real
    ---@return real
    function math.acosh(r)
        return math.log(r + math.sqrt(r^2 - 1))
    end

    ---Computes the inverse hyperbolic tangent of a real number.
    ---@param r real
    ---@return real
    function math.atanh(r)
        return 0.5 * math.log((1 + r)/(1 - r))
    end

    ---Rounds a number to the nearest whole number.
    ---@param r any
    ---@return integer
    function math.round(r)
        if r > 0 then
            return I2R(R2I(r + 0.5))
        end
        return I2R(R2I(r - 0.5))
    end

    ---Computes the fractional part of a number.
    ---@param r real
    ---@return real
    function math.fractional(r)
        return select(2, math.modf(r))
    end

    ---Merges the fracional and the non fractional parts of a number together to an integer number.
    ---@param r real
    ---@return integer
    function math.mergeFloat(r)
        local beforeC, afterC = math.modf(r)

        if afterC == 0 then
            return beforeC
        end

        local beforeComma = tostring(beforeC)
        local afterComma = tostring(afterC)

        return tonumber(string.sub(beforeComma, 1, string.len(beforeComma) - 2) .. string.sub(afterComma, 2, string.len(afterComma)))
    end

    ---Determines whether a string is a digit or not.
    ---@param s string
    ---@return boolean
    function math.isDigit(s)
        return not (StringLength(s) ~= 1 or S2R(s) == 0 and s ~= "0")
    end

    ---Determines whether a real is integer or not.
    ---@param r number
    ---@return boolean
    function math.isInteger(r)
        return math.type(r) == "integer"
    end

    ---Determines the parity of a real number.
    ---@param r number
    ---@return boolean
    function math.isEven(r)
        return math.mod(r, 2) == 0
    end

    ---Computes the factorial of a number r. If r is not a natural
    ---number, the gamma function as an extension to the factorial
    ---function is used.
    ---@param r number
    ---@return number
    function math.factorial(r)
        if math.isInteger(r) then
            local z = 1.0
            if r < 0 then
                error("Factorial of negative number is not defined!", 2)
            end
            if r == 0 then
                return 1
            end
            while r ~= 0.0 do
                z = z * r
                r = r - 1
            end
            return z
        end
        r = r + 1.0
        return math.sqrt((2*math.pi/r) * (((r + 1.0/(12.0*r - 1.0/(10.0*r)))/math.E)^r))
    end

    -- Is prime

    local function primeTest(a, d, s, n)
        local test = false
        local dSave = d
        local counter = 0
        while counter <= s do
            local modulus = math.expMod(a, d, n)
            if (counter == 0 and modulus == 1) or (counter > 0 and modulus - n == -1) then
                test = true
                break
            end
            d = 2*d

            counter = counter + 1
            if counter == 1 then
                d = dSave
            end
        end
        return test
    end

    local stored = {} ---@type boolean[]
    local isPrime = {} ---@type boolean[]

    ---Determines whether a number is a prime or not by using a deterministic version of the Miller-Rabin test.
    ---@param n integer
    ---@return boolean
    function math.isPrime(n)
        if n == 2 or n == 7 or n == 61 then
            return true
        elseif math.isEven(n) or n < 2 then
            return false
        end

        stored[n] = stored[n] or __jarray(false)
        isPrime[n] = isPrime[n] or __jarray(false)

        if STORE_DETECTED_PRIMES then
            if stored[n] then
                return isPrime[n]
            end
        end

        if n < 157 then
            local a = n
            while a ~= 1 do
                if math.modInt(n, a) == 0 and a ~= n then
                    if STORE_DETECTED_PRIMES then
                        stored[n] = true
                        isPrime[n] = false
                    end
                    return false
                end
                a = a - 1
            end
            if STORE_DETECTED_PRIMES then
                stored[n] = true
                isPrime[n] = true
            end
            return true
        end

        local s = math.floor(math.log(n-1,2))
        while true do
            local temp = R2I(2^s)
            if math.modInt(n - 1, temp) == 0 then break end
            s = s - 1
        end

        local d = (n - 1) // R2I(2^s)
        if primeTest(2, d, s, n) or primeTest(7, d, s, n) or primeTest(61, d, s, n)  then
            if STORE_DETECTED_PRIMES then
                stored[n] = true
                isPrime[n] = true
            end
            return true
        end

        if STORE_DETECTED_PRIMES then
            stored[n] = true
            isPrime[n] = false
        end
        return false
    end
end