Debug.beginFile("OnUnitEnter")
OnInit("OnUnitEnter", function ()
    Require "WorldBounds"
    Require "EventListener"

    local onEnter = EventListener.create()

    local t = CreateTrigger()
    TriggerRegisterEnterRegion(t, MapBounds.region, nil)
    TriggerAddAction(t, function ()
        TriggerExecute(gg_trg_Unit_enters_in_playable_map_area)
        onEnter:run(GetEnteringUnit())
    end)

    ---@param func fun(enterUnit: unit)
    function OnUnitEnter(func)
        onEnter:register(func)
    end
end)
Debug.endFile()