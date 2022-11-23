OnInit("DummyCaster", function ()
    Require "WorldBounds"
    Require "Timed"

    -- System based on MUI DummyCaster

    -- Import the dummy from the object editor
    local DummyID = FourCC('n000')

    -- WARNING: Do not touch anything below this line!

    -- Default 3 values you may use, pick one as desired
    ---@enum CastType
    CastType = {
        IMMEDIATE = 0,
        POINT = 1,
        TARGET = 2
    }

    local Dummies = {}
    local Abilities = __jarray(0)

    local function GetDummy(player, x, y, angle)
        local dummy = table.remove(Dummies)
        if not dummy then
            dummy = CreateUnit(player, DummyID, x, y, angle)
        else
            ShowUnitShow(dummy)
            SetUnitOwner(dummy, player, false)
            SetUnitPosition(dummy, x, y)
            BlzSetUnitFacingEx(dummy, angle)
        end
        return dummy
    end

    local function RefreshDummy(dummy)
        ShowUnitHide(dummy)
        SetUnitPosition(dummy, WorldBounds.maxX, WorldBounds.maxY)
        UnitRemoveAbility(dummy, Abilities[dummy])
        Abilities[dummy] = nil
        table.insert(Dummies, dummy)
    end

    ---Casts a spell from a dummy caster, returns if the spell was successfully casted
    ---@param owner player
    ---@param x number
    ---@param y number
    ---@param abilId integer
    ---@param orderId integer
    ---@param level integer
    ---@param castType CastType
    ---@param tx? number | unit
    ---@param ty? number
    ---@return boolean
    function DummyCast(owner, x, y, abilId, orderId, level, castType, tx, ty)
        local angle = 0
        if castType == CastType.IMMEDIATE then
            if tx then
                error("Too much arguments", 2)
            end
        elseif castType == CastType.POINT then
            if not tx or not ty then
                error("You didn't set a target point", 2)
            elseif not type(tx) == "number" or not type(ty) == "number" then
                error("Invalid target", 2)
            end
            angle = math.atan(ty - y, tx - x)
        elseif castType == CastType.TARGET then
            if Wc3Type(tx) ~= "unit" then
                error("Invalid target", 2)
            end
            angle = math.atan(GetUnitX(tx) - y, GetUnitX(tx) - x)
        else
            error("Invalid target-type", 2)
        end
        local dummy = GetDummy(owner, x, y, angle)
        UnitAddAbility(dummy, abilId)
        SetUnitAbilityLevel(dummy, abilId, level)
        Abilities[dummy] = abilId
        local success = false
        if castType == CastType.IMMEDIATE then
            success = IssueImmediateOrderById(dummy, orderId)
        elseif castType == CastType.POINT then
            success = IssuePointOrderById(dummy, orderId, tx, ty)
        elseif castType == CastType.TARGET then
            success = IssueTargetOrderById(dummy, orderId, tx)
        end
        if not success then
            Timed.call(1., function ()
                RefreshDummy(dummy)
            end)
        end
        return success
    end

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_FINISH)
    TriggerAddAction(t, function ()
        if GetUnitTypeId(GetSpellAbilityUnit()) == DummyID then
            local u = GetSpellAbilityUnit()
            Timed.call(1., function ()
                RefreshDummy(u)
            end)
        end
    end)
end)