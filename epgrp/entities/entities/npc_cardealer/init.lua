AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


util.AddNetworkString( "carinfo" )
util.AddNetworkString( "buycar" )
util.AddNetworkString( "testcar" )
util.AddNetworkString( "openaskmenu" )

util.AddNetworkString( "send_garage_table" )
util.AddNetworkString( "request_car_data" )

function ENT:Initialize( )
    self:SetModel( "models/odessa.mdl" )
	self:SetUseType( SIMPLE_USE )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetSolid( SOLID_BBOX )
	self:SetMaxYawSpeed( 9999 )
	self:DropToFloor()
	
	self.cars = {}
	self.testdrives = {}
	self.lastrespawn = CurTime()
	self:SpawnCars()
	
	for k, v in pairs( player.GetAll() ) do
		v:LoadGarageTable()
	end
end

hook.Add( "PlayerAuthed", "SendCarInfo", function( ply )
	timer.Simple( 10, function()
		ply:LoadGarageTable()
		
		for _, npc in pairs( ents.FindByClass( "npc_cardealer" )) do
			for k, v in pairs( npc.cars ) do
				net.Start( "carinfo" )
					net.WriteTable( {ent=v.car,carinfo=v.tbl} )
				net.Send( ply )
			end
		end
	end)
end)

net.Receive( "request_car_data", function( len, ply )
	for _, npc in pairs( ents.FindByClass( "npc_cardealer" )) do
		for k, v in pairs( npc.cars ) do
			net.Start( "carinfo" )
				net.WriteTable( {ent=v.car,carinfo=v.tbl} )
			net.Send( ply )
		end
	end
end)

function ENT:SpawnCars()
	CSVehicles.CarSpawns[tostring(game.GetMap())] = CSVehicles.CarSpawns[tostring(game.GetMap())] or {}
	for k, v in pairs( CSVehicles.CarSpawns[tostring(game.GetMap())] ) do
		local blocked = ents.FindInSphere( v.pos, 15 )
		local isblocked = false
		for _, block in pairs( blocked ) do
			if block:IsPlayer() then
				block:SetPos( self:GetForward()*50 )
				block:ChatPrint( "Du wurdest zum CarDealer teleportiert, weil du sonst im Auto feststecken würdest." )
				continue
			end
			if IsValid( block ) && block:GetClass() == "prop_physics" then block:Remove() continue end
			if block:GetClass() == "npc_cardealer_car" && !(block.GettingTested) then block:Remove() continue end
			isblocked = true
		end
		
		if isblocked then continue end
		
		local rand = table.Random( CSVehicles.Cars )
		if self:IsCarDuplicate( rand.vehsname ) then continue end
		
		local car = ents.Create( "npc_cardealer_car" )
		car:SetModel( rand.model )
		car:SetPos( v.pos )
		car:SetAngles( v.ang )
		car.carinfo = rand
		car:Spawn()
		
		car.cardealer = self
		
		net.Start( "carinfo" )
			net.WriteTable( {ent=car,carinfo=rand} )
		net.Send( player.GetAll() )
		
		self:DeleteOnRemove( car )
		
		table.insert( self.cars, {name=rand.vehsname, tbl=rand, car=car} )
	end
end

function ENT:RespawnCars()
	for k, v in pairs( self.cars ) do
		if !(IsValid( v.car )) then table.remove( self.cars, k ) continue end
		if v.car.GettingTested then continue end
		v.car:Remove()
		table.remove( self.cars, k )
	end
	self:SpawnCars()
end

function ENT:IsCarDuplicate( name )
	for k, v in pairs( self.cars ) do
		if v.name == name then return true end
	end
	return false
end

function SpawnTestCar( ent, ply )
	if ent.GettingTested then return end
	
	local tbl = ent.carinfo
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
	
	ent:SetNotSolid( true )
	ent:SetColor( Color( 0, 0, 0, 0 ) )
	ent:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	CarCreate:SetPos( ent:GetPos() )
	CarCreate:SetAngles( ent:GetAngles() )
	CarCreate:SetColor(Color( 255, 255, 255, 255 ))
	
	CarCreate.VehicleName = tbl.vehsname
	CarCreate.VehicleTable = VehData
	CarCreate:SetPhysicsAttacker( ply )
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

	CarCreate:SetHealth( tbl.hp )
	CarCreate:SetMaxHealth( tbl.hp )
	
	CarCreate.ClassOverride = VehData.Class
	
	CarCreate.enterpos = ply:GetPos()
	CarCreate.carent = ent
	ent.GettingTested = true
	ply:EnterVehicle( CarCreate )
	
	table.insert( ent.cardealer.testdrives, {start=CurTime(), car=CarCreate, ply=ply} )
end

function SpawnNewCar( ent, ply )

	local tbl = ent.carinfo
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
	
	CarCreate:SetPos( ent:GetPos() )
	CarCreate:SetAngles( ent:GetAngles() )
	CarCreate:SetColor( ent:GetColor() )
	
	CarCreate.VehicleName = tbl.vehsname
	CarCreate.VehicleTable = VehData
	CarCreate:SetPhysicsAttacker( ply )
	
	
	ent:SetNotSolid( true )
	ent:SetColor( Color( 0, 0, 0, 0 ) )
	ent:SetRenderMode( RENDERMODE_TRANSALPHA )
	SafeRemoveEntity( ent ) 
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

	CarCreate:SetHealth( tbl.hp )
	CarCreate:SetMaxHealth( tbl.hp )
	
	CarCreate.ClassOverride = VehData.Class
	
	if VehData.Members then
		table.Merge(CarCreate, VehData.Members)
	end
	
	CarCreate:SetRPVar( "owner", ply )
	CarCreate.Owner = ply 
	gamemode.Call("PlayerSpawnedVehicle", ply, CarCreate) -- VUMod compatability
	CarCreate:Fire( "lock", 1 )
    
	CreateCarfuel( CarCreate )
end

function PLAYER_META:SpawnNewCar( vehname, pos, ang, skin )
    local ply = self
	local VehData = list.Get("Vehicles")[vehname]

    skin = skin or nil
    local cartbl = FindCarTableByClassName( vehname )

	if not VehData then
		GAMEMODE:Log( 1, "[VehicleScript] FATAL: Keine Vehicle Lua-Datei für " .. vehname .. " geladen!" )
		return
	end
	local CarCreate = ents.Create(VehData.Class)
	CarCreate:SetModel(VehData.Model)
	if VehData.KeyValues then
		for k, v in pairs(VehData.KeyValues) do
			CarCreate:SetKeyValue(k, v)
		end
	end
	
	CarCreate:SetPos( pos )
	CarCreate:SetAngles( ang )
	CarCreate:SetColor( Color( 255, 255, 255, 255 ) )
    if skin != nil then CarCreate:SetSkin( skin ) end
	
	CarCreate.VehicleName = vehname
	CarCreate.VehicleTable = VehData
	CarCreate:SetPhysicsAttacker( ply )
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

	CarCreate:SetHealth( cartbl.health or 100 )
	CarCreate:SetMaxHealth( cartbl.health or 100 )
	
	CarCreate.ClassOverride = VehData.Class
	
	if VehData.Members then
		table.Merge(CarCreate, VehData.Members)
	end
	
	CarCreate.Owner = ply 
	gamemode.Call("PlayerSpawnedVehicle", ply, CarCreate) -- VUMod compatability
	return CarCreate
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		
	end
end

function ENT:Think()
	for k, v in pairs( self.testdrives ) do
        if (self.lastrespawn + 1800) < CurTime() then
            self:RespawnCars()
            self.lastrespawn = CurTime()
        end
        
		if !(IsValid( v.car )) then table.remove( self.testdrives, k ) continue end
		if !(IsValid( v.car:GetDriver())) then 
			if v.ply:Alive() then
				v.ply:ExitVehicle( v.car )
				v.ply:SetPos( v.car.enterpos ) 
			end
			
			v.car.carent:SetNotSolid( false )
			v.car.carent:SetColor( Color( 255, 255, 255, 255 ) )
			v.car.carent:SetRenderMode( RENDERMODE_TRANSALPHA )
			v.car.carent.GettingTested = false
			
			v.car:Remove()
			table.remove( self.testdrives, k )
			continue 
		end
		if (v.start + 30) < CurTime() then
			if v.ply:Alive() then 
				v.ply:ExitVehicle( v.car )
				v.ply:SetPos( v.car.enterpos ) 
			end
			
			v.car.carent:SetNotSolid( false )
			v.car.carent:SetColor( Color( 255, 255, 255, 255 ) )
			v.car.carent:SetRenderMode( RENDERMODE_TRANSALPHA )
			v.car.carent.GettingTested = false
			
			v.car:Remove()
			v.ply:ChatPrint( "Deine Testfahrt ist zu ende!" )
			table.remove( self.testdrives, k )
			continue 
		end
	end
end

/*************************************
	MySQL Stuff
*************************************/
--db
local meta = FindMetaTable( "Player" )
local ent_meta = FindMetaTable( "Entity" )

function meta:PurchaseCar( car )
	if self:HasCarLimit() then self:ChatPrint( "Du kannst nicht mehr Autos kaufen!" ) return end
	if !(self:CanAfford( car.carinfo.cost )) then  return end
	
	self:AddCash( -car.carinfo.cost )
	
	local sid = tostring(self:SteamID())
	local carname = car.carinfo.vehsname
	local col_r, col_g, col_b = car:GetColor().r, car:GetColor().g, car:GetColor().b
	local skin = car:GetSkin()
	local tunings = util.TableToJSON( {} )
	local fuel = car.carinfo.fuel
	local health = car.carinfo.hp
	local number = GenerateNumberShield()
	local model = car.carinfo.model
    local data = util.TableToJSON({})
	
	RP.SQL:Query("INSERT INTO garage (player_sid, carname, col_red, col_green, col_blue, skin, tunings, fuel, health, car_number, model,data) VALUES (%1%, %2%, %3%, %4%, %5%, %6%, %7%, %8%, %9%, %10%, %11%, %12%)", 
	{sid, carname, col_r, col_g, col_b, skin, tunings, fuel, health, number, model, data}, function()
		self:LoadGarageTable()
		SpawnNewCar( car, self )
    end)
end

function meta:HasCarLimit()
	/*
	local limit_query = db:query("SELECT * FROM player_garage WHERE player_sid = '" .. tostring(self:SteamID()) .. "'")
    limit_query.onSuccess = function(q)
		if checkQuery(q) then
			local data = q:getData()
			if #data >= CSVehicles.config.MaxVehicles then return true end
			return false
        end
    end
    limit_query.onError = function(q,e) print(e) return end
    limit_query:start()
	*/
    self.garage_table = self.garage_table or {}
	if #self.garage_table >= (CSVehicles.config.MaxVehicles + 1) && !(CSVehicles.config.MaxVehicles == 3) && (self:IsAdmin() or self:IsUserGroup( "donator") or self:IsUserGroup( "vip")) then
		return false
	end
	if #self.garage_table >= CSVehicles.config.MaxVehicles then return true end
	return false
end

function meta:LoadGarageTable()
	RP.SQL:Query("SELECT * FROM garage WHERE player_sid = %1%", {tostring(self:SteamID())}, function(q)
		if #q > 0 then
			self.garage_table = q
            
            for k, v in pairs( self.garage_table ) do
                v.data = v.data or "[]"
                v.data = util.JSONToTable( v.data )
            end
            q = self.garage_table
            
			net.Start( "send_garage_table" )
				net.WriteTable( q )
			net.Send( self )
		else
			self.garage_table = {}
			net.Start( "send_garage_table" )
				net.WriteTable( {} )
			net.Send( self )
        end
    end)
end