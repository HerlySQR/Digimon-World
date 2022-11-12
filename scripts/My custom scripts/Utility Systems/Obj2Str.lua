OnInit("Obj2Str", function ()
    Require "Wc3Type" -- https://www.hiveworkshop.com/threads/debug-utils-ingame-console-etc.330758/

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
            local result = ""
            for i = 1, #o do
                result = result .. "," .. Obj2Str(o[i])
            end
            return "table: {" .. result:sub(2) .. "}"
        elseif typ == "userdata" then
            return Wc3Type(o) .. ": " .. GetHandleId(o)
        end
        error("Invalid object type", 2)
    end

    ---Converts an string id to object
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
            while true do
                local colon = value:find(":")

                if not colon then break end

                if value:sub(1, colon - 1) ~= "table" then -- Check the type of the object
                    local comma = value:find(",", colon) or (value:len() + 1)
                    table.insert(result, Str2Obj(value:sub(1, comma - 1)))
                    value = value:sub(comma + 1)
                else
                    -- If the value is a table then check how many is extended
                    local bracket = 0
                    -- Search the start and end brackets of the table, in case the table store more tables
                    local count = 0
                    for i = 1, value:len() do
                        local char = value:sub(i, i)
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
                    table.insert(result, Str2Obj(value:sub(1, bracket)))
                    value = value:sub(bracket + 2)
                end
            end
            return result
        else
            local func = _G["Load" .. Names[typ] .. "Handle"]

            if not func then
                error("Invalid string id", 2)
            end

            SaveFogStateHandle(h, 0, 0, ConvertFogState(tonumber(value)))
            return func(h, 0, 0)
        end
    end

end)