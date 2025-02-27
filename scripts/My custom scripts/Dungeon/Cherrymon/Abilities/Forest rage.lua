Debug.beginFile("Cherrymon\\Abilities\\Forest rage")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DH')
    local WOODMON = FourCC('h04R')
    local QUANTITY = 4
    local DURATION = 60.
    local HEAL_LIFE_FACTOR = 0.02

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)

        SetUnitInvulnerable(caster, true)
        PauseUnit(caster, true)

        local minions = {} ---@type unit[]

        for i = 1, QUANTITY do
            local angle = i*math.pi/4
            minions[i] = CreateUnit(owner, WOODMON, x + 100 * math.cos(angle), y + 100 * math.sin(angle), math.deg(angle))
        end

        local heal = BlzGetUnitMaxHP(caster) * HEAL_LIFE_FACTOR / DURATION

        Timed.echo(1., DURATION, function ()
            SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + heal)
            DestroyEffect(AddSpecialEffectTarget("Model\\BrownRoots.mdx", caster, "origin"))
            for i = #minions, 1, -1 do
                if not UnitAlive(minions[i]) then
                    table.remove(minions, i)
                end
            end
            if #minions == 0 then
                SetUnitInvulnerable(caster, false)
                PauseUnit(caster, false)
                return true
            end
        end, function ()
            SetUnitInvulnerable(caster, false)
            PauseUnit(caster, false)
        end)
    end)
end)
Debug.endFile()