Debug.beginFile("SpectAlly")
OnInit.final(function ()
    --Require "FrameLoader"
    --Require "PlayerUtils"

    local slots = {}

    --FrameLoaderAdd(function ()
        BlzFrameClick(BlzGetFrameByName("UpperButtonBarAlliesButton", 0))
        BlzFrameClick(BlzGetFrameByName("AllianceCancelButton", 0))

        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            -- To create their handles
            BlzGetFrameByName("AllianceSlot", i)
            BlzGetFrameByName("PlayerNameLabel", i)

            local p = Player(i)
            if GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(p) == MAP_CONTROL_USER then
                slots[p] = __jarray(bj_MAX_PLAYER_SLOTS - 1)
                local s = 0
                for j = 0, bj_MAX_PLAYER_SLOTS - 1 do
                    local p2 = Player(j)
                    if GetPlayerSlotState(p2) == PLAYER_SLOT_STATE_PLAYING then
                        if p ~= p2 then
                            slots[p][p2] = s
                            s = s + 1
                        end
                    end
                end
            end
        end

        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            local p = Player(i)
            if GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING --[[and GetPlayerController(p) == MAP_CONTROL_USER]] then
                print(slots[GetLocalPlayer()][p])
                local slot = BlzGetFrameByName("AllianceSlot", slots[GetLocalPlayer()][p])
                local label = BlzGetFrameByName("PlayerNameLabel", slots[GetLocalPlayer()][p])

                local text = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
                BlzFrameSetParent(text, slot)
                BlzFrameSetPoint(text, FRAMEPOINT_TOPRIGHT, label, FRAMEPOINT_TOPRIGHT, -0.01, 0.005)
                BlzFrameSetPoint(text, FRAMEPOINT_BOTTOMRIGHT, label, FRAMEPOINT_BOTTOMRIGHT, -0.01, -0.005)
                BlzFrameSetPoint(text, FRAMEPOINT_LEFT, label, FRAMEPOINT_RIGHT, -0.06, 0.)
                BlzFrameSetText(text, "See")
                BlzFrameSetTextAlignment(text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
                BlzFrameSetLevel(text, 4)
                BlzFrameSetVisible(text, GetLocalPlayer() ~= p)

                local t = CreateTrigger()
                BlzTriggerRegisterFrameEvent(t, text, FRAMEEVENT_CONTROL_CLICK)
                TriggerAddAction(t, function ()
                    print(GetPlayerName(p))
                end)
            end
        end
    --end)

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "r ", false)
    TriggerAddAction(t, function ()
        local sl = tonumber(GetEventPlayerChatString():sub(3))
        RemovePlayer(Player(sl), PLAYER_GAME_RESULT_DEFEAT)
    end)
end)
Debug.endFile()