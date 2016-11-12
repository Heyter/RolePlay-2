AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/BriefCase001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end
	--self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
end


function ENT:Use(activator,caller)
	if IsValid( GetMayor() ) && activator == GetMayor() then
		ECONOMY.AddCityCash(self.CashValue)
		self:Remove()
        GetMayor():SetSkill( "Ruf", GetMayor():GetSkill( "Ruf" ) + 0.01 )
        GetMayor():SetSkill( "Management", GetMayor():GetSkill( "Management" ) + 0.05 )
		return
	elseif activator:Team() == TEAM_CITIZEN then
		activator:AddCash(self.CashValue or 0)
		activator:RPNotify("Du hast Geld von der Stadt geklaut! Du bekommst: " .. (self.CashValue or 0) .. "$ !", 5)
		self:Remove()
        activator:SetSkill( "Ruf", activator:GetSkill( "Ruf" ) - 0.06 )
        GetMayor():SetSkill( "Management", GetMayor():GetSkill( "Management" ) - 0.05 )
        if IsValid( GetMayor() ) then GetMayor():RPNotify("Etwas Geld vom StadtPrinter wurde gestohlen!", 5) end
		return
	else
		return
	end
end
