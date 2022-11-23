OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A06J')
    local StrDmgFactor = 0.45
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local Area = 250.
    local PushDist = 350.
    local CasterEffect = "Abilities\\Spells\\NightElf\\FanOfKnives\\FanOfKnivesCaster.mdl"
    local TargetUnitEffect1 = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
    local TargetUnitEffect2 = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        local eff = AddSpecialEffect(CasterEffect, x, y)
        DestroyEffectTimed(eff, 2.)
        -- --
        ForUnitsInRange(x, y, Area, function (u)
            if IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, damage, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                
            end
        end)
    end)

end)