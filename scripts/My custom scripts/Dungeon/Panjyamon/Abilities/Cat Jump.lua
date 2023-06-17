Debug.beginFile("Panjyamon\\Abilities\\Cat Jump")
OnInit(function ()
    Require "BossFightUtils"
    Require "JumpSystem"

    local SPELL = FourCC('A0DN')
    local MIN_DIST = 300.
    local MAX_DIST = 600.
    local DAMAGE = 50.
    local DAMAGE_PER_SEC = 10.
    local DURATION = 5. -- same as object editor
    local EFFECT = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)

        local toX, toY

        for _ = 1, 5 do
            local dist = MIN_DIST + (MAX_DIST - MIN_DIST) * math.random()
            local angle = 2 * math.pi * math.random()
            local checkX = x + dist * math.cos(angle)
            local checkY = y + dist * math.sin(angle)

            local contains = false
            local i = 1
            while true do
                -- To be sure that the target is inside the bossfight area
                if not rawget(_G, "gg_rct_Panjyamon_" .. i) then
                    break
                end
                if RectContainsCoords(rawget(_G, "gg_rct_Panjyamon_" .. i), checkX, checkY) then
                    contains = true
                    break
                end
                i = i + 1
            end

            if contains and IsTerrainWalkable(checkX, checkY) then
                toX, toY = checkX, checkY
                break
            end 
        end

        if not toX then
            return
        end

        local target = GetSpellTargetUnit()

        UnitAddAbility(target, CROW_FORM_ID)
        UnitRemoveAbility(target, CROW_FORM_ID)

        local originHeight = GetUnitFlyHeight(target)

        local endTimer = Timed.echo(0.02, function ()
            local angle = math.rad(GetUnitFacing(caster))
            SetUnitPosition(target, GetUnitX(caster) + 50*math.cos(angle), GetUnitY(caster) + 50*math.sin(angle))
            SetUnitFlyHeight(target, GetUnitFlyHeight(caster) + 50, 1000000000)
        end)

        Jump(caster, toX, toY, 500., 100., nil, "slam", function ()
            endTimer()
            SetUnitFlyHeight(target, originHeight, 1000000000)

            DestroyEffect(AddSpecialEffect(EFFECT, GetUnitX(caster), GetUnitY(caster)))
            Damage.apply(caster, target, DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
            DummyCast(
                GetOwningPlayer(caster),
                GetUnitX(target), GetUnitY(target),
                ICE_SPELL,
                ICE_ORDER,
                1,
                CastType.TARGET,
                target
            )
            Timed.echo(1., DURATION, function ()
                Damage.apply(caster, target, DAMAGE_PER_SEC, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
            end)
        end)
    end)
end)
Debug.endFile()