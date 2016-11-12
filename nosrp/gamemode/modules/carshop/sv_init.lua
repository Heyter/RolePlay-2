CARSHOP = CARSHOP or {}
CARSHOP.BuyableCars = CARSHOP.BuyableCars or {}
CARSHOP.NextSwitch = CARSHOP.NextSwitch or nil

util.AddNetworkString( "CarDealer_SendChoosenCars" )
util.AddNetworkString( "CarDealer_PurchaseCar" )
util.AddNetworkString( "CarDealer_SellCar" )
util.AddNetworkString( "CarDealer_RepairCar" )
util.AddNetworkString( "CarDealer_DoInstaRepair" )
util.AddNetworkString( "CarDealer_SpawnGarageCar" )


function CARSHOP.PlayerAuthed( ply )
    if !(IsValid( ply )) then return end
    net.Start( "CarDealer_SendChoosenCars" )
        net.WriteTable( CARSHOP.BuyableCars or {} )
    net.Send( ply )
    
    Query("SELECT * FROM garage WHERE player_sid='" .. tostring(ply:SteamID()) .. "'", function( q ) 
        local tbl = {}
        for k, v in pairs( q ) do
            v.Tunings = util.JSONToTable( v.Tunings )
            v.data = util.JSONToTable( v.data )
            v.Name = CARSHOP.CARTABLE.CARS[v.carname].Name or "Unknown"
            v.Desc = CARSHOP.CARTABLE.CARS[v.carname].Desc
            v.Damage_Class = CARSHOP.CARTABLE.CARS[v.carname].Damage_Class
            tbl[v.carname] = v
        end
        
        ply:SetRPVar( "garage_table", tbl ) 
    end, 
    function( q ) 
        ply:SetRPVar( "garage_table", {} ) 
    end)
end

function CARSHOP.PlayerDisconnected( ply )
    for k, v in pairs( ents.GetAll() ) do
        if !(IsValid( v )) then continue end
        if !(v:IsVehicle()) then continue end
        if !(v:GetClass() == "prop_vehicle_jeep") then continue end
        if v.JobCar == nil then continue end
        
        if v.Owner == ply or v.Owner == nil then
            v:SetColor( (v.col or Color( 255, 255, 255, 255 )) )
            if v.JobCar != nil && !(v.JobCar) then CARSHOP.SaveCar( v ) end
            v:Remove()
        end
    end
end


function CARSHOP.SaveCar( car )
    if !(car or IsValid( car )) then return end
    if !(car.Owner or IsValid( car.Owner)) then return end
    if !(car.VehicleName) then return end
    local tbl = car.Owner:GetRPVar( "garage_table" )[car.VehicleName]
    
    local sid = tostring(car.Owner:SteamID())
    local r, g, b = car:GetColor().r, car:GetColor().g, car:GetColor().b
    local s = car:GetSkin()
    local t = util.TableToJSON( tbl.Tunings )
    local f = car:GetNWInt( "fuel" ) or 0
    local h = car:Health()
    local a = car:GetRPVar( "Armor" )
    local cn = tbl.car_number
    local d = util.TableToJSON( tbl.data )
    local owner = car.Owner
    local rep = tbl.repair or 0
    
    --(col_r,col_b,col_g,Skin,Tunings,Fuel,Health,car_number,Model,data,Armor)
    Query(string.format("UPDATE garage SET col_r=%s,col_g=%s,col_b=%s,Skin=%s,Tunings='%s',Fuel=%s,Health=%s,car_number='%s',data='%s',Armor=%s,repair=%s",
    r,
    g,
    b,
    s,
    tostring(t),
    f,
    h,
    tostring(cn),
    tostring(d),
    a, rep) .. " WHERE player_sid='"..tostring(car.Owner:SteamID()).."' AND carname='"..car.VehicleName.."'", function()
        CARSHOP.PlayerAuthed( owner )
    end)
end

function CARSHOP.PurchaseCar( ply, index, data )
    local tbl = CARSHOP.BuyableCars[index]
    CARSHOP.BuyableCars[index].Sold = CARSHOP.BuyableCars[index].Sold or false
    CARSHOP.BuyableCars[index].VIP = CARSHOP.BuyableCars[index].VIP or false
    
    if tbl.Sold == true then return end
    if tbl.VIP && ply:GetVIPLevel() < tbl.VIP then return end
    if !(ply:CanAfford( tbl.Cost )) then return end
    if #(ply:GetRPVar( "garage_table" ) or {}) >= (CARSHOP.CONFIG.MaxCars + (CARSHOP.CONFIG.VIPMaxCars*ply:GetVIPLevel())) then ply:RPNotify( "Du hast das Maximum an Fahrzeugen erreicht!", 5 ) return end
    if table.HasValue( ply:GetRPVar( "garage_table" ), index ) then return end
    local sid = tostring(ply:SteamID())
    local name = index
    local col = 255
    local s = 0
    local t = "[]"
    local f = tbl.Fuel
    local h = tbl.Health
    local a = tbl.Armor
    local cn = "Unregistriert"
    local m = tbl.Model
    local d = "[]"
    local p = os.time()
    Query("INSERT INTO garage(player_sid,carname,col_r,col_b,col_g,Skin,Tunings,Fuel,Health,car_number,Model,data,purchase_date,Armor) VALUES('"..sid.."','"..name .."',"..col..","..col..","..col..","..s..",'"..t.."',"..f..","..h..",'"..cn.."','"..m.."','"..d.."',"..p..","..a..")", function()
        tbl.Sold = true
        ply:AddCash( -tbl.Cost )
        
        tbl.data = tbl.data or util.JSONToTable( d )
        tbl.col_r =  tbl.col_r or col
        tbl.col_g =  tbl.col_g or col
        tbl.col_b =  tbl.col_b or col
        tbl.Skin = tbl.Skin or s
        tbl.Tunings = tbl.Tunings or util.JSONToTable( t )
        tbl.car_number = tbl.car_number or cn
        
        local g_t = ply:GetRPVar( "garage_table" ) or {}
        g_t[index] = tbl
        ply:SetRPVar( "garage_table", g_t )
        
        net.Start( "CarDealer_SendChoosenCars" )
            net.WriteTable( CARSHOP.BuyableCars or {} )
        net.Send( player.GetAll() )
        ply:RPNotify( "Das Auto wurde zu deiner Garage geliefert!", 5 )
    end)
end
net.Receive( "CarDealer_PurchaseCar", function( data, ply ) CARSHOP.PurchaseCar( ply, net.ReadString(), {} ) end)

function CARSHOP.SellCar( ply, index )
    local tbl = ply:GetRPVar( "garage_table" ) or {}
    if !(tbl) then return end
    if !(tbl[index]) then return end
    
    local price = CARSHOP.CalculateSellPrice( ply, index ) or 0
    Query( "DELETE FROM garage WHERE player_sid='" .. tostring(ply:SteamID()) .. "' AND carname='" .. index .. "'", function() 
        ply:AddCash( price )
        tbl = table.RemoveByKey( tbl, index )
        ply:SetRPVar( "garage_table", tbl )
        ply:RPNotify( "Du hast dein Auto erfolgreich Verkauft!", 5 )
    end)
end
net.Receive( "CarDealer_SellCar", function( data, ply ) CARSHOP.SellCar( ply, net.ReadString() ) end)

function CARSHOP.RepairGarageCar( ply, index )
    local price = CARSHOP.CalculateRepairCost( index, ply ) or 3500
    if !(ply:CanAfford( price )) then ply:RPNotify( "Du kannst dir keine Reparatur leisten!", 5 ) return end
    ply:AddCash( -price )
    
	print("got")
    local tbl = ply:GetRPVar( "garage_table" )
    tbl[index].Health = CARSHOP.CARTABLE.CARS[index].Health
    tbl[index].Armor = CARSHOP.CARTABLE.CARS[index].Armor
    tbl[index].repair = 0
    ply:SetRPVar( "garage_table", tbl )
    
    Query(string.format("UPDATE garage SET Health=%s,Armor=%s,repair=%s",
    CARSHOP.CARTABLE.CARS[index].Health,
    CARSHOP.CARTABLE.CARS[index].Armor,
    0) .. " WHERE player_sid='"..tostring(ply:SteamID()).."' AND carname='"..index.."'", function()
        --CARSHOP.PlayerAuthed( ply )
    end)
end
net.Receive( "CarDealer_RepairCar", function( data, ply ) CARSHOP.RepairGarageCar( ply, net.ReadString() ) end )

function CARSHOP.AdminRepairCar( ent )
    local ply = ent:GetRPVar( "owner" )
    local tbl = ply:GetRPVar( "garage_table" )
    local index = ent.VehicleName
    
    if !(IsValid( ply )) then ent:Remove() return false end
    if !( index ) then return false end
    
    ent:SetHealth( CARSHOP.CARTABLE.CARS[index].Health )
    ent:SetRPVar( "Armor", CARSHOP.CARTABLE.CARS[index].Armor )
    tbl[index].Health = CARSHOP.CARTABLE.CARS[index].Health
    tbl[index].Armor = CARSHOP.CARTABLE.CARS[index].Armor
    tbl[index].repair = 0
    ply:SetRPVar( "garage_table", tbl )
    
    ent.destructed = false
    ent:SetMaterial( "" )
    ent:SetColor( ent.col )
    ent:Fire( "turnon", 1 )
    
    Query(string.format("UPDATE garage SET Health=%s,Armor=%s,repair=%s",
    CARSHOP.CARTABLE.CARS[index].Health,
    CARSHOP.CARTABLE.CARS[index].Armor,
    0) .. " WHERE player_sid='"..tostring(ply:SteamID()).."' AND carname='"..index.."'", function()
        ply:RPNotify( "Dein Auto wurde von ein Admin repariert!", 5 )
    end)
    return true
end

function CARSHOP.CreateGarageCar( ply, index, pos, angles )
    local tbl = (ply:GetRPVar( "garage_table" ) or {})
    if !(tbl) then return end
    if !(tbl[index]) then return end
    tbl = tbl[index]
	local VehData = list.Get("Vehicles")[index]

	if not VehData then
		GAMEMODE:Log( 1, "[VehicleScript] FATAL: Keine Vehicle Lua-Datei für " .. index .. " geladen!" )
		return
	end
    
    local found = false
    for k, v in pairs( ents.GetAll() ) do
        if !(IsValid( v )) then continue end
        if !(v.VehicleTable) then continue end
        v.destructed = v.destructed or false
        if v.Owner == ply && !(v.destructed) then
            ply:RPNotify( "Stelle erst dein Aktuelles Auto in die Garage, bevor du ein neues Spawnst", 5 )
            return
        elseif v.Owner == ply && v.destructed then
            ply:RPNotify( "Du musst dein Auto zuerst Reparieren lassen, bevor du ein neues Spawnen kannst", 5 )
            return
        end
    end
	local CarCreate = ents.Create( "prop_vehicle_jeep" )
	CarCreate:SetModel(tbl.Model)
	if VehData.KeyValues then
		for k, v in pairs(VehData.KeyValues) do
			CarCreate:SetKeyValue(k, v)
		end
	end
	
	CarCreate:SetPos( pos )
	CarCreate:SetAngles( angles )
	CarCreate:SetColor( Color( tbl.col_r, tbl.col_g, tbl.col_b, 255 ) )
    CarCreate.JobCar = false
	
	CarCreate.VehicleName = index
	CarCreate.VehicleTable = tbl
    CarCreate.col = CarCreate:GetColor()
	CarCreate:SetPhysicsAttacker( ply )
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

	CarCreate:SetHealth( tbl.Health )
	CarCreate:SetMaxHealth( CARSHOP.CARTABLE.CARS[index] )
	
	CarCreate.ClassOverride = VehData.Class
	
	if VehData.Members then
		table.Merge(CarCreate, VehData.Members)
	end
	
	CarCreate:SetRPVar( "owner", ply )
    CarCreate:SetRPVar( "Armor", tbl.Armor or 0 )
	CarCreate.Owner = ply
	gamemode.Call("PlayerSpawnedVehicle", ply, CarCreate, true) -- VUMod compatability
	CarCreate:Fire( "lock", 1 )
    
    CARSHOP.ApplyVisuals( ply, CarCreate )
end

function CARSHOP.CreateJOBCar( ply, vehname, pos, ang )
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
    CarCreate.col = CarCreate:GetColor()
	CarCreate:SetPhysicsAttacker( ply )
	
	CarCreate:Spawn( )
	CarCreate:Activate( )

    cartbl = cartbl or {}
    cartbl.Health = cartbl.Health or 300
    cartbl.Armor = cartbl.Armor or GAMEMODE.TEAMS[ply:Team()].CarArmor
    
	CarCreate:SetHealth( cartbl.Health or 300 )
	CarCreate:SetMaxHealth( cartbl.Health or 300 )
    CarCreate.JobCar = true
    
	
	CarCreate.ClassOverride = VehData.Class
	
	if VehData.Members then
		table.Merge(CarCreate, VehData.Members)
	end
	
	CarCreate:SetRPVar( "owner", ply )
    CarCreate:SetRPVar( "Armor", cartbl.Armor or 0 )
	CarCreate.Owner = ply 
	gamemode.Call("PlayerSpawnedVehicle", ply, CarCreate, false) -- VUMod compatability
	CarCreate:Fire( "lock", 1 )
    return CarCreate
end

function FindCarTableByClassName( name )
    for k, v in pairs( CARSHOP.CARTABLE.CARS ) do
        if name == k then return v end
    end
end

function CARSHOP.SpawnGarageCar( ply, index )
    if !(IsValid( ply )) then return end
    local pos = CARSHOP.FindSpawnPos( ply )
    if pos == nil then print("Couldnt spawn car - too far away") return end
    
    timer.Simple( 0.2, function() CARSHOP.CreateGarageCar( ply, index, pos.pos, pos.ang ) end )
end
net.Receive( "CarDealer_SpawnGarageCar", function( data, ply ) local c = net.ReadString() CARSHOP.SpawnGarageCar( ply, c ) end )

function CARSHOP.CreateCarTable()
    local tbl = {}
    CARSHOP.NextSwitch = CurTime() + CARSHOP.CONFIG.CarChangeInterval
    
    for i=1, math.Rand( CARSHOP.CONFIG.MinCarsInShop, CARSHOP.CONFIG.MaxCarsInShop ) do
        local v, k = table.Random( CARSHOP.CARTABLE.CARS )
        tbl[k] = v
        continue
    end
    
    CARSHOP.BuyableCars = tbl
    
    net.Start( "CarDealer_SendChoosenCars" )
        net.WriteTable( CARSHOP.BuyableCars or {} )
    net.Send( player.GetAll() )
end

CARSHOP.NextSwitch = CurTime() + 10
timer.Simple( 5, CARSHOP.CreateCarTable )
function CARSHOP.CarDealerThink()
    if CARSHOP.NextSwitch != nil then
        if CurTime() >= CARSHOP.NextSwitch then
            CARSHOP.CreateCarTable()
        end
    end
end

hook.Add( "PlayerDisconnected", "CarDealerPlayAuthed", function( ply ) CARSHOP.PlayerDisconnected( ply ) end)
hook.Add( "PlayerAuthed", "CarDealerPlayAuthed", CARSHOP.PlayerAuthed )
hook.Add( "Think", "CarDealerThink", CARSHOP.CarDealerThink )