Debug.beginFile("Tonosama Gekomon\\Abilities\\Summon Gekomon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BH')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local GEKOMON_ID = FourCC('O017')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Gekomon
        for _ = 1, 2 do
            local d = Digimon.create(owner, GEKOMON_ID, x, y, GetUnitFacing(caster))
            DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
            d.isSummon = true
            d:setLevel(GetHeroLevel(caster))

            Timed.echo(1., function ()
                if not UnitAlive(caster) then
                    d:kill()
                    return true
                end
            end)
        end
    end)

end)
Debug.endFile()