Debug.beginFile("Inventory")
OnInit(function ()
    Require "DigimonBank"
    Require "ErrorMessage"
    Require "Menu"
    Require "PlayerUtils"
    Require "AddHook"

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
                    if GetItemType(itm) == ITEM_TYPE_CAMPAIGN then
                        howMany = howMany + 1
                        if howMany > 2 then
                            has = true
                            break
                        end
                    end
                    if itm and GetItemTypeId(itm) == GetItemTypeId(m) and itm ~= m then
                        has = true
                        break
                    end
                end
            end

            if has then
                ErrorMessage("You can't carry more of this item.", GetOwningPlayer(u))
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
                --elseif typ == ITEM_TYPE_MISCELLANEOUS then
                --    slot = DIGIVICE_SLOT
                elseif typ == ITEM_TYPE_CHARGED then
                    slot = CREST_SLOT
                else
                    slot = DIGIVICE_SLOT
                    --error("Item not identified")
                end
                UnitDropItemSlot(u, m, slot)
            end
        end
    end)

    Timed.echo(1., function ()
        ForForce(FORCE_PLAYING, function ()
            local p = GetEnumPlayer()
            for _, d in ipairs(GetUsedDigimons(p)) do
                for i = 0, 5 do
                    local m = UnitItemInSlot(d.root, i)
                    if m then
                        local typ = GetItemType(m)
                        if (typ == ITEM_TYPE_PERMANENT and i ~= SHIELD_SLOT)
                            or (typ == ITEM_TYPE_ARTIFACT and i ~= WEAPON_SLOT)
                            or (typ == ITEM_TYPE_CAMPAIGN and (i ~= ACCESORIES_SLOT_1 and i ~= ACCESORIES_SLOT_2))
                            --or (typ == ITEM_TYPE_MISCELLANEOUS and i ~= DIGIVICE_SLOT)
                            or (typ == ITEM_TYPE_CHARGED and i ~= CREST_SLOT) then

                            local slot
                            if typ == ITEM_TYPE_PERMANENT then
                                slot = SHIELD_SLOT
                            elseif typ == ITEM_TYPE_ARTIFACT then
                                slot = WEAPON_SLOT
                            elseif typ == ITEM_TYPE_CAMPAIGN then
                                if UnitItemInSlot(d.root, ACCESORIES_SLOT_2) then
                                    slot = ACCESORIES_SLOT_1
                                else
                                    slot = ACCESORIES_SLOT_2
                                end
                            --elseif typ == ITEM_TYPE_MISCELLANEOUS then
                            --    slot = DIGIVICE_SLOT
                            elseif typ == ITEM_TYPE_CHARGED then
                                slot = CREST_SLOT
                            else
                                slot = DIGIVICE_SLOT
                            end

                            UnitDropItemSlot(d.root, m, slot)
                            ErrorMessage("This item doesn't belong to this slot.", p)
                        end
                    end
                end
            end
        end)
    end)
end)
Debug.endFile()