local MIXTURE = {}


MIXTURE.Name = "AS Val"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_dmg_vally.mdl"
MIXTURE.UniqueName = "m9k_val"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 5,
	chunk_of_plastic = 3,
	piece_of_metal = 5,
    metal_polish = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 4
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
