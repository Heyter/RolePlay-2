surface.CreateFont( "TitlesFont", {
	font = "Roboto Th",
	size = 36,
	weight = 400,
	antialias = true
} )

local PANEL = {}

function PANEL:Init()
	self:SetPos( 200, 28 )
	self:SetSize( 500, 380 )
end

function PANEL:Paint()
	draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color(226,226,226) )
end

function PANEL:Title( text )
	self.Title = vgui.Create("DLabel", self)
	self.Title:SetText( text )
	self.Title:SetFont( "TitlesFont" )
	self.Title:SetPos( 8, 2 )
	self.Title:SizeToContents()
	self.Title:SetColor(Color(52, 73, 94))
end
derma.DefineControl("DCustomPanel", "Custom Panel", PANEL, "DPanel")