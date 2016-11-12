local MIXTURE = {}


MIXTURE.Name = "Bandage"
MIXTURE.Description = "Heilt deine Wunden und stoppt Blutungen."
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/Items/BoxFlares.mdl"
MIXTURE.UniqueName = "bandage"

MIXTURE.VIP = false

MIXTURE.Items = {
    lodine = 2,
}

MIXTURE.Skills = {
    ["Intelligenz"] = 1,
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
