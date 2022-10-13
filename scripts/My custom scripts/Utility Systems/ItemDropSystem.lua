do
    local instances = {}

    ---Makes the creep have a chance of drop an item when it dies.
    ---If the chances is an empty table, then it will be assume that
    ---all the items will have the same chance.
    ---
    ---The optional boolean is to make the creep don't drop items again
    ---in case you wanna resurrect it
    ---@param creep unit
    ---@param items integer[]
    ---@param chances number[]
    ---@param once? boolean
    function AddItemDrop(creep, items, chances, once)
        if #items == 0 then
            error("You didn't add items", 2)
        end

        if #chances > 0 and #items ~= #chances then
            error("The number of items don't matches with the number or chances", 2)
        end

        local sum = 0
        for i = 1, #chances do
            sum = sum + chances[i]
        end
        if sum > 1 then
            error("The sum of the chances are bigger than 1", 2)
        end

        local new = {
            itempool = CreateItemPool(),
            once = once
        }
        local max = #items
        local chance = #chances == 0 and 1/max

        for i = 1, max do
            ItemPoolAddItemType(new.itempool, items[i], chance or chances[i])
        end

        if not instances[creep] then
            instances[creep] = {}
        end

        table.insert(instances[creep], new)
    end

    OnTrigInit(function ()
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            local list = instances[GetDyingUnit()]
            if list then
                for i = #list, 1, -1 do
                    local ins = list[i]
                    PlaceRandomItem(ins.itempool, GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()))

                    if ins.once then
                        DestroyItemPool(ins.itempool)
                        table.remove(list, i)
                    end
                end

                if #list == 0 then
                    instances[GetDyingUnit()] = nil
                end
            end
        end)

        -- For GUI

        udg_ItemDropChances = __jarray(0) -- I need it empty

        udg_ItemDropAdd = CreateTrigger()
        TriggerAddAction(udg_ItemDropAdd, function ()
            AddItemDrop(udg_ItemDropCreep, udg_ItemDropTypes, udg_ItemDropChances, udg_ItemDropOnce)
            udg_ItemDropCreep = nil
            udg_ItemDropTypes = __jarray(0)
            udg_ItemDropChances = __jarray(0)
            udg_ItemDropOnce = nil
        end)
    end)

end