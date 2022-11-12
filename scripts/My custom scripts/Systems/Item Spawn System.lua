OnInit(function ()
    Require "LinkedList"

    local INTERVAL = 15.

    local All = LinkedList.create()
    local Reference = {}

    local function Create(rects, types, maxItems)
        local new = {
            rects = rects,
            types = types,
            maxItems = maxItems,
            count = 0
        }

        All:insert(new)

        return new
    end

    local function Update()
        for node in All:loop() do
            local itemSpawn = node.value
            for _, where in ipairs(itemSpawn.rects) do
                -- Only create an item if didn't surpassed their max
                if itemSpawn.count < itemSpawn.maxItems then
                    -- Create an item in a random position of the rect
                    local m = CreateItem(itemSpawn.types[math.random(#itemSpawn.types)], GetRandomReal(GetRectMinX(where), GetRectMaxX(where)), GetRandomReal(GetRectMinY(where), GetRectMaxY(where)))
                    Reference[m] = itemSpawn
                    itemSpawn.count = itemSpawn.count + 1
                end
            end
        end
    end

    -- Discount the item when is picked
    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_STACK_ITEM)
    TriggerAddAction(t, function ()
        local m
        if GetTriggerEventId() == EVENT_PLAYER_UNIT_PICKUP_ITEM then
            m = GetManipulatedItem()
        else
            m = BlzGetStackingItemSource()
        end
        local this = Reference[m]
        if this then
            Reference[m] = nil
            this.count = this.count - 1
        end
    end)
    -- Start update
    Timed.call(function ()
        Timed.echo(Update, INTERVAL)
    end)

    -- For GUI
    udg_ItemSpawnCreate = CreateTrigger()
    TriggerAddAction(udg_ItemSpawnCreate, function ()
        Create(udg_ItemSpawnRegions, udg_ItemSpawnTypes, udg_ItemSpawnMaxItems)
        udg_ItemSpawnRegions = {}
        udg_ItemSpawnTypes = {}
        udg_ItemSpawnMaxItems = 0
    end)
end)