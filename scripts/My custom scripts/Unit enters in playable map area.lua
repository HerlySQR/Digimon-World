Debug.beginFile("Unit enters in playable map area")
OnInit(function ()
    Require "WorldBounds"

    local t = CreateTrigger()
    TriggerRegisterEnterRegion(t, MapBounds.region, nil)
    TriggerAddAction(t, function ()
        TriggerExecute(gg_trg_Unit_enters_in_playable_map_area)
    end)
end)
Debug.endFile()