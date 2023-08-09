if Debug then Debug.beginFile("AbilityEvent") end
OnInit.main("AbilityEvent", function ()
    Require "EventListener"
    Require "SyncedTable"

    --[[
        Decide yourself if you want to use hooks or UnitAddAbilityEx and 
        UnitRemoveAbilityEx instead of the calling UnitAddAbility and 
        UnitRemoveAbility.
    ]]
    local USE_HOOKS  = true

    local addEvent = EventListener.create()
    local removeEvent = EventListener.create()
    local skillEvent = EventListener.create()

    ---Happens when the ability is added to the unit
    ---@overload fun(callback: fun(u: unit, id: integer?))
    ---@param abilityId integer
    ---@param callback fun(u: unit, id: integer?)
    function OnAddAbility(abilityId, callback)
        if not callback then
            callback = abilityId
            abilityId = nil
        end
        addEvent:register(callback)
    end

    ---Happens when the ability is removed to the unit
    ---@overload fun(callback: fun(u: unit, id: integer?))
    ---@param abilityId integer
    ---@param callback fun(u: unit, id: integer?)
    function OnRemoveAbility(abilityId, callback)
        if not callback then
            callback = abilityId
            abilityId = nil
        end
        removeEvent:register(callback)
    end

    ---Happens when the ability is skilled by a hero
    ---@overload fun(callback: fun(u: unit, id: integer?))
    ---@param abilityId integer
    ---@param callback fun(u: unit, id: integer?)
    function OnSkillAbility(abilityId, callback)
        if not callback then
            callback = abilityId
            abilityId = nil
        end
        skillEvent:register(callback)
    end

    if USE_HOOKS then
        Require "AddHook"

        local oldUnitAddAbility
        oldUnitAddAbility = AddHook("UnitAddAbility", function (u, id)
            addEvent:run(u, id)
            return oldUnitAddAbility(u, id)
        end)

        local oldUnitRemoveAbility
        oldUnitRemoveAbility = AddHook("UnitRemoveAbility", function (u, id)
            removeEvent:run(u, id)
            return oldUnitRemoveAbility(u, id)
        end)
    end
end)
if Debug then Debug.endFile() end