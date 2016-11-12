local MIXTURE = {}


MIXTURE.Name = "Colt"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/s_dmgf_co1911.mdl"
MIXTURE.UniqueName = "m9k_colt1911"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	wooden_nail = 2,
	chunk_of_plastic = 1,
	piece_of_metal = 2,
    metal_polish = 1,
    wooden_board = 1,
	glue = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
