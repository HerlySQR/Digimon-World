Debug.beginFile("Panjyamon\\Abilities\\Ice Stomp")
OnInit(function ()
    Require "BossFightUtils"
    Require "JumpSystem"

    local SPELL = FourCC('A0DK')
    local DAMAGE = 100.
    local AREA = 225.
    local DURATION = 1.
    local HEIGHT = 100.^2
    local SPEED = math.sqrt(2)*DURATION
    local EFFECT = "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        Jump(caster, x + DURATION, y + DURATION, SPEED, HEIGHT, nil, nil, function ()
            for i = 1, 6 do
                DestroyEffect(AddSpecialEffect(EFFECT, x + (AREA*0.75)*math.cos(2*i*math.pi/6), y + (AREA*0.75)*math.sin(2*i*math.pi/6)))
            end
            DestroyEffect(AddSpecialEffect(EFFECT, x, y))
            ForUnitsInRange(x, y, AREA, function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    Damage.apply(caster, u, DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    DummyCast(
                        GetOwningPlayer(caster),
                        GetUnitX(u), GetUnitY(u),
                        ICE_SPELL,
                        ICE_ORDER,
                        1,
                        CastType.TARGET,
                        u
                    )
                end
            end)
        end)
    end)
end)
Debug.endFile()