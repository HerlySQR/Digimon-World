Debug.beginFile("Skull Satamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    local Color = Require "Color" ---@type Color

    local PILLAR = FourCC('n01T')
    local VILEMON = FourCC('O034')
    local PILAR_EFFECT = "Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualCaster.mdl"
    local VILEMON_EFFECT = "Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl"
    local RESTORE_EFFECT = "Objects\\Spawnmodels\\Undead\\UDeathMedium\\UDeath.mdl"
    local LIGHTNING_MODEL = "HWPB"
    local BOSS_EFFECT = "Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl"
    local FIRE_PILLAR = FourCC('A0DY')

    local boss = gg_unit_O03B_0069 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.25
    local pillarPos = {GetRectCenter(gg_rct_SkullSatamonPilar1), GetRectCenter(gg_rct_SkullSatamonPilar2)}
    local pillar = {CreateUnitAtLoc(Digimon.VILLAIN, PILLAR, pillarPos[1], bj_UNIT_FACING), CreateUnitAtLoc(Digimon.VILLAIN, PILLAR, pillarPos[2], bj_UNIT_FACING)}
    local phase = {false, false}
    local times = {30., 45.}
    local minions = {2, 4}
    local metamorphosis = false
    local white = Color.new(0xFFFFFFFF)
    local gray = Color.new(0xFF666666)

    ---@param i integer
    local function restartPilar(i)
        phase[i] = false
        if UnitAlive(pillar[i]) then
            SetUnitInvulnerable(pillar[i], true)
            SetUnitState(pillar[i], UNIT_STATE_LIFE, GetUnitState(pillar[i], UNIT_STATE_MAX_LIFE))
        else
            pillar[i] = CreateUnitAtLoc(Digimon.VILLAIN, PILLAR, pillarPos[i], bj_UNIT_FACING)
        end
        DestroyEffect(AddSpecialEffectLoc(RESTORE_EFFECT, pillarPos[i]))
    end

    ---@param i integer
    local function phaseActions(i)
        phase[i] = true
        DestroyEffect(AddSpecialEffectTarget(BOSS_EFFECT, boss, "origin"))

        SetUnitInvulnerable(pillar[i], false)
        DestroyEffect(AddSpecialEffect(PILAR_EFFECT, GetUnitX(pillar[i]), GetUnitY(pillar[i])))
        SetUnitInvulnerable(boss, true)

        local needToKill = CreateGroup()
        GroupAddUnit(needToKill, pillar[i])
        local x, y = GetUnitX(boss), GetUnitY(boss)
        local vilemons = {} ---@type Digimon[]

        for j = 1, minions[i] do
            local angle = 2*math.pi * math.random()
            local dist = 100 + 100 * math.random()
            vilemons[j] = SummonMinion(boss, VILEMON, x + dist * math.cos(angle), y + dist * math.sin(angle), bj_UNIT_FACING)
            vilemons[j]:setLevel(GetHeroLevel(boss))
            DestroyEffect(AddSpecialEffect(VILEMON_EFFECT, vilemons[j]:getPos()))
            GroupAddUnit(needToKill, vilemons[j].root)
        end

        local chain = AddLightningEx(LIGHTNING_MODEL, true, GetUnitX(pillar[i]), GetUnitY(pillar[i]), GetUnitZ(pillar[i]) + 50, x, y, GetUnitZ(boss) + 75)
        Timed.echo(0.1, times[i], function ()
            if UnitAlive(pillar[i]) and phase[i] then
                MoveLightningEx(chain, true, GetUnitX(pillar[i]), GetUnitY(pillar[i]), GetUnitZ(pillar[i]) + 50, GetUnitX(boss), GetUnitY(boss), GetUnitZ(boss) + 75)
            else
                DestroyLightning(chain)
                return true
            end
        end, function ()
            SetUnitState(boss, UNIT_STATE_LIFE, GetUnitState(boss, UNIT_STATE_LIFE) + 0.15 * GetUnitState(boss, UNIT_STATE_MAX_LIFE))
            DestroyLightning(chain)
        end)

        Timed.echo(1., function ()
            if GroupDead(needToKill) then
                SetUnitInvulnerable(boss, false)
                DestroyGroup(needToKill)
                return true
            end
            if not phase[i] then
                for j = 1, minions[i] do
                    if vilemons[j]:isAlive() then
                        DestroyEffect(AddSpecialEffect(VILEMON_EFFECT, vilemons[j]:getPos()))
                        vilemons[j]:destroy()
                    end
                end
                DestroyGroup(needToKill)
                return true
            end
        end)
    end

    local J_MISSILE_MODEL = "Abilities\\Spells\\Undead\\DarkSummoning\\DarkSummonMissile.mdl"
    local J_TARGET_EFFECT = "Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl"
    local J_JAIL_EFFECT = "Abilities\\Spells\\Undead\\UnholyAura\\UnholyAura.mdl"
    local J_KILL_EFFECT = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"
    local J_DMG_PER_SEC = 60.

    local J_jails = {gg_dest_B07X_52154, gg_dest_B07X_52152, gg_dest_B07X_52153} ---@type destructable[]
    local J_facings = {190.99, 164.85, 119.37} -- Why there is not a GetDestructableFacing function?
    local J_positions = {} ---@type location[]
    local J_offsets = {} ---@type location[]
    local J_used = __jarray(false) ---@type boolean[]
    local J_prisoner = {} ---@type unit[]
    local J_isCaged = __jarray(false) ---@type table<player, boolean>
    local J_stop = {} ---@type function[]

    ---@param i integer
    local function restartJail(i)
        SetUnitFlyHeight(J_prisoner[i], GetUnitDefaultFlyHeight(J_prisoner[i]), 0)
        SetUnitInvulnerable(J_prisoner[i], false)
        SetUnitPathing(J_prisoner[i], true)
        PauseUnit(J_prisoner[i], false)
        J_isCaged[GetOwningPlayer(J_prisoner[i])] = false
        J_prisoner[i] = nil
        if J_stop[i] then
            J_stop[i]()
            J_stop[i] = nil
        end
        Timed.call(2 + 3*math.random(), function ()
            local eff = AddSpecialEffectLoc(J_JAIL_EFFECT, J_positions[i])
            Timed.call(2., function ()
                DestroyEffect(eff)
                DestructableRestoreLife(J_jails[i], GetDestructableMaxLife(J_jails[i]), true)
                SetDestructableInvulnerable(J_jails[i], true)
                J_used[i] = false
            end)
        end)
    end

    for i = 1, #J_jails do
        SetDestructableInvulnerable(J_jails[i], true)
        J_positions[i] = GetDestructableLoc(J_jails[i])
        J_offsets[i] = PolarProjectionBJ(J_positions[i], 80., J_facings[i])
        local t = CreateTrigger()
        TriggerRegisterDeathEvent(t, J_jails[i])
        TriggerAddAction(t, function ()
            if J_prisoner[i] then
                restartJail(i)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_CHANGE_OWNER)
        TriggerAddAction(t, function ()
            local u = GetTriggerUnit()
            local stop = true
            for i = 1, #J_jails do
                if J_prisoner[i] == u then
                    restartJail(i)
                    stop = false
                    break
                end
            end

            if stop then
                return
            end

            if Digimon.getInstance(u) then
                local p = Digimon.getInstance(u).owner
                if PlayerIsStucked(p) then
                    for j = 1, #J_jails do
                        if J_prisoner[j] and GetOwningPlayer(J_prisoner[j]) == p then
                            Timed.call(2., function ()
                                local u2 = J_prisoner[j]
                                KillDestructable(J_jails[j]) -- This sets prisoner[j] to nil
                                KillUnit(u2)
                                DestroyEffect(AddSpecialEffectLoc(J_KILL_EFFECT, J_offsets[j]))
                            end)
                        end
                    end
                end
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterUnitEvent(t, boss, EVENT_UNIT_DEATH)
        TriggerAddAction(t, function ()
            for j = 1, #J_jails do
                if J_prisoner[j] then
                    KillDestructable(J_jails[j])
                end
            end
        end)
    end

    local function onJail(caster, target)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            for i = 1, #J_jails do
                if not J_used[i] and IsDestructableAliveBJ(J_jails[i]) then
                    J_used[i] = true
                    J_prisoner[i] = target
                    J_isCaged[GetOwningPlayer(target)] = true
                    BossIgnoreUnit(caster, target, true)

                    local eff = AddSpecialEffectTarget(J_TARGET_EFFECT, target, "origin")
                    SetUnitInvulnerable(target, true)
                    PauseUnit(target, true)
                    SetUnitPathing(target, false)
                    Timed.call(3., function ()
                        DestroyEffect(eff)
                        ShowUnit(target, false)
                        UnitAddAbility(target, CROW_FORM_ID)
                        UnitRemoveAbility(target, CROW_FORM_ID)
                        SetUnitFlyHeight(target, 50., 0)

                        local m = Missiles:create(GetUnitX(target), GetUnitY(target), GetUnitZ(target), GetLocationX(J_positions[i]), GetLocationY(J_positions[i]), 50)
                        m.owner = GetOwningPlayer(caster)
                        m:model(J_MISSILE_MODEL)
                        m:speed(700)
                        m.onFinish = function ()
                            ShowUnit(target, true)
                            SetUnitX(target, GetLocationX(J_offsets[i]))
                            SetUnitY(target, GetLocationY(J_offsets[i]))
                            SetUnitFacing(target, J_facings[i])
                            SetDestructableInvulnerable(J_jails[i], false)
                            local cb = Timed.echo(1., function ()
                                SetUnitInvulnerable(target, false)
                                Damage.apply(caster, target, J_DMG_PER_SEC, false, false, udg_Dark, DAMAGE_TYPE_DEATH, WEAPON_TYPE_WHOKNOWS)
                                SetUnitInvulnerable(target, true)
                            end)
                            J_stop[i] = function ()
                                cb()
                                BossIgnoreUnit(caster, target, false)
                            end
                        end
                        m:launch()
                    end)

                    if Digimon.getInstance(target) then
                        local p = Digimon.getInstance(target).owner
                        if PlayerIsStucked(p) then
                            for j = 1, #J_jails do
                                if J_prisoner[j] and GetOwningPlayer(J_prisoner[j]) == p then
                                    Timed.call(5., function ()
                                        local u = J_prisoner[j]
                                        KillDestructable(J_jails[j]) -- This sets prisoner[j] to nil
                                        KillUnit(u)
                                        DestroyEffect(AddSpecialEffectLoc(J_KILL_EFFECT, J_offsets[j]))
                                    end)
                                end
                            end
                        end
                    end

                    break
                end
            end
        end)
    end

    local T_SPELL = FourCC('A0DW')
    local T_DELAY = 2.5

    local function onThunderclap(caster)
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_AQUA)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, T_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/T_DELAY)*100, 1)
        end, function ()
            bar:destroy()
            BossIsCasting(caster, false)
            DummyCast(GetOwningPlayer(caster), GetUnitX(caster), GetUnitY(caster), T_SPELL, Orders.thunderclap, metamorphosis and 2 or 1, CastType.IMMEDIATE)
        end)
    end

    local FP_FIRE_MODEL = "Doodads\\Cinematic\\TownBurningFireEmitter\\TownBurningFireEmitter"
    local FP_AREA = 200.
    local FP_DAMAGE = 350.

    local function onFirePillar(caster, x, y)
        local owner = GetOwningPlayer(caster)

        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            -- Create the fire
            local circle = AddSpecialEffect("war3mapImported\\EnduranceAuraTarget.mdl", x, y)
            BlzSetSpecialEffectScale(circle, 0.75)
            Timed.call(1.5, function ()
                DestroyEffect(circle)

                local fire = AddSpecialEffect(FP_FIRE_MODEL, x, y)
                BlzSetSpecialEffectTime(fire, 0)

                Timed.echo(3.3, function ()
                    ForUnitsInRange(x, y, FP_AREA, function (u)
                        if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                            Damage.apply(caster, u, FP_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                    if not UnitAlive(caster) or not GetRandomUnitOnRange(GetUnitX(caster), GetUnitY(caster), 700, function (u2) return IsUnitEnemy(u2, owner) end) then
                        DestroyEffect(fire)
                        return true
                    end
                end)
            end)
        end)
    end

    InitBossFight({
        name = "SkullSatamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_31899},
        inner = gg_rct_SkullSatamonInner,
        entrance = gg_rct_SkullSatamonEntrance,
        moveOption = 1,
        spells = {
            8, CastType.TARGET, onJail, -- Jail
            5, CastType.IMMEDIATE, onThunderclap, -- Thunderclap
            4, CastType.TARGET, onJail, -- Jail
            6, CastType.POINT, onFirePillar -- Fire Pillar
        },
        extraSpells = {
            FourCC('A09E'), Orders.carrionswarm, CastType.POINT, -- Nail bone
            FourCC('A07H'), Orders.cripple, CastType.TARGET, -- Cripple
        },
        castCondition = function (spell, target)
            if spell == onJail then
                return not J_isCaged[GetOwningPlayer(target)], true
            elseif spell == onFirePillar then
                return metamorphosis, true
            end
            return true
        end,
        actions = function (u)
            if not phase[1] then
                if GetUnitHPRatio(boss) < 0.7 then
                    phaseActions(1)
                end
            end
            if not phase[2] then
                if GetUnitHPRatio(boss) < 0.4 then
                    phaseActions(2)
                end
            end
            if not metamorphosis then
                if not UnitAlive(pillar[1]) and not UnitAlive(pillar[2]) then
                    metamorphosis = true
                    UnitAddAbility(boss, FIRE_PILLAR)
                    BossChangeAttack(boss, 1)
                    local current = 0
                    Timed.echo(0.02, 1., function ()
                        SetUnitVertexColor(boss, white:lerp(gray, current))
                        SetUnitScale(boss, Lerp(originalSize, current, increasedSize), 0., 0.)
                        current = current + 0.02
                    end)
                end
            end
        end,
        onReset = function ()
            if metamorphosis then
                metamorphosis = false
                UnitRemoveAbility(boss, FIRE_PILLAR)
                BossChangeAttack(boss, 0)
                local current = 0
                Timed.echo(0.02, 1., function ()
                    SetUnitVertexColor(boss, gray:lerp(white, current))
                    SetUnitScale(boss, Lerp(increasedSize, current, originalSize), 0., 0.)
                    current = current + 0.02
                end)
            end

            restartPilar(1)
            restartPilar(2)

            SetUnitInvulnerable(boss, false)
        end
    })
end)
Debug.endFile()