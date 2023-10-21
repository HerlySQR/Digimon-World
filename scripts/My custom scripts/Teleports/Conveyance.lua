OnInit(function ()
    Require "Digimon"

    ---@param ticket integer
    ---@param receiver location
    ---@param envName string
    local function Create(ticket, receiver, envName)
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ticket end))
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetManipulatingUnit())
            d:hide()
            d:setLoc(receiver)
            d.environment = Environment.get(envName)
            if Environment.apply(envName, d:getOwner(), true) and  d:getOwner() == GetLocalPlayer() then
                PanCameraToTimed(d:getX(), d:getY(), 0)
            end
            Timed.call(0.25, function ()
                d:show()
            end)
        end)
    end

    udg_ConveyanceCreate = CreateTrigger()
    TriggerAddAction(udg_ConveyanceCreate, function ()
        Create(
            udg_ConveyanceTicket,
            udg_ConveyanceReceiver,
            udg_ConveyanceNewEnvName
        )
    end)
end)