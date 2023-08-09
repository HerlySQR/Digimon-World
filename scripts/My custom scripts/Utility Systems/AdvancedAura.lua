if Debug then Debug.beginFile("AdvancedAura") end
--############################## ~AdvancedAura~ ######################################--
--##
--## Based on Axarion's AdvancedAura 1.0 https://www.hiveworkshop.com/threads/advancedaura.179937/
--##
--############################### DESCRIPTION ###################################--
--##
--## This System allows to  create  custom auras. It was  made, because ability
--## only auras arent very flexible and have bad filters. Also normal auras are 
--## limited to specific bonuses.
--##
--############################### HOW DOES IT WORK ##############################--
--## 
--## To use this system create an instance and set the fields and methods.
--## In the onInit method you have to define the ability for the aura and  
--## the buffs ability if you use UnitAuraBuff. When a unit acquires the ability the 
--## aura will be added automatically so you don't have to do it yourself. To define 
--## the ability just use:
--##    
--##        .abilityId = FourCC('AURA')
--##        .INTERVAL = 0.5
--##
--## The aura will be paused if the unit is a hero and it dies. If a unit leaves 
--## the map the aura will be removed, so you don't have to worry about leaking
--## instances.
--## 
--################################# METHODS #####################################--
--##   
--##    You can implement these functions into your instance. They are 
--##    all optional. 
--##
--##    - happens when a new aura is created (define the bonuses here)
--##        auraInit()
--## 
--##    - happens when a unit enters the aura     
--##        onAffect(unit u)
--##
--##    - happens when a unit leaves the aura   
--##        onUnaffect(u)
--##    
--##    - happens when a unit stayed in the aura
--##        onLoop(u)
--##
--##    - checks if the unit is a valid target for the aura
--##        onFilter(u) returns boolean
--##
--##    - happens when the aura leveled up (increase the bonuses here)
--##        onLevelUp()
--##
--##    - define the AoE here
--##        getAuraAoE() returns real
--##
--################################# API & Variables ##############################--
--##
--##    - the unit owning the aura:
--##        .owner
--##
--##    - the level of the aura:
--##        .level
--##
--##    - the aura ability
--##        .abilityId
--##
--##    - the auras group with all currently affected units
--##        .instanceGroup
--##
--############################### Buff ##############################--
--## 
--## Just implement AdvancedAuraBuff before you implement AdvancedAura
--## and define the BUFF in the onInit method of your struct and your done.
--## The ability should be a modified Tornado Slow Aura with targets set as
--## only self and range of 0.01.
--## Also you should modify the buff/create a new one.
--## 
--##            self.BUFF = 'Haxx'
--## 
--############################### Bonus ##############################--
--## 
--## Just implement AdvancedAuraBonus before you implement AdvancedAura and define 
--## the bonuses in the AuraInit method of your struct and increase/decrease them 
--## in the onLevelUp method if you want.
--##
--##    .setBonus(integer bonusType, integer amount)
--##
--############################### Effect ##############################--
--## 
--## Just implement AdvancedAuraEffect before you implement AdvancedAura
--## and define the TARGET_SFX, OWNER_SFX in the onInit method of your struct and your done.
--##
--##    .TARGET_SFX      = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
--##    .TARGET_ATTACH   = "origin"
--##
--##    .OWNER_SFX       = ""
--##    .OWNER_ATTACH    = "origin"
--##
--################################################################################--
OnInit("AdvancedAura", function ()
    Require "UnitEnterEvent"
    Require "AddHook"
    Require "Timed"
    Require "NewBonus"
    Require "UnitEnum"

    ---@class AdvancedAura
    ---@field owner unit
    ---@field instanceGroup group
    ---@field abilityId integer
    ---@field private index integer
    ---@field private level integer
    ---@field private pause boolean
    ---@field affectedCount integer
    ---@field instanceUnits table<unit, AdvancedAura>
    ---@field INTERVAL number
    ---@field private auraTimer function
    ---@field auraInit fun(self: AdvancedAura)
    ---@field onAffect fun(self: AdvancedAura, u: unit)
    ---@field getAuraAoE fun(self: AdvancedAura): number
    ---@field onUnaffect fun(self: AdvancedAura, u: unit)
    ---@field AdvanceAura fun(self: AdvancedAura)
    ---@field onLoopUnit fun(self: AdvancedAura, u: unit): number
    ---@field onLoop fun(self: AdvancedAura)
    ---@field onFilter fun(self: AdvancedAura, u: unit): boolean
    ---@field onLevelUp fun(self: AdvancedAura, level: integer)
    ---@field BUFF integer
    ---@field private BUFF_LOCK table<unit, integer>
    ---@field private bonusSaver table<integer, integer>
    ---@field private EFFECT_LOCK table<unit, integer>
    ---@field TARGET_SFX string
    ---@field TARGET_ATTACH string
    ---@field OWNER_SFX string
    ---@field OWNER_ATTACH string
    ---@field private TARGET_EFFECT table<unit, effect>
    ---@field private OWNER_EFFECT effect
    local AdvancedAura = {}
    AdvancedAura.__index = AdvancedAura

    ---@param t AdvancedAura
    local function auraInit(t)
    end

    ---@param t AdvancedAura
    ---@param u unit
    local function onAffect(t, u)
    end

    ---@param t AdvancedAura
    ---@return number
    local function getAuraAoE(t)
        return 900.
    end

    ---@param t AdvancedAura
    ---@param u unit
    local function onUnaffect(t, u)
    end

    ---@param t AdvancedAura
    local function onLoop(t)
    end

    ---@param t AdvancedAura
    ---@param u unit
    local function onLoopUnit(t, u)
    end

    ---@param t AdvancedAura
    ---@param u unit
    local function onFilter(t, u)
        return true
    end

    ---@param t AdvancedAura
    ---@param l integer
    local function onLevelUp(t, l)
    end

    ---@param abilityId integer
    ---@return AdvancedAura
    function AdvancedAura.create(abilityId)
        assert(GetObjectName(abilityId) ~= "Default string", "You passed an invalid abilityId")

        local self = setmetatable({
            abilityId = abilityId,
            index = 0,
            level = 0,
            pause = false,
            affectedCount = 0,
            instanceUnits = {},
            INTERVAL = 0.5,
            auraInit = auraInit,
            onAffect = onAffect,
            getAuraAoE = getAuraAoE,
            onUnaffect = onUnaffect,
            onLoop = onLoop,
            onLoopUnit = onLoopUnit,
            onFilter = onFilter,
            onLevelUp = onLevelUp,
            BUFF = 0,
            bonusSaver = __jarray(0),
            TARGET_SFX = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl",
            TARGET_ATTACH = "origin",
            OWNER_SFX = "",
            OWNER_ATTACH = "origin"
        }, AdvancedAura)

        OnUnitEnter(function (u)
            if GetUnitAbilityLevel(u, abilityId) > 0 then
                self:addAura(u)
            end
        end)

        OnUnitLeave(function (u)
            if GetUnitAbilityLevel(u, abilityId) > 0 then
                self:removeAura(u)
            end
        end)


        local oldUnitAddAbility
        oldUnitAddAbility = AddHook("UnitAddAbility", function (u, id)
            if id == abilityId then
                self:addAura(u)
            end
            return oldUnitAddAbility(u, id)
        end)

        local oldUnitRemoveAbility
        oldUnitRemoveAbility = AddHook("UnitRemoveAbility", function (u, id)
            if id == abilityId then
                self:removeAura(u)
            end
            return oldUnitRemoveAbility(u, id)
        end)

        local oldSetUnitAbilityLevel
        oldSetUnitAbilityLevel = AddHook("SetUnitAbilityLevel", function (whichUnit, abilcode, level)
            local prevLevel = GetUnitAbilityLevel(whichUnit, abilcode)
            level = oldSetUnitAbilityLevel(whichUnit, abilcode, level)
            if abilcode == abilityId then
                local this = self.instanceUnits[whichUnit]
                this.level = level

                if prevLevel < this.level then
                    for l = prevLevel, this.level do
                        this:onLevelUp(l)
                    end
                elseif prevLevel > this.level then
                    for l = prevLevel, this.level, -1 do
                        this:onLevelUp(l)
                    end
                end
            end
            return level
        end)

        local oldIncUnitAbilityLevel
        oldIncUnitAbilityLevel = AddHook("IncUnitAbilityLevel", function (whichUnit, abilcode)
            local prev = GetUnitAbilityLevel(whichUnit, abilcode)
            local new = oldIncUnitAbilityLevel(whichUnit, abilcode)
            if abilcode == abilityId then
                if prev < new then
                    self.instanceUnits[whichUnit]:onLevelUp(new)
                end
            end
            return new
        end)

        local oldDecUnitAbilityLevel
        oldDecUnitAbilityLevel = AddHook("DecUnitAbilityLevel", function (whichUnit, abilcode)
            local prev = GetUnitAbilityLevel(whichUnit, abilcode)
            local new = oldDecUnitAbilityLevel(whichUnit, abilcode)
            if abilcode == abilityId then
                if prev > new then
                    self.instanceUnits[whichUnit]:onLevelUp(new)
                end
            end
            return new
        end)

        self.__index = self
        return self
    end

    ---@param u unit
    function AdvancedAura:affect(u)
        self.affectedCount = self.affectedCount + 1

        self:addBuff(u)
        self:addBonuses(u)
        self:addEffect(u)

        self:onAffect(u)
    end

    ---@param u unit
    function AdvancedAura:unaffect(u)
        self.affectedCount = self.affectedCount - 1

        self:removeBuff(u)
        self:removeBonuses(u)
        self:removeEffect(u)

        self:onUnaffect(u)
    end

    ---@param whichUnit unit
    function AdvancedAura:addAura(whichUnit)
        local this = self.instanceUnits[whichUnit]
        if not this then
            this = setmetatable({}, self)
            self.instanceUnits[whichUnit] = this
        end

        this.owner = whichUnit
        this.instanceGroup = CreateGroup()
        this.level = GetUnitAbilityLevel(whichUnit, self.abilityId)
        this.BUFF_LOCK = __jarray(0)
        this.bonusSaver = __jarray(0)
        this.EFFECT_LOCK = __jarray(0)
        this.TARGET_EFFECT = {}

        this:addOwnerEffect()
        this:auraInit()

        this.auraTimer = Timed.echo(self.INTERVAL, function ()
            if not this.pause then
                if GetUnitAbilityLevel(this.owner, self.abilityId) == 0 then
                    self:removeAura(this.owner)
                elseif not UnitAlive(this.owner) then
                    if IsUnitType(this.owner, UNIT_TYPE_HERO) then
                        this.pause = true
                        ForGroup(this.instanceGroup, function ()
                            this:unaffect(GetEnumUnit())
                            GroupRemoveUnit(this.instanceGroup, GetEnumUnit())
                        end)
                    else
                        self:removeAura(whichUnit)
                    end
                else
                    this.pause = false
                    this.level = GetUnitAbilityLevel(whichUnit, self.abilityId)

                    local add = {}

                    ForUnitsInRange(GetUnitX(this.owner), GetUnitY(this.owner), this:getAuraAoE(), function (enumUnit)
                        local b = this:onFilter(enumUnit)
                        if IsUnitInGroup(enumUnit, this.instanceGroup) and b then
                            this:onLoopUnit(enumUnit)
                        elseif b then
                            this:affect(enumUnit)
                        elseif IsUnitInGroup(enumUnit, this.instanceGroup) then
                            this:unaffect(enumUnit)
                        end

                        GroupRemoveUnit(this.instanceGroup, enumUnit)

                        if b then
                            table.insert(add, enumUnit)
                        end
                    end)
                    ForGroup(this.instanceGroup, function ()
                        this:unaffect(GetEnumUnit())
                        GroupRemoveUnit(this.instanceGroup, GetEnumUnit())
                    end)
                    for i = 1, #add do
                        GroupAddUnit(this.instanceGroup, add[i])
                    end
                    this:onLoop()
                end
            end
        end)
    end

    ---@param whichUnit unit
    function AdvancedAura:removeAura(whichUnit)
        local this = self.instanceUnits[whichUnit]
        if this then
            DestroyGroup(this.instanceGroup)
            this:removeOwnerEffect()
            this.auraTimer()
            self.instanceUnits[whichUnit] = nil
        end
    end

    ---@param u unit
    function AdvancedAura:addBuff(u)
        if self.BUFF ~= 0 then
            if self.BUFF_LOCK[u] == 0 then
                UnitAddAbility(u, self.BUFF)
                UnitMakeAbilityPermanent(u, true, self.BUFF)
            end
            self.BUFF_LOCK[u] = self.BUFF_LOCK[u] + 1
        end
    end

    ---@param u unit
    function AdvancedAura:removeBuff(u)
        if self.BUFF ~= 0 then
            self.BUFF_LOCK[u] = self.BUFF_LOCK[u] - 1
            if self.BUFF_LOCK[u] == 0 then
                UnitRemoveAbility(u, self.BUFF)
            end
        end
    end

    ---@param u unit
    function AdvancedAura:addBonuses(u)
        for bonusType, amount in pairs(self.bonusSaver) do
            if amount ~= 0 then
                AddUnitBonus(u, bonusType, amount)
            end
        end
    end

    ---@param u unit
    function AdvancedAura:removeBonuses(u)
        for bonusType, amount in pairs(self.bonusSaver) do
            if amount ~= 0 then
                AddUnitBonus(u, bonusType, -amount)
            end
        end
    end

    ---@param bonusType integer
    ---@param amount integer
    function AdvancedAura:setBonus(bonusType, amount)
        if self.bonusSaver[bonusType] ~= 0 then
            ForGroup(self.instanceGroup, function ()
                AddUnitBonus(GetEnumUnit(), bonusType, -self.bonusSaver[bonusType])
            end)
        end
        self.bonusSaver[bonusType] = amount
        if amount ~= 0 then
            ForGroup(self.instanceGroup, function ()
                AddUnitBonus(GetEnumUnit(), bonusType, amount)
            end)
        end
    end

    ---@param bonusType integer
    ---@return integer
    function AdvancedAura:getBonus(bonusType)
        return self.bonusSaver[bonusType]
    end

    ---@param u unit
    function AdvancedAura:addEffect(u)
        if self.EFFECT_LOCK[u] == 0 then
            self.TARGET_EFFECT[u] = AddSpecialEffectTarget(self.TARGET_SFX, u, self.TARGET_ATTACH)
        end
        self.EFFECT_LOCK[u] = self.EFFECT_LOCK[u] + 1
    end

    ---@param u unit
    function AdvancedAura:removeEffect(u)
        self.EFFECT_LOCK[u] = self.EFFECT_LOCK[u] - 1
        if self.EFFECT_LOCK[u] == 0 then
            DestroyEffect(self.TARGET_EFFECT[u])
            self.TARGET_EFFECT[u] = nil
        end
    end

    function AdvancedAura:addOwnerEffect()
        self.OWNER_EFFECT = AddSpecialEffectTarget(self.OWNER_SFX, self.owner, self.OWNER_ATTACH)
    end

    function AdvancedAura:removeOwnerEffect()
        DestroyEffect(self.OWNER_EFFECT)
        self.OWNER_EFFECT = nil
    end

    return AdvancedAura
end)
if Debug then Debug.endFile() end