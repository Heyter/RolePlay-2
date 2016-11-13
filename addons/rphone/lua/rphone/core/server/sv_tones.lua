
if !rPhone.GetVariable( "RPHONE_TONES_ENABLED", true ) or 
	rPhone.GetVariable( "RPHONE_TONES_CLIENTSIDEONLY", false ) then return end

util.AddNetworkString( "rphone_tones_play" )
util.AddNetworkString( "rphone_tones_stop" )

local suppress_interval = rPhone.GetVariable( "TONES_SUPPRESS_INTERVAL", 5 )
local max_length = rPhone.GetVariable( "TONES_MAX_LENGTH", 10 )

local last_tones = {}

net.Receive( "rphone_tones_play", function( len, ply )
	if last_tones[ply] and (CurTime() - last_tones[ply]) < suppress_interval then return end

	local tone = net.ReadString()
	local toneid = net.ReadUInt( 16 )
	local reps, duration

	if net.ReadBit() == 1 then
		reps = -1
		duration = net.ReadFloat()
	else
		reps = net.ReadUInt( 8 )
	end

	if !rPhone.IsValidTone( tone ) then return end

	local slen = SoundDuration( tone )

	if reps > 0 then
		local maxreps = math.floor( max_length / slen )

		reps = math.min( reps, maxreps )
	else
		duration = math.min( duration, max_length )
	end

	if reps == 0 or (duration and duration <= 0) then return end

	rPhone.PlayToneInternal( ply, toneid, tone, reps, duration )

	last_tones[ply] = CurTime()
end )

net.Receive( "rphone_tones_stop", function( len, ply )
	local toneid = net.ReadUInt( 16 )

	rPhone.StopToneInternal( ply, toneid )
end )
