Debug.beginFile("LocalizeString")
OnInit(function ()
    Require "AddHook"
    Require "GlobalRemap"

    local localStrings = {} ---@type table<string, string>

    GlobalRemap("udg_TrgStrValue", nil, function (str)
        localStrings[udg_TrgStrKey] = str
    end)

    local oldGetLocalizedString
    oldGetLocalizedString = AddHook("GetLocalizedString", function (key)
        return localStrings[key] or oldGetLocalizedString(key)
    end)

    for k, v in pairs(_G) do
        if k:sub(1, 13) == "Trig_Strings_" then
            v()
        end
    end

    udg_FormatInt = {}
    udg_FormatString = {}
    udg_FormatReal = {}

    udg_StringFormat = CreateTrigger()
    TriggerAddAction(udg_StringFormat, function ()
        local _, n = udg_FormattedString:gsub("\x25\x25", "")
        local params = {}

        for i = 1, n do
            if udg_FormatInt[i] then
                table.insert(params, udg_FormatInt[i])
                udg_FormatInt[i] = nil
            elseif udg_FormatString[i] then
                table.insert(params, udg_FormatString[i])
                udg_FormatString[i] = nil
            elseif udg_FormatReal[i] then
                table.insert(params, udg_FormatReal[i])
                udg_FormatReal[i] = nil
            end
        end

        udg_FormattedString = udg_FormattedString:format(table.unpack(params))
    end)
end)
Debug.endFile()