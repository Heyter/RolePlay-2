
local OS = rPhone.AssertPackage( "os" )
local Util = OS.Util

local PM = {}
PM.__index = PM

function PM:NewPage( trns, name )
	local pnl = self.canv:AddPanel()
		pnl:SetSize( self.canv:GetSize() )
		pnl:SetZPos( #self.pages )
		pnl.Paint = nil

	local pinfo = {
		transparent = trns,
		panel = pnl,
		name = name
	}

	table.insert( self.pages, pinfo )

	self:UpdateVisibility()

	return pnl
end

function PM:GoBack()
	local pinfo = self.pages[#self.pages]

	if !pinfo then return end

	if IsValid( pinfo.panel ) then
		pinfo.panel:Remove()
	end

	table.remove( self.pages )

	self:UpdateVisibility()
end

function PM:UpdateVisibility()
	local hideprev = false

	for i=#self.pages, 1, -1 do
		local pinfo = self.pages[i]
		local pnl = pinfo.panel

		if IsValid( pnl ) then 
			pnl:SetVisible( !hideprev )
		end

		if !hideprev and !pinfo.transparent then
			hideprev = true
		end
	end
end

function PM:GetCurrentPage()
	local pinfo = self.pages[#self.pages]

	if pinfo then return pinfo.panel end
end

function PM:GetCurrentPageName()
	local pinfo = self.pages[#self.pages]

	if pinfo then return pinfo.name end
end

function PM:GetPreviousPage()
	local pinfo = self.pages[#self.pages - 1]

	if pinfo then return pinfo.panel end
end

function PM:GetPreviousPageName()
	local pinfo = self.pages[#self.pages - 1]

	if pinfo then return pinfo.name end
end

function PM:SimplePopup( blur, name )
	local page = self:NewPage( true )

	if blur then
		function page:Paint( w, h )
			surface.SetDrawColor( 0, 0, 0, 245 )
			surface.DrawRect( 0, 0, w, h )
		end
	end

	local pnl = rPhone.CreatePanel( "DPanel", page )
		function pnl:Paint( w, h )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
		function pnl:PerformLayout()
			self:SetPos( 
				(page:GetWide() - self:GetWide()) / 2,
				(page:GetTall() - self:GetTall()) / 2
			)
		end
		pnl:InvalidateLayout( true )

	return pnl
end



function Util.CreatePageManager( canv )
	return setmetatable( {
		canv = canv,
		pages = {}
	}, PM )
end
