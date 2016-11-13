
local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment( 4 )
	self:SetTextInset( 15, 0 )
	self:SetTextColor( Color( 255, 255, 255 ) )
	self:SetFont( "DermaDefaultBold" )
	self:SetCursor( "hand" )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 80, 80, 80, 255 )
	surface.DrawOutlinedRect( 0, 0, w, h )

	if self:IsHovered() then
		local h2 = h / 2
		local h3 = h / 4

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawLine( 1, h3, 8, h2 )
		surface.DrawLine( 1, h-h3, 8, h2 )
	end
end

function PANEL:PerformLayout()
	self:SizeToContents()
	self:SetWide( self:GetWide() + 20 )
	
	local w = math.max( self:GetParent():GetWide(), self:GetWide() )

	self:SetSize( w, 22 )
	
	DButton.PerformLayout( self )
end

derma.DefineControl( "RPDMenuOption", "", PANEL, "RPDTextButton" )
