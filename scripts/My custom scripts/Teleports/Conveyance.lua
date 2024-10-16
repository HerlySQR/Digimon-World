Debug.beginFile("Conveyance")
OnInit(function ()
    Require "Digimon"
    Require "Transmission"
    Require "Menu"

    local LocalPlayer = GetLocalPlayer()

    local WHAMON = FourCC('N009')

    local whamonCams = {gg_cam_WhamonCam1, gg_cam_WhamonCam2} ---@type camerasetup[]
    local whamonPos = {CameraSetupGetDestPositionLoc(gg_cam_WhamonCam1), CameraSetupGetDestPositionLoc(gg_cam_WhamonCam2)}
    for i = 1, 2 do
        MoveLocation(whamonPos[i], GetLocationX(whamonPos[i]), GetLocationY(whamonPos[i]) - 128.)
    end
    local whamonModel = "war3mapImported\\Whamon2.mdl"
    local whamonDist = math.abs(CameraSetupGetDestPositionX(gg_cam_WhamonCam1) - CameraSetupGetDestPositionX(gg_cam_WhamonCam2))
    local whamonStep = whamonDist * 0.02
    OnInit.final(function ()
        ForForce(FORCE_PLAYING, function ()
            CreateFogModifierRectBJ(true, GetEnumPlayer(), FOG_OF_WAR_VISIBLE, gg_rct_WhamonAnimation)
        end)
    end)

    ---@param ticket integer
    ---@param receiver location
    ---@param envName string
    ---@param level integer
    ---@param noLevelDialog integer
    local function Create(ticket, receiver, envName, level, noLevelDialog)
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SELL_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetSoldItem()) == ticket end))
        TriggerAddAction(t, function ()
            local d = Digimon.getInstance(GetBuyingUnit())
            local p = d:getOwner()

            if level > 0 and d:getLevel() < level then
                if noLevelDialog > 0 then
                    udg_TalkId = noLevelDialog
                    udg_TalkTo = d.root
                    udg_TalkToForce = Force(p)
                    TriggerExecute(udg_TalkRun)
                end
                return
            end

            local typ = GetUnitTypeId(GetTriggerUnit())
            local inTran = false

            d:hide()
            d:setLoc(receiver)
            d.environment = Environment.get(envName)
            if typ == WHAMON then
                local pos1 = math.random(2)
                local pos2 = pos1 == 1 and 2 or 1

                local root = ""
                if p == LocalPlayer then
                    root = whamonModel
                end
                local whamon = AddSpecialEffectLoc(root, whamonPos[pos1])
                BlzSetSpecialEffectYaw(whamon, pos1 == 1 and 0 or math.pi)

                Environment.whamonAnimation:apply(p, true)

                if p == LocalPlayer then
                    inTran = true
                    SaveCameraSetup()
                    HideMenu(true)
                    CameraSetupApplyForceDuration(whamonCams[pos1], true, 0)
                end
                PolledWait(0.02)
                if p == LocalPlayer then
                    CameraSetupApplyForceDuration(whamonCams[pos2], true, 1.)
                end
                local step = pos1 == 1 and whamonStep or -whamonStep
                Timed.echo(0.02, 1.26, function ()
                    BlzSetSpecialEffectX(whamon, BlzGetLocalSpecialEffectX(whamon) + step)
                end, function ()
                    BlzSetSpecialEffectAlpha(whamon, 0)
                    DestroyEffect(whamon)
                end)
                PolledWait(1.)
            end
            Environment.apply(envName, p, true)
            if p == LocalPlayer then
                if inTran then
                    ShowMenu(true)
                    RestartToPreviousCamera()
                end
                PanCameraToTimed(d:getX(), d:getY(), 0)
            end
            Timed.call(0.25, function ()
                d:show()
            end)
        end)
    end

    udg_ConveyanceCreate = CreateTrigger()
    TriggerAddAction(udg_ConveyanceCreate, function ()
        Create(
            udg_ConveyanceTicket,
            udg_ConveyanceReceiver,
            udg_ConveyanceNewEnvName,
            udg_ConveyanceLevel,
            udg_ConveyanceNoLevelDialog
        )
        udg_ConveyanceTicket = 0
        udg_ConveyanceReceiver = nil
        udg_ConveyanceNewEnvName = ""
        udg_ConveyanceLevel = 0
        udg_ConveyanceNoLevelDialog = 0
    end)
end)
Debug.endFile()