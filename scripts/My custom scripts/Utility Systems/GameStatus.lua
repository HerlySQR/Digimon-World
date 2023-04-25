OnInit("GameStatus", function ()
    ---@enum GameStatus
    GameStatus = {
        UNKNOWN = 0,
        ONLINE = 1,
        OFFLINE = 2,
        REPLAY = 3
    }

    local status = GameStatus.UNKNOWN ---@type GameStatus

    ---@return GameStatus
    function GameStatus.get()
        return status
    end

    ---@param p player
    ---@return boolean
    function IsPlayerInGame(p)
        return GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(p) == MAP_CONTROL_USER
    end

    local firstPlayer = Player(0)
    while not IsPlayerInGame(firstPlayer) do
        firstPlayer = Player(GetPlayerId(firstPlayer) + 1)
    end

    -- Force the player to select a dummy unit
    local u = CreateUnit(firstPlayer, FourCC('hfoo'), 0, 0, 0)
    SelectUnit(u, true)
    local selected = IsUnitSelected(u, firstPlayer)
    RemoveUnit(u)

    if selected then
        -- Detect if replay or offline game
        if (ReloadGameCachesFromDisk()) then
            status = GameStatus.OFFLINE
        else
            status = GameStatus.REPLAY
        end
    else
        -- If the unit wasn't selected instantly, the game is online
        status = GameStatus.ONLINE
    end
    
end)