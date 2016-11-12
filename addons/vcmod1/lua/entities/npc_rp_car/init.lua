AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

file.CreateDir("vc_npc_cars")

include( 'shared.lua' )

local PutAwayRadius = 500

util.AddNetworkString( "AttemptBuyCar" )
util.AddNetworkString( "AttemptSpawnCar" )
util.AddNetworkString( "RequestCurrentCars" )
util.AddNetworkString( "SendCurrentCars" )
util.AddNetworkString( "OpenCarMenu" )
util.AddNetworkString( "AttemptRemoveCar" )
util.AddNetworkString( "AttemptSellCar" )
util.AddNetworkString( "AttemptTestCar" )

function ENT:Initialize( )
	self:SetModel("models/Barney.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid( SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:DropToFloor()
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(90)
end

function ENT:AcceptInput( Name, Activator, Caller )
	if( Name == "Use" ) then
		if( Caller:IsValid() && Caller:IsPlayer() ) then
			if !Caller.VC_OpenMenuTime or CurTime() >= Caller.VC_OpenMenuTime then
				Caller.VC_OpenMenuTime = CurTime()+1
				net.Start( "OpenCarMenu" )
				net.Send( Caller )
			end
		end
	end
end

hook.Add( "PlayerInitialSpawn", "car_file_check", function( ply )
	ply.HasCar = false
	ply.OwnedCar = nil
	if( !file.Exists( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) then
		file.Write( "vc_npc_cars/"..ply:UniqueID()..".txt", "" )
	end
end)

hook.Add( "PlayerDisconnected", "check_for_cars", function(ply) if ply.HasCar then local ent = ply.OwnedCar if IsValid(ent) and ent:IsVehicle() then ply.HasCar = false ply.OwnedCar = nil ent:Remove() end end end)

hook.Add( "CanTool", "no_removing_cars", function( ply, tr, tool )
	if tool == "remover" and IsValid(tr.Entity) and tr.Entity:IsVehicle() and tr.Entity.VC_SpawnedVIANPC then
	VCMsg("You cannot remove cars that way, speak with the car npc.", ply)
	return false
	end
end)

local function SpawnCar( id, ply )
	local car = VC_NPC_Cars[ id ]
	local ent = ents.Create(car.class)
	ent:SetModel( car.model )
	ent:SetKeyValue("vehiclescript", car.script)
	ent:SetPos(Vehicle_SpawnPosition or Vector(0,0,0))
	ent:SetAngles(Vehicle_SpawnAngle or Angle(0,0,0))
	ent.VehicleTable = {}
	ent.VehicleTable.Name = car.name
	ent.VC_SpawnedVIANPC = true
	ent.VC_Spawner = ply

	for k, v in pairs(list.Get( "Vehicles" )) do if v.KeyValues.vehiclescript == car.script then ent.VehicleName = k break end end

	ent:Spawn()

	ent.VC_NPC_Remove_Time = CurTime()+ (VC_Settings.VC_NPC_Remove_Time or 300)
	ply.HasCar = true
	ply.OwnedCar = ent

	local Func = ent.keysOwn or ent.Own
	if Func then Func(ent, ply) end

	ent.Owner = ply
	ent.OwnerID = ply:SteamID()
	if p_SpawnedVehicle then p_SpawnedVehicle(ply, ent) end
end
net.Receive( "RequestCurrentCars", function( ln, ply )
	for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) ) do
		net.Start( "SendCurrentCars" )
		net.WriteInt( tonumber( v ), 8 )
		net.Send( ply )
	end
end )

net.Receive( "AttemptBuyCar", function( ln, ply )
	local id = net.ReadInt( 8 )
	if VC_NPC_Cars[ id ].vip then
		-- if ply:IsAdmin() && !ply:IsUserGroup( "vipmod" ) && !ply:IsUserGroup("vip") && !ply:IsUserGroup( "vipadmin" ) then
		if !ply:IsAdmin() and !ply:IsUserGroup(string.lower(VC_NPC_Settings.Group or "vip")) then
			VCMsg("You need to be VIP to buy this car.", ply)
			return
		end
	end
	for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) ) do
		if( tonumber( v ) == id ) then
			VCMsg("You already have that car.", ply)
			return
		end
	end

	local Func = ply.canAfford or ply.CanAfford
	if Func and !Func(ply, VC_NPC_Cars[ id ].price) then
		VCMsg("You can't affored that car.", ply)
		return
	end
	local Func = ply.addMoney or ply.AddMoney
	if Func then Func(ply,  -VC_NPC_Cars[ id ].price) end
	VCMsg("You bought a "..VC_NPC_Cars[ id ].name..".", ply)
	local prev = file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" )
	file.Write( "vc_npc_cars/"..ply:UniqueID()..".txt", prev..tostring( id )..";" )
end )

net.Receive( "AttemptSellCar", function( ln, ply )
	if ply.VC_LastSoldCarTime and CurTime() < ply.VC_LastSoldCarTime then VCMsg("You will have to wait another "..(math.Round(ply.VC_LastSoldCarTime-CurTime()*10)/10).." seconds before you can sell another car.", ply) end
	if (ply.HasCar) then VCMsg("You currently have a car out!", ply) return end
	-- local id = net.ReadInt( 8 ) local can = false for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..player.GetAll()[1]:UniqueID()..".txt", "DATA" ) ) ) do if id == tonumber(v) then can = true break end end
	-- if can then
		local Func = ply.addMoney or ply.AddMoney
		if Func then Func(ply, VC_NPC_Cars[ id ].price * (VC_Settings.VC_NPC_RefundPrice or 75)/100) end
		VCMsg("You sold a "..VC_NPC_Cars[ id ].name.." for $"..(c)..".", ply) ply.VC_LastSoldCarTime = CurTime()+5
		local new = ""
		for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) ) do
			if( tonumber( v ) != id ) then
				new = new..v..";"
			end
		end
	file.Write( "vc_npc_cars/"..ply:UniqueID()..".txt", new )
	-- end
end)

net.Receive( "AttemptSpawnCar", function( ln, ply )
	local id = net.ReadInt( 8 )
	if(VC_NPC_Cars[ id ].vip) then
		if !ply:IsAdmin() and !ply:IsUserGroup(string.lower(VC_NPC_Settings.Group or "vip")) then
			VCMsg("You need to be VIP to spawn this car.", ply)
			return
		end
	end
	for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) ) do
		if( tonumber( v ) == id ) then
			if( ply.HasCar ) then
				VCMsg("You already have a car.", ply)
				return
			else
				SpawnCar( id, ply )
				return
			end
		end
	end
end )

net.Receive( "AttemptTestCar", function( ln, ply )
	local id = net.ReadInt( 8 )
	if( ply.HasCar ) then
		VCMsg("You already have a car.", ply)
		return
	end
	SpawnCar( id, ply )
	VCMsg("You have 30 seconds to test this car!", ply)
	ply.isTesting = true
	timer.Simple( 30, function()
		if IsValid(ply) then
		VCMsg("Your test drive is over!", ply)
		if ply.OwnedCar then ply.OwnedCar:Remove() ply.OwnedCar = nil end
		ply.HasCar = false
		ply.isTesting = false
		end
	end )
end )

net.Receive( "RequestCurrentCars", function( ln, ply )
	for k,v in pairs( string.Explode( ";", file.Read( "vc_npc_cars/"..ply:UniqueID()..".txt", "DATA" ) ) ) do
		local id = tonumber( v )
		if( id ) then
			net.Start( "SendCurrentCars" )
				net.WriteInt( id, 8 )
			net.Send( ply )
		end
	end
	net.Start( "SendCurrentCars" )
		net.WriteInt( -1, 8 )
	net.Send( ply )
end )
net.Receive( "AttemptRemoveCar", function( ln, ply )
	if( ply.isTesting ) then
		VCMsg("You are currently testing a car!", ply)
	elseif( ply.HasCar == false ) then
		VCMsg("You dont have a car to put away.", ply)
	else
		local ent = ply.OwnedCar
		if( ent:IsValid() ) then
			if( ent:IsVehicle() ) then
				if( ply:GetPos():Distance( ent:GetPos() ) <= PutAwayRadius ) then
					ply.HasCar = false
					ply.OwnedCar = nil
					ent:Remove()
					return
				end
			end
		end
		VCMsg("You need to bring your car to me if you want me to put it away.", ply)
	end
end )