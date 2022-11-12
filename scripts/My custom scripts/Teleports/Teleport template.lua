OnInit(function ()
    Require "Digimon"

    local LocalPlayer = GetLocalPlayer() ---@type player

    ---Creates a new teleporter
    ---@param enterRect rect
    ---@param leaveRect rect
    ---@param enterTP location
    ---@param leaveTP location
    ---@param enterText string
    ---@param leaveText string
    local function CreateTeleport(enterRect, leaveRect, enterTP, leaveTP, enterText, leaveText)
        local enterX, enterY = GetLocationX(enterTP), GetLocationY(enterTP)
        local leaveX, leaveY = GetLocationX(leaveTP), GetLocationY(leaveTP)

        local innerEnv = Environment.get(enterText)
        local outerEnv = Environment.get(leaveText)

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
    udg_TP_Create = CreateTrigger()
    TriggerAddAction(udg_TP_Create, function ()
        CreateTeleport(
            udg_TP_EnterRect,
            udg_TP_LeaveRect,
            udg_TP_EnterPoint,
            udg_TP_LeavePoint,
            udg_TP_EnterText,
            udg_TP_LeaveText
        )
        udg_TP_EnterRect = nil
        udg_TP_LeaveRect = nil
        udg_TP_EnterPoint = nil
        udg_TP_LeavePoint = nil
        udg_TP_EnterText = nil
        udg_TP_LeaveText = nil
    end)
end)