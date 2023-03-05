if Debug then Debug.beginFile("SaveActions") end
OnInit("SaveActions", function ()
    Require "SaveHelper"
    Require "Savecode"
    Require "Player Data"
    Require "Backpack"

    ---@param p player
    ---@param savecode Savecode
    function SaveActions(p, savecode)
        -- Save each hero index:
        local list = GetDigimons(p)
        for i = 1, #list do
            local d = list[i]
            savecode:Encode(SaveHelper.ConvertUnitId(d:getTypeId()), udg_Setup_Total_Heroes)
            -- To the menu
            udg_SaveLoadDigimons[i] = d:getTypeId()
            -- Save the current hero's items:
            local inv = Inventory.create()
            for j = 0, 5 do
                local m = UnitItemInSlot(d.root, j)
                if m then
                    -- Save charges
                    savecode:Encode(GetItemCharges(m), 99)
                    -- Save slot
                    savecode:Encode(j + 1, 6)
                    -- Save item-class
                    savecode:Encode(GetHandleId(GetItemType(m)), 9)
                    -- Save item-type
                    savecode:Encode(SaveHelper.ConvertItemId(GetItemTypeId(m)), udg_Setup_Total_Items)
                    -- To the menu
                    inv:add(GetItemTypeId(m), GetItemCharges(m), j + 1)
                end
            end
            udg_SaveLoadInventories[i] = inv
            -- Save total number of items carried:
            savecode:Encode(UnitInventoryCount(d.root), 6)
            -- Save the level:
            udg_SaveLoadLevels[i] = d:getLevel()
            savecode:Encode(udg_SaveLoadLevels[i], 99)
            -- Save the current exp:
            udg_SaveLoadExps[i] = d:getExp()
            savecode:Encode(udg_SaveLoadExps[i], 54930)
        end
        -- Save the total number of Heroes the player controls:
        savecode:Encode(#list, udg_MAX_DIGIMONS)
        -- Store the backpack
        local backpack = GetBackpackItems(p)
        for i = 1, #backpack do
            local m = backpack[i]
            -- Store the item
            savecode:Encode(SaveHelper.ConvertItemId(m.id), udg_Setup_Total_Items)
            -- Store the charges
            savecode:Encode(m.charges, udg_MAX_STACK)
        end
        -- Save the total number of items has the backpack:
        savecode:Encode(#backpack, udg_MAX_ITEMS)
    end
end)
if Debug then Debug.endFile() end