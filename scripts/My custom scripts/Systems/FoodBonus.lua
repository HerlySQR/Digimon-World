OnInit(function ()
    Require "NewBonus"
    Require "Timed"

    ---@class BonusInfo
    ---@field isDrink boolean
    ---@field bonusType integer[]
    ---@field amount number[]
    ---@field buff integer

    local bonusTypes = { ---@type table<string, integer>
        damage = BONUS_DAMAGE,
        armor = BONUS_ARMOR,
        agility = BONUS_AGILITY,
        strength = BONUS_STRENGTH,
        intelligence = BONUS_INTELLIGENCE,
        health = BONUS_HEALTH,
        mana = BONUS_MANA,
        movespeed = BONUS_MOVEMENT_SPEED,
        --sightrange = BONUS_SIGHT_RANGE,
        liferegen = BONUS_HEALTH_REGEN,
        manaregen = BONUS_MANA_REGEN,
        attackspeed = BONUS_ATTACK_SPEED
    }

    local bonuses = {} ---@type table<integer, BonusInfo>

    ---@class ActualBuffData
    ---@field buff integer
    ---@field removeBuff function
    ---@field removeTimer function

    local actualBuffFood = {} ---@type table<unit, ActualBuffData>
    local actualBuffDrink = {} ---@type table<unit, ActualBuffData>

    ---@param itm integer
    ---@param isDrink boolean
    ---@param bonusType string
    ---@param amount number
    ---@param buff integer
    local function RegisterBonus(itm, isDrink, bonusType, amount, buff)
        if not bonusTypes[bonusType] then
            error("invalid bonus type: " .. bonusType)
        end

        if not bonuses[itm] then
            bonuses[itm] = {
                isDrink = isDrink,
                bonusType = {bonusTypes[bonusType]},
                amount = {amount},
                buff = buff
            }
        else
            table.insert(bonuses[itm].bonusType, bonusTypes[bonusType])
            table.insert(bonuses[itm].amount, amount)
        end
    end

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local info = bonuses[GetItemTypeId(GetManipulatedItem())]
        if info then
            local u = GetManipulatingUnit()

            local function removeBuff()
                for i = 1, #info.bonusType do
                    AddUnitBonus(u, info.bonusType[i], -info.amount[i])
                end
                if info.isDrink then
                    actualBuffDrink[u] = nil
                else
                    actualBuffFood[u] = nil
                end
            end

            local removeTimer = Timed.echo(0.2, function ()
                if not UnitHasBuffBJ(u, info.buff) then
                    removeBuff()
                    return true
                end
            end)

            if info.isDrink then
                if actualBuffDrink[u] then
                    if info.buff ~= actualBuffDrink[u].buff then
                        UnitRemoveBuffBJ(actualBuffDrink[u].buff, u)
                    end
                    actualBuffDrink[u].removeTimer()
                    actualBuffDrink[u].removeBuff()
                end
                actualBuffDrink[u] = {
                    buff = info.buff,
                    removeBuff = removeBuff,
                    removeTimer = removeTimer
                }
            else
                if actualBuffFood[u] then
                    if info.buff ~= actualBuffFood[u].buff then
                        UnitRemoveBuffBJ(actualBuffFood[u].buff, u)
                    end
                    actualBuffFood[u].removeTimer()
                    actualBuffFood[u].removeBuff()
                end
                actualBuffFood[u] = {
                    buff = info.buff,
                    removeBuff = removeBuff,
                    removeTimer = removeTimer
                }
            end

            for i = 1, #info.bonusType do
                AddUnitBonus(u, info.bonusType[i], info.amount[i])
            end
        end
    end)

    OnInit.trig(function ()
        udg_FoodBonusAmountInt = nil
        udg_FoodBonusAmountReal = nil
        udg_FoodBonusCreate = CreateTrigger()
        TriggerAddAction(udg_FoodBonusCreate, function ()
            RegisterBonus(
                udg_FoodBonusItem,
                udg_FoodBonusIsDrink,
                udg_FoodBonusType,
                udg_FoodBonusAmountInt or udg_FoodBonusAmountReal,
                udg_FoodBonusBuff
            )
            udg_FoodBonusItem = 0
            udg_FoodBonusIsDrink = false
            udg_FoodBonusType = ""
            udg_FoodBonusAmountInt = nil
            udg_FoodBonusAmountReal = nil
            udg_FoodBonusBuff = 0
        end)
    end)
end)