if Debug then Debug.beginFile("Serializable") end
OnInit("Serializable", function ()
    --[[    Simple Serialisation and Deserialisation package intended to be used with SaveLoadData.
        Allows you to save properties of any "class" instance into a string,
        and load the same properties from that string.

        Properties are saved in plain text format, but hashed to prevent naive tampering.
        If the saved properties are meant to be private, you should pripe the output through an encoder.

        =>USAGE<=

        1. Make your class "extend" the Serializable class

            > ---@class MyClass
            > ---@field amount integer
            > MyClass = setmetatable({}, Serializable)

        2. Implement `serializeProperties`, saving all properties that you want by using `addProperty`.
        The first parameter is the name with which you will load the property later.

            > function MyClass:serializeProperties()
            >	self:addProperty("amount", self.amount)

        3.  Implement `deserializeProperties`, loading all saved properties using the type specific `getXProperty` function,
            and assigning it to the variable that was originally saved.

            > function MyClass:deserializeProperties()
            >	self.amount = self:getIntProperty("amount")

        4. That's all the setup required. You can now save any string using `serialize`

            > local myClass = MyClass.create()
            > local chunkedString = myClass:serialize()

        and load it again from a string using `deserialize`.

        > local myClass2 = MyClass.create()
        > myClass:deserialize(chunkedString)

        =>BEHIND THE SCENES<=

        The properties are saved in a RLE format which can be defined as follows:

            T					 	   LLL							N*  		=  				V*
            ^							^							^			^				^
        1 letter type token  | 3 letters run length  |  [1-10] prop name | equal sign | [1-180] prop value

        Repeated for each property, with the hash being appended at the end.

    ]]
    ---@class Serializable
    ---@field private serOutput string
    ---@field private map table
    ---@field hash integer
    ---@field serializeProperties fun(self: Serializable)
    ---@field deserializeProperties fun(self: Serializable)
    Serializable = {
        serOutput = "",
        hash = 0
    }
    Serializable.__index = Serializable

    local MAX_NAME_LENGTH = 10
    local LEN_LENGTH = 3
    local HASH_LENGTH = 10

    local INT_TOKEN = "i"
    local REAL_TOKEN = "r"
    local STRING_TOKEN = "s"
    local BOOLEAN_TOKEN = "b"

    ---@param name string
    ---@param value integer | number | string | boolean
    function Serializable:addProperty(name, value)
        assert(value ~= nil, "You can't add a nil property.", 2)

        if name:len() > MAX_NAME_LENGTH then
            error("name " .. name .. " too long.")
        end
        local token = ""
        local typ = type(value)
        if typ =="number" then
            if math.type(value) == "integer" then
                token = INT_TOKEN
            else
                token = REAL_TOKEN
            end
        elseif typ == "string" then
            token = STRING_TOKEN
        elseif typ == "boolean" then
            token = BOOLEAN_TOKEN
            value = value and 1 or 0
        else
            error("Wrong value type.", 2)
        end

        local prop = name .. "=" .. value
        local propLen = tostring(prop:len())
        while propLen:len() < LEN_LENGTH do
            propLen = "0" .. propLen
        end

        self.hash = self.hash + StringHash(prop)

        self.serOutput = self.serOutput .. token .. propLen .. prop
    end

    ---@param name string
    ---@return integer
    function Serializable:getIntProperty(name)
        if math.type(self.map[name]) ~= "integer" then
            return 0
        end
        return self.map[name] or 0
    end

    ---@param name string
    ---@return number
    function Serializable:getRealProperty(name)
        if type(self.map[name]) ~= "number" then
            return 0.
        end
        return self.map[name] or 0.
    end

    ---@param name string
    ---@return string
    function Serializable:getStringProperty(name)
        if type(self.map[name]) ~= "string" then
            return ""
        end
        return self.map[name] or ""
    end

    ---@param name string
    ---@return boolean
    function Serializable:getBoolProperty(name)
        if math.type(self.map[name]) ~= "integer" or self.map[name] > 1 then
            return false
        end
        return self.map[name] == 1
    end

    ---@return string
    function Serializable:padHash()
        local hashStr = tostring(self.hash)
        if hashStr:len() > HASH_LENGTH then
            hashStr = hashStr:sub(1, HASH_LENGTH)
        end
        while hashStr:len() < HASH_LENGTH do
            hashStr = "0" .. hashStr
        end
        return hashStr
    end

    function Serializable:serialize()
        self.hash = 0
        self.serOutput = ""
        self:serializeProperties()

        self.serOutput = self.serOutput .. self:padHash()
        return self.serOutput
    end

    ---@param input string
    function Serializable:deserialize(input)
        self.hash = 0
        self.map = {}
        self:_parseInput(input)

        local hashStr = input:sub(input:len() - HASH_LENGTH + 1, input:len())
        if hashStr == self:padHash() then
            self:deserializeProperties()
        end

        self.map = nil
    end

    ---@param input string
    function Serializable:_parseInput(input)
        local pointer = 0

        while pointer + HASH_LENGTH < input:len() do
            local token = input:sub(pointer + 1, pointer + 1)
            if token ~= INT_TOKEN and token ~= REAL_TOKEN and token ~= STRING_TOKEN and token ~= BOOLEAN_TOKEN then
                break
            end
            pointer = pointer + 1
            local length = math.tointeger(input:sub(pointer + 1, pointer + LEN_LENGTH))
            pointer = pointer + LEN_LENGTH
            self:_parseProperty(token, input:sub(pointer + 1, pointer + length))
            pointer = pointer + length
        end
    end

    ---@param token string
    ---@param input string
    function Serializable:_parseProperty(token, input)
        self.hash = self.hash + StringHash(input)
        local indexOfEqual = input:find("=")
        assert(indexOfEqual)
        local name = input:sub(1, indexOfEqual - 1)
        local value = input:sub(indexOfEqual + 1)
        if token == INT_TOKEN or token == BOOLEAN_TOKEN then
            self.map[name] = math.tointeger(value)
        elseif token == REAL_TOKEN then
            self.map[name] = tonumber(value)
        elseif token == STRING_TOKEN then
            self.map[name] = value
        end
    end
end)
if Debug then Debug.endFile() end