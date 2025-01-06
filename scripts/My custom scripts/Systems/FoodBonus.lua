Debug.beginFile("FoodBonus")
OnInit("FoodBonus", function ()
    Require "NewBonus"
    Require "Timed"
    Require "MDTable"
    Require "Digimon"

    local DURATION = udg_FOOD_BUFF_DURATION

    local elapsedTime = MDTable.create(2, 0) ---@type table<Digimon, table<integer, number>>

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
    ---@field bonusInfo BonusInfo
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
            local d = Digimon.getInstance(GetManipulatingUnit())

            if elapsedTime[d][info.buff] <= 0 then
                d:addAbility(info.buff)
                local function removeBuff()
                    for i = 1, #info.bonusType do
                        AddUnitBonus(d.root, info.bonusType[i], -info.amount[i])
                    end
                    if info.isDrink then
                        actualBuffDrink[d] = nil
                    else
                        actualBuffFood[d] = nil
                    end
                    d:removeAbility(info.buff)
                end

                local removeTimer = Timed.echo(0.2, function ()
                    elapsedTime[d][info.buff] = elapsedTime[d][info.buff] - 0.2
                    if elapsedTime[d][info.buff] <= 0 then
                        removeBuff()
                        return true
                    end
                end)

                if info.isDrink then
                    if actualBuffDrink[d] then
                        actualBuffDrink[d].removeTimer()
                        actualBuffDrink[d].removeBuff()
                    end
                    actualBuffDrink[d] = {
                        bonusInfo = info,
                        removeBuff = removeBuff,
                        removeTimer = removeTimer
                    }
                else
                    if actualBuffFood[d] then
                        actualBuffFood[d].removeTimer()
                        actualBuffFood[d].removeBuff()
                    end
                    actualBuffFood[d] = {
                        bonusInfo = info,
                        removeBuff = removeBuff,
                        removeTimer = removeTimer
                    }
                end

                for i = 1, #info.bonusType do
                    AddUnitBonus(d.root, info.bonusType[i], info.amount[i])
                end
            end
            elapsedTime[d][info.buff] = DURATION
        end
    end)

    Digimon.evolutionEvent:register(function (d, old)
        if actualBuffDrink[d] then
            local info = actualBuffDrink[d].bonusInfo

            UnitRemoveAbility(old, info.buff)
            for i = 1, #info.bonusType do
                AddUnitBonus(old, info.bonusType[i], -info.amount[i])
            end

            d:addAbility(info.buff)
            for i = 1, #info.bonusType do
                AddUnitBonus(d.root, info.bonusType[i], info.amount[i])
            end
        end

        if actualBuffFood[d] then
            local info = actualBuffFood[d].bonusInfo

            UnitRemoveAbility(old, info.buff)
            for i = 1, #info.bonusType do
                AddUnitBonus(old, info.bonusType[i], -info.amount[i])
            end

            d:addAbility(info.buff)
            for i = 1, #info.bonusType do
                AddUnitBonus(d.root, info.bonusType[i], info.amount[i])
            end
        end
    end)

    ---@param id integer
    ---@return boolean
    function IsItemFood(id)
        if bonuses[id] then
            return not bonuses[id].isDrink
        end
        return false
    end

    ---@param id integer
    ---@return boolean
    function IsItemDrink(id)
        if bonuses[id] then
            return bonuses[id].isDrink
        end
        return false
    end

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
Debug.endFile()