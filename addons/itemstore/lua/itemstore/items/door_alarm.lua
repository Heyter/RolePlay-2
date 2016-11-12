ITEM.Name = "Tür Alarm"
ITEM.Description = ""
ITEM.Model = "models/props_lab/reciever01d.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false

function ITEM:Use( pl )
	pl:Give( "door_alarm" )
    return true
end

