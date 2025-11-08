Debug.beginFile("UnstableData")
OnInit(function ()
    Require "BossFightUtils"
    Require "FrameLoader"
    Require "SyncedTable"
    Require "FrameEffects"
    Require "PressSaveOrLoad"

    local UNSTABLE_DATA_PART = FourCC('I09V')
    local UNSTABLE_DATA = FourCC('I09W')
    local UNSTABLE_DATA_SPELL = FourCC('A0JR')

    local unstableDatas = __jarray(0) ---@type table<player, integer>
    local bossFound = {} ---@type table<player, unit>

    local LocalPlayer = GetLocalPlayer()

    --local UnstableDatas = nil ---@type framehandle
    --local UnstableDatasProgress = nil ---@type framehandle

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == UNSTABLE_DATA_PART end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            unstableDatas[p] = unstableDatas[p] + 1
            if p == LocalPlayer then
                --[[if unstableDatas[p] > 0 then
                    BlzFrameSetValue(UnstableDatasProgress, math.max(5 - unstableDatas[p], 0))
                    BlzFrameSetVisible(UnstableDatas, true)
                    BlzFrameSetVisible(UnstableDatasProgress, true)
                else
                    BlzFrameSetVisible(UnstableDatas, false)
                    BlzFrameSetVisible(UnstableDatasProgress, false)
                end]]
                StartSound(bj_questItemAcquiredSound)
            end
            --[[Timed.call(1.5, function ()
                if p == LocalPlayer then
                    BlzFrameSetVisible(UnstableDatas, false)
                    BlzFrameSetVisible(UnstableDatasProgress, false)
                end
            end)]]
            DisplayTextToPlayer(p, 0, 0, "Unstable Data parts: " .. unstableDatas[p])
            if unstableDatas[p] >= 5 then
                unstableDatas[p] = 0
                DisplayTextToPlayer(p, 0, 0, "You crafted an Unstable Data, see your backpack!")
                UnitAddItemById(GetManipulatingUnit(), UNSTABLE_DATA)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)
        TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == UNSTABLE_DATA_SPELL end))
        TriggerAddAction(t, function ()
            local u = GetSpellAbilityUnit()
            local p = GetOwningPlayer(u)
            bossFound[p] = nil
            for _, d in ipairs(GetUsedDigimons(p)) do
                ForUnitsInRange(d:getX(), d:getY(), 1000, function (boss)
                    if not bossFound[p] and IsUnitType(boss, UNIT_TYPE_HERO) and IsUnitType(boss, UNIT_TYPE_ANCIENT) and not UnitAlive(boss) then
                        bossFound[p] = boss
                    end
                end)
                if bossFound[p] then
                    break
                end
            end
            if not bossFound[p] then
                ErrorMessage("No dead boss nearby", p)
                UnitAbortCurrentOrder(u)
            end
        end)

        t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == UNSTABLE_DATA_SPELL end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetSpellAbilityUnit())
            if not bossFound[p] then
                ErrorMessage("How did you managed to click this?", p)
                return
            end
            RerollItemDrop(bossFound[p])
            DisplayTextToPlayer(p, 0, 0, "Re-rolling item drop for " .. GetHeroProperName(bossFound[p]) .. "...")
            bossFound[p] = nil
        end)
    end

    --[[FrameLoaderAdd(function ()
        UnstableDatas = BlzCreateFrameByType("BACKDROP", "BackdropUnstableDatasProgress", BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), "", 0)
        BlzFrameSetAbsPoint(UnstableDatas, FRAMEPOINT_TOPLEFT, 0.00000, 0.570000)
        BlzFrameSetAbsPoint(UnstableDatas, FRAMEPOINT_BOTTOMRIGHT, 0.0500000, 0.520000)
        BlzFrameSetTexture(UnstableDatas, "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp", 0, true)
        BlzFrameSetVisible(UnstableDatas, false)

        UnstableDatasProgress = BlzCreateFrameByType("SIMPLESTATUSBAR", "", UnstableDatas, "", 0)
        BlzFrameSetAllPoints(UnstableDatasProgress, UnstableDatas)
        BlzFrameSetTexture(UnstableDatasProgress, "ReplaceableTextures\\CommandButtonsDisabled\\DISBTNCrystalBall.blp", 0, true)
        BlzFrameSetMinMaxValue(UnstableDatasProgress, 0, 5)
        BlzFrameSetValue(UnstableDatasProgress, 5)
        BlzFrameSetVisible(UnstableDatasProgress, false)
        BlzFrameSetLevel(UnstableDatasProgress, 4)
    end)]]

    ---@param p player
    ---@return integer
    function GetUnstableDataParts(p)
        return unstableDatas[p]
    end

    ---@param p player
    ---@param value integer
    function SetUnstableDataParts(p, value)
        unstableDatas[p] = value
    end

    OnInit.map(function ()
        udg_BackpackItem = UNSTABLE_DATA
        udg_BackpackAbility = UNSTABLE_DATA_SPELL
        udg_BackpackNoTarget = true
        TriggerExecute(udg_BackpackRun)
    end)
end)
Debug.endFile()