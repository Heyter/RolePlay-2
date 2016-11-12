local MIXTURE = {}


MIXTURE.Name = "Deagle"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_tcom_deagle.mdl"
MIXTURE.UniqueName = "m9k_deagle"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	wooden_nail = 3,
	chunk_of_plastic = 2,
	piece_of_metal = 2,
    paint_bucket = 1,
    metal_polish = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
