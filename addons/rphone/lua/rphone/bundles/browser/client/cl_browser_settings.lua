
local APP = rPhone.AssertPackage( "browser" )

local browser_settings = {}

local function settingsPageLayout( pnl, settings )
	local lblhome = rPhone.CreatePanel( "DLabel", pnl )
		lblhome:SetText( "Homepage:" )
		lblhome:SizeToContents()
		lblhome:SetPos( 5, 7 )

	local txthome = rPhone.CreatePanel( "DTextEntry", pnl )
		txthome:SetText( APP.GetHomepage() )
		txthome:SetPos( lblhome:GetWide() + 10, 5 )
		txthome:SetWide( pnl:GetWide() - lblhome:GetWide() - 15 )
		function txthome:OnTextChanged()
			settings.homepage = self:GetText()
		end
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	browser_settings = apk_settings.GetSettings( APP.PackageName )
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( APP.DisplayName, {
		Category = "Apps",
		PackageName = APP.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )



function APP.GetHomepage()
	local homepage = browser_settings.homepage or rPhone.GetVariable( 
		"BROWSER_HOMEPAGE_DEFAULT", 
		"http://www.google.com"
	)

	if !homepage:StartWith( "http://" ) then
		homepage = "http://" .. homepage
	end

	return homepage
end
