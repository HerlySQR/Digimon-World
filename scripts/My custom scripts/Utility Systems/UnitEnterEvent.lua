if Debug then Debug.beginFile("UnitEnterEvent") end
OnInit("UnitEnterEvent", function ()
    Require "EventListener"
    Require "Orders"
    Require "WorldBounds"

    local LEAVE_DETECTION = FourCC('A0DI')

    local enterEvent = EventListener.create()
    local leaveEvent = EventListener.create()

    ---@param func fun(u: unit)
    function OnUnitEnter(func)
        enterEvent:register(func)
    end

    ---@param func fun(u: unit)
    function OnUnitLeave(func)
        leaveEvent:register(func)
    end

    ---@param u unit
    local function prepareUnit(u)
        UnitAddAbility(u, LEAVE_DETECTION)
        UnitMakeAbilityPermanent(u, true, LEAVE_DETECTION)
        enterEvent:run(u)
    end

	-- Make the ability invisible to the player
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        SetPlayerAbilityAvailable(Player(i), LEAVE_DETECTION, false)
    end

    OnInit.final(function ()
        -- Create the enter event
        TriggerRegisterEnterRegion(CreateTrigger(), WorldBounds.region, Filter(function () prepareUnit(GetFilterUnit()) end))

        -- Create the leave event
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        TriggerAddAction(t, function ()
            local leavingUnit = GetTriggerUnit()
            if GetUnitAbilityLevel(leavingUnit, LEAVE_DETECTION) == 0 and GetIssuedOrderId() == Orders.undefend then
                leaveEvent:run(leavingUnit)
            end
        end)

        -- Process preplaced units
        local preplacedUnits = CreateGroup()
        GroupEnumUnitsInRect(preplacedUnits, WorldBounds.rect)
        ForGroup(preplacedUnits, function () prepareUnit(GetEnumUnit()) end)
        GroupClear(preplacedUnits)
        DestroyGroup(preplacedUnits)
    end)
end)