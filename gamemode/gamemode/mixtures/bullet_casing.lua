local MIXTURE = {}


MIXTURE.Name = "Bullet Casing"
MIXTURE.Description = "Eine leere Patronenhuelle."
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/Items/AR2_Grenade.mdl"
MIXTURE.UniqueName = "bullet_casing"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 1,
	chunk_of_plastic = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
