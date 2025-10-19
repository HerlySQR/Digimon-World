Debug.beginFile("Load Data")
OnInit(function ()
    if not udg_AutoLoadData then
        return
    end

    Require "FrameLoader"
    Require "Menu"
    Require "SaveHelper"
    Require "GetSyncedData"

    local WaitPlayers = nil ---@type framehandle
    local WaitPlayersText = nil ---@type framehandle
    local PlayerLabel = {} ---@type framehandle[]
    local PlayerName = {} ---@type framehandle[]
    local PlayerStatus = {} ---@type framehandle[]
    local PlayerReady = {} ---@type framehandle[]
    local PlayerProgress = {} ---@type framehandle[]

    HideMenu(true)
    EnableUserControl(false)

    local function InitFrames()

        WaitPlayers = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_TOPLEFT, 0.250000, 0.530000)
        BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_BOTTOMRIGHT, 0.540000, 0.48000 - 0.02 * User.AmountPlaying -0.01)
        BlzFrameSetVisible(WaitPlayers, false)

        WaitPlayersText = BlzCreateFrameByType("TEXT", "name", WaitPlayers, "", 0)
        BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_TOPLEFT, WaitPlayers, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_BOTTOMRIGHT, WaitPlayers, FRAMEPOINT_TOPRIGHT, -0.010000, -0.015000)
        BlzFrameSetText(WaitPlayersText, GetLocalizedString("LOAD_WAITING"))
        BlzFrameSetEnable(WaitPlayersText, false)
        BlzFrameSetScale(WaitPlayersText, 2.00)
        BlzFrameSetTextAlignment(WaitPlayersText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        for i = 0, User.AmountPlaying - 1 do
            local user = User.PlayingPlayer[i]

            PlayerLabel[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", WaitPlayers, "", 1)
            BlzFrameSetPoint(PlayerLabel[i], FRAMEPOINT_TOPLEFT, WaitPlayers, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000 - 0.02*i)
            BlzFrameSetPoint(PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, WaitPlayers, FRAMEPOINT_TOPRIGHT, -0.010000, -0.050000 - 0.02*(i+1))
            BlzFrameSetTexture(PlayerLabel[i], "war3mapImported\\EmptyBTN.blp", 0, true)

            PlayerName[i] = BlzCreateFrameByType("TEXT", "name", PlayerLabel[i], "", 0)
            BlzFrameSetPoint(PlayerName[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.030000, 0.0000)
            BlzFrameSetPoint(PlayerName[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.010000)
            BlzFrameSetText(PlayerName[i], user:getNameColored())
            BlzFrameSetEnable(PlayerName[i], false)
            BlzFrameSetTextAlignment(PlayerName[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            PlayerStatus[i] = BlzCreateFrameByType("TEXT", "name", PlayerLabel[i], "", 0)
            BlzFrameSetPoint(PlayerStatus[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.030000, -0.010000)
            BlzFrameSetPoint(PlayerStatus[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetText(PlayerStatus[i], GetLocalizedString("LOAD_STATUS"))
            BlzFrameSetEnable(PlayerStatus[i], false)
            BlzFrameSetTextAlignment(PlayerStatus[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            PlayerReady[i] = BlzCreateFrame("QuestCheckBox", PlayerLabel[i], 0, 0)
            BlzFrameSetPoint(PlayerReady[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.0037600, 0.0000)
            BlzFrameSetPoint(PlayerReady[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, -0.24624, 0.0000)

            PlayerProgress[i] = BlzCreateFrameByType("TEXT", "name", PlayerLabel[i], "", 0)
            BlzFrameSetScale(PlayerProgress[i], 0.572)
            BlzFrameSetPoint(PlayerProgress[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.0037000, 0.0000)
            BlzFrameSetPoint(PlayerProgress[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, -0.24630, 0.0000)
            BlzFrameSetText(PlayerProgress[i], "0\x25")
            BlzFrameSetEnable(PlayerProgress[i], false)
            BlzFrameSetLevel(PlayerProgress[i], 10)
            BlzFrameSetTextAlignment(PlayerProgress[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        end
    end

    -- Run load
    OnInit.final(function ()
        FrameLoaderAdd(InitFrames)
        BlzFrameSetVisible(WaitPlayers, true)

        -- In case a player leave the game when loading
        local users = {} ---@type User[]
        local n = User.AmountPlaying - 1
        for i = 0, n do
            users[i] = User.PlayingPlayer[i]
        end

        -- To make sure that I can yield this thread
        coroutine.wrap(function ()
            local finish = false
            local progress = 0
            local actIndex = 0
            local t = CreateTrigger()
            TriggerAddAction(t, function ()
                if finish then
                    return
                end
                progress = progress + 1
                BlzFrameSetText(PlayerProgress[actIndex], math.floor(math.min(progress*100/31, 100)) .."\x25")
                WaitLastSync()
                if finish then
                    return
                end
                Timed.call(function ()
                    TriggerExecute(t)
                end)
            end)

            local tr = coroutine.running()
            Timed.echo(0.02, function ()
                if coroutine.status(tr) == "suspended" then
                    TriggerExecute(t)
                    return true
                elseif coroutine.status(tr) == "dead" then
                    return true
                end
            end)

            for i = 0, n do
                actIndex = i
                local loaded = false
                local user = users[i]
                local p = user.handle
                for slot = 1, 6 do
                    loaded = LoadPlayerData(p, slot) or loaded
                end
                LoadHotkeys(p)
                --LoadUnlockedCosmetics(p)
                if not user.isPlaying then
                    BlzFrameSetText(PlayerStatus[i], GetLocalizedString("LOAD_LEFT"))
                elseif not loaded then
                    BlzFrameSetText(PlayerStatus[i], GetLocalizedString("LOAD_NOT_FOUND"))
                else
                    BlzFrameSetText(PlayerStatus[i], GetLocalizedString("LOAD_READY"))
                    ShowLoad(p, true)
                end
                progress = 0
                BlzFrameSetVisible(PlayerProgress[i], false)
                BlzFrameSetVisible(BlzFrameGetChild(PlayerReady[i], 3), true)
            end

            finish = true
            TriggerClearActions(t)
            DestroyTrigger(t)

            PolledWait(1.)

            ShowMenu(true)
            BlzFrameSetVisible(WaitPlayers, false)
            EnableUserControl(true)
        end)()
    end)

end)
Debug.endFile()