Debug.beginFile("SpectAlly")
OnInit.final(function ()
    Require "FrameLoader"
    Require "GameStatus"
    Require "Environment"

    local slots = {}

    FrameLoaderAdd(function ()
        BlzFrameClick(BlzGetFrameByName("UpperButtonBarAlliesButton", 0))
        BlzFrameClick(BlzGetFrameByName("AllianceCancelButton", 0))

        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            -- To create their handles
            if GameStatus.get() == GameStatus.ONLINE then
                BlzGetFrameByName("AllianceSlot", i)
                BlzGetFrameByName("PlayerNameLabel", i)
            else
                Location(0, 0)
                Location(0, 0)
            end

            local p = Player(i)
            if IsPlayerInGame(p) then
                slots[p] = __jarray(Player(bj_MAX_PLAYER_SLOTS - 1))
                local s = 0
                for j = 0, bj_MAX_PLAYER_SLOTS - 1 do
                    local p2 = Player(j)
                    if GetPlayerSlotState(p2) == PLAYER_SLOT_STATE_PLAYING then
                        if p ~= p2 then
                            slots[p][s] = p2
                            s = s + 1
                        end
                    end
                end
            end
        end

        local leave = CreateTrigger()

        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            local slot = BlzGetFrameByName("AllianceSlot", i)
            local label = BlzGetFrameByName("PlayerNameLabel", i)

            local button = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
            BlzFrameSetParent(button, slot)
            BlzFrameSetPoint(button, FRAMEPOINT_TOPRIGHT, label, FRAMEPOINT_TOPRIGHT, -0.01, 0.005)
            BlzFrameSetPoint(button, FRAMEPOINT_BOTTOMRIGHT, label, FRAMEPOINT_BOTTOMRIGHT, -0.01, -0.005)
            BlzFrameSetPoint(button, FRAMEPOINT_LEFT, label, FRAMEPOINT_RIGHT, -0.06, 0.)
            BlzFrameSetText(button, "See")
            BlzFrameSetTextAlignment(button, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(button, 4)
            BlzFrameSetVisible(button, GetPlayerController(slots[GetLocalPlayer()][i]) == MAP_CONTROL_USER)

            local t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, button, FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function ()
                Environment.spect(GetTriggerPlayer(), slots[GetTriggerPlayer()][i])
            end)

            TriggerRegisterPlayerEvent(leave, Player(i), EVENT_PLAYER_LEAVE)
            TriggerAddAction(leave, function ()
                if slots[GetLocalPlayer()][i] == GetTriggerPlayer() then
                    BlzFrameSetVisible(button, false)
                end
            end)
        end
    end)
end)
Debug.endFile()