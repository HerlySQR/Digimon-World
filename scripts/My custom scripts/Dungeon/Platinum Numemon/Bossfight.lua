Debug.beginFile("Platinum Numemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_H04V_0175 ---@type unit
    local owner = GetOwningPlayer(boss)
    local area = gg_rct_PlatinumNumemon_1 ---@type rect

    local RAIN_OF_FILTH = FourCC('A0G4')
    local STINKY_AURA = FourCC('A0G5')
    local BIG_FART = FourCC('A0G6')
    local SUMMON_RAREMON = FourCC('A0G7')

    local rainOfFilthOrder = Orders.thunderclap
    local bigFartOrder = Orders.stomp
    local summonRaremonOrder = Orders.spiritwolf

    local secondPhase = false

    InitBossFight({
        name = "PlatinumNumemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_B082_53321},
        returnPlace = gg_rct_Leave_Sewers,
        inner = gg_rct_PlatinumNumemonInner,
        entrance = gg_rct_PlatinumNumemonEntrance,
        toTeleport = gg_rct_Sewers,
        actions = function (u)
            if u then
                local chance = math.random(100)
                if chance <= 20 then
                    IssueImmediateOrderById(boss, rainOfFilthOrder)
                elseif chance <= 50 then
                    IssueImmediateOrderById(boss, bigFartOrder)
                elseif chance <= 65 then
                    IssueImmediateOrderById(boss, summonRaremonOrder)
                end
            end

            if not secondPhase then
                if GetUnitHPRatio(boss) < 0.5 then
                    secondPhase = true
                    UnitAddAbility(boss, STINKY_AURA)
                end
            end
        end,
        onDeath = function ()
            local owners = CreateForce()
            ForUnitsInRect(gg_rct_PlatinumNumemon_1, function (u)
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    ForceAddPlayer(owners, GetOwningPlayer(u))
                end
            end)
            ForForce(owners, function ()
                CreateItem(RARE_DATA, GetUnitX(boss), GetUnitY(boss))
            end)
            DestroyForce(owners)
        end,
        onReset = function ()
            if secondPhase then
                secondPhase = false
                UnitRemoveAbility(boss, STINKY_AURA)
            end
        end
    })

    local BIG_FART_DAMAGE = 500.
    local BIG_FART_SCALES_1 = {2., 2.5, 3.}
    local BIG_FART_SCALES_2 = {2.5, 3.5, 4.5}
    local BIG_FART_FACTOR = {1., 0.5, 0.3}
    local BIG_FART_RANGES_1 = {500., 700., 900.}
    local BIG_FART_RANGES_2 = {700., 900., 1200.}

    local RAREMON = FourCC('O02C')
    local RAREMON_PLACES = {gg_rct_SummonRaremon1, gg_rct_SummonRaremon2, gg_rct_SummonRaremon3, gg_rct_SummonRaremon4}
    local RAREMON_SUMMON_EFFECT = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
    local RAREMON_EXPLOSION_DAMAGE = 600.

    ---@param x number
    ---@param y number
    ---@param dmg number
    ---@param max integer
    local function dropFilth(x, y, dmg, max)
        local shadow = AddSpecialEffect("war3mapImported\\QuestMarking.mdx", x, y)
        Timed.call(1., function ()
            for _ = 1, math.random(max) do
                local filth = Missiles:create(x, y, 960., x, y, 0.)
                filth.source = boss
                filth.owner = owner
                filth.damage = dmg
                filth:model("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl")
                filth:speed(0.)
                filth.collision = 0
                filth.collideZ = true
                filth:color(128, 64, 0)
                -- Gravity
                filth.onPeriod = function ()
                    filth:speed(filth.Speed + 0.04)
                end
                filth.onFinish = function ()
                    DestroyEffect(shadow)
                    ForUnitsInRange(x, y, 150., function (u)
                        if IsUnitEnemy(u, owner) then
                            Damage.apply(boss, u, dmg, true, false, udg_Nature, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                            -- Poison
                            DummyCast(
                                owner,
                                GetUnitX(boss), GetUnitY(boss),
                                POISON_SPELL,
                                POISON_ORDER,
                                1,
                                CastType.TARGET,
                                u
                            )
                        end
                    end)
                    local s = CreateSoundFromLabel("ArtilleryExplodeDeath", false, true, true, 10, 10)
                    SetSoundPosition(s, x, y, 0.)
                    SetSoundVolume(s, 63)
                    StartSound(s)
                    KillSoundWhenDone(s)
                end
                filth:launch()
            end
        end)
    end

    local t = CreateTrigger()
    TriggerRegisterUnitEvent(t, boss, EVENT_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function ()
        local spell = GetSpellAbilityId()

        if spell == RAIN_OF_FILTH then
            PauseUnit(boss, true)
            SetUnitAnimation(boss, "channel")
            if not secondPhase then
                Timed.echo(0.25, 10., function ()
                    local angle = 2*math.pi*math.random()
                    local dist = GetRandomReal(100., 500.)
                    dropFilth(GetUnitX(boss) + dist * math.cos(angle), GetUnitY(boss) + dist * math.sin(angle), 250., 3)
                end, function ()
                    PauseUnit(boss, false)
                    ResetUnitAnimation(boss)
                end)
            else
                Timed.echo(0.15, 10., function ()
                    local l = GetRandomLocInRect(area)
                    dropFilth(GetLocationX(l), GetLocationY(l), 375., 5)
                    RemoveLocation(l)
                end, function ()
                    PauseUnit(boss, false)
                    ResetUnitAnimation(boss)
                end)
            end
        elseif spell == BIG_FART then
            local fart = AddSpecialEffect("Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl", GetUnitX(boss), GetUnitY(boss))
            local ranges, scales
            if not secondPhase then
                ranges = BIG_FART_RANGES_1
                scales = BIG_FART_SCALES_1
            else
                ranges = BIG_FART_RANGES_2
                scales = BIG_FART_SCALES_2
            end
            local act = 1
            BlzSetSpecialEffectScale(fart, scales[act])
            Timed.echo(1., function ()
                DestroyEffect(fart)
                act = act + 1
                if act > 3 then
                    return true
                end
                local x, y = GetUnitX(boss), GetUnitY(boss)
                fart = AddSpecialEffect("Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl", GetUnitX(boss), GetUnitY(boss))
                ForUnitsInRange(x, y, ranges[act], function (u)
                    if (not ranges[act-1] or DistanceBetweenCoords(x, y, GetUnitX(u), GetUnitY(u)) >= ranges[act-1]) and IsUnitEnemy(u, owner) then
                        Damage.apply(boss, u, BIG_FART_DAMAGE * BIG_FART_FACTOR[act], false, false, udg_Dark, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
                BlzSetSpecialEffectScale(fart, scales[act])
            end)
        elseif spell == SUMMON_RAREMON then
            for i = 1, #RAREMON_PLACES do
                local d = Digimon.create(Digimon.NEUTRAL, RAREMON, GetRectCenterX(RAREMON_PLACES[i]), GetRectCenterY(RAREMON_PLACES[i]), GetRandomReal(160, 200))
                DestroyEffect(AddSpecialEffect(RAREMON_SUMMON_EFFECT, GetRectCenterX(RAREMON_PLACES[i]), GetRectCenterY(RAREMON_PLACES[i])))

                d.isSummon = true
                d:setLevel(90)
                SetUnitMoveSpeed(d.root, 275)
                ZTS_AddThreatUnit(d.root, false)
                SetUnitState(d.root, UNIT_STATE_MANA, 0)
                SetUnitVertexColor(d.root, 255, 150, 150, 255)
                AddUnitBonus(d.root, BONUS_DAMAGE, 25)
                AddUnitBonus(d.root, BONUS_HEALTH, GetUnitState(d.root, UNIT_STATE_MAX_LIFE))

                ForUnitsInRect(area, function (u)
                    if IsUnitEnemy(u, owner) then
                        ZTS_ModifyThreat(u, d.root, 10., true)
                    end
                end)
                local exploding = false

                Timed.echo(1., function ()
                    if exploding or not UnitAlive(boss) then
                        if exploding and d:isAlive() then
                            local x, y = d:getPos()
                            ForUnitsInRange(x, y, 300., function (u)
                                if IsUnitEnemy(d.root, GetOwningPlayer(u)) then
                                    Damage.apply(d.root, u, RAREMON_EXPLOSION_DAMAGE, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                                elseif GetUnitTypeId(u) == RAREMON then
                                    SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) - RAREMON_EXPLOSION_DAMAGE)
                                end
                            end)
                            DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Demon\\DemonLargeDeathExplode\\DemonLargeDeathExplode.mdl", x, y))
                            DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\Mortar\\MortarMissile.mdl", x, y))
                        end
                        d:kill()
                        return true
                    end
                    if math.random(10) == 1 then
                        exploding = true
                        d:pause()
                        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl", d.root, "overhead")
                        BlzSetSpecialEffectScale(eff, 3.)
                        DestroyEffectTimed(eff, 1.)
                    end
                end)
            end
        end
    end)
end)
Debug.endFile()