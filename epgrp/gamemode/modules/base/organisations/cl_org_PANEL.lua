/*---------------------------------------------------------
   Name: DrawOrgElements()
   Desc: Alle HUDfunktionen sollten hier untereinander aufgelistet werden.
---------------------------------------------------------*/

function OpenURLImporter( webframe )
	local orgdata = LocalPlayer():GetOrganisation()
	if orgdata == nil then return end
	
	local urlframe = vgui.Create( "DFrame" )
	urlframe:SetSize( 450, 150 )
	urlframe:SetTitle( "Lade ein Bild hoch" )
	urlframe:Center()
	urlframe:MakePopup()

	local closer = vgui.Create( "DButton", urlframe )
	closer:SetSize( 24, 24 )
	closer:SetPos( urlframe:GetWide() - 80, 0 )
	closer:SetText( "X" )
	closer.DoClick = function() urlframe:Close() end
	closer.Paint = function() end

	local url = vgui.Create( "DTextEntry", urlframe )
	url:SetPos( 20, urlframe:GetTall()/2 - 15 )
	url:SetSize( urlframe:GetWide() - 40, 30 )
	url:SetText( "Bitte gebe den URL-Pfad an" )
	url:SetFont( "Trebuchet21" )
	
	local opener = vgui.Create("HTML", IPanel)
	opener:SetPos( 0, 0 )
	opener:SetSize( 0, 0 )
	
	urlframe:DEX_CreateSpecialButton( 0, urlframe:GetTall() - 30, urlframe:GetWide(), 30, "Bild Hochladen", Color( 51, 153, 204, 255 ), function()
		opener:OpenURL("http://server.gmod-networks.net/camo/create.php?link=" .. tostring( url:GetValue() ) .. "&group=" .. tostring(orgdata.id) .. "")
		urlframe:Close()
		timer.Simple( 5, function() webframe:OpenURL( "http://server.gmod-networks.net/camo/" .. tostring(orgdata.id) .. ".jpg" ) end )
	end)
end

function OpenOrgPanel()
	local orgdata = LocalPlayer():GetOrganisation()
	
	if orgdata == nil then
		OpenOrgBrowser()
		return
	end

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 720, 360 )
	frame:SetTitle( "Organisation" )
	frame:Center()
	frame:MakePopup()

	local closer = vgui.Create( "DButton", frame )
	closer:SetSize( 24, 24 )
	closer:SetPos( frame:GetWide() - 80, 0 )
	closer:SetText( "X" )
	closer.DoClick = function() frame:Close() end
	closer.Paint = function() end

	local PS = vgui.Create( "DPropertySheet", frame )
	PS:SetPos( 4, 35 )
	PS:SetSize( frame:GetWide() - 8, frame:GetTall() - 38 )

	---------------------------
	--  Information Panel    --
	---------------------------

	local IPanel = vgui.Create( "DPanel" )
	IPanel.Paint = function()
		draw.RoundedBox( 0, 0, 0, IPanel:GetWide(), IPanel:GetTall(), Color( 0, 0, 0, 100 ) )
		draw.SimpleText( "- " .. orgdata.name .. " -", "Trebuchet25", 148, 12, HUD_SKIN.LIST_BG_SECOND )
		draw.SimpleText( "Mitglieder:", "Trebuchet23", 148, 50, HUD_SKIN.LIST_BG_SECOND )
		draw.SimpleText( tostring(#orgdata.member), "Trebuchet23", 255, 50, Color( 51, 153, 204, 255 ) )
		draw.SimpleText( "Level:", "Trebuchet23", 148, 90, HUD_SKIN.LIST_BG_SECOND )
		draw.SimpleText( tostring(orgdata.level), "Trebuchet23", 208, 90, Color( 51, 153, 204, 255 ) )
		draw.SimpleText( "Erfahrung:", "Trebuchet23", 148, 115, HUD_SKIN.LIST_BG_SECOND )
		draw.SimpleText( tostring(orgdata.exp) .. " / 128.000", "Trebuchet23", 252, 115, Color( 51, 153, 204, 255 ) )
		
		draw.SimpleText( "News:", "Trebuchet25", 10, IPanel:GetTall()/1.55, HUD_SKIN.LIST_BG_SECOND )
		draw.SimpleText( "Dies sind Randomnews, diese koennen jederzeit geÃ¤ndert werden.", "Trebuchet21", 10, IPanel:GetTall()/1.35, HUD_SKIN.LIST_BG_SECOND )
	end

	local Icon = vgui.Create("HTML", IPanel)
	Icon:SetPos( 10, 10 )
	Icon:SetSize( 128, 128 )
	Icon:OpenURL("http://server.gmod-networks.net/camo/" .. tostring(orgdata.id) .. ".jpg")
	
	IPanel:DEX_CreateSpecialButton( 10, 142.5, Icon:GetWide(), 30, "Bild Hochladen", Color( 51, 51, 51, 255 ), function()
		OpenURLImporter( Icon )
	end)


	PS:AddSheet( "Informationen", IPanel, "icon16/information.png", false, false )

	---------------------------
	-- Benutzergruppen Panel --
	---------------------------

	local BGPanel = vgui.Create( "DPanel" )
	BGPanel.Paint = function() 
		draw.RoundedBox( 0, 0, 0, BGPanel:GetWide(), BGPanel:GetTall(), Color( 0, 0, 0, 100 ) )
	end
	
	local bglist = vgui.Create( "DPanelList", BGPanel )
	bglist:SetPos( 5, 5 )
	bglist:SetSize( PS:GetWide() - 35, PS:GetTall()- 35 )
	bglist:SetSpacing( 2 )
	bglist:EnableHorizontal( false ) -- Only vertical items
	bglist:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
	for gruppenindex, gruppe in ipairs( orgdata.member ) do
		local mframe = vgui.Create( "DPanel" )
		mframe:SetSize( bglist:GetWide(), 30 )
		mframe:SetPos( 0, 0 )
		mframe.Paint = function()
			draw.RoundedBox( 4, 0, 0, mframe:GetWide(), mframe:GetTall(), Color( 0, 0, 0, 150 ) )
			draw.SimpleText( gruppe.name, "Trebuchet21", 4, 4, Color( 51, 153, 204, 255 ) )
		end
		bglist:AddItem( mframe )
		for k, v in pairs( gruppe.member ) do
			local mframe = vgui.Create( "DPanel" )
			mframe:SetSize( bglist:GetWide(), 30 )
			mframe:SetPos( 0, 0 )
			mframe.Paint = function()
				draw.RoundedBox( 4, 0, 0, mframe:GetWide(), mframe:GetTall(), Color( 0, 0, 0, 150 ) )
				draw.SimpleText( v.name, "Trebuchet21", 4, 4, HUD_SKIN.LIST_BG_FIRST )
			end
			bglist:AddItem( mframe )
		end
	end

	PS:AddSheet( "Benutzergruppen Verwalten", BGPanel, "icon16/wrench.png", 
	false, false )

	---------------------------
	-- Mitglieder Verwaltung --
	---------------------------

	local MPanel = vgui.Create( "DPanel" )
	MPanel.Paint = function() 
		draw.RoundedBox( 0, 0, 0, MPanel:GetWide(), MPanel:GetTall(), Color( 0, 0, 0, 100 ) )
	end

	PS:AddSheet( "Mitglieder Verwalten", MPanel, "icon16/user.png", false, false )

	---------------------------
	--  Organisations Shop   --
	---------------------------

	local ShopPanel = vgui.Create( "DPanel" )
	ShopPanel.Paint = function() 
		draw.RoundedBox( 0, 0, 0, ShopPanel:GetWide(), ShopPanel:GetTall(), Color( 0, 0, 0, 100 ) )
	end

	PS:AddSheet( "Shop", ShopPanel, "icon16/money.png", false, false )
end
concommand.Add( "ShowOrganisation", OpenOrgPanel )

function OpenOrgBrowser()

end