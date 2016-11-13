
surface.CreateFont( "rpdcategorylist_categoryheader", {
	font = "Trebuchet18",
	size = 20,
} )

local PANEL = {}

AccessorFunc( PANEL, "catfont", "CategoryFont" )

function PANEL:Init()
	self:EnableVerticalScrollbar( true )
	self:SetPadding( 0 )
	self:SetSpacing( 5 )

	self:SetCategoryFont( "rpdcategorylist_categoryheader" )
end

function PANEL:AddCategory( cat )
	local lblcat = rPhone.CreatePanel( "DLabel" )
		lblcat:SetFont( self.catfont )
		lblcat:SetText( cat )
		lblcat:SizeToContents()

	self:AddItem( lblcat )
end

function PANEL:Paint()
end

derma.DefineControl( "RPDCategoryList", "", PANEL, "DPanelList" )
