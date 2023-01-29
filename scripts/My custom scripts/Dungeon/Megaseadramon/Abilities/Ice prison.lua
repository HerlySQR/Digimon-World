Debug.beginFile("Megaseadramon\\Abilities\\Ice prison")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A00W')
    local ICE_CUBE = FourCC('n01C')
    local DURATION = 8.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local owner = GetOwningPlayer(caster)
        -- Create the cube
        local cube = CreateUnit(owner, ICE_CUBE, GetUnitX(target), GetUnitY(target), bj_UNIT_FACING)
        UnitApplyTimedLife(cube, FourCC("BTLF"), DURATION)
        PauseUnit(target, true)
        SetUnitScale(cube, 1.2 * BlzGetUnitRealField(target, UNIT_RF_SCALING_VALUE) + 0.5, 1, 1)
        Timed.echo(0.02, function ()
            SetUnitPosition(cube, GetUnitX(target), GetUnitY(target))
            if not UnitAlive(cube) then
                PauseUnit(target, false)
                return true
            end
        end)
    end)

end)
Debug.endFile()