local MIXTURE = {}


MIXTURE.Name = "Pistolen Munition"
MIXTURE.Description = "Inhalt 15 Patronen"
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/Items/357ammobox.mdl"
MIXTURE.UniqueName = "ent_pistol_ammo"

MIXTURE.VIP = false

MIXTURE.Items = {
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
