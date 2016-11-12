AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()

	self.damage = 50
	self.onstove = false
	self.smoke = false
	self.cooktime = 0
	self.stove = {}
	self.ct = 0
	
	// Settings
	self.needcooktime = 600 // How long player's need to cook the meth ( seconds )
	self.rewardprice = 1750 // How much player's gain when meth is done + 35% of the cooktime
	self.dierange = 200 // Ignites & kills all player's in this range when the meth explodes
	self.maxmeth = 3 // How much meth a player can plant
	self.explodechance = 3 // How much chance the meth has to explode on start ( in % )
	self.chancetime = 60 // Adds explodechance each 60 seconds!
	self.addchance = 3 // How much explodechance will be added after 60 seconds ( set above )
	// Explode time of or above 27% causes explosion of the meth very often!
	///////////
	
	self.dt.owning_ent.plantedmeth = self.dt.owning_ent.plantedmeth or 0
end

function ENT:OnRemove()
	if self.onstove then
		--self.dt.owning_ent.plantedmeth = math.Clamp( self.dt.owning_ent.plantedmeth - 1, 0, self.maxmeth )
	end
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end

function ENT:Use(activator,caller)
	local ply = activator
	if IsValid( ply )  && self.cooktime >= self.needcooktime then
		ply:AddMoney( self.rewardprice + self.cooktime*0.35)
		self:Remove()
	end
end

function ENT:AddExplodeChance( chance )
	self.explodechance = math.Clamp( self.explodechance + chance, 0, 100 )
	self:DoExplodeCalc()
end

function ENT:DoExplodeCalc()
	local crit = math.Rand( 0, 100 )
	if crit < self.explodechance then
		self:Explode()
	end
end

function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(5)
	util.Effect("Explosion", effectdata)
	
	local fents = ents.FindInSphere( self:GetPos(), self.dierange ) 
	
	for k, v in pairs(fents) do
		if IsValid( v ) then
			v:Ignite( 120 )
		end
	end
	
	self:Remove()
	self.stove:Remove()
	
	--self.dt.owning_ent.plantedmeth = math.Clamp( self.dt.owning_ent.plantedmeth - 1, 0, self.maxmeth )
	
	for k, v in pairs(player.GetAll()) do // Kill all players they're near 300 units of the meth!
		if v:GetPos():Distance(self:GetPos()) <= self.dierange then
			v:Kill()
		end
	end
end

function ENT:Think()

	local tracedata = {}
    tracedata.start = self:EyePos()
    tracedata.endpos = self:GetPos() - (self:GetUp()*8)
    tracedata.filter = {self}
    local trace = util.TraceLine(tracedata)
	
	local ent = trace.Entity
	
	if IsValid( ent ) && ent:GetClass() == "drug_meth_stove" then
		if !(self.onstove) then
			--if self.dt.owning_ent.plantedmeth >= self.maxmeth then return end
			
			--self.dt.owning_ent.plantedmeth = math.Clamp( self.dt.owning_ent.plantedmeth + 1, 0, self.maxmeth )
		end
		self.onstove = true
		self.stove = ent
		self:SetColor(Color(0, 255, 0, 255) )
	else
		self.onstove = false
		self:SetColor( Color(255, 255, 255, 255) )
		if IsValid( self.stove ) then
			--self.dt.owning_ent.plantedmeth = math.Clamp( self.dt.owning_ent.plantedmeth - 1, 0, self.maxmeth )
		end
		self.stove = {}
	end
	
	if self.smoke && self.onstove then
		local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos() + self:GetUp()*5 )
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("meth_smoke", effectdata)
		
		/* Rotating when done :)
		self.ang = self.ang or 0
		self.ang = self.ang + 1
		if self.ang >= 360 then self.ang = 0 end
		
		self:GetPhysicsObject():EnableMotion( false )
		self:SetAngles(Angle(0, self.ang, 0))
		*/
	end
	
	if self.onstove then // Progress of the Meth
		self.cooldown = self.cooldown or (CurTime() + 1)
		if CurTime() < self.cooldown then return end
		self.cooldown = CurTime() + 1
		self.cooktime = self.cooktime + 1
		
		self.ct = self.ct + 1
		if self.ct >= self.chancetime then
			self:AddExplodeChance( self.addchance )
			self.ct = 0
		end
		
		if self.cooktime >= self.needcooktime then // Emit the Smoke and some other stuff
			
			self.smoke = true
			
			if self.cooktime >= (self.needcooktime + 180) then // Overcooking
				self:Explode()
			end
		end
	end
end