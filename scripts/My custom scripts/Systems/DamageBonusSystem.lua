if Debug then Debug.beginFile("DamageBonusSystem") end
OnInit("DamageBonusSystem", function ()
    Require "NewBonus"

    local Requirements = {} ---@type table<integer, integer>

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DROP_ITEM)
    TriggerAddAction(t, function ()
        local m = GetManipulatedItem()
        if Requirements[GetItemTypeId(m)] then
            AddUnitBonus(GetManipulatingUnit(), BONUS_DAMAGE,
            ((GetTriggerEventId() == EVENT_PLAYER_UNIT_PICKUP_ITEM) and 1 or -1) * Requirements[GetItemTypeId(m)])
        end
    end)

    ---@param itm integer | nil
    ---@param amount integer
    local function Create(itm, amount)
        if itm then
            Requirements[itm] = amount
        else
            error("DamageBonusSystem: not item was set in the system")
        end
    end

    udg_DamageBonusItem = nil

    udg_DamageBonusCreate = CreateTrigger()
    TriggerAddAction(udg_DamageBonusCreate, function ()
        Create(udg_DamageBonusItem, udg_DamageBonusAmount)
        udg_DamageBonusItem = nil
        udg_DamageBonusAmount = 0
    end)

    ---@param itm integer
    ---@return integer
    function GetItemDamageBonus(itm)
        return Requirements[itm] or 0
    end
end)
if Debug then Debug.endFile() end