
local PANEL = {}

AccessorFunc( PANEL, "padding", "Padding" )
AccessorFunc( PANEL, "rowpadding", "RowPadding" )
AccessorFunc( PANEL, "spacing", "Spacing" )

function PANEL:Init()
	self:SetPadding( 5 )
	self:SetRowPadding( 5 )
	self:SetSpacing( 5 )
	
	self.rows = {}
end

function PANEL:SetPadding( pad )
	self.padding = pad

	self:InvalidateLayout()
end

function PANEL:SetRowPadding( rpad )
	self.rowpadding = rpad

	self:InvalidateLayout()
end

function PANEL:SetSpacing( spc )
	self.spacing = spc

	self:InvalidateLayout()
end

function PANEL:AddRow( ... )
	local row = { ... }

	for _, item in pairs( row ) do
		self:AddItem( item )
	end

	table.insert( self.rows, row )

	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	local cmaxw = {}
	local rmaxh = {}

	for i, row in ipairs( self.rows ) do
		local maxh = 0

		for j, item in ipairs( row ) do
			if !IsValid( item ) then continue end

			maxh = math.max( maxh, item:GetTall() )
			cmaxw[j] = math.max( cmaxw[j] or 0, item:GetWide() )
		end

		rmaxh[i] = maxh
	end

	local ys = self:GetPadding()

	for i, row in ipairs( self.rows ) do
		local xs = self:GetPadding()
		local maxh = rmaxh[i] or 0

		for j, item in ipairs( row ) do
			if !IsValid( item ) then continue end

			item:SetPos( xs, ys + ((maxh - item:GetTall()) / 2) )

			xs = xs + (cmaxw[j] or 0) + self.rowpadding
		end

		ys = ys + self:GetSpacing() + maxh
	end

	DScrollPanel.PerformLayout( self )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, w, h )
end

derma.DefineControl( "RPDAlignedControlList", "", PANEL, "DScrollPanel" )
