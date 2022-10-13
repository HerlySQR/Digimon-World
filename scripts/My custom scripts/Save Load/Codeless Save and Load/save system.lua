OnLibraryInit({name = "Savecode", "BigNum"}, function ()

    ---@return string
    local function uppercolor()
        return "|cffff0000"
    end

    ---@return string
    local function lowercolor()
        return "|cff00ff00"
    end

    ---@return string
    local function numcolor()
        return "|cff0000ff"
    end

    ---@return string
    local function player_charset()
        return "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end

    ---@return integer
    local function player_charsetlen()
        return StringLength(player_charset())
    end

    ---@return string
    local function charset()
        return "!#$%&'()*+,-.0123456789:;=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}`"
    end

    ---@return integer
    local function charsetlen()
        return StringLength(charset())
    end

    ---@return integer
    local function BASE()
        return charsetlen()
    end

    ---@return integer
    local function HASHN()
        return 5000 --1./HASHN() is the probability of a random code being valid
    end

    ---@return integer
    local function MAXINT()
        return 2147483647
    end

    ---@param c string
    ---@return integer
    local function player_chartoi(c)
        local i = 0
        local cs = player_charset()
        local len = player_charsetlen()
        while not(i >= len or c == SubString(cs, i, i + 1)) do
            i = i + 1
        end
        return i
    end

    ---@param c string
    ---@return integer
    local function chartoi(c)
        local i = 0
        local cs = charset()
        local len = charsetlen()
        while not(i >= len or c == SubString(cs, i, i + 1)) do
            i = i + 1
        end
        return i
    end

    ---@param i integer
    ---@return string
    local function itochar(i)
        return SubString(charset(), i, i + 1)
    end

    ---You probably want to use a different char set for this.
    ---Also, use a hash that doesn't suck so much
    ---@param s string
    ---@return integer
    local function scommhash(s)
        local count = {} ---@type integer[]
        local len = StringLength(s)
        local x = nil ---@type integer
        s = StringCase(s, true)
        for i = 0, len do
            x = player_chartoi(SubString(s, i, i + 1))
            count[x] = (count[x] or 0) + 1
        end
        len = player_charsetlen()
        x = 0
        for i = 0, len - 1 do
            count[i] = count[i] or 0
            x = count[i]*count[i]*i+count[i]*x+x+199
            --BJDebugMsg(I2S(x) .. " " .. I2S(count[i]))
            --TriggerSleepAction(0.)
        end
        if x < 0 then
            x = -x
        end
        return x
    end

    ---@param x integer
    ---@return integer
    local function modb(x)
        if x >= BASE() then
            return x - BASE()
        elseif x < 0 then
            return x + BASE()
        else
            return x
        end
    end
    --Conversion by vJass2Lua v0.7.0.2

    ---@class Savecode
    ---@field digits number -- logarithmic approximation
    ---@field bignum BigNum
    Savecode = {}
    Savecode.__index = Savecode

    ---@return Savecode
    function Savecode.create()
        local sc = setmetatable({}, Savecode)
        sc.digits = 0
        sc.bignum = BigNum.create(BASE())
        return sc
    end

    function Savecode:destroy()
        self.bignum:destroy()
    end

    ---@param val integer
    ---@param max integer
    function Savecode:Encode(val, max)
        self.digits = self.digits + log(max + 1, BASE())
        self.bignum:MulSmall(max + 1)
        self.bignum:AddSmall(val)
    end

    ---@param max integer
    function Savecode:Decode(max)
        return self.bignum:DivSmall(max+1)
    end

    ---@return boolean
    function Savecode:IsEmpty()
        return self.bignum:IsZero()
    end

    ---@return number
    function Savecode:Length()
        return self.digits
    end

    function Savecode:Clean()
        self.bignum:Clean()
    end

    -- These functions get too intimate with BigNum_l

    function Savecode:Pad()
        local cur = self.bignum.list
        local prev ---@type BigNum_l
        local maxlen = R2I(1.0 + self:Length())

        while cur do
            prev = cur
            cur = cur.next
            maxlen = maxlen - 1
        end
        while maxlen > 0 do
            prev.next = BigNum_l.create()
            prev = prev.next
            maxlen = maxlen - 1
        end
    end

    ---@return string
    function Savecode:ToString()
        local cur = self.bignum.list
        local s = ""
        while cur do
            s = itochar(cur.leaf) .. s
            cur = cur.next
        end
        return s
    end

    ---@param s string
    function Savecode:FromString(s)
        local i = StringLength(s) - 1
        local cur = BigNum_l.create()
        self.bignum.list = cur
        while true do
            cur.leaf = chartoi(SubString(s, i, i + 1))
            if i <= 0 then break end
            cur.next = BigNum_l.create()
            cur = cur.next
            i = i - 1
        end
    end

    ---@return integer
    function Savecode:Hash()
        local hash = 0
        local cur = self.bignum.list
        while cur do
            local x = cur.leaf
            hash = ModuloInteger(hash + 79*hash//(x+1) + 293*x//(1+hash - (hash//BASE())*BASE()) + 479, HASHN())
            cur = cur.next
        end
        return hash
    end

    ---this is not cryptographic which is fine for this application,
    ---sign = 1 is forward,
    ---sign = -1 is backward
    ---@param key integer
    ---@param sign integer
    function Savecode:Obfuscate(key, sign)
        local seed = GetRandomInt(0, MAXINT())
        local x = 0
        local cur = self.bignum.list


        if sign == -1 then
            SetRandomSeed(self.bignum:LastDigit())
            cur.leaf = modb(cur.leaf + sign * GetRandomInt(0, BASE()-1))
            x = cur.leaf
        end

        SetRandomSeed(key)
        while cur do
            local advance = 0
            if sign == -1 then
                advance = cur.leaf or 0
            end
            cur.leaf = modb(cur.leaf + sign * GetRandomInt(0, BASE()-1))
            if sign == 1 then
                advance = cur.leaf
            end
            advance = advance + GetRandomInt(0, BASE()-1)
            SetRandomSeed(advance)

            x = cur.leaf
            cur = cur.next
        end

        if sign == 1 then
            SetRandomSeed(x)
            self.bignum.list.leaf = modb(self.bignum.list.leaf + sign*GetRandomInt(0, BASE()-1))
        end

        SetRandomSeed(seed)
    end

    function Savecode:Dump()
        local cur = self.bignum.list
        local s = ""
        s = "max: " .. R2S(self.digits)

        while cur == 0 do
            s = cur.leaf .. " " .. s
            cur = cur.next
        end
        print(s)
    end

    ---@param p player
    ---@param loadtype integer
    ---@return string
    function Savecode:Save(p, loadtype)
        local key = scommhash(GetPlayerName(p)) + loadtype*73

        self:Clean()

        local hash = self:Hash()
        self:Encode(hash, HASHN())
        self:Clean()

        --
        -- Save code information.  Comment out next two lines in implementation
        --call BJDebugMsg("Expected length: " +I2S(R2I(1.0+.Length())))
        --call BJDebugMsg("Room left in last char: "+R2S(1.-ModuloReal((.Length()),1)))
        --

        self:Pad()
        self:Obfuscate(key, 1)
        return self:ToString()
    end

    ---@param p player
    ---@param s string
    ---@param loadtype integer
    ---@return boolean
    function Savecode:Load(p, s, loadtype)
        local ikey = scommhash(GetPlayerName(p)) + loadtype*73

        self:FromString(s)
        self:Obfuscate(ikey, -1)
        local inputhash = self:Decode(HASHN())

        self:Clean()

        return inputhash == self:Hash()
    end

    ---@param c string
    ---@return boolean
    local function isupper(c)
        return c == string.upper(c)
    end

    ---@param c string
    ---@return boolean
    local function ischar(c)
        return S2I(c) == 0 and c ~= "0"
    end

    ---@param c string
    ---@return integer
    local function chartype(c)
        if(ischar(c)) then
            if isupper(c) then
                return 0
            else
                return 1
            end
        else
            return 2
        end
    end

    ---@param c string
    local function testchar(c)
        if(ischar(c)) then
            if isupper(c) then
                BJDebugMsg(c.." isupper")
            else
                BJDebugMsg(c.." islower")
            end
        else
            BJDebugMsg(c.." isnumber")
        end
    end


    ---@param s string
    ---@return string
    function colorize(s)
        local out  = "" ---@type string
        local i  = 0 ---@type integer
        local len  = StringLength(s) ---@type integer
        local ctype = nil ---@type integer
        local c = nil ---@type string
        while not(i >= len) do
            c = SubString(s, i, i+1)
            ctype = chartype(c)
            if ctype == 0 then
                out = out .. uppercolor() .. c.. "|r"
            elseif ctype == 1 then
                out = out .. lowercolor().. c .. "|r"
            else
                out = out .. numcolor() .. c .. "|r"
            end
            i = i + 1
        end
        return out
    end

    ---@return boolean
    local function prop_Savecode()
        local s = nil ---@type string
        local loadcode = nil ---@type Savecode

    ----- Data you want to save ---
        local medal1  = 10 ---@type integer
        local medal2  = 3 ---@type integer
        local medalmax  = 13 ---@type integer
        local XP  = 1337 ---@type integer
        local XPmax  = 1000000 ---@type integer

        local savecode  = Savecode:create() ---@type Savecode

        SetPlayerName(Player(0), "yomp")
        SetPlayerName(Player(1), "fruitcup")

        savecode:Encode(medal1, medalmax)
        savecode:Encode(medal2, medalmax)
        savecode:Encode(XP, XPmax)

    ----- Savecode_save generates the savecode for a specific player ---
        s = savecode:Save(Player(0), 1)
        savecode:destroy()
    --  call BJDebugMsg("Savecode: ".. Savecode_colorize(s))

    ----- User writes down code, inputs again ---

        loadcode = Savecode:create()
        if loadcode:Load(Player(0), s, 1) then
    --      call BJDebugMsg("load ok")
        else
            BJDebugMsg("load failed")
            return false
        end

    --Must decode in reverse order of encodes

    --               load object : max value that data can take
        if XP ~= loadcode:Decode(XPmax) then
            return false
        elseif medal2 ~= loadcode:Decode(medalmax) then
            return false
        elseif medal1 ~= loadcode:Decode(medalmax) then
            return false
        end
        loadcode:destroy()
        return true
    end
    --Conversion by vJass2Lua v0.7.0.2
end)