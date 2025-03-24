Debug.beginFile("Pummel Peck")
OnInit(function ()
    local LocalPlayer = GetLocalPlayer()

    local dummyHeros = {}
    local heroGlows = {} ---@type framehandle[]

    for i = 1, 3 do
        dummyHeros[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('Hpal'), 0, 0, 0)
    end

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            local p = GetEnumPlayer()
            for j = 1, 3 do
                SetUnitOwner(dummyHeros[j], p, false)
            end
        end)

        for i = 0, 2 do
            heroGlows[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)
        end
        for i = 1, 3 do
            RemoveUnit(dummyHeros[i])
        end
    end)

    ---@async
    ---Returns a table with indices from 0 to 2 with their respective hero if it exists, based on the hero button positions
    ---@param p player
    ---@return table<0|1|2, unit>
    function GetHeroButtonPos(p)
        local orders = {} ---@type table<0|1|2, unit>

        local heros = {} ---@type unit[]
        ForUnitsOfPlayer(p, function (u)
            if IsUnitType(u, UNIT_TYPE_HERO) then
                table.insert(heros, u)
            end
        end)

        -- To prevent crashes
        --[[for i = 0, #heros - 1 do
            if BlzFrameGetChildrenCount(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)) < 3 then
                return orders
            end
        end]]

        if #heros == 1 then -- The only 1
            if p == LocalPlayer then
                orders[0] = heros[1]
            end
        elseif #heros > 1 then
            for i = 0, 2 do
                print(i, BlzFrameGetChild(heroGlows[i], 2))
            end

            local prevSkillPoints = __jarray(0) ---@type table<unit, integer>
            for i = 1, #heros do
                prevSkillPoints[heros[i]] = GetHeroSkillPoints(heros[i])
                UnitModifySkillPoints(heros[i], -prevSkillPoints[heros[i]])
            end

            if #heros == 2 then -- Check who has it visible or not
                UnitModifySkillPoints(heros[1], 1)

                if p == LocalPlayer then
                    if BlzFrameIsVisible(BlzFrameGetChild(heroGlows[0], 2)) then
                        orders[0] = heros[1]
                        orders[1] = heros[2]
                    else
                        orders[0] = heros[2]
                        orders[1] = heros[1]
                    end
                end

                UnitModifySkillPoints(heros[1], -1)
            elseif #heros == 3 then -- Make visible 2 and check who is the other one
                local indices = {0, 1, 2}

                UnitModifySkillPoints(heros[1], 1)
                UnitModifySkillPoints(heros[2], 1)

                local noVisible = -1

                if p == LocalPlayer then
                    for i = 0, 2 do
                        if not BlzFrameIsVisible(BlzFrameGetChild(heroGlows[i], 2)) then
                            noVisible = i
                        end
                    end

                    orders[noVisible] = heros[3]

                    for i = 3, 1, -1 do
                        if indices[i] == noVisible then
                            table.remove(indices, i)
                            break
                        end
                    end
                end

                -- Now repeat the same process of 2 with the rest of them
                UnitModifySkillPoints(heros[2], -1)

                local visible = -1

                if p == LocalPlayer then
                    for i = 1, 2 do
                        if not BlzFrameIsVisible(BlzFrameGetChild(heroGlows[indices[i]], 2)) then
                            noVisible = indices[i]
                        else
                            visible = indices[i]
                        end
                    end

                    orders[visible] = heros[1]
                    orders[noVisible] = heros[2]
                end

                UnitModifySkillPoints(heros[1], -1)
            end

            for i = 1, #heros do
                UnitModifySkillPoints(heros[i], prevSkillPoints[heros[i]])
            end
        end

        return orders
    end

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "b", true)
    TriggerAddAction(t, function ()
        local list = GetHeroButtonPos(Player(0))
        local syncedList = GetSyncedData(Player(0), function ()
            return list
        end)
        for i = 0, 2 do
            if syncedList[i] then
                print(GetUnitName(syncedList[i]))
                SetUnitManaPercentBJ(syncedList[i], 50)
            end
        end
    end)

    t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
    TriggerAddAction(t, function ()
        print("si")
    end)
end)
Debug.endFile()