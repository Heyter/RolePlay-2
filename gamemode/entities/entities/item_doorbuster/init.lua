AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self.Entity:SetModel("models/Items/car_battery01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	
	self.Damage = math.random(80, 350)
	self.used = false
	self.locked = false
	  
	local phys = self.Entity:GetPhysicsObject();
	  
	if(IsValid( phys )) then
	  phys:Wake();
	 end
 
end

function ENT:Use()
if self.used then return end

	self.used = true
	self.locked = true
	
	for i=1, 20 do
		timer.Simple(i, function() self:Beep(100) end);
	end
	
	timer.Simple(21, function() self:Beep(110) end);
	timer.Simple(22, function() self:Beep(120) end);
	timer.Simple(23, function() self:Beep(130) end);
	timer.Simple(24, function() self:Beep(140) end);
	timer.Simple(25, function() self:Beep(150) end);
	timer.Simple(26, function() self:Beep(160) end);
	timer.Simple(27, function() self:Beep(170) end);
	timer.Simple(28, function() self:Beep(180) end);
	timer.Simple(29, function() self:Beep(190) end);
	timer.Simple(29.2, function() self:Beep(190) end);
	timer.Simple(29.4, function() self:Beep(190) end);
	timer.Simple(30, function() self:DestroyDoors() end);
end

function ENT:Beep(i)	
	self:EmitSound("buttons/button17.wav", 100,i or 100)
end

function ENT:DestroyDoors()
	if(not IsValid(self.Entity)) then return end
	
	for k,door in pairs(ents.FindInSphere(self.Entity:GetPos(), 220)) do
		if(door:IsVehicle()) then
			
		end
		
		if (door:IsPlayer() && IsValid(door)) then door:Kill() end
		
		if(IsDoor( door )) then
			if(true) then
				if(IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating" or door:GetClass() == "func_door")) then
				
					door:Fire("unlock", "", 0);
					door:Fire("open", "", 0);
				
				end
							
			end
			if(IsValid(door) and door:GetClass() == "prop_door_rotating") then
			
				door:EmitSound(Sound( "physics/wood/wood_box_impact_hard3.wav"));
				
				if(SERVER) then
					
				end
				
			end
		end
	end
	util.ScreenShake(self.Entity:GetPos(), 15, 15, 3, 2000)  
	util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 500, self.Damage)
	self.Entity:EmitExplodeEffect();
	self.Entity:Remove()
    
    if IsValid( self.owner ) then
        self.owner:SetSkill( "Ruf", self.owner:GetSkill( "Ruf" ) + 0.07 )
    end
end

function ENT:EmitExplodeEffect()
	if(not IsValid(self.Entity)) then return end
	
	self.Entity:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav");
	self.Entity:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav");
	self.Entity:EmitSound("ambient/explosions/explode_" .. math.random(4) .. ".wav");
	
	local effectdata = EffectData();
	effectdata:SetStart(self.Entity:GetPos());
	effectdata:SetOrigin(self.Entity:GetPos());
	effectdata:SetScale(1);
	util.Effect("effect_doorbuster", effectdata);
end