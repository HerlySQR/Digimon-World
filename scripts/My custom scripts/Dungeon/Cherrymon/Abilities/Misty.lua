Debug.beginFile("Cherrymon\\Abilities\\Misty")
OnInit(function ()
    Require "BossFightUtils"
    Require "UnitEnterEvent"

    local SPELL = FourCC('A0DC')
    local DAMAGE = 5.
    local RANGE = 600. -- Same as object editor
    local CASTER_MODEL = "Abilities\\Spells\\Human\\CloudOfFog\\CloudOfFog.mdl"

    local effects = {} ---@type table<unit, effect>

    OnUnitEnter(function (u)
        if GetUnitAbilityLevel(u, SPELL) > 0 then
            Timed.echo(1., function ()
                if effects[u] then
                    local destroy = true
                    if UnitAlive(u) then
                        ForUnitsInRange(GetUnitX(u), GetUnitY(u), RANGE, function (u2)
                            if IsUnitEnemy(u, GetOwningPlayer(u2)) then
                                destroy = false
                                Damage.apply(u, u2, DAMAGE, false, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                    else
                        destroy = true
                    end
                    if destroy then
                        DestroyEffect(effects[u])
                        effects[u] = nil
                    end
                else
                    local create = false
                    if UnitAlive(u) then
                        ForUnitsInRange(GetUnitX(u), GetUnitY(u), RANGE, function (u2)
                            if IsUnitEnemy(u, GetOwningPlayer(u2)) then
                                create = true
                            end
                        end)
                    else
                        create = false
                    end
                    if create then
                        effects[u] = AddSpecialEffectTarget(CASTER_MODEL, u, "origin")
                        BlzSetSpecialEffectScale(effects[u], 5.)
                    end
                end
            end)
        end
    end)

end)
Debug.endFile()