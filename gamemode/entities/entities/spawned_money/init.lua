AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
    self:SetModel( "models/props/cs_assault/Money.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType(SIMPLE_USE)
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	phys:SetMass( 1 )
	
    self.submoney = false
	self.amount = self.amount or 1
	self.dt.value = self.amount
	self.hasMerged = false
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		Caller:AddCash( self.dt.value )
		--Caller:SendLua("GAMEMODE:AddNotify(\"You have found $" .. tostring(self.dt.value) .. "." .. "\", NOTIFY_GENERIC, 5)")
		self:Remove()
	end
end

function CreateMoneyBag(pos, amount)
	local moneybag = ents.Create("spawned_money")
	moneybag:SetPos(pos)
	moneybag.amount = amount
	moneybag:Spawn()
	moneybag:Activate()
	return moneybag
end

/*
function ENT:Touch(ent)
	if ent:GetClass() ~= "spawned_money" or self.hasMerged or ent.hasMerged then return end

	ent.hasMerged = true

	ent:Remove()
	self.dt.value = (self.dt.value + ent.dt.value)
end
*/