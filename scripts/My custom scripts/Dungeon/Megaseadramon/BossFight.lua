Debug.beginFile("Megaseadramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O006_0036 ---@type unit

    local GL_BOLT_MODEL = "war3mapImported\\Great Lightning.mdl"
    local GL_AREA = 160.
    local GL_DAMAGE = 100.

    local function onGreatLightning(caster, x, y)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local owner = GetOwningPlayer(caster)
            -- Create the cloud
            DestroyEffect(AddSpecialEffect(GL_BOLT_MODEL, x, y))
            ForUnitsInRange(x, y, GL_AREA, function (u)
                if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                    Damage.apply(caster, u, GL_DAMAGE, true, false, udg_Air, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                end
            end)
        end)
    end

    local IP_ICE_CUBE = FourCC('n01C')
    local IP_DURATION = 9.

    local function onIcePrison(caster, target)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            -- Create the cube
            local cube = SummonMinion(caster, IP_ICE_CUBE, GetUnitX(target), GetUnitY(target), bj_UNIT_FACING, IP_DURATION)
            PauseUnit(target, true)
            SetUnitScale(cube.root, 1.2 * BlzGetUnitRealField(target, UNIT_RF_SCALING_VALUE) + 0.5, 1, 1)
            Timed.echo(0.02, function ()
                cube:setPos(GetUnitX(target), GetUnitY(target))
                if not cube:isAlive() then
                    PauseUnit(target, false)
                    return true
                end
            end)
        end)
    end

    local SS_CLOUD_MODEL = "Abilities\\Spells\\Human\\CloudOfFog\\CloudOfFog.mdl"
    local SS_DURATION = 8.
    local SS_COLOR = Color.new(0, 224, 255)
    local SS_AREA = 300.
    local SS_DAMAGE = 22.

    local function onSpontaneousStorm(caster, x, y)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            -- Create the cloud
            local cloud = AddSpecialEffect(SS_CLOUD_MODEL, x, y)
            BlzSetSpecialEffectZ(cloud, 200.)
            BlzSetSpecialEffectColor(cloud, SS_COLOR)
            BlzSetSpecialEffectScale(cloud, 2.5)
            Timed.echo(0.3, SS_DURATION, function ()
                ForUnitsInRange(x, y, SS_AREA, function (u)
                    if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                        Damage.apply(caster, u, SS_DAMAGE, true, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
            end, function ()
                DestroyEffect(cloud)
            end)
        end)
    end

    local CS_EFF1 = FourCC('SNhs') -- Northrend snow (heavy)
    local CS_EFF2 = FourCC('WOcw') -- Outland wind (heavy)
    local CS_AREA = 1400.
    local CS_DAMAGE = 5.
    local CS_DURATION = 55.

    local function onColdStorm(caster)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local x, y = GetUnitX(caster), GetUnitY(caster)
            -- Create the storm
            local re = Rect(x - 512, y - 512, x + 512, y + 512)
            local eff1 = AddWeatherEffect(re, CS_EFF1)
            local eff2 = AddWeatherEffect(re, CS_EFF2)
            EnableWeatherEffect(eff1, true)
            EnableWeatherEffect(eff2, true)

            Timed.call(1., function ()
                Timed.echo(4.5, CS_DURATION, function ()
                    ForUnitsInRange(x, y, CS_AREA, function (u)
                        if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                            Damage.apply(caster, u, CS_DAMAGE, true, false, udg_Water, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                            DummyCast(owner, GetUnitX(u), GetUnitY(u), ICE_SPELL, ICE_ORDER, 2, CastType.TARGET, u)
                        end
                    end)
                    if not UnitAlive(caster) then
                        RemoveWeatherEffect(eff1)
                        RemoveWeatherEffect(eff2)
                        RemoveRect(re)
                        return true
                    end
                end, function ()
                    RemoveWeatherEffect(eff1)
                    RemoveWeatherEffect(eff2)
                    RemoveRect(re)
                end)
            end)
        end)
    end

    InitBossFight({
        name = "Megaseadramon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofw_52791},
        inner = gg_rct_MegaseadramonInner,
        entrance = gg_rct_MegaseadramonEntrance,
        spells = {
            2, CastType.POINT, onGreatLightning, -- Great lightning
            2, CastType.TARGET, onIcePrison, -- Ice prison
            0, CastType.TARGET, onIcePrison, -- Ice prison
            2, CastType.POINT, onGreatLightning, -- Great lightning
            2, CastType.POINT, onSpontaneousStorm, -- Spontaneous storm
            3, CastType.IMMEDIATE, onColdStorm -- Cold storm
        },
        castCondition =  function (spell)
            if spell == onIcePrison then
                return GetUnitHPRatio(boss) < 0.7, true
            end
            return true
        end,
        actions = function (u)
        end
    })
end)
Debug.endFile()