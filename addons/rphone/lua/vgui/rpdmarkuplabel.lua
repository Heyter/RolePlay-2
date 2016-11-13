
local PANEL = {}

AccessorFunc( PANEL, "padding", "Padding", FORCE_NUMBER )
AccessorFunc( PANEL, "bgcol", "BackgroundColor" )

function PANEL:Init()
    self:SetPadding( 0 )
    self:SetBackgroundColor( Color( 0, 0, 0, 245 ) )
end

function PANEL:SetPadding( padding )
    self.padding = padding

    self:InvalidateLayout()
end

function PANEL:SetText( str )
	local mw = self:GetWide() - (self.padding * 2)

	self.text = tostring( str )
    self.markup = markup.Parse( self.text, mw )

    if self.markup then
    	self:SetTall( self.markup:GetHeight() + (self.padding * 2) )
    end
end

function PANEL:SizeToContents()
    if self.text then
        self:SetText( self.text )
    end
end

function PANEL:PerformLayout()
	self:SizeToContents()
end

function PANEL:Paint( w, h )
    if !self.markup then return end

    surface.SetDrawColor( self.bgcol )
    surface.DrawRect( 0, 0, w, h )

    self.markup:Draw( self.padding, self.padding, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 255 )
end

derma.DefineControl( "RPDMarkupLabel", "", PANEL, "DPanel" )
