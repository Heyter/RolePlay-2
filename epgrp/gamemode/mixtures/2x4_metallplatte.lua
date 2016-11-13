local MIXTURE = {}


MIXTURE.Name = "Metallplatte 2x4"
MIXTURE.Description = ""
MIXTURE.Category = "Props"
MIXTURE.Model = "models/props_phx/construct/metal_plate2x4.mdl"
MIXTURE.UniqueName = "nosrp_prop"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 6,
    metal_polish = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 2,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
