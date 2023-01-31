if Debug then Debug.beginFile("Savecode") end
OnInit("Savecode", function ()
    Require "BigNum"

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
        return player_charset():len()
    end

    ---@return string
    local function charset()
        return "!#$%&'()*+,-.0123456789:;=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}`"
    end

    ---@return integer
    local function charsetlen()
        return charset():len()
    end

    ---@return integer
    local function BASE()
        return charsetlen()
    end

    ---@return integer
    local function HASHN()
        return 5000 -- 1./HASHN() is the probability of a random code being valid
    end

    ---@return integer
    local function MAXINT()
        return 2147483647
    end

    ---@param c string
    ---@return integer
    local function player_chartoi(c)
        local i = 1
        local cs = player_charset()
        local len = player_charsetlen()
        while true do
            if i >= len or c == cs:sub(i, i) then break end
            i = i + 1
        end
        return i - 1
    end

    ---@param c string
    ---@return integer
    local function chartoi(c)
        local i = 1
        local cs = charset()
        local len = charsetlen()
        while true do
            if i >= len or c == cs:sub(i, i) then break end
            i = i + 1
        end
        return i - 1
    end

    ---@param i integer
    ---@return string
    local function itochar(i)
        return charset():sub(i+1, i+1)
    end

    --You probably want to use a different char set for this
    --Also, use a hash that doesn't suck so much
    ---@param s string
    ---@return integer
    local function scommhash(s)
        local count = __jarray(0)
        s = s:upper()
        for i = 1, s:len() do
            local x = player_chartoi(s:sub(i, i))
            count[x] = count[x] + 1
        end
        local x = 0
        for i = 0, player_charsetlen() - 1 do
            x = count[i]*count[i]*i + count[i]*x + x + 199
            --print(x .. " " .. count[i])
            --TriggerSleepAction(0.)
        end
        if x < 0 then
            x = -x
        end
        return x
    end

    local function modb(x)
        if x >= BASE() then
            return x - BASE()
        elseif x < 0 then
            return x + BASE()
        else
            return x
        end
    end

    ---@class Savecode
    ---@field digits number    logarithmic approximation
    ---@field bigNum BigNum

    Savecode = {}
    Savecode.__index = Savecode

    ---@return Savecode
    function Savecode.create()
        local sc = setmetatable({}, Savecode)
        sc.digits = 0.
        sc.bigNum = BigNum.create(BASE())
        return sc
    end

    function Savecode:destroy()
        self.bigNum:destroy()
    end

    ---@param val integer
    ---@param max integer
    function Savecode:Encode(val, max)
        self.digits = self.digits + log(max + 1, BASE())
        self.bigNum:MulSmall(max + 1)
        self.bigNum:AddSmall(val)
    end

    ---@param max integer
    ---@return integer
    function Savecode:Decode(max)
        return self.bigNum:DivSmall(max + 1)
    end

    ---@return boolean
    function Savecode:IsEmpty()
        return self.bigNum:IsZero()
    end

    ---@return number
    function Savecode:Length()
        return self.digits
    end

    function Savecode:Clean()
        self.bigNum:Clean()
    end

    -- These functions get too intimate with BigNum_l

    function Savecode:Pad()
        local cur = self.bigNum.list
        local maxlen = math.floor(1.0 + self:Length())
        local prev

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
        local cur = self.bigNum.list
        local s = ""
        while cur do
            s = itochar(cur.leaf) .. s
            cur = cur.next
        end
        return s
    end

    ---@param s string
    function Savecode:FromString(s)
        local i = s:len()
        local cur = BigNum_l.create()
        self.bigNum.list = cur
        while true do
            cur.leaf = chartoi(s:sub(i, i))
            if i <= 1 then break end
            cur.next = BigNum_l.create()
            cur = cur.next
            i = i - 1
        end
    end

    ---@return integer
    function Savecode:Hash()
        local hash = 0
        local cur = self.bigNum.list
        while cur do
            local x = cur.leaf
            hash = ModuloInteger(hash + 79*hash//(x+1) + 293*x//(1+hash - (hash//BASE())*BASE()) + 479, HASHN())
            cur = cur.next
        end
        return hash
    end

    ---this is not cryptographic which is fine for this application
    ---sign = 1 is forward
    ---sign = -1 is backward
    ---@param key integer
    ---@param sign integer
    function Savecode:Obfuscate(key, sign)
        local seed = math.random(0, MAXINT())
        local x
        local cur = self.bigNum.list

        if sign == -1 then
            SetRandomSeed(self.bigNum:LastDigit())
            cur.leaf = modb(cur.leaf + sign*math.random(0, BASE()-1))
            x = cur.leaf
        end

        SetRandomSeed(key)
        while cur do
            local advance

            if sign == -1 then
                advance = cur.leaf
            end
            cur.leaf = modb(cur.leaf + sign*math.random(0, BASE()-1))
            if sign == 1 then
                advance = cur.leaf
            end
            advance = advance + math.random(0, BASE()-1)
            SetRandomSeed(advance)

            x = cur.leaf
            cur = cur.next
        end

        if sign == 1 then
            SetRandomSeed(x)
            self.bigNum.list.leaf = modb(self.bigNum.list.leaf + sign*math.random(0, BASE()-1))
        end

        SetRandomSeed(seed)
    end

    function Savecode:Dump()
        local cur = self.bigNum.list
        local s = "max: " .. self.digits

        while cur do
            s = cur.leaf .. s
            cur = cur.next
        end

        print(s)
    end

    ---@param p player
    ---@param loadtype integer
    function Savecode:Save(p, loadtype)
        local key = scommhash(GetPlayerName(p)) + loadtype*73

        self:Clean()

        local hash = self:Hash()
        self:Encode(hash, HASHN())

        --///////////////////// Save code information.  Comment out next two lines in implementation
        --print("Expected length: " .. math.floor(1.0 + self:Length()))
        --print("Room left in last char: " .. (1. - ModuloReal(self:Length(), 1)))
        --/////////////////////

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
        return c == c:upper()
    end

    ---@param c string
    ---@return boolean
    local function ischar(c)
        return S2I(c) == 0 and c ~= "0"
    end

    ---@param c string
    ---@return integer
    local function chartype(c)
        if ischar(c) then
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
        if ischar(c) then
            if isupper(c) then
                print(c .. " isupper")
            else
                print(c .. " islower")
            end
        else
            print(c .. " isnumber")
        end
    end

    ---@param s string
    ---@return string
    function colorize(s)
        local out = ""
        for i = 1, s:len() do
            local c = s:sub(i, i)
            local ctype = chartype(c)
            if ctype == 0 then
                out = out .. uppercolor() .. c .. "|r"
            elseif ctype == 1 then
                out = out .. lowercolor() .. c .. "|r"
            else
                out = out .. numcolor() .. c .. "|r"
            end
        end
        return out
    end

    local function prop_Savecode()
        --- Data you want to save ---
        local medal1 = 10
        local medal2 = 3
        local medalmax = 13
        local XP = 1337
        local XPmax = 1000000

        local savecode = Savecode.create()

        SetPlayerName(Player(0), "yomp")
        SetPlayerName(Player(1), "fruitcup")

        savecode:Encode(medal1, medalmax)
        savecode:Encode(medal2, medalmax)
        savecode:Encode(XP, XPmax)

        --- Savecode_save generates the savecode for a specific player ---
        local s = savecode:Save(Player(0), 1)
        savecode:destroy()
        --print("Savecode: " .. Savecode_colorize(s))

        --- User writes down code, inputs again ---

        local loadcode = Savecode.create()
        if loadcode:Load(Player(0), s, 1) then
            -- BJDebugMsg("load ok")
        else
            print("load failed")
            return false
        end

        -- Must decode in reverse order of encodes

        -- load object : max value that data can take
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

    --[[OnInit.final(function ()
        assert(prop_Savecode(), "Savecode failed.")
    end)]]
end)
if Debug then Debug.endFile() end