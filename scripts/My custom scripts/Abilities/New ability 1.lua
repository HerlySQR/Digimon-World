Debug.beginFile("Meteor Shower Star")
OnInit(function ()
    Require "SpellsTemplate"

    CreateFragmentsSpell({
        spell = FourCC('A0AI'),
        strDmgFactor = 0.4,
        agiDmgFactor = 0.6,
        intDmgFactor = 0.4,
        attackFactor = 1.2,
        finalDmgFactor = 0.95,
        dmgPerSecFactor = 1,
        missileModel = "Units\\Demon\\Infernal\\InfernalBirth.mdl",
        fragmentsEffect = "Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl",
        zOffsetSource = 60,
        zOffsetTarget = 0,
        scale = 0.5,
        speed = 1500.,
        arc = 0.,
        fragmentsOffset = 0.2,
        attType = udg_Fire,
        dmgType = DAMAGE_TYPE_FIRE
    })
end)
Debug.endFile()