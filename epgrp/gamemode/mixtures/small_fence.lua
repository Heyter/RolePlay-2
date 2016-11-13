local MIXTURE = {}


MIXTURE.Name = "Kleiner Drahtzaun"
MIXTURE.Description = "Allzweck Zaun"
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_c17/fence01a.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    wooden_nail = 4,
    metal_rod = 4
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
