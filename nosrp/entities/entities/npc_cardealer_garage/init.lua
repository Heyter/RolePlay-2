AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString( "opengaragemenu" )
util.AddNetworkString( "spawn_garagecar" )

local meta = FindMetaTable( "Player" )

function ENT:Initialize( )
	self:SetModel( "models/props/de_nuke/equipment1.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	phys:EnableMotion( false )
	
	self.GettingTested = false
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		net.Start( "opengaragemenu" )
		net.Send( Activator )
	end
end

hook.Add( "CanExitVehicle", "Garage_Check", function( veh, ply )
	local pos = FindSpawnPos( ply, true )
	if pos == nil then return true end
	if pos.pos:Distance( ply:GetPos() ) > 100 then return true end
	ply:ExitVehicle( veh )
	veh:Remove()
	return true
end)

function meta:HasActiveCar( remove )
	remove = remove or false
	for k, v in pairs( ents.GetAll() ) do
		if !(IsValid( v )) then continue end
		if !(v:IsVehicle()) then continue end
		v.Owner = v.Owner or nil
		if v.Owner == nil then continue end
		if v.Owner == self && remove then v:Remove() return false end
		if v.Owner == self then return true end
	end
	return false
end

function meta:HasCar( vehsname )
	for k, v in pairs( self.garage_table or {} ) do
		if v.carname == vehsname then return true end
	end
	return false
end

/*
function PLAYER_META:FindCarTableByClassName( name )
    for k, v in pairs( self.garage_table ) do
        if name == v.carname then return v end
    end
end
*/

function FindSpawnPos( ply, near )
	Car_SpawnPositions[tostring(game.GetMap())] = Car_SpawnPositions[tostring(game.GetMap())] or {}
	near = near or false
	if not near then
		for k, v in pairs( Car_SpawnPositions[tostring(game.GetMap())] ) do
			if ply:GetPos():Distance( v.pos ) > 750 then continue end
			local blocks = ents.FindInSphere( v.pos, 20 )
			local found_block = false
			for _, block in pairs( blocks ) do
				block.Owner = block.Owner or nil
				if IsValid( block ) && block:IsVehicle() && block.Owner == ply then block:Remove() continue end
				if IsValid( block ) then found_block = true continue end
			end
			if found_block then continue end
			return v
		end
		return nil
	else
		for k, v in pairs( Car_SpawnPositions[tostring(game.GetMap())] ) do
			if ply:GetPos():Distance( v.pos ) > 100 then continue end
			local blocks = ents.FindInSphere( v.pos, 20 )
			local found_block = false
			for _, block in pairs( blocks ) do
				block.Owner = block.Owner or nil
				if IsValid( block ) && block.Owner == ply then return v end
				if IsValid( block ) then found_block = true continue end
			end
			if found_block then continue end
			return v
		end
		return nil
	end
end

net.Receive( "spawn_garagecar", function( len, ply )
	local tbl = net.ReadString()
	ply.lastcarspawn = ply.lastcarspawn or 0
	if ply.lastcarspawn > CurTime() then return end
	ply.lastcarspawn = CurTime() + 2
	if !(ply:HasCar( tbl )) then return end
	if ply:HasActiveCar( ) then ply:ChatPrint( "Bitte bring erst dein anderes Auto zurück in die Garage, bevor du ein neues spawnst." ) return end
	local pos = FindSpawnPos( ply )
	if pos == nil then ply:ChatPrint( "Wir konnten leider kein Autospawn für dein Auto finden. Vesuch es später erneut." ) return end
	SpawnGarageCar( tbl, pos, ply )
end)

function meta:GetGarageInfo( vehsname )
	for k, v in pairs( player.GetAll() ) do
		if v.carname == vehsname then return v end
	end
	return nil
end

function SpawnGarageCar( vehsname, pos_tbl, ply )

	local tbl = GetCarInfo( vehsname )
	--local garage_info = ply:GetGarageInfo( vehsname )
	local VehData = list.Get("Vehicles")[tbl.vehsname]

	if not VehData then
		GAMEMODE:Log( 1, "[VehicleScript] FATAL: Keine Vehicle Lua-Datei für " .. tbl.vehsname .. " geladen!" )
		return
	end
	local CarCreate = ents.Create(VehData.Class)
	CarCreate:SetModel(tbl.model)
	if VehData.KeyValues then
		for k, v in pairs(VehData.KeyValues) do
			CarCreate:SetKeyValue(k, v)
		end
	end
	
	CarCreate:SetPos( pos_tbl.pos )
	CarCreate:SetAngles( pos_tbl.ang )

	CarCreate:SetColor( Color( 255, 255, 255, 255 ) )
	
	CarCreate.VehicleName = tbl.vehsname
	CarCreate.VehicleTable = VehData
	CarCreate:SetPhysicsAttacker( ply )
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

	CarCreate:SetHealth( tbl.hp )
	CarCreate:SetMaxHealth( tbl.hp )
	
	CarCreate.ClassOverride = VehData.Class
	
	if VehData.Members then
		table.Merge(CarCreate, VehData.Members)
	end
	
	CarCreate.Owner = ply 
	gamemode.Call("PlayerSpawnedVehicle", ply, CarCreate) -- VUMod compatability
	CarCreate:Fire( "lock", 1 )
	
end

function ENTITY_META:SaveCarStats()
    if !(IsValid( self )) then return end
    local name = self:GetTable().VehicleName
    local tbl = self.owner:FindCarTableByClassName( name )
    if !(tbl) then return end
   -- Query("UPDATE player_garage WHERE , function()
		
    --end)
end