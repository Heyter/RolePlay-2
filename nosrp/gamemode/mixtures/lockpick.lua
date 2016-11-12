local MIXTURE = {}


MIXTURE.Name = "Lockpick"
MIXTURE.Description = "Wird benutzt um Tueren zu aufzubrechen."
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_crowbar.mdl"
MIXTURE.UniqueName = "lockpick"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	piece_of_metal = 3,
}

MIXTURE.Skills = {
    ["Kraft"] = 4,
    ["Intelligenz"] = 1,
    ["Handwerks Geschick"] = 1
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
