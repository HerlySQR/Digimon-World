Debug.beginFile("UpdateHealthbar")
OnInit(function ()
    Require "UIUtils"
    Require "Timed"

    Foo = {} ---@type unit[]

    Foo[0] = gg_unit_hfoo_0004
    Foo[1] = gg_unit_hfoo_0002
    Foo[2] = gg_unit_hfoo_0005

    Timed.echo(0.1, function ()
        healthbarFrame:setValue(GetUnitState(Foo[LocalPlayerId], UNIT_STATE_LIFE)/GetUnitState(Foo[LocalPlayerId], UNIT_STATE_MAX_LIFE))
    end)
end)
Debug.endFile()