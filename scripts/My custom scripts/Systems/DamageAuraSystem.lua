Debug.beginFile("DamageAuraSystem")
OnInit("DamageAuraSystem", function ()
    local AdvancedAura = Require "AdvancedAura" ---@type AdvancedAura

    ---@param spell integer
    ---@param buff integer
    ---@param area number
    ---@param ownerEffect string
    ---@param attackBase number
    ---@param attackPreviousFactor number
    ---@param attackLevelFactor number
    ---@param attackConstantFactor number
    local function Create(spell, buff, area, ownerEffect, attackBase, attackPreviousFactor, attackLevelFactor, attackConstantFactor)
        local NewAura = AdvancedAura.create(spell)

        NewAura.BUFF = buff
        NewAura.OWNER_SFX = ownerEffect

        function NewAura:auraInit()
            self:setBonus(BONUS_DAMAGE, attackBase)
        end

        function NewAura:getAuraAoE()
            return area
        end

        function NewAura:onLevelUp(level)
            local attack = attackBase
            for l = 2, level do
                attack = attack * attackPreviousFactor + l * attackLevelFactor + attackConstantFactor
            end
            self:setBonus(BONUS_DAMAGE, R2I(attack))
        end
    end

    udg_DamageAuraCreate = CreateTrigger()
    TriggerAddAction(udg_DamageAuraCreate, function ()
        Create(
            udg_DamageAuraSpell,
            udg_DamageAuraBuff,
            udg_DamageAuraArea,
            udg_DamageAuraOwnerEffect,
            udg_DamageAuraAttackBase,
            udg_DamageAuraAttackPreviousFactor,
            udg_DamageAuraAttackLevelFactor,
            udg_DamageAuraAttackConstantFactor
        )
        udg_DamageAuraSpell = 0
        udg_DamageAuraBuff = 0
        udg_DamageAuraArea = 0.
        udg_DamageAuraOwnerEffect = ""
        udg_DamageAuraAttackBase = 0.
        udg_DamageAuraAttackPreviousFactor = 0.
        udg_DamageAuraAttackLevelFactor = 0.
        udg_DamageAuraAttackConstantFactor = 0.
    end)
end)
Debug.endFile()