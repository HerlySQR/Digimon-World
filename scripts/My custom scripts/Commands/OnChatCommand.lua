Debug.beginFile("OnChatCommand")
OnInit("OnChatCommand", function ()
    Require "GlobalRemap"

    local actCommand = ""
    local actExtra = ""

    GlobalRemap("udg_ChatCommandText", function () return actCommand end)
    GlobalRemap("udg_ChatCommandExtra", function () return actExtra end)

    OnInit.final(function ()
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-", false)
        end)
        TriggerAddCondition(t, Condition(function () return GetEventPlayerChatString():sub(1, 1) == "-" end))
        TriggerAddAction(t, function ()
            local c = GetEventPlayerChatString()
            local f = c:find(" ")
            if f then
                actCommand = c:sub(2, f)
                actExtra = c:sub(f + 1, c:len())
            else
                actCommand = c:sub(1, c:len())
            end

            globals.udg_ChatCommandEvent = 1.
            globals.udg_ChatCommandEvent = 0.

            actCommand = ""
            actExtra = ""
        end)
    end)
end)
Debug.endFile()