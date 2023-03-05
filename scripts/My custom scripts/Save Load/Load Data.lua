Debug.beginFile("Load Data")
OnInit(function ()
    Require "FrameLoader"
    Require "SaveHelper"
    Require "Player Data"
    Require "GetSyncedData"

    local WaitPlayers = nil ---@type framehandle
    local WaitPlayersText = nil ---@type framehandle
    local PlayerLabel = {} ---@type framehandle[]
    local PlayerName = {} ---@type framehandle[]
    local PlayerStatus = {} ---@type framehandle[]
    local PlayerReady = {} ---@type framehandle[]

    BlzHideOriginFrames(true)
    local DefaultHeight = BlzFrameGetHeight(BlzGetFrameByName("ConsoleUIBackdrop",0))
    BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, 0.0001)
    EnableUserControl(false)

    local function InitFrames()

        WaitPlayers = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_TOPLEFT, 0.250000, 0.530000)
        BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_BOTTOMRIGHT, 0.540000, 0.48000 - 0.03 * User.AmountPlaying)
        BlzFrameSetVisible(WaitPlayers, false)

        WaitPlayersText = BlzCreateFrameByType("TEXT", "name", WaitPlayers, "", 0)
        BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_TOPLEFT, WaitPlayers, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_BOTTOMRIGHT, WaitPlayers, FRAMEPOINT_TOPRIGHT, -0.010000, -0.015000)
        BlzFrameSetText(WaitPlayersText, "|cff0091ffWaiting for load data of players|r")
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
            BlzFrameSetScale(PlayerName[i], 1.00)
            BlzFrameSetTextAlignment(PlayerName[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            PlayerStatus[i] = BlzCreateFrameByType("TEXT", "name", PlayerLabel[i], "", 0)
            BlzFrameSetPoint(PlayerStatus[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.030000, -0.010000)
            BlzFrameSetPoint(PlayerStatus[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetText(PlayerStatus[i], "Status")
            BlzFrameSetEnable(PlayerStatus[i], false)
            BlzFrameSetScale(PlayerStatus[i], 1.00)
            BlzFrameSetTextAlignment(PlayerStatus[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            PlayerReady[i] = BlzCreateFrame("QuestCheckBox", PlayerLabel[i], 0, 0)
            BlzFrameSetPoint(PlayerReady[i], FRAMEPOINT_TOPLEFT, PlayerLabel[i], FRAMEPOINT_TOPLEFT, 0.0037600, 0.0000)
            BlzFrameSetPoint(PlayerReady[i], FRAMEPOINT_BOTTOMRIGHT, PlayerLabel[i], FRAMEPOINT_BOTTOMRIGHT, -0.24624, 0.0000)
        end
    end

    -- Run load
    OnInit.final(function ()
        InitFrames()
        FrameLoaderAdd(InitFrames)
        BlzFrameSetVisible(WaitPlayers, true)

        -- In case a player leave the game when loading
        local users = {} ---@type User[]
        local n = User.AmountPlaying - 1
        for i = 0, n do
            users[i] = User.PlayingPlayer[i]
        end

        -- To make sure that I can yield this thread
        coroutine.resume(coroutine.create(function ()
            for i = 0, n do
                local user = users[i]
                local p = user.handle
                SaveHelper.SetUserLoading(user, true)
                local loaded = 0
                for slot = 1, 6 do
                    local invalid = false
                    local exists = GetSyncedData(p, SaveFile.exists, p, slot)
                    if exists then
                        local s = GetSyncedData(p, SaveFile.getData, p, slot)
                        SaveHelper.SetSaveSlot(user, slot)
                        local savecode = Savecode.create()
                        if savecode:Load(p, s, 1) then
                            udg_SaveCount = 0
                            udg_SaveTempInt = savecode
                            TriggerExecute(gg_trg_Load_Actions)

                            if udg_SaveCodeLegacy then
                                udg_SaveCodeLegacy = false
                                invalid = true
                            end
                        else
                            invalid = true
                        end

                        if not invalid then
                            loaded = loaded + 1
                            StoreData(p, slot)
                        else
                            if p == GetLocalPlayer() then
                                print("You are using an invalid code.\n")
                            end
                            ClearSaveLoadData()
                        end

                        savecode:destroy()
                    end
                end
                SaveHelper.SetUserLoading(user, false)
                if not user.isPlaying then
                    BlzFrameSetText(PlayerStatus[i], "|cffffff00Left the game|r")
                elseif loaded == 0 then
                    BlzFrameSetText(PlayerStatus[i], "|cffBFBFBFData not found")
                else
                    BlzFrameSetText(PlayerStatus[i], "|cff00ff00Data loaded|r")
                    ShowLoad(p, true)
                end
                BlzFrameSetVisible(BlzFrameGetChild(PlayerReady[i], 3), true)
            end

            PolledWait(1.)

            BlzHideOriginFrames(false)
            BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, DefaultHeight)
            BlzFrameSetVisible(WaitPlayers, false)
            EnableUserControl(true)
        end))
    end)

end)
Debug.endFile()