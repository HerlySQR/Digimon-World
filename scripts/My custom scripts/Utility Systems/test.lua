OnInit(function ()
    Require "Threat System"

    udg_HandleBoard = nil ---@type leaderboard 
    DebugGroup = CreateGroup() ---@type group 


    ---@param P location
    ---@return integer
    function HandleCounter_L2I(P)
        return GetHandleId(P)
    end

    function HandleCounter_Update()
        local i = 0 ---@type integer
        local P = {} ---@type location[]
        local result = 0 ---@type number
        while i < 50 do
                i = i + 1
                P[i] = Location(0,0)
                local id = HandleCounter_L2I(P[i])
                result = result + (id-0x100000)
        end
        result = result/i-i/2
        while true do
                RemoveLocation(P[i])
                P[i] = nil
                if i <= 1 then break end
                i = i - 1
        end

        GroupEnumUnitsSelected(DebugGroup, Player(0), nil)
        local U = FirstOfGroup(DebugGroup)
        LeaderboardSetItemValue(udg_HandleBoard, 0, R2I(result))
        LeaderboardSetItemLabel(udg_HandleBoard, 1, "Combat State")
        if Threat.getCombatState(U) then
            LeaderboardSetItemValue(udg_HandleBoard, 1, 1)
        else
            LeaderboardSetItemValue(udg_HandleBoard, 1, 0)
        end
        if GetOwningPlayer(U) == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            local j = 1
            while j <= 7 do 
                if Threat.getSlotUnit(U, j) ~= nil then
                    LeaderboardSetItemLabel(udg_HandleBoard, 1+j, "Slot "..I2S(j).." - "..I2S(GetHandleId(Threat.getSlotUnit(U, j)))..":")
                    LeaderboardSetItemValue(udg_HandleBoard, 1+j, R2I(Threat.getSlotAmount(U, j)))
                else
                    LeaderboardSetItemLabel(udg_HandleBoard, 1+j, "Slot "..I2S(j).." - ".."<empty>"..":")
                    LeaderboardSetItemValue(udg_HandleBoard, 1+j, 0)
                end
                j = j + 1
            end
        end
    end

    function HandleCounter_Actions()
        udg_HandleBoard = CreateLeaderboard()
        LeaderboardSetLabel(udg_HandleBoard, "threat-table for selected:")
        PlayerSetLeaderboard(GetLocalPlayer(),udg_HandleBoard)
        LeaderboardDisplay(udg_HandleBoard,true)
        LeaderboardAddItem(udg_HandleBoard,"(Debug) Handles",0,Player(0))
        LeaderboardAddItem(udg_HandleBoard, "Combat Status", 0, Player(1))
        LeaderboardAddItem(udg_HandleBoard, "Slot 1", 0, Player(2))
        LeaderboardAddItem(udg_HandleBoard, "Slot 2", 0, Player(3))
        LeaderboardAddItem(udg_HandleBoard, "Slot 3", 0, Player(4))
        LeaderboardAddItem(udg_HandleBoard, "Slot 4", 0, Player(5))
        LeaderboardAddItem(udg_HandleBoard, "Slot 5", 0, Player(6))
        LeaderboardAddItem(udg_HandleBoard, "Slot 6", 0, Player(7))
        LeaderboardAddItem(udg_HandleBoard, "Slot 7", 0, Player(8))
        LeaderboardSetSizeByItemCount(udg_HandleBoard,8)
        HandleCounter_Update()
        TimerStart(GetExpiredTimer(),0.05,true,HandleCounter_Update)
    end

    --===========================================================================
    TimerStart(CreateTimer(),0,false,HandleCounter_Actions)
end)
--Conversion by vJass2Lua v0.A.2.3