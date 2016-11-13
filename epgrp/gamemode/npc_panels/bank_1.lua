net.Receive( "NPC_CanTakeJob", function( )
    local TEAM = net.ReadString()
    local canDo = tonumber(net.ReadString())
	canDoCallback( canDo or 1 )
end )

DIALOG = DIALOG or {}

DIALOG["NPC_BankHello"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Guten Tag.\nWas kann ich für sie tun?",
			options = {
                ["Ich möchte an mein Bank-CP."] = function( frame ) 
                    NOSBankMenu()
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