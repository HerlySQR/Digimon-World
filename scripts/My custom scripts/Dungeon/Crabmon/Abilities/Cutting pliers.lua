Debug.beginFile("Crabmon\\Abilities\\Cutting pliers")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0GV')
    local DAMAGE = 50.
    local DISTANCE = 250.
    local SPEED = DISTANCE * 0.12
    local EFFECT = "war3mapImported\\ChargerWindCasterArt.mdx"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local angle = math.atan(GetSpellTargetY() - GetUnitY(caster), GetSpellTargetX() - GetUnitX(caster))
        local deltaX = SPEED * math.cos(angle)
        local deltaY = SPEED * math.sin(angle)

        BossIsCasting(caster, true)
        PauseUnit(caster, true)
        SetUnitPathing(caster, false)
        SetUnitAnimation(caster, "ready")

        local eff = AddSpecialEffectTarget(EFFECT, caster, "origin")
        local affected = CreateGroup()
        local traveled = 0

        Timed.echo(0.02, function ()
            SetUnitPosition(caster, GetUnitX(caster) + deltaX, GetUnitY(caster) + deltaY)
            ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), 150, function (u)
                if not IsUnitInGroup(u, affected) and IsUnitEnemy(u, owner) then
                    GroupAddUnit(affected, u)
                    Damage.apply(caster, u, DAMAGE, false, false, udg_Water, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffectTarget("Effect\\SapStampedeMissileDeath.mdx", u, "origin"))
                end
            end)
            traveled = traveled + SPEED
            if traveled >= DISTANCE then
                DestroyGroup(affected)
                BossIsCasting(caster, false)
                PauseUnit(caster, false)
                SetUnitPathing(caster, true)
                ResetUnitAnimation(caster)
                DestroyEffect(eff)
                return true
            end
        end)
    end)
end)
Debug.endFile()