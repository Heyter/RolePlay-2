surface.CreateFont( "SideButtonsFont", {
	font = "Open Sans Light",
	size = 22,
	weight = 400,
	antialias = true
} )

local PANEL = {}

function PANEL:Init()
	self:EnableHorizontal( false )
	self:EnableVerticalScrollbar( true )
end

function PANEL:Paint()
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 52, 73, 94 ) )
end

function PANEL:AddMenuButton( text, image, panel )

	local Item = {}

	Item.Button = vgui.Create("DButton", self)
	Item.Button:SetHeight( 55 )
	Item.Button:SetText("")
	Item.Button.Target = panel

	Item.Label = vgui.Create("DLabel", Item.Button)
	Item.Label:SetColor(Color(255, 255, 255))
	Item.Label:SetFont("SideButtonsFont")
	Item.Label:SetText( text )
	Item.Label:SizeToContents()
	Item.Label:SetPos( 55, 17)

	Item.Icon = vgui.Create("DImage", Item.Button)
	Item.Icon:SetImage( image )
	Item.Icon:SetPos( 10, 12 )
	Item.Icon:SizeToContents()

	Item.Button.Paint = function( )
		if Item.Button.isHover then
			draw.RoundedBox( 0, 0, 0, Item.Button:GetWide(), Item.Button:GetTall(), Color( 44, 62, 80 ) )
		else
			draw.RoundedBox( 0, 0, 0, Item.Button:GetWide(), Item.Button:GetTall(), Color( 52, 73, 94 ) )
		end
		surface.SetDrawColor( 44, 62, 80 )
		surface.DrawLine( 0, 54, Item.Button:GetWide(), 54 )
	end

	Item.Button.OnCursorEntered = function()
		Item.Button.isHover = true;
	end

	Item.Button.OnCursorExited = function()
		Item.Button.isHover = false;
	end

	Item.Button.DoClick = function()
		self:switchPanel( Item.Button )
		surface.PlaySound("buttons/button15.wav")
	end

	panel:SetVisible( false )

	self:AddItem( Item.Button )
end

function PANEL:AddSwitchButton( text, image, callback )

	local Item = {}

	Item.Button = vgui.Create("DButton", self)
	Item.Button:SetHeight( 55 )
	Item.Button:SetText("")
	Item.Button.Target = panel

	Item.Label = vgui.Create("DLabel", Item.Button)
	Item.Label:SetColor(Color(255, 255, 255))
	Item.Label:SetFont("SideButtonsFont")
	Item.Label:SetText( text )
	Item.Label:SizeToContents()
	Item.Label:SetPos( 55, 17)

	Item.Icon = vgui.Create("DImage", Item.Button)
	Item.Icon:SetImage( image )
	Item.Icon:SetPos( 10, 12 )
	Item.Icon:SizeToContents()

	Item.Button.Paint = function( )
		if Item.Button.isHover then
			draw.RoundedBox( 0, 0, 0, Item.Button:GetWide(), Item.Button:GetTall(), Color( 44, 62, 80 ) )
		else
			draw.RoundedBox( 0, 0, 0, Item.Button:GetWide(), Item.Button:GetTall(), Color( 52, 73, 94 ) )
		end
		surface.SetDrawColor( 44, 62, 80 )
		surface.DrawLine( 0, 54, Item.Button:GetWide(), 54 )
	end

	Item.Button.OnCursorEntered = function()
		Item.Button.isHover = true;
	end

	Item.Button.OnCursorExited = function()
		Item.Button.isHover = false;
	end

	Item.Button.DoClick = function()
		callback()
		surface.PlaySound("buttons/button15.wav")
	end

	self:AddItem( Item.Button )
end

function PANEL:switchPanel( panel )	

	if ( self.active && self.active.Target ) then	
		self.active.Target:SetVisible( false )
	end
	self.active = panel
	self.active.Target:SetVisible( true )

end
derma.DefineControl("DSidemenu", "Sidemenu", PANEL, "DPanelList")