
local APP = rPhone.AssertPackage( "phone" )

local whisper_always = rPhone.GetVariable( "PHONE_WHISPER_ALWAYS", false )
local phone_settings = {}

local function settingsPageLayout( pnl, settings )
	local pk_os = rPhone.AssertPackage( "os" )
	
	local tone = APP.GetRingTone()
	local ptt = APP.GetPushToTalkDefault()
	local whisper = APP.GetWhisperDefault()

	local tones = { "Silent", "Vibrate" }

	for tname in pairs( rPhone.GetVariable( "PHONE_RINGTONES", {} ) ) do
		table.insert( tones, tname )
	end

	table.sort( tones )

	if !table.HasValue( tones, tone ) then 
		tone = "Silent"
	end

	local lbltone = rPhone.CreatePanel( "DLabel", pnl )
		lbltone:SetText( "Ring Tone:" )
		lbltone:SizeToContents()
		lbltone:SetPos( 5, 7 )

	local btnplay = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnplay:SetWide( 50 )
		btnplay:SetText( "Play" )
		btnplay:SetPos( pnl:GetWide() - btnplay:GetWide() - 5, 5 )
		function btnplay:DoClick()
			local tone = APP.GetRingTone()

			if !tone or tone == "Silent" then return end
			if tone == "Vibrate" then 
				pk_os.Vibrate( APP.GetRingTimeout() )
				
				return
			end

			local tones = rPhone.GetVariable( "PHONE_RINGTONES", {} )
			local path = tones[tone]
			
			if !path or !rPhone.IsValidTone( path ) then return end

			surface.PlaySound( path )
		end

	local cmbtone = rPhone.CreatePanel( "DComboBox", pnl )
		cmbtone:SetPos( lbltone:GetWide() + 10, 5 )
		cmbtone:SetWide( pnl:GetWide() - lbltone:GetWide() - btnplay:GetWide() - 20 )
		cmbtone:SetValue( tone )
		function cmbtone:OnSelect( idx, val, data )
			settings.ring_tone = val
		end

	btnplay:SetTall( cmbtone:GetTall() )

	for _, tname in pairs( tones ) do
		cmbtone:AddChoice( tname )
	end

	local chkptt = rPhone.CreatePanel( "DCheckBoxLabel", pnl )
		chkptt:SetText( "Push-To-Talk Start On" )
		chkptt:SizeToContents()
		chkptt:SetPos( 5, cmbtone:GetTall() + 10 )
		chkptt:SetChecked( ptt )
		function chkptt:OnChange( checked )
			settings.ptt_default = checked
		end

	local chkwsp = rPhone.CreatePanel( "DCheckBoxLabel", pnl )
		chkwsp:SetText( "Whisper Start On" )
		chkwsp:SizeToContents()
		chkwsp:SetPos( 5, cmbtone:GetTall() + chkptt:GetTall() + 15 )
		function chkwsp:OnChange( checked )
			settings.whisper_default = checked
		end
		if whisper_always then
			chkwsp:SetChecked( true )
			chkwsp:SetDisabled( true )
		else
			chkwsp:SetChecked( whisper )
		end
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	phone_settings = apk_settings.GetSettings( APP.PackageName )
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( APP.DisplayName, {
		Category = "Apps",
		PackageName = APP.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )



function APP.GetRingTone()
	return phone_settings.ring_tone or rPhone.GetVariable( "PHONE_RINGTONE_DEFAULT", "Silent" )
end

function APP.GetRingTimeout()
	return rPhone.GetVariable( "PHONE_RING_TIMEOUT", 10 )
end

function APP.GetWhisperDefault()
	return phone_settings.whisper_default or rPhone.GetVariable( "PHONE_WHISPER_DEFAULT", false )
end

function APP.GetWhisperAlways()
	return whisper_always
end

function APP.GetPushToTalkDefault()
	return phone_settings.ptt_default or rPhone.GetVariable( "PHONE_PTT_DEFAULT", false )
end
