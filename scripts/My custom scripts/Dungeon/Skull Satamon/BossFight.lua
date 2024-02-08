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
    local THUNDERCLAP = FourCC('A0DW')
    local FIRE_PILLAR = FourCC('A0DY')

    local boss = gg_unit_O03B_0069 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.25
    local originalTargetsAllowed = BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0)
    local originalBaseDamage = BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
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
            vilemons[j] = Digimon.create(Digimon.VILLAIN, VILEMON, x + dist * math.cos(angle), y + dist * math.sin(angle), bj_UNIT_FACING)
            vilemons[j].isSummon = true
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

    local jailOrder = Orders.ensnare
    local firePillarOrder = Orders.impale

    InitBossFight({
        name = "SkullSatamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_31899},
        returnPlace = gg_rct_Great_Cannyon_Tp,
        inner = gg_rct_SkullSatamonInner,
        entrance = gg_rct_SkullSatamonEntrance,
        toTeleport = gg_rct_SkullSatamonToReturn,
        actions = function (u)
            if math.random(0, 100) <= 10 then
                IssueTargetOrderById(boss, jailOrder, u)
            end

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
                    SetUnitAbilityLevel(boss, THUNDERCLAP, 2)
                    UnitAddAbility(boss, FIRE_PILLAR)
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
            else
                if math.random(0, 100) <= 50 then
                    IssuePointOrderById(boss, firePillarOrder, GetUnitX(u), GetUnitY(u))
                end
            end
        end,
        onReset = function ()
            if metamorphosis then
                metamorphosis = false
                SetUnitAbilityLevel(boss, THUNDERCLAP, 1)
                UnitRemoveAbility(boss, FIRE_PILLAR)
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

            restartPilar(1)
            restartPilar(2)

            SetUnitInvulnerable(boss, false)
        end
    })
end)
Debug.endFile()