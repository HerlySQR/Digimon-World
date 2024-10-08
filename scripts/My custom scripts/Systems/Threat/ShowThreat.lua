Debug.beginFile("ShowThreat")
OnInit(function ()
    Require "ZTS"
    Require "Menu"
    Require "AbilityUtils"

    local LocalPlayer = GetLocalPlayer()

    local ThreatBackdrop = nil ---@type framehandle
    local ThreatBoss = nil ---@type framehandle
    local ThreatArrow = nil ---@type framehandle
    local ThreatPlayerUnitT = {} ---@type framehandle[]
    local ThreatPlayerUnitPercent = {} ---@type framehandle[]

    local bosses = {} ---@type unit[]
    local canSee = CreateForce()
    local units = {}
    local colors = {
        [0] = "ff00ff",
        "ffff00",
        "00ff00",
        "ffffff"
    }
    --local speedMove = 0.005
    --local speedAlpha = 8

    ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
        if GetHandleId(GetUnitRace(u)) == 11 and IsUnitType(u, UNIT_TYPE_HERO) then
            table.insert(bosses, u)
        end
    end)

    Timed.echo(1., function ()
        BlzFrameSetVisible(ThreatBackdrop, false)
        for i = 1, #bosses do
            local boss = bosses[i]
            local attackers = ZTS_GetAttackers(boss)
            local totalThreat = 0
            for j = 0, 3 do
                local u = BlzGroupUnitAt(attackers, j)
                if u then
                    ForceAddPlayer(canSee, GetOwningPlayer(u))
                end
                units[j] = u
                totalThreat = totalThreat + ZTS_GetThreatUnitAmount(boss, u)
            end
            DestroyGroup(attackers)
            if IsPlayerInForce(LocalPlayer, canSee) then
                BlzFrameSetVisible(ThreatBackdrop, true)
                BlzFrameSetTexture(ThreatBoss, BlzGetAbilityIcon(GetUnitTypeId(boss)), 0, true)
                for j = 0, 3 do
                    local u = units[#units-j] -- I don't know why they are in inverse order
                    if u then
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], true)
                        BlzFrameSetTexture(ThreatPlayerUnitT[j], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)
                        if #units == 0 then
                            BlzFrameSetVisible(ThreatPlayerUnitPercent[j], false)
                        else
                            BlzFrameSetVisible(ThreatPlayerUnitPercent[j], true)
                            BlzFrameSetText(ThreatPlayerUnitPercent[j], "|cff" .. colors[j] .. math.floor(ZTS_GetThreatUnitAmount(boss, u)/totalThreat * 100) .. "\x25|r")
                        end
                    else
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], false)
                    end
                    BlzFrameSetVisible(ThreatPlayerUnitPercent[j], BlzFrameIsVisible(ThreatPlayerUnitT[j]))
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
        end
    end)
end)
Debug.endFile()