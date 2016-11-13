
local PANEL = {}

AccessorFunc( PANEL, "text", "Text" )
AccessorFunc( PANEL, "spacer", "Spacer", FORCE_NUMBER )
AccessorFunc( PANEL, "padding", "Padding", FORCE_NUMBER )
AccessorFunc( PANEL, "alignment", "Alignment", FORCE_STRING )
AccessorFunc( PANEL, "bgcol", "Color" )
AccessorFunc( PANEL, "brdcol", "BorderColor" )

function PANEL:Init()
    self:SetSpacer( 10 )
    self:SetPadding( 4 )
	self:SetAlignment( "center" )

    self:SetColor( Color( 40, 40, 40, 255 ) )
    self:SetBorderColor( Color( 180, 180, 180, 255 ) )
end

function PANEL:SetSpacer( space )
    self.spacer = space

    self:InvalidateLayout()
end

function PANEL:SetPadding( padding )
    self.padding = padding

    self:InvalidateLayout()
end

function PANEL:SetAlignment( align )
	if align != "left" and align != "right" and align != "center" then return end

	self.alignment = align
end

function PANEL:SetText( str )
	local mw = self:GetWide() - self.spacer - (self.padding * 2)

	self.text = tostring( str )
    self.markup = markup.Parse( self.text, mw )

    if self.markup then
    	self:SetTall( self.markup:GetHeight() + (self.padding * 2) )
    end
end

function PANEL:PerformLayout()
	if self.text then
		self:SetText( self.text )
	end
end

function PANEL:Paint( w, h )
    if !self.markup then return end

    local x = 0
    local xalign = TEXT_ALIGN_LEFT
    local xoff = self.padding

    w = w - self.spacer

    if self.alignment == "right" then
    	x = self.spacer
    elseif self.alignment == "center" then
    	x = (self.spacer / 2)
    	xalign = TEXT_ALIGN_CENTER
        xoff = w / 2
    end

    draw.RoundedBox( 4, x, 0, w, h, self.brdcol )
    draw.RoundedBox( 4, x + 1, 1, w - 2, h - 2, self.bgcol )

	self.markup:Draw( x + xoff, self.padding, xalign, TEXT_ALIGN_TOP, 255 )
end

derma.DefineControl( "RPDAlignedMessage", "", PANEL, "DPanel" )
