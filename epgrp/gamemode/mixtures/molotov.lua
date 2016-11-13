local MIXTURE = {}


MIXTURE.Name = "Molotov"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_grenade.mdl"
MIXTURE.UniqueName = "molotov"

MIXTURE.VIP = false

MIXTURE.Items = {
    fuel_can = 1,
    propane_tank = 1,
    glue = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
