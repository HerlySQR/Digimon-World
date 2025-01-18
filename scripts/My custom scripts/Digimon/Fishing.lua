Debug.beginFile("Fishing")
OnInit(function ()
    Require "AbilityUtils"
    Require "RegisterSpellEffectEvent"
    Require "ErrorMessage"
    Require "FrameLoader"

    local ROD = FourCC('I07M')
    local FISHING = FourCC('A0IL')
    local FISH = FourCC('I07N')
    local RED_LINE_STEPS = 48
    local GREEN_AREA_START = 22
    local GREEN_AREA_END = 27

    ---@alias catchState
    ---| 0 # None
    ---| 1 # Success
    ---| 2 # Fail

    local LocalPlayer = GetLocalPlayer()
    local fishers = {} ---@type table<player, unit[]>
    local fishing = __jarray(false) ---@type table<unit, boolean>
    local lines = {} ---@type table<unit, lightning>
    local linePos = __jarray(0) ---@type table<unit, integer>
    local catch = __jarray(0) ---@type table<unit, catchState>
    local usedRedLine = __jarray(0) ---@type table<unit, integer>
    local allowedRedLine = __jarray(true) ---@type table<integer, boolean>

    local FishBackdrop = nil ---@type framehandle
    local ProgressBar = nil ---@type framehandle
    local Ready = nil ---@type framehandle
    local BackdropReady = nil ---@type framehandle
    local RedLines = {} ---@type framehandle[]
    local Fisher = {} ---@type framehandle[]
    local GreenArea = nil ---@type framehandle

    for i = 0, bj_MAX_PLAYERS - 1 do
        fishers[Player(i)] = {}
    end

    ---@param u unit
    local function abortFish(u)
        if fishing[u] then
            fishing[u] = false
            if lines[u] then
                DestroyLightning(lines[u])
                lines[u] = nil
            end
            UnitAbortCurrentOrder(u)
            local p = GetOwningPlayer(u)
            for i = #fishers[p], 1, -1 do
                if fishers[p][i] == u then
                    table.remove(fishers[p], i)
                    break
                end
            end
            if p == LocalPlayer then
                BlzFrameSetVisible(RedLines[usedRedLine[u]], false)
                if #fishers[p] == 0 then
                    BlzFrameSetVisible(FishBackdrop, false)
                end
                allowedRedLine[usedRedLine[u]] = true
                usedRedLine[u] = 0
            end
            catch[u] = 0
        end
    end

    ---@param u unit
    ---@param p player
    ---@param line lightning
    local function startFishing(u, p, line)
        Timed.call(2 + 2*math.random(), function ()
            if lines[u] ~= line then
                return
            end

            local index = 0
            if p == LocalPlayer then
                index = usedRedLine[u]
                BlzFrameSetVisible(FishBackdrop, true)
                BlzFrameSetPoint(RedLines[index], FRAMEPOINT_LEFT, ProgressBar, FRAMEPOINT_LEFT,  0.000, 0.00000)
                BlzFrameSetVisible(RedLines[index], true)
            end
            linePos[u] = 0
            Timed.echo(0.02, 0.02 * RED_LINE_STEPS, function ()
                if lines[u] ~= line then
                    return true
                end

                linePos[u] = linePos[u] + 1
                if p == LocalPlayer then
                    BlzFrameSetPoint(RedLines[index], FRAMEPOINT_LEFT, ProgressBar, FRAMEPOINT_LEFT,  0.0100 * linePos[u], 0.00000)
                end

                if catch[u] ~= 0 then
                    if p == LocalPlayer then
                        BlzFrameSetVisible(RedLines[index], false)
                        if #fishers[p] == 1 then
                            BlzFrameSetVisible(FishBackdrop, false)
                        end
                    end
                    if catch[u] == 2 then
                        abortFish(u)
                    end
                    return true
                end
            end, function ()
                if p == LocalPlayer then
                    BlzFrameSetVisible(RedLines[index], false)
                end
                startFishing(u, p, line)
            end)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ROD end))
        TriggerAddAction(t, function ()
            UnitAddAbility(GetManipulatingUnit(), FISHING)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DROP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ROD end))
        TriggerAddAction(t, function ()
            local u = GetManipulatingUnit()
            Timed.call(function ()
                if not UnitHasItemOfTypeBJ(u, ROD) then
                    UnitRemoveAbility(u, FISHING)
                    abortFish(u)
                end
            end)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
        TriggerAddCondition(t, Condition(function () return fishing[GetOrderedUnit()] end))
        TriggerAddAction(t, function ()
            abortFish(GetOrderedUnit())
        end)
    end

    RegisterSpellEffectEvent(FISHING, function ()
        local u = GetSpellAbilityUnit()

        abortFish(u)

        local targetX, targetY
        ForEachCellInArea(GetUnitX(u), GetUnitY(u), 128, function (x, y)
            if not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainWalkable(x, y) then
                targetX, targetY = x, y
            end
        end)
        if targetX then
            fishing[u] = true
            local p = GetOwningPlayer(u)
            table.insert(fishers[p], u)

            local angle = math.atan(targetY - GetUnitY(u), targetX - GetUnitX(u))
            SetUnitFacing(u, math.deg(angle))

            local actX = GetUnitX(u)
            local actY = GetUnitY(u)
            local actZ = GetUnitZ(u, true) + 50.

            local step = DistanceBetweenCoords(GetUnitX(u), GetUnitY(u), targetX, targetY) / 50
            local stepX = step * math.cos(angle) * 1.25
            local stepY = step * math.sin(angle) * 1.25
            local stepZ = (GetPosZ(targetX, targetY) - actZ) / 40

            local line = AddLightningEx( "LEAS", true, actX, actY, actZ, actX, actY, actZ)
            SetLightningColor(line, 0.5, 1., 1., 1.)

            Timed.echo(0.02, 1., function ()
                if lines[u] ~= line then
                    return true
                end
                actX = actX + stepX
                actY = actY + stepY
                actZ = actZ + stepZ
                MoveLightningEx(line, true, GetUnitX(u), GetUnitY(u), GetUnitZ(u, true) + 50., actX, actY, actZ)
            end, function ()
                if p == LocalPlayer then
                    local index = 0
                    for i = 1, #RedLines do
                        if allowedRedLine[i] then
                            index = i
                            break
                        end
                    end
                    usedRedLine[u] = index
                    allowedRedLine[index] = false
                    BlzFrameSetTexture(Fisher[index], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)
                end

                startFishing(u, p, line)

                Timed.echo(0.02, function ()
                    if lines[u] ~= line then
                        return true
                    end
                    if DistanceBetweenCoordsSq(actX, actY, GetUnitX(u), GetUnitY(u)) > 90000. then
                        abortFish(u)
                    end
                    if catch[u] == 0 then
                        if math.random(1, 50) == 1 then
                            local angle2 = math.random() * 2 * math.pi
                            DestroyEffectTimed(AddSpecialEffect("Doodads\\Ruins\\Water\\BubbleGeyser\\BubbleGeyser.mdl", actX + 50.*math.random() * math.cos(angle2), actY + 50.*math.random() * math.sin(angle2)), 1.)
                        end 
                    elseif catch[u] == 1 then
                        actX = actX - stepX
                        actY = actY - stepY
                        actZ = actZ - stepZ
                        MoveLightningEx(line, true, GetUnitX(u), GetUnitY(u), GetUnitZ(u, true) + 50., actX, actY, actZ)

                        if DistanceBetweenCoordsSq(actX, actY, GetUnitX(u), GetUnitY(u)) < 2500 then
                            CreateItem(FISH, GetUnitX(u), GetUnitY(u))
                            abortFish(u)
                        end
                    end
                end)
            end)
            lines[u] = line
        else
            ErrorMessage("No fishing spot found", GetOwningPlayer(u))
        end
    end)

    local function ReadyFunc()
        local p = GetTriggerPlayer()
        table.sort(fishers[p], function (a, b) return linePos[a] > linePos[b] end)

        for i = 1, #fishers[p] do
            local u = fishers[p][i]
            if linePos[u] < RED_LINE_STEPS then
                local tt = CreateTextTag()
                SetTextTagPosUnit(tt, u, 128)
                SetTextTagPermanent(tt, false)
                SetTextTagLifespan(tt, 2.)
                SetTextTagVisibility(tt, p == LocalPlayer)

                if linePos[u] >= GREEN_AREA_START and linePos[u] <= GREEN_AREA_END then
                    catch[u] = 1
                    SetTextTagText(tt, "Success!", 0.023)
                    SetTextTagColor(tt, 0, 255, 0, 255)
                    if p == LocalPlayer then
                        StartSound(bj_questItemAcquiredSound)
                    end
                else
                    catch[u] = 2
                    SetTextTagText(tt, "Fail!", 0.023)
                    SetTextTagColor(tt, 255, 0, 0, 255)
                    if p == LocalPlayer then
                        StartSound(bj_questFailedSound)
                    end
                end
                break
            end
        end
    end

    FrameLoaderAdd(function ()
        FishBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
        BlzFrameSetAbsPoint(FishBackdrop, FRAMEPOINT_TOPLEFT, 0.160000, 0.460000)
        BlzFrameSetAbsPoint(FishBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.660000, 0.180000)
        BlzFrameSetTexture(FishBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(FishBackdrop, false)

        ProgressBar = BlzCreateFrame("QuestButtonBaseTemplate", FishBackdrop, 0, 0)
        BlzFrameSetPoint(ProgressBar, FRAMEPOINT_TOPLEFT, FishBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.13000)
        BlzFrameSetPoint(ProgressBar, FRAMEPOINT_BOTTOMRIGHT, FishBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.13000)

        Ready = BlzCreateFrame("IconButtonTemplate", FishBackdrop, 0, 0)
        BlzFrameSetPoint(Ready, FRAMEPOINT_TOPLEFT, FishBackdrop, FRAMEPOINT_TOPLEFT, 0.22500, -0.21000)
        BlzFrameSetPoint(Ready, FRAMEPOINT_BOTTOMRIGHT, FishBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22500, 0.020000)

        BackdropReady = BlzCreateFrameByType("BACKDROP", "BackdropReady", Ready, "", 0)
        BlzFrameSetAllPoints(BackdropReady, Ready)
        BlzFrameSetTexture(BackdropReady, "ReplaceableTextures\\CommandButtons\\BTNFishing1.blp", 0, true)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Ready, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ReadyFunc)

        for i = 1, udg_MAX_USED_DIGIMONS do
            RedLines[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", ProgressBar, "", 1)
            BlzFrameSetPoint(RedLines[i], FRAMEPOINT_LEFT, ProgressBar, FRAMEPOINT_LEFT, 0.00000, 0.00000)
            BlzFrameSetSize(RedLines[i], 0.01000, 0.10000)
            BlzFrameSetTexture(RedLines[i], "war3mapImported\\red.blp", 0, true)
            BlzFrameSetLevel(RedLines[i], 2)
            BlzFrameSetVisible(RedLines[i], false)

            Fisher[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", RedLines[i], "", 1)
            BlzFrameSetPoint(Fisher[i], FRAMEPOINT_TOPLEFT, RedLines[i], FRAMEPOINT_TOPLEFT, -0.010000, -0.10000)
            BlzFrameSetPoint(Fisher[i], FRAMEPOINT_BOTTOMRIGHT, RedLines[i], FRAMEPOINT_BOTTOMRIGHT, 0.010000, -0.030000)
            BlzFrameSetTexture(Fisher[i], "CustomFrame.png", 0, true)
        end

        GreenArea = BlzCreateFrameByType("BACKDROP", "BACKDROP", ProgressBar, "", 1)
        BlzFrameSetPoint(GreenArea, FRAMEPOINT_TOPLEFT, ProgressBar, FRAMEPOINT_TOPLEFT, 0.21000, 0.0000)
        BlzFrameSetPoint(GreenArea, FRAMEPOINT_BOTTOMRIGHT, ProgressBar, FRAMEPOINT_BOTTOMRIGHT, -0.21000, 0.0000)
        BlzFrameSetTexture(GreenArea, "CustomFrame.png", 0, true)
        BlzFrameSetLevel(GreenArea, 1)
    end)
end)
Debug.endFile()