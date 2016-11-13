
local sms_tones = {}

local function AddSMSTone( name, path )
	sms_tones[name] = path

	rPhone.RegisterTone( path )

	if CLIENT and !rPhone.GetVariable( "SMS_TONES" ) then
		rPhone.SetVariable( "SMS_TONES", sms_tones )
	end
end



AddSMSTone( "Subtle", "dan/rphone/bundles/sms/subtle.wav" )  --add an sms tone, provide a name (visible to the user), and path to the sound
AddSMSTone( "Major", "dan/rphone/bundles/sms/major.wav" )
AddSMSTone( "Instance", "dan/rphone/bundles/sms/instance.wav" )
AddSMSTone( "Confirm", "dan/rphone/bundles/sms/confirm.wav" )
AddSMSTone( "Color", "dan/rphone/bundles/sms/color.wav" )


rPhone.CLSetVariable( "SMS_TONE_DEFAULT", "Subtle" )  --default sms tone, use the tone name, not the path
													  --'Silent' and 'Vibrate' are also valid values

rPhone.SVSetVariable( "SMS_MAILBOX_SIZE", 50 )  --maximum mailbox (offline message queue) size
rPhone.SetVariable( "SMS_MAX_MESSAGE_LENGTH", 256 )  --maximum message length
