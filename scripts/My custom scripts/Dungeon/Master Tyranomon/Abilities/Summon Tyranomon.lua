Debug.beginFile("Master Tyranomon\\Abilities\\Summon Tyranomon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0B2')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local TYRANOMON_ID = FourCC('O00M')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Tyranomon
        local d = SummonMinion(caster, TYRANOMON_ID, x, y, GetUnitFacing(caster))
        DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
        d:setLevel(GetHeroLevel(caster))
    end)

end)
Debug.endFile()