Debug.beginFile("Panjyamon\\Abilities\\Ice fist")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0DJ')
    local DISTANCE = 500.
    local DAMAGE = 175.
    local DELAY = 2. -- Same as object editor
    local ORDER = Orders.breathoffrost
    local EFFECT_CASTER = "war3mapImported\\DetroitSmash_BunosEffect.mdx"
    local EFFECT_TARGET = "war3mapImported\\DetroitSmash_Effect.mdx"

    RegisterSpellChannelEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_AQUA)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        BossIsCasting(caster, true)

        SetUnitAnimationByIndex(caster, 1) -- stand ready

        local progress = 0
        local interval = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) or GetUnitCurrentOrder(caster) ~= ORDER then
                bar:destroy()
                BossIsCasting(caster, false)
                return true
            end
            progress = progress + 0.02
            interval = interval + 0.02
            if interval >= 0.1 then
                interval = 0
                local eff = AddSpecialEffectTarget(EFFECT_CASTER, caster, "hand right")
                BlzSetSpecialEffectColor(eff, 0, 209, 255)
                DestroyEffect(eff)
            end
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            bar:destroy()
        end)
    end)

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        BossIsCasting(caster, false)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local tx = GetSpellTargetX()
        local ty = GetSpellTargetY()
        local angle = math.atan(ty - y, tx - x)

        SetUnitAnimation(caster, "slam")

        Timed.call(0.4, function ()
            local eff = AddSpecialEffect(EFFECT_TARGET, x, y)
            BlzSetSpecialEffectPosition(eff, x + 50*math.cos(angle - math.pi/6), y + 50*math.sin(angle - math.pi/6), 125.)
            BlzSetSpecialEffectYaw(eff, angle)
            BlzSetSpecialEffectColor(eff, 0, 209, 255)
            DestroyEffect(eff)

            ForUnitsInRange(x - 100*math.cos(angle), y - 100*math.sin(angle), DISTANCE, function (u)
                if math.abs(math.atan(GetUnitY(u) - y, GetUnitX(u) - x)) <= math.pi/6 and IsUnitEnemy(u, owner) then
                    DummyCast(owner, GetUnitX(u), GetUnitY(u), ICE_SPELL, ICE_ORDER, 1, CastType.TARGET, u)
                    Damage.apply(caster, u, DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                end
            end)
        end)
    end)
end)
Debug.endFile()