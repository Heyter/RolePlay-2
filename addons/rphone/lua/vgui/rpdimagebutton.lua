
local PANEL = {}

AccessorFunc( PANEL, "matstr", "Image" )
AccessorFunc( PANEL, "padding", "Padding" )
AccessorFunc( PANEL, "rot", "Rotation" )

function PANEL:Init()
	self:SetPadding( 2 )
	self:SetRotation( 0 )
end

function PANEL:SetImage( mat )
	self.matstr = mat

	self.mat = Material( mat, "smooth" )
end

function PANEL:Paint( w, h )
	if !self.mat or self.mat:IsError() then return end

	local col = self.bgcol
	local pad = self.padding

	if self:GetDisabled() then
		col = self.bgcol_dis
	elseif self.lc or self.rc then
		col = self.bgcol_dep
	elseif self:IsHovered() then
		col = self.bgcol_hov
	end

	surface.SetDrawColor( col )
	surface.SetMaterial( self.mat )
	surface.DrawTexturedRectRotated( w/2, h/2, w - (pad * 2), h - (pad * 2), self.rot )
end

derma.DefineControl( "RPDImageButton", "", PANEL, "RPDContentButton" )
