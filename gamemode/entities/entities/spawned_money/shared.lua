ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Spawned Money"
ENT.Author = "CaMoTraX"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "value")
	self:DTVar("Entity", 1, "owning_ent")
end