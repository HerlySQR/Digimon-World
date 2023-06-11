OnInit(function ()

    Timed.echo(1., function ()
        print("Sí")
        for i = 0, 1 do
            BlzFrameSetVisible(BlzGetFrameByName("AllianceSlot", i), false)
        end
    end)
end)