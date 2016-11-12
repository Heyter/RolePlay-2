local MIXTURE = {}


MIXTURE.Name = "Wand Halterung"
MIXTURE.Description = ""
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_trainstation/mount_connection001a.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 2,
    wooden_nail = 4,
    metal_rod = 1,
    metal_polish = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
