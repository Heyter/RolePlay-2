ITEM.Name = "Feuerlöscher"
ITEM.Description = ""
ITEM.Model = "models/props/cs_office/Fire_Extinguisher.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false

function ITEM:Use( pl )
	pl:Give( "fire_extinguisher" )
    return true
end