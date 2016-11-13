
local APP = rPhone.AssertPackage( "camera" )

local camera_settings = {}

local function settingsPageLayout( pnl, settings )
	local chkfullscr = rPhone.CreatePanel( "DCheckBoxLabel", pnl )
		chkfullscr:SetText( "Capture Fullscreen" )
		chkfullscr:SizeToContents()
		chkfullscr:SetPos( 5, 5 )
		chkfullscr:SetChecked( APP.GetShouldCaptureFullscreen() )
		function chkfullscr:OnChange( checked )
			settings.capture_fullscreen = checked
		end
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	camera_settings = apk_settings.GetSettings( APP.PackageName )
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( APP.DisplayName, {
		Category = "Apps",
		PackageName = APP.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )



function APP.GetShouldCaptureFullscreen()
	return camera_settings.capture_fullscreen or false
end
