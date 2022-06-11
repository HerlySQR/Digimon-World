if Timed then

    ---Destroys an effect after a while
    ---@param eff effect
    ---@param delay real
    function DestroyEffectTimed(eff, delay)
        Timed.call(delay, function () DestroyEffect(eff) end)
    end

    ---Destroys a lightning after a while
    ---@param l lightning
    ---@param delay real
    function DestroyLightningTimed(l, delay)
        Timed.call(delay, function () DestroyLightning(l) end)
    end

    ---Removes a weathereffect after a while
    ---@param we weathereffect
    ---@param delay real
    function RemoveWeatherEffectTimed(we, delay)
        Timed.call(delay, function () RemoveWeatherEffect(we) end)
    end

    ---Removes an item after a while
    ---@param m item
    ---@param delay real
    function RemoveItemTimed(m, delay)
        Timed.call(delay, function () RemoveItem(m) end)
    end

    ---Destroys an effect after a while
    ---@param eff effect
    ---@param delay real
    function DestroyEffectTimed(eff, delay)
        Timed.call(delay, function () DestroyEffect(eff) end)
    end

    ---Removes an unit after a while
    ---@param u unit
    ---@param delay real
    function RemoveUnitTimed(u, delay)
        Timed.call(delay, function () RemoveUnit(u) end)
    end

    ---Destroys an ubersplat after a while
    ---@param ub ubersplat
    ---@param delay real
    function DestroyUbersplatTimed(ub, delay)
        Timed.call(delay, function () DestroyUbersplat(ub) end)
    end

    ---Destroys a fogmodifier after a while
    ---@param f fogmodifier
    ---@param delay real
    function DestroyFogModifierTimed(f, delay)
        Timed.call(delay, function () DestroyFogModifier(f) end)
    end

end