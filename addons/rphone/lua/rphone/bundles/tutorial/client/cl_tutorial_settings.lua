
local APP = rPhone.AssertPackage( "tutorial" )

local function settingsPageLayout( pnl, settings )
	local btntut = rPhone.CreatePanel( "RPDTextButton", pnl )
		btntut:SetText( "Replay Tutorial" )
		btntut:SetWide( 100 )
		btntut:SetPos( 5, 5 )
		function btntut:DoClick()
			APP.PlayTutorial()
		end
end

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk )
	apk.AddSettingsPage( "Tutorial", {
		Category = "System",
		PerformLayout = settingsPageLayout
	} )
end )
