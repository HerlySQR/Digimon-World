Debug.beginFile("Abilities\\New Illusion")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A0JB')
    local DURATION = 15.
    local DMG_DEALT = 1.
    local DMG_TAKEN = 1.5
    local AOE = 170.
    local NUMBER_OF_IMG = 2
    local DUMMY_ILLUSION = FourCC('A0JC')
    local ORDER = Orders.wandOfIllusion
    local DummyID = FourCC('n000')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)

        for _ = 1, NUMBER_OF_IMG do
            local dummy = CreateUnit(owner, DummyID, GetUnitX(caster), GetUnitY(caster), 0)
            UnitAddAbility(dummy, DUMMY_ILLUSION)
            local abil = BlzGetUnitAbility(dummy, DUMMY_ILLUSION)

            BlzSetAbilityRealLevelField(abil, ABILITY_RLF_DURATION_NORMAL, 0, DURATION)
            BlzSetAbilityRealLevelField(abil, ABILITY_RLF_DURATION_HERO, 0, DURATION)
            BlzSetAbilityRealLevelField(abil, ABILITY_RLF_AREA_OF_EFFECT, 0, AOE)
            BlzSetAbilityRealLevelField(abil, ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL, 0, DMG_DEALT)
            BlzSetAbilityRealLevelField(abil, ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER, 0, DMG_TAKEN)

            IssueTargetOrderById(dummy, ORDER, caster)

            UnitApplyTimedLife(dummy, FourCC("BTLF"), 5.)
        end
    end)
    
end)
Debug.endFile()