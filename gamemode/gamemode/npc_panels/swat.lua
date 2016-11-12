net.Receive( "NPC_CanTakeJob", function( )
    local TEAM = net.ReadString()
    local canDo = tonumber(net.ReadString())
	canDoCallback( canDo or 1 )
end )

DIALOG = DIALOG or {}

DIALOG["NPC_SwatHello"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Guten Tag.\nWas kann ich für sie tun?",
			options = {
                ["Ich möchte der SWAT Einheit angehören."] = function( frame ) 
					CanDoJob( TEAM_SWAT, function( canDo )
						if canDo then
							frame:GoToStage( 2 )
						else
							frame:Close()
						end
					end )
				end,
				["Ich habe es mir gerade anders überlegt. Entschuldigen Sie die Störung."] = function( frame )
					frame:Close( )
				end
			}
		},
        {
			npcsay = "Willkommen im Team!",
			options = {
                ["Danke"] = function( frame ) 
					frame:Close()
				end
			}
		}
	}
	return tbl 
end

DIALOG["NPC_SwatInTeam"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Was kann ich für Sie tun?",
			options = {
                ["Ich will gerne kündigen! Hier sind meine Sachen"] = function( frame ) 
                    net.Start( "NPC_LeaveJob" )
                    net.SendToServer()
                    frame:GoToStage( 2 )
                end,
                ["Ich möchte einen Dienstwagen anfordern!"] = function( frame ) 
					net.Start( "NPC_ClaimJobCar" )
                    net.SendToServer()
                    --frame:GoToStage( 2 )
                    frame:Close()
                end,
                ["Schon gut"] = function( frame )
                    frame:Close()
                end
			}
		},
        {
            npcsay = "Alles klar. Danke für Ihre Unterstützung.",
			options = {
                ["*Gehen*"] = function( frame ) 
					frame:Close()
				end
			}
        }
	}
	return tbl 
end