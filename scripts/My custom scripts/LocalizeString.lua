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
end)
Debug.endFile()