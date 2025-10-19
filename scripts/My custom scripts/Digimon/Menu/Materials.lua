Debug.beginFile("Materials")
OnInit(function ()
    Require "Serializable"
    Require "Hotkeys"
    Require "Digimon"

    local MAX_MATERIAL_AMOUNT = udg_MAX_MATERIAL_AMOUNT
    local MAX_MATERIALS = udg_MAX_MATERIALS

    ---@class MaterialTemplate
    ---@field source integer
    ---@field itm integer

    local MaterialFromSource = {} ---@type table<integer, MaterialTemplate>
    local MaterialFromItem = {} ---@type table<integer, MaterialTemplate>

    ---@class Material
    ---@field template MaterialTemplate
    ---@field amount integer

    local Materials = {} ---@type table<player, Material[]>

    ---@param source integer
    ---@return MaterialTemplate
    function GetMaterialFromSource(source)
        return MaterialFromSource[source]
    end

    ---@param itm integer
    ---@return MaterialTemplate
    function GetMaterialFromItem(itm)
        return MaterialFromItem[itm]
    end

    ---@class MaterialData : Serializable
    ---@field itms integer[]
    ---@field amounts integer[]
    ---@field count integer
    MaterialData = setmetatable({}, Serializable)
    MaterialData.__index = MaterialData

    ---@param p player?
    ---@return MaterialData
    function MaterialData.create(p)
        local self = setmetatable({
            itms = __jarray(0),
            amounts = __jarray(0),
            count = 0
        }, MaterialData)
        if p then
            for _, material in ipairs(Materials[p]) do
                self.count = self.count + 1
                self.itms[self.count] = material.template.itm
                self.amounts[self.count] = material.amount
            end
        end
        return self
    end

    function MaterialData:serializeProperties()
        self:addProperty("count", self.count)
        for i = 1, self.count do
            self:addProperty("itm" .. i, self.itms[i])
            self:addProperty("amount" .. i, self.amounts[i])
        end
    end

    function MaterialData:deserializeProperties()
        self.count = self:getIntProperty("count")
        for i = 1, self.count do
            self.itms[i] = self:getIntProperty("itm" .. i)
            self.amounts[i] = self:getIntProperty("amount" .. i)
        end
    end

    ---@param p player
    function MaterialData:apply(p)
        Materials[p] = {}
        for i = 1, self.count do
            Materials[p][i] = {
                template = MaterialFromItem[self.itms[i]],
                amount = self.amounts[i]
            }
        end
    end

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        Materials[Player(i)] = {}
    end

    local LocalPlayer = GetLocalPlayer()

    local MaterialsButton = nil ---@type framehandle
    local BackdropMaterialsButton = nil ---@type framehandle
    local MaterialsBackdrop = nil ---@type framehandle
    local MaterialsLabel = nil ---@type framehandle
    local MaterialIconT = {} ---@type framehandle[]
    local BackdropMaterialIconT = {} ---@type framehandle[]
    local MaterialAmount = {} ---@type framehandle[]
    local MaterialTooltip = {} ---@type framehandle[]
    local MaterialTooltipText = {} ---@type framehandle[]

    local function UpdateMenu()
        local bag = Materials[LocalPlayer]
        for i = 1, MAX_MATERIALS do
            if bag[i] then
                BlzFrameSetVisible(MaterialIconT[i-1], true)
                BlzFrameSetTexture(BackdropMaterialIconT[i-1], BlzGetAbilityIcon(bag[i].template.itm), 0, true)
                BlzFrameSetText(MaterialAmount[i-1], tostring(bag[i].amount))

                BlzFrameSetText(MaterialTooltipText[i-1], GetObjectName(bag[i].template.itm))
                BlzFrameSetSize(MaterialTooltipText[i-1], 0, 0.01)
                BlzFrameClearAllPoints(MaterialTooltip[i-1])
                BlzFrameSetPoint(MaterialTooltip[i-1], FRAMEPOINT_TOPLEFT, MaterialTooltipText[i-1], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
                BlzFrameSetPoint(MaterialTooltip[i-1], FRAMEPOINT_BOTTOMRIGHT, MaterialTooltipText[i-1], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
            else
                BlzFrameSetVisible(MaterialIconT[i-1], false)
                BlzFrameSetTexture(BackdropMaterialIconT[i-1], "UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0, true)
                BlzFrameSetText(MaterialAmount[i-1], "")
            end
        end
    end

    local function MaterialsButtonFunc(p)
        if p == LocalPlayer then
            if not BlzFrameIsVisible(MaterialsBackdrop) then
                BlzFrameSetVisible(MaterialsBackdrop, true)
                AddButtonToEscStack(MaterialsButton)
                UpdateMenu()
            else
                BlzFrameSetVisible(MaterialsBackdrop, false)
                RemoveButtonFromEscStack(MaterialsButton)
            end
        end
    end

    FrameLoaderAdd(function()
        MaterialsButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(MaterialsButton, 6)
        SetFrameHotkey(MaterialsButton, udg_MATERIALS_HOTKEY)
        AddDefaultTooltip(MaterialsButton, "Material bag", "Look how many materials you have stored.")
        AddFrameToMenu(MaterialsButton)
        BlzFrameSetVisible(MaterialsButton, false)

        BackdropMaterialsButton = BlzCreateFrameByType("BACKDROP", "BackdropMaterialsButton", MaterialsButton, "", 0)
        BlzFrameSetAllPoints(BackdropMaterialsButton, MaterialsButton)
        BlzFrameSetTexture(BackdropMaterialsButton, udg_MATERIALS_BUTTON, 0, true)
        OnClickEvent(MaterialsButton, MaterialsButtonFunc)

        MaterialsBackdrop = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.315, 0.420000)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.055, 0.230000)
        AddFrameToMenu(MaterialsBackdrop)
        BlzFrameSetVisible(MaterialsBackdrop, false)

        MaterialsLabel = BlzCreateFrameByType("TEXT", "name", MaterialsBackdrop, "", 0)
        BlzFrameSetScale(MaterialsLabel, 1.29)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.010000)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.16000)
        BlzFrameSetText(MaterialsLabel, "|cffFFCC00Your materials:|r")
        BlzFrameSetTextAlignment(MaterialsLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        for i = 0, 4 do
            for j = 0, 5 do
                local index = i*6 + j

                MaterialIconT[index] = BlzCreateFrame("IconButtonTemplate", MaterialsBackdrop, 0, 0)
                BlzFrameSetPoint(MaterialIconT[index], FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.020000 + i*0.045, -0.030000 - j*0.025)
                BlzFrameSetPoint(MaterialIconT[index], FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.22000 + i*0.045, 0.14000 - j*0.025)
                BlzFrameSetEnable(MaterialIconT[index], false)

                BackdropMaterialIconT[index] = BlzCreateFrameByType("BACKDROP", "BackdropMaterialIconT[" .. index .. "]", MaterialsBackdrop, "", 0)
                BlzFrameSetAllPoints(BackdropMaterialIconT[index], MaterialIconT[index])
                BlzFrameSetTexture(BackdropMaterialIconT[index], "UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0, true)

                MaterialAmount[index] = BlzCreateFrameByType("TEXT", "name", MaterialsBackdrop, "", 0)
                BlzFrameSetPoint(MaterialAmount[index], FRAMEPOINT_TOPLEFT, MaterialIconT[index], FRAMEPOINT_TOPLEFT, 0.020000, 0.0000)
                BlzFrameSetPoint(MaterialAmount[index], FRAMEPOINT_BOTTOMRIGHT, MaterialIconT[index], FRAMEPOINT_BOTTOMRIGHT, 0.020000, 0.0000)
                BlzFrameSetText(MaterialAmount[index], "")
                BlzFrameSetTextAlignment(MaterialAmount[index], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

                MaterialTooltip[i] = BlzCreateFrame("QuestButtonBaseTemplate", MaterialIconT[i], 0, 0)

                MaterialTooltipText[i] = BlzCreateFrameByType("TEXT", "name", MaterialTooltip[i], "", 0)
                BlzFrameSetPoint(MaterialTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, MaterialIconT[i], FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.025000)
                BlzFrameSetText(MaterialTooltipText[i], "Empty")
                BlzFrameSetEnable(MaterialTooltipText[i], false)
                BlzFrameSetTextAlignment(MaterialTooltipText[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

                BlzFrameSetPoint(MaterialTooltip[i], FRAMEPOINT_TOPLEFT, MaterialTooltipText[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
                BlzFrameSetPoint(MaterialTooltip[i], FRAMEPOINT_BOTTOMRIGHT, MaterialTooltipText[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)
                BlzFrameSetTooltip(MaterialIconT[i], MaterialTooltip[i])
            end
        end
    end)

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(MaterialsBackdrop)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.205, 0.460000)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.055, 0.300000)
    end)

    ---@param p player
    ---@param itm integer
    ---@param amount integer
    function SetMaterialAmount(p, itm, amount)
        amount = math.min(amount, MAX_MATERIAL_AMOUNT)

        local found = false
        for i = 1, #Materials[p] do
            if Materials[p][i].template.itm == itm then
                found = true
                Materials[p][i].amount = amount
                break
            end
        end

        if not found then
            table.insert(Materials[p], {
                template = MaterialFromItem[itm],
                amount = amount
            })
        end

        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    ---@param p player
    ---@param itm integer
    ---@return integer
    function GetMaterialAmount(p, itm)
        for i = 1, #Materials[p] do
            if Materials[p][i].template.itm == itm then
                return Materials[p][i].amount
            end
        end
        return 0
    end

    ---@param p player
    ---@param itm integer
    ---@param amount integer
    function AddMaterialAmount(p, itm, amount)
        local found = false
        for i = 1, #Materials[p] do
            if Materials[p][i].template.itm == itm then
                found = true
                Materials[p][i].amount = math.min(Materials[p][i].amount + amount, MAX_MATERIAL_AMOUNT)
                break
            end
        end

        if not found then
            amount = math.min(amount, MAX_MATERIAL_AMOUNT)
            table.insert(Materials[p], {
                template = MaterialFromItem[itm],
                amount = amount
            })
        end

        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    ---@param p player
    ---@param itm integer
    ---@param amount integer
    function SubMaterialAmount(p, itm, amount)
        for i = 1, #Materials[p] do
            if Materials[p][i].template.itm == itm then
                Materials[p][i].amount = math.max(Materials[p][i].amount - amount, 0)
                break
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

    ---@param p player
    ---@param flag boolean
    function ShowMaterials(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(MaterialsButton, flag)
        end
    end

    ---@param itm integer -- item type
    ---@param source integer -- unit type
    local function InitMaterial(itm, source)
        if source == 0 then
            print("Materials: The material " .. GetObjectName(itm) .. " has no source.")
            return
        end

        IgnoreCommandButton(source)

        local material = {
            source = source,
            itm = itm
        }

        MaterialFromSource[source] = material
        MaterialFromItem[itm] = material

        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == itm end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            AddMaterialAmount(p, itm, 1)
            RemoveItem(GetManipulatedItem())
            if p == LocalPlayer then
                BlzFrameSetVisible(MaterialsButton, true)
                UpdateMenu()
            end
        end)

        t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetOrderTargetItem()) == itm and GetIssuedOrderId() == Orders.smart end))
        TriggerAddAction(t, function ()
            local u = GetOrderedUnit()
            local p = GetOwningPlayer(u)
            if GetMaterialAmount(p, itm) >= MAX_MATERIAL_AMOUNT then
                IssueTargetOrderById(u, Orders.attack, u)
                ErrorMessage("You can't carry more of this material.", p)
            end
        end)

        t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
        TriggerAddCondition(t, Condition(function () return GetUnitTypeId(udg_DamageEventTarget) == source end))
        TriggerAddAction(t, function ()
            udg_DamageEventAmount = 0
            local u = udg_DamageEventTarget
            Timed.call(function ()
                SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) - 1)
            end)
        end)

        t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddCondition(t, Condition(function () return GetUnitTypeId(GetDyingUnit()) == source end))
        TriggerAddAction(t, function ()
            local x, y = GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit())
            CreateItem(itm, x, y)

            local delay = udg_MATERIAL_REFILL_DELAY

            local tt = CreateTextTag()
            SetTextTagPos(tt, x, y, 128.)
            SetTextTagText(tt, "Restore in: " .. math.floor(delay), 0.023)
            SetTextTagVisibility(tt, IsVisibleToPlayer(x, y, LocalPlayer))
            Timed.echo(0.02, udg_MATERIAL_REFILL_DELAY, function ()
                delay = delay - 0.02
                SetTextTagText(tt, "Restore in: " .. math.floor(delay), 0.023)
                SetTextTagVisibility(tt, IsVisibleToPlayer(x, y, LocalPlayer))
            end, function ()
                DestroyTextTag(tt)
                CreateUnit(Digimon.RESOURCE, source, x, y, bj_UNIT_FACING)
            end)
        end)
    end

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            local p = GetEnumPlayer()
            if p ~= Digimon.RESOURCE then
                if p == Digimon.NEUTRAL or p == Digimon.VILLAIN then
                    SetPlayerAllianceStateBJ(Digimon.RESOURCE, p, bj_ALLIANCE_ALLIED)
                    SetPlayerAllianceStateBJ(p, Digimon.RESOURCE, bj_ALLIANCE_ALLIED)
                elseif IsPlayerInGame(p) then
                    EnablePvP(p, Digimon.RESOURCE)
                end
            end
        end)
    end)

    udg_MaterialInit = CreateTrigger()
    TriggerAddAction(udg_MaterialInit, function ()
        InitMaterial(
            udg_MaterialItem,
            udg_MaterialSource
        )
        udg_MaterialName = ""
        udg_MaterialItem = 0
        udg_MaterialSource = 0
    end)
end)
Debug.endFile()