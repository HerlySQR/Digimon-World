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

    local bosses = {} ---@type unit[]
    local canSee = CreateForce()
    local units = {}
    --local speedMove = 0.005
    --local speedAlpha = 8

    ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
        if GetUnitRace(u) == RACE_OTHER and IsUnitType(u, UNIT_TYPE_HERO) then
            table.insert(bosses, u)
        end
    end)

    Timed.echo(0.1, function ()
        BlzFrameSetVisible(ThreatBackdrop, false)
        for i = 1, #bosses do
            local boss = bosses[i]
            for j = 0, 3 do
                local u = ZTS_GetThreatSlotUnit(boss, j)
                if u then
                    ForceAddPlayer(canSee, GetOwningPlayer(u))
                end
                units[j] = u
            end
            if IsPlayerInForce(LocalPlayer, canSee) then
                BlzFrameSetVisible(ThreatBackdrop, true)
                BlzFrameSetTexture(ThreatBoss, BlzGetAbilityIcon(GetUnitTypeId(boss)), 0, true)
                for j = 0, 3 do
                    local u = units[j]
                    if u then
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], true)
                        BlzFrameSetTexture(ThreatPlayerUnitT[j], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)
                    else
                        BlzFrameSetVisible(ThreatPlayerUnitT[j], false)
                    end
                end
            end
            ForceClear(canSee)
        end
    end)

    FrameLoaderAdd(function ()
        ThreatBackdrop = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
        BlzFrameSetAbsPoint(ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.230000, 0.520000)
        AddFrameToMenu(ThreatBackdrop)
        BlzFrameSetVisible(ThreatBackdrop, false)

        ThreatBoss = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
        BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(ThreatBoss, FRAMEPOINT_BOTTOMRIGHT, ThreatBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.18500, 0.0050000)
        BlzFrameSetTexture(ThreatBoss, "", 0, true)

        ThreatArrow = BlzCreateFrameByType("TEXT", "name", ThreatBackdrop, "", 0)
        BlzFrameSetScale(ThreatArrow, 4.57)
        BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_TOPLEFT, 0.0500000, 0.570000)
        BlzFrameSetAbsPoint(ThreatArrow, FRAMEPOINT_BOTTOMRIGHT, 0.100000, 0.520000)
        BlzFrameSetText(ThreatArrow, "|cffFFCC00→|r")
        BlzFrameSetEnable(ThreatArrow, false)
        BlzFrameSetTextAlignment(ThreatArrow, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        for i = 0, 3 do
            ThreatPlayerUnitT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ThreatBackdrop, "", 1)
            BlzFrameSetPoint(ThreatPlayerUnitT[i], FRAMEPOINT_TOPLEFT, ThreatBackdrop, FRAMEPOINT_TOPLEFT, 0.10500 + i*0.05, -0.0050000)
            BlzFrameSetSize(ThreatPlayerUnitT[i], 0.05, 0.05)
            BlzFrameSetTexture(ThreatPlayerUnitT[i], "", 0, true)
            BlzFrameSetAlpha(ThreatPlayerUnitT[i], 255 * (3-i) // 3)
        end
    end)
end)
Debug.endFile()