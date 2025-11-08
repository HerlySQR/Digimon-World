Debug.beginFile("Cherrymon\\Abilities\\Forest rage")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DH')
    local WOODMON = FourCC('h04R')
    local QUANTITY = 4
    local DURATION = 70.
    local HEAL_LIFE_FACTOR = 0.02

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)

        SetUnitInvulnerable(caster, true)
        PauseUnit(caster, true)

        local minions = {} ---@type Digimon[]

        for i = 1, QUANTITY do
            local angle = i*math.pi/4
            local newX = x + 100 * math.cos(angle)
            local newY = y + 100 * math.sin(angle)
            minions[i] = SummonMinion(caster, WOODMON, newX, newY, math.deg(angle))
            DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\NightElf\\EntBirthTarget\\EntBirthTarget.mdl", newX, newY))
        end

        local heal = BlzGetUnitMaxHP(caster) * HEAL_LIFE_FACTOR / DURATION

        Timed.echo(1., DURATION, function ()
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
                return true
            end
        end, function ()
            SetUnitInvulnerable(caster, false)
            PauseUnit(caster, false)
        end)
    end)
end)
Debug.endFile()