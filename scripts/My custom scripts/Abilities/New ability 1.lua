Debug.beginFile("Nitro Stinger")
OnInit(function ()
    Require "SpellsTemplate"

    CreateMultipleMissilesSpell({
        spell = FourCC('A08D'),
        strDmgFactor = 0.7,
        agiDmgFactor = 0.75,
        intDmgFactor = 0.15,
        attackFactor = 1.6,
        missileModel = "Missile\\Firebrand Shot Yellow.mdx",
        missileCount = 8,
        zOffsetSource = 150,
        zOffsetTarget = 0,
        scale = 0.5,
        speed = 700.,
        arc = 20.,
        attType = udg_Air,
        dmgType = DAMAGE_TYPE_NORMAL,
        buffType = BuffSpell.PURGE,
        buffLevel = 2
    })
end)
Debug.endFile()