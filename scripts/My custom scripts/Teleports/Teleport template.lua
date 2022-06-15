do
    local LocalPlayer = nil ---@type player

    ---Creates a new teleporter
    ---@param inner rect
    ---@param enterRect rect
    ---@param leaveRect rect
    ---@param enterTP location
    ---@param leaveTP location
    ---@param enterText string
    ---@param leaveText string
    function CreateTeleport(inner, outer, enterRect, leaveRect, enterTP, leaveTP, enterText, leaveText, enterMinimap, leaveMinimap)
        local enterX, enterY = GetLocationX(enterTP),  GetLocationY(enterTP)
        local leaveX, leaveY = GetLocationX(leaveTP),  GetLocationY(leaveTP)

        local innerEnv = Environment.create(enterText, inner, enterMinimap)
        local outerEnv = Environment.create(leaveText, outer, leaveMinimap)

        RemoveLocation(enterTP)
        RemoveLocation(leaveTP)

        -- Enter
        local t = CreateTrigger()
        TriggerRegisterEnterRectSimple(t, enterRect)
        TriggerAddAction(t, function ()
            local u = GetEnteringUnit()
            local p = GetOwningPlayer(u)
            SetUnitPosition(u, enterX, enterY)
            local d = Digimon.getInstance(u)
            if d then
                d.environment = innerEnv
            end
            if IsUnitSelected(u, p) then
                innerEnv:apply(p, true)
                if p == LocalPlayer then
                    PanCameraToTimed(enterX, enterY, 0)
                end
            end
        end)

        -- Leave
        t = CreateTrigger()
        TriggerRegisterEnterRectSimple(t, leaveRect)
        TriggerAddAction(t, function ()
            local u = GetEnteringUnit()
            local p = GetOwningPlayer(u)
            SetUnitPosition(u, leaveX, leaveY)
            local d = Digimon.getInstance(u)
            if d then
                d.environment = outerEnv
            end
            if IsUnitSelected(u, p) then
                outerEnv:apply(p, true)
                if p == LocalPlayer then
                    PanCameraToTimed(leaveX, leaveY, 0)
                end
            end
        end)
    end

    -- For GUI
    OnTrigInit(function ()
        udg_TP_Create = CreateTrigger()
        TriggerAddAction(udg_TP_Create, function ()
            CreateTeleport(
                udg_TP_Inner,
                udg_TP_Outer,
                udg_TP_EnterRect,
                udg_TP_LeaveRect,
                udg_TP_EnterPoint,
                udg_TP_LeavePoint,
                udg_TP_EnterText,
                udg_TP_LeaveText,
                udg_TP_EnterMinimap,
                udg_TP_LeaveMinimap
            )
            udg_TP_Inner = nil
            udg_TP_Outer = nil
            udg_TP_EnterRect = nil
            udg_TP_LeaveRect = nil
            udg_TP_EnterPoint = nil
            udg_TP_LeavePoint = nil
            udg_TP_EnterText = nil
            udg_TP_LeaveText = nil
            udg_TP_EnterMinimap = nil
            udg_TP_LeaveMinimap = nil
        end)

        LocalPlayer = GetLocalPlayer()
    end)
end