if Debug then Debug.beginFile("ItemDropSystem") end
OnInit(function ()
    Require "Timed"

    local instances = {} ---@type table<unit, {itempool: itempool, once: boolean}[]>

    ---Makes the creep have a chance of drop an item when it dies.
    ---If the weights is an empty table, then it will be assume that
    ---all the items will have the same weight.
    ---
    ---The optional boolean is to make the creep don't drop items again
    ---in case you wanna resurrect it
    ---@param creep unit
    ---@param items integer[]
    ---@param weights number[]
    ---@param once? boolean
    function AddItemDrop(creep, items, weights, once)
        if #items == 0 then
            error("You didn't add items", 2)
        end

        if #weights > 0 and #items ~= #weights then
            error("The number of items doesn't match with the number or weights", 2)
        end

        local new = {
            itempool = CreateItemPool(),
            once = once
        }
        local weight = #weights == 0 and 1

        for i = 1, #items do
            ItemPoolAddItemType(new.itempool, items[i], weight or weights[i])
        end

        if not instances[creep] then
            instances[creep] = {}
        end

        table.insert(instances[creep], new)
    end

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(t, function ()
        local list = instances[GetDyingUnit()]
        if list then
            for i = #list, 1, -1 do
                local ins = list[i]
                PlaceRandomItem(ins.itempool, GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()))

                if ins.once then
                    Timed.call(function ()
                        DestroyItemPool(ins.itempool)
                        table.remove(list, i)
                    end)
                end
            end

            if #list == 0 then
                instances[GetDyingUnit()] = nil
            end
        end
    end)

    ---@param creep unit
    function RerollItemDrop(creep)
        local list = instances[creep]
        if list then
            for i = #list, 1, -1 do
                PlaceRandomItem(list[i].itempool, GetUnitX(creep), GetUnitY(creep))
            end
        end
    end

    -- For GUI

    udg_ItemDropChances = __jarray(0) -- I need it empty

    udg_ItemDropAdd = CreateTrigger()
    TriggerAddAction(udg_ItemDropAdd, function ()
        AddItemDrop(udg_ItemDropCreep, udg_ItemDropTypes, udg_ItemDropWeights, udg_ItemDropOnce)
        udg_ItemDropCreep = nil
        udg_ItemDropTypes = __jarray(0)
        udg_ItemDropWeights = __jarray(0)
        udg_ItemDropOnce = nil
    end)

end)
if Debug then Debug.endFile() end