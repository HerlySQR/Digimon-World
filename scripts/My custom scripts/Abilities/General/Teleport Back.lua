Debug.beginFile("Abilities\\Teleport Back")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A0C7')
    local TeleportDelay = 5.
    local Area = 350. -- Same as object editor
    local TeleportTargetX, TeleportTargetY = GetRectCenterX(gg_rct_Player_1_Spawn), GetRectCenterY(gg_rct_Player_1_Spawn)
    local TargetEffect = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl"
    local TargetUnitEffect = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"
    local TargetPointEffect = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl"

    local digimonsToTeleport = {} ---@type table<unit, Digimon[]>

    RegisterSpellCastEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        local digimons = {} ---@type Digimon[]

        Digimon.enumInRange(x, y, Area, function (d)
            if d:getOwner() == owner and not d.onCombat then
                table.insert(digimons, d)
            end
        end)

        if #digimons == 0 then
            UnitAbortCurrentOrder(caster)
            ErrorMessage("There are no avaible digimons", owner)
        else
            digimonsToTeleport[caster] = digimons
        end
    end)

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        local digimons = digimonsToTeleport[caster]
        local effects = {} ---@type effect[]
        local xOffsets, yOffsets = {}, {} ---@type number[], number[]

        local eff = AddSpecialEffect(TargetEffect, TeleportTargetX, TeleportTargetY)

        for i, d in ipairs(digimons) do
            effects[i] = AddSpecialEffect(TargetEffect, d:getPos())
            xOffsets[i] = d:getX() - x
            yOffsets[i] = d:getY() - y
            d:pause()
        end
        Timed.echo(0.5, TeleportDelay, function ()
            for i = #digimons, 1, -1 do
                if IsUnitType(digimons[i].root, UNIT_TYPE_STUNNED) or not digimons[i]:isAlive() then
                    DestroyEffect(effects[i])
                    table.remove(effects, i)
                    table.remove(xOffsets, i)
                    table.remove(yOffsets, i)
                    table.remove(digimons, i)
                    digimons[i]:unpause()
                end
            end
            if #digimons == 0 then
                DestroyEffect(eff)
                return true
            end
        end, function ()
            DestroyEffect(eff)
            for i, d in ipairs(digimons) do
                DestroyEffect(AddSpecialEffect(TargetUnitEffect, d:getPos()))
                d:setPos(TeleportTargetX + xOffsets[i], TeleportTargetY + yOffsets[i])
                DestroyEffect(effects[i])
                DestroyEffect(AddSpecialEffect(TargetPointEffect, d:getPos()))
                d.environment = Environment.initial
                d:unpause()
            end
            Environment.initial:apply(owner)
        end)
    end)
end)
Debug.endFile()