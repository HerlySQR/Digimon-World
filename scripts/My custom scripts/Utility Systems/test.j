     

library ZTS initializer InitThreatSystem uses Init

globals   
    private constant real UpdateIntervall = 0.5 //The intervall for issueing orders and performing AttackRange check. recommended value: 0.5
    private constant real HelpRange = 400 //The range between units considered being in the same camp. If a unit of the same camp gets attacked, all others will help.
                                          //Set CallForHelp to something lower in Gameplay Constants.
    private constant real OrderReturnRange = 3500 //The range the unit's target can be away from the original camping position, before being ordered to return.
    private constant real ReturnRange = 1200 //The range the unit can move away from the original camping position, before being ordered to return.
    private constant real DungeonRange = 1600 //The range the unit can move away from the original camping position, before being ordered to return (Dungeon units)
    private constant real TimeToPort = 10 //This timer expires once a unit tries to return to its camping position.
                                          //If it reaches 0 before reaching the camp position, the unit will be teleported immediately.
    private constant boolean HealUnitsOnReturn = true //If this is true, returning units will be healed to 100% health.
    
    
//      Do not edit below here!
//------------------------------------------------------------------------------------------------------//  
    private boolexpr BOOLEXPR = null
    private constant timer Updater = CreateTimer()
    private constant group NPCgroup = CreateGroup()
    private constant hashtable NPClist = InitHashtable()
    private constant hashtable PUlist = InitHashtable()
    
    //temporary variables for enumerations and forgroups
    private unit TSub = null
    private unit TMod = null
    private constant group TGroupSub = CreateGroup()
    private unit THealer = null
    private real THealthreat = 0
    private boolean TBool = false
    private integer TState = 0
    private group TGroupGet = null
    private boolean EventBool = false
    private constant group AIGroup = CreateGroup()
    private player AIPlayer = null
    public boolean IssueNoAttackOrder = false
    public unit IssueOrderUnit = null
    private constant group RangeGroup = CreateGroup()
    private unit RangeGroupTest = null
endglobals

public function RemoveAllBuffs takes unit u returns nothing
    local BuffListIterator iter = UnitBuffs[u].bl.iterator()
    local Buff b
    loop
        exitwhen iter.hasNoNext()
        set b = iter.next()
        call b.destroy()
    endloop
    call iter.destroy()
endfunction 

public function IsEvent takes nothing returns boolean
    if EventBool then
        set EventBool = false
        return true
    endif
    return false
endfunction

private function Pos2Key takes integer position returns integer //converts threat list position into hashtable childkey
    return 8+(position*2)
endfunction

private function Key2Pos takes integer key returns integer //converts hashtable childkey into threat list position
    return (key-8)/2
endfunction

public function GetCombatState takes unit u returns boolean
    if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then //unit dead or null
        return false
    elseif HaveSavedInteger(NPClist, GetHandleId(u), 0) then //unit is npc
        return LoadInteger(NPClist, GetHandleId(u), 0) > 0
    elseif HaveSavedHandle(PUlist, GetHandleId(u), 0) then //unit is player unit
        if GetPlayerId(GetOwningPlayer(u)) < 6 then
            if PvPtimer[GetPlayerId(GetOwningPlayer(u))] != null then
                if TimerGetRemaining(PvPtimer[GetPlayerId(GetOwningPlayer(u))]) > 50 then //pvp incombat
                    return true
                endif
            endif
        endif
        return LoadInteger(PUlist, GetHandleId(u), 1) > 0
    endif
    return false
endfunction

public function GetCombatTime takes unit u returns real
    if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then //unit dead or null
        return 0.
    elseif HaveSavedInteger(NPClist, GetHandleId(u), 0) then //unit is npc
        if LoadInteger(NPClist, GetHandleId(u), 0) == 1 then //only return a time when the unit is in combat
            return LoadReal(NPClist, GetHandleId(u), 3)
        endif
    endif
    return 0.
endfunction

public function GetThreatUnitPosition takes unit npc, unit pu returns integer
    if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then //units null
        return 0
    elseif not (HaveSavedInteger(NPClist, GetHandleId(npc), 0) and HaveSavedHandle(PUlist, GetHandleId(pu), 0)) then //units not added
        return 0
    elseif HaveSavedInteger(PUlist, GetHandleId(pu), GetHandleId(npc)) then
        return LoadInteger(PUlist, GetHandleId(pu), GetHandleId(npc))
    endif
    return 0
endfunction

public function GetThreatUnitAmount takes unit npc, unit pu returns real
    if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then //units null
        return 0.
    elseif not (HaveSavedInteger(NPClist, GetHandleId(npc), 0) and HaveSavedHandle(PUlist, GetHandleId(pu), 0)) then //units not added
        return 0.
    elseif HaveSavedInteger(PUlist, GetHandleId(pu), GetHandleId(npc)) then
        return LoadReal(NPClist, GetHandleId(npc), Pos2Key(LoadInteger(PUlist, GetHandleId(pu), GetHandleId(npc)))+1)
    endif
    return 0.
endfunction

public function GetThreatSlotUnit takes unit npc, integer position returns unit
    if GetUnitTypeId(npc) == 0 or position <= 0 then //unit null or invalid slot
        return null
    elseif not HaveSavedInteger(NPClist, GetHandleId(npc), 0) then //unit not added
        return null
    elseif HaveSavedHandle(NPClist, GetHandleId(npc), Pos2Key(position)) then
        return LoadUnitHandle(NPClist, GetHandleId(npc), Pos2Key(position))
    endif
    return null
endfunction

public function GetThreatSlotAmount takes unit npc, integer position returns real
    if GetUnitTypeId(npc) == 0 or position <= 0 then //unit null or invalid slot
        return 0.
    elseif not HaveSavedInteger(NPClist, GetHandleId(npc), 0) then //unit not added
        return 0.
    elseif HaveSavedReal(NPClist, GetHandleId(npc), Pos2Key(position)+1) then
        return LoadReal(NPClist, GetHandleId(npc), Pos2Key(position)+1)
    endif
    return 0.
endfunction

private function GetAttackersSub takes nothing returns nothing
    call GroupAddUnit(TGroupGet, GetEnumUnit())
endfunction

public function GetAttackers takes unit u returns group
    local group g = CreateGroup()
    local integer key = 10
    local integer max
    if GetUnitTypeId(u) == 0 then
        return g
    endif
    if HaveSavedInteger(NPClist, GetHandleId(u), 0) then //unit is npc
        set max = Pos2Key(LoadInteger(NPClist, GetHandleId(u), 5))
        loop
            exitwhen key > max
            call GroupAddUnit(g, LoadUnitHandle(NPClist, GetHandleId(u), key))
            set key = key+2
        endloop
    elseif HaveSavedHandle(PUlist, GetHandleId(u), 0) then //unit is player unit
        set TGroupGet = g
        call ForGroup(LoadGroupHandle(PUlist, GetHandleId(u), 0), function GetAttackersSub)
        set g = TGroupGet
        set TGroupGet = null
    endif
    return g
endfunction

private function Swap takes integer npcID, integer key1, integer key2 returns nothing
    local unit u = LoadUnitHandle(NPClist, npcID, key1)
    local real r = LoadReal(NPClist, npcID, key1+1)
    call SaveUnitHandle(NPClist, npcID, key1, LoadUnitHandle(NPClist, npcID, key2))
    call SaveReal(NPClist, npcID, key1+1, LoadReal(NPClist, npcID, key2+1))
    call SaveInteger(PUlist, GetHandleId(LoadUnitHandle(NPClist, npcID, key1)), npcID, Key2Pos(key1)) //update position list
    call SaveUnitHandle(NPClist, npcID, key2, u)
    call SaveReal(NPClist, npcID, key2+1, r)
    call SaveInteger(PUlist, GetHandleId(u), npcID, Key2Pos(key2)) //update position list
    set u = null
endfunction

private function CampThreat takes nothing returns nothing
    local integer npcID = GetHandleId(GetEnumUnit())
    local integer puID = GetHandleId(TMod)
    local integer key
    local integer listlength
    if GetEnumUnit() == TSub then
        return
    elseif HaveSavedInteger(PUlist, puID, npcID) then //original pu unit already listed in EnumUnit's threat list
        return
    elseif LoadInteger(NPClist, npcID, 0) > 1 or IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) then //do not add threat to dead or units that are status: returning
        return
    endif
    set listlength = LoadInteger(NPClist, npcID, 5)+1
    call SaveInteger(NPClist, npcID, 5, listlength) //add to list length of EnumUnit
    set key = Pos2Key(listlength)
    call SaveUnitHandle(NPClist, npcID, key, TMod) //add original pu unit to end of EnumUnit's threat list
    call SaveReal(NPClist, npcID, key+1, 0)
    call SaveInteger(PUlist, puID, npcID, listlength) //add EnumUnit to slot list
    call GroupAddUnit(LoadGroupHandle(PUlist, puID, 0), GetEnumUnit()) //add EnumUnit to slot list group
    call SaveInteger(PUlist, puID, 1, LoadInteger(PUlist, puID, 1)+1) //increase group size count
    if LoadInteger(NPClist, npcID, 0) == 0 then
        call SaveInteger(NPClist, npcID, 0, 1) //set unit status: combat
        call GroupAddUnit(NPCgroup, GetEnumUnit()) //add the unit to incombat group
    endif
endfunction

public function ModifyThreat takes unit pu, unit npc, real amount, boolean add returns nothing
    local integer npcID = GetHandleId(npc)
    local integer puID = GetHandleId(pu)
    local integer key
    local integer listlength
    local integer i = 0
    local real newamount
    local real oldamount = 0
    local boolean b = false
    if not (HaveSavedInteger(NPClist, npcID, 0) and HaveSavedHandle(PUlist, puID, 0)) then //units not added
        return
    elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(npc, UNIT_TYPE_DEAD) then //units dead
        return
    elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(npc) == 0 then //null units
        return
    elseif LoadInteger(NPClist, npcID, 0) > 1 then //do not add threat to units that are status: returning
        return
    endif
    if not HaveSavedInteger(PUlist, puID, npcID) then //pu not listed in npc's threat list
        set listlength = LoadInteger(NPClist, npcID, 5)+1
        call SaveInteger(NPClist, npcID, 5, listlength) //add to list length of npc
        set key = Pos2Key(listlength)
        call SaveUnitHandle(NPClist, npcID, key, pu) //add pu to end of npc's threat list
        call SaveInteger(PUlist, puID, npcID, listlength) //add npc to slot list
        call GroupAddUnit(LoadGroupHandle(PUlist, puID, 0), npc) //add npc to slot list group
        call SaveInteger(PUlist, puID, 1, LoadInteger(PUlist, puID, 1)+1) //increase group size count
        if LoadInteger(NPClist, npcID, 0) == 0 then
            call SaveInteger(NPClist, npcID, 0, 1) //set unit status: combat
            call GroupAddUnit(NPCgroup, npc) //add the unit to incombat group
        endif
        set b = true
    else
        set key = Pos2Key(LoadInteger(PUlist, puID, npcID))
        set oldamount = LoadReal(NPClist, npcID, key+1)
    endif
    if add then
        set newamount = oldamount+amount
    else
        set newamount = amount
    endif
    if newamount < 0 then
        set newamount = 0
    endif
    call SaveReal(NPClist, npcID, key+1, newamount)
    if newamount > oldamount then //check lower keys
        loop
            if HaveSavedReal(NPClist, npcID, key-1-i) then
                if LoadReal(NPClist, npcID, key-1-i) < newamount then //lower key amount is smaller
                    call Swap(npcID, key-2-i, key-i)
                else
                    exitwhen true
                endif
                set i = i + 2
            else
                exitwhen true
            endif
        endloop
    elseif newamount < oldamount then //check higher keys
        loop
            if HaveSavedReal(NPClist, npcID, key+3+i) then
                if LoadReal(NPClist, npcID, key+3+i) > newamount then //upper key amount is larger
                    call Swap(npcID, key+2+i, key+i)
                else
                    exitwhen true
                endif
                set i = i + 2
            else
                exitwhen true
            endif
        endloop
    endif
    if b then //set all units of the same camp to status: combat and apply 0 threat from pu to them
        set TSub = npc
        set TMod = pu
        call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampThreat)
    endif
    
    //if aggressive mode is on, issue pet orders
    set i = GetPlayerId(GetOwningPlayer(pu))+1
    if i <= 6 then
        if not PetButtonsHidden[i] then
            if PetAggressive[i] then
                if GetUnitTypeId(PlayerPetTarget[i]) == 0 and PlayerPetOrder[i] == "" then
                    if IsUnitInRange(udg_ControlledHero[i], npc, 1200) then
                        set PlayerPetTarget[i] = npc
                    endif
                endif
            endif
        endif
    endif
endfunction

private function AcquireTarget takes nothing returns boolean
    local unit npc = GetTriggerUnit()
    local unit pu
    if GetEventTargetUnit() != null then
        set pu = GetEventTargetUnit()
    else
        set pu = GetOrderTargetUnit()
    endif
    if IsUnitEnemy(pu, GetOwningPlayer(npc)) then
        if LoadInteger(NPClist, GetHandleId(npc), 0) == 0 then //pull out of combat units only
            call ModifyThreat(pu, npc, 0, true)
        endif
    endif
    set pu = null
    set npc = null
    return false
endfunction

private function FilterUnitsWithCampGroup takes nothing returns boolean //only units that are out of combat and not patrolling
    return HaveSavedHandle(NPClist, GetHandleId(GetFilterUnit()), 4) and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and LoadInteger(NPClist, GetHandleId(GetFilterUnit()), 0) <= TState and GetUnitAbilityLevel(GetFilterUnit(), 'A0GY') <= 0
endfunction

public function AddThreatUnit takes unit u, boolean includeCombatCamps returns nothing
    local integer ID = GetHandleId(u)
    local group g = null
    local trigger t = null
    local unit other = null
    local integer otherID = 0
    local unit temp = null
    local integer i = 0
    local integer listlength = 0
    if HaveSavedInteger(NPClist, ID, 0) or HaveSavedHandle(PUlist, ID, 0) then //unit already added
        return
    elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then //unit dead or null
        return
    endif
    
    call UnitAddAbility(u, 'Aeth') //disable collision
    
    call SaveInteger(NPClist, ID, 0, 0) //status
    call SaveReal(NPClist, ID, 1, GetUnitX(u)) //return X
    call SaveReal(NPClist, ID, 2, GetUnitY(u)) //return Y
    call SaveReal(NPClist, ID, 3, 0) //combat time and return timer
    call SaveInteger(NPClist, ID, 5, 0) //list length
    set t = CreateTrigger()
    call TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ISSUED_TARGET_ORDER)
    call TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ACQUIRED_TARGET)
    call TriggerAddCondition(t, Condition(function AcquireTarget))
    call SaveTriggerHandle(NPClist, ID, 6, t) //acquire target event trigger
    if includeCombatCamps then
        set TState = 1
    else
        set TState = 0
    endif
    call GroupEnumUnitsInRange(TGroupSub, GetUnitX(u), GetUnitY(u), HelpRange, Condition(function FilterUnitsWithCampGroup))
    set other = FirstOfGroup(TGroupSub)
    if other != null and GetUnitAbilityLevel(u, 'A0GY') <= 0 then //valid unit in range and unit is not patrolling
        set otherID = GetHandleId(other)
        set g = LoadGroupHandle(NPClist, otherID, 4)
        if includeCombatCamps then
            //don't forget to inherit the camp unit's threat list...
            if LoadInteger(NPClist, otherID, 0) == 1 then //...but only if filtered unit is actually infight
                set listlength = LoadInteger(NPClist, otherID, 5)
                call SaveInteger(NPClist, ID, 5, listlength) //copy list length
                loop //copy all list entries as the newly added unit has an empty list and will cause the camp to reset almost instantly
                    set i = i + 1
                    exitwhen i > listlength
                    set temp = LoadUnitHandle(NPClist, otherID, Pos2Key(i))
                    call SaveUnitHandle(NPClist, ID, Pos2Key(i), temp)
                    call SaveReal(NPClist, ID, Pos2Key(i)+1, 0)
                    call SaveInteger(PUlist, GetHandleId(temp), ID, i) //assign the threat position to the player unit's reference list
                    call GroupAddUnit(LoadGroupHandle(PUlist, GetHandleId(temp), 0), u) //add the unit to the player unit's threat group
                    call SaveInteger(PUlist, GetHandleId(temp), 1, LoadInteger(PUlist, GetHandleId(temp), 1)+1) //increase group size count
                endloop
                call SaveInteger(NPClist, ID, 0, 1) //set unit status: combat
                call GroupAddUnit(NPCgroup, u) //add the unit to incombat group
                set temp = null
            endif
        endif
    else //no unit in range has a camp group assigned (or the unit is patrolling), so create a new one
        set g = CreateGroup()
    endif
    call GroupAddUnit(g, u)
    call SaveGroupHandle(NPClist, ID, 4, g) //camp group
    set t = null
    set g = null
    set other = null
endfunction

public function ChangeReturnPos takes unit u, real x, real y returns nothing
    local integer ID = GetHandleId(u)
    if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then //unit dead or null
        return
    endif
    if HaveSavedInteger(NPClist, ID, 0) then //unit in list
        call SaveReal(NPClist, ID, 1, x)
        call SaveReal(NPClist, ID, 2, y)
    endif
endfunction

public function AddPlayerUnit takes unit u returns nothing
    local integer ID = GetHandleId(u)
    if HaveSavedInteger(NPClist, ID, 0) or HaveSavedHandle(PUlist, ID, 0) then //unit already added
        return
    elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then //unit dead or null
        return
    endif
    call SaveGroupHandle(PUlist, ID, 0, CreateGroup()) //slot list group
    call SaveInteger(PUlist, ID, 1, 0) //list group count
endfunction

public function RemoveThreatUnit takes unit u returns nothing
    local integer ID = GetHandleId(u)
    local integer OtherID
    local group g = null
    local integer key = 10
    if not HaveSavedInteger(NPClist, ID, 0) then //unit not added
        return
    elseif GetUnitTypeId(u) == 0 then
        return
    endif
    if LoadInteger(NPClist, ID, 0) > 1 then //unit status is: returning
        call IssueImmediateOrder(u, "stop")
        call UnitRemoveAbility(u, 'Avul')
        if IsUnitSuspended(u) then
            call SuspendUnit(u, false)
        endif
    endif
    
    loop //remove the entry in the player unit's position list and list group and decrease list group count
        if HaveSavedHandle(NPClist, ID, key) then
            set OtherID = GetHandleId(LoadUnitHandle(NPClist, ID, key))
            call RemoveSavedInteger(PUlist, OtherID, ID)
            call GroupRemoveUnit(LoadGroupHandle(PUlist, OtherID, 0), u)
            call SaveInteger(PUlist, OtherID, 1, LoadInteger(PUlist, OtherID, 1)-1)
            set key = key+2
        else //last entry reached
            exitwhen true
        endif
    endloop
    
    set g = LoadGroupHandle(NPClist, ID, 4)
    call GroupRemoveUnit(g, u)
    if FirstOfGroup(g) == null then //camp group is empty
        call DestroyGroup(g)
    endif
    call DestroyTrigger(LoadTriggerHandle(NPClist, ID, 6))
    call FlushChildHashtable(NPClist, ID)
    if IsUnitInGroup(u, NPCgroup) then
        call GroupRemoveUnit(NPCgroup, u) //remove unit from incombat group
    endif
    set g = null
endfunction

private function RemovePlayerUnitEntries takes nothing returns nothing
    local integer ID = GetHandleId(TSub)
    local integer OtherID = GetHandleId(GetEnumUnit())
    local integer key = Pos2Key(LoadInteger(PUlist, ID, OtherID))
    loop //remove the entry in u's threat list and fill the gap
        if HaveSavedHandle(NPClist, OtherID, key+2) then //move up next entry
            call SaveUnitHandle(NPClist, OtherID, key, LoadUnitHandle(NPClist, OtherID, key+2))
            call SaveReal(NPClist, OtherID, key+1, LoadReal(NPClist, OtherID, key+3))
            call SaveInteger(PUlist, GetHandleId(LoadUnitHandle(NPClist, OtherID, key)), OtherID, Key2Pos(key)) //update position in player unit list
            set key = key+2
        else //last entry reached
            call RemoveSavedHandle(NPClist, OtherID, key)
            call RemoveSavedReal(NPClist, OtherID, key+1)
            call SaveInteger(NPClist, OtherID, 5, Key2Pos(key-2)) //decrease list length
            exitwhen true
        endif
    endloop
endfunction

public function RemovePlayerUnit takes unit u returns nothing
    local integer ID = GetHandleId(u)
    if not HaveSavedHandle(PUlist, ID, 0) then //unit not added
        return
    elseif GetUnitTypeId(u) == 0 then
        return
    endif
    set TSub = u
    call ForGroup(LoadGroupHandle(PUlist, ID, 0), function RemovePlayerUnitEntries)
    
    call DestroyGroup(LoadGroupHandle(PUlist, ID, 0))
    call DestroyTrigger(LoadTriggerHandle(PUlist, ID, 2))
    call FlushChildHashtable(PUlist, ID)
endfunction

private function HealThreatSub takes nothing returns nothing
    call ModifyThreat(THealer, GetEnumUnit(), THealthreat, TBool)
endfunction

public function ApplyHealThreat takes unit pu, unit ally, real amount, boolean add, boolean divide returns nothing
    local integer puID = GetHandleId(pu)
    local integer allyID = GetHandleId(ally)
    if not (HaveSavedHandle(PUlist, puID, 0) and HaveSavedHandle(PUlist, allyID, 0)) then //units not added
        return
    elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(ally, UNIT_TYPE_DEAD) then //units dead
        return
    elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(ally) == 0 then //null units
        return
    endif
    if divide and LoadInteger(PUlist, allyID, 1) > 1 then
        set THealthreat = amount/LoadInteger(PUlist, allyID, 1)
    else
        set THealthreat = amount
    endif
    set TBool = add
    set THealer = pu
    call ForGroup(LoadGroupHandle(PUlist, allyID, 0), function HealThreatSub)
endfunction

private function RemoveSummon takes nothing returns nothing
    local timer t = GetExpiredTimer()
    local unit u = LoadUnitHandle(TimerHash, GetHandleId(t), 0)
    call ZTS_RemoveThreatUnit(u)
    call RemoveUnit(u)
    call FlushChildHashtable(TimerHash, GetHandleId(t))
    call DestroyTimer(t)
    set u = null
    set t = null
endfunction

private function CampCommand takes nothing returns nothing
    local unit u = GetEnumUnit()
    local timer t = null
    local integer ID = GetHandleId(u)
    local integer OtherID
    local integer status = LoadInteger(NPClist, ID, 0)
    local integer key = 10
    if status == 1 then
        call SaveInteger(NPClist, GetHandleId(u), 0, 2) //set status: returning
        loop //remove the entry in the player unit's position list and list group and decrease list group count
            if HaveSavedHandle(NPClist, ID, key) then
                set OtherID = GetHandleId(LoadUnitHandle(NPClist, ID, key))
                call RemoveSavedInteger(PUlist, OtherID, ID)
                call GroupRemoveUnit(LoadGroupHandle(PUlist, OtherID, 0), u)
                call SaveInteger(PUlist, OtherID, 1, LoadInteger(PUlist, OtherID, 1)-1)
                call RemoveSavedHandle(NPClist, ID, key)
                call RemoveSavedReal(NPClist, ID, key+1)
                set key = key+2
            else //last entry reached
                exitwhen true
            endif
        endloop
        call RemoveAllBuffs(u)
        call SaveInteger(NPClist, ID, 5, 0) //also set list length to zero
        call IssueImmediateOrder(u, "stop") //cancels even spellcast with casting time
        call IssuePointOrder(u, "move", LoadReal(NPClist, ID, 1), LoadReal(NPClist, ID, 2))
        call SaveReal(NPClist, ID, 3, TimeToPort)
        call UnitAddAbility(u, 'Avul')
        if HealUnitsOnReturn then
            call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
            call SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
        endif
    elseif status == 3 then
        call SaveInteger(NPClist, GetHandleId(u), 0, 0) //set status: out of combat
        call SaveReal(NPClist, GetHandleId(u), 3, 0.) //reset incombat and return timer
        call UnitRemoveAbility(u, 'Avul')
        if HealUnitsOnReturn then
            call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
            call SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            call UnitResetCooldown(u)
        endif
        call GroupRemoveUnit(NPCgroup, u) //remove from combat group
        if GetUnitAbilityLevel(u, 'A052') > 0 then //is a summoned unit
            set t = CreateTimer()
            call SaveUnitHandle(TimerHash, GetHandleId(t), 0, u)
            call TimerStart(t, 0, false, function RemoveSummon)
            set t = null
        endif
        call SuspendUnit(u, false)
        call IssueImmediateOrder(u, "stop")
    endif
    set u = null
endfunction

private function CampStatus takes nothing returns nothing
    if LoadInteger(NPClist, GetHandleId(GetEnumUnit()), 0) != 3 then
        set TBool = false
    endif
endfunction

public function GetWoundedAlly takes unit U returns unit
    local group G = CreateGroup()
    local unit U2 = null
    local unit AITargetUnit = null
    call GroupEnumUnitsInRange(G, GetUnitX(U), GetUnitY(U), 700, BOOLEXPR_TRUE)
    loop
        set U2 = FirstOfGroup(G)
        exitwhen U2 == null
        if IsUnitAlly(U2, GetOwningPlayer(U)) and GetOwningPlayer(U2) != Player(PLAYER_NEUTRAL_PASSIVE) then
            if IsUnitType(U2, UNIT_TYPE_DEAD) == false then
                if GetUnitTypeId(AITargetUnit) == null then
                    set AITargetUnit = U2
                else
                    if (GetUnitState(AITargetUnit, UNIT_STATE_LIFE) / GetUnitState(AITargetUnit, UNIT_STATE_MAX_LIFE)) > (GetUnitState(U2, UNIT_STATE_LIFE) / GetUnitState(U2, UNIT_STATE_MAX_LIFE)) then
                        set AITargetUnit = U2
                    endif
                endif
            endif
        endif
        call GroupRemoveUnit(G, U2)
    endloop
    call DestroyGroup(G)
    set G = null
    set U2 = null
    return AITargetUnit
endfunction

private function FilterEnemyAliveCombatUnits takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(), AIPlayer) and GetCombatState(GetFilterUnit()) and GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0
endfunction

private function FilterEnemyAliveCombatHeroes takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(), AIPlayer) and GetCombatState(GetFilterUnit()) and IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) and GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0
endfunction

public function SimpleAIOrder takes unit U, boolean B, string O1, integer T1, string O2, integer T2, string O3, integer T3, string O4, integer T4 returns boolean
    local unit target = null
    local integer i = 0
    local integer TempTarget = T1
    local string TempOrder = O1
    local boolean isCreep = true
    local unit petTarget
    if GetPlayerId(GetOwningPlayer(U)) < 6 then
        set isCreep = false
        set petTarget = PlayerPetTarget[GetPlayerId(GetOwningPlayer(U))+1]
    endif
    if B == false then
        loop
            set i = i + 1
            exitwhen i > 4 or B == true
            if i == 2 then
                set TempOrder = O2
                set TempTarget = T2
            elseif i == 3 then
                set TempOrder = O3
                set TempTarget = T3
            elseif i == 4 then
                set TempOrder = O4
                set TempTarget = T4
            endif
            if TempOrder != "" then
                if not isCreep then
                    if TempTarget <= -2 or TempTarget >= 2 then
                        set TempTarget = 1 //no random orders for enslaved creeps
                    endif
                endif
                if TempTarget == -1 then
                    set B = IssueImmediateOrder(U, TempOrder)
                elseif TempTarget == 0 then
                    set B = IssueTargetOrder(U, TempOrder, U)
                elseif TempTarget == 1 then
                    if isCreep then
                        set target = GetThreatSlotUnit(U, 1)
                    else
                        set target = petTarget
                    endif
                    set B = IssueTargetOrder(U, TempOrder, target)
                    if B == false then
                        set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                    endif
                elseif TempTarget == 2 then
                    set target = GetThreatSlotUnit(U, 2)
                    if target != null and GetUnitAbilityLevel(target, 'Aloc') <= 0 then
                        set B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        endif
                    else
                        set target = GetThreatSlotUnit(U, 1)
                        set B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        endif
                    endif
                elseif TempTarget == 3 then
                    set target = GetThreatSlotUnit(U, 3)
                    if target != null and GetUnitAbilityLevel(target, 'Aloc') <= 0 then
                        set B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        endif
                    else
                        set target = GetThreatSlotUnit(U, 2)
                        if target != null and GetUnitAbilityLevel(target, 'Aloc') <= 0 then
                            set B = IssueTargetOrder(U, TempOrder, target)
                            if B == false then
                                set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                            endif
                        else
                            set target = GetThreatSlotUnit(U, 1)
                            set B = IssueTargetOrder(U, TempOrder, target)
                            if B == false then
                                set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                            endif
                        endif
                    endif
                elseif TempTarget == -2 then //Random unit in range
                    set AIPlayer = GetOwningPlayer(U)
                    call GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(function FilterEnemyAliveCombatUnits))
                    set target = GroupPickRandomUnit(AIGroup)
                    set B = IssueTargetOrder(U, TempOrder, target)
                    if B == false then
                        set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                    endif
                elseif TempTarget == -3 then //Random unit except first in aggro
                    set AIPlayer = GetOwningPlayer(U)
                    call GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(function FilterEnemyAliveCombatUnits))
                    call GroupRemoveUnit(AIGroup, GetThreatSlotUnit(U, 1))
                    set target = GroupPickRandomUnit(AIGroup)
                    if target == null then
                        set target = GetThreatSlotUnit(U, 1)
                    endif
                    set B = IssueTargetOrder(U, TempOrder, target)
                    if B == false then
                        set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                    endif
                else //Random hero unit
                    set AIPlayer = GetOwningPlayer(U)
                    call GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(function FilterEnemyAliveCombatHeroes))
                    set target = GroupPickRandomUnit(AIGroup)
                    set B = IssueTargetOrder(U, TempOrder, target)
                    if B == false then
                        set B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                    endif
                endif
            else
                set target = null
                return B
            endif
        endloop
    endif
    set target = null
    set petTarget = null
    return B
endfunction

private function IssueSpellOrder takes unit u, unit target returns nothing
    local group g
    local unit temp
    local real r
    local real x
    local real y
    set IssueOrderUnit = u
    set IssueNoAttackOrder = false
    if HaveSavedHandle(Triggerhash, GetUnitTypeId(u), 0) then
        call TriggerEvaluate(LoadTriggerHandle(Triggerhash, GetUnitTypeId(u), 0))
    elseif GetUnitAbilityLevel(u, 'A0I1') > 0 then
        call TriggerEvaluate(LoadTriggerHandle(Triggerhash, 'A0I1', 0)) 
    endif
    if not IssueNoAttackOrder then
        if IsUnitInRange(target, u, 100) and not IsUnitType(u, UNIT_TYPE_SAPPER) then //reposition only non-boss melees
            set g = CreateGroup()
            call GroupEnumUnitsInRange(g, GetUnitX(u), GetUnitY(u), 48, BOOLEXPR_TRUE)
            loop
                set temp = FirstOfGroup(g)
                exitwhen temp == null
                if temp != u and IsUnitType(temp, UNIT_TYPE_DEAD) == false and IsUnitAlly(temp, GetOwningPlayer(u)) and GetUnitCurrentOrder(temp) != 851986 then
                    set r = Atan2(GetUnitY(u) - GetUnitY(target), GetUnitX(u) - GetUnitX(target)) + GetRandomReal(0, 3)
                    set x = GetUnitX(target)+Cos(r)*60
                    set y = GetUnitY(target)+Sin(r)*60
                    set IssueNoAttackOrder = IssuePointOrderById(u, 851986, x, y)
                endif
                call GroupRemoveUnit(g, temp)
            endloop
            call DestroyGroup(g)
        endif
        if not IssueNoAttackOrder then
            set IssueNoAttackOrder = IssueTargetOrder(u, "smart", target) //returns false if unit is out of range
        endif
    endif
    if GetUnitTypeId(u) == 'n02J' then //Spirit of Magic
        if not IsUnitInRange(u, target, 500) then
            call ForGroup(LoadGroupHandle(NPClist, GetHandleId(u), 4), function CampCommand) //set camp returning
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AItb\\AItbTarget.mdl", GetUnitX(u), GetUnitY(u)))
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualTarget.mdl", GetUnitX(u), GetUnitY(u)))
            call RemoveUnit(u)
            set MageDungeon_state = 0
            call DestroyEffect(MageDungeon_NWactive)
            set MageDungeon_NWactive = null
            call DestroyEffect(MageDungeon_NEactive)
            set MageDungeon_NEactive = null
            call DestroyEffect(MageDungeon_SWactive)
            set MageDungeon_SWactive = null
            call DestroyEffect(MageDungeon_SEactive)
            set MageDungeon_SEactive = null
            set MageDungeon_boss = null
        endif
    elseif GetUnitTypeId(u) == 'nfgo' then //Ancient One
        if not IsUnitInRange(u, target, 1300) then
            call ForGroup(LoadGroupHandle(NPClist, GetHandleId(u), 4), function CampCommand) //set camp returning
        endif
    elseif GetUnitTypeId(u) == 'nfgt' then //Tentacle
        if not IsUnitInRange(u, target, 800) then
            call ForGroup(LoadGroupHandle(NPClist, GetHandleId(u), 4), function CampCommand) //set camp returning
        endif
    endif
    set temp = null
    set g = null
endfunction

private function IssueOrder takes nothing returns nothing
    local unit npc = GetEnumUnit()
    local integer npcID = GetHandleId(npc)
    local integer status = LoadInteger(NPClist, npcID, 0)
    local integer i = 0
    local unit target = null
    local real Range = ReturnRange
    local real OrderRange = OrderReturnRange
    if status == 1 then //unit in combat
    
        if SubString(GetUnitName(npc),0,10) == "|cffffcc00" then
            set Range = DungeonRange
        endif
        if GetUnitAbilityLevel(npc, 'A01H') > 0 then //Event return range
            set Range = 10000
            set OrderRange = 10000
        endif
        
        call SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) + UpdateIntervall)
        
        if IsUnitInRangeXY(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), Range) and HaveSavedHandle(NPClist, npcID, 10) then
            set target = LoadUnitHandle(NPClist, npcID, 10)
            if IsUnitInRangeXY(target, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), OrderRange) then
                if GetUnitCurrentOrder(npc) == 851983 or GetUnitCurrentOrder(npc) == 0 or GetUnitCurrentOrder(npc) == 851971 then //attack order, no order or smart
                    set EventBool = true
                    call IssueSpellOrder(npc, target)
                    set EventBool = false
                endif
            else //target of unit to far away from camp position
                call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampCommand) //set camp returning
            endif
        else //unit left return range or killed all player units
            call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampCommand) //set camp returning
        endif
    elseif status == 2 then //unit is returning
        if LoadReal(NPClist, npcID, 3) > 0 then
            if not IsUnitInRangeXY(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), 35) then
                call IssuePointOrder(npc, "move", LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2))
                call SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) - UpdateIntervall)
                call UnitAddAbility(npc, 'Avul')
            else //unit within close range to camp position
                if GetUnitCurrentOrder(npc) == 851986 then //move order
                    call SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) - UpdateIntervall)
                    call UnitAddAbility(npc, 'Avul')
                else //Something blocks the exact spot or the unit has arrived
                    call SaveInteger(NPClist, npcID, 0, 3) //set status: returned
                    call SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) - UpdateIntervall)
                    set TBool = true
                    call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampStatus)
                    if TBool then //all units in camp have status: returned to camp position
                        call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampCommand) //set camp ooc
                    else
                        call SuspendUnit(npc, true) //make sure it doesn't move or attack when invulnerable
                    endif
                endif
            endif
        else //counter expired - perform instant teleport
            call SetUnitPosition(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2))
            call SaveInteger(NPClist, npcID, 0, 3) //set status: returned
            set TBool = true
            call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampStatus)
            if TBool then //all units in camp have status: returned to camp position
                call ForGroup(LoadGroupHandle(NPClist, npcID, 4), function CampCommand) //set camp ooc
            else
                call SuspendUnit(npc, true) //make sure it doesn't move or attack when invulnerable
            endif
        endif
    endif
    set npc = null
    set target = null
endfunction

private function Update takes nothing returns nothing 
    call ForGroup(NPCgroup, function IssueOrder) //issues orders to all units in combat
endfunction

private function rettrue takes nothing returns boolean
    return true
endfunction

private function RemovedUnitFound takes nothing returns boolean
    if HaveSavedInteger(NPClist, GetHandleId(GetIndexedUnit()), 0) then
        call RemoveThreatUnit(GetIndexedUnit())
    elseif HaveSavedHandle(PUlist, GetHandleId(GetIndexedUnit()), 0) then
        call RemovePlayerUnit(GetIndexedUnit())
    endif
    return true
endfunction

private function OnDeath takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local unit target
    local integer i = 0
    if HaveSavedInteger(NPClist, GetHandleId(u), 0) then
        call RemoveThreatUnit(u)
    endif
    if HaveSavedHandle(PUlist, GetHandleId(u), 0) then
        call RemovePlayerUnit(u)
    endif
    set target = null
    set u = null
endfunction

private function AddOnlyNonDummyNH takes nothing returns boolean
    if GetOwningPlayer(GetFilterUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE) and GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') == 0 then
        call AddThreatUnit(GetFilterUnit(), false)
    endif
    return false
endfunction

private function InitThreatSystem takes nothing returns nothing
    local group g=CreateGroup()
    local trigger t = CreateTrigger()
    local integer index = 0
    set BOOLEXPR=Condition(function rettrue) //prevent booleanexpressions from leaking
    call TimerStart(Updater, UpdateIntervall, true, function Update)
    loop
        call TriggerRegisterPlayerUnitEvent(t, Player(index), EVENT_PLAYER_UNIT_DEATH, BOOLEXPR)
        set index = index + 1
        exitwhen index == bj_MAX_PLAYER_SLOTS
    endloop
    call TriggerAddAction(t, function OnDeath)
    set t = CreateTrigger()
    call TriggerRegisterUnitIndexEvent(t, EVENT_UNIT_DEINDEX)
    call TriggerAddCondition(t, Condition(function RemovedUnitFound))
    set t = null
    
    call GroupEnumUnitsOfPlayer(g,Player(PLAYER_NEUTRAL_AGGRESSIVE),Condition(function AddOnlyNonDummyNH))
    call DestroyGroup(g)
    set g=null
endfunction

endlibrary