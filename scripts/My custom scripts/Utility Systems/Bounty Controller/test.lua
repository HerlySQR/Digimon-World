OnInit(function ()
    Require "Timed"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar
    local Color = Require "Color" ---@type Color

    xpcall(function ()
    local pbar = ProgressBar.create()
    pbar.xOffset = -15
    pbar:setZOffset(200)
    pbar:setSize(1)
    pbar:RGB(Color.new(math.random(0x000000, 0xFFFFFF)))
    pbar:setTargetUnit(gg_unit_N005_0111)

    Timed.echo(2.5, function ()
        xpcall(function ()
        local random = GetRandomInt(20, 100)
        print(random .. "\x25")
        pbar:RGB(Color.new(math.random(0x000000, 0xFFFFFF)))
        pbar:setPercentage(random, 1)
        end, print)
    end)
    end, print)
end)