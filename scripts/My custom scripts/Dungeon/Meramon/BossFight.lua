Debug.beginFile("Meramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    local SH_DURATION = 8. -- seconds
    local SH_DAMAGE = 4. -- per second
    local SH_AREA = 1200.
    local SH_INTERVAL = 1.0
    local SH_DMG_PER_TICK = SH_DAMAGE * SH_INTERVAL

    local function onScorchingHeat(caster)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", caster, "origin")
            BlzSetSpecialEffectScale(eff, 2.)
            Timed.echo(SH_INTERVAL, SH_DURATION, function ()
                ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), SH_AREA, function (u)
                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                        UnitDamageTarget(caster, u, SH_DMG_PER_TICK, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", u, "chest"))
                    end
                end)
                if not UnitAlive(caster) then
                    BossIsCasting(caster, false)
                    BlzSetSpecialEffectScale(eff, 0.01)
                    DestroyEffect(eff)
                    return true
                end
            end, function ()
                BossIsCasting(caster, false)
                BlzSetSpecialEffectScale(eff, 0.01)
                DestroyEffect(eff)
            end)
        end)
    end

    local MELT_SPELL = FourCC('A07D')
    local MELT_ORDER = Orders.faeriefire
    local MA_AREA = 1500. -- Same as object editor

    local function onMeltAll(caster)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), MA_AREA, function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    DummyCast(owner,
                            GetUnitX(caster), GetUnitY(caster),
                            MELT_SPELL,
                            MELT_ORDER,
                            1,
                            CastType.TARGET,
                            u)
                end
            end)
        end)
    end

    local LE_DURATION = 7. -- seconds
    local LE_DAMAGE = 40. -- per explosion
    local LE_MIN_DIST = 50.
    local LE_AREA = 650.
    local LE_AREA_EXP = 125.
    local LE_INTERVAL = 0.5

    local function onLavaExplosions(caster)
        BossIsCasting(caster, true)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            Timed.echo(LE_INTERVAL, LE_DURATION, function ()
                for _ = 1, math.random(1, 4) do
                    local angle = 2 * math.pi * math.random()
                    local dist = LE_MIN_DIST + LE_AREA * math.random()
                    local x = GetUnitX(caster) + dist * math.cos(angle)
                    local y = GetUnitY(caster) + dist * math.sin(angle)

                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoMissile.mdl", x, y))
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl", x, y))

                    ForUnitsInRange(x, y, LE_AREA_EXP, function (u)
                        if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                            UnitDamageTarget(caster, u, LE_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                end
            end, function ()
                BossIsCasting(caster, false)
            end)
        end)
    end

    InitBossFight({
        name = "Meramon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52788},
        inner = gg_rct_MeramonInner,
        entrance = gg_rct_MeramonEntrance,
        moveOption = 3,
        spells = {
            4, CastType.IMMEDIATE, onScorchingHeat, -- Scorching heat
            0, CastType.IMMEDIATE, onMeltAll, -- Melt All
            5, CastType.IMMEDIATE, onLavaExplosions -- Lava explosions
        },
        extraSpells = {
            FourCC('A02A'), Orders.firebolt, CastType.TARGET, -- Fire ball attack
            FourCC('A0J1'), Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Petit Meramon
        },
        castCondition = function (spell)
            if spell == onMeltAll then
                return GetUnitHPRatio(boss) < 0.5
            end
            return true
        end,
        actions = function (u)
        end
    })
end)
Debug.endFile()