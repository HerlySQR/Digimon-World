Debug.beginFile("Test")
OnInit(function ()
    Require "Pathfinder"

    local MAX_RANGE = 100.
    local DUMMY_ITEM = CreateItem(FourCC('wolg'), 0, 0)
    SetItemVisible(DUMMY_ITEM, false)
    local SEARCH_RECT = Rect(0, 0, 128, 128)
    local hiddenItems = {} ---@type item[]

    ---@param x number
    ---@param y number
    ---@return boolean
    function IsTerrainWalkable(x, y)
        -- Hide any items in the area to avoid conflicts with our item
        MoveRectTo(SEARCH_RECT, x, y)
        EnumItemsInRect(SEARCH_RECT, nil, function ()
            if IsItemVisible(GetEnumItem()) then
                table.insert(hiddenItems, GetEnumItem())
                SetItemVisible(GetEnumItem(), false)
            end
        end)

        -- Try to move the test item and get its coords
        SetItemPosition(DUMMY_ITEM, x, y) -- Unhides the item
        local tempX, tempY = GetItemX(DUMMY_ITEM), GetItemY(DUMMY_ITEM)
        SetItemVisible(DUMMY_ITEM, false) -- Hide it again

        -- Unhide any items hidden at the start
        for i = 1, #hiddenItems do
            SetItemVisible(hiddenItems[i], true)
        end
        hiddenItems = {}

        return (x - tempX)^2 + (y - tempY)^2 <= MAX_RANGE and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    end

    local firstX, firstY = 0, 0

    local t = CreateTrigger()
    TriggerRegisterPlayerEvent(t, Player(0), EVENT_PLAYER_MOUSE_DOWN)
    TriggerAddAction(t, function ()
        local mx = BlzGetTriggerPlayerMouseX()
        local my = BlzGetTriggerPlayerMouseY()
        local eff = AddSpecialEffect("Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl", mx, my)
        Timed.call(5., function ()
            DestroyEffect(eff)
        end)

        if firstX == 0 and firstY == 0 then
            firstX, firstY = mx, my
        else
            local finder = Pathfinder.create(firstX, firstY, mx, my)
            finder.stepDelay = 0.02
            finder.outputPath = true
            finder.debug = true
            finder:setCond(IsTerrainWalkable)

            finder:search(function (success, path)
                if success then
                    print("Path found. Nodes = " .. #path)
                    for i = 1, #path - 1 do
                        local ln = AddLightning("CLPB", false, path[i].posX, path[i].posY, path[i+1].posX, path[i+1].posY)
                        Timed.call(10., function ()
                            DestroyLightning(ln)
                        end)
                    end
                end
            end)

            firstX, firstY = 0, 0
        end
    end)
    FogEnable(false)
    FogMaskEnable(false)
end)
Debug.endFile()