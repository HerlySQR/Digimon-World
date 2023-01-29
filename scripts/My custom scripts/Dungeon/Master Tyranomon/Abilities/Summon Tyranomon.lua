Debug.beginFile("Master Tyranomon\\Abilities\\Summon Tyranomon")
OnInit(function ()
    Require "BossFightUtils"
    local MCT = Require "MCT" ---@type MCT

    local SPELL = FourCC('A0B2')
    local SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local TYRANOMON_ID = FourCC('O00K')

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the Tyranomon
        local d = Digimon.create(owner, TYRANOMON_ID, x, y, GetUnitFacing(caster))
        DestroyEffect(AddSpecialEffect(SUMMON_EFFECT, d:getX(), d:getY()))

        local lvls = {} ---@type integer[]
        ForUnitsInRange(x, y, 700., function (u)
            if UnitAlive(u) and IsUnitEnemy(u, owner) and IsUnitType(u, UNIT_TYPE_HERO) then
                table.insert(lvls, GetHeroLevel(u))
            end
        end)
        local lvl = MCT.mean(lvls)
        d:setLevel(lvl == 0 and GetHeroLevel(caster) or lvl)
    end)

end)
Debug.endFile()