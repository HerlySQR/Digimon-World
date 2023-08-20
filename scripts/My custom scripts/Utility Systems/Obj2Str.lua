if Debug then Debug.beginFile("Obj2Str") end
OnInit("Obj2Str", function ()
    Require "Wc3Type" -- https://www.hiveworkshop.com/threads/debug-utils-ingame-console-etc.330758/

    local MAX_DEPTH = 99
    local h = InitHashtable()

    ---I do it in this way, because I can't get a general conversion to all this types
    local Names = {
        player = "Player",
        unit = "Unit",
        destructable = "Destructable",
        item = "Item",
        ability = "Ability",
        force = "Force",
        group = "Group",
        trigger = "Trigger",
        timer = "Timer",
        location = "Location",
        region = "Region",
        rect = "Rect",
        sound = "Sound",
        effect = "Effect",
        fogmodifier = "FogModifier",
        dialog = "Dialog",
        button = "Button",
        timerdialog = "TimerDialog",
        leaderboard = "Leaderboard",
        multiboard = "Multiboard",
        texttag = "TextTag",
        lightning = "Lightning",
        image = "Image",
        ubersplat = "Ubersplat",
        hashtable = "Hashtable",
        framehandle = "Frame"
    }

    setmetatable(Names, {
        __index = function (t, k)
            error("Invalid string id: " .. k, 2)
        end
    })

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
            return Wc3Type(o) .. ": " .. GetHandleId(o)
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
            local func = _G["Load" .. Names[typ] .. "Handle"]

            SaveFogStateHandle(h, 0, 0, ConvertFogState(tonumber(value)))
            return func(h, 0, 0)
        end
    end

end)
if Debug then Debug.endFile() end