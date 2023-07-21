Debug.beginFile("DamageAuraSystem")
OnInit("DamageAuraSystem", function ()
    Require "NewBonus"
    Require "AddHook"
    Require "Timed"
    Require "Set"
    Require "AbilityUtils"

    local Datas = {} ---@type table<integer, {buff: integer, attackBase: number, attackPreviousFactor: number, attackLevelFactor: number, attackConstantFactor: number, value: integer, prevLevel: integer}>
    local Units = Set.create()
    local Groups = {} ---@type table<unit, group>

    ---@param spell integer
    ---@param buff integer
    ---@param attackBase number
    ---@param attackPreviousFactor number
    ---@param attackLevelFactor number
    ---@param attackConstantFactor number
    local function Create(spell, buff, attackBase, attackPreviousFactor, attackLevelFactor, attackConstantFactor)
        Datas[spell] = {
            buff = buff,
            attackBase = attackBase,
            attackPreviousFactor = attackPreviousFactor,
            attackLevelFactor = attackLevelFactor,
            attackConstantFactor = attackConstantFactor,
            value = 0,
            prevLevel = 0
        }
    end

    Timed.call(1., function ()
        for u in Units:elements() do
            local i = 0
            local remove = true
            while true do
                local spell = BlzGetUnitAbilityByIndex(u, i)
                if not spell then break end
                local id = BlzGetAbilityId(spell)
                local data = Datas[id]
                if data then
                    remove = false
                    local g = Groups[u]
                    if not g then
                        g = CreateGroup()
                        Groups[u] = g
                    end

                    local level = GetUnitAbilityLevel(u, id)
                    local area = BlzGetAbilityRealLevelField(spell, ABILITY_RLF_AREA_OF_EFFECT, level - 1)

                    ForGroup(g, function ()
                        local u2 = GetEnumUnit()
                        if (DistanceBetweenCoords(GetUnitX(u), GetUnitY(u), GetUnitX(u2), GetUnitY(u2)) + BlzGetUnitCollisionSize(u2)) > area then
                            GroupRemoveUnit(g, u2)
                            AddUnitBonus(u2, BONUS_DAMAGE, -data.value)
                        end
                    end)

                    if data.prevLevel ~= level then
                        ForGroup(g, function ()
                            AddUnitBonus(GetEnumUnit(), BONUS_DAMAGE, -data.value)
                        end)
                        local attack = data.attackBase
                        for l = 2, level do
                            attack = attack * data.attackPreviousFactor + l * data.attackLevelFactor + data.attackConstantFactor
                        end
                        data.value = R2I(attack)
                        data.prevLevel = level
                        ForGroup(g, function ()
                            AddUnitBonus(GetEnumUnit(), BONUS_DAMAGE, data.value)
                        end)
                    end

                    ForUnitsInRange(GetUnitX(u), GetUnitY(u), area, function (u2)
                        if not IsUnitInGroup(u2, g) and IsUnitAlly(u, GetOwningPlayer(u2)) then
                            GroupAddUnit(g, u2)
                            AddUnitBonus(u2, BONUS_DAMAGE, data.value)
                        end
                    end)
                end
                i = i + 1
            end
            if remove then
                DestroyGroup(Groups[u])
                Groups[u] = nil
                Units:removeSingle(u)
            end
        end
    end)

    local oldUnitAddAbility
    oldUnitAddAbility = AddHook("UnitAddAbility", function (whichUnit, abilityId)
        if Datas[abilityId] then
            Units:addSingle(whichUnit)
        end
        return oldUnitAddAbility(whichUnit, abilityId)
    end)

    udg_DamageAuraCreate = CreateTrigger()
    TriggerAddAction(udg_DamageAuraCreate, function ()
        Create(
            udg_DamageAuraSpell,
            udg_DamageAuraBuff,
            udg_DamageAuraAttackBase,
            udg_DamageAuraAttackPreviousFactor,
            udg_DamageAuraAttackLevelFactor,
            udg_DamageAuraAttackConstantFactor
        )
        udg_DamageAuraSpell = 0
        udg_DamageAuraBuff = 0
        udg_DamageAuraAttackBase = 0.
        udg_DamageAuraAttackPreviousFactor = 0.
        udg_DamageAuraAttackLevelFactor = 0.
        udg_DamageAuraAttackConstantFactor = 0.
    end)
end)
Debug.endFile()