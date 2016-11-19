net.Receive( "NPC_CanTakeJob", function( )
    local TEAM = net.ReadString()
    local canDo = tonumber(net.ReadString())
	canDoCallback( canDo or 1 )
end )

DIALOG = DIALOG or {}

DIALOG["NPC_Jailer"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Guten Tag.\nWas kann ich für sie tun Mr.?",
			options = {
                ["Ich möchte ein Spieler Inhaftieren"] = function( frame ) 
					CanDoJob( TEAM_POLICE, function( canDo )
						if canDo then
							OpenJailerMenu( frame.npc )
							frame:Close()
						else
							frame:Close()
						end
					end )
				end,
				["Nichts."] = function( frame )
					frame:Close( )
				end
			}
		}
	}
	return tbl 
end

DIALOG["NPC_Jailer_Nope"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Dies ist eine Sicherheitszone!\nVerlassen sie umgehend diesen Bereich.\nOder sie werden Verhaftet!",
			options = {
                ["Ok"] = function( frame ) 
					frame:Close()
				end
			}
		}
	}
	return tbl 
end
