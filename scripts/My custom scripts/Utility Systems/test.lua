Debug.beginFile("TestSerializable")
OnInit(function ()
    Require "Serializable"

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
    end

    function Test:deserializeProperties()
        self.name = self:getStringProperty("name")
        self.amount = self:getIntProperty("amount")
        self.scale = self:getRealProperty("scale")
        self.count = self:getIntProperty("count")
        self.flag = self:getBoolProperty("flag")
        self.nested = Nested.create()
        self.nested:deserialize(self:getStringProperty("nested"))
    end

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

        local code = test:serialize()
        print(code)

        local test2 = Test.create()

        test2:deserialize(code)
        print(test2.name, test2.amount, test2.scale, test2.count, test2.flag, test2.nested.subname, test2.nested.state)
    end)
end)
Debug.endFile()