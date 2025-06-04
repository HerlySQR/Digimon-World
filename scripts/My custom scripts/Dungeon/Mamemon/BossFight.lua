Debug.beginFile("Mamemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00A_0062 ---@type unit

    local KBP_DAMAGE = 35.
    local KBP_PUSH_DIST = 300.
    local KBP_AREA = 200.
    local KBP_PUNCH_EFFECT = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"
    local KBP_TARGET_UNIT_EFFECT = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"

    local function onKnockbackPunch(caster, target)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "attack")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)

            local x, y = GetUnitX(target), GetUnitY(target)

            ForUnitsInRange(x, y, KBP_AREA, function (u)
                if UnitAlive(u) and IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, KBP_DAMAGE, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                end
            end)
            DestroyEffect(AddSpecialEffect(KBP_PUNCH_EFFECT, x, y))

            -- Push the target
            if not IsUnitType(target, UNIT_TYPE_GIANT) then
                Knockback(
                    target,
                    math.atan(y - GetUnitY(caster), x - GetUnitX(caster)),
                    KBP_PUSH_DIST,
                    2400.,
                    KBP_TARGET_UNIT_EFFECT,
                    nil,
                    false
                )
            end
        end)
    end

    local KUP_DAMAGE = 60.
    local KUP_FLY_DIST = 600.
    local KUP_SPEED = 70.
    local KUP_AREA = 200.
    local KUP_FALL_EFFECT = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"

    local function onKnockupPunch(caster, target)
        SetUnitAnimation(caster, "slam")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)

            local speed = 1400.

            UnitAddAbility(target, CROW_FORM_ID)
            UnitRemoveAbility(target, CROW_FORM_ID)
            PauseUnit(target, true)

            Timed.echo(0.04, function ()
                speed = speed - KUP_SPEED
                if speed > -1400. then
                    local rate
                    local goal
                    if speed >= 0. then
                        rate = speed
                        goal = KUP_FLY_DIST
                    else
                        rate = -speed
                        goal = 0.
                    end
                    SetUnitFlyHeight(target, goal, rate)
                else
                    local posX, posY = GetUnitX(target), GetUnitY(target)
                    local owner = GetOwningPlayer(caster)
                    DestroyEffect(AddSpecialEffect(KUP_FALL_EFFECT, posX, posY))
                    TerrainDeformationRippleBJ(2., false, Location(posX, posY), KUP_AREA, KUP_AREA, 64., 1., KUP_AREA)

                    ForUnitsInRange(posX, posY, KUP_AREA, function (u)
                        if IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                            Damage.apply(caster, u, KUP_DAMAGE, true, false, udg_Machine, DAMAGE_TYPE_SONIC, WEAPON_TYPE_ROCK_HEAVY_BASH)
                        end
                    end)
                    PauseUnit(target, false)
                    SetUnitFlyHeight(target, GetUnitDefaultFlyHeight(target), 1000.)
                    return true
                end
            end)
        end)
    end

    InitBossFight({
        name = "Mamemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_52789},
        inner = gg_rct_MamemonInner,
        entrance = gg_rct_MamemonEntrance,
        moveOption = 0,
        spells = {
            4, CastType.TARGET, onKnockbackPunch, -- Knockback punch
            4, CastType.TARGET, onKnockupPunch, -- Knockup punch
        },
        extraSpells = {
            FourCC('A0B6'), Orders.roar, CastType.IMMEDIATE, -- Increase Damage
            FourCC('A0J0'), Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Mudfrigimon
            FourCC('A09L'), Orders.inferno, CastType.POINT -- Smiley bomb
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()