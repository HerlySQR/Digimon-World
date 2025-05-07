Debug.beginFile("Rare Data")
OnInit("Rare Data", function ()
    Require "Backpack"
    Require "ErrorMessage"

    local Items = {} ---@type table<integer, {cost: integer, goldCost: integer, woodCost: integer}>

    local itemGot = EventListener.create()

    ---@param func fun(u: unit, itm: integer)
    function OnRareDataItemGot(func)
        itemGot:register(func)
    end

    ---@param itm integer
    ---@param cost integer
    local function Define(itm, cost, goldCost, woodCost)
        Items[itm] = {
            cost = cost,
            goldCost = goldCost,
            woodCost = woodCost
        }
    end

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELL_ITEM)
    TriggerAddAction(t, function ()
        local id = GetItemTypeId(GetSoldItem())
        if Items[id] then
            local p = GetOwningPlayer(GetBuyingUnit())
            local rareDataCount = GetBackpackItemCharges(p, udg_RARE_DATA)
            if rareDataCount >= Items[id].cost then
                SetBackpackItemCharges(p, udg_RARE_DATA, rareDataCount - Items[id].cost)
                itemGot:run(GetBuyingUnit(), id)
            else
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + Items[id].goldCost)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + Items[id].woodCost)
                RemoveItem(GetSoldItem())
                ErrorMessage("Not enough rare data.", p)
            end
        end
    end)

    udg_RareDataDefine = CreateTrigger()
    TriggerAddAction(udg_RareDataDefine, function ()
        Define(udg_RareDataItem, udg_RareDataCost, udg_RareDataItemGoldCost, udg_RareDataItemWoodCost)
        udg_RareDataItem = 0
        udg_RareDataCost = 0
        udg_RareDataItemGoldCost = 0
        udg_RareDataItemWoodCost = 0
    end)
end)
Debug.endFile()