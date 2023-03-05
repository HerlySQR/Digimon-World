if Debug then Debug.beginFile("JumpSystem") end
OnInit("JumpSystem", function ()
    Require "Timed"

    local CROW_FORM = FourCC('Arav')

    ---@param jumper unit
    ---@param targetX number
    ---@param targetY number
    ---@param speed number
    ---@param highDistance number
    ---@param eff? string
    ---@param animation? string
    ---@param onFinish? function
    function Jump(jumper, targetX, targetY, speed, highDistance, eff, animation, onFinish)
        SetUnitPathing(jumper, false)
        if animation then
            SetUnitAnimation(jumper, animation)
        end
        UnitAddAbility(jumper, CROW_FORM)
        UnitRemoveAbility(jumper, CROW_FORM)

        speed = speed * 0.02
        highDistance = highDistance * 0.02
        local posX, posY = GetUnitX(jumper), GetUnitY(jumper)
        local distance = math.sqrt((posX - targetX)^2 + (posY - targetY)^2)
        local angle = math.atan(targetY - posY, targetX - posX)
        local reachedDistance = 0
        local realTimer = 0
        local realTimerDiff = math.pi / (distance / speed)
        local highSettings = highDistance * distance
        Timed.echo(0.02, function ()
            if reachedDistance < distance then
                if animation then
                    QueueUnitAnimation(jumper, animation)
                end
                local newX = GetUnitX(jumper) + speed * math.cos(angle)
                local newY = GetUnitY(jumper) + speed * math.sin(angle)
                SetUnitPosition(jumper, newX, newY)
                if eff and math.random(1, 5) == 1 then
                    DestroyEffect(AddSpecialEffectTarget(eff, jumper, "origin"))
                end
                realTimer = realTimer + realTimerDiff
                local jumpHigh = math.sin(realTimer) * highSettings
                SetUnitFlyHeight(jumper, jumpHigh, 1000000000)
                reachedDistance = reachedDistance + speed
            else
                SetUnitPathing(jumper, true)
                ResetUnitAnimation(jumper)
                if onFinish then
                    onFinish()
                end
                return true
            end
        end)
    end
end)
if Debug then Debug.endFile() end