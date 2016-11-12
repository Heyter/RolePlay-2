if (SERVER) then
	AddCSLuaFile("cl_init.lua")
	AddCSLuaFile("shared.lua")
end

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/garbage_glassbottle003a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:Ignite(10,0)
	timer.Simple(10, function()
		if self:IsValid() then
			self:Remove()
		end
	end )
end

function ENT:Think()
	if self.Entity:WaterLevel() > 0 then
		self.Entity:Extinguish()
	end
end

function ENT:OnRemove()
	if self.Entity:WaterLevel() > 0 then return end
	
	local expl = ents.Create("env_explosion")
		expl:SetPos(self.Entity:GetPos())
		expl:Spawn()
		expl:SetKeyValue("iMagnitude", "100")
		expl:Fire("Explode", 0, 0)
		expl:EmitSound("BaseGrenade.Explode", 300, 300)
		
	for i=1,3 do
		local explfire = ents.Create("ent_fire")
		explfire:SetPos(self.Entity:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 0))
		explfire:Spawn()
	end	
	
	for _, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 100)) do
		if v:IsPlayer() then return end
		v:Ignite(60,100)
	end
	
end

function ENT:PhysicsCollide(tbl, obj)
	self.Entity:EmitSound("physics/glass/glass_largesheet_break" ..math.random(1,3).. ".wav", 50, math.random(80,120))
	self.Entity:Remove()
end