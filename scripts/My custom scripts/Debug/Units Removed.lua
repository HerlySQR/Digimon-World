Debug.beginFile("Units Removed")
OnInit(function ()
    Require "AddHook"
    if udg_KeepTrackOfRemovedUnits then
        AddHook("RemoveUnit", function (u)
            print("Digimon removed:")
            print("Name: " .. GetHeroProperName(u))
            print("Level: " .. GetHeroLevel(u))
            print("Date: " .. os.date())
            print(Debug.traceback())
            print("\n")
        end)
    end
end)
Debug.endFile()