local MIXTURE = {}


MIXTURE.Name = "Door Welder"
MIXTURE.Description = "Wird benutzt um Tueren zu verschweißen."
MIXTURE.Category = "Weapon"
MIXTURE.Model = "models/weapons/w_rif_ak47.mdl"
MIXTURE.UniqueName = "door_welder"

MIXTURE.VIP = false

MIXTURE.Items = {
    metal_rod = 1,
	wooden_nail = 2,
	propane_tank = 1,
	piece_of_metal = 2,
	rope_roll = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
