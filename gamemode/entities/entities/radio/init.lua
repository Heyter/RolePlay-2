AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


// TTT Options
Map_Radios = 0
Max_Radios = 2
UserGroups = {"member", "vip", "donator", "operator"}
UserGroups_r = {"member", "operator"}
///

local Sender = {}
Sender[1] = {name="Technobase.FM", URL="http://listen.technobase.fm/dsl.pls"}
Sender[2] = {name="Hardbase.FM", URL="http://listen.hardbase.fm/dsl.pls"}
Sender[3] = {name="Trancebase.FM", URL="http://listen.trancebase.fm/dsl.pls"}
Sender[4] = {name="Clubtime.FM", URL="http://listen.clubtime.fm/dsl.pls"}
Sender[5] = {name="Catalyst.FM", URL="http://alpha.grey-hat.net:9998/listen.pls"}


function ENT:Initialize()
	self:SetModel( "models/props/cs_office/radio.mdl" )

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	
	local b = 10
	self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.on = self.on or false
	
	if SERVER then
      self:SetMaxHealth(100)

      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
         phys:SetMass(20)
      end
	  
	  self:SetHealth(100)
	  
      self:SetUseType(CONTINUOUS_USE)
   end
	
	
	Map_Radios = Map_Radios + 1
end

-- traditional equipment destruction effects
function ENT:OnTakeDamage(dmginfo)

   self:TakePhysicsDamage(dmginfo)

   self:SetHealth(self:Health() - dmginfo:GetDamage())
   
   if self:Health() < 0 then
      self:Remove()

    
   end
end


hook.Add( "KeyPress", "RADIO_KEYPRESS_R", function( ply, key )
	local pos = ply:GetShootPos()
	local ang = ply:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*50)
	tracedata.filter = ply
	local tr = util.TraceLine(tracedata)
	
	if !IsValid( tr.Entity ) or tr.Entity:GetClass() != "radio" then return end
	
	tr.Entity.nextchange = tr.Entity.nextchange or CurTime()
	tr.Entity.sender = tr.Entity.sender or 0
	if key == IN_RELOAD && CurTime() > tr.Entity.nextchange then
		local pos = ply:GetShootPos()
		local ang = ply:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*50)
		tracedata.filter = ply
		local tr = util.TraceLine(tracedata)
		
		if !IsValid( tr.Entity ) or tr.Entity:GetClass() != "radio" then return end
		
		tr.Entity.nextchange = CurTime() + 1
		tr.Entity.sender = tr.Entity.sender + 1
		if tr.Entity.sender > #Sender then tr.Entity.sender = 0 end
        
        tr.Entity.locked = true
        timer.Simple( 3, function() tr.Entity.locked = false end )
		
		if tr.Entity.sender == 0 then
			net.Start( "RADIO_StopURL" )
				net.WriteEntity( tr.Entity )
			net.Broadcast()
			tr.Entity.on = false
			tr.Entity:EmitSound( "/weapons/stunstick/spark1.wav", 50, 50 )
			return
		end
		
		net.Start( "RADIO_PlayURL" )
			net.WriteEntity( tr.Entity )
			net.WriteTable( Sender[tr.Entity.sender] )
		net.Broadcast()
		tr.Entity:EmitSound( "/weapons/stunstick/spark1.wav", 50, 80 )
		tr.Entity.on = true
	end
end)

net.Receive( "RADIO_RequestURL", function()
	local tbl = net.ReadTable() or {}
	if !(tbl) then return end
	
	if !(IsValid( tbl.radio )) or tbl.radio:GetClass() != "radio" then return end
	
	net.Start( "RADIO_PlayURL" )
		net.WriteEntity( tbl.radio )
		net.WriteTable( {name=tbl.URL, URL=tbl.URL} )
	net.Broadcast()
	tbl.radio:EmitSound( "/weapons/stunstick/spark1.wav", 50, 80 )
end)

util.AddNetworkString( "RADIO_PlayURL" )
util.AddNetworkString( "RADIO_StopURL" )
util.AddNetworkString( "RADIO_OpenURLMenu" )
util.AddNetworkString( "RADIO_RequestURL" )

function ENT:Use(activator,caller)
	self.nextuse = self.nextuse or CurTime()
	if CurTime() < self.nextuse then return end
	self.nextuse = CurTime() + 1
	net.Start( "RADIO_OpenURLMenu" )
		net.WriteEntity( self )
	net.Send( activator )
end

function ENT:OnRemove()
	net.Start( "RADIO_StopURL" )
		net.WriteEntity( self )
	net.Broadcast()
	
	Map_Radios = Map_Radios - 1
end
