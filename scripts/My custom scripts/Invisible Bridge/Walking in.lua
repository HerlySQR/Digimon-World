OnMapInit(function ()
    local place = gg_rct_Invisible_Bridge
    local feetModel = "war3mapImported\\GeneralHeroGlow.mdx"
    local stepModel = "Abilities\\Spells\\Human\\Brilliance\\Brilliance.mdl"
    local staticTimer ---@type function
    local effs = {}

    local t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, place)
    TriggerAddAction(t, function ()
        local u = GetEnteringUnit()
        MotionSensor.addUnit(u)
        local node = MotionSensor.get(u)
        effs[u] = {AddSpecialEffectTarget(feetModel, u, "right foot"), AddSpecialEffectTarget(feetModel, u, "left foot")}
        staticTimer = Timed.echo(function ()
            if node.moving then
                local e = AddSpecialEffect(stepModel, GetUnitX(u), GetUnitY(u))
                BlzSetSpecialEffectScale(e, 0.5)
                DestroyEffect(e)
            end
        end)
    end)

    t = CreateTrigger()
    TriggerRegisterLeaveRectSimple(t, place)
    TriggerAddAction(t, function ()
        local u = GetLeavingUnit()
        MotionSensor.removeUnit(u)
        pcall(staticTimer)
        DestroyEffect(effs[u][1])
        DestroyEffect(effs[u][2])
        effs[u] = {}
    end)
end)