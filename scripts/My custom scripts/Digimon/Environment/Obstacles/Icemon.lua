Debug.beginFile("Environment\\Obstacles\\Icemon")
OnInit.final(function ()
    Require "AbilityUtils"

    local ICEMON = FourCC('O06E')
    local PATH_BLOCKER = FourCC('YTpc')
    local OFFSETS = {0, 1, -1}
    local AREA = 1500.
    local BLIZZARD = FourCC('WNcw')

    ForUnitsOfPlayer(Digimon.NEUTRAL, function (u)
        if GetUnitTypeId(u) == ICEMON then
            local x, y = RoundUp(GetUnitX(u)), RoundUp(GetUnitY(u))
            SetUnitPosition(u, x, y)
            for i = 1, 3 do
                for j = 1, 3 do
                    if not (i == 1 and j == 1) then
                        CreateDestructable(PATH_BLOCKER, x + OFFSETS[i] * bj_CELLWIDTH, y + OFFSETS[j] * bj_CELLWIDTH, 0, 1, 0)
                    end
                end
            end
            ForEachCellInRange(x, y, bj_CELLWIDTH, function (x2, y2)
                TerrainDeformCrater(x2, y2, 63, -600, 1, true)
            end)
            EnableWeatherEffect(AddWeatherEffect(Rect(x - AREA, y - AREA, x + AREA, y + AREA), BLIZZARD), true)
        end
    end)
end)
Debug.endFile()