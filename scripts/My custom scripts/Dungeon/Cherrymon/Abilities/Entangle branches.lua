Debug.beginFile("Cherrymon\\Abilities\\Entangle branches")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DE')
    local AREA = 300.
    local ENTANGLE = FourCC('A0DF')
    local DAMAGE = 10.
    local DURATION = 2. -- Same as object editor

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        ForUnitsInRange(x, y, AREA, function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                -- Entangle
                DummyCast(owner, x, y, ENTANGLE, Orders.entanglingroots, 1, CastType.TARGET, u)
                Timed.echo(1., DURATION, function ()
                    Damage.apply(caster, u, DAMAGE, false, false, udg_Nature, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                end)
            end
        end)
    end)
end)
Debug.endFile()