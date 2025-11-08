Debug.beginFile("Recipes")
OnInit(function ()
    Require "Backpack"
    Require "SyncedTable"
    Require "AddHook"
    Require "UnitEnterEvent"

    ---@class Recipe
    ---@field itm integer
    ---@field itmToUpgrade integer?
    ---@field spell integer
    ---@field requirements table<integer, integer>
    ---@field resultItm integer

    local RecipeFromItm = {} ---@type table<integer, Recipe>

    ---@param itm integer
    ---@return Recipe
    function GetRecipe(itm)
        return RecipeFromItm[itm]
    end

    ---@param recipe Recipe
    ---@param tooltip string
    ---@return string
    local function fixTooltip(recipe, tooltip)
        local top, start = tooltip:find(GetLocalizedString("RECIPES_REQUIRE_HEADER"))
        if start then
            local tooltipStart = tooltip:sub(1, start)
            local _, finish = tooltip:reverse():find("n|")
            if finish then
                finish = tooltip:len() - finish
            else
                finish = tooltip:len()
            end
            local tooltipEnd = tooltip:sub(finish + 1, tooltip:len())

            local requirements = ""
            if recipe.itmToUpgrade then
                requirements = requirements .. "- " .. GetObjectName(recipe.itmToUpgrade) .. "|n"
            end
            for matReq, amtReq in pairs(recipe.requirements) do
                requirements = requirements .. "- " .. amtReq .. " " .. GetObjectName(matReq) .. "|n"
            end

            tooltipStart = BlzGetAbilityExtendedTooltip(recipe.resultItm, 0) .. "|n" .. GetLocalizedString("RECIPES_REQUIRE_HEADER")
            tooltip = tooltipStart .. requirements .. tooltipEnd
        end
        return tooltip
    end
    local done = {}
    OnItemCreate(function (itm)
        if RecipeFromItm[GetItemTypeId(itm)] then
            Timed.call(function ()
                local typ = GetItemTypeId(itm)
                BlzSetItemDescription(itm, fixTooltip(RecipeFromItm[typ], BlzGetItemDescription(itm)))
                --BlzSetItemExtendedTooltip(itm, fixTooltip(RecipeFromItm[typ], BlzGetItemExtendedTooltip(itm)))
                if not done[typ] then
                    done[typ] = true
                    BlzSetAbilityExtendedTooltip(typ, fixTooltip(RecipeFromItm[typ], BlzGetAbilityExtendedTooltip(typ, 0)), 0)
                end
            end)
        end
    end)

    ---@param itm integer
    ---@param itmToUpgrade integer?
    ---@param spell integer
    ---@param materialReq integer[]
    ---@param amountReq integer[]
    ---@param resultItm integer
    local function Create(itm, itmToUpgrade, spell, materialReq, amountReq, resultItm)
        assert(#materialReq == #amountReq, "The number of material requirements does not match with the number of amounts for the recipe " .. GetObjectName(itm))

        local self = {
            itm = itm,
            itmToUpgrade = itmToUpgrade,
            spell = spell,
            requirements = SyncedTable.create(),
            resultItm = resultItm
        }

        for i = 1, #materialReq do
            self.requirements[materialReq[i]] = amountReq[i]
        end

        RecipeFromItm[itm] = self

        udg_BackpackItem = itm
        udg_BackpackAbility = spell
        TriggerExecute(udg_BackpackRun)

        RegisterSpellCastEvent(spell, function ()
            local caster = GetSpellAbilityUnit()
            local p = GetOwningPlayer(caster)

            if self.itmToUpgrade then
                local m = GetSpellTargetItem()
                if GetItemTypeId(m) ~= itmToUpgrade then
                    UnitAbortCurrentOrder(caster)
                    ErrorMessage(GetLocalizedString("RECIPES_WARN_WRONG_ITEM"), p)
                    return
                end

                local iOwner = GetItemPlayer(m)
                if IsPlayerInGame(iOwner) and p ~= iOwner then
                    UnitAbortCurrentOrder(caster)
                    ErrorMessage(GetLocalizedString("THIS_ITEM_BELONGS_TO_OTHER_PLAYER"), p)
                    return
                end
            end

            local has = true
            for itmReq, amtReq in pairs(self.requirements) do
                if GetMaterialAmount(p, itmReq) < amtReq then
                    has = false
                    break
                end
            end

            if not has then
                UnitAbortCurrentOrder(caster)
                ErrorMessage(GetLocalizedString("RECIPE_WARN_NO_MATERIALS"), p)
            end
        end)

        RegisterSpellEffectEvent(spell, function ()
            local caster = GetSpellAbilityUnit()
            if not caster then
                return
            end

            local p = GetOwningPlayer(caster)
            for itmReq, amtReq in pairs(self.requirements) do
                SubMaterialAmount(p, itmReq, amtReq)
            end

            local x, y
            if self.itmToUpgrade then
                local m = GetSpellTargetItem()
                x, y = GetItemX(m), GetItemY(m)
                RemoveItem(m)
            else
                x, y = GetSpellTargetX(), GetSpellTargetY()
            end

            SetItemPlayer(CreateItem(resultItm, x, y), p, true)
            DestroyEffect(AddSpecialEffect(udg_RECIPE_EFFECT, x, y))
        end)
    end

    udg_RecipeItemToUpgrade = nil

    udg_RecipeInit = CreateTrigger()
    TriggerAddAction(udg_RecipeInit, function ()
        Create(
            udg_RecipeItem,
            udg_RecipeItemToUpgrade,
            udg_RecipeSpell,
            udg_RecipeMaterialReq,
            udg_RecipeAmountReq,
            udg_RecipeResultItem
        )
        udg_RecipeItem = 0
        udg_RecipeItemToUpgrade = nil
        udg_RecipeSpell = 0
        udg_RecipeMaterialReq = __jarray(0)
        udg_RecipeAmountReq = __jarray(0)
        udg_RecipeResultItem = 0
    end)
end)
Debug.endFile()