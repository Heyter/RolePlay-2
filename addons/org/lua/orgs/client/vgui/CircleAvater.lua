local PANEL = {}

function PANEL:Init()
	self.AvatarImage = vgui.Create( "AvatarImage", self )
	self.AvatarImage:SetPaintedManually( true )
end

function PANEL:PerformLayout()
	self.AvatarImage:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer( pl )
	self.AvatarImage:SetPlayer( pl, self:GetWide() )
end

function PANEL:Paint(w, h)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
	render.SetStencilReferenceValue( 1 )

	local _m = 23
	local circle = {
	}

	surface.SetDrawColor(Color(225, 0, 0))
	for a = 1, 3 do
		for i = 0, 360, a do
			local _i = i * math.pi/180;
			local t = { x = math.cos(_i)*(_m)+w/2.1, y = math.sin(_i)*(_m)+h/2 }

			table.insert(circle, t)
		end
	end
	draw.NoTexture()
	surface.DrawPoly(circle)

	render.SetStencilFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilReferenceValue( 1 )

	self.AvatarImage:SetPaintedManually(false)
	self.AvatarImage:PaintManual()
	self.AvatarImage:SetPaintedManually(true)

	render.SetStencilEnable(false)
	render.ClearStencil()
end
vgui.Register("CircleAvater", PANEL)