Debug.beginFile("Skull Satamon\\Abilities\\Jail")
OnInit(function ()
    Require "BossFightUtils"
    Require "DigimonBank"
    Require "PlayerUtils"

    local SPELL = FourCC('A0DX')
    local MISSILE_MODEL = "Abilities\\Spells\\Undead\\DarkSummoning\\DarkSummonMissile.mdl"
    local TARGET_EFFECT = "Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl"
    local JAIL_EFFECT = "Abilities\\Spells\\Undead\\UnholyAura\\UnholyAura.mdl"
    local KILL_EFFECT = "Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl"

    local jails = {gg_dest_B07X_52154, gg_dest_B07X_52152, gg_dest_B07X_52153} ---@type destructable[]
    local facings = {190.99, 164.85, 119.37} -- Why there is not a GetDestructableFacing function?
    local positions = {} ---@type location[]
    local offsets = {} ---@type location[]
    local used = __jarray(false) ---@type boolean[]
    local prisoner = {} ---@type unit[]

    ---@param i integer
    local function restartJail(i)
        SetUnitFlyHeight(prisoner[i], GetUnitDefaultFlyHeight(prisoner[i]), 0)
        SetUnitInvulnerable(prisoner[i], false)
        SetUnitPathing(prisoner[i], true)
        PauseUnit(prisoner[i], false)
        prisoner[i] = nil
        Timed.call(2 + 3*math.random(), function ()
            local eff = AddSpecialEffectLoc(JAIL_EFFECT, positions[i])
            Timed.call(2., function ()
                DestroyEffect(eff)
                DestructableRestoreLife(jails[i], GetDestructableMaxLife(jails[i]), true)
                SetDestructableInvulnerable(jails[i], true)
                used[i] = false
            end)
        end)
    end

    for i = 1, #jails do
        SetDestructableInvulnerable(jails[i], true)
        positions[i] = GetDestructableLoc(jails[i])
        offsets[i] = PolarProjectionBJ(positions[i], 80., facings[i])
        local t = CreateTrigger()
        TriggerRegisterDeathEvent(t, jails[i])
        TriggerAddAction(t, function ()
            if prisoner[i] then
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
            for i = 1, #jails do
                if prisoner[i] == u then
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
                    for j = 1, #jails do
                        if prisoner[j] and GetOwningPlayer(prisoner[j]) == p then
                            Timed.call(2., function ()
                                local u2 = prisoner[j]
                                KillDestructable(jails[j]) -- This sets prisoner[j] to nil
                                KillUnit(u2)
                                DestroyEffect(AddSpecialEffectLoc(KILL_EFFECT, offsets[j]))
                            end)
                        end
                    end
                end
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            if GetUnitAbilityLevel(GetDyingUnit(), SPELL) > 0 then
                for j = 1, #jails do
                    if prisoner[j] then
                        KillDestructable(jails[j])
                    end
                end
            end
        end)
    end

    RegisterSpellEffectEvent(SPELL, function ()
        for i = 1, #jails do
            if not used[i] and IsDestructableAliveBJ(jails[i]) then
                local caster = GetSpellAbilityUnit()
                local target = GetSpellTargetUnit()

                used[i] = true
                prisoner[i] = target

                local eff = AddSpecialEffectTarget(TARGET_EFFECT, target, "origin")
                SetUnitInvulnerable(target, true)
                PauseUnit(target, true)
                SetUnitPathing(target, false)
                Timed.call(3., function ()
                    DestroyEffect(eff)
                    ShowUnit(target, false)
                    UnitAddAbility(target, CROW_FORM_ID)
                    UnitRemoveAbility(target, CROW_FORM_ID)
                    SetUnitFlyHeight(target, 50., 0)

                    local m = Missiles:create(GetUnitX(target), GetUnitY(target), GetUnitZ(target), GetLocationX(positions[i]), GetLocationY(positions[i]), 50)
                    m.owner = GetOwningPlayer(caster)
                    m:model(MISSILE_MODEL)
                    m:speed(700)
                    m.onFinish = function ()
                        ShowUnit(target, true)
                        SetUnitX(target, GetLocationX(offsets[i]))
                        SetUnitY(target, GetLocationY(offsets[i]))
                        SetUnitFacing(target, facings[i])
                        SetDestructableInvulnerable(jails[i], false)
                    end
                    m:launch()
                end)

                if Digimon.getInstance(target) then
                    local p = Digimon.getInstance(target).owner
                    if PlayerIsStucked(p) then
                        for j = 1, #jails do
                            if prisoner[j] and GetOwningPlayer(prisoner[j]) == p then
                                Timed.call(5., function ()
                                    local u = prisoner[j]
                                    KillDestructable(jails[j]) -- This sets prisoner[j] to nil
                                    KillUnit(u)
                                    DestroyEffect(AddSpecialEffectLoc(KILL_EFFECT, offsets[j]))
                                end)
                            end
                        end
                    end
                end

                break
            end
        end
    end)
end)
Debug.endFile()