Debug.beginFile("King Sukamon\\Abilities\\Generic Ward of damage")
OnInit(function ()
    Require "BossFightUtils"

    local WARD = FourCC('o00Y')
    local SLOW = FourCC('BUau')
    local DAMAGE_PER_SEC = 10.
    local AREA = 350.

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SUMMON)
    TriggerAddAction(t, function ()
        local ward = GetSummonedUnit()
        if GetUnitTypeId(ward) == WARD then
            local caster = GetSummoningUnit()
            local owner = GetOwningPlayer(ward)
            local x, y = GetUnitX(ward), GetUnitY(ward)
            Timed.echo(1.,function ()
                if UnitAlive(ward) then
                    ForUnitsInRange(x, y, AREA, function (u)
                        if UnitHasBuffBJ(u, SLOW) and IsUnitEnemy(u, owner) then
                            Damage.apply(caster, u, DAMAGE_PER_SEC, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                else
                    return true
                end
            end)
        end
    end)

end)
Debug.endFile()