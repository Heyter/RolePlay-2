
local ScriptFodderProfileURL = "http://scriptfodder.com/users/view/76561197997120007"
local ProjectURL = "http://scriptfodder.com/scripts/view/174"


local OS = rPhone.AssertPackage( "os" )

local function addLine( list, txt, onclick )
	local line = rPhone.CreatePanel( "RPDMarkupLabel" )
		line:SetWide( list:GetWide() )
		line:SetText( txt )

	if onclick then
		local btn = rPhone.CreatePanel( "RPDContentButton" )
			btn:SetSize( line:GetSize() )
			btn.Paint = nil
			btn.DoClick = onclick

		line:SetParent( btn )

		line = btn
	end

	list:AddItem( line )
end

local function settingsPageLayout( pnl, settings )
	local nicenum = rPhone.ToNiceNumber( rPhone.GetNumber() or '' )
	local version = rPhone.Version or ''

	local list = rPhone.CreatePanel( "RPDCategoryList", pnl )
		list:SetPos( 5, 5 )
		list:SetSize( pnl:GetWide() - 10, pnl:GetTall() - 10 )

	list:AddCategory( "rPhone" )

	addLine( list, [[<font=DermaDefaultBold>Version:</font> ]] .. version )
	addLine( list, [[<font=DermaDefaultBold>Phone Number:</font> ]] .. nicenum, function()
		SetClipboardText( nicenum )
	end )

	list:AddCategory( "Credits" )

	addLine( list, [[<font=DermaDefaultBold>Author:</font> Dan]] )
	addLine( list, [[<font=DermaDefaultBold>Contact:</font> ScriptFodder profile]], function()
		gui.OpenURL( ScriptFodderProfileURL )
	end )
	addLine( list, [[<font=DermaDefaultBold>Project:</font> rPhone]], function()
		gui.OpenURL( ProjectURL )
	end )
end

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( "About", {
		Category = "System",
		PackageName = OS.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )
