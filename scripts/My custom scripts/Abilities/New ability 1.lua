Debug.beginFile("Grand Cross")
OnInit(function ()
    Require "SpellsTemplate"

    CreateSingleMissileSpell({
        spell = FourCC('A04L'),
        strDmgFactor = 0.2,
        agiDmgFactor = 0.1,
        intDmgFactor = 0.9,
        attackFactor = 1.2,
        missileModel = "",
        targetEffect = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
        zOffsetSource = 50,
        zOffsetTarget = 50,
        scale = 0.1,
        speed = 1000.,
        arc = 10.,
        pColor = 4,
        attType = udg_Holy,
        dmgType = DAMAGE_TYPE_NORMAL
    })
end)
Debug.endFile()