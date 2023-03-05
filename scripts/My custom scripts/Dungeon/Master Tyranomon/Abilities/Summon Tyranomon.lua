Debug.beginFile("Master Tyranomon\\Abilities\\Summon Tyranomon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0B2')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local TYRANOMON_ID = FourCC('O00K')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Tyranomon
        local d = Digimon.create(owner, TYRANOMON_ID, x, y, GetUnitFacing(caster))
        DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))
        d.isSummon = true
        d:setLevel(GetHeroLevel(caster))

        Timed.echo(1., function ()
            if not UnitAlive(caster) then
                d:kill()
                return true
            end
        end)
    end)

end)
Debug.endFile()