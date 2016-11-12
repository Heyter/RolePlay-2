local MIXTURE = {}


MIXTURE.Name = "Gewehr Munition"
MIXTURE.Description = "Inhalt 30 Patronen"
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/Items/BoxSRounds.mdl"
MIXTURE.UniqueName = "ent_rifle_ammo"

MIXTURE.VIP = false

MIXTURE.Items = {
    lodine = 1,
	chunk_of_plastic = 1,
    cardboard_box = 1,
    bullet_casing = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 2,
    ["Intelligenz"] = 3,
    ["Handwerks Geschick"] = 2
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
