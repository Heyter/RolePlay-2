local MIXTURE = {}


MIXTURE.Name = "UZI"
MIXTURE.Description = ""
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_uzi_imi.mdl"
MIXTURE.UniqueName = "m9k_uzi"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	wooden_nail = 4,
	piece_of_metal = 3,
    metal_polish = 1,
    paint_bucket = 1,
	glue = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
