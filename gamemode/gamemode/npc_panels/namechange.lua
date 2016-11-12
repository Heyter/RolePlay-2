net.Receive( "NPC_CanTakeJob", function( )
    local TEAM = net.ReadString()
    local canDo = tonumber(net.ReadString())
	canDoCallback( canDo or 1 )
end )

DIALOG = DIALOG or {}

DIALOG["NAMECHANGE_HELLO"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Ein Namenswechsel kostet: " .. (SETTINGS.NameChangeCost or 0) .. ",-EUR",
			options = {
                ["OK, lass es uns tun!"] = function( frame ) 
                    net.Start( "RP_WantNameChange" )
                    net.SendToServer()
                    frame:Close()
				end,
				["Ich habe es mir gerade anders überlegt. Entschuldigen Sie die Störung."] = function( frame )
					frame:Close( )
				end
			}
		}
	}
	return tbl 
end

DIALOG["CANT_DO_NAMECHANGE"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Du kannst dir das leider nicht leisten. Tut mir leid",
			options = {
                ["Ein versuch war's wert *grins* :D"] = function( frame ) 
                    frame:Close()
				end
			}
		}
	}
	return tbl 
end