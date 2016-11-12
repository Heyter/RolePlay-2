local MIXTURE = {}


MIXTURE.Name = "Mossberg"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/v_shot_mberg_590.mdl"
MIXTURE.UniqueName = "m9k_mossberg590"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 6,
	piece_of_metal = 4,
    metal_polish = 1,
    chunk_of_plastic = 1,
	glue = 2
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 4
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
