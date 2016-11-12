local MIXTURE = {}


MIXTURE.Name = "Sprengsatz"
MIXTURE.Description = "Wird benutzt um Tueren zu sprengen"
MIXTURE.Category = "Misc"
MIXTURE.Model = "models/Items/car_battery01.mdl"
MIXTURE.UniqueName = "item_doorbuster"

MIXTURE.VIP = false

MIXTURE.Items = {
    propane_tank = 2,
    fuel_can = 4,
	piece_of_metal = 2,
    normal_batterie = 1,
	glue = 1
}

MIXTURE.Skills = {
    ["Kraft"] = 3,
    ["Intelligenz"] = 4,
    ["Handwerks Geschick"] = 5
}



// Don't touch!
RP.CRAFTING.AddMixture( MIXTURE )
