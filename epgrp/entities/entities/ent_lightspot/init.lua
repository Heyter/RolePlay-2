AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_wasteland/light_spotlight01_lamp.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
	self.on = false
	self.lastswitch = CurTime() + 1
	
	CreatePlug( self, Vector( 0, 0, 0 ), 150, 12 )
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
		phys:SetMass(150)
end

function ENT:Use( ply, caller )
	local delay = (self.lastswitch or CurTime())
	if (CurTime() < self.lastswitch) then return end
	if !(self.Plug.isplugged) then return end
	
	if !(self.light) then

		local flashlight = ents.Create("env_projectedtexture")
		flashlight:SetParent(self)
			
		flashlight:SetLocalPos(Vector(-50,0,0))
		flashlight:SetLocalAngles(Angle(0,0,0))
			
		flashlight:SetKeyValue("enableshadows", 0)
		flashlight:SetKeyValue("farz", 1028)
		flashlight:SetKeyValue("nearz", 64)
			
		flashlight:SetKeyValue("lightfov", 60)
		
		flashlight:SetKeyValue("lightcolor", "255 255 255")
		flashlight:Spawn()
		
		flashlight:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
	
		self.light = flashlight
		print("kk")
		
	end
	
	self.lastswitch = CurTime() + 1
	print("gnarr2")
	
	if !(self.on) then
	print("gnarr3 | " .. tostring(self.light))
		self.light:Fire("TurnOn", "", 0)
		self.light.StatusOn = true
		self.on = true
	else
	print("gnarr4")
		self.light:Fire("TurnOff", "", 0)
		self.on = false
		self.light.StatusOn = false
	end
	self:EmitSound("/buttons/button16.wav", 75, 100)
end

function ENT:MasterHasEnergy()
	for k, v in pairs(constraint.GetAllConstrainedEntities( self )) do
		if !(IsValid( v )) then continue end
		if v:GetClass() == "ent_plugholder3x" then
			if v.Plug.isplugged then
				return true
			else
				return false
			end
		end
	end
	return true
end

function ENT:Think()
	if (self.Plug && self.light) && !(self.Plug.isplugged) or !(self:MasterHasEnergy()) then
	if !(self.on) then return end
		self.on = false
		self.light:Fire("TurnOff", "", 0)
		self:EmitSound("/buttons/button16.wav", 75, 100)
	end
end