Debug.beginFile("Tonosama Gekomon\\Abilities\\Summon Gekomon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BH')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local GEKOMON_ID = FourCC('O01A')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Gekomon
        for _ = 1, 3 do
            local d = SummonMinion(caster, GEKOMON_ID, x, y, GetUnitFacing(caster))
            DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
            d:setLevel(GetHeroLevel(caster))
        end
    end)

end)
Debug.endFile()