
local PANEL = {}

AccessorFunc( PANEL, "minwidth", 	"MinimumWidth" )
AccessorFunc( PANEL, "maxheight", 		"MaxHeight" )

function PANEL:Init()
	self:SetMinimumWidth( 100 )
	self:SetMaxHeight( ScrH() * 0.9 )
end

function PANEL:AddOption( option, func )
	local pnl = vgui.Create( "RPDMenuOption", self )
		pnl:SetText( option )
		pnl.DoClick = function()
			self:OnOptionSelected( option )
			self:Remove()

			if func then func( option ) end
		end
	
	self:AddItem( pnl )
	
	return pnl
end

function PANEL:AddSpacer( strText, funcFunction )
	local pnl = vgui.Create( "DPanel", self )
		pnl:SetTall( 3 )
		function pnl:Paint( w, h )
			surface.SetDrawColor( 255, 255, 255, 100 )
			surface.DrawRect( 0, 1, w, 1 )
		end

	self:AddItem( pnl )
	
	return pnl
end

function PANEL:Hide()
	self:SetVisible( false )
end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild( num )
	return self:GetCanvas():GetChildren()[num]
end

function PANEL:PerformLayout()
	local w = self:GetMinimumWidth()
	
	for _, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl:PerformLayout()
		w = math.max( w, pnl:GetWide() )
	end

	self:SetWide( w )
	
	local y = 0
	
	for _, pnl in pairs( self:GetCanvas():GetChildren() ) do
		pnl:SetWide( w )
		pnl:SetPos( 0, y )
		pnl:InvalidateLayout( true )
		
		y = y + pnl:GetTall()
	end
	
	y = math.min( y, self:GetMaxHeight() )
	
	self:SetTall( y )

	DScrollPanel.PerformLayout( self )
end

function PANEL:Open( x, y, ownerpanel )
	local parent = self:GetParent()
	local lmx, lmy = 0, 0
	local pw, ph = ScrW(), ScrH()

	if IsValid( parent ) then
		lmx, lmy = parent:ScreenToLocal( gui.MouseX(), gui.MouseY() )
		pw, ph = parent:GetSize()
	end

	self:PerformLayout()

	local w = self:GetWide()
	local h = self:GetTall()
	
	x = x or lmx
	y = y or lmy
	
	if y + h > ph then y = math.max( ph - h, 1 ) end
	if x + w > pw then x = math.max( pw - w, 1 ) end

	self:SetPos( x, y )

	self:MoveToFront()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )

	self:InvalidateLayout( true )
end

function PANEL:Think()
	if self.removing or 
		(!input.IsMouseDown( MOUSE_LEFT ) and 
			!input.IsMouseDown( MOUSE_RIGHT ) and 
				!input.IsMouseDown( MOUSE_MIDDLE )) then
		return
	end

	local pnl = vgui.GetHoveredPanel()
	local descendent = false

	while pnl do
		if pnl == self then
			descendent = true
			break
		end
		
		pnl = pnl:GetParent()
	end

	if !descendent then
		timer.Simple( 0.2, function()
			if IsValid( self ) then self:Remove() end
		end )

		self.removing = true
	end
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, w, h )
end


function PANEL:OnOptionSelected( option )
end

function PANEL:OnDeselected()
end

derma.DefineControl( "RPDMenu", "", PANEL, "DScrollPanel" )
