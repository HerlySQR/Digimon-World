Debug.beginFile("Pummel Peck")
OnInit(function ()
    Require "SpellsTemplate"

    CreateMultipleMissilesSpell({
        spell = FourCC('A06A'),
        strDmgFactor = 0.3,
        agiDmgFactor = 0.6,
        intDmgFactor = 0.5,
        attackFactor = 1.2,
        missileModel = "war3mapImported\\Kiwimon.mdx",
        missileCount = 6,
        zOffsetSource = 100,
        zOffsetTarget = 0,
        scale = 0.001,
        speed = 700.,
        arc = 15.,
        attType = udg_Nature,
        dmgType = DAMAGE_TYPE_ENHANCED,
        buffType = BuffSpell.STUN,
        buffLevel = 2
    })
end)
Debug.endFile()