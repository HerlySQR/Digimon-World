Debug.beginFile("Cherrymon\\Abilities\\Misty")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DC')
    local DAMAGE = 5.
    local RANGE = 600. -- Same as object editor
    local CASTER_MODEL = "Abilities\\Spells\\Human\\CloudOfFog\\CloudOfFog.mdl"

    local effects = {} ---@type table<unit, effect>

    Digimon.createEvent:register(function (new)
        local u = new.root ---@type unit
        if GetUnitAbilityLevel(u, SPELL) > 0 then
            local t = CreateTrigger()
            TriggerRegisterUnitInRange(t, u, RANGE)
            TriggerAddAction(t, function ()
                if not effects[u] and IsUnitEnemy(u, GetOwningPlayer(GetTriggerUnit())) then
                    effects[u] = AddSpecialEffectTarget(CASTER_MODEL, u, "origin")
                    BlzSetSpecialEffectScale(effects[u], 5.)
                    Timed.echo(1., function ()
                        local destroy = true
                        ForUnitsInRange(GetUnitX(u), GetUnitY(u), RANGE, function (u2)
                            if IsUnitEnemy(u, GetOwningPlayer(u2)) then
                                destroy = false
                                Damage.apply(u, u2, DAMAGE, false, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                        if destroy then
                            DestroyEffect(effects[u])
                            effects[u] = nil
                            return true
                        end
                    end)
                end
            end)
        end
    end)

end)
Debug.endFile()