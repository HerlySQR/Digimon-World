Debug.beginFile("test")
OnInit(function ()
    Require "UnitEnum"
    Require "GetSyncedData"

    Timed.echo(1., function ()
        print(" ")
        -- I do this in this way because the function locally calls the passed function and has functions that can't be called locally
        local orders = GetHeroButtonPos(Player(0))
        local syncedOrders = GetSyncedData(Player(0), function ()
            return orders
        end)
        for i = 0, 2 do
            if syncedOrders[i] then
                print(GetHeroProperName(orders[i]))
            end
        end
    end)

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "0", true)
    TriggerAddAction(t, function ()
        local hero
        GroupEnumUnitsOfPlayer(CreateGroup(), Player(0), Filter(function ()
            if IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) then
                hero = GetFilterUnit()
            end
        end))

        if hero then
            UnitModifySkillPoints(hero, -1)
            print(BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), 2)))
            UnitModifySkillPoints(hero, 1)
            print(BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), 2)))
            UnitModifySkillPoints(hero, -1)
            print(BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), 2)))
        end
    end)

    t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "1", true)
    TriggerAddAction(t, function ()
        local hero
        GroupEnumUnitsOfPlayer(CreateGroup(), Player(0), Filter(function ()
            if IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) then
                hero = GetFilterUnit()
            end
        end))

        if hero then
            UnitModifySkillPoints(hero, 30)
            print(BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), 2)))
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
        for i = 0, #heros - 1 do
            if BlzFrameGetChildrenCount(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)) < 3 then
                return orders
            end
        end

        if #heros == 1 then -- The only 1
            orders[0] = heros[1]
        elseif #heros > 1 then
            local prevSkillPoints = __jarray(0) ---@type table<unit, integer>
            for i = 1, #heros do
                prevSkillPoints[heros[i]] = GetHeroSkillPoints(heros[i])
                UnitModifySkillPoints(heros[i], -prevSkillPoints[heros[i]])
            end

            if #heros == 2 then -- Check who has it visible or not
                UnitModifySkillPoints(heros[1], 1)

                if BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, 0), 2)) then
                    orders[0] = heros[1]
                    orders[1] = heros[2]
                else
                    orders[0] = heros[2]
                    orders[1] = heros[1]
                end

                UnitModifySkillPoints(heros[1], -1)
            elseif #heros == 3 then -- Make visible 2 and check who is the other one
                local indices = {0, 1, 2}

                UnitModifySkillPoints(heros[1], 1)
                UnitModifySkillPoints(heros[2], 1)

                local noVisible = -1

                for i = 0, 2 do
                    if not BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i), 2)) then
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

                -- Now repeat the same process of 2 with the rest of them
                UnitModifySkillPoints(heros[2], -1)

                local visible = -1

                for i = 1, 2 do
                    if not BlzFrameIsVisible(BlzFrameGetChild(BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, indices[i]), 2)) then
                        noVisible = indices[i]
                    else
                        visible = indices[i]
                    end
                end

                orders[visible] = heros[1]
                orders[noVisible] = heros[2]

                UnitModifySkillPoints(heros[1], -1)
            end

            for i = 1, #heros do
                UnitModifySkillPoints(heros[i], prevSkillPoints[heros[i]])
            end
        end

        return orders
    end
end)
Debug.endFile()