Debug.beginFile("Calm mind")
OnInit(function ()
    local AdvancedAura = Require "AdvancedAura" ---@type AdvancedAura

    local CalmMind = AdvancedAura.create(FourCC('A02U'))

    CalmMind.INTERVAL = 1.
    CalmMind.OWNER_SFX = ""
    CalmMind.TARGET_SFX = ""

    function CalmMind:onFilter(u)
        return u == self.owner
    end

    function CalmMind:onLoop()
        self:setBonus(BONUS_MANA, GetHeroLevel(self.owner) * 2)
    end

    function CalmMind:getAuraAoE()
        return 10.
    end
end)
Debug.endFile()