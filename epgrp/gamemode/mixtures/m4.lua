local MIXTURE = {}


MIXTURE.Name = "M4"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_hk_416.mdl"
MIXTURE.UniqueName = "m9k_m416"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 6,
	chunk_of_plastic = 3,
	piece_of_metal = 6,
    metal_polish = 3
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 6,
    ["Handwerks Geschick"] = 5
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
