OnLibraryInit({name = "TimedHandles", "Timed"}, function ()

    ---Destroys an effect after a while
    ---@param eff effect
    ---@param delay number
    function DestroyEffectTimed(eff, delay)
        Timed.call(delay, function () DestroyEffect(eff) end)
    end

    ---Destroys a lightning after a while
    ---@param l lightning
    ---@param delay number
    function DestroyLightningTimed(l, delay)
        Timed.call(delay, function () DestroyLightning(l) end)
    end

    ---Removes a weathereffect after a while
    ---@param we weathereffect
    ---@param delay number
    function RemoveWeatherEffectTimed(we, delay)
        Timed.call(delay, function () RemoveWeatherEffect(we) end)
    end

    ---Removes an item after a while
    ---@param m item
    ---@param delay number
    function RemoveItemTimed(m, delay)
        Timed.call(delay, function () RemoveItem(m) end)
    end

    ---Destroys an effect after a while
    ---@param eff effect
    ---@param delay number
    function DestroyEffectTimed(eff, delay)
        Timed.call(delay, function () DestroyEffect(eff) end)
    end

    ---Removes an unit after a while
    ---@param u unit
    ---@param delay number
    function RemoveUnitTimed(u, delay)
        Timed.call(delay, function () RemoveUnit(u) end)
    end

    ---Destroys an ubersplat after a while
    ---@param ub ubersplat
    ---@param delay number
    function DestroyUbersplatTimed(ub, delay)
        Timed.call(delay, function () DestroyUbersplat(ub) end)
    end

    ---Destroys a fogmodifier after a while
    ---@param f fogmodifier
    ---@param delay number
    function DestroyFogModifierTimed(f, delay)
        Timed.call(delay, function () DestroyFogModifier(f) end)
    end

end)