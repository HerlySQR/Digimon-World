Debug.beginFile("Death Behind")
OnInit(function ()
    Require "SpellsTemplate"

    CreateImmediateAreaTargetSpell({
        spell = FourCC('A0FI'),
        strDmgFactor = 0.65,
        agiDmgFactor = 0.45,
        intDmgFactor = 0.3,
        attackFactor = 1.5,
        finalDmgFactor = 0.95,
        attType = udg_Machine,
        dmgType = DAMAGE_TYPE_NORMAL
    })
end)
Debug.endFile()