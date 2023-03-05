Debug.beginFile("Garudamon\\Abilities\\Fly and Throw")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BO')
    local DAMAGE = 100.
    local AREA = 150.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        BossIsCasting(caster, true)

        UnitAddAbility(caster, CROW_FORM_ID)
        UnitRemoveAbility(caster, CROW_FORM_ID)

        SetUnitFlyHeight(caster, 200, 100)
        ShowUnitHide(target)
        local eff = AddSpecialEffectTarget("Units\\Human\\Phoenix\\PhoenixEgg.mdl", caster, "hand")
        BlzSetSpecialEffectScale(eff, 2)
        BlzSpecialEffectAddSubAnimation(eff, SUBANIM_TYPE_ALTERNATE_EX)
        BlzPlaySpecialEffect(eff, ANIM_TYPE_STAND)

        Timed.call(3, function ()
            if not UnitAlive(caster) then
                ShowUnitShow(target)
                BossIsCasting(caster, false)
            else
                SetUnitAnimation(caster, "attack")
                local x, y = GetUnitX(caster), GetUnitY(caster)
                local newTarget = GetRandomUnitOnRange(x, y, 700., function (u)
                    return RectContainsUnit(gg_rct_Garudamon_1, u) or RectContainsUnit(gg_rct_Garudamon_2, u) or RectContainsUnit(gg_rct_Garudamon_3, u)
                end)
                local targetX, targetY = table.unpack(newTarget and {GetUnitX(newTarget), GetUnitY(newTarget)} or {x + math.random(-128, 128), y + math.random(-128, 128)})

                SetUnitFacing(caster, math.deg(math.atan(targetY - y, targetX - x)))

                Timed.call(0.8, function ()
                    SetUnitFlyHeight(caster, GetUnitDefaultFlyHeight(caster), 100)
                    ResetUnitAnimation(caster)

                    BlzSetSpecialEffectScale(eff, 0.001)
                    DestroyEffect(eff)
                    local missile = Missiles:create(x, y, 200., targetX, targetY, newTarget and GetUnitFlyHeight(newTarget) or 0.)
                    missile:model("Units\\Human\\Phoenix\\PhoenixEgg.mdl")
                    missile:speed(800.)
                    missile:scale(2.)
                    missile.source = caster
                    missile.owner = GetOwningPlayer(caster)
                    missile.onFinish = function ()
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", missile.x, missile.y))
                        ForUnitsInRange(missile.x, missile.y, AREA, function (u)
                            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                                UnitDamageTarget(caster, u, DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                        SetUnitPosition(target, missile.x, missile.y)
                        ShowUnitShow(target)
                    end
                    missile:launch()
                    BossIsCasting(caster, false)
                end)
            end
        end)
    end)
end)
Debug.endFile()