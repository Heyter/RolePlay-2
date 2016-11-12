local MIXTURE = {}


MIXTURE.Name = "Plexiglas - 2x2"
MIXTURE.Description = ""
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_phx/construct/glass/glass_plate2x2.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    glue = 2,
    chunk_of_plastic = 4
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
