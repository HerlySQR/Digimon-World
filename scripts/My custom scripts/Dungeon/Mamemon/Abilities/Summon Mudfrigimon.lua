Debug.beginFile("Mamemon\\Abilities\\Summon Mudfrigimon")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0J0')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local MUDFRIGIMON = FourCC('O074')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)

        local d = Digimon.create(owner, MUDFRIGIMON, x, y, GetUnitFacing(caster))
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