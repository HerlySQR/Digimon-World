Debug.beginFile("Meramon\\Abilities\\MeltAll")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0H4')
    local MELT_SPELL = FourCC('A07D')
    local MELT_ORDER = Orders.faeriefire
    local AREA = 300. -- Same as object editor

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)

        ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), AREA, function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                DummyCast(owner,
                          GetUnitX(caster), GetUnitY(caster),
                          MELT_SPELL,
                          MELT_ORDER,
                          1,
                          CastType.TARGET,
                          u)
            end
        end)
    end)
end)
Debug.endFile()