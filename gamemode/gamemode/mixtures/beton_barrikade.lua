local MIXTURE = {}


MIXTURE.Name = "Beton Barrikade"
MIXTURE.Description = ""
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_c17/concrete_barrier001a.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 4,
    lodine = 2
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
