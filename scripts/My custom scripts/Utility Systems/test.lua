Debug.beginFile("test") local l = Debug.getLine()
OnInit(function ()
    Require "AddHook"

    local ROAR_BUFF = FourCC('Broa')

    ---@param caster unit
    ---@return number
    local function InternalGetAverageAttack(caster)
        local base = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
        local dice = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE, 0)
        local side = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE, 0)
        return base + (dice * (side + 1)) / 2
    end

    ---Returns the average attack damage of the unit
    ---@param caster unit
    ---@param damage? number
    ---@return number
    function GetBonusAttack(caster, damage)
        damage = damage or InternalGetAverageAttack(caster)
        local bonus = 0
        local i = 0
        while true do
            local spell = BlzGetUnitAbilityByIndex(caster, i)
            if not spell then break end
            local level = GetUnitAbilityLevel(caster, BlzGetAbilityId(spell)) - 1

            bonus = bonus
                -- + BlzGetAbilityIntegerLevelField(spell, ABILITY_ILF_ATTACK_BONUS, level) -- Attack bonus (Base damage?)
                + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_HAV3, level) -- Mountain King Avatar
                + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_IDAM, level) -- Orb
                + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_FAK1, level) -- Orb of Annihilation
                + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_IPV1, level) -- Vampirism Potion
                + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_NEG2, level) -- Tinker Engineering Upgrade
                + damage * (
                    (BlzGetAbilityId(spell) == ROAR_BUFF and 1 or -1) * BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1, level) -- Roar / Howl of terror
                    - BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_PENALTY, level) -- Soul burn
                    + BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1, level) -- Inner fire
                )

            -- Trueshot aura
            if IsUnitType(caster, UNIT_TYPE_RANGED_ATTACKER) then
                bonus = bonus + damage * BlzGetAbilityRealLevelField(spell, ABILITY_RLF_DAMAGE_BONUS_PERCENT, level)
            end

            -- Command aura
            local add = BlzGetAbilityRealLevelField(spell, ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1, level)
            if add > 0 then
                if (IsUnitType(caster, UNIT_TYPE_MELEE_ATTACKER) and BlzGetAbilityBooleanLevelField(spell, ABILITY_BLF_MELEE_BONUS, level))
                    or (IsUnitType(caster, UNIT_TYPE_RANGED_ATTACKER) and BlzGetAbilityBooleanLevelField(spell, ABILITY_BLF_RANGED_BONUS, level)) then

                    if BlzGetAbilityBooleanLevelField(spell, ABILITY_BLF_FLAT_BONUS, level) then
                        bonus = bonus + add
                    else
                        bonus = bonus + damage * add
                    end
                end
            end

            i = i + 1
        end
        return bonus
    end

    ---Returns the average attack damage of the unit
    ---@param caster unit
    ---@param withoutBonus? boolean
    ---@return number
    function GetAverageAttack(caster, withoutBonus)
        local damage = InternalGetAverageAttack(caster)
        return damage + (withoutBonus and 0 or GetBonusAttack(caster, damage))
    end

    GetAvarageAttack = GetAverageAttack -- ay

    local old
    old = AddHook("BlzGetAbilityRealLevelField", function (ability, abilityreallevelfield, integer)
        local get = old(ability, abilityreallevelfield, integer)
        if get > 0 then
            print(GetObjectName(BlzGetAbilityId(ability)), get)
            print(Debug.getLine(1) - l + 1)
        end
        return get
    end)
end)
Debug.endFile()