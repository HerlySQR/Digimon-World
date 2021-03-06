if OnGlobalInit and WorldBounds and Timed then
    -- System based on MUI DummyCaster

    -- Import the dummy from the object editor
    local DummyID = FourCC('n000')

    -- WARNING: Do not touch anything below this line!

    -- Default 3 values you may use, pick one as desired
    ---@class CastType
    CastType = {
        IMMEDIATE = 0,  ---@type CastType
        POINT = 1,      ---@type CastType
        TARGET = 2      ---@type CastType
    }

    local Dummies = {}
    local Abilities = {}

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

    ---Casts a spell from a dummy caster
    ---@param owner player
    ---@param x real
    ---@param y real
    ---@param abilId integer
    ---@param orderId integer
    ---@param level integer
    ---@param castType CastType
    ---@param tx? real | unit
    ---@param ty? real
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
            angle = math.atan(GetWidgetX(tx) - y, GetWidgetY(tx) - x)
        else
            error("Invalid target-type", 2)
        end
        local dummy = GetDummy(owner, x, y, angle)
        UnitAddAbility(dummy, abilId)
        SetUnitAbilityLevel(dummy, abilId, level)
        Abilities[dummy] = abilId
        if castType == CastType.IMMEDIATE then
            IssueImmediateOrderById(dummy, orderId)
        elseif castType == CastType.POINT then
            IssuePointOrderById(dummy, orderId, tx, ty)
        elseif castType == CastType.TARGET then
            IssueTargetOrderById(dummy, orderId, tx)
        end
    end

    OnMapInit(function ()
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
end