Debug.beginFile("Materials")
OnInit(function ()
    Require "Serializable"
    Require "Hotkeys"
    Require "Digimon"

    local Materials = {} ---@type table<player, table<string, integer>>

    ---@class Material
    ---@field name string
    ---@field source integer
    ---@field itm integer

    local MaterialFromName = {} ---@type table<string, Material>
    local MaterialFromSource = {} ---@type table<integer, Material>
    local MaterialFromItem = {} ---@type table<string, Material>

    ---@param name string
    ---@return Material
    function GetMaterialFromName(name)
        return MaterialFromName[name]
    end

    ---@param source integer
    ---@return Material
    function GetMaterialFromSource(source)
        return MaterialFromSource[source]
    end

    ---@param itm integer
    ---@return Material
    function GetMaterialFromItem(itm)
        return MaterialFromItem[itm]
    end

    ---@class MaterialData : Serializable
    ---@field names string[]
    ---@field amounts integer[]
    ---@field count integer
    MaterialData = setmetatable({}, Serializable)
    MaterialData.__index = MaterialData

    ---@param p player?
    ---@return MaterialData
    function MaterialData.create(p)
        local self = setmetatable({
            names = __jarray(""),
            amounts = __jarray(0),
            count = 0
        }, MaterialData)
        if p then
            for name, amount in pairs(Materials[p]) do
                self.count = self.count + 1
                self.names[self.count] = name
                self.amounts[self.count] = amount
            end
        end
        return self
    end

    function MaterialData:serializeProperties()
        self:addProperty("count", self.count)
        for i = 1, self.count do
            self:addProperty("name" .. i, self.names[i])
            self:addProperty("amount" .. i, self.amounts[i])
        end
    end

    function MaterialData:deserializeProperties()
        self.count = self:getIntProperty("count")
        for i = 1, self.count do
            self.names[i] = self:getStringProperty("name" .. i)
            self.amounts[i] = self:getIntProperty("amount" .. i)
        end
    end

    ---@param p player
    function MaterialData:apply(p)
        Materials[p] = __jarray(0)
        for i = 1, self.count do
            Materials[p][self.names[i]] = self.amounts[i]
        end
    end

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        Materials[Player(i)] = __jarray(0)
    end

    local LocalPlayer = GetLocalPlayer()

    local MaterialsButton = nil ---@type framehandle
    local BackdropMaterialsButton = nil ---@type framehandle
    local MaterialsBackdrop = nil ---@type framehandle
    local MaterialsLabel = nil ---@type framehandle
    local MaterialAmounts = nil ---@type framehandle

    local function UpdateMenu()
        local materials = ""
        for name, amount in pairs(Materials[LocalPlayer]) do
            materials = materials .. "- " .. amount .. " " .. name .. "\n"
        end
        BlzFrameSetText(MaterialAmounts, materials)
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
        SetFrameHotkey(MaterialsButton, "Y")
        AddDefaultTooltip(MaterialsButton, "Material bag", "Look how many materials you have stored.")
        AddFrameToMenu(MaterialsButton)
        BlzFrameSetVisible(MaterialsButton, false)

        BackdropMaterialsButton = BlzCreateFrameByType("BACKDROP", "BackdropMaterialsButton", MaterialsButton, "", 0)
        BlzFrameSetAllPoints(BackdropMaterialsButton, MaterialsButton)
        BlzFrameSetTexture(BackdropMaterialsButton, "ReplaceableTextures\\CommandButtons\\BTNDustOfAppearance.blp", 0, true)
        OnClickEvent(MaterialsButton, MaterialsButtonFunc)

        MaterialsBackdrop = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.235, 0.460000)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.055, 0.240000)
        AddFrameToMenu(MaterialsBackdrop)
        BlzFrameSetVisible(MaterialsBackdrop, false)

        MaterialsLabel = BlzCreateFrameByType("TEXT", "name", MaterialsBackdrop, "", 0)
        BlzFrameSetScale(MaterialsLabel, 1.29)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.18500)
        BlzFrameSetText(MaterialsLabel, "|cffFFCC00Your materials:|r")
        BlzFrameSetEnable(MaterialsLabel, false)
        BlzFrameSetTextAlignment(MaterialsLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MaterialAmounts = BlzCreateFrameByType("TEXTAREA", "name", MaterialsBackdrop, "", 0)
        BlzFrameSetPoint(MaterialAmounts, FRAMEPOINT_TOPLEFT, MaterialsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(MaterialAmounts, FRAMEPOINT_BOTTOMRIGHT, MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(MaterialAmounts, "|cffffffff100 Special Wood|r")
    end)

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(MaterialsBackdrop)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.205, 0.460000)
        BlzFrameSetAbsPoint(MaterialsBackdrop, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.055, 0.300000)
    end)

    ---@param p player
    ---@param name string
    ---@param amount integer
    function SetMaterialAmount(p, name, amount)
        Materials[p][name] = amount
    end

    ---@param p player
    ---@param name string
    ---@return integer
    function GetMaterialAmount(p, name)
        return Materials[p][name]
    end

    ---@param p player
    ---@param name string
    ---@param amount integer
    function AddMaterialAmount(p, name, amount)
        Materials[p][name] = Materials[p][name] + amount
    end

    ---@param p player
    ---@param name string
    ---@param amount integer
    function SubMaterialAmount(p, name, amount)
        Materials[p][name] = Materials[p][name] - amount
    end

    ---@param p player
    ---@param flag boolean
    function ShowMaterials(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(MaterialsButton, flag)
        end
    end

    ---@param name string
    ---@param itm integer -- item type
    ---@param source integer -- unit type
    local function InitMaterial(name, itm, source)
        IgnoreCommandButton(source)

        local material = {
            name = name,
            source = source,
            itm = itm
        }

        MaterialFromName[name] = material
        MaterialFromSource[source] = material
        MaterialFromItem[itm] = material

        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == itm end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            AddMaterialAmount(p, name, 1)
            RemoveItem(GetManipulatedItem())
            if p == LocalPlayer then
                BlzFrameSetVisible(MaterialsButton, true)
                UpdateMenu()
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
            udg_MaterialName,
            udg_MaterialItem,
            udg_MaterialSource
        )
        udg_MaterialName = ""
        udg_MaterialItem = 0
        udg_MaterialSource = 0
    end)
end)
Debug.endFile()