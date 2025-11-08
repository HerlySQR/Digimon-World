Debug.beginFile("ShowThreat")
OnInit(function ()
    Require "Threat System"
    Require "Menu"
    Require "AbilityUtils"

    local LocalPlayer = GetLocalPlayer()

    local ThreatBackdrop = nil ---@type framehandle
    local ThreatBoss = nil ---@type framehandle
    local ThreatArrow = nil ---@type framehandle
    local ThreatPlayerUnitT = {} ---@type framehandle[]
    local ThreatPlayerUnitPercent = {} ---@type framehandle[]
    local HealthBar = {} ---@type framehandle[]

    local bosses = {} ---@type unit[]
    local canSee = CreateForce()
    local units = {}
    local colors = {
        "ff00ff",
        "ffff00",
        "00ff00",
        "ffffff"
    }
    local red = Color.new(0xFF0000)
    local green = Color.new(0x00FF00)
    --local speedMove = 0.005
    --local speedAlpha = 8

    ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
        if GetHandleId(GetUnitRace(u)) == 11 and IsUnitType(u, UNIT_TYPE_HERO) then
            table.insert(bosses, u)
        end
    end)

    Timed.echo(1., function ()
        BlzFrameSetVisible(ThreatBackdrop, false)
        for j = 0, 3 do
            BlzFrameSetVisible(HealthBar[j], false)
        end
        for i = 1, #bosses do
            local boss = bosses[i]
            local totalThreat = 0
            for j = 1, 4 do
                local u = Threat.getSlotUnit(boss, j)
                if u then
                    ForceAddPlayer(canSee, GetOwningPlayer(u))
                end
                units[j] = u
                totalThreat = totalThreat + Threat.getUnitAmount(boss, u)
            end
            if IsPlayerInForce(LocalPlayer, canSee) then
                BlzFrameSetVisible(ThreatBackdrop, true)
                BlzFrameSetTexture(ThreatBoss, BlzGetAbilityIcon(GetUnitTypeId(boss)), 0, true)
                for j = 0, 3 do
                    local u = units[j+1] -- I don't know why they are in inverse order
                    if u then
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], true)
                        BlzFrameSetTexture(ThreatPlayerUnitT[j], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)
                        if #units == 0 then
                            BlzFrameSetVisible(ThreatPlayerUnitPercent[j], false)
                        else
                            BlzFrameSetVisible(ThreatPlayerUnitPercent[j], true)
                            BlzFrameSetText(ThreatPlayerUnitPercent[j], "|cff" .. colors[j+1] .. math.floor(Threat.getUnitAmount(boss, u)/totalThreat * 100) .. "\x25|r")
                        end

                        local ratio = GetUnitHPRatio(u)
                        BlzFrameSetVertexColor(HealthBar[j], ILerpColors(red, ratio, green))
                        BlzFrameSetValue(HealthBar[j], math.round(ratio*100))
                    else
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], false)
                    end
                    BlzFrameSetVisible(ThreatPlayerUnitPercent[j], BlzFrameIsVisible(ThreatPlayerUnitT[j]))
                    BlzFrameSetVisible(HealthBar[j], BlzFrameIsVisible(ThreatPlayerUnitT[j]))
                end
            end
            ForceClear(canSee)
        end
    end)

    FrameLoaderAdd(function ()
        ThreatBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.575000)
        BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.120000, 0.540000)
        AddFrameToMenu(ThreatBackdrop)
        BlzFrameSetVisible(ThreatBackdrop, false)

        ThreatBoss = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
        BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.0075000, -0.0075000)
        BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.092500, 0.0075000)
        BlzFrameSetTexture(ThreatBoss, "", 0, true)

        ThreatArrow = BlzCreateFrameByType("TEXT", "name", ThreatBackdrop, "", 0)
        BlzFrameSetScale(ThreatArrow, 2.00)
        BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_TOPLEFT, 0.0300000, 0.567500)
        BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.547500)
        BlzFrameSetText(ThreatArrow, "|cffFFCC00->|r")
        BlzFrameSetTextAlignment(ThreatArrow, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        for i = 0, 3 do
            ThreatPlayerUnitT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
            BlzFrameSetPoint(ThreatPlayerUnitT[i], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.052500 + i*0.02, -0.0075000)
            BlzFrameSetPoint(ThreatPlayerUnitT[i], FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.047500 + i*0.02, 0.0075000)
            BlzFrameSetSize(ThreatPlayerUnitT[i], 0.04, 0.04)
            BlzFrameSetTexture(ThreatPlayerUnitT[i], "", 0, true)
            BlzFrameSetAlpha(ThreatPlayerUnitT[i], 255 * (3-i) // 3)

            ThreatPlayerUnitPercent[i] = BlzCreateFrameByType("TEXT", "name", ThreatBackdrop, "", 0)
            BlzFrameSetScale(ThreatPlayerUnitPercent[i], 0.90)
            BlzFrameSetAllPoints(ThreatPlayerUnitPercent[i], ThreatPlayerUnitT[i])
            BlzFrameSetText(ThreatPlayerUnitPercent[i], "0\x25")
            BlzFrameSetTextAlignment(ThreatPlayerUnitPercent[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            HealthBar[i] = BlzCreateFrameByType("SIMPLESTATUSBAR", "", ThreatPlayerUnitT[i], "", 0)
            BlzFrameSetTexture(HealthBar[i], "replaceabletextures\\teamcolor\\teamcolor21", 0, true)
            BlzFrameSetPoint(HealthBar[i], FRAMEPOINT_TOPLEFT, ThreatPlayerUnitT[i], FRAMEPOINT_TOPLEFT, 0.0010000, -0.020500)
            BlzFrameSetPoint(HealthBar[i], FRAMEPOINT_BOTTOMRIGHT, ThreatPlayerUnitT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0015000, -0.0050000)
            BlzFrameSetMinMaxValue(HealthBar[i], 0, 100)
            BlzFrameSetValue(HealthBar[i], 50)
            BlzFrameSetVisible(HealthBar[i], false)
        end
    end)
end)
Debug.endFile()