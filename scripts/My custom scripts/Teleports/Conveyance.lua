OnInit(function ()
    Require "Digimon"
    Require "Transmission"

    ---@param ticket integer
    ---@param receiver location
    ---@param envName string
    ---@param level integer
    ---@param noLevelDialog integer
    local function Create(ticket, receiver, envName, level, noLevelDialog)
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ticket end))
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetManipulatingUnit())

            if level > 0 and d:getLevel() < level then
                if noLevelDialog > 0 then
                    udg_TalkId = noLevelDialog
                    udg_TalkTo = d.root
                    udg_TalkToForce = Force(d:getOwner())
                    TriggerExecute(udg_TalkRun)
                end
                return
            end

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
            udg_ConveyanceNewEnvName,
            udg_ConveyanceLevel,
            udg_ConveyanceNoLevelDialog
        )
        udg_ConveyanceTicket = 0
        udg_ConveyanceReceiver = nil
        udg_ConveyanceNewEnvName = ""
        udg_ConveyanceLevel = 0
        udg_ConveyanceNoLevelDialog = 0
    end)
end)