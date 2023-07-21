if Debug then Debug.beginFile("AbilityEvent") end
OnInit("AbilityEvent", function ()
    Require "EventListener"

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
        addEvent:register(callback)
    end
end)
if Debug then Debug.endFile() end