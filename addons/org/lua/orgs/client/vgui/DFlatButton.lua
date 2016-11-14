surface.CreateFont( "FlatButtonsFont", {
	font = "Open Sans",
	size = 20,
	weight = 400,
	antialias = true
} )

local PANEL = {}

function PANEL:Init()
	self:SetSize( 180, 40 )
	self:SetColor( Color( 255, 255, 255) )
	self:SetFont("FlatButtonsFont")
end

function PANEL:Paint()
	if self.isHover then
		if self.State then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 39, 174, 96 ) )
		else
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 192, 57, 43 ) )
		end
		if self.State == nil then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 41, 128, 185 ) )
		end
	else
		if self.State then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 46, 204, 113 ) )
		else
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 231, 76, 60 ) )
		end
		if self.State == nil then
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 52, 152, 219 ) )
		end
	end
end

function PANEL:OnCursorEntered()
	self.isHover = true
end
function PANEL:OnCursorExited()
	self.isHover = false
end
function PANEL:SetState( state )
	self.State = state
end
derma.DefineControl("DFlatButton", "Custom Button", PANEL, "DButton")