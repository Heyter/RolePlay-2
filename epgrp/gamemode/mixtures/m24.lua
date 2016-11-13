local MIXTURE = {}


MIXTURE.Name = "M24"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_snip_m24_6.mdl"
MIXTURE.UniqueName = "m9k_m24"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 2,
	wooden_nail = 7,
	chunk_of_plastic = 3,
	piece_of_metal = 6,
    metal_polish = 3,
    paint_bucket = 1,
    cardboard_box = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 6,
    ["Handwerks Geschick"] = 5
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
