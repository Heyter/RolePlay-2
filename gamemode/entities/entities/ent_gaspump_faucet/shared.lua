
ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"vehicle")
end