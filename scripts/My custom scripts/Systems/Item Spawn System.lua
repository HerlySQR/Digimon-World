OnInit(function ()
    local INTERVAL = 15.

    ---@class RectInfo
    ---@field rect rect
    ---@field amount integer
    ---@field parent ItemSpawnInfo

    ---@class ItemSpawnInfo
    ---@field rectInfos RectInfo[]
    ---@field types integer[]
    ---@field maxItems integer
    ---@field count integer

    local All = {} ---@type ItemSpawnInfo[]
    local Reference = {} ---@type table<item, RectInfo>

    ---@param rects rect[]
    ---@param types integer[]
    ---@param maxItems integer
    ---@return ItemSpawnInfo
    local function Create(rects, types, maxItems)
        local rectInfos = {}

        local new = {
            types = types,
            maxItems = maxItems,
            count = 0
        }

        for i = 1, #rects do
            rectInfos[i] = {
                rect = rects[i],
                amount = 0,
                parent = new
            }
        end

        new.rectInfos = rectInfos

        table.insert(All, new)

        return new
    end

    local function Update()
        for _, itemSpawn in ipairs(All) do
            for _, where in ipairs(itemSpawn.rectInfos) do
                -- Only create an item if didn't surpassed their max
                if itemSpawn.count < itemSpawn.maxItems then
                    -- Create an item in a random position of the rect
                    local m = CreateItem(itemSpawn.types[math.random(#itemSpawn.types)], GetRandomReal(GetRectMinX(where.rect), GetRectMaxX(where.rect)), GetRandomReal(GetRectMinY(where.rect), GetRectMaxY(where.rect)))
                    Reference[m] = where
                    itemSpawn.count = itemSpawn.count + 1
                    where.amount = where.amount + 1
                else
                    break
                end
            end
            if itemSpawn.maxItems - itemSpawn.count < #itemSpawn.rectInfos then
                table.sort(itemSpawn.rectInfos, function (a, b)
                    return a.amount < b.amount
                end)
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
            this.parent.count = this.parent.count - 1
            this.amount = this.amount - 1
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