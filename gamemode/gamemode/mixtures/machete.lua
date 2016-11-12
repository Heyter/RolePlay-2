local MIXTURE = {}


MIXTURE.Name = "Machete"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_fc2_machete.mdl"
MIXTURE.UniqueName = "m9k_machete"

MIXTURE.VIP = true

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
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
