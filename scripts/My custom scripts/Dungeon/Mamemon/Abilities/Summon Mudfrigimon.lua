Debug.beginFile("Mamemon\\Abilities\\Summon Mudfrigimon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0J0')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local MUDFRIGIMON = FourCC('O074')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)

        local d = SummonMinion(caster, MUDFRIGIMON, x, y, GetUnitFacing(caster))
        DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
        d:setLevel(GetHeroLevel(caster))
    end)

end)
Debug.endFile()