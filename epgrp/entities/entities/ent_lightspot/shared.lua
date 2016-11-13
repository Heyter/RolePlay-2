ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Light"
ENT.Author			= "CaMoTraX"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "owning_ent")
end