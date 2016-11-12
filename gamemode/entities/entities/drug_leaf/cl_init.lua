include("shared.lua")

function ENT:Draw()
	local GrowthPercent = self.dt.status / 120

	if GrowthPercent <= 1 then
		local scale = Vector(GrowthPercent, GrowthPercent, GrowthPercent)
		local mat = Matrix()
		mat:Scale(scale)
		self:EnableMatrix("RenderMultiply", mat)
	end
	
	--if (LocalPlayer():EyePos():RPIsInSight({LocalPlayer(), self})) then
		self:DrawModel();
	--end
end