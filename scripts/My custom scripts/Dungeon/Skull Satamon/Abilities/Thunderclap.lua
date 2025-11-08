Debug.beginFile("Skull Satamon\\Abilities\\Thunderclap")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0DW')
    local DELAY = 2.5 -- Same as object editor
    local ORDER = Orders.thunderclap

    RegisterSpellChannelEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_AQUA)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) or GetUnitCurrentOrder(caster) ~= ORDER then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            bar:destroy()
        end)
    end)
end)
Debug.endFile()