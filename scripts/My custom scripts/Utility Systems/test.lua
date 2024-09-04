Debug.beginFile("TestSerializable")
OnInit(function ()
    Require "Serializable"
    Require "Savecode"

    local CHUNK_SIZE = 150

    ---@class Nested: Serializable
    ---@field state boolean
    ---@field subname string
    Nested = setmetatable({}, Serializable)
    Nested.__index = Nested

    ---@return Nested | Serializable
    function Nested.create()
        return setmetatable({}, Nested)
    end

    function Nested:serializeProperties()
        self:addProperty("state", self.state)
        self:addProperty("subname", self.subname)
    end

    function Nested:deserializeProperties()
        self.state = self:getBoolProperty("state")
        self.subname = self:getStringProperty("subname")
    end

    ---@class Test: Serializable
    ---@field name string
    ---@field amount integer
    ---@field scale number
    ---@field count integer
    ---@field flag boolean
    ---@field nested Nested
    ---@field stats integer
    ---@field strenght integer
    ---@field agility integer
    ---@field intelligence integer
    Test = setmetatable({}, Serializable)
    Test.__index = Test

    ---@return Test | Serializable
    function Test.create()
        return setmetatable({}, Test)
    end

    function Test:serializeProperties()
        self:addProperty("name", self.name)
        self:addProperty("amount", self.amount)
        self:addProperty("scale", self.scale)
        self:addProperty("count", self.count)
        self:addProperty("flag", self.flag)
        self:addProperty("nested", self.nested:serialize())
        self:addProperty("stats", self.stats)
        self:addProperty("strenght", self.strenght)
        self:addProperty("agility", self.agility)
        self:addProperty("intel", self.intelligence)
    end

    function Test:deserializeProperties()
        self.name = self:getStringProperty("name")
        self.amount = self:getIntProperty("amount")
        self.scale = self:getRealProperty("scale")
        self.count = self:getIntProperty("count")
        self.flag = self:getBoolProperty("flag")
        self.nested = Nested.create()
        self.nested:deserialize(self:getStringProperty("nested"))
        self.stats = self:getIntProperty("stats")
        self.strenght = self:getIntProperty("strenght")
        self.agility = self:getIntProperty("agility")
        self.intelligence = self:getIntProperty("intel")
    end

    ---@param p player
    ---@param s string
    ---@return string
    function EncodeString(p, s)
        local len = s:len()
        local iter = math.floor(len/CHUNK_SIZE)
        local code = ""

        for j = 1, iter do
            local savecode = Savecode.create()

            for i = 1, CHUNK_SIZE do
                savecode:Encode(s:byte((j-1)*CHUNK_SIZE+i), 255)
            end

            code = code .. savecode:Save(p, 1) .. "~"
            savecode:destroy()
        end

        local rest = len - iter*CHUNK_SIZE
        local savecode = Savecode.create()

        for i = 1, rest do
            savecode:Encode(s:byte(iter*CHUNK_SIZE+i), 255)
        end
        savecode:Encode(rest, CHUNK_SIZE)

        code = code .. savecode:Save(p, 1)
        savecode:destroy()


        return code
    end

    ---@param p player
    ---@param s string
    ---@return string?
    function DecodeString(p, s)
        local decode = ""
        local prevBuffer = 1
        local buffer = s:find("~")

        while buffer do
            local sub = s:sub(prevBuffer, buffer - 1)

            local savecode = Savecode.create()
            if not savecode:Load(p, sub, 1) then
                savecode:destroy()
                return nil
            end
            for _ = 1, CHUNK_SIZE do
                decode = string.char(savecode:Decode(255)) .. decode
            end
            savecode:destroy()

            prevBuffer = buffer + 1
            buffer = s:find("~", buffer + 1)
        end

        local sub = s:sub(prevBuffer)
        local savecode = Savecode.create()
        if not savecode:Load(p, sub, 1) then
            savecode:destroy()
            return nil
        end
        local len = savecode:Decode(CHUNK_SIZE)
        local decode2 = ""
        for _ = 1, len do
            decode2 = string.char(savecode:Decode(255)) .. decode2
        end
        savecode:destroy()
        decode = decode .. decode2

        return decode
    end

    local oldModulo
    oldModulo = AddHook("ModuloInteger", function (dividend, divisor)
        return math.floor(oldModulo(dividend, divisor))
    end)

    OnInit.final(function ()
        local test = Test.create()
        test.name = "hola"
        test.amount = 10
        test.scale = 0.631
        test.count = 203
        test.flag = true
        test.nested = Nested.create()
        test.nested.subname = "jaja"
        test.nested.state = false
        test.stats = 14341
        test.strenght = 12345
        test.agility = 68745
        test.intelligence = 0x3994

        local code = test:serialize()
        print(code)

        local encoded = EncodeString(Player(0), code)

        print(encoded)

        local code2 = DecodeString(Player(0), encoded)

        print(code2)
        if code2 then
            local test2 = Test.create()
            test2:deserialize(code2)
            print(test2.name, test2.amount, test2.scale, test2.count, test2.flag, test2.nested.subname, test2.nested.state, test2.stats, test2.strenght, test2.agility, test2.intelligence)
        end
    end)
end)
Debug.endFile()