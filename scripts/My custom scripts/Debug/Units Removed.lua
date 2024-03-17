Debug.beginFile("Units Removed")
OnInit(function ()
    Require "AddHook"
    if udg_KeepTrackOfRemovedUnits then
        local oldRemoveUnit
        oldRemoveUnit = AddHook("RemoveUnit", function (u)
            print("Digimon removed:")
            print("Name: " .. GetHeroProperName(u))
            print("Level: " .. GetHeroLevel(u))
            print("Date: " .. os.date())
            print(Debug.traceback())
            print("\n")
            oldRemoveUnit(u)
        end)
    end
end)
Debug.endFile()