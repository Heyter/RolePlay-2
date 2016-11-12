local MIXTURE = {}


MIXTURE.Name = "AK 47"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_tct_ak47.mdl"
MIXTURE.UniqueName = "m9k_ak74"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 5,
    wooden_board = 4,
	chunk_of_plastic = 2,
	piece_of_metal = 4,
    metal_polish = 2,
    glue = 2
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 6
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
