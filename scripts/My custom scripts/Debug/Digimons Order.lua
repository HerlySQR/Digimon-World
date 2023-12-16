OnInit(function ()
    Require "Timed"
    Require "PlayerUtils"

    Timed.echo(5., function ()
        ForForce(FORCE_PLAYING, function ()
            print(User[GetEnumPlayer()]:getNameColored() .. "'s digimons: ")
            for _, d in ipairs(GetAllDigimons(GetEnumPlayer())) do
                print(GetHeroProperName(d.root))
            end
        end)
    end)
end)