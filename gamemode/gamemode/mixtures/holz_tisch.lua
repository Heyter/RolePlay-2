local MIXTURE = {}


MIXTURE.Name = "Holz Tisch"
MIXTURE.Description = ""
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_c17/FurnitureTable002a.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    wooden_board = 2,
    wooden_nail = 4,
    glue = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
