Debug.beginFile("Abilities\\War Cry")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A012')
    local BUFF = FourCC('Broa')
    local ROOKIE_BONUS = 4
    local CHAMPION_BONUS = 8
    local ULTIMATE_BONUS = 12
    local MEGA_BONUS = 16

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()

        Digimon.enumInRange(GetUnitX(caster), GetUnitY(caster), BlzGetAbilityRealLevelField(BlzGetUnitAbility(caster, SPELL), ABILITY_RLF_AREA_OF_EFFECT, 0), function (d)
            if not d:hasAbility(BUFF) then
                Timed.call(0.02, function ()
                    if d:hasAbility(BUFF) then
                        if d.rank == Rank.ROOKIE then
                            AddUnitBonus(d.root, BONUS_DAMAGE, ROOKIE_BONUS)
                        elseif d.rank == Rank.CHAMPION then
                            AddUnitBonus(d.root, BONUS_DAMAGE, CHAMPION_BONUS)
                        elseif d.rank == Rank.ULTIMATE then
                            AddUnitBonus(d.root, BONUS_DAMAGE, ULTIMATE_BONUS)
                        elseif d.rank == Rank.MEGA then
                            AddUnitBonus(d.root, BONUS_DAMAGE, MEGA_BONUS)
                        end
                        Timed.echo(1., function ()
                            if not d:isAlive() or not d:hasAbility(BUFF) then
                                if d.rank == Rank.ROOKIE then
                                    AddUnitBonus(d.root, BONUS_DAMAGE, -ROOKIE_BONUS)
                                elseif d.rank == Rank.CHAMPION then
                                    AddUnitBonus(d.root, BONUS_DAMAGE, -CHAMPION_BONUS)
                                elseif d.rank == Rank.ULTIMATE then
                                    AddUnitBonus(d.root, BONUS_DAMAGE, -ULTIMATE_BONUS)
                                elseif d.rank == Rank.MEGA then
                                    AddUnitBonus(d.root, BONUS_DAMAGE, -MEGA_BONUS)
                                end
                                return true
                            end
                        end)
                    end
                end)
            end
        end)
    end)
end)
Debug.endFile()