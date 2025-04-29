Debug.beginFile("Datamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    Require "SyncedTable"
    Require "Set"
    local Color = Require "Color" ---@type Color

    local GENERATOR = FourCC('n01U')
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
    local electricTrapDamage = 0.01
    local electricTrapTick = 0
    local electricTrapInstances = 1

    for i = 1, #generators do
        generatorsPos[i] = GetUnitLoc(generators[i])
    end

    local function restartGenerators()
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
        electricTrapDamage = 0.01
        electricTrapInstances = 1
        electricTrapTick = 0
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
            electricTrapTick = electricTrapTick + 1
            if electricTrapTick >= 10 then
                electricTrapTick = 0
                electricTrapInstances = electricTrapInstances + 1
                electricTrapDamage = electricTrapDamage + 0.01 * electricTrapInstances * (1/2 + generatorUnits:size()/6)
            end
            for u in generatorUnits:elements() do
                Damage.apply(boss, u, electricTrapDamage * GetUnitState(u, UNIT_STATE_MAX_LIFE), false, false, udg_Machine, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
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
                    local unitToTeleportTo = {}
                    ForUnitsInRect(gg_rct_Datamon_1, function (u2)
                        if not unitToTeleportTo[GetOwningPlayer(u2)] then
                            unitToTeleportTo[GetOwningPlayer(u2)] = u2
                        end
                    end)
                    for u2 in generatorUnits:elements() do
                        if UnitAlive(u2) then
                            DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                            local toTp = unitToTeleportTo[GetOwningPlayer(u2)]
                            if toTp then
                                local toX, toY = GetUnitX(toTp), GetUnitY(toTp)
                                SetUnitPosition(u2, toX, toY)
                                DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT_TARGET, toX, toY))
                            else
                                local l = GetRandomLocInRect(returnPlace)
                                SetUnitPositionLoc(u2, l)
                                DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                                RemoveLocation(l)
                            end
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
            if GetUnitTypeId(u) ~= GENERATOR then
                generatorUnits:addSingle(u)
                BossIgnoreUnit(boss, u, true)
            end
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

    RegisterSpellEffectEvent(FourCC('A0H5'), function ()
        if GetSpellAbilityUnit() == boss then
            BossMove(boss, 1, 1000, 150, math.random(2) == 1)
        end
    end)

    InitBossFight({
        name = "Datamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_52713},
        inner = gg_rct_DatamonInner,
        entrance = gg_rct_DatamonEntrance,
        spells = {
            FourCC('A0DZ'), 5, Orders.shadowstrike, CastType.TARGET, -- Homming Missile
            FourCC('A0E0'), 3, Orders.clusterrockets, CastType.POINT, -- Missile Barrage
            FourCC('A0H5'), 2, Orders.avengerform, CastType.IMMEDIATE, -- Move
        },
        actions = function (u, unitsInTheField)
            --BossMove(boss, math.random(0, 3), 600., 100., math.random(0, 1) == 1)

            if canTrap then
                cooldown = cooldown - 1
                if cooldown <= 0 then
                    restartGenerators()
                    cooldown = ELECTRIC_TRAP_TICKS_CD
                    canTrap = false
                    local list = SyncedTable.create()
                    for u2 in unitsInTheField:elements() do
                        if not list[GetOwningPlayer(u2)] then
                            list[GetOwningPlayer(u2)] = u2
                        end
                    end
                    for p, u2 in pairs(list) do
                        DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                        local l = GetRandomLocInRect(generatorRect)
                        SetUnitPositionLoc(u2, l)
                        DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                        RemoveLocation(l)

                        if GetMainDigimon(p) == Digimon.getInstance(u2) then
                            SearchNewMainDigimon(p)
                        end

                        if u == u2 then
                            IssuePointOrderById(boss, Orders.attack, GetUnitX(boss), GetUnitY(boss))
                        end
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
                    BossCanLeave(boss, true)

                    local needToKill = CreateGroup()
                    local guardromons = {} ---@type Digimon[]

                    for j = 1, minions do
                        local l = GetRandomLocInRect(returnPlace)
                        guardromons[j] = SummonMinion(boss, GUARDROMON, GetLocationX(l), GetLocationY(l), bj_UNIT_FACING)
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
                            BossCanLeave(boss, false)
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
            secondPhase = false
            goMetamorphosis = false

            if metamorphosis then
                metamorphosis = false
                SetUnitAbilityLevel(boss, MISSILE_BARRAGE, 1)
                BossChangeAttack(boss, 0)
                local current = 0
                Timed.echo(0.02, 1., function ()
                    SetUnitVertexColor(boss, gray:lerp(white, current))
                    SetUnitScale(boss, Lerp(increasedSize, current, originalSize), 0., 0.)
                    current = current + 0.02
                end)
            end
        end
    })
end)
Debug.endFile()