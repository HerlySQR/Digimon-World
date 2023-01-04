OnInit("AFK", function ()
    Require "PlayerUtils"
    Require "Timed"
    Require "EventListener"

    AFKEvent = EventListener.create()

    local afkTime = __jarray(0) ---@type table<player, number>

    OnInit.final(function ()
        Timed.call(1., function ()
            ForForce(FORCE_PLAYING, function ()
                local p = GetEnumPlayer()
                afkTime[p] = afkTime[p] + 1
                if afkTime[p] == 300 then
                    AFKEvent:run(p)
                end
            end)
        end)

        local t = CreateTrigger()
        ForForce(FORCE_PLAYING, function ()
            local p = GetEnumPlayer()
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_SELECTED)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_DESELECTED)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_ISSUED_ORDER)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_PAWN_ITEM)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_PICKUP_ITEM)
            TriggerRegisterPlayerUnitEvent(t, p, EVENT_PLAYER_UNIT_SELL_ITEM)
            TriggerRegisterPlayerChatEvent(t, p, "", false)
            TriggerRegisterPlayerEvent(t, p, EVENT_PLAYER_END_CINEMATIC)
            TriggerRegisterPlayerEvent(t, p, EVENT_PLAYER_ALLIANCE_CHANGED)
        end)
        TriggerAddAction(t, function ()
            afkTime[GetTriggerPlayer()] = 0
        end)
    end)

end)