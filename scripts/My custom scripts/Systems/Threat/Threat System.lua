Debug.beginFile("Threat System")
OnInit("Threat System", function ()
    Require "EventListener"
    Require "Timed"
    Require "UnitEnterEvent"
    Require "UnitEnum"
    Require "SyncedTable"
    Require "Orders"

    local UPDATE_INTERVAL = 0.5 -- The intervall for issueing orders and performing AttackRange check. recommended value: 0.5
    local HELP_RANGE = 400 -- The range between units considered being in the same camp. If a unit of the same camp gets attacked, all others will help.
                                          -- Set CallForHelp to something lower in Gameplay Constants.
    local ORDER_RETURN_RANGE = 3500 -- The range the unit's target can be away from the original camping position, before being ordered to return.
    local RETURN_RANGE = 1200 -- The range the unit can move away from the original camping position, before being ordered to return.
    local TIME_TO_PORT = 10 -- This timer expires once a unit tries to return to its camping position.
                                          -- If it reaches 0 before reaching the camp position, the unit will be teleported immediately.
    local HEAL_UNITS_IN_RETURN = true -- If this is true, returning units will be healed to 100% health.
    local DISABLE_NPC_COLLISION = false

    ---@alias threatStatus
    ---| 0 # Off combat
    ---| 1 # On combat
    ---| 2 # Returning
    ---| 3 # Returned

    local PUlist = {} ---@type table<unit, table<unit, integer>>

    ---@class NPCThreat
    ---@field status threatStatus
    ---@field returnX number
    ---@field returnY number
    ---@field time number
    ---@field camp table<unit, boolean>
    ---@field list unit[]
    ---@field threats number[]
    ---@field acquireTarget trigger

    local NPClist = SyncedTable.create() ---@type table<unit, NPCThreat>

    local NPCOrders = {} ---@type table<integer, {order: integer, castType: CastType, forAlly: boolean}>

    ---@param range number
    ---@return number
    local function convertedRange(range)
        local r = range/100
        return (2/r + r)*100
    end

    Threat = {}

    ---@param pu unit
    function Threat.addPlayerUnit(pu)
        if PUlist[pu] or NPClist[pu] then -- unit already added
            return
        elseif GetUnitTypeId(pu) == 0 or IsUnitType(pu, UNIT_TYPE_DEAD) then -- unit dead or nil
            return
        end
        PUlist[pu] = SyncedTable.create()
    end

    ---@param npc unit
    ---@param key1 integer
    ---@param key2 integer
    local function Swap(npc, key1, key2)
        local u = NPClist[npc].list[key1]
        local r = NPClist[npc].threats[key1]
        NPClist[npc].list[key1] = NPClist[npc].list[key2]
        NPClist[npc].threats[key1] = NPClist[npc].threats[key2]
        PUlist[NPClist[npc].list[key1]][npc] = key1 -- update position list
        NPClist[npc].list[key2] = u
        NPClist[npc].threats[key2] = r
        PUlist[u][npc] = key2 -- update position list
    end

    local AcquireTarget = Condition(function ()
        local npc = GetTriggerUnit()
        local pu
        if GetEventTargetUnit() ~= nil then
            pu = GetEventTargetUnit()
        else
            pu = GetOrderTargetUnit()
        end
        if IsUnitEnemy(pu, GetOwningPlayer(npc)) then
            if NPClist[npc].status == 0 then -- pull out of combat units only
                Threat.modify(pu, npc, 0, true)
            end
        end
        return false
    end)

    ---@param npc unit
    ---@param includeCombatCamps boolean
    function Threat.addNPC(npc, includeCombatCamps)
        if PUlist[npc] or NPClist[npc] then -- unit already added
            return
        elseif GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) then -- unit dead or nil
            return
        end

        if DISABLE_NPC_COLLISION then
            UnitAddAbility(npc, FourCC('Aeth')) -- disable collision
        end
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, npc, EVENT_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterUnitEvent(t, npc, EVENT_UNIT_ACQUIRED_TARGET)
        TriggerAddCondition(t, AcquireTarget)

        NPClist[npc] = {
            status = 0,
            returnX = GetUnitX(npc),
            returnY = GetUnitY(npc),
            time = 0,
            camp = nil,
            list = {},
            threats = __jarray(0),
            acquireTarget = t,
            orders = SyncedTable.create()
        }

        local tState = includeCombatCamps and 1 or 0

        local other = GetRandomUnitOnRange(GetUnitX(npc), GetUnitY(npc), HELP_RANGE, function (u)
            return NPClist[u] and not IsUnitType(u, UNIT_TYPE_DEAD) and NPClist[u].status <= tState
        end)

        local camp
        if other then
            camp = NPClist[other].camp
            if not camp then
                camp = SyncedTable.create()
                NPClist[other].camp = camp
            end
            if includeCombatCamps then
                -- don't forget to inherit the camp unit's threat list...
                if NPClist[other].status == 1 then -- ...but only if filtered unit is actually infight
                    for i = 1, #NPClist[other].list do -- copy all list entries as the newly added unit has an empty list and will cause the camp to reset almost instantly
                        local temp = NPClist[other].list[i]

                        table.insert(NPClist[npc].list, temp)
                        table.insert(NPClist[npc].threats, 0)

                        PUlist[temp][npc] = i
                    end
                    NPClist[npc].status = 1 -- set unit status: combat
                end
            end
        else -- no unit in range has a camp group assigned, so create a new one
            camp = SyncedTable.create()
        end
        camp[npc] = true
        NPClist[npc].camp = camp
    end

    ---@param npc unit
    ---@param x number
    ---@param y number
    function Threat.changeReturnPos(npc, x, y)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) then -- unit dead or nil
            return
        end
        if NPClist[npc] then
            NPClist[npc].returnX = x
            NPClist[npc].returnY = y
        end
    end

    ---@param pu unit
    function Threat.removePlayerUnit(pu)
        if not PUlist[pu] then -- unit not added
            return
        elseif GetUnitTypeId(pu) == 0 then
            return
        end
        for other, key in pairs(PUlist[pu]) do -- remove the entry in u's threat list and fill the gap
            for i = key+1, #NPClist[other].list do
                PUlist[NPClist[other].list[i]][other] = i-1
            end
            table.remove(NPClist[other].list, key)
            table.remove(NPClist[other].threats, key)
        end
        PUlist[pu] = nil
    end

    ---@param npc unit
    function Threat.removeNPC(npc)
        if not NPClist[npc] then -- unit not added
            return
        elseif GetUnitTypeId(npc) == 0 then
            return
        end

        if NPClist[npc].status > 1 then -- unit status is: returning
            IssueImmediateOrderById(npc, Orders.stop)
            SetUnitInvulnerable(npc, false)
        end

        for i = 1, #NPClist[npc].list do -- remove the entry in the player unit's position list and list group and decrease list group count
            PUlist[NPClist[npc].list[i]][npc] = nil
        end

        NPClist[npc].camp[npc] = nil

        DestroyTrigger(NPClist[npc].acquireTarget)

        NPClist[npc] = nil
    end

    ---@param u unit
    ---@return boolean
    function Threat.getCombatState(u)
        if GetUnitTypeId(u) == 0 or IsUnitType(u, UNIT_TYPE_DEAD) then -- unit dead or null
            return false
        elseif NPClist[u] then
            return NPClist[u].status > 0
        elseif PUlist[u] then
            for _, _ in pairs(PUlist[u]) do
                return true
            end
        end
        return false
    end

    ---@param npc unit
    ---@return number
    function Threat.getCombatTime(npc)
        if GetUnitTypeId(npc) == 0 or IsUnitType(npc, UNIT_TYPE_DEAD) then -- unit dead or null
            return 0.
        elseif NPClist[npc] then
            if NPClist[npc].status == 1 then -- only return a time when the unit is in combat
                return NPClist[npc].time
            end
        end
        return 0.
    end

    ---@param npc unit
    ---@param pu unit
    ---@return integer
    function Threat.getUnitSlot(npc, pu)
        if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then -- units null
            return 0
        elseif not NPClist[npc] or not PUlist[pu] then -- units not added
            return 0
        end
        return PUlist[pu][npc] or 0
    end

    ---@param npc unit
    ---@param pu unit
    ---@return number
    function Threat.getUnitAmount(npc, pu)
        if GetUnitTypeId(npc) == 0 or GetUnitTypeId(pu) == 0 then -- units null
            return 0.
        elseif not NPClist[npc] or not PUlist[pu] then -- units not added
            return 0.
        end
        return NPClist[npc].threats[PUlist[pu][npc]]
    end

    ---@param npc unit
    ---@param position integer
    ---@return unit?
    function Threat.getSlotUnit(npc, position)
        if GetUnitTypeId(npc) == 0 or position <= 0 then -- unit null or invalid slot
            return nil
        elseif not NPClist[npc] then -- unit not added
            return nil
        end
        return NPClist[npc].list[position]
    end

    ---@param npc unit
    ---@param position integer
    ---@return number
    function Threat.getSlotAmount(npc, position)
        if GetUnitTypeId(npc) == 0 or position <= 0 then -- unit null or invalid slot
            return 0.
        elseif not NPClist[npc] then -- unit not added
            return 0.
        end
        return NPClist[npc].threats[position]
    end

    ---@param u unit
    ---@return unit[]
    function Threat.getAttackers(u)
        local l = {}
        if GetUnitTypeId(u) == 0 then
            return l
        end

        if NPClist[u] then
            for i = 1, #NPClist[u].list do
                table.insert(l, NPClist[u].list[i])
            end
        elseif PUlist[u] then
            for npc, _ in pairs(PUlist[u]) do
                table.insert(l, npc)
            end
        end

        return l
    end

    ---@param pu unit
    ---@param ally unit
    ---@param amount number
    ---@param add boolean
    ---@param divide boolean
    function Threat.applyHeal(pu, ally, amount, add, divide)
        if not PUlist[pu] or not PUlist[ally] then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(ally, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(ally) == 0 then -- nil units
            return
        end

        if divide and PUlist[ally] then
            local len = 0
            for _, _ in pairs(PUlist[ally]) do
                len = len + 1
            end
            if len > 1 then
                amount = amount/len
            end
        end

        for npc, _ in pairs(PUlist[ally]) do
            Threat.modify(pu, npc, amount, add)
        end
    end

    ---@param pu unit
    ---@param npc unit
    ---@param amount number
    ---@param add boolean
    function Threat.modify(pu, npc, amount, add)
        if not PUlist[pu] or not NPClist[npc] then -- units not added
            return
        elseif IsUnitType(pu, UNIT_TYPE_DEAD) or IsUnitType(npc, UNIT_TYPE_DEAD) then -- units dead
            return
        elseif GetUnitTypeId(pu) == 0 or GetUnitTypeId(npc) == 0 then -- nil units
            return
        elseif NPClist[npc].status > 1 then -- do not add threat to units that are status: returning
            return
        end

        local key
        local oldAmount = 0
        local b = false

        if not PUlist[pu][npc] then -- pu not listed in npc's threat list
            table.insert(NPClist[npc].list, pu) -- add pu to end of npc's threat list
            table.insert(NPClist[npc].threats, amount) -- add npc to slot list
            key = #NPClist[npc].list
            PUlist[pu][npc] = key
            if NPClist[npc].status == 0 then
                NPClist[npc].status = 1
            end
            b = true
        else
            key = PUlist[pu][npc]
            oldAmount = NPClist[npc].threats[key]
        end

        local newAmount = add and (oldAmount + amount) or amount
        newAmount = math.max(newAmount, 0)

        NPClist[npc].threats[key] = newAmount

        local i = 0
        if newAmount > oldAmount then -- check lower keys
            while true do
                if NPClist[npc].list[key-1-i] then
                    if NPClist[npc].threats[key-1-i] < newAmount then -- lower key amount is smaller
                        Swap(npc, key-1-i, key-i)
                    else
                        break
                    end
                    i = i + 1
                else
                    break
                end
            end
        elseif newAmount < oldAmount then -- check higher keys
            while true do
                if NPClist[npc].list[key+1+i] then
                    if NPClist[npc].threats[key+1+i] > newAmount then -- upper key amount is larger
                        Swap(npc, key+1+i, key+i)
                    else
                        break
                    end
                    i = i + 1
                else
                    break
                end
            end
        end
        if b then
            for other, _ in pairs(NPClist[npc].camp) do
                if other ~= npc and not PUlist[pu][other] and not (NPClist[other].status > 1 or IsUnitType(other, UNIT_TYPE_DEAD)) then
                    table.insert(NPClist[other].list, pu) -- add original pu unit to end of other's threat list
                    table.insert(NPClist[other].threats, 0.)
                    PUlist[pu][other] = #NPClist[other].list -- add other to slot list
                    if NPClist[other].status == 0 then
                        NPClist[other].status = 1 -- set unit status: combat
                    end
                end
            end
        end
    end

    ---set camp returning
    ---@param camp table<unit, boolean>
    local function CampCommand(camp)
        for npc, _ in pairs(camp) do
            local status = NPClist[npc].status
            if status == 1 then
                NPClist[npc].status = 2
                for i = #NPClist[npc].list, 1, -1 do -- remove the entry in the player unit's position list and list group and decrease list group count
                    PUlist[NPClist[npc].list[i]][npc] = nil
                    table.remove(NPClist[npc].list, i)
                    table.remove(NPClist[npc].threats, i)
                end
                IssueImmediateOrderById(npc, Orders.stop)
                IssuePointOrderById(npc, Orders.move, NPClist[npc].returnX, NPClist[npc].returnY)
                NPClist[npc].time = TIME_TO_PORT
                SetUnitInvulnerable(npc, true)
                if HEAL_UNITS_IN_RETURN then
                    SetUnitState(npc, UNIT_STATE_LIFE, GetUnitState(npc, UNIT_STATE_MAX_LIFE))
                    SetUnitState(npc, UNIT_STATE_MANA, GetUnitState(npc, UNIT_STATE_MAX_MANA))
                end
            elseif status == 3 then
                NPClist[npc].status = 0
                NPClist[npc].time = 0.
                SetUnitInvulnerable(npc, false)
                if HEAL_UNITS_IN_RETURN then
                    SetUnitState(npc, UNIT_STATE_LIFE, GetUnitState(npc, UNIT_STATE_MAX_LIFE))
                    SetUnitState(npc, UNIT_STATE_MANA, GetUnitState(npc, UNIT_STATE_MAX_MANA))
                    UnitResetCooldown(npc)
                end
                IssueImmediateOrderById(npc, Orders.stop)
            end
        end
    end

    ---@param u unit
    ---@param target unit
    local function IssueSpellOrder(u, target)
        local orderIssued = false
        local i = 0
        while true do
            local abil = BlzGetUnitAbilityByIndex(u, i)
            if not abil then break end

            local spell = BlzGetAbilityId(abil)

            local data = NPCOrders[spell]

            local level, range, area

            if not data then
                goto next_iteration
            end

            if not UnitCanCastAbility(u, spell) then
                goto next_iteration
            end

            level = GetUnitAbilityLevel(u, spell)
            range = convertedRange(BlzGetAbilityRealLevelField(abil, ABILITY_RLF_CAST_RANGE, level - 1))
            area = BlzGetAbilityRealLevelField(abil, ABILITY_RLF_AREA_OF_EFFECT, level - 1)

            if data.castType == CastType.TARGET then
                if data.forAlly then
                    target = GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        return IsUnitAlly(u, GetOwningPlayer(u2)) and UnitAlive(u2)
                    end)
                end
                if target then
                    orderIssued = IssueTargetOrderById(u, data.order, target)
                end
            elseif data.castType == CastType.POINT then
                orderIssued = IssuePointOrderById(u, data.order, GetUnitX(target), GetUnitY(target))
            elseif data.castType == CastType.IMMEDIATE then
                local count = 0
                ForUnitsInRange(GetUnitX(u), GetUnitY(u), area, function (u2)
                    if not data.forAlly and (not IsUnitEnemy(u, GetOwningPlayer(u2)) or BlzIsUnitInvulnerable(u2)) and UnitAlive(u2) then
                        return
                    end
                    if data.forAlly and not IsUnitAlly(u, GetOwningPlayer(u2)) and UnitAlive(u2) then
                        return
                    end
                    count = count + 1
                end)
                if count >= 1 then
                    orderIssued = IssueImmediateOrderById(u, data.order)
                end
            end

            if orderIssued then
                break
            end

            ::next_iteration::
            i = i + 1
        end

        if not orderIssued then
            if IsUnitInRange(target, u, 100) then
                ForUnitsInRange(GetUnitX(u), GetUnitY(u), 48, function (u2)
                    if u2 ~= u and not IsUnitType(u2, UNIT_TYPE_DEAD) and IsUnitAlly(u2, GetOwningPlayer(u)) and GetUnitCurrentOrder(u2) ~= Orders.move then
                        local r = Atan2(GetUnitY(u) - GetUnitY(target), GetUnitX(u) - GetUnitX(target)) + GetRandomReal(0, 3)
                        local x = GetUnitX(target)+Cos(r)*60
                        local y = GetUnitY(target)+Sin(r)*60
                        orderIssued = IssuePointOrderById(u, Orders.move, x, y)
                    end
                end)
            end
            if not orderIssued then
                orderIssued = IssueTargetOrderById(u, Orders.smart, target) -- returns false if unit is out of range
            end
        end
    end

    ---@param order integer
    ---@param castType CastType
    ---@param forAlly boolean
    function Threat.NPCAddOrder(spell, order, castType, forAlly)
        NPCOrders[spell] = {
            order = order,
            castType = castType,
            forAlly = forAlly
        }
    end

    Timed.echo(UPDATE_INTERVAL, function ()
        for npc, threat in pairs(NPClist) do
            local status = threat.status

            if status == 1 then
                threat.time = threat.time + UPDATE_INTERVAL

                if IsUnitInRangeXY(npc, threat.returnX, threat.returnY, RETURN_RANGE) and threat.list[1] then
                    local target = threat.list[1]
                    if IsUnitInRangeXY(target, threat.returnX, threat.returnY, ORDER_RETURN_RANGE) then
                        if GetUnitCurrentOrder(npc) == Orders.attack or GetUnitCurrentOrder(npc) == 0 or GetUnitCurrentOrder(npc) == Orders.smart then
                            IssueSpellOrder(npc, target)
                        end
                    else -- target of unit to far away from camp position
                        CampCommand(threat.camp)
                    end
                else -- unit left return range or killed all player units
                    CampCommand(threat.camp)
                end
            elseif status == 2 then -- unit is returning
                if threat.time > 0 then
                    threat.time = threat.time - UPDATE_INTERVAL
                    if not IsUnitInRangeXY(npc, threat.returnX, threat.returnY, 35) then
                        IssuePointOrderById(npc, Orders.move, threat.returnX, threat.returnY)
                        SetUnitInvulnerable(npc, true)
                    else -- unit within close range to camp position
                        if GetUnitCurrentOrder(npc) == Orders.move then -- move order
                            SetUnitInvulnerable(npc, true)
                        else -- Something blocks the exact spot or the unit has arrived
                            threat.status = 3 -- set status: returned
                            for other, _ in pairs(threat.camp) do
                                if NPClist[other].status ~= 3 then
                                    CampCommand(threat.camp)
                                    break
                                end
                            end
                        end
                    end
                else -- counter expired - perform instant teleport
                    SetUnitPosition(npc, threat.returnX, threat.returnY)
                    threat.status = 3 -- set status: returned
                    for other, _ in pairs(threat.camp) do
                        if NPClist[other].status ~= 3 then
                            CampCommand(threat.camp)
                            break
                        end
                    end
                end
            end
        end
    end)

    OnUnitLeave(function (u)
        if PUlist[u] then
            Threat.removePlayerUnit(u)
        elseif NPClist[u] then
            Threat.removeNPC(u)
        end
    end)
end)
Debug.endFile()