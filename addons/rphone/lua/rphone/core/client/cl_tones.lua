
local enabled = rPhone.GetVariable( "RPHONE_TONES_ENABLED", true )
local cl_only = rPhone.GetVariable( "RPHONE_TONES_CLIENTSIDEONLY", false )

local toneid = 0

local function playTone( tone, reps, duration )
	if !enabled then return end

	reps = reps or 1
	toneid = toneid + 1

	if !rPhone.IsValidTone( tone ) or reps == 0 or (reps < 0 and (!duration or duration <= 0)) then return end

	if cl_only then
		rPhone.PlayToneInternal( toneid, tone, reps, duration )
	else
		net.Start( "rphone_tones_play" )
			net.WriteString( tone )
			net.WriteUInt( toneid, 16 )

			if reps < 0 then
				net.WriteBit( true )
				net.WriteFloat( duration )
			else
				net.WriteBit( false )
				net.WriteUInt( reps, 8 )
			end
		net.SendToServer()
	end

	return toneid
end



function rPhone.PlayToneLoop( tone, reps )
	if reps < 1 then return end

	return playTone( tone, reps )
end

function rPhone.PlayTone( tone )
	return rPhone.PlayToneLoop( tone, 1 )
end

function rPhone.PlayToneDuration( tone, duration )
	return playTone( tone, -1, duration )
end

function rPhone.StopTone( toneid )
	if !enabled then return end
	
	if cl_only then
		rPhone.StopToneInternal( toneid )
	else
		net.Start( "rphone_tones_stop" )
			net.WriteUInt( toneid or 0, 16 )
		net.SendToServer()
	end
end
