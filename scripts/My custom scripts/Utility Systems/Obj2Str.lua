if Debug then Debug.beginFile("Obj2Str") end
OnInit("Obj2Str", function ()
    Require "UnitEnterEvent"
    Require "AddHook"

    local MAX_DEPTH = 99
    local handle2Int = {} ---@type table<handle, integer>
    local int2Handle = {} ---@type table<integer, handle>
    local recycle = __jarray(0) ---@type table<integer, integer>
    local instanceCount = 0

    ---@param h handle
    local function allocate(h)
        if handle2Int[h] then
            return
        end

        local new

        if recycle[0] == 0 then
            instanceCount = instanceCount + 1
            new = instanceCount
        else
            new = recycle[0]
            recycle[0] = recycle[recycle[0]]
        end

        handle2Int[h] = new
        int2Handle[new] = h
    end

    ---@param h handle
    local function deallocate(h)
        if not handle2Int[h] then
            return
        end

        local old = handle2Int[h]

        recycle[old] = recycle[0]
        recycle[0] = old

        int2Handle[old] = nil
        handle2Int[h] = nil
    end

    ---@param f string
    local function hookAlloc(f)
        local oldf
        oldf = AddHook(f, function (...)
            local h = oldf(...)
            allocate(h)
            return h
        end)
    end

    ---@param f string
    local function hookDealloc(f)
        local oldf
        oldf = AddHook(f, function (...)
            local h = oldf(...)
            allocate(h)
            return h
        end)
    end

    OnUnitEnter(allocate)
    OnUnitLeave(deallocate)

    ---@param t table
    ---@param depth integer
    ---@return string
    local function Tab2Str(t, depth)
        if depth == MAX_DEPTH then
            error("Obj2Str surpassed the recursion limit of " .. MAX_DEPTH)
        end

        local result = ""
        for k, v in pairs(t) do
            result = result
                .. ",("
                .. ((type(k) == "table") and Tab2Str(k, depth + 1) or Obj2Str(k))
                .. ","
                .. ((type(v) == "table") and Tab2Str(v, depth + 1) or Obj2Str(v))
                .. ")"
        end
        return "table: {" .. result:sub(2) .. "}"
    end

    ---Converts an object to a string id
    ---@param o any
    ---@return string
    function Obj2Str(o)
        local typ = type(o)
        if typ == "nil" then
            return "nil"
        elseif typ == "number" then
            return "number: " .. tostring(o)
        elseif typ == "boolean" then
            return "boolean: " .. (o and "true" or "false")
        elseif typ == "string" then
            return "string: " .. o
        elseif typ == "table" then
            return Tab2Str(o, 0)
        elseif typ == "userdata" then
            return "handle: " .. handle2Int[o]
        end
        error("Invalid object type", 2)
    end

    ---Converts a string id to object (a copy in case of a lua table)
    ---@param s string
    ---@return any
    function Str2Obj(s)
        if s == "nil" then
            return nil
        end

        local pos = s:find(":")
        if not pos then
            error("Invalid string id", 2)
        end

        local typ = s:sub(1, pos - 1)
        local value = s:sub(pos + 2)

        if typ == "number" then
            return tonumber(value)
        elseif typ == "boolean" then
            return value == "true"
        elseif typ == "string" then
            return value
        elseif typ == "table" then
            local result = {}
            value = value:sub(2, value:len() - 1) -- Remove the brackets
            while value:find(":") do
                -- Get the (key,value) pair
                local parentesis = 0
                -- Search the start and end parentesis of the pair, in case the table store more tables
                local count = 0
                for i = 1, value:len() do
                    local char = value:sub(i, i)
                    if char == "(" then
                        count = count + 1
                    elseif char == ")" then
                        count = count - 1
                    end
                    if count == 0 then
                        parentesis = i
                        break
                    end
                end
                if count ~= 0 then
                    error("Unable to convert this \"table\"", 2)
                end
                local pair = value:sub(2, parentesis - 1)
                local colon = pair:find(":")
                local comma
                if pair:sub(1, colon - 1) == "table" then
                    -- The key is a table, so let's find the end of it
                    local bracket = 0
                    count = 0
                    for i = colon + 2, pair:len() do
                        local char = pair:sub(i, i)
                        if char == "{" then
                            count = count + 1
                        elseif char == "}" then
                            count = count - 1
                        end
                        if count == 0 then
                            bracket = i
                            break
                        end
                    end
                    if count ~= 0 then
                        error("Unable to convert this \"table\"", 2)
                    end
                    comma = bracket + 1
                else
                    comma = pair:find(",")
                end

                result[Str2Obj(pair:sub(1, comma - 1))] = Str2Obj(pair:sub(comma + 1, pair:len()))

                value = value:sub(parentesis + 2)
            end
            return result
        else
            return int2Handle[math.tointeger(value)]
        end
    end

end)
if Debug then Debug.endFile() end