Debug.beginFile("Meramon\\Abilities\\Summon PetitMeramon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0J1')
    local SUMMON_EFFECT = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
    local MERAMON_ID = FourCC('nlv3')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Meramon
        for _ = 1, 2 do
            local d = SummonMinion(caster, MERAMON_ID, x, y, GetUnitFacing(caster))
            DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
        end
    end)

end)
Debug.endFile()