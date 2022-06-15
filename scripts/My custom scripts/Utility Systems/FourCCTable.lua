do
    --[[ FourCCTable by Tasyen

    Table Creator which autoconverts 4 digit RawCodes into numbers.

    function CreateFourCCTable(includeValue)
        Creates a table which will by itself convert 4 string keys into Object Editor Numbers.
        includeValue (true) -> also FourCC value
        returns a new Table
    ]]
    local targets = {}
    local metaTable = {__newindex = function(tab, key, value)
        if type(key) == "string" and string.len(key) == 4 then key = FourCC(key) end
        if targets[tab] and type(value) == "string" and string.len(value) == 4 then value = FourCC(value) end
        rawset(tab, key, value)
    end}
    function CreateFourCCTable(includeValue)
        local object = {}
        targets[object] = includeValue
        return setmetatable(object, metaTable)
    end
end