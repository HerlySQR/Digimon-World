OnInit(function ()
    Require "ErrorMessage"
    --[[
        Permanent = Shield (max. 1)
        Artifact = Weapon (max. 1)
        Campaing = Accesories (max. 2)
        Charged = Digivice (max. 1)
        Purchasable = Crest (max. 1)
    ]]

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local m = GetManipulatedItem()
        local typ = GetItemType(m)
        if typ ~= ITEM_TYPE_POWERUP then
            local u = GetManipulatingUnit()

            local has = false

            if typ ~= ITEM_TYPE_CAMPAIGN then

                for i = 0, 5 do
                    local itm = UnitItemInSlot(u, i)
                    if typ == GetItemType(itm) and m ~= itm then
                        has = true
                        break
                    end
                end
            else
                local howMany = 0

                for i = 0, 5 do
                    local itm = UnitItemInSlot(u, i)
                    if GetItemType(itm) == ITEM_TYPE_CAMPAIGN then
                        howMany = howMany + 1
                        if howMany > 2 then
                            has = true
                            break
                        end
                    end
                    if GetItemTypeId(itm) == GetItemTypeId(m) and itm ~= m then
                        has = true
                        break
                    end
                end
            end

            if has then
                ErrorMessage("You can't carry more of this item.", GetOwningPlayer(u))
                UnitRemoveItem(u, m)
            end
        end
    end)
end)