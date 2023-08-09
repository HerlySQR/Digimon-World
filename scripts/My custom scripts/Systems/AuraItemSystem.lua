if Debug then Debug.beginFile("AuraItemSystem") end
OnInit.main("AuraItemSystem", function ()

    local Requirements = {} ---@type table<integer, {[1]: integer[] , [2]: integer}>

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DROP_ITEM)
    TriggerAddAction(t, function ()
        local typ = GetItemTypeId(GetManipulatedItem())
        if Requirements[typ] then
            local requirements = Requirements[typ]
            local u = GetManipulatingUnit()

            for i = 1, #requirements[1] do
                if not UnitHasItemOfTypeBJ(u, requirements[1][i]) then
                    if GetUnitAbilityLevel(u, requirements[2]) > 0 then
                        UnitRemoveAbility(u, requirements[2])
                    end
                    return
                end
            end

            UnitAddAbility(u, requirements[2])
        end
    end)

    ---@param types integer[]
    ---@param spell integer
    local function Create(types, spell)
        local instance = {types, spell}
        for i = 1, #types do
            Requirements[types[i]] = instance
        end
    end

    udg_AuraItemCreate = CreateTrigger()
    TriggerAddAction(udg_AuraItemCreate, function ()
        Create(udg_AuraItemTypes, udg_AuraItemSpell)
        udg_AuraItemTypes = __jarray(0)
        udg_AuraItemSpell = 0
    end)
end)
if Debug then Debug.endFile() end