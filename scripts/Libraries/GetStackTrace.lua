do
    local prefixes = {"war3map.lua", "blizzard.j.lua"}
    local n = #prefixes
    local prefixesLen = {}
    for i = 1, n do
        prefixesLen[i] = string.len(prefixes[i])
    end
    local list = {}
    local lastMsg = nil

    local function getPos(msg, pos)
        error(msg, pos)
    end

    local function store(msg)
        lastMsg = msg
    end

    local function checkPrefixes()
        for i = 1, n do
            if string.sub(lastMsg, 1, prefixesLen[i]) == prefixes[i] then
                return true
            end
        end
        return false
    end

    ---Returns stack trace, but only the position of the called functions, not its names
    ---@return string
    function GetStackTrace()
        local stack = ""

        local i = 4
        local p = 1
        while true do
            xpcall(getPos, store, "- " .. p, i)
            if not checkPrefixes() then break end
            table.insert(list, lastMsg)
            i = i + 1
            p = p + 1
        end

        for j = #list, 1, -1 do
            stack = stack .. list[j] .. "\n"
        end

        list = {}

        return stack
    end
end