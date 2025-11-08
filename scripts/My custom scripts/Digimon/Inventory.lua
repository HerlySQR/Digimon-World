Debug.beginFile("Inventory")
OnInit(function ()
    Require "ErrorMessage"
    Require "PlayerUtils"

    --[[
        Permanent = Shield (max. 1)
        Artifact = Weapon (max. 1)
        Campaing = Accesories (max. 2)
        Miscellaneous = Digivice (max. 1)
        Charged = Crest (max. 1)
    ]]

    local SHIELD_SLOT = 0
    local WEAPON_SLOT = 1
    local ACCESORIES_SLOT_1 = 2
    local ACCESORIES_SLOT_2 = 3
    local DIGIVICE_SLOT = 4
    local CREST_SLOT = 5

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local m = GetManipulatedItem()
        local typ = GetItemType(m)

            if typ ~= ITEM_TYPE_POWERUP then
                local u = GetManipulatingUnit()

                Timed.call(function ()
                    local has = false
                    local howMany = 0

                    if typ ~= ITEM_TYPE_CAMPAIGN then
                        for i = 0, 5 do
                            local itm = UnitItemInSlot(u, i)
                            if itm and typ == GetItemType(itm) and m ~= itm then
                                has = true
                                break
                            end
                        end
                    else
                        for i = 0, 5 do
                            local itm = UnitItemInSlot(u, i)
                            if itm and itm ~= m then
                                if GetItemTypeId(itm) == GetItemTypeId(m) then
                                    has = true
                                    break
                                elseif GetItemType(itm) == ITEM_TYPE_CAMPAIGN then
                                    howMany = howMany + 1
                                    if howMany > 1 then
                                        has = true
                                        break
                                    end
                                end
                            end
                        end
                    end

                    if has then
                        ErrorMessage(GetLocalizedString("CANT_CARRY_MORE_OF_THIS_ITEM"), GetOwningPlayer(u))
                        UnitRemoveItem(u, m)
                    else
                        local slot
                        if typ == ITEM_TYPE_PERMANENT then
                            slot = SHIELD_SLOT
                        elseif typ == ITEM_TYPE_ARTIFACT then
                            slot = WEAPON_SLOT
                        elseif typ == ITEM_TYPE_CAMPAIGN then
                            if howMany == 0 then
                                slot = ACCESORIES_SLOT_1
                            else
                                slot = ACCESORIES_SLOT_2
                            end
                        elseif typ == ITEM_TYPE_CHARGED then
                            slot = CREST_SLOT
                        else
                            slot = DIGIVICE_SLOT
                        end
                        UnitDropItemSlot(u, m, slot)
                    end
                end)
            end
    end)
end)
Debug.endFile()