Debug.beginFile("Cherrymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02V_0095 ---@type unit

    local entagle = FourCC('A0DG')

    local PP_StrDmgFactor = 0.9
    local PP_AgiDmgFactor = 0.9
    local PP_IntDmgFactor = 0.9
    local PP_AttackFactor = 0.7
    local PP_MissileModel = "Objects\\InventoryItems\\Shimmerweed\\Shimmerweed.mdl"
    local PP_TargetUnitModel = "Effect\\SapStampedeMissileDeath.mdx"
    local PP_Area = 155.

    local function onPitPelter(caster, x, y)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local cx = GetUnitX(caster)
            local cy = GetUnitY(caster)
            -- Calculating the damage
            local damage = (GetAttributeDamage(caster, PP_StrDmgFactor, PP_AgiDmgFactor, PP_IntDmgFactor) +
                        GetAvarageAttack(caster) * PP_AttackFactor)
            -- --
            damage = damage / 2
            local counter = 10
            Timed.echo(0.25, function ()
                if counter == 0 then return true end
                local angle = 2 * math.pi * math.random()
                local dist = PP_Area * 2 * math.random()
                local tx = x + dist * math.cos(angle)
                local ty = y + dist * math.sin(angle)
                local missile = Missiles:create(cx, cy, 150, tx, ty, 0)
                missile.source = caster
                missile.owner = owner
                missile.damage = damage
                missile:scale(0.1)
                missile:model(PP_MissileModel)
                missile:speed(400.)
                missile:arc(20.)
                missile.onFinish = function ()
                    ForUnitsInRange(missile.x, missile.y, PP_Area, function (u)
                        if IsUnitEnemy(u, missile.owner) then
                            Damage.apply(caster, u, damage, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                            DestroyEffect(AddSpecialEffect(PP_TargetUnitModel,GetUnitX(u), GetUnitY(u)))
                            -- Poison
                            PoisonUnit(caster, u)
                        end
                    end)
                end
                missile:launch()
                counter = counter - 1
            end)
        end)
    end

    local WOODMON = FourCC('h04R')
    local FR_QUANTITY = 5
    local FR_DURATION = 70.
    local FR_HEAL_LIFE_FACTOR = 0.01

    local function onForestRage(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)

        SetUnitInvulnerable(caster, true)
        PauseUnit(caster, true)
        BossIsCasting(caster, true)

        local minions = {} ---@type Digimon[]

        for i = 1, FR_QUANTITY do
            local angle = i*math.pi/4
            local newX = x + 100 * math.cos(angle)
            local newY = y + 100 * math.sin(angle)
            minions[i] = SummonMinion(caster, WOODMON, newX, newY, math.deg(angle))
            DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", newX, newY))
        end

        local heal = BlzGetUnitMaxHP(caster) * FR_HEAL_LIFE_FACTOR / FR_DURATION

        Timed.echo(1., FR_DURATION, function ()
            SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + heal)
            DestroyEffect(AddSpecialEffectTarget("Model\\BrownRoots.mdx", caster, "origin"))
            for i = #minions, 1, -1 do
                if not minions[i]:isAlive() then
                    table.remove(minions, i)
                end
            end
            if #minions == 0 then
                SetUnitInvulnerable(caster, false)
                PauseUnit(caster, false)
                BossIsCasting(caster, false)
                return true
            end
        end, function ()
            SetUnitInvulnerable(caster, false)
            PauseUnit(caster, false)
            BossIsCasting(caster, false)
        end)
    end

    local EB_AREA = 350.
    local EB_ENTANGLE = FourCC('A0DF')
    local EB_DAMAGE = 100.
    local EB_DURATION = 3.

    local function onEntangleBranches(caster)
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        ForUnitsInRange(x, y, EB_AREA, function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                -- Entangle
                DummyCast(owner, x, y, EB_ENTANGLE, Orders.entanglingroots, 1, CastType.TARGET, u)
                Timed.echo(1., EB_DURATION, function ()
                    Damage.apply(caster, u, EB_DAMAGE, false, false, udg_Nature, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                end)
            end
        end)
    end

    InitBossFight({
        name = "Cherrymon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_13139},
        inner = gg_rct_CherrymonInner,
        entrance = gg_rct_CherrymonEntrance,
        spells = {
            5, CastType.POINT, onPitPelter, -- Pit Pelter
            6, CastType.IMMEDIATE, onForestRage, -- Forest Rage
            4, CastType.IMMEDIATE, onEntangleBranches -- Entangle Branches
        },
        extraSpells = {
            FourCC('A0DG'), 0, Orders.entanglingroots, CastType.TARGET, -- Entangle
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, entagle)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, entagle)
        end
    })
end)
Debug.endFile()