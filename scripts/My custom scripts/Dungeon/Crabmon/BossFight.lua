Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local aquaMagicOrder = Orders.innerfire
    local aquaMagicBuff = FourCC('B01D')

    local SMC_DELAY = 2.5
    local SMC_DAMAGE_PER_SHOT = 32.
    local SMC_MAX_SHOTS = 12
    local SMC_AREA = 175.
    local SMC_MISSILE_MODEL = "Missile\\BubbleMissile.mdx"
    local SMC_INTERVAL = 0.03125

    local function onScissorMagicChaos(caster, x, y)
        local owner = GetOwningPlayer(caster)

        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)

        Timed.call(0.5, function ()
            local bar = ProgressBar.create()
            bar:setColor(PLAYER_COLOR_PEANUT)
            bar:setZOffset(250)
            bar:setSize(1.3)
            bar:setTargetUnit(caster)

            local progress = 0
            Timed.echo(0.02, SMC_DELAY, function ()
                if not UnitAlive(caster) then
                    bar:destroy()
                    return true
                end
                progress = progress + 0.02
                bar:setPercentage((progress/SMC_DELAY)*100, 1)
            end, function ()
                bar:destroy()
                if UnitAlive(caster) then
                    local counter = SMC_MAX_SHOTS
                    Timed.echo(SMC_INTERVAL, function ()
                        if counter == 0 then
                            PauseUnit(caster, false)
                            ResetUnitAnimation(caster)
                            BossIsCasting(caster, false)
                            return true
                        end
                        SetUnitAnimation(caster, "spell throw")

                        local angle = 2 * math.pi * math.random()
                        local dist = SMC_AREA * math.random()
                        local tx = x + dist * math.cos(angle)
                        local ty = y + dist * math.sin(angle)
                        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, tx, ty, 0)
                        missile.source = caster
                        missile.owner = owner
                        missile.damage = SMC_DAMAGE_PER_SHOT
                        missile:model(SMC_MISSILE_MODEL)
                        missile:speed(900.)
                        missile:arc(60.)
                        missile.onFinish = function ()
                            ForUnitsInRange(missile.x, missile.y, 128., function (u)
                                if IsUnitEnemy(u, missile.owner) then
                                    Damage.apply(caster, u, SMC_DAMAGE_PER_SHOT, true, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                                end
                            end)
                        end
                        missile:launch()
                        counter = counter - 1
                    end)
                end
            end)
        end)
    end

    local CP_DAMAGE = 40.
    local CP_DISTANCE = 250.
    local CP_SPEED = CP_DISTANCE * 0.12
    local CP_EFFECT = "war3mapImported\\ChargerWindCasterArt.mdx"

    local function onCuttingPliers(caster, x, y)
        local owner = GetOwningPlayer(caster)
        local angle = math.atan(y - GetUnitY(caster), x - GetUnitX(caster))
        local deltaX = CP_SPEED * math.cos(angle)
        local deltaY = CP_SPEED * math.sin(angle)

        PauseUnit(caster, true)
        SetUnitPathing(caster, false)
        SetUnitAnimation(caster, "ready")

        local eff = AddSpecialEffectTarget(CP_EFFECT, caster, "origin")
        local affected = CreateGroup()
        local traveled = 0

        Timed.echo(0.02, function ()
            SetUnitPosition(caster, GetUnitX(caster) + deltaX, GetUnitY(caster) + deltaY)
            ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), 150, function (u)
                if not IsUnitInGroup(u, affected) and IsUnitEnemy(u, owner) then
                    GroupAddUnit(affected, u)
                    Damage.apply(caster, u, CP_DAMAGE, false, false, udg_Water, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffectTarget("Effect\\SapStampedeMissileDeath.mdx", u, "origin"))
                end
            end)
            traveled = traveled + CP_SPEED
            if traveled >= CP_DISTANCE then
                DestroyGroup(affected)
                PauseUnit(caster, false)
                SetUnitPathing(caster, true)
                ResetUnitAnimation(caster)
                DestroyEffect(eff)
                return true
            end
        end)
    end

    InitBossFight({
        name = "Crabmon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52786},
        inner = gg_rct_CrabmonInner,
        entrance = gg_rct_CrabmonEntrance,
        moveOption = 2,
        spells = {
            2, CastType.POINT, onScissorMagicChaos, -- Scissor Magic Chaos
            3, CastType.POINT, onCuttingPliers, -- Cutting pliers
        },
        extraSpells = {
            FourCC('A074'), Orders.berserk, CastType.IMMEDIATE, -- Berserk
            FourCC('A0H6'), Orders.chainlightning, CastType.TARGET, -- Scissor Magic
        },
        actions = function (u)
            if not BossStillCasting(boss) and GetUnitAbilityLevel(boss, aquaMagicBuff) == 0 and GetUnitHPRatio(boss) < 0.5 then
                IssueTargetOrderById(boss, aquaMagicOrder, boss)
            end
        end
    })
end)
Debug.endFile()