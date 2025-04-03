-- Insatiable
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02K')
    local DmgFactor = 0.05
    local pass = false

    Digimon.postDamageEvent:register(function (info)
        if pass then
            return
        end
        local source = info.source ---@type Digimon
        local target = info.target ---@type Digimon

        if source:hasAbility(Spell) then
            udg_ZOffset = 48.00
            local amount = DmgFactor * GetHeroAgi(source.root, true)
            pass = true
            Damage.apply(source.root, target.root, amount, false, false, udg_Dark, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
            PolledWait(0)
            pass = false
        end
    end)
end)