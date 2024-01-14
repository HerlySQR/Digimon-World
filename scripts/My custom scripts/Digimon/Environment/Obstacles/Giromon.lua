Debug.beginFile("Environment\\Obstacles\\Giromon")
OnInit.final(function ()
    Require "AbilityUtils"

    local GIROMON = FourCC('O06G')
    local visibilities = {} ---@type table<unit, table<player, fogmodifier>>

    ForUnitsOfPlayer(Digimon.NEUTRAL, function (u)
        if GetUnitTypeId(u) == GIROMON then
            visibilities[u] = SyncedTable.create()
        end
    end)

    Timed.echo(1, function ()
        ForUnitsOfPlayer(Digimon.NEUTRAL, function (u)
            if GetUnitTypeId(u) == GIROMON then
                local has = {}
                local x, y = GetUnitX(u), GetUnitY(u)
                ForUnitsInRange(x, y, 700., function (u2)
                    local p = GetOwningPlayer(u2)
                    if IsPlayerInGame(p) then
                        has[p] = true
                        if not visibilities[u][p] then
                            visibilities[u][p] = CreateFogModifierRadius(p, FOG_OF_WAR_VISIBLE, x, y, 700., true, false)
                            FogModifierStart(visibilities[u][p])
                        end
                    end
                end)
                for p, v in pairs(visibilities[u]) do
                    if not has[p] then
                        DestroyFogModifier(v)
                        visibilities[u][p] = nil
                    end
                end
            end
        end)
    end)
end)
Debug.endFile()