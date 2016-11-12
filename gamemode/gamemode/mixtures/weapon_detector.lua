local MIXTURE = {}


MIXTURE.Name = "Waffen Detektor"
MIXTURE.Description = "Piept falls ein Spieler mit Waffe passiert."
MIXTURE.Category = "Items"
MIXTURE.Model = "models/props_wasteland/interior_fence002e.mdl"
MIXTURE.UniqueName = "item_weaponfinder"

MIXTURE.VIP = false

MIXTURE.Items = {
    piece_of_metal = 4,
    metal_rod = 4,
    wooden_nail = 4,
    normal_batterie = 1
}

MIXTURE.Skills = {
    ["Kraft"] =2,
    ["Intelligenz"] =3,
    ["Handwerks Geschick"] = 3
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
