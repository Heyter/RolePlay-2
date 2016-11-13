
local APP = rPhone.AssertPackage( "sms" )

local sms_settings = {}

local function settingsPageLayout( pnl, settings )
	local pk_os = rPhone.AssertPackage( "os" )
	
	local tone = APP.GetTone()
	local tones = { "Silent", "Vibrate" }

	for tname in pairs( rPhone.GetVariable( "SMS_TONES", {} ) ) do
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
			local tone = APP.GetTone()

			if !tone or tone == "Silent" then return end
			if tone == "Vibrate" then 
				pk_os.Vibrate()
				
				return
			end

			local tones = rPhone.GetVariable( "SMS_TONES", {} )
			local path = tones[tone]
			
			if !path or !rPhone.IsValidTone( path ) then return end

			surface.PlaySound( path )
		end

	local cmbtone = rPhone.CreatePanel( "DComboBox", pnl )
		cmbtone:SetPos( lbltone:GetWide() + 10, 5 )
		cmbtone:SetWide( pnl:GetWide() - lbltone:GetWide() - btnplay:GetWide() - 20 )
		cmbtone:SetValue( tone )
		function cmbtone:OnSelect( idx, val, data )
			settings.tone = val
		end

	btnplay:SetTall( cmbtone:GetTall() )

	for _, tname in pairs( tones ) do
		cmbtone:AddChoice( tname )
	end
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	sms_settings = apk_settings.GetSettings( APP.PackageName )
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( APP.DisplayName, {
		Category = "Apps",
		PackageName = APP.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )



function APP.GetTone()
	return sms_settings.tone or rPhone.GetVariable( "SMS_TONE_DEFAULT", "Silent" )
end
