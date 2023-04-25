if Debug then Debug.beginFile("Zwiebelchen's threat system") end
--[[
    
    Based on ZWIEBELCHEN'S THREAT SYSTEM v2.6    https:  www.hiveworkshop.com/threads/zwiebelchens-threat-system-2-7.156179/

    How to set it up:
  
    1. Gameplay Constants
  
        It is recommended to edit certain Gameplay Constants entries, to use the full potential of
        the system.
        The most important entries are: (with selected "Show Raw-Data")
        CallForHelp                 --> Set this to 0, if possible; the system will manage this - it isn't a problem if you don't do this, though
                                        You don't have to do it if your threat-system controlled units are neutral hostile
        CreepCallForHelp            --> Set this to 0, if possible; the system will manage this - it isn't a problem if you don't do this, though
        GuardDistance               --> Set this to something higher than ReturnRange (see below)
        MaxGuardDistance            --> Set this to something higher than ReturnRange (see below)
        GuardReturnTime             --> Set this to something very high, so that the standard AI doesn't interfere (i.e. 60 seconds)       
  
    2. Damage Detection
  
        Of course, a threat system is pretty useless without a trigger, that adds threat depending on
        the damage dealt by a player unit.
        I recommend using a damage detection script like IDDS:
        (http:  www.wc3c.net/showthread.php?t=100618)
        Check up the demo map for a very simple (but leaking) damage detection trigger
        The only function you actually need then is:
        ModifyThreat(GetEventDamageSource(), GetTriggerUnit(), GetEventDamage(), true)
        The function does all required checks on its own. There is no need to run something else.
]]
OnInit("ZTS", function ()
    Require "AddHook"
    Require "Timed"
    Require "Orders"
    Require "SyncedTable"
    Require "UnitEnum"

    -- Configurable

    local UPDATE_INTERVAL = 0.5 -- The intervall for issueing orders and performing AttackRange check. recommended value: 0.5
    local HELP_RANGE = 400 -- The range between units considered being in the same camp. If a unit of the same camp gets attacked, all others will help. Set CallForHelp to something lower in Gameplay Constants.
    local ORDER_RETURN_RANGE = 4000 -- The range the unit's target can be away from the original camping position, before being ordered to return.
    local RETURN_RANGE = 1500 -- The range the unit can move away from the original camping position, before being ordered to return.
    local TIME_TO_PORT = 10 -- This timer expires once a unit tries to return to its camping position. If it reaches 0 before reaching the camp position, the unit will be teleported immediately.
    local HEAL_UNITS_ON_RETURN = false -- If this is true, returning units will be healed to 100% health.

    -- Do not edit below here!

    ---@alias unitStatus
    ---| 0 out of combat
    ---| 1 in combat
    ---| 2 returning
    ---| 3 returned

    ---@class ZTS
    ---@field status unitStatus
    ---@field returnX number
    ---@field returnY number
    ---@field inCombat number
    ---@field camp group
    ---@field listlength integer
    ---@field threats table<unit, number>
    ---@field acquireTarget trigger
    local ZTS = {}

    local NPCgroup = CreateGroup()
    local NPClist = {} ---@type table<unit, ZTS>
    local PUlist = {} ---@type table<unit, ZTS>
    -- temporary variables for enumerations and forgroups
    local TBool = false
    local EventBool = false

    ---When using "A unit is issued an order without target" or "A unit is issued a target order" events,
    ---this function returns true when the order was issued by the threat system.
    ---
    ---You can use this to setup your own spell-AI for units.
    ---
    ---Let's say you want the unit to cast Summon Water Elemental whenever the cooldown is ready:
    ---Just use the mentioned events and add:
    ---
    ---    Custom script:   if not ZTS.isEvent() then
    ---    Custom script:   return
    ---    Custom script:   end
    ---
    ---at the beginning of you trigger's actions and you're done.
    ---
    ---You can now issue the order to the triggering unit:
    ---
    ---    Unit - Order (Triggering unit) to Human Archmage - Summon Water Elemental
    ---
    ---In combination with some of the Getter functions, you can trigger nice spell AI like this.
    ---
    ---NOTE: ZTS_IsEvent will only return true once(!) for every fired event, so if you need it again inside that trigger,
    ---make sure to save it to a variable.
    ---@return boolean
    function ZTS.isEvent()
        if EventBool then
            EventBool = false
            return true
        end
        return false
    end

    ---@param list table<unit, number>
    ---@return unit
    local function GetUnitWithMaxThreat(list)
        local max = 0
        local get
        for k, v in pairs(list) do
            if v >= max then
                get = k
            end
        end
        return get
    end

    ---converts threat list position into hashtable childkey
    ---@param position integer
    ---@return integer
    local function Pos2Key(position)
        return 8 + (position*2)
    end

    ---converts hashtable childkey into threat list position
    ---@param key integer
    ---@return integer
    local function Key2Pos(key)
        return (key-8)/2
    end

    ---Returns the combat state of a player or npc unit.
    ---
    ---Returns true, if the unit is registered and in combat.
    ---
    ---Returns false, if the unit is not registered or out of combat.
    ---@param u any
    ---@return boolean
    function ZTS.getCombatState(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return false
        elseif HaveSavedInteger(NPClist, GetHandleId(u), 0) then -- unit is npc
            return LoadInteger(NPClist, GetHandleId(u), 0) > 0
        elseif HaveSavedHandle(PUlist, GetHandleId(u), 0) then -- unit is player unit
            return LoadInteger(PUlist, GetHandleId(u), 1) > 0
        end
        return false
    end

    ---Returns the in-combat time of the npc.
    ---
    ---Does not work for player units.
    ---
    ---Returns "0" if the unit is not in combat or currently returning to camp position.
    ---@param u unit
    ---@return number
    function ZTS.getCombatTime(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return 0.
        elseif NPClist[u] then -- unit is npc
            if NPClist[u].status == 1 then -- only return a time when the unit is in combat
                return NPClist[u].inCombat
            end
        end
        return 0.
    end

    ---Returns the amount of threat unit PU has in unit NPC's threat list
    ---Returns "0" if the unit was not found, NPC does not feature a threat list or in case of invalid input data
    ---@param npc unit
    ---@param pu unit
    ---@return number
    function ZTS.getThreatUnitAmount(npc, pu)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) or GetUnitTypeId(pu) == 0 or IsUnitType(pu, UNIT_TYPE_DEAD) then -- units dead or null
            return 0.
        elseif not (NPClist[npc] and PUlist[pu]) then -- units not added
            return 0.
        elseif PUlist[pu].threats[npc] then
            return NPClist[npc].threats[pu]
        end
        return 0.
    end

    ---If used on a ThreatUnit, this returns a group of all units in threat list;
    ---
    ---if used on a PlayerUnit, this returns a group of all units aggroed.
    ---
    ---Returns an empty list, in case of invalid input data or empty lists.
    ---@param u unit
    ---@return unit[]
    function ZTS.getAttackers(u)
        local g = {}
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return g
        end

        if NPClist[u] then -- unit is npc
            for k, _ in pairs(NPClist[u].threats) do
                table.insert(g, k)
            end
        elseif PUlist[u] then -- unit is player unit
            ForGroup(PUlist[u].camp, function ()
                table.insert(g, GetEnumUnit())
            end)
        end
        return g
    end

    ---Adds, sets or substracts threat from npc's threat list caused by pu.
    ---
    ---Set 'add' to true to add or substract amount from the current value.
    ---
    ---Set 'add' to false to set the new threat value to amount.
    ---
    ---To reduce threat, use negative amount values with add == true.
    ---
    ---Remember: If a unit has 0 threat, it is still considered in-combat -
    ---this also means, that adding "0" to the units threat causes them to attack!
    ---@param pu unit
    ---@param npc unit
    ---@param amount number
    ---@param add boolean
    function ZTS.modifyThreat(pu, npc, amount, add)
        if not (NPClist[npc] and PUlist[pu]) then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(npc, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(npc) == 0 then -- null units
            return
        elseif NPClist[npc].status > 1 then -- do not add threat to units that are status: returning
            return
        end

        local puList = PUlist[pu]
        local npcList = NPClist[npc]
        local b = false
        local newAmount
        local oldAmount = 0

        if not puList.threats[pu] then -- pu not listed in npc's threat list
            local listlength = npcList.listlength + 1
            npcList.listlength = listlength -- add to list length of npc
            npcList.threats[pu] = 0 -- add pu to npc's threat list
            puList.threats[npc] = listlength -- add npc to slot list
            GroupAddUnit(puList.camp, npc) -- add npc to slot list group
            puList.listlength = puList.listlength + 1 -- increase group size count
            if npcList.status == 0 then
                npcList.status = 1 -- set unit status: combat
                GroupAddUnit(NPCgroup, npc) -- add the unit to incombat group
            end
            b = true
        else
            oldAmount = npcList.threats[pu]
        end

        if add then
            newAmount = oldAmount + amount
        else
            newAmount = amount
        end

        newAmount = math.max(newAmount, 0)

        npcList.threats[pu] = newAmount

        if b then
            ForGroup(npcList.camp, function ()
                local otherNPC = GetEnumUnit()
                if GetEnumUnit() == npc then
                    return
                end
                local otherNPCList = NPClist[otherNPC]
                if puList.threats[otherNPC] then -- original pu unit already listed in EnumUnit's threat list
                    return
                elseif otherNPCList.status > 1 or not UnitAlive(otherNPC) then -- do not add threat to dead or units that are status: returning
                    return
                end
                local listlength = otherNPCList.listlength + 1
                otherNPCList.listlength = listlength -- add to list length of EnumUnit
                otherNPCList.threats[pu] = 0. -- add original pu unit to EnumUnit's threat list
                puList.threats[otherNPC] = listlength
                GroupAddUnit(puList.camp, otherNPC)
                puList.listlength = puList.listlength + 1
                if otherNPCList.status == 0 then
                    otherNPCList.status = 1
                    GroupAddUnit(NPCgroup, otherNPC)
                end
            end)
        end
    end

    ---Units add by this way will generate threat on ThreatUnits.
    ---
    ---If the unit is not registered as a PlayerUnit, it will not be attacked by ThreatUnits.
    ---@param u unit
    function ZTS.addPlayerUnit(u)
        if NPClist[u] or PUlist[u] then -- unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return
        end
        PUlist[u] = {
            camp = CreateGroup(),
            listlength = 0,
            status = 0,
            returnX = 0,
            returnY = 0,
            inCombat = 0,
            threats = SyncedTable.create()
        }
    end

    ---This function registers the unit as an AI-controlled unit.
    ---
    ---ThreatUnits will automaticly attack the highest-in-threat attacker.
    ---
    ---When adding a ThreatUnit, its current position gets saved and be considered camp-position.
    ---
    ---It will always return to this position if pulled to far or on victory.
    ---
    ---Nearby units will be considered in the same camp group. Camp members will always retreat and attack together.
    ---
    ---If includeCombatCamps is true, the unit will be added to already fighting camps. If it is false, the unit will
    ---create its own camp group, if it can't find any non-fighting units nearby.
    ---
    ---This should be false in most cases, but it can be useful when you have bosses that summon units infight, so that
    ---the summons will be added to the bossfight correctly instead of getting their own seperate group.
    ---@param u unit
    ---@param includeCombatCamps boolean
    function ZTS.addThreatUnit(u, includeCombatCamps)
        if NPClist[u] or PUlist[u] then -- unit already added
            return
        elseif GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return
        end
        local data = { ---@type ZTS
            status = 0,
            returnX = GetUnitX(u),
            returnY = GetUnitY(u),
            inCombat = 0,
            listlength = 0,
            threats = SyncedTable.create()
        }

        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterUnitEvent(t, u, EVENT_UNIT_ACQUIRED_TARGET)
        TriggerAddCondition(t, Condition(function ()
            local npc = GetTriggerUnit()
            local pu = GetEventTargetUnit() or GetOrderTargetUnit()
            if IsUnitEnemy(pu, GetOwningPlayer(npc)) then
                if (data.threats[npc] or 0) == 0 then -- pull out of combat units only
                    ZTS.modifyThreat(pu, npc, 0, true)
                end
            end
            return false
        end))
        data.acquireTarget = t -- acquire target event trigger
        local tState = includeCombatCamps and 1 or 0

        local other = GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), HELP_RANGE, function (u2)
            return NPClist[u2] and NPClist[u2].camp and not IsUnitType(u2, UNIT_TYPE_DEAD) and NPClist[u2].status <= tState
        end)

        local g ---@type group
        if other then
            local otherData = NPClist[other]
            g = otherData.camp
            if includeCombatCamps then
                -- don't forget to inherit the camp unit's threat list...
                if otherData.status == 1 then -- ...but only if filtered unit is actually infight
                    local listlength = otherData.listlength
                    data.listlength = listlength -- copy list length
                    local i = 0
                    for temp, _ in pairs(otherData.threats) do -- copy all list entries as the newly added unit has an empty list and will cause the camp to reset almost instantly
                        data.threats[temp] = 0
                        if PUlist[temp] then
                            PUlist[temp].threats[u] = i -- assign the threat position to the player unit's reference list
                            GroupAddUnit(PUlist[temp].camp, u) -- add the unit to the player unit's threat group
                            PUlist[temp].listlength = PUlist[temp].listlength + 1 -- increase group size count
                        end
                        i = i + 1
                    end
                    data.status = 1
                    GroupAddUnit(NPCgroup, u) -- add the unit to incombat group
                end
            end
        else -- no unit in range has a camp group assigned, so create a new one
            g = CreateGroup()
        end
        GroupAddUnit(g, u)
        data.camp = g
        NPClist[u] = data
    end

    function ZTS.removeThreatUnit(u)
        if not NPClist[u] then -- unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end

        if NPClist[u].status > 1 then -- unit status is: returning
            IssueImmediateOrderById(u, Orders.stop)
            --SetUnitInvulnerable(u, false)
            --if IsUnitPaused(u) then
            --    PauseUnit(u, false)
            --end
        end

        for other, _ in pairs(NPClist[u].threats) do
            PUlist[other].threats[u] = nil
            GroupRemoveUnit(PUlist[other].camp, u)
            PUlist[other].listlength = PUlist[other].listlength - 1
        end

        local g = NPClist[u].camp
        GroupRemoveUnit(g, u)
        if not FirstOfGroup(g) then -- camp group is empty
            DestroyGroup(g)
        end

        local t = NPClist[u].acquireTarget
        TriggerClearActions(t)
        TriggerClearConditions(t)
        DestroyTrigger(t)

        NPClist[u] = nil
        if IsUnitInGroup(u, NPCgroup) then
            GroupRemoveUnit(NPCgroup, u) -- remove unit from incombat group
        end
    end

    ---Removes a player unit from the system. The unit will no longer generate threat on ThreatUnits.
    ---
    ---The unit will also be instantly removed from all threat lists.
    ---
    ---If the unit was the last unit in combat with the same hostile camp, all units
    ---of that camp group will immediately return to their camp positions.
    ---
    ---You can use this, followed by AddPlayerUnit to that unit out of combat and reset all threat.
    ---
    ---Dead or removed units will automaticly be cleared. You need to add them again after revival/recreation.
    ---@param u unit
    function ZTS.removePlayerUnit(u)
        if not PUlist[u] then -- unit not added
            return
        elseif GetUnitTypeId(u) == 0 then
            return
        end
        ForGroup(PUlist[u].camp, function ()
            local other = GetEnumUnit()
            NPClist[other].threats[u] = nil
            PUlist[u].threats[other] = nil
            NPClist[other].listlength = NPClist[other].listlength - 1
        end)

        DestroyGroup(PUlist[u].camp)
        PUlist[u] = nil
    end

    ---Adds Healing Threat to all units, that have ally on threat-list.
    ---
    ---This can be abused to apply global threat to a unit by passing the same unit to p and ally.
    ---
    ---Parameter divide = true means that the amount is split by the number of units attacking the target;
    ---for example if 3 units are currently attacking the targeted ally, it adds amount/3 threat from pu to all of them.
    ---
    ---Parameter divide = false means that every attacking unit gets 'amount' of threat applied.
    ---use add = false to set the amount of threat to 'amount', instead of increasing/decreasing it
    ---negative values are allowed in combination with 'add' to reduce threat.
    ---
    ---You can also use this with add = false and amount = 0 with pu = ally to set total threat generated back to zero for this unit.
    ---@param pu unit
    ---@param ally unit
    ---@param amount number
    ---@param add boolean
    ---@param divide boolean
    function ZTS.applyHealThreat(pu, ally, amount, add, divide)
        if not (PUlist[pu] and PUlist[ally]) then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(ally, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(ally) == 0 then -- null units
            return
        end

        local THealthreat
        if divide and PUlist[ally].listlength > 1 then
            THealthreat = amount / PUlist[ally].listlength
        else
            THealthreat = amount
        end
        ForGroup(PUlist[ally].camp, function ()
            ZTS.modifyThreat(pu, GetEnumUnit(), THealthreat, add)
        end)
    end

    local function CampCommand()
        local u = GetEnumUnit()
        local data = NPClist[u]
        local status = data.status

        if status == 1 then
            data.status = 2
            for other, _ in pairs(data.threats) do
                local otherData = PUlist[other]
                otherData.threats[u] = nil
                GroupRemoveUnit(otherData.camp, u)
                otherData.listlength = otherData.listlength - 1
            end
            data.threats = SyncedTable.create()
            data.listlength = 0
            IssueImmediateOrderById(u, Orders.stop) -- cancels even spellcast with casting time
            IssuePointOrderById(u, Orders.move, data.returnX, data.returnY)
            data.inCombat = TIME_TO_PORT
            --SetUnitInvulnerable(u, true)
            if HEAL_UNITS_ON_RETURN then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            end
        elseif status == 3 then
            data.status = 0
            data.inCombat = 0. -- reset incombat and return timer
            --SetUnitInvulnerable(u, false)
            if HEAL_UNITS_ON_RETURN then
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE))
                SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
            end
            GroupRemoveUnit(NPCgroup, u) -- remove from combat group

            --PauseUnit(u, false)
            IssueImmediateOrderById(u, Orders.stop)
        end
    end

    local function CampStatus()
        if NPClist[GetEnumUnit()].status ~= 3 then
            TBool = false
        end
    end

    Timed.echo(UPDATE_INTERVAL, function ()
        ForGroup(NPCgroup, function () -- issues orders to all units in combat
            local npc = GetEnumUnit()
            local data = NPClist[npc]
            local status = data.status

            if status == 1 then
                data.inCombat = data.inCombat + UPDATE_INTERVAL
                local target = GetUnitWithMaxThreat(data.threats)
                if IsUnitInRangeXY(npc, data.returnX, data.returnY, RETURN_RANGE) and target then
                    if IsUnitInRangeXY(target, data.returnX, data.returnY, ORDER_RETURN_RANGE) then
                        if GetUnitCurrentOrder(npc) == Orders.attack or GetUnitCurrentOrder(npc) == 0 or GetUnitCurrentOrder(npc) == Orders.smart then -- attack order or no order or smart order
                            EventBool = true
                            IssueTargetOrderById(npc, Orders.smart, target)
                            EventBool = false
                        end
                    else  -- target of unit to far away from camp position
                        ForGroup(data.camp, CampCommand) -- set camp returning
                    end
                else -- unit left return range or killed all player units
                    ForGroup(data.camp, CampCommand) -- set camp returning
                end
            elseif status == 2 then
                if data.inCombat > 0 then
                    if not IsUnitInRangeXY(npc, data.returnX, data.returnY, 35) then
                        IssuePointOrderById(npc, Orders.move, data.returnX, data.returnY)
                        data.inCombat = data.inCombat - UPDATE_INTERVAL
                        --SetUnitInvulnerable(npc, true)
                    else -- unit within close range to camp position
                        if GetUnitCurrentOrder(npc) == Orders.move then
                            data.inCombat = data.inCombat - UPDATE_INTERVAL
                            --SetUnitInvulnerable(npc, true)
                        else -- Something blocks the exact spot or the unit has arrived
                            data.status = 3
                            TBool = true
                            ForGroup(data.camp, CampStatus)
                            if TBool then -- all units in camp have status: returned to camp position
                                ForGroup(data.camp, CampCommand) -- set camp ooc
                            --else
                                --PauseUnit(npc, true) -- make sure it doesn't move or attack when invulnerable
                            end
                        end
                    end
                else -- counter expired - perform instant teleport
                    SetUnitPosition(npc, data.returnX, data.returnY)
                    data.status = 3
                    TBool = true
                    ForGroup(data.camp, CampStatus)
                    if TBool then -- all units in camp have status: returned to camp position
                        ForGroup(data.camp, CampCommand) -- set camp ooc
                    --else
                        --PauseUnit(npc, true) -- make sure it doesn't move or attack when invulnerable
                    end
                end
            end
        end)
    end)

    ---@param u unit
    local function ClearUnit(u)
        if NPClist[u] then
            ZTS.removeThreatUnit(u)
        end
        if PUlist[u] then
            ZTS.removePlayerUnit(u)
        end
    end

    local t = CreateTrigger()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_DEATH)
    end
    TriggerAddAction(t, function ()
        ClearUnit(GetTriggerUnit())
    end)

    AddHook("RemoveUnit", ClearUnit)

    return ZTS
end)
if Debug then Debug.endFile() end