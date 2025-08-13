if Debug then Debug.beginFile("DummyCaster") end
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
                error("Invalid target (".. tostring(tx) .. "," .. tostring(ty) .. ")", 2)
            end
            angle = math.atan(ty - y, tx - x)
        elseif castType == CastType.TARGET then
            if Wc3Type(tx) ~= "unit" then
                error("Invalid target (".. tostring(tx) .. ")", 2)
            end
            angle = math.atan(GetUnitY(tx) - y, GetUnitX(tx) - x)
        else
            error("Invalid target-type", 2)
        end

        local dummy = CreateUnit(owner, DummyID, x, y, angle)
        UnitAddAbility(dummy, abilId)
        SetUnitAbilityLevel(dummy, abilId, level)

        local success = false
        if castType == CastType.IMMEDIATE then
            success = IssueImmediateOrderById(dummy, orderId)
        elseif castType == CastType.POINT then
            success = IssuePointOrderById(dummy, orderId, tx, ty)
        elseif castType == CastType.TARGET then
            success = IssueTargetOrderById(dummy, orderId, tx)
        end

        UnitApplyTimedLife(dummy, FourCC("BTLF"), 5.)

        return success
    end
end)
if Debug then Debug.endFile() end