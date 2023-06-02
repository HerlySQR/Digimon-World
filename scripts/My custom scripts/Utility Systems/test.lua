if Debug then Debug.beginFile("Zwiebelchen's threat system") end
--------------------------------------------------------------------------------------------------------//
--  ZTS - ZWIEBELCHEN'S THREAT SYSTEM        v. 2.6                                                     //
--------------------------------------------------------------------------------------------------------//         
--------------------------------------------------------------------------------------------------------//
--                                                                                                      //
--                                                                                                      //
--  Special thanks to TEC-Ghost, who inspired me on creating this system.                               //
--------------------------------------------------------------------------------------------------------//
--                                              MANUAL                                                  //
--------------------------------------------------------------------------------------------------------//
-- 1.   How to Install:
--
--      - Create a trigger called "ZTS"
--      - Convert it to custom Text
--      - Replace everything inside with this code
--
--
-- 2.   How to set it up:
--
--  2.1 Constants
--
--      There are a bunch of global constants below this manual, you can edit to your liking.
--      I commented everything you need to know about those constants right beside them. If you need additional information,
--      please tell me, so I can improve this manual. However, I think most of it should be pretty clear.
--
--  2.2. Gameplay Constants
--
--      It is recommended to edit certain Gameplay Constants entries, to use the full potential of
--      the system.
--      The most important entries are: (with selected "Show Raw-Data")
--      CallForHelp                 --> Set this to 0, if possible; the system will manage this - it isn't a problem if you don't do this, though
--                                      You don't have to do it if your threat-system controlled units are neutral hostile
--      CreepCallForHelp            --> Set this to 0, if possible; the system will manage this - it isn't a problem if you don't do this, though
--      GuardDistance               --> Set this to something higher than ReturnRange (see below)
--      MaxGuardDistance            --> Set this to something higher than ReturnRange (see below)
--      GuardReturnTime             --> Set this to something very high, so that the standard AI doesn't interfere (i.e. 60 seconds)       
--
--  2.3. Damage Detection
--
--      Of course, a threat system is pretty useless without a trigger, that adds threat depending on
--      the damage dealt by a player unit.
--      I recommend using a damage detection script like IDDS:
--      (http://www.wc3c.net/showthread.php?t=100618)
--      Check up the demo map for a very simple (but leaking) damage detection trigger
--      The only function you actually need then is:
--      call ZTS_ModifyThreat(GetEventDamageSource(), GetTriggerUnit(), GetEventDamage(), true)
--      The function does all required checks on its own. There is no need to run something else.
--
-- 3. How to use it:
--
--  3.1. Core functions
--
--      call ZTS_AddThreatUnit(unit npc, boolean includeCombatCamps) returns nothing:
--
--          This function registers the unit as an AI-controlled unit.
--          ThreatUnits will automaticly attack the highest-in-threat attacker.
--          When adding a ThreatUnit, its current position gets saved and be considered camp-position.
--          It will always return to this position if pulled to far or on victory.
--          Nearby units will be considered in the same camp group. Camp members will always retreat and attack together.
--          If includeCombatCamps is true, the unit will be added to already fighting camps. If it is false, the unit will
--          create its own camp group, if it can't find any non-fighting units nearby.
--          This should be false in most cases, but it can be useful when you have bosses that summon units infight, so that
--          the summons will be added to the bossfight correctly instead of getting their own seperate group.
--
--      call ZTS_AddPlayerUnit(unit pu) returns nothing:
--
--          Units add by this way will generate threat on ThreatUnits.
--          If the unit is not registered as a PlayerUnit, it will not be attacked by ThreatUnits.
--
--      call ZTS_RemoveThreatUnit(unit npc) returns nothing:
--
--          Removes a ThreatUnit from the system. The unit will no longer be controlled by the threat system.
--          Also, the threat list for that unit will be cleared.
--          Dead or removed units will automaticly be cleared. You need to add them again after revival/recreation.
--
--      call ZTS_RemovePlayerUnit(unit pu) returns nothing:
--
--          Removes a player unit from the system. The unit will no longer generate threat on ThreatUnits.
--          The unit will also be instantly removed from all threat lists.
--          If the unit was the last unit in combat with the same hostile camp, all units
--          of that camp group will immediately return to their camp positions.
--          You can use this, followed by AddPlayerUnit to that unit out of combat and reset all threat.
--          Dead or removed units will automaticly be cleared. You need to add them again after revival/recreation.
--
--      call ZTS_ModifyThreat(unit pu, unit npc, number amount, boolean add) returns nothing:
--
--          Adds, sets or substracts threat from npc's threat list caused by pu.
--          Set 'add' to true to add or substract amount from the current value.
--          Set 'add' to false to set the new threat value to amount.
--          To reduce threat, use negative amount values with add == true.
--          Remember: If a unit has 0 threat, it is still considered in-combat -
--          this also means, that adding "0" to the units threat causes them to attack!
--
--      call ZTS_ApplyHealThreat(unit pu, unit ally, number amount, boolean add, boolean divide) returns nothing:
--
--          Adds Healing Threat to all units, that have ally on threat-list
--          This can be abused to apply global threat to a unit by passing the same unit to p and ally.
--          Parameter divide = true means that the amount is split by the number of units attacking the target;
--          for example if 3 units are currently attacking the targeted ally, it adds amount/3 threat from pu to all of them.
--          Parameter divide = false means that every attacking unit gets 'amount' of threat applied.
--          use add = false to set the amount of threat to 'amount', instead of increasing/decreasing it
--          negative values are allowed in combination with 'add' to reduce threat.
--          You can also use this with add = false and amount = 0 with pu = ally to set total threat generated back to zero for this unit.
--
--
--  3.2. Getter functions
--
--      call ZTS_GetCombatState(unit U) returns boolean:
--
--          Returns the combat state of a player or npc unit.
--          Returns true, if the unit is registered and in combat.
--          Returns false, if the unit is not registered or out of combat.
--
--      call ZTS_GetCombatTime(unit NPC) returns boolean:
--
--          Returns the incombat time of the npc.
--          Does not work for player units.
--          Returns "0" if the unit is not in combat or currently returning to camp position.
--
--      call ZTS_GetThreatUnitPosition(unit NPC, unit PU) returns integer:
--
--          Returns the position of unit PU in unit NPC's threat list
--          Returns "0" if the unit was not found, NPC does not feature a threat list or in case of invalid input data
--
--      call ZTS_GetThreatUnitAmount(unit NPC, unit PU) returns number:
--
--          Returns the amount of threat unit PU has in unit NPC's threat list
--          Returns "0" if the unit was not found, NPC does not feature a threat list or in case of invalid input data
--
--      call ZTS_GetThreatSlotUnit(unit NPC, integer position) returns unit:
--
--          Returns the unit in threat-slot position
--          Returns null if the NPC does not feature a threat list, the number is too large
--          or in case of invalid input data
--
--      call ZTS_GetThreatSlotAmount(unit NPC, integer position) returns number:
--
--          Returns the threat amount of the threat-slot position
--          Returns "0" if the NPC does not feature a threat list, the number is too large
--          or in case of invalid input data
--
--      call ZTS_GetAttackers(unit U) returns group:
--
--          If used on a ThreatUnit, this returns a group of all units in threat list;
--          if used on a PlayerUnit, this returns a group of all units aggroed.
--          Returns an empty group, in case of invalid input data or empty lists.
--
--  
--  3.3. Advanced User features
--
--      call ZTS_IsEvent() returns boolean
--
--          When using "A unit is issued an order without target" or "A unit is issued a target order" events,
--          this function returns true when the order was issued by the threat system.
--          You can use this to setup your own spell-AI for units.
--          Let's say you want the unit to cast Summon Water Elemental whenever the cooldown is ready:
--          Just use the mentioned events and add:
--              Custom script:   if not ZTS_IsEvent() then
--              Custom script:   return
--              Custom script:   endif
--          at the beginning of you trigger's actions and you're done.
--          You can now issue the order to the triggering unit:
--              Unit - Order (Triggering unit) to Human Archmage - Summon Water Elemental
--          In combination with some of the Getter functions, you can trigger nice spell AI like this.
--          NOTE: ZTS_IsEvent will only return true once(!) for every fired event, so if you need it again inside that trigger,
--                make sure to save it to a variable.
--
--------------------------------------------------------------------------------------------------------//

OnInit("ZTS", function ()
    Require "AddHook"
    Require "MDTable"
   
    local UpdateIntervall      = 0.5  ---@type number --The intervall for issueing orders and performing AttackRange check. recommended value: 0.5
    local HelpRange      = 400  ---@type number --The range between units considered being in the same camp. If a unit of the same camp gets attacked, all others will help.
                                          --Set CallForHelp to something lower in Gameplay Constants.
    local OrderReturnRange      = 4000  ---@type number --The range the unit's target can be away from the original camping position, before being ordered to return.
    local ReturnRange      = 1500  ---@type number --The range the unit can move away from the original camping position, before being ordered to return.
    local TimeToPort      = 10  ---@type number --This timer expires once a unit tries to return to its camping position.
                                          --If it reaches 0 before reaching the camp position, the unit will be teleported immediately.
    local HealUnitsOnReturn         = true  ---@type boolean --If this is true, returning units will be healed to 100% health.
    
    
--      Do not edit below here!
--------------------------------------------------------------------------------------------------------//  
    local BOOLEXPR          = nil ---@type boolexpr 
    local Updater       = CreateTimer() ---@type timer 
    local NPCgroup       = CreateGroup() ---@type group 
    local NPClist           = MDTable.create(2)
    local PUlist           = MDTable.create(2)
    
    --temporary variables for enumerations and forgroups
    local TSub      = nil ---@type unit 
    local TMod      = nil ---@type unit 
    local TGroupSub       = CreateGroup() ---@type group 
    local THealer      = nil ---@type unit 
    local THealthreat      = 0 ---@type number 
    local TBool         = false ---@type boolean 
    local TState         = 0 ---@type integer 
    local TGroupUpd       = CreateGroup() ---@type group 
    local TGroupGet       = nil ---@type group 
    local EventBool         = false ---@type boolean 


    ---@return boolean
    function ZTS_IsEvent()
        if EventBool then
            EventBool = false
            return true
        end
        return false
    end

    ---@param position integer
    ---@return integer
    local function Pos2Key(position) --converts threat list position into hashtable childkey
        return 8+(position*2)
    end

    ---@param key integer
    ---@return integer
    local function Key2Pos(key) --converts hashtable childkey into threat list position
        return (key-8)//2
    end

    ---@param u unit
    ---@return boolean
    function ZTS_GetCombatState(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then --unit dead or null
            return false
        elseif HaveSavedInteger(NPClist, GetHandleId(u), 0) then --unit is npc
            return LoadInteger(NPClist, GetHandleId(u), 0) > 0
        elseif HaveSavedHandle(PUlist, GetHandleId(u), 0) then --unit is player unit
            return LoadInteger(PUlist, GetHandleId(u), 1) > 0
        end
        return false
    end

    ---@param u unit
    ---@return number
    function ZTS_GetCombatTime(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then --unit dead or null
            return 0.
        elseif HaveSavedInteger(NPClist, GetHandleId(u), 0) then --unit is npc
            if LoadInteger(NPClist, GetHandleId(u), 0) == 1 then --only return a time when the unit is in combat
                return LoadReal(NPClist, GetHandleId(u), 3)
            end
        end
        return 0.
    end

    ---@param npc unit
    ---@param pu unit
    ---@return integer
    function ZTS_GetThreatUnitPosition(npc, pu)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) or GetUnitTypeId(pu) == 0 or IsUnitType(pu, UNIT_TYPE_DEAD) then --units dead or null
            return 0
        elseif not (HaveSavedInteger(NPClist, GetHandleId(npc), 0) and HaveSavedHandle(PUlist, GetHandleId(pu), 0)) then --units not added
            return 0
        elseif HaveSavedInteger(PUlist, GetHandleId(pu), GetHandleId(npc)) then
            return LoadInteger(PUlist, GetHandleId(pu), GetHandleId(npc))
        end
        return 0
    end

    ---@param npc unit
    ---@param pu unit
    ---@return number
    function ZTS_GetThreatUnitAmount(npc, pu)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) or GetUnitTypeId(pu) == 0 or IsUnitType(pu, UNIT_TYPE_DEAD) then --units dead or null
            return 0.
        elseif not (HaveSavedInteger(NPClist, GetHandleId(npc), 0) and HaveSavedHandle(PUlist, GetHandleId(pu), 0)) then --units not added
            return 0.
        elseif HaveSavedInteger(PUlist, GetHandleId(pu), GetHandleId(npc)) then
            return LoadReal(NPClist, GetHandleId(npc), Pos2Key(LoadInteger(PUlist, GetHandleId(pu), GetHandleId(npc)))+1)
        end
        return 0.
    end

    ---@param npc unit
    ---@param position integer
    ---@return unit
    function ZTS_GetThreatSlotUnit(npc, position)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) or position <= 0 then --unit dead or null or invalid slot
            return nil
        elseif not HaveSavedInteger(NPClist, GetHandleId(npc), 0) then --unit not added
            return nil
        elseif HaveSavedHandle(NPClist, GetHandleId(npc), Pos2Key(position)) then
            return LoadUnitHandle(NPClist, GetHandleId(npc), Pos2Key(position))
        end
        return nil
    end

    ---@param npc unit
    ---@param position integer
    ---@return number
    function ZTS_GetThreatSlotAmount(npc, position)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) or position <= 0 then --unit dead or null or invalid slot
            return 0.
        elseif not HaveSavedInteger(NPClist, GetHandleId(npc), 0) then --unit not added
            return 0.
        elseif HaveSavedReal(NPClist, GetHandleId(npc), Pos2Key(position)+1) then
            return LoadReal(NPClist, GetHandleId(npc), Pos2Key(position)+1)
        end
        return 0.
    end

    local function GetAttackersSub()
        GroupAddUnit(TGroupGet, GetEnumUnit())
    end

    ---@param u unit
    ---@return group
    function ZTS_GetAttackers(u)
        local g       = CreateGroup() ---@type group 
        local key         = 10 ---@type integer 
        local max ---@type integer 
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then --unit dead or null
            return g
        end
        if HaveSavedInteger(NPClist, GetHandleId(u), 0) then --unit is npc
            max = Pos2Key(LoadInteger(NPClist, GetHandleId(u), 5))
            while key <= max do 
                GroupAddUnit(g, LoadUnitHandle(NPClist, GetHandleId(u), key))
                key = key+2
            end
        elseif HaveSavedHandle(PUlist, GetHandleId(u), 0) then --unit is player unit
            TGroupGet = g
            ForGroup(LoadGroupHandle(PUlist, GetHandleId(u), 0), GetAttackersSub)
            g = TGroupGet
            TGroupGet = nil
        end
        return g
    end

    ---@param npcID integer
    ---@param key1 integer
    ---@param key2 integer
    local function Swap(npcID, key1, key2)
        local u      = LoadUnitHandle(NPClist, npcID, key1) ---@type unit 
        local r      = LoadReal(NPClist, npcID, key1+1) ---@type number 
        SaveUnitHandle(NPClist, npcID, key1, LoadUnitHandle(NPClist, npcID, key2))
        SaveReal(NPClist, npcID, key1+1, LoadReal(NPClist, npcID, key2+1))
        SaveInteger(PUlist, GetHandleId(LoadUnitHandle(NPClist, npcID, key1)), npcID, Key2Pos(key1)) --update position list
        SaveUnitHandle(NPClist, npcID, key2, u)
        SaveReal(NPClist, npcID, key2+1, r)
        SaveInteger(PUlist, GetHandleId(u), npcID, Key2Pos(key2)) --update position list
        u = nil
    end

    local function CampThreat()
        local npcID         = GetHandleId(GetEnumUnit()) ---@type integer 
        local puID         = GetHandleId(TMod) ---@type integer 
        local key ---@type integer 
        local listlength ---@type integer 
        if GetEnumUnit() == TSub then
            return
        elseif HaveSavedInteger(PUlist, puID, npcID) then --original pu unit already listed in EnumUnit's threat list
            return
        elseif LoadInteger(NPClist, npcID, 0) > 1 or IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) then --do not add threat to dead or units that are status: returning
            return
        end
        listlength = LoadInteger(NPClist, npcID, 5)+1
        SaveInteger(NPClist, npcID, 5, listlength) --add to list length of EnumUnit
        key = Pos2Key(listlength)
        SaveUnitHandle(NPClist, npcID, key, TMod) --add original pu unit to end of EnumUnit's threat list
        SaveReal(NPClist, npcID, key+1, 0)
        SaveInteger(PUlist, puID, npcID, listlength) --add EnumUnit to slot list
        GroupAddUnit(LoadGroupHandle(PUlist, puID, 0), GetEnumUnit()) --add EnumUnit to slot list group
        SaveInteger(PUlist, puID, 1, LoadInteger(PUlist, puID, 1)+1) --increase group size count
        if LoadInteger(NPClist, npcID, 0) == 0 then
            SaveInteger(NPClist, npcID, 0, 1) --set unit status: combat
            GroupAddUnit(NPCgroup, GetEnumUnit()) --add the unit to incombat group
        end
    end

    ---@param pu unit
    ---@param npc unit
    ---@param amount number
    ---@param add boolean
    function ZTS_ModifyThreat(pu, npc, amount, add)
        local npcID         = GetHandleId(npc) ---@type integer 
        local puID         = GetHandleId(pu) ---@type integer 
        local key ---@type integer 
        local listlength ---@type integer 
        local i         = 0 ---@type integer 
        local newamount ---@type number 
        local oldamount      = 0 ---@type number 
        local b         = false ---@type boolean 
        if not (HaveSavedInteger(NPClist, npcID, 0) and HaveSavedHandle(PUlist, puID, 0)) then --units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(npc, UNIT_TYPE_DEAD) then --units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(npc) == 0 then --null units
            return
        elseif LoadInteger(NPClist, npcID, 0) > 1 then --do not add threat to units that are status: returning
            return
        end
        if not HaveSavedInteger(PUlist, puID, npcID) then --pu not listed in npc's threat list
            listlength = LoadInteger(NPClist, npcID, 5)+1
            SaveInteger(NPClist, npcID, 5, listlength) --add to list length of npc
            key = Pos2Key(listlength)
            SaveUnitHandle(NPClist, npcID, key, pu) --add pu to end of npc's threat list
            SaveInteger(PUlist, puID, npcID, listlength) --add npc to slot list
            GroupAddUnit(LoadGroupHandle(PUlist, puID, 0), npc) --add npc to slot list group
            SaveInteger(PUlist, puID, 1, LoadInteger(PUlist, puID, 1)+1) --increase group size count
            if LoadInteger(NPClist, npcID, 0) == 0 then
                SaveInteger(NPClist, npcID, 0, 1) --set unit status: combat
                GroupAddUnit(NPCgroup, npc) --add the unit to incombat group
            end
            b = true
        else
            key = Pos2Key(LoadInteger(PUlist, puID, npcID))
            oldamount = LoadReal(NPClist, npcID, key+1)
        end
        if add then
            newamount = oldamount+amount
        else
            newamount = amount
        end
        if newamount < 0 then
            newamount = 0
        end
        SaveReal(NPClist, npcID, key+1, newamount)
        if newamount > oldamount then --check lower keys
            while true do
                if HaveSavedReal(NPClist, npcID, key-1-i) then
                    if LoadReal(NPClist, npcID, key-1-i) < newamount then --lower key amount is smaller
                        Swap(npcID, key-2-i, key-i)
                    else
                        break
                    end
                    i = i + 2
                else
                    break
                end
            end
        elseif newamount < oldamount then --check higher keys
            while true do
                if HaveSavedReal(NPClist, npcID, key+3+i) then
                    if LoadReal(NPClist, npcID, key+3+i) > newamount then --upper key amount is larger
                        Swap(npcID, key+2+i, key+i)
                    else
                        break
                    end
                    i = i + 2
                else
                    break
                end
            end
        end
        if b then --set all units of the same camp to status: combat and apply 0 threat from pu to them
            TSub = npc
            TMod = pu
            ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampThreat)
        end
    end

    ---@param u unit
    function ZTS_AddPlayerUnit(u)
        local ID         = GetHandleId(u) ---@type integer 
        if HaveSavedInteger(NPClist, ID, 0) or HaveSavedHandle(PUlist, ID, 0) then --unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then --unit dead or null
            return
        end
        SaveGroupHandle(PUlist, ID, 0, CreateGroup()) --slot list group
        SaveInteger(PUlist, ID, 1, 0) --list group count
    end

    ---@return boolean
    local function AcquireTarget()
        local npc      = GetTriggerUnit() ---@type unit 
        local pu ---@type unit 
        if GetEventTargetUnit() ~= nil then
            pu = GetEventTargetUnit()
        else
            pu = GetOrderTargetUnit()
        end
        if IsUnitEnemy(pu, GetOwningPlayer(npc)) then
            if LoadInteger(NPClist, GetHandleId(npc), 0) == 0 then --pull out of combat units only
                ZTS_ModifyThreat(pu, npc, 0, true)
            end
        end
        pu = nil
        npc = nil
        return false
    end

    ---@return boolean
    local function FilterUnitsWithCampGroup()
        return HaveSavedHandle(NPClist, GetHandleId(GetFilterUnit()), 4) and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and LoadInteger(NPClist, GetHandleId(GetFilterUnit()), 0) <= TState
    end

    ---@param u unit
    ---@param includeCombatCamps boolean
    function ZTS_AddThreatUnit(u, includeCombatCamps)
        local ID         = GetHandleId(u) ---@type integer 
        local g       = nil ---@type group 
        local t         = nil ---@type trigger 
        local other      = nil ---@type unit 
        local otherID         = 0 ---@type integer 
        local temp      = nil ---@type unit 
        local i         = 0 ---@type integer 
        local listlength         = 0 ---@type integer 
        if HaveSavedInteger(NPClist, ID, 0) or HaveSavedHandle(PUlist, ID, 0) then --unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then --unit dead or null
            return
        end
        SaveInteger(NPClist, ID, 0, 0) --status
        SaveReal(NPClist, ID, 1, GetUnitX(u)) --return X
        SaveReal(NPClist, ID, 2, GetUnitY(u)) --return Y
        SaveReal(NPClist, ID, 3, 0) --return countdown and incombat timer
        SaveInteger(NPClist, ID, 5, 0) --list length
        t = CreateTrigger()
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ACQUIRED_TARGET)
        TriggerAddCondition(t, Condition(AcquireTarget))
        SaveTriggerHandle(NPClist, ID, 6, t) --acquire target event trigger
        if includeCombatCamps then
            TState = 1
        else
            TState = 0
        end
        GroupEnumUnitsInRange(TGroupSub, GetUnitX(u), GetUnitY(u), HelpRange, Condition(FilterUnitsWithCampGroup))
        other = FirstOfGroup(TGroupSub)
        if other ~= nil then
            otherID = GetHandleId(other)
            g = LoadGroupHandle(NPClist, otherID, 4)
            if includeCombatCamps then
                --don't forget to inherit the camp unit's threat list...
                if LoadInteger(NPClist, otherID, 0) == 1 then --...but only if filtered unit is actually infight
                    listlength = LoadInteger(NPClist, otherID, 5)
                    SaveInteger(NPClist, ID, 5, listlength) --copy list length
                    while true do --copy all list entries as the newly added unit has an empty list and will cause the camp to reset almost instantly
                        i = i + 1
                        if i > listlength then break end
                        temp = LoadUnitHandle(NPClist, otherID, Pos2Key(i))
                        SaveUnitHandle(NPClist, ID, Pos2Key(i), temp)
                        SaveReal(NPClist, ID, Pos2Key(i)+1, 0)
                        SaveInteger(PUlist, GetHandleId(temp), ID, i) --assign the threat position to the player unit's reference list
                        GroupAddUnit(LoadGroupHandle(PUlist, GetHandleId(temp), 0), u) --add the unit to the player unit's threat group
                        SaveInteger(PUlist, GetHandleId(temp), 1, LoadInteger(PUlist, GetHandleId(temp), 1)+1) --increase group size count
                    end
                    SaveInteger(NPClist, ID, 0, 1) --set unit status: combat
                    GroupAddUnit(NPCgroup, u) --add the unit to incombat group
                    temp = nil
                end
            end
        else --no unit in range has a camp group assigned, so create a new one
            g = CreateGroup()
        end
        GroupAddUnit(g, u)
        SaveGroupHandle(NPClist, ID, 4, g) --camp group
        t = nil
        g = nil
        other = nil
    end

    ---@param u unit
    function ZTS_RemoveThreatUnit(u)
        local ID         = GetHandleId(u) ---@type integer 
        local OtherID ---@type integer 
        local g       = nil ---@type group 
        local key         = 10 ---@type integer 
        if not HaveSavedInteger(NPClist, ID, 0) then --unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end
        if LoadInteger(NPClist, ID, 0) > 1 then --unit status is: returning
            IssueImmediateOrder(u, "stop")
            SetUnitInvulnerable(u, false)
            if IsUnitPaused(u) then
                PauseUnit(u, false)
            end
        end
        
        while true do --remove the entry in the player unit's position list and list group and decrease list group count
            if HaveSavedHandle(NPClist, ID, key) then
                OtherID = GetHandleId(LoadUnitHandle(NPClist, ID, key))
                RemoveSavedInteger(PUlist, OtherID, ID)
                GroupRemoveUnit(LoadGroupHandle(PUlist, OtherID, 0), u)
                SaveInteger(PUlist, OtherID, 1, LoadInteger(PUlist, OtherID, 1)-1)
                key = key+2
            else --last entry reached
                break
            end
        end
        
        g = LoadGroupHandle(NPClist, ID, 4)
        GroupRemoveUnit(g, u)
        if FirstOfGroup(g) == nil then --camp group is empty
            DestroyGroup(g)
        end
        DestroyTrigger(LoadTriggerHandle(NPClist, ID, 6))
        FlushChildHashtable(NPClist, ID)
        if IsUnitInGroup(u, NPCgroup) then
            GroupRemoveUnit(NPCgroup, u) --remove unit from incombat group
        end
        g = nil
    end

    local function RemovePlayerUnitEntries()
        local ID         = GetHandleId(TSub) ---@type integer 
        local OtherID         = GetHandleId(GetEnumUnit()) ---@type integer 
        local key         = Pos2Key(LoadInteger(PUlist, ID, OtherID)) ---@type integer 
        while true do --remove the entry in u's threat list and fill the gap
            if HaveSavedHandle(NPClist, OtherID, key+2) then --move up next entry
                SaveUnitHandle(NPClist, OtherID, key, LoadUnitHandle(NPClist, OtherID, key+2))
                SaveReal(NPClist, OtherID, key+1, LoadReal(NPClist, OtherID, key+3))
                SaveInteger(PUlist, GetHandleId(LoadUnitHandle(NPClist, OtherID, key)), OtherID, Key2Pos(key)) --update position in player unit list
                key = key+2
            else --last entry reached
                RemoveSavedHandle(NPClist, OtherID, key)
                RemoveSavedReal(NPClist, OtherID, key+1)
                SaveInteger(NPClist, OtherID, 5, Key2Pos(key-2)) --decrease list length
                break
            end
        end
    end

    ---@param u unit
    function ZTS_RemovePlayerUnit(u)
        local ID         = GetHandleId(u) ---@type integer 
        if not HaveSavedHandle(PUlist, ID, 0) then --unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end
        TSub = u
        ForGroup(LoadGroupHandle(PUlist, ID, 0), RemovePlayerUnitEntries)
        
        DestroyGroup(LoadGroupHandle(PUlist, ID, 0))
        FlushChildHashtable(PUlist, ID)
    end

    local function HealThreatSub()
        ZTS_ModifyThreat(THealer, GetEnumUnit(), THealthreat, TBool)
    end

    ---@param pu unit
    ---@param ally unit
    ---@param amount number
    ---@param add boolean
    ---@param divide boolean
    function ZTS_ApplyHealThreat(pu, ally, amount, add, divide)
        local puID         = GetHandleId(pu) ---@type integer 
        local allyID         = GetHandleId(ally) ---@type integer 
        if not (HaveSavedHandle(PUlist, puID, 0) and HaveSavedHandle(PUlist, allyID, 0)) then --units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(ally, UNIT_TYPE_DEAD) then --units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(ally) == 0 then --null units
            return
        end
        if divide and LoadInteger(PUlist, allyID, 1) > 1 then
            THealthreat = amount/LoadInteger(PUlist, allyID, 1)
        else
            THealthreat = amount
        end
        TBool = add
        THealer = pu
        ForGroup(LoadGroupHandle(PUlist, allyID, 0), HealThreatSub)
    end

    local function CampCommand()
        local u      = GetEnumUnit() ---@type unit 
        local ID         = GetHandleId(u) ---@type integer 
        local OtherID ---@type integer 
        local status         = LoadInteger(NPClist, ID, 0) ---@type integer 
        local key         = 10 ---@type integer 
        if status == 1 then
            SaveInteger(NPClist, GetHandleId(u), 0, 2) --set status: returning
            while true do --remove the entry in the player unit's position list and list group and decrease list group count
                if HaveSavedHandle(NPClist, ID, key) then
                    OtherID = GetHandleId(LoadUnitHandle(NPClist, ID, key))
                    RemoveSavedInteger(PUlist, OtherID, ID)
                    GroupRemoveUnit(LoadGroupHandle(PUlist, OtherID, 0), u)
                    SaveInteger(PUlist, OtherID, 1, LoadInteger(PUlist, OtherID, 1)-1)
                    RemoveSavedHandle(NPClist, ID, key)
                    RemoveSavedReal(NPClist, ID, key+1)
                    key = key+2
                else --last entry reached
                    break
                end
            end
            SaveInteger(NPClist, ID, 5, 0) --also set list length to zero
            IssueImmediateOrder(u, "stop") --cancels even spellcast with casting time
            IssuePointOrder(u, "move", LoadReal(NPClist, ID, 1), LoadReal(NPClist, ID, 2))
            SaveReal(NPClist, ID, 3, TimeToPort)
            SetUnitInvulnerable(u, true)
            if HealUnitsOnReturn then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            end
        elseif status == 3 then
            SaveInteger(NPClist, GetHandleId(u), 0, 0) --set status: out of combat
            SaveReal(NPClist, GetHandleId(u), 3, 0.) --reset incombat and return timer
            SetUnitInvulnerable(u, false)
            if HealUnitsOnReturn then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            end
            GroupRemoveUnit(NPCgroup, u) --remove from combat group
            
            PauseUnit(u, false)
            IssueImmediateOrder(u, "stop")
        end
        u = nil
    end

    local function CampStatus()
        if LoadInteger(NPClist, GetHandleId(GetEnumUnit()), 0) ~= 3 then
            TBool = false
        end
    end

    local function IssueOrder()
        local npc      = GetEnumUnit() ---@type unit 
        local npcID         = GetHandleId(npc) ---@type integer 
        local status         = LoadInteger(NPClist, npcID, 0) ---@type integer 
        local i         = 0 ---@type integer 
        local b         = true ---@type boolean 
        local target      = nil ---@type unit 
        if status == 1 then --unit in combat
            SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) + UpdateIntervall) --increase the combat timer
            if IsUnitInRangeXY(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), ReturnRange) and HaveSavedHandle(NPClist, npcID, 10) then
                target = LoadUnitHandle(NPClist, npcID, 10)
                if IsUnitInRangeXY(target, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), OrderReturnRange) then
                    if GetUnitCurrentOrder(npc) == 851983 or GetUnitCurrentOrder(npc) == 0 or GetUnitCurrentOrder(npc) == 851971 then --attack order or no order or smart order
                        EventBool = true
                        IssueTargetOrder(npc, "smart", target)
                        EventBool = false
                    end
                else --target of unit to far away from camp position
                    ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampCommand) --set camp returning
                end
            else --unit left return range or killed all player units
                ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampCommand) --set camp returning
            end
        elseif status == 2 then --unit is returning
            if LoadReal(NPClist, npcID, 3) > 0 then
                if not IsUnitInRangeXY(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2), 35) then
                    IssuePointOrder(npc, "move", LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2))
                    SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) - UpdateIntervall)
                    SetUnitInvulnerable(npc, true)
                else --unit within close range to camp position
                    if GetUnitCurrentOrder(npc) == 851986 then --move order
                        SaveReal(NPClist, npcID, 3, LoadReal(NPClist, npcID, 3) - UpdateIntervall)
                        SetUnitInvulnerable(npc, true)
                    else --Something blocks the exact spot or the unit has arrived
                        SaveInteger(NPClist, npcID, 0, 3) --set status: returned
                        TBool = true
                        ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampStatus)
                        if TBool then --all units in camp have status: returned to camp position
                            ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampCommand) --set camp ooc
                        else
                            PauseUnit(npc, true) --make sure it doesn't move or attack when invulnerable
                        end
                    end
                end
            else --counter expired - perform instant teleport
                SetUnitPosition(npc, LoadReal(NPClist, npcID, 1), LoadReal(NPClist, npcID, 2))
                SaveInteger(NPClist, npcID, 0, 3) --set status: returned
                TBool = true
                ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampStatus)
                if TBool then --all units in camp have status: returned to camp position
                    ForGroup(LoadGroupHandle(NPClist, npcID, 4), CampCommand) --set camp ooc
                else
                    PauseUnit(npc, true) --make sure it doesn't move or attack when invulnerable
                end
            end
        end
        npc = nil
        target = nil
    end

    local function Update()
        ForGroup(NPCgroup, IssueOrder) --issues orders to all units in combat
    end

    ---@return boolean
    local function rettrue()
        return true
    end

    ---@param u unit
    local function RemovedUnitFound(u)
        if HaveSavedInteger(NPClist, GetHandleId(u), 0) then
            ZTS_RemoveThreatUnit(u)
        end
        if HaveSavedHandle(PUlist, GetHandleId(u), 0) then
            ZTS_RemovePlayerUnit(u)
        end
    end

    AddHook("RemoveUnit", RemovedUnitFound)

    local function OnDeath()
        if HaveSavedInteger(NPClist, GetHandleId(GetTriggerUnit()), 0) then
            ZTS_RemoveThreatUnit(GetTriggerUnit())
        end
        if HaveSavedHandle(PUlist, GetHandleId(GetTriggerUnit()), 0) then
            ZTS_RemovePlayerUnit(GetTriggerUnit())
        end
    end

    local t         = CreateTrigger() ---@type trigger 
    local index         = 0 ---@type integer 
    BOOLEXPR=Condition(rettrue) --prevent booleanexpressions from leaking
    TimerStart(Updater, UpdateIntervall, true, Update)
    repeat
        TriggerRegisterPlayerUnitEvent(t, Player(index), EVENT_PLAYER_UNIT_DEATH, BOOLEXPR)
        index = index + 1
    until index == bj_MAX_PLAYER_SLOTS
    TriggerAddAction(t, OnDeath)

end)
--Conversion by vJass2Lua v0.A.2.3
if Debug then Debug.endFile() end