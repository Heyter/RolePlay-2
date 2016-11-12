local MIXTURE = {}


MIXTURE.Name = "Shotgun Munition"
MIXTURE.Description = "Inhalt 25 Patronen"
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/items/boxbuckshot.mdl"
MIXTURE.UniqueName = "ent_buckshot_ammo"

MIXTURE.VIP = false

MIXTURE.Items = {
    chunk_of_plastic = 1,
    cardboard_box = 1,
    bullet_casing = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 1,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
