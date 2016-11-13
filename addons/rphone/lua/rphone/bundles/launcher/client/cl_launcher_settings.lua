
local APP = rPhone.AssertPackage( "launcher" )

local launcher_settings = {}

local function launcherSettingsPageLayout( pnl, settings )
	local icncol, txtcol = APP.GetIconColor(), APP.GetIconTextColor()
	local fadelen = APP.GetFadeAnimationTime()

	local w = pnl:GetWide() - 10

	local lblfade = rPhone.CreatePanel( "DLabel", pnl )
		lblfade:SetText( "Fade Time:" )
		lblfade:SizeToContents()
		lblfade:SetPos( 5, 7 )

	local txtfade = rPhone.CreatePanel( "DTextEntry", pnl )
		txtfade:SetPos( lblfade:GetWide() + 10, 5 )
		txtfade:SetWide( 100 )
		txtfade:SetText( fadelen )
		function txtfade:OnTextChanged()
			local len = tonumber( self:GetText() )

			if !len or len < 0 then return end

			len = math.Clamp( len, 0, 5 )

			settings.fade_len = len
		end

	local btnreset = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnreset:SetText( "Reset to Default" )
		btnreset:SetWide( 100 )
		btnreset:SetPos( 5, pnl:GetTall() - btnreset:GetTall() - 5 )



	local list = rPhone.CreatePanel( "DPanelList", pnl )
		list:SetPos( 5, txtfade:GetTall() + 10 )
		list:SetSize( w, pnl:GetTall() - btnreset:GetTall() - txtfade:GetTall() - 20 )
		list:SetSpacing( 5 )
		list:SetPadding( 0 )

	local lbliconcol = rPhone.CreatePanel( "DLabel" )
		lbliconcol:SetText( "Icon Color" )
		lbliconcol:SizeToContents()

	local cmixicon = rPhone.CreatePanel( "DColorMixer" )
		cmixicon:SetSize( w, w / 2 )
		cmixicon:SetPalette( false )
		cmixicon:SetAlphaBar( true )
		cmixicon:SetColor( icncol )
		function cmixicon:Think()
			settings.icon_color = self:GetColor()
		end	

	local lbltxtcol = rPhone.CreatePanel( "DLabel" )
		lbltxtcol:SetText( "Icon Label Color" )
		lbltxtcol:SizeToContents()

	local cmixtxt = rPhone.CreatePanel( "DColorMixer" )
		cmixtxt:SetSize( w, w / 2 )
		cmixtxt:SetPalette( false )
		cmixtxt:SetAlphaBar( true )
		cmixtxt:SetColor( txtcol )
		function cmixtxt:Think()
			settings.icon_text_color = self:GetColor()
		end

	function btnreset:DoClick()
		settings.icon_color = nil
		settings.icon_text_color = nil
		settings.fade_len = nil

		local icncol, txtcol = APP.GetIconColor(), APP.GetIconTextColor()
		local fadelen = APP.GetFadeAnimationTime()

		cmixicon:SetColor( icncol )
		cmixtxt:SetColor( txtcol )
		txtfade:SetText( fadelen )
	end

	list:AddItem( lbliconcol )
	list:AddItem( cmixicon )
	list:AddItem( lbltxtcol )
	list:AddItem( cmixtxt )
end

local function wallpaperSettingsPageLayout( pnl, settings )
	local mode = APP.GetWallpaperMode()
	local col = APP.GetWallpaperColor()
	local url = APP.GetWallpaperURL()

	local btnreset = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnreset:SetText( "Reset to Default" )
		btnreset:SetWide( 100 )
		btnreset:SetPos( 5, pnl:GetTall() - btnreset:GetTall() - 5 )

	local propsheet = rPhone.CreatePanel( "DPropertySheet", pnl )
		propsheet:SetSize( pnl:GetWide(), pnl:GetTall() - btnreset:GetTall() - 5 )
		propsheet:SetShowIcons( false )
		propsheet:SetPadding( 0 )
		propsheet:SetFadeTime( 0 )
		propsheet.Paint = nil
		function propsheet:Think()
			local tab = self:GetActiveTab()

			if !IsValid( tab ) then return end

			local mode = tab:GetText():lower()

			settings.wallpaper_mode = mode
		end

	local sheetcolor = rPhone.CreatePanel( "DPanel" )
		sheetcolor.Paint = nil

	local sheeturl = rPhone.CreatePanel( "DPanel" )
		sheeturl.Paint = nil

	local tabcolor = propsheet:AddSheet( "Color", sheetcolor, nil, false, false ).Tab
		tabcolor.Paint = nil

	local taburl = propsheet:AddSheet( "URL", sheeturl, nil, false, false ).Tab
		taburl.Paint = nil

	propsheet:InvalidateLayout( true )
	propsheet:SetActiveTab( (mode == "color") and tabcolor or taburl )


	local w = pnl:GetWide() - 10

	local cmixcol = rPhone.CreatePanel( "DColorMixer", sheetcolor )
		cmixcol:SetPos( 5, 5 )
		cmixcol:SetSize( w, w / 2 )
		cmixcol:SetPalette( false )
		cmixcol:SetAlphaBar( false )
		cmixcol:SetColor( Color( col.r, col.g, col.b ) )
		function cmixcol:Think()
			settings.wallpaper_color = self:GetColor()
		end


	local lblurl = rPhone.CreatePanel( "DLabel", sheeturl )
		lblurl:SetText( "Image URL:" )
		lblurl:SizeToContents()
		lblurl:SetPos( 5, 7 )

	local txturl = rPhone.CreatePanel( "DTextEntry", sheeturl )
		txturl:SetText( url )
		txturl:SetPos( lblurl:GetWide() + 10, 5 )
		txturl:SetWide( pnl:GetWide() - lblurl:GetWide() - 15 )
		function txturl:OnTextChanged()
			settings.wallpaper_url = self:GetText()
		end

	function btnreset:DoClick()
		settings.wallpaper_mode = nil
		settings.wallpaper_color = nil
		settings.wallpaper_url = nil

		local mode = APP.GetWallpaperMode()
		local col = APP.GetWallpaperColor()
		local url = APP.GetWallpaperURL()

		cmixcol:SetColor( Color( col.r, col.g, col.b ) )
		txturl:SetText( url )
		propsheet:SetActiveTab( (mode == "color") and tabcolor or taburl )
	end
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	launcher_settings = apk_settings.GetSettings( APP.PackageName )

	APP.UpdateWallpaper()
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( "Launcher", {
		Category = "General",
		PackageName = APP.PackageName,
		PerformLayout = launcherSettingsPageLayout
	} )

	apk_settings.AddSettingsPage( "Wallpaper", {
		Category = "General",
		PackageName = APP.PackageName,
		PerformLayout = wallpaperSettingsPageLayout,
		OnClose = APP.UpdateWallpaper
	} )
end )



function APP.GetIconColor()
	return launcher_settings.icon_color or rPhone.GetVariable( 
		"LAUNCHER_ICON_COLOR_DEFAULT", 
		Color( 255, 255, 255, 255 ) 
	)
end

function APP.GetIconTextColor()
	return launcher_settings.icon_text_color or rPhone.GetVariable( 
		"LAUNCHER_ICON_TEXT_COLOR_DEFAULT", 
		Color( 255, 255, 255, 255 )
	)
end


function APP.GetWallpaperMode()
	return launcher_settings.wallpaper_mode or rPhone.GetVariable(
		"LAUNCHER_WALLPAPER_MODE_DEFAULT",
		"color"
	)
end

function APP.GetWallpaperColor()
	return launcher_settings.wallpaper_color or rPhone.GetVariable(
		"LAUNCHER_WALLPAPER_COLOR_DEFAULT",
		Color( 0, 0, 0 )
	)
end

function APP.GetWallpaperURL()
	return launcher_settings.wallpaper_url or rPhone.GetVariable(
		"LAUNCHER_WALLPAPER_URL_DEFAULT",
		""
	)
end

function APP.GetFadeAnimationTime()
	return math.Clamp(
		launcher_settings.fade_len or rPhone.GetVariable( "LAUNCHER_FADE_ANIMATION_LENGTH_DEFAULT", 0.8 ),
		0, 5
	)
end
