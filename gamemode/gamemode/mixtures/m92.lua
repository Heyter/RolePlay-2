local MIXTURE = {}


MIXTURE.Name = "M92 - Baretta"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_beretta_m92.mdl"
MIXTURE.UniqueName = "m9k_m92beretta"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	wooden_nail = 4,
	chunk_of_plastic = 2,
	piece_of_metal = 1,
    metal_polish = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
