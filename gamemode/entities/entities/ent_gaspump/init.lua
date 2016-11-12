AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel("models/props_wasteland/gaspump001a.mdl")
	self.Entity:SetColor(Color(255, 255, 255, 255))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)


	self.Faucet = ents.Create("ent_gaspump_faucet")
	self.Faucet:SetPos(self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45)))
	self.Faucet:SetAngles(Angle(0, 0, 90) + self.Entity:GetAngles())
	self.Faucet:Spawn()
	self.Faucet:Activate()
	self.Faucet.Parent = self
	
	self.LastPayment = CurTime() + 1
	
	self.Faucet:GetPhysicsObject():Sleep()

	constraint.Rope(self.Entity, self.Faucet, 0, 0, Vector(0,-18,56), Vector(0,-7,0), 125, 0, 0, 3, "cable/cable2")
end


function ENT:PhysicsCollide( data, phys ) 
	local ent = data.HitEntity
    self.fauced_collide = self.fauced_collide or CurTime() -1
    if CurTime() < self.fauced_collide then return end
    self.fauced_collide = CurTime() + 2
	if ent == self.Faucet then
		self.Faucet:SetPos(self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45)))
		self.Faucet:SetAngles(Angle(0, 0, 90) + self.Entity:GetAngles())

		self.Faucet:Freeze()
	end
end


function ENT:DoPayment( ply )
	if CurTime() < self.LastPayment then return end
	self.LastPayment = CurTime() + 1
	local kosten = ECONOMY.GASPREIS * self.dt.tanked_liters
	kosten = math.Round( kosten )
	if !(ply:CanAfford( kosten )) then self.LastPayment = CurTime() + 1 return end
	
	if kosten > 0 then
        ply:AddCash( -kosten )
		ECONOMY.AddCityCash( kosten )
        ECONOMY.AddToLog( "+" .. kosten .. ",-EUR für " .. self.dt.tanked_liters .. " Liter Benzin." )
		
		self.dt.tanked_liters = 0
	end
	
	constraint.RemoveConstraints( self.Faucet, "Weld" )
	self.Faucet.Vehicle = nil
	self.Faucet.dt.vehicle = nil
	
	self.Faucet.NextTouch = CurTime() + 1
	
	self:EmitSound("/buttons/button6.wav", 75, 100)
	
	timer.Simple(0.5, function()
		self.Faucet:SetPos(self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45)))
		self.Faucet:SetAngles(Angle(0, 0, 90) + self.Entity:GetAngles())

		self.Faucet:Freeze()
	end)
	
end

function ENT:Use( ply )
	if self.Faucet.Vehicle != nil then self:DoPayment( ply ) return end
	if !(CurTime() > self.LastPayment) then return end
	self.LastPayment = CurTime() + 2
	
	if self.Faucet.stored then return end
	
	self.Faucet:SetPos(self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45)))
	self.Faucet:SetAngles(Angle(0, 0, 90) + self.Entity:GetAngles())

	self.Faucet:Freeze()
end

--If the gas pump is removed it will also remove the pipefaucet.
function ENT:OnRemove()
	if self.Faucet:IsValid() then
		self.Faucet:Remove()
	end
end

function ENT:Think()

	if self.Faucet:GetPos():Distance(self:GetPos()) > 250 then
		self.Faucet:EmitSound("/buttons/button19.wav", 75, 100)
		self.Faucet:SetPos(self.Entity:GetPos()+((self.Entity:GetRight()*20)+(self.Entity:GetUp()*45)))
		self.Faucet:SetAngles(Angle(0, 0, 90) + self.Entity:GetAngles())

		self.Faucet:Freeze()
	end
	
	local money = ents.FindInSphere( self:GetPos() + Vector( 0, 0, 50 ), 25 )
	for k, v in pairs( money or {} ) do
		if !(IsValid( v )) then continue end
		if !(v:GetClass() == "spawned_money") then continue end
		if (CurTime() < self.LastPayment) then return end
		self.LastPayment = CurTime() + 1
		
		self.dt.credits = self.dt.credits + (v.dt.value or 0)
		v:Remove()
	end
	
end
