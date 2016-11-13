
local enabled = rPhone.GetVariable( "RPHONE_TONES_ENABLED", true )
local cl_only = rPhone.GetVariable( "RPHONE_TONES_CLIENTSIDEONLY", false )
local volume = math.Clamp( rPhone.GetVariable( "RPHONE_TONES_VOLUME", 10 ), 0, 100 )

local tones = {}
local player_tones = {}

function rPhone.RegisterTone( path )
	tones[path] = true

	if CLIENT then
		util.PrecacheSound( path )
	end
end

function rPhone.IsValidTone( path )
	return tones[path]
end

function rPhone.PlayToneInternal( ply, toneid, tone, reps, duration )
	if !enabled or (cl_only and SERVER) then return end
	if CLIENT then
		duration = reps
		reps = tone
		tone = toneid
		toneid = ply
		ply = LocalPlayer()
	end

	reps = math.Round( reps or 1 )

	if player_tones[ply] or !rPhone.IsValidTone( tone ) or reps == 0 then return end

	local slen = SoundDuration( tone )
	local snd = CreateSound( ply, tone )

	if !snd or !slen then return end

	slen = slen + 0.1

	if reps > 0 then
		duration = reps * slen
	elseif !duration or duration <= 0 then
		return
	end

	player_tones[ply] = {
		sound = snd,
		start = CurTime(),
		last_start = CurTime(),
		length = slen,
		duration = duration,
		toneid = toneid
	}

	snd:PlayEx( volume / 100, 100 )

	return toneid
end

function rPhone.StopToneInternal( ply, toneid )
	if !enabled or (cl_only and SERVER) then return end
	if CLIENT then
		toneid = ply
		ply = LocalPlayer()
	end

	local ptinfo = player_tones[ply]

	if ptinfo and (!toneid or toneid == ptinfo.toneid) then
		ptinfo.sound:Stop()
		player_tones[ply] = nil
	end
end

local function checkTones()
	for ply, ptinfo in pairs( player_tones ) do
		local ct = CurTime()

		if (ct - ptinfo.start) > ptinfo.duration then
			ptinfo.sound:Stop()

			player_tones[ply] = nil
		elseif (ct - ptinfo.last_start) > ptinfo.length then
			ptinfo.sound:Stop()
			ptinfo.sound:PlayEx( 0.1, 100 )

			ptinfo.last_start = ct
		end
	end
end

if enabled and (!cl_only or CLIENT) then
	timer.Create( "sh_tones_checktones", 0.1, 0, checkTones )
end
