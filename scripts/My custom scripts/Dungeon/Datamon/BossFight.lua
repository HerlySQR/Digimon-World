Debug.beginFile("Datamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    Require "SyncedTable"
    Require "Set"
    local Color = Require "Color" ---@type Color

    local GENERATOR = FourCC('n01U')
    local ELECTRIC_TRAP_DAMAGE = 15.
    local ELECTRIC_TRAP_TICKS_CD = 8
    local ELECTRIC_TRAP_EFFECT = "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldBuff.mdl"
    local ENERGY_FIELD = FourCC('YZef')
    local RESTORE_EFFECT = "Objects\\Spawnmodels\\Undead\\UDeathSmall\\UDeathSmall.mdl"
    local TELEPORT_EFFECT = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl"
    local TELEPORT_EFFECT_TARGET = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    local GUARDROMON = FourCC('O01I')
    local GUARDROMON_EFFECT = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl"
    local MISSILE_BARRAGE = FourCC('A0E0')

    local boss = gg_unit_O03P_0105 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.25
    local originalTargetsAllowed = BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0)
    local originalBaseDamage = BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
    local originalMoveSpeed = GetUnitMoveSpeed(boss)
    local cooldown = ELECTRIC_TRAP_TICKS_CD
    local generators = {gg_unit_n01U_0110, gg_unit_n01U_0112, gg_unit_n01U_0114, gg_unit_n01U_0113} ---@type unit[]
    local generatorsPos = {} ---@type location[]
    local generatorRect = gg_rct_Datamon_Generators ---@type rect
    local generatorUnits = Set.create()
    local returnPlace = gg_rct_Datamon_Return ---@type rect
    local canTrap = true
    local secondPhase = false
    local observerPos = GetRectCenter(gg_rct_Datamon_Observer)
    local minions = 2
    local metamorphosis = false
    local goMetamorphosis = false
    local white = Color.new(0xFFFFFFFF)
    local gray = Color.new(0xFF666666)
    local canSeeHim = SyncedTable.create() ---@type table<player, boolean>

    local hommingMissileOrder = Orders.shadowstrike
    local missileBarrageOrder = Orders.blackarrow

    for i = 1, #generators do
        generatorsPos[i] = GetUnitLoc(generators[i])
    end

    local function restartGenerators()
        if canTrap then
            return
        end
        for i = 1, #generators do
            local showEff = false
            if UnitAlive(generators[i]) then
                if GetUnitState(generators[i], UNIT_STATE_LIFE) < GetUnitState(generators[i], UNIT_STATE_MAX_LIFE) then
                    SetUnitState(generators[i], UNIT_STATE_LIFE, GetUnitState(generators[i], UNIT_STATE_MAX_LIFE))
                    showEff = true
                end
            else
                generators[i] = CreateUnitAtLoc(Digimon.VILLAIN, GENERATOR, generatorsPos[i], bj_UNIT_FACING)
                showEff = true
            end
            if showEff then
                DestroyEffect(AddSpecialEffectLoc(RESTORE_EFFECT, generatorsPos[i]))
            end
        end
    end

    ---@return boolean
    local function allGeneratorsDead()
        for i = 1, #generators do
            if UnitAlive(generators[i]) then
                return false
            end
        end
        return true
    end

    ---@return boolean
    local function allGeneratorUnitsDead()
        for u in generatorUnits:elements() do
            if UnitAlive(u) then
                return false
            end
        end
        return true
    end

    Timed.echo(1., function ()
        if not allGeneratorsDead() then
            for u in generatorUnits:elements() do
                Damage.apply(boss, u, ELECTRIC_TRAP_DAMAGE, false, false, udg_Machine, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                DestroyEffect(AddSpecialEffectTarget(ELECTRIC_TRAP_EFFECT, u, "origin"))
            end
            SetDoodadAnimationRect(generatorRect, ENERGY_FIELD, "show", false)
        else
            SetDoodadAnimationRect(generatorRect, ENERGY_FIELD, "hide", false)
        end
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            if not canTrap and (GetDyingUnit() == boss or (RectContainsUnit(generatorRect, GetDyingUnit()) and (allGeneratorUnitsDead() or allGeneratorsDead()))) then
                Timed.call(2., function ()
                    for u2 in generatorUnits:elements() do
                        if UnitAlive(u2) then
                            DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                            local l = GetRandomLocInRect(returnPlace)
                            SetUnitPositionLoc(u2, l)
                            DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                            RemoveLocation(l)
                        end
                    end
                    generatorUnits:clear()
                    Timed.call(4., function ()
                        restartGenerators()
                        canTrap = true
                    end)
                end)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterEnterRectSimple(t, generatorRect)
        TriggerAddAction(t, function ()
            local u = GetEnteringUnit()
            generatorUnits:addSingle(u)
            BossIgnoreUnit(boss, u, true)
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterLeaveRectSimple(t, generatorRect)
        TriggerAddAction(t, function ()
            local u = GetLeavingUnit()
            generatorUnits:removeSingle(u)
            BossIgnoreUnit(boss, u, false)
            if generatorUnits:isEmpty() and not canTrap then
                Timed.call(2., function ()
                    restartGenerators()
                    canTrap = true
                end)
            end
        end)
    end

    InitBossFight("Datamon", boss, function (u, unitsInTheField)
        if not BossStillCasting(boss) and u then
            local chance = math.random(0, 100)
            if chance <= 30 then
                IssuePointOrderById(boss, missileBarrageOrder, GetUnitX(u), GetUnitY(u))
            elseif chance > 30 and chance <= 80 then
                IssueTargetOrderById(boss, hommingMissileOrder, u)
            end
        end

        if canTrap then
            cooldown = cooldown - 1
            if cooldown <= 0 then
                cooldown = ELECTRIC_TRAP_TICKS_CD
                canTrap = false
                local list = SyncedTable.create()
                for u2 in unitsInTheField:elements() do
                    if not list[GetOwningPlayer(u2)] then
                        list[GetOwningPlayer(u2)] = u2
                    end
                end
                for _, u2 in pairs(list) do
                    DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                    local l = GetRandomLocInRect(generatorRect)
                    SetUnitPositionLoc(u2, l)
                    DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                    RemoveLocation(l)
                end
                if not BossStillCasting(boss) then
                    IssuePointOrderById(boss, Orders.attack, GetUnitX(boss), GetUnitY(boss))
                end
            end
        end

        if not secondPhase then
            if GetUnitHPRatio(boss) <= 0.4 then
                secondPhase = true

                local previousPos = GetUnitLoc(boss)
                DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT, previousPos))
                SetUnitPositionLoc(boss, observerPos)
                DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, observerPos))
                SetUnitFacing(boss, 180.)
                SetUnitInvulnerable(boss, true)
                BlzSetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE, 0)
                SetUnitMoveSpeed(boss, 0)

                local needToKill = CreateGroup()
                local guardromons = {} ---@type Digimon[]

                for j = 1, minions do
                    local l = GetRandomLocInRect(returnPlace)
                    guardromons[j] = Digimon.create(Digimon.VILLAIN, GUARDROMON, GetLocationX(l), GetLocationY(l), bj_UNIT_FACING)
                    guardromons[j].isSummon = true
                    guardromons[j]:setLevel(GetHeroLevel(boss))
                    DestroyEffect(AddSpecialEffectLoc(GUARDROMON_EFFECT, l))
                    RemoveLocation(l)
                    GroupAddUnit(needToKill, guardromons[j].root)
                end

                Timed.echo(1., function ()
                    for k, _ in pairs(canSeeHim) do
                        UnitShareVision(boss, k, false)
                        canSeeHim[k] = nil
                    end
                    if GroupDead(needToKill) or not secondPhase then
                        if not secondPhase then
                            for j = 1, minions do
                                if guardromons[j]:isAlive() then
                                    DestroyEffect(AddSpecialEffect(GUARDROMON_EFFECT, guardromons[j]:getPos()))
                                    guardromons[j]:destroy()
                                end
                            end
                        else
                            goMetamorphosis = true
                        end
                        SetUnitInvulnerable(boss, false)
                        BlzSetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE, 1)
                        SetUnitMoveSpeed(boss, originalMoveSpeed)
                        DestroyGroup(needToKill)
                        DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT, observerPos))
                        SetUnitPositionLoc(boss, previousPos)
                        DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, previousPos))
                        RemoveLocation(previousPos)
                        return true
                    end
                    for u2 in unitsInTheField:elements() do
                        canSeeHim[GetOwningPlayer(u2)] = true
                    end
                    for k, _ in pairs(canSeeHim) do
                        UnitShareVision(boss, k, true)
                    end
                end)
            end
        end

        if not metamorphosis then
            if goMetamorphosis then
                metamorphosis = true
                SetUnitAbilityLevel(boss, MISSILE_BARRAGE, 2)
                BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0, 33554432)
                BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
                originalBaseDamage = BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
                BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, originalBaseDamage)
                local current = 0
                Timed.echo(0.02, 1., function ()
                    SetUnitVertexColor(boss, white:lerp(gray, current))
                    SetUnitScale(boss, Lerp(originalSize, current, increasedSize), 0., 0.)
                    current = current + 0.02
                end)
            end
        end
    end, nil, function ()
        secondPhase = false
        goMetamorphosis = false

        if metamorphosis then
            metamorphosis = false
            SetUnitAbilityLevel(boss, MISSILE_BARRAGE, 1)
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0, originalTargetsAllowed)
            BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, false)
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, originalBaseDamage)
            local current = 0
            Timed.echo(0.02, 1., function ()
                SetUnitVertexColor(boss, gray:lerp(white, current))
                SetUnitScale(boss, Lerp(increasedSize, current, originalSize), 0., 0.)
                current = current + 0.02
            end)
        end
    end)
end)
Debug.endFile()