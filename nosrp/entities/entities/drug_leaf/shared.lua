ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Weapon"
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int",1,"status")
end