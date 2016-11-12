DIALOG = DIALOG or {}

local canGetCallback

DIALOG["NPC_CarDealerHello"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Hallo, wie kann ich Ihnen weiterhelfen?",
			options = {
				["Schon gut."] = function( frame )
					frame:Close( )
				end,
				["Ich möchte gerne ihren Auto-Katalog ansehen."] = function( frame ) 
					CARSHOP.OpenShop()
                    frame:Close()
				end
			}
		}
	}
	return tbl 
end