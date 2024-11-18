Debug.beginFile("Teleport template")
OnInit(function ()
    Require "Digimon"
    Require "DigimonBank"
    Require "GameStatus"

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
        local innerEnv = Environment.get(enterText)
        RemoveLocation(enterTP)

        -- Enter
        local t = CreateTrigger()
        TriggerRegisterEnterRectSimple(t, enterRect)
        TriggerAddAction(t, function ()
            local u = GetEnteringUnit()
            local p = GetOwningPlayer(u)

            if not IsPlayerInGame(p) then
                return
            end

            SetUnitPosition(u, enterX, enterY)
            local d = Digimon.getInstance(u)
            if d then
                d.environment = innerEnv
            end

            StoreAllDigimons(p, true, d)

            if innerEnv:apply(p, true) and p == LocalPlayer then
                PanCameraToTimed(enterX, enterY, 0)
            end
        end)

        -- Leave
        if leaveRect and leaveTP and leaveText then
            local leaveX, leaveY = GetLocationX(leaveTP), GetLocationY(leaveTP)
            local outerEnv = Environment.get(leaveText)
            RemoveLocation(leaveTP)

            t = CreateTrigger()
            TriggerRegisterEnterRectSimple(t, leaveRect)
            TriggerAddAction(t, function ()
                local u = GetEnteringUnit()
                local p = GetOwningPlayer(u)

                if not IsPlayerInGame(p) then
                    return
                end

                SetUnitPosition(u, leaveX, leaveY)
                local d = Digimon.getInstance(u)
                if d then
                    d.environment = outerEnv
                end

                StoreAllDigimons(p, true, d)

                if outerEnv:apply(p, true) and p == LocalPlayer then
                    PanCameraToTimed(leaveX, leaveY, 0)
                end
            end)
        end
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
Debug.endFile()