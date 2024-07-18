Debug.beginFile("Tonosama Gekomon\\Abilities\\Big Leap")
OnInit(function ()
    Require "BossFightUtils"
    Require "JumpSystem"

    local SPELL = FourCC('A0BK')
    local SPEED = 700.
    local HEIGHT = 100.
    local STOMP = FourCC('A0BL')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        Jump(caster, GetSpellTargetX(), GetSpellTargetY(), SPEED, HEIGHT, nil, nil, function ()
            DummyCast(
                GetOwningPlayer(caster),
                GetUnitX(caster), GetUnitY(caster),
                STOMP,
                Orders.thunderclap,
                1,
                CastType.IMMEDIATE)
        end)
    end)
end)
Debug.endFile()