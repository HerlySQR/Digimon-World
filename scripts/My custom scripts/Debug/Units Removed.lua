Debug.beginFile("Units Removed")
OnInit(function ()
    Require "AddHook"
    Require "UnitEnterEvent"

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

    OnUnitLeave(function (u)
        print("Digimon leave:")
        print("Name: " .. GetHeroProperName(u))
        print("Level: " .. GetHeroLevel(u))
        print("Date: " .. os.date())
        print("\n")
    end)
end)
Debug.endFile()