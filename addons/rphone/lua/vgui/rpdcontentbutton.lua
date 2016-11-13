
local PANEL = {}

AccessorFunc( PANEL, "disabled", "Disabled" )
AccessorFunc( PANEL, "bgcol", "Color" )
AccessorFunc( PANEL, "bgcol_hov", "HoveredColor" )
AccessorFunc( PANEL, "bgcol_dep", "DepressedColor" )
AccessorFunc( PANEL, "bgcol_dis", "DisabledColor" )

function PANEL:Init()
	self:SetTall( 20 )

	self:SetColor( Color( 50, 50, 50 ) )
	self:SetHoveredColor( Color( 80, 80, 80 ) )
	self:SetDepressedColor( Color( 70, 70, 70 ) )
	self:SetDisabledColor( Color( 30, 30, 30 ) )

	self.overlay = vgui.Create( "RPDSimpleButton", self )
		self.overlay:SetSize( self:GetSize() )
		self.overlay.Paint = nil
		function self.overlay.DoClick()
			self:DoClick()
		end
		function self.overlay.DoRightClick()
			self:DoRightClick()
		end
end

function PANEL:IsHovered()
	return IsValid( self.overlay ) and self.overlay:IsHovered()
end

function PANEL:IsDown()
	return IsValid( self.overlay ) and self.overlay:IsDown()
end

function PANEL:OnChildAdded( child )
	if IsValid( self.overlay ) then
		self.overlay:MoveToFront()
	end
end

function PANEL:PerformLayout()
	if IsValid( self.overlay ) then
		self.overlay:SetSize( self:GetSize() )
	end
end

function PANEL:SetDisabled( disabled )
	if IsValid( self.overlay ) then
		self.overlay:SetDisabled( disabled )
	end
end

function PANEL:GetDisabled()
	return !IsValid( self.overlay ) or self.overlay:GetDisabled()
end

function PANEL:Paint( w, h )
	local col = self.bgcol

	if self:GetDisabled() then
		col = self.bgcol_dis
	elseif self.lc or self.rc then
		col = self.bgcol_dep
	elseif self:IsHovered() then
		col = self.bgcol_hov
	end

	surface.SetDrawColor( col )
	surface.DrawRect( 0, 0, w, h )
end


function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

derma.DefineControl( "RPDContentButton", "", PANEL, "DPanel" )
