Debug.beginFile("Clear items")
OnInit("Clear Items", function ()
    Require "Timed"
    Require "WorldBounds"

    local DEFAULT_LIFE = 300. -- seconds

    local lifeSpans = __jarray(DEFAULT_LIFE) ---@type table<item, number>

    local callback = Filter(function ()
        local m = GetFilterItem()
        lifeSpans[m] = lifeSpans[m] - 1
        if lifeSpans[m] <= 0 then
            RemoveItem(m)
        end
    end)

    Timed.echo(1., function ()
        EnumItemsInRect(WorldBounds.rect, callback)
    end)

    ---@param m item
    ---@param life number?
    function SetItemLifeSpan(m, life)
        lifeSpans[m] = life or DEFAULT_LIFE
    end
end)
Debug.endFile()