
local ring_tones = {}

local function AddRingTone( name, path )
	ring_tones[name] = path

	rPhone.RegisterTone( path )

	if CLIENT and !rPhone.GetVariable( "PHONE_RINGTONES" ) then
		rPhone.SetVariable( "PHONE_RINGTONES", ring_tones )
	end
end



AddRingTone( "Canis Major", "dan/rphone/bundles/phone/canismajor.wav" )  --add a ringtone, provide a name (visible to the user), and path to the sound
AddRingTone( "Girtab", "dan/rphone/bundles/phone/girtab.wav" )
AddRingTone( "Hydra", "dan/rphone/bundles/phone/hydra.wav" )
AddRingTone( "Jack", "dan/rphone/bundles/phone/jack.wav" )
AddRingTone( "Orion", "dan/rphone/bundles/phone/orion.wav" )
AddRingTone( "Rigel", "dan/rphone/bundles/phone/rigel.wav" )
AddRingTone( "Standard", "dan/rphone/bundles/phone/standard.wav" )


rPhone.CLSetVariable( "PHONE_RINGTONE_DEFAULT", "Canis Major" )  --default ringtone for phone, use the ringtone name, not the path
																 --'Silent' and 'Vibrate' are also valid values

rPhone.SetVariable( "PHONE_RING_TIMEOUT", 10 )  --maximum ring time until automatic call termination

rPhone.SetVariable( "PHONE_WHISPER_ALWAYS", false )  --always whisper when using phone
rPhone.CLSetVariable( "PHONE_WHISPER_DEFAULT", false )  --whether whisper is on by default

rPhone.CLSetVariable( "PHONE_PTT_DEFAULT", false )  --whether push-to-talk is on by default
