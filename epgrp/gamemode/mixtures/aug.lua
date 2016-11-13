local MIXTURE = {}


MIXTURE.Name = "m9k_auga3"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/v_auga3sa.mdl"
MIXTURE.UniqueName = "m9k_auga3"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 5,
	chunk_of_plastic = 1,
	piece_of_metal = 5,
    metal_polish = 1,
    normal_batterie = 1,
	glue = 2
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 4
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
