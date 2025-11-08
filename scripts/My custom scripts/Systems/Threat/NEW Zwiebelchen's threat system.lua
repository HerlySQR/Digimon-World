if Debug then Debug.beginFile("NEW Zwiebelchen's threat system") end
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
--       ZTS_ModifyThreat(GetEventDamageSource(), GetTriggerUnit(), GetEventDamage(), true)
--      The function does all required checks on its own. There is no need to run something else.
--
-- 3. How to use it:
--
--  3.1. Core functions
--
--      ZTS_AddThreatUnit(unit npc, boolean includeCombatCamps) returns nothing:
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
--      ZTS_AddPlayerUnit(unit pu) returns nothing:
--
--          Units add by this way will generate threat on ThreatUnits.
--          If the unit is not registered as a PlayerUnit, it will not be attacked by ThreatUnits.
--
--      ZTS_RemoveThreatUnit(unit npc) returns nothing:
--
--          Removes a ThreatUnit from the system. The unit will no longer be controlled by the threat system.
--          Also, the threat list for that unit will be cleared.
--          Dead or removed units will automaticly be cleared. You need to add them again after revival/recreation.
--
--      ZTS_RemovePlayerUnit(unit pu) returns nothing:
--
--          Removes a player unit from the system. The unit will no longer generate threat on ThreatUnits.
--          The unit will also be instantly removed from all threat lists.
--          If the unit was the last unit in combat with the same hostile camp, all units
--          of that camp group will immediately return to their camp positions.
--          You can use this, followed by AddPlayerUnit to that unit out of combat and reset all threat.
--          Dead or removed units will automaticly be cleared. You need to add them again after revival/recreation.
--
--      ZTS_ModifyThreat(unit pu, unit npc, number amount, boolean add) returns nothing:
--
--          Adds, sets or substracts threat from npc's threat list caused by pu.
--          Set 'add' to true to add or substract amount from the current value.
--          Set 'add' to false to set the new threat value to amount.
--          To reduce threat, use negative amount values with add == true.
--          Remember: If a unit has 0 threat, it is still considered in-combat -
--          this also means, that adding "0" to the units threat causes them to attack!
--
--      ZTS_ApplyHealThreat(unit pu, unit ally, number amount, boolean add, boolean divide) returns nothing:
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
--      ZTS_GetCombatState(unit U) returns boolean:
--
--          Returns the combat state of a player or npc unit.
--          Returns true, if the unit is registered and in combat.
--          Returns false, if the unit is not registered or out of combat.
--
--      ZTS_GetCombatTime(unit NPC) returns boolean:
--
--          Returns the incombat time of the npc.
--          Does not work for player units.
--          Returns "0" if the unit is not in combat or currently returning to camp position.
--
--      ZTS_GetThreatUnitPosition(unit NPC, unit PU) returns integer:
--
--          Returns the position of unit PU in unit NPC's threat list
--          Returns "0" if the unit was not found, NPC does not feature a threat list or in case of invalid input data
--
--      ZTS_GetThreatUnitAmount(unit NPC, unit PU) returns number:
--
--          Returns the amount of threat unit PU has in unit NPC's threat list
--          Returns "0" if the unit was not found, NPC does not feature a threat list or in case of invalid input data
--
--      ZTS_GetThreatSlotUnit(unit NPC, integer position) returns unit:
--
--          Returns the unit in threat-slot position
--          Returns null if the NPC does not feature a threat list, the number is too large
--          or in case of invalid input data
--
--      ZTS_GetThreatSlotAmount(unit NPC, integer position) returns number:
--
--          Returns the threat amount of the threat-slot position
--          Returns "0" if the NPC does not feature a threat list, the number is too large
--          or in case of invalid input data
--
--      ZTS_GetAttackers(unit U) returns group:
--
--          If used on a ThreatUnit, this returns a group of all units in threat list;
--          if used on a PlayerUnit, this returns a group of all units aggroed.
--          Returns an empty group, in case of invalid input data or empty lists.
--
--  
--  3.3. Advanced User features
--
--      ZTS_IsEvent() returns boolean
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

    local UpdateIntervall = 0.5 -- The intervall for issueing orders and performing AttackRange check. recommended value: 0.5
    local HelpRange = 400 -- The range between units considered being in the same camp. If a unit of the same camp gets attacked, all others will help.
                                          -- Set CallForHelp to something lower in Gameplay Constants.
    local OrderReturnRange = 3500 -- The range the unit's target can be away from the original camping position, before being ordered to return.
    local ReturnRange = 1200 -- The range the unit can move away from the original camping position, before being ordered to return.
    local DungeonRange = 1600 -- The range the unit can move away from the original camping position, before being ordered to return (Dungeon units)
    local TimeToPort = 10 -- This timer expires once a unit tries to return to its camping position.
                                          -- If it reaches 0 before reaching the camp position, the unit will be teleported immediately.
    local HealUnitsOnReturn = true -- If this is true, returning units will be healed to 100% health.

    --       Do not edit below here!
    -- --------------------------------------------------------------------------------------------------------   
    local BOOLEXPR_TRUE = nil
    local Updater = CreateTimer()
    local NPCgroup = CreateGroup()
    local NPClist = MDTable.create(2)
    local PUlist = MDTable.create(2)
    
    -- temporary variables for enumerations and forgroups
    local TSub = nil
    local TMod = nil
    local TGroupSub = CreateGroup()
    local THealer = nil
    local THealthreat = 0
    local TBool = false
    local TState = 0
    local TGroupGet = nil
    local EventBool = false
    local AIGroup = CreateGroup()
    local AIPlayer = nil
    ZTS_IssueNoAttackOrder = false
    ZTS_IssueOrderUnit = nil
    local RangeGroup = CreateGroup()
    local RangeGroupTest = nil

    function ZTS_IsEvent()
        if EventBool then
            EventBool = false
            return true
        end
        return false
    end

    ---@param position integer
    ---@return integer
    local function Pos2Key(position) -- converts threat list position into hashtable childkey
        return 8+(position*2)
    end

    ---@param key integer
    ---@return integer
    local function Key2Pos(key) -- converts hashtable childkey into threat list position
        return (key-8)/2
    end

    ---@param u unit
    ---@return boolean
    function ZTS_GetCombatState(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return false
        elseif NPClist[u][0] then -- unit is npc
            return NPClist[u][0] > 0
        elseif PUlist[u][0] then -- unit is player unit
            return PUlist[u][1] > 0
        end
        return false
    end

    ---@param u unit
    ---@return number
    function ZTS_GetCombatTime(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return 0.
        elseif NPClist[u][0] then -- unit is npc
            if NPClist[u][0] == 1 then -- only return a time when the unit is in combat
                return NPClist[u][3]
            end
        end
        return 0.
    end

    ---@param npc unit
    ---@param pu unit
    ---@return integer
    function ZTS_GetThreatUnitPosition(npc, pu)
        if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then -- units null
            return 0
        elseif not (NPClist[npc][0] and PUlist[pu][0]) then -- units not added
            return 0
        elseif PUlist[pu][npc] then
            return PUlist[pu][npc]
        end
        return 0
    end

    ---@param npc unit
    ---@param pu unit
    ---@return integer
    function ZTS_GetThreatUnitAmount(npc, pu)
        if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then -- units null
            return 0.
        elseif not (NPClist[npc][0] and PUlist[pu][0]) then -- units not added
            return 0.
        elseif PUlist[pu][npc] then
            return NPClist[npc][Pos2Key(PUlist[pu][npc])+1]
        end
        return 0.
    end

    ---@param npc unit
    ---@param position integer
    ---@return unit?
    function ZTS_GetThreatSlotUnit(npc, position)
        if GetUnitTypeId(npc) == 0 or position <= 0 then --unit null or invalid slot
            return nil
        elseif not NPClist[npc][0] then -- unit not added
            return nil
        elseif NPClist[npc][Pos2Key(position)] then
            return NPClist[npc][Pos2Key(position)]
        end
        return nil
    end

    ---@param npc unit
    ---@param position integer
    ---@return integer
    function ZTS_GetThreatSlotAmount(npc, position)
        if GetUnitTypeId(npc) == 0 or position <= 0 then --unit null or invalid slot
            return 0.
        elseif not NPClist[npc][0] then -- unit not added
            return 0.
        elseif NPClist[npc][Pos2Key(position)+1] then
            return NPClist[npc][Pos2Key(position)+1]
        end
        return 0.
    end

    local function GetAttackersSub()
        GroupAddUnit(TGroupGet, GetEnumUnit())
    end

    ---@param u unit
    ---@return group
    function ZTS_GetAttackers(u)
        local g = CreateGroup()
        local key = 10
        local max
        if GetUnitTypeId(u) == 0 then
            return g
        end
        if NPClist[u][0] then -- unit is npc
            max = Pos2Key(NPClist[u][5])
            while true do
                if key > max then break end
                GroupAddUnit(g, NPClist[u][key])
                key = key+2
            end
        elseif PUlist[u][0] then -- unit is player unit
            TGroupGet = g
            ForGroup(PUlist[u][0], GetAttackersSub)
            g = TGroupGet
            TGroupGet = nil
        end
        return g
    end

    ---@param npcID unit
    ---@param key1 integer
    ---@param key2 integer
    local function Swap(npcID, key1, key2)
        local u = NPClist[npcID][key1]
        local r = NPClist[npcID][key1+1]
        NPClist[npcID][key1] = NPClist[npcID][key2]
        NPClist[npcID][key1+1] = NPClist[npcID][key2+1]
        PUlist[NPClist[npcID][key1]][npcID] = Key2Pos(key1) -- update position list
        NPClist[npcID][key2] = u
        NPClist[npcID][key2+1] = r
        PUlist[u][npcID] = Key2Pos(key2) -- update position list
        u = nil
    end

    local function CampThreat()
        local npcID = GetEnumUnit()
        local puID = TMod
        local key
        local listlength
        if GetEnumUnit() == TSub then
            return
        elseif PUlist[puID][npcID] then -- original pu unit already listed in EnumUnit's threat list
            return
        elseif NPClist[npcID][0] > 1 or IsUnitType(GetEnumUnit(), UNIT_TYPE_DEAD) then -- do not add threat to dead or units that are status: returning
            return
        end
        listlength = NPClist[npcID][5] + 1
        NPClist[npcID][5] = listlength -- add to list length of EnumUnit
        key = Pos2Key(listlength)
        NPClist[npcID][key] = TMod -- add original pu unit to end of EnumUnit's threat list
        NPClist[npcID][key+1] = 0
        PUlist[puID][npcID] = listlength -- add EnumUnit to slot list
        GroupAddUnit(PUlist[puID][0], GetEnumUnit()) -- add EnumUnit to slot list group
        PUlist[puID][1] = PUlist[puID][1] + 1 -- increase group size count
        if NPClist[npcID][0] == 0 then
            NPClist[npcID][0] = 1 -- set unit status: combat
            GroupAddUnit(NPCgroup, GetEnumUnit()) -- add the unit to incombat group
        end
    end

    ---@param pu unit
    ---@param npc unit
    ---@param amount number
    ---@param add true
    function ZTS_ModifyThreat(pu, npc, amount, add)
        local npcID = npc
        local puID = pu
        local key
        local listlength
        local i = 0
        local newamount
        local oldamount = 0
        local b = false
        if not (NPClist[npcID][0] and PUlist[puID][0]) then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(npc, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(npc) == 0 then -- null units
            return
        elseif NPClist[npcID][0] > 1 then -- do not add threat to units that are status: returning
            return
        end
        if not PUlist[puID][npcID] then -- pu not listed in npc's threat list
            listlength = NPClist[npcID][5] + 1
            NPClist[npcID][5] = listlength -- add to list length of npc
            key = Pos2Key(listlength)
            NPClist[npcID][key] = pu -- add pu to end of npc's threat list
            PUlist[puID][npcID] = listlength -- add npc to slot list
            GroupAddUnit(PUlist[puID][0], npc) -- add npc to slot list group
            PUlist[puID][1] = PUlist[puID][1] + 1 -- increase group size count
            if NPClist[npcID][0] == 0 then
                NPClist[npcID][0] = 1 -- set unit status: combat
                GroupAddUnit(NPCgroup, npc) -- add the unit to incombat group
            end
            b = true
        else
            key = Pos2Key(PUlist[puID][npcID])
            oldamount = NPClist[npcID][key+1]
        end
        if add then
            newamount = oldamount+amount
        else
            newamount = amount
        end
        if newamount < 0 then
            newamount = 0
        end
        NPClist[npcID][key+1] = newamount
        if newamount > oldamount then -- check lower keys
            while true do
                if NPClist[npcID][key-1-i] then
                    if NPClist[npcID][key-1-i] < newamount then -- lower key amount is smaller
                        Swap(npcID, key-2-i, key-i)
                    else
                        break
                    end
                    i = i + 2
                else
                    break
                end
            end
        elseif newamount < oldamount then -- check higher keys
            while true do
                if NPClist[npcID][key+3+i] then
                    if NPClist[npcID][key+3+i] > newamount then -- upper key amount is larger
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
        if b then -- set all units of the same camp to status: combat and apply 0 threat from pu to them
            TSub = npc
            TMod = pu
            ForGroup(NPClist[npcID][4], CampThreat)
        end
    end

    ---@return boolean
    local function AcquireTarget()
        local npc = GetTriggerUnit()
        local pu
        if GetEventTargetUnit() ~= nil then
            pu = GetEventTargetUnit()
        else
            pu = GetOrderTargetUnit()
        end
        if IsUnitEnemy(pu, GetOwningPlayer(npc)) then
            if NPClist[npc][0] == 0 then -- pull out of combat units only
                ZTS_ModifyThreat(pu, npc, 0, true)
            end
        end
        pu = nil
        npc = nil
        return false
    end

    local function FilterUnitsWithCampGroup() -- only units that are out of combat
        return NPClist[GetFilterUnit()][4] and IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and NPClist[GetFilterUnit()][0] <= TState
    end

    ---@param u unit
    ---@param includeCombatCamps boolean
    function ZTS_AddThreatUnit(u, includeCombatCamps)
        local ID = u
        local g = nil
        local t = nil
        local other = nil
        local otherID = 0
        local temp = nil
        local i = 0
        local listlength = 0
        if NPClist[ID][0] or PUlist[ID][0] then -- unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return
        end

        UnitAddAbility(u, FourCC('Aeth')) -- disable collision

        NPClist[ID][0] = 0 -- status
        NPClist[ID][1] = GetUnitX(u) -- return X
        NPClist[ID][2] = GetUnitY(u) -- return Y
        NPClist[ID][3] = 0 -- combat time and return timer
        NPClist[ID][5] = 0 -- list length
        t = CreateTrigger()
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ACQUIRED_TARGET)
        TriggerAddCondition(t, Condition(AcquireTarget))
        NPClist[ID][6] = t -- acquire target event trigger
        if includeCombatCamps then
            TState = 1
        else
            TState = 0
        end
        GroupEnumUnitsInRange(TGroupSub, GetUnitX(u), GetUnitY(u), HelpRange, Condition(FilterUnitsWithCampGroup))
        other = FirstOfGroup(TGroupSub)
        if other ~= nil then -- valid unit in range
            otherID = other
            g = NPClist[otherID][4]
            if includeCombatCamps then
                -- don't forget to inherit the camp unit's threat list...
                if NPClist[otherID][0] == 1 then -- ...but only if filtered unit is actually infight
                    listlength = NPClist[otherID][5]
                    NPClist[otherID][5] = listlength -- copy list length
                    while true do -- copy all list entries as the newly added unit has an empty list and will cause the camp to reset almost instantly
                        i = i + 1
                        if i > listlength then break end
                        temp = NPClist[otherID][Pos2Key(i)]
                        NPClist[ID][Pos2Key(i)] = temp
                        NPClist[ID][Pos2Key(i)+1] = 0
                        PUlist[temp][ID] = i -- assign the threat position to the player unit's reference list
                        GroupAddUnit(PUlist[temp][0], u) -- add the unit to the player unit's threat group
                        PUlist[temp][1] = PUlist[temp][1] + 1 -- increase group size count
                    end
                    NPClist[ID][0] = 1 -- set unit status: combat
                    GroupAddUnit(NPCgroup, u) -- add the unit to incombat group
                    temp = nil
                end
            end
        else -- no unit in range has a camp group assigned (or the unit is patrolling), so create a new one
            g = CreateGroup()
        end
        GroupAddUnit(g, u)
        NPClist[ID][4] = g -- camp group
        t = nil
        g = nil
        other = nil
    end

    ---@param u unit
    ---@param x number
    ---@param y number
    function ZTS_ChangeReturnPos(u, x, y)
        local ID = GetHandleId(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return
        end
        if NPClist[ID][0] then -- unit in list
            NPClist[ID][1] = x
            NPClist[ID][2] = y
        end
    end

    ---@param u unit
    function ZTS_AddPlayerUnit(u)
        local ID = GetHandleId(u)
        if NPClist[ID][0] or PUlist[ID][0] then -- unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return
        end
        PUlist[ID][0] = CreateGroup() -- slot list group
        PUlist[ID][1] = 0 -- list group count
    end

    ---@param u unit
    function ZTS_RemoveThreatUnit(u)
        local ID = u
        local OtherID
        local g = nil
        local key = 10
        if not NPClist[ID][0] then -- unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end
        if NPClist[ID][0] > 1 then -- unit status is: returning
            IssueImmediateOrder(u, "stop")
            UnitRemoveAbility(u, FourCC('Avul'))
        end

        while true do -- remove the entry in the player unit's position list and list group and decrease list group count
            if NPClist[ID][key] then
                OtherID = NPClist[ID][key]
                PUlist[OtherID][ID] = nil
                GroupRemoveUnit(PUlist[OtherID][0], u)
                PUlist[OtherID][1] = PUlist[OtherID][1] - 1
                key = key+2
            else -- last entry reached
                break
            end
        end

        g = NPClist[ID][4]
        GroupRemoveUnit(g, u)
        if FirstOfGroup(g) == nil then -- camp group is empty
            DestroyGroup(g)
        end
        DestroyTrigger(NPClist[ID][6])
        NPClist[ID] = {}
        if IsUnitInGroup(u, NPCgroup) then
            GroupRemoveUnit(NPCgroup, u) -- remove unit from incombat group
        end
        g = nil
    end

    local function RemovePlayerUnitEntries()
        local ID = TSub
        local OtherID = GetEnumUnit()
        local key = Pos2Key(PUlist[ID][OtherID])
        while true do -- remove the entry in u's threat list and fill the gap
            if NPClist[OtherID][key+2] then -- move up next entry
                NPClist[OtherID][key] = NPClist[OtherID][key+2]
                NPClist[OtherID][key+1] = NPClist[OtherID][key+3]
                PUlist[NPClist[OtherID][key]][OtherID] = Key2Pos(key) -- update position in player unit list
                key = key+2
            else -- last entry reached
                NPClist[OtherID][key] = nil
                NPClist[OtherID][key+1] = nil
                NPClist[OtherID][5] = Key2Pos(key-2) -- decrease list length
                break
            end
        end
    end

    function ZTS_RemovePlayerUnit(u)
        local ID = u
        if not PUlist[ID][0] then -- unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end
        TSub = u
        ForGroup(PUlist[ID][0], RemovePlayerUnitEntries)

        DestroyGroup(PUlist[ID][0])
        DestroyTrigger(PUlist[ID][2])
        PUlist[ID] = {}
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
        local puID = pu
        local allyID = ally
        if not (PUlist[puID][0] and PUlist[allyID][0]) then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(ally, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(ally) == 0 then -- null units
            return
        end
        if divide and PUlist[allyID][1] > 1 then
            THealthreat = amount/PUlist[allyID][1]
        else
            THealthreat = amount
        end
        TBool = add
        THealer = pu
        ForGroup(PUlist[allyID][0], HealThreatSub)
    end

    local function CampCommand()
        local u = GetEnumUnit()
        local t = nil
        local ID = u
        local OtherID
        local status = NPClist[ID][0]
        local key = 10
        if status == 1 then
            NPClist[u][0] = 2 -- set status: returning
            while true do -- remove the entry in the player unit's position list and list group and decrease list group count
                if NPClist[ID][key] then
                    OtherID = NPClist[ID][key]
                    PUlist[OtherID][ID] = nil
                    GroupRemoveUnit(PUlist[OtherID][0], u)
                    PUlist[OtherID][1] = PUlist[OtherID][1] - 1
                    NPClist[ID][key] = nil
                    NPClist[ID][key+1] = nil
                    key = key+2
                else -- last entry reached
                    break
                end
            end
            NPClist[ID][5] = 0 -- also set list length to zero
            IssueImmediateOrder(u, "stop") -- cancels even spellcast with casting time
            IssuePointOrder(u, "move", NPClist[ID][1], NPClist[ID][2])
            NPClist[ID][3] = TimeToPort
            UnitAddAbility(u, FourCC('Avul'))
            if HealUnitsOnReturn then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            end
        elseif status == 3 then
            NPClist[u][0] = 0 -- set status: out of combat
            NPClist[u][3] = 0. -- reset incombat and return timer
            UnitRemoveAbility(u, FourCC('Avul'))
            if HealUnitsOnReturn then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
                UnitResetCooldown(u)
            end
            GroupRemoveUnit(NPCgroup, u) -- remove from combat group
            IssueImmediateOrder(u, "stop")
        end
        u = nil
    end

    local function CampStatus()
        if NPClist[GetEnumUnit()][0] ~= 3 then
            TBool = false
        end
    end

    ---@param U unit
    ---@return unit?
    function ZTS_GetWoundedAlly(U)
        local G = CreateGroup()
        local U2 = nil
        local AITargetUnit = nil
        GroupEnumUnitsInRange(G, GetUnitX(U), GetUnitY(U), 700, BOOLEXPR_TRUE)
        while true do
            U2 = FirstOfGroup(G)
            if U2 == nil then break end
            if IsUnitAlly(U2, GetOwningPlayer(U)) and GetOwningPlayer(U2) ~= Player(PLAYER_NEUTRAL_PASSIVE) then
                if IsUnitType(U2, UNIT_TYPE_DEAD) == false then
                    if GetUnitTypeId(AITargetUnit) == 0 then
                        AITargetUnit = U2
                    else
                        if (GetUnitState(AITargetUnit, UNIT_STATE_LIFE) / GetUnitState(AITargetUnit, UNIT_STATE_MAX_LIFE)) > (GetUnitState(U2, UNIT_STATE_LIFE) / GetUnitState(U2, UNIT_STATE_MAX_LIFE)) then
                            AITargetUnit = U2
                        end
                    end
                end
            end
            GroupRemoveUnit(G, U2)
        end
        DestroyGroup(G)
        G = nil
        U2 = nil
        return AITargetUnit
    end

    ---@return boolean
    local function FilterEnemyAliveCombatUnits()
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(), AIPlayer) and ZTS_GetCombatState(GetFilterUnit()) and GetUnitAbilityLevel(GetFilterUnit(), FourCC('Aloc')) <= 0
    end

    ---@return boolean
    local function FilterEnemyAliveCombatHeroes()
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) == false and IsUnitEnemy(GetFilterUnit(), AIPlayer) and ZTS_GetCombatState(GetFilterUnit()) and IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) and GetUnitAbilityLevel(GetFilterUnit(), FourCC('Aloc')) <= 0
    end

    ---@param U unit
    ---@param B boolean
    ---@param O1 string
    ---@param T1 integer
    ---@param O2 string
    ---@param T2 integer
    ---@param O3 string
    ---@param T3 integer
    ---@param O4 string
    ---@param T4 integer
    ---@return boolean
    function ZTS_SimpleAIOrder(U, B, O1, T1, O2, T2, O3, T3, O4, T4)
        local target = nil
        local i = 0
        local TempTarget = T1
        local TempOrder = O1

        if B == false then
            while true do
                i = i + 1
                if i > 4 or B == true then break end
                if i == 2 then
                    TempOrder = O2
                    TempTarget = T2
                elseif i == 3 then
                    TempOrder = O3
                    TempTarget = T3
                elseif i == 4 then
                    TempOrder = O4
                    TempTarget = T4
                end
                if TempOrder ~= "" then
                    if TempTarget <= -2 or TempTarget >= 2 then
                        TempTarget = 1 -- no random orders for enslaved creeps
                    end
                    if TempTarget == -1 then
                        B = IssueImmediateOrder(U, TempOrder)
                    elseif TempTarget == 0 then
                        B = IssueTargetOrder(U, TempOrder, U)
                    elseif TempTarget == 1 then
                        target = ZTS_GetThreatSlotUnit(U, 1)
                        B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        end
                    elseif TempTarget == 2 then
                        target = ZTS_GetThreatSlotUnit(U, 2)
                        if target ~= nil and GetUnitAbilityLevel(target, FourCC('Aloc')) <= 0 then
                            B = IssueTargetOrder(U, TempOrder, target)
                            if B == false then
                                B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                            end
                        else
                            target = ZTS_GetThreatSlotUnit(U, 1)
                            B = IssueTargetOrder(U, TempOrder, target)
                            if B == false then
                                B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                            end
                        end
                    elseif TempTarget == 3 then
                        target = ZTS_GetThreatSlotUnit(U, 3)
                        if target ~= nil and GetUnitAbilityLevel(target, FourCC('Aloc')) <= 0 then
                            B = IssueTargetOrder(U, TempOrder, target)
                            if B == false then
                                B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                            end
                        else
                            target = ZTS_GetThreatSlotUnit(U, 2)
                            if target ~= nil and GetUnitAbilityLevel(target, FourCC('Aloc')) <= 0 then
                                B = IssueTargetOrder(U, TempOrder, target)
                                if B == false then
                                    B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                                end
                            else
                                target = ZTS_GetThreatSlotUnit(U, 1)
                                B = IssueTargetOrder(U, TempOrder, target)
                                if B == false then
                                    B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                                end
                            end
                        end
                    elseif TempTarget == -2 then -- Random unit in range
                        AIPlayer = GetOwningPlayer(U)
                        GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(FilterEnemyAliveCombatUnits))
                        target = GroupPickRandomUnit(AIGroup)
                        B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        end
                    elseif TempTarget == -3 then -- Random unit except first in aggro
                        AIPlayer = GetOwningPlayer(U)
                        GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(FilterEnemyAliveCombatUnits))
                        GroupRemoveUnit(AIGroup, ZTS_GetThreatSlotUnit(U, 1))
                        target = GroupPickRandomUnit(AIGroup)
                        if target == nil then
                            target = ZTS_GetThreatSlotUnit(U, 1)
                        end
                        B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        end
                    else -- Random hero unit
                        AIPlayer = GetOwningPlayer(U)
                        GroupEnumUnitsInRange(AIGroup, GetUnitX(U), GetUnitY(U), 1000, Condition(FilterEnemyAliveCombatHeroes))
                        target = GroupPickRandomUnit(AIGroup)
                        B = IssueTargetOrder(U, TempOrder, target)
                        if B == false then
                            B = IssuePointOrder(U, TempOrder, GetUnitX(target), GetUnitY(target))
                        end
                    end
                else
                    target = nil
                    return B
                end
            end
        end
        target = nil
        return B
    end

    ---@param u unit
    ---@param target unit
    local function IssueSpellOrder(u, target)
        local g
        local temp
        local r
        local x
        local y
        IssueOrderUnit = u
        IssueNoAttackOrder = false
        if not IssueNoAttackOrder then
            if IsUnitInRange(target, u, 100) and not IsUnitType(u, UNIT_TYPE_SAPPER) then -- reposition only non-boss melees
                g = CreateGroup()
                GroupEnumUnitsInRange(g, GetUnitX(u), GetUnitY(u), 48, BOOLEXPR_TRUE)
                while true do
                    temp = FirstOfGroup(g)
                    if temp == nil then break end
                    if temp ~= u and IsUnitType(temp, UNIT_TYPE_DEAD) == false and IsUnitAlly(temp, GetOwningPlayer(u)) and GetUnitCurrentOrder(temp) ~= 851986 then
                        r = Atan2(GetUnitY(u) - GetUnitY(target), GetUnitX(u) - GetUnitX(target)) + GetRandomReal(0, 3)
                        x = GetUnitX(target)+Cos(r)*60
                        y = GetUnitY(target)+Sin(r)*60
                        IssueNoAttackOrder = IssuePointOrderById(u, 851986, x, y)
                    end
                    GroupRemoveUnit(g, temp)
                end
                DestroyGroup(g)
            end
            if not IssueNoAttackOrder then
                IssueNoAttackOrder = IssueTargetOrder(u, "smart", target) -- returns false if unit is out of range
            end
        end
        temp = nil
        g = nil
    end

    local function IssueOrder()
        local npc = GetEnumUnit()
        local npcID = npc
        local status = NPClist[npcID][0]
        local i = 0
        local target = nil
        local Range = ReturnRange
        local OrderRange = OrderReturnRange
        if status == 1 then -- unit in combat

            NPClist[npcID][3] = NPClist[npcID][3] + UpdateIntervall

            if IsUnitInRangeXY(npc, NPClist[npcID][1], NPClist[npcID][2], Range) and NPClist[npcID][10] then
                target = NPClist[npcID][10]
                if IsUnitInRangeXY(target, NPClist[npcID][1], NPClist[npcID][2], OrderRange) then
                    if GetUnitCurrentOrder(npc) == 851983 or GetUnitCurrentOrder(npc) == 0 or GetUnitCurrentOrder(npc) == 851971 then -- attack order, no order or smart
                        EventBool = true
                        IssueSpellOrder(npc, target)
                        EventBool = false
                    end
                else -- target of unit to far away from camp position
                    ForGroup(NPClist[npcID][4], CampCommand) -- set camp returning
                end
            else -- unit left return range or killed all player units
                ForGroup(NPClist[npcID][4], CampCommand) -- set camp returning
            end
        elseif status == 2 then -- unit is returning
            if NPClist[npcID][3] > 0 then
                if not IsUnitInRangeXY(npc, NPClist[npcID][1], NPClist[npcID][2], 35) then
                    IssuePointOrder(npc, "move", NPClist[npcID][1], NPClist[npcID][2])
                    NPClist[npcID][3] = NPClist[npcID][3] - UpdateIntervall
                    UnitAddAbility(npc, FourCC('Avul'))
                else -- unit within close range to camp position
                    if GetUnitCurrentOrder(npc) == 851986 then -- move order
                        NPClist[npcID][3] = NPClist[npcID][3] - UpdateIntervall
                        UnitAddAbility(npc, FourCC('Avul'))
                    else -- Something blocks the exact spot or the unit has arrived
                        NPClist[npcID][0] = 3 -- set status: returned
                        NPClist[npcID][3] = NPClist[npcID][3] - UpdateIntervall
                        TBool = true
                        ForGroup(NPClist[npcID][4], CampStatus)
                        if TBool then -- all units in camp have status: returned to camp position
                            ForGroup(NPClist[npcID][4], CampCommand) -- set camp ooc
                        end
                    end
                end
            else -- counter expired - perform instant teleport
                SetUnitPosition(npc, NPClist[npcID][1], NPClist[npcID][2])
                NPClist[npcID][0] = 3 -- set status: returned
                TBool = true
                ForGroup(NPClist[npcID][4], CampStatus)
                if TBool then -- all units in camp have status: returned to camp position
                    ForGroup(NPClist[npcID][4], CampCommand) -- set camp ooc
                end
            end
        end
        npc = nil
        target = nil
    end

    local function Update()
        ForGroup(NPCgroup, IssueOrder) -- issues orders to all units in combat
    end

    ---@return boolean
    local function rettrue()
        return true
    end

    ---@return boolean
    local function RemovedUnitFound()
        if HaveSavedInteger(NPClist, GetHandleId(GetIndexedUnit()), 0) then
            ZTS_RemoveThreatUnit(GetIndexedUnit())
        elseif HaveSavedHandle(PUlist, GetHandleId(GetIndexedUnit()), 0) then
            ZTS_RemovePlayerUnit(GetIndexedUnit())
        end
        return true
    end

    --[[local function OnDeath()
        local u = GetTriggerUnit()
        local target
        local i = 0
        if NPClist[u][0] then
            RemoveThreatUnit(u)
        end
        if PUlist[u][0] then
            RemovePlayerUnit(u)
        end
        target = nil
        u = nil
    end]]

    ---@return boolean
    local function AddOnlyNonDummyNH()
        if GetOwningPlayer(GetFilterUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE) and GetUnitAbilityLevel(GetFilterUnit(), FourCC('Aloc')) == 0 then
            ZTS_AddThreatUnit(GetFilterUnit(), false)
        end
        return false
    end

    local g = CreateGroup()
    local t = CreateTrigger()
    local index = 0
    BOOLEXPR_TRUE = Condition(rettrue) -- prevent booleanexpressions from leaking
    TimerStart(Updater, UpdateIntervall, true, Update)
    --[[while true do
        TriggerRegisterPlayerUnitEvent(t, Player(index), EVENT_PLAYER_UNIT_DEATH, BOOLEXPR)
        index = index + 1
        if index == bj_MAX_PLAYER_SLOTS then break end
    end
    TriggerAddAction(t, OnDeath)
    t = CreateTrigger()
    TriggerRegisterUnitIndexEvent(t, EVENT_UNIT_DEINDEX)
    TriggerAddCondition(t, Condition(RemovedUnitFound))
    t = nil]]

    OnUnitLeave(function (u)
        if NPClist[u][0] then
            ZTS_RemoveThreatUnit(u)
        end
        if PUlist[u][0] then
            ZTS_RemovePlayerUnit(u)
        end
    end)

    GroupEnumUnitsOfPlayer(g, Player(PLAYER_NEUTRAL_AGGRESSIVE), Condition(AddOnlyNonDummyNH))
    DestroyGroup(g)
    g = nil
end)
if Debug then Debug.endFile() end