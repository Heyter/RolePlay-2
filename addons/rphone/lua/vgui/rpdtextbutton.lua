
local PANEL = {}

AccessorFunc( PANEL, "bgcol", "Color" )
AccessorFunc( PANEL, "bgcol_hov", "HoveredColor" )
AccessorFunc( PANEL, "bgcol_dep", "DepressedColor" )
AccessorFunc( PANEL, "bgcol_dis", "DisabledColor" )
AccessorFunc( PANEL, "toggleable", "Toggleable" )
AccessorFunc( PANEL, "toggled", "Toggled" )
AccessorFunc( PANEL, "tog_bgcol", "ToggledColor" )
AccessorFunc( PANEL, "untog_bgcol", "UntoggledColor" )

function PANEL:Init()
	self:SetToggleable( false )
	self:SetToggled( false )

	self:SetColor( Color( 50, 50, 50, 255 ) )
	self:SetHoveredColor( Color( 80, 80, 80, 255 ) )
	self:SetDepressedColor( Color( 70, 70, 70, 255 ) )
	self:SetDisabledColor( Color( 30, 30, 30, 255 ) )

	self:SetTextColor( Color( 255, 255, 255, 255 ) )

	self:SetToggledColor( self:GetColor() )
	self:SetUntoggledColor( self:GetDisabledColor() )
end

function PANEL:Paint( w, h )
	local col
	
	if self:GetToggleable() then
		if self.toggled then
			col = self:GetToggledColor()
		else
			col = self:GetUntoggledColor()
		end
	else
		col = self.bgcol

		if self:GetDisabled() then
			col = self.bgcol_dis
		elseif self:IsDown() then
			col = self.bgcol_dep
		elseif self:IsHovered() then
			col = self.bgcol_hov
		end
	end

	surface.SetDrawColor( col )
	surface.DrawRect( 0, 0, w, h )

	return false
end


function PANEL:OnToggled( toggled )
end

function PANEL:DoClick()
	if self:GetToggleable() and !self:GetDisabled() then
		self:SetToggled( !self:GetToggled() )
		self:OnToggled( self:GetToggled() )
	end
end

derma.DefineControl( "RPDTextButton", "", PANEL, "DButton" )
