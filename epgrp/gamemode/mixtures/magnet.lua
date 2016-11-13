local MIXTURE = {}


MIXTURE.Name = "Magnet"
MIXTURE.Description = "Ein starker Magnet"
MIXTURE.Category = "Items"
MIXTURE.Model = "models/props_c17/streetsign004e.mdl"
MIXTURE.UniqueName = "ent_magnet"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 2,
    normal_batterie = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 1
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
