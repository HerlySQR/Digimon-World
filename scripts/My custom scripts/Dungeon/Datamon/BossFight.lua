Debug.beginFile("Datamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    Require "SyncedTable"

    local GENERATOR = FourCC('n01U')
    local ELECTRIC_TRAP_DAMAGE = 15.
    local ELECTRIC_TRAP_TICKS_CD = 8
    local ELECTRIC_TRAP_EFFECT = "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldBuff.mdl"
    local ENERGY_FIELD = FourCC('YZef')
    local RESTORE_EFFECT = "Objects\\Spawnmodels\\Undead\\UDeathSmall\\UDeathSmall.mdl"
    local TELEPORT_EFFECT = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl"
    local TELEPORT_EFFECT_TARGET = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"

    local boss = gg_unit_O03P_0105 ---@type unit
    local cooldown = ELECTRIC_TRAP_TICKS_CD
    local generators = {gg_unit_n01U_0110, gg_unit_n01U_0112, gg_unit_n01U_0114, gg_unit_n01U_0113} ---@type unit[]
    local generatorsPos = {} ---@type location[]
    local generatorRect = gg_rct_Datamon_Generators ---@type rect
    local generatorUnits = SyncedTable.create()
    local returnPlace = gg_rct_Datamon_Return ---@type rect
    local canTrap = true

    local hommingMissileOrder = Orders.shadowstrike
    local missileBarrageOrder = Orders.blackarrow

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
        for _, u in pairs(generatorUnits) do
            if UnitAlive(u) then
                return false
            end
        end
        return true
    end

    Timed.echo(1., function ()
        if not allGeneratorsDead() then
            for _, u in pairs(generatorUnits) do
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
            if GetDyingUnit() == boss or (RectContainsUnit(generatorRect, GetDyingUnit()) and (allGeneratorUnitsDead() or allGeneratorsDead())) then
                Timed.call(2., function ()
                    for _, u2 in pairs(generatorUnits) do
                        if UnitAlive(u2) then
                            DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                            local l = GetRandomLocInRect(returnPlace)
                            SetUnitPositionLoc(u2, l)
                            DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                            RemoveLocation(l)
                            BossIgnoreUnit(boss, u2, false)
                        end
                    end
                    generatorUnits = SyncedTable.create()
                    Timed.call(4., function ()
                        canTrap = true
                        restartGenerators()
                    end)
                end)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterLeaveRectSimple(t, generatorRect)
        TriggerAddAction(t, function ()
            local u = GetLeavingUnit()
            for k, v in pairs(generatorUnits) do
                if v == u then
                    generatorUnits[k] = nil
                end
            end
            if next(generatorUnits) == nil then
                Timed.call(2., function ()
                    restartGenerators()
                end)
            end
        end)
    end

    InitBossFight("Datamon", boss, function (u, unitsInTheField)
        if not BossStillCasting(boss) then
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
                for u2 in unitsInTheField:elements() do
                    if not generatorUnits[GetOwningPlayer(u2)] then
                        generatorUnits[GetOwningPlayer(u2)] = u2
                    end
                end
                for _, u2 in pairs(generatorUnits) do
                    DestroyEffect(AddSpecialEffect(TELEPORT_EFFECT, GetUnitX(u2), GetUnitY(u2)))
                    local l = GetRandomLocInRect(generatorRect)
                    SetUnitPositionLoc(u2, l)
                    DestroyEffect(AddSpecialEffectLoc(TELEPORT_EFFECT_TARGET, l))
                    RemoveLocation(l)
                    BossIgnoreUnit(boss, u2, true)
                end
                if not BossStillCasting(boss) then
                    IssuePointOrderById(boss, Orders.attack, GetUnitX(boss), GetUnitY(boss))
                end
            end
        end
    end)
end)
Debug.endFile()