DIALOG = DIALOG or {}

local canGetCallback

DIALOG["NPC_GarageHello"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Hallo, wie kann ich Ihnen weiterhelfen?",
			options = {
				["Schon gut."] = function( frame )
					frame:Close( )
				end,
				["Ich möchte gerne meine Garage betreten."] = function( frame ) 
					CARSHOP.OpenGarage()
                    frame:Close()
				end
			}
		}
	}
	return tbl 
end