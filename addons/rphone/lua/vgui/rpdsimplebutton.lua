
local PANEL = {}

function PANEL:Init()
	self.lc = false
	self.rc = false

	self:SetCursor( "hand" )
end

function PANEL:IsDown()
	return self.lc or self.rc
end

function PANEL:IsLeftDown()
	return self.lc
end

function PANEL:IsRightDown()
	return self.rc
end

function PANEL:OnMousePressed( mc )
	if self.disabled then return end

	if mc == MOUSE_LEFT then
		self.lc = true
		self:MouseCapture( true )
	elseif mc == MOUSE_RIGHT then
		self.rc = true
		self:MouseCapture( true )
	end
end

function PANEL:OnMouseReleased( mc )
	local hovered = self:IsHovered()

	if mc == MOUSE_LEFT then
		self.lc = false
		self:MouseCapture( false )

		if hovered then self:DoClick() end
	elseif mc == MOUSE_RIGHT then
		self.rc = false
		self:MouseCapture( false )

		if hovered then self:DoRightClick() end
	end
end

function PANEL:SetDisabled( disabled )
	self.disabled = disabled
end

function PANEL:GetDisabled()
	return self.disabled == true
end


function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

derma.DefineControl( "RPDSimpleButton", "", PANEL, "DPanel" )
