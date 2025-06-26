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
end)
Debug.endFile()