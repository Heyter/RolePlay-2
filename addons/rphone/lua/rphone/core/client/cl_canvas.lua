
local canv_instances = rPhone.NewWeakTable( 'k' )

local CANV = {}
CANV.__index = CANV

function CANV:CreateBasePanel()
	local inst = canv_instances[self]

	if !inst then return end

	local pnl = rPhone.CreatePanel( "EditablePanel" )
		pnl:SetSize( inst.width, inst.height )
		pnl:SetPos( inst.x, inst.y )
		pnl:SetVisible( inst.visible )
		pnl.SetSize = function() end
		pnl.Paint = function( _, w, h )
			self:Draw( w, h )
		end
		
	if inst.parent then
		local pbpnl = inst.parent:GetBasePanel()
		
		if IsValid( pbpnl ) then
			pnl:SetParent( pbpnl )
		end
	end

	inst.bpanel = pnl
end

function CANV:DestroyBasePanel()
	local bpnl = self:GetBasePanel()
	
	if IsValid( bpnl ) then
		bpnl:Remove()
	end
end

function CANV:Clear()
	self:DestroyBasePanel()
	self:CreateBasePanel()
end

function CANV:Dispose()
	self:DestroyBasePanel()
end

function CANV:SetPos( x, y )
	local inst = canv_instances[self]

	if !inst then return end

	inst.x = x
	inst.y = y
	
	local bpnl = self:GetBasePanel()
	
	if IsValid( bpnl ) then
		bpnl:SetPos( x, y )
	end
end

function CANV:GetBasePanel()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.bpanel
end

function CANV:GetParent()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.parent
end

function CANV:AddPanel( ptype )
	local bpnl = self:GetBasePanel()
	
	if IsValid( bpnl ) then
		return rPhone.CreatePanel( ptype, bpnl )
	end
end

function CANV:GetWidth()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.width
end
CANV.GetWide = CANV.GetWidth

function CANV:GetHeight()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.height
end
CANV.GetTall = CANV.GetHeight

function CANV:GetSize()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.width, inst.height
end

function CANV:GetPos()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.x, inst.y
end

function CANV:SetVisible( vis )
	local inst = canv_instances[self]

	if !inst then return end

	local bpnl = inst.bpanel
	
	if IsValid( bpnl ) then
		bpnl:SetVisible( vis )
	end

	inst.visible = vis
end

function CANV:GetVisible()
	local inst = canv_instances[self]

	if !inst then return end

	return inst.visible
end


function CANV:Draw( w, h )
end



function rPhone.CreateCanvas( x, y, w, h, parent )
	local inst = {}
	local data = {
		x = x, y = y,
		width = w, height = h,
		visible = true,
		parent = parent
	}

	canv_instances[inst] = data
	
	local canv = setmetatable( inst, CANV )
	
	canv:CreateBasePanel()
	
	return canv
end
