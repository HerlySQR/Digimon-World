//TESH.scrollpos=12
//TESH.alwaysfold=0
globals
    leaderboard udg_HandleBoard
    group DebugGroup = CreateGroup()
endglobals

function HandleCounter_L2I takes location P returns integer
    return GetHandleId(P)
endfunction

function HandleCounter_Update takes nothing returns nothing
        local unit U
        local integer i = 0
        local integer j = 1
        local integer id
        local location array P
        local real result=0
        loop
                exitwhen i >= 50
                set i = i + 1
                set P[i] = Location(0,0)
                set id = HandleCounter_L2I(P[i])
                set result = result + (id-0x100000)
        endloop
        set result = result/i-i/2
        loop
                call RemoveLocation(P[i])
                set P[i] = null
                exitwhen i <= 1
                set i = i - 1
        endloop
        
        call GroupEnumUnitsSelected(DebugGroup, Player(0), null)
        set U = FirstOfGroup(DebugGroup)
        call LeaderboardSetItemValue(udg_HandleBoard, 0, R2I(result))
        call LeaderboardSetItemLabel(udg_HandleBoard, 1, "Combat State")
        if ZTS_GetCombatState(U) then
            call LeaderboardSetItemValue(udg_HandleBoard, 1, 1)
        else
            call LeaderboardSetItemValue(udg_HandleBoard, 1, 0)
        endif
        if GetOwningPlayer(U) == Player(PLAYER_NEUTRAL_AGGRESSIVE) then
            loop
                exitwhen j > 7
                if ZTS_GetThreatSlotUnit(U, j) != null then
                    call LeaderboardSetItemLabel(udg_HandleBoard, 1+j, "Slot "+I2S(j)+" - "+I2S(GetHandleId(ZTS_GetThreatSlotUnit(U, j)))+":")
                    call LeaderboardSetItemValue(udg_HandleBoard, 1+j, R2I(ZTS_GetThreatSlotAmount(U, j)))
                else
                    call LeaderboardSetItemLabel(udg_HandleBoard, 1+j, "Slot "+I2S(j)+" - "+"<empty>"+":")
                    call LeaderboardSetItemValue(udg_HandleBoard, 1+j, 0)
                endif
                set j = j + 1
            endloop
        endif
        set U = null
endfunction

function HandleCounter_Actions takes nothing returns nothing
        set udg_HandleBoard = CreateLeaderboard()
        call LeaderboardSetLabel(udg_HandleBoard, "threat-table for selected:")
        call PlayerSetLeaderboard(GetLocalPlayer(),udg_HandleBoard)
        call LeaderboardDisplay(udg_HandleBoard,true)
        call LeaderboardAddItem(udg_HandleBoard,"(Debug) Handles",0,Player(0))
        call LeaderboardAddItem(udg_HandleBoard, "Combat Status", 0, Player(1))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 1", 0, Player(2))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 2", 0, Player(3))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 3", 0, Player(4))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 4", 0, Player(5))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 5", 0, Player(6))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 6", 0, Player(7))
        call LeaderboardAddItem(udg_HandleBoard, "Slot 7", 0, Player(8))
        call LeaderboardSetSizeByItemCount(udg_HandleBoard,8)
        call HandleCounter_Update()
        call TimerStart(GetExpiredTimer(),0.05,true,function HandleCounter_Update)
endfunction

//===========================================================================
function InitTrig_Debug_Board takes nothing returns nothing
        call TimerStart(CreateTimer(),0,false,function HandleCounter_Actions)
endfunction