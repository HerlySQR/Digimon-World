OnLibraryInit({name = "BossFightUtils", "AbilityUtils"}, function ()
    local castDelay = 5. -- seconds
    local isCasting = {} ---@type boolean[]

    ---Don't cast timed duration spells when other timed duration spell is casted
    ---@param caster unit
    ---@param flag boolean
    function BossIsCasting(caster, flag)
        if flag then
            isCasting[caster] = true
        else
            Timed.call(castDelay, function () isCasting[caster] = false end)
        end
    end

    ---@param caster unit
    ---@return boolean
    function BossStillCasting(caster)
        return isCasting[caster]
    end
end)