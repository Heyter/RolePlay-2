local MIXTURE = {}


MIXTURE.Name = "Physic Gun"
MIXTURE.Description = "Wird benutzt um Objekte zu Fixieren"
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_physics.mdl"
MIXTURE.UniqueName = "weapon_physgun"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	chunk_of_plastic = 2,
	piece_of_metal = 4,
    metal_polish = 2,
    lodine = 5,
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
