Debug.beginFile("ReselectWhenClick")
OnInit.final(function ()
    Require "PlayerUtils"

    local LocalPlayer = GetLocalPlayer()

    local t = CreateTrigger()
    for i = 0, bj_MAX_PLAYERS - 1 do
        TriggerRegisterPlayerEvent(t, Player(i), EVENT_PLAYER_MOUSE_UP)
    end
    TriggerAddAction(t, function ()
        local r = math.random()
        if r < 0.5 and BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
            local p = GetTriggerPlayer()
            local units = {}
            ForUnitsSelected(p, function (u)
                table.insert(units, u)
            end)
            Timed.call(function ()
                if p == LocalPlayer then
                    ClearSelection()
                end
                Timed.call(function ()
                    if p == LocalPlayer then
                        for _, u in ipairs(units) do
                            SelectUnit(u, true)
                        end
                    end
                end)
            end)
        end
    end)
end)
Debug.endFile()