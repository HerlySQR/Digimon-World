OnInit(function ()
    local AdvanceAura = Require "AdvancedAura" ---@type AdvancedAura

    local NewAura = AdvanceAura.create(FourCC('A000'))

    NewAura.OWNER_SFX = "Abilities\\Spells\\Orc\\WarDrums\\DrumsCasterHeal.mdl"
    NewAura.BUFF = FourCC('A001')

    function NewAura:auraInit()
        self:setBonus(BONUS_DAMAGE, 3)
    end

    function NewAura:onFilter(u)
        return IsUnitAlly(self.owner, GetOwningPlayer(u))
    end

    OnUnitEnter(print)

end)