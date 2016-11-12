resource.AddFile( "nosrp/car/wont_start.mp3" )
resource.AddFile( "nosrp/car/start.mp3" )
resource.AddFile( "nosrp/car/stop.mp3" )

hook.Add( "PlayerSpawnedVehicle", "CARS_TurnOff", function( ply, vehicle, fuel )
	if !(IsValid( vehicle )) then return end
	vehicle:Fire( "turnoff", "", 1 )
	vehicle.Owner = ply
    
	if fuel then CreateCarfuel( vehicle ) else vehicle:SetNWInt( "fuel", 100 ) end
end)

hook.Add( "CanPlayerEnterVehicle", "CARS_CanEnterCar",  function( ply, veh, role )
    if veh:Health() < 1 && veh:GetClass() == "prop_vehicle_jeep" then ply:RPNotify( "Dieses Auto muss erst repariert werden!", 5 ) return false end
    if veh.JobCar && ply:Team() == TEAM_CITIZEN && !(veh.Owner:IsBuddy( ply )) then ply:RPNotify( "Du kannst keine Job-Autos klauen!", 5 ) return false end
    return true
end)

hook.Add( "KeyPress", "CARS_KeyPress", function( ply, key )
	if !(key == IN_JUMP) then return end
	if !(ply:InVehicle()) or !(ply:GetVehicle():GetClass() == "prop_vehicle_jeep" or ply:GetVehicle():GetClass() == "prop_vehicle_jeep_old") then return end
	local veh = ply:GetVehicle()
	local fuel = veh:GetNWInt( "fuel" )
	veh.turnedon = veh.turnedon or false
	veh.lastswitch = veh.lastswitch or 0
	if !(CurTime() > veh.lastswitch) then return end
	local data = veh:GetRPVar( "doordata" )
	if !(data) then return end
	
	
	if !(veh.turnedon) && (data.owner == ply or data.owner:IsBuddy( ply )) then // Owner try to turn on car
		if fuel <= 0 then
			veh:EmitSound( "nosrp/car/wont_start.mp3", 100, 100 )  // Cant turn on.
			veh.lastswitch = CurTime() + 3.5
			return
		end
		veh.lastswitch = CurTime() + 6
		veh:EmitSound( "nosrp/car/wont_start.mp3", 100, 100) // Start Engine!
		timer.Simple( 3.5, function() veh:EmitSound( "nosrp/car/start.mp3", 100, 100) end )
		timer.Simple( 5, function()
			veh:Fire("turnon", "", 0)
			veh.turnedon = true
		end)
	elseif !(veh.turnedon) && data.owner != ply then // Rober try to turn on car
		if fuel <= 0 then
			veh:EmitSound( "", 100, 100 )  // Cant turn on.
			veh.lastswitch = CurTime() + 3.5
			return
		end
		veh.lastswitch = CurTime() + 3.5
		veh:EmitSound( "nosrp/car/wont_start.mp3", 100, 100 )  // snap cables together
		local rand = math.Round(math.Rand( 1, 6 ))
		if rand == 4 then
			veh.lastswitch = CurTime() + 6
			timer.Simple( 3.5, function() veh:EmitSound( "nosrp/car/start.mp3", 100, 100) end )
			timer.Simple( 5, function()
				veh:Fire("turnon", "", 0)
				veh.turnedon = true
			end)
		end
	elseif veh.turnedon && (data.owner == ply or data.owner:IsBuddy( ply )) then // Rober try to turn on car
		veh.lastswitch = CurTime() + 3
		veh:EmitSound( "nosrp/car/stop.mp3", 100, 100) // Start Engine!
		veh:Fire("turnoff", "", 0)
		veh.turnedon = false
	elseif veh.turnedon && data.owner != ply then // Rober try to turn on car
		veh.lastswitch = CurTime() + 3
		veh:EmitSound( "nosrp/car/stop.mp3", 100, 100) // Start Engine!
		veh:Fire("turnoff", "", 0)
		veh.turnedon = false
	end
end)

function CreateCarfuel( car )
    local ply = car.Owner
    local cartbl = ply:GetRPVar( "garage_table" )[car:GetTable().VehicleName]
    car:SetNWInt("fuel", cartbl.Fuel)
    timer.Create("CheckCarfuel" .. car:EntIndex(), 10, 0, function()
        if !( IsValid( car )) then timer.Destroy("CheckCarfuel" .. car:EntIndex()) car:Remove() return end
        if !(car.Owner or IsValid( car.Owner )) then timer.Destroy("CheckCarfuel" .. car:EntIndex()) car:Remove() end
        car.destructed = car.destructed or false
        if car.destructed then return end
        
        local vehicleVel = car:GetVelocity():Length()
        local vehicleConv = -1
        local terminal = 0
               
        terminal = math.Clamp(vehicleVel/2000, 0, 1)
        vehicleConv = math.Round(vehicleVel / 10)
        
        local carfuel = car:GetNWInt("fuel")
        local iscarempty = car:GetNWBool("Empty")
        if (vehicleConv > 2 and IsValid( car )) and car.turnedon and IsValid( car:GetDriver() ) then -- Wenn er in bewegung ist, Valid ist und der Tank nicht leer ist
            if carfuel > 0 then 
                carfuel = carfuel - ( 0.01 * vehicleConv )
                car:SetNWInt("fuel", carfuel)
                Query( string.format( "UPDATE garage SET Fuel='%s' WHERE player_sid='%s' AND carname='%s'", carfuel, tostring(car.Owner:SteamID()), tostring(car.VehicleName)), function() end )
            else
                car:EmitSound("vehicles/apc/apc_shutdown.wav")
                car:Fire("TurnOff", "1", 0)
            end
        elseif IsValid( car ) and car.turnedon then
            if carfuel > 0 then 
                carfuel = carfuel - 0.01
                car:SetNWInt("fuel", carfuel)
                Query( string.format( "UPDATE garage SET Fuel='%s' WHERE player_sid='%s' AND carname='%s'", carfuel, tostring(car.Owner:SteamID()), tostring(car.VehicleName)), function() end )
            else
                car:EmitSound("vehicles/apc/apc_shutdown.wav")
                car:Fire("TurnOff", "1", 0)
            end
        end
    end)
end

function ENTITY_META:CheckCarHealth()
    self.destructed = self.destructed or false
    if self:Health() < 1 && !(self.destructed) then self.destructed = true self:ExplodeCar() end
end

function ENTITY_META:ExplodeCar()
    if self:Health() < 0 then return end
    self:SetHealth( -1 )
    self:SetRPVar( "Armor", 0 )
    self.JobCar = self.JobCar or false
    if !(self.JobCar) then CARSHOP.SaveCar( self ) end
    self:SetMaterial( "metal/metalwall062a" )
    self:SetColor( Color( 0, 0, 0, 255 ) )
    
    if IsValid(self:GetDriver()) then self:GetDriver():ExitVehicle() end
    util.BlastDamage( self, self, self:GetPos(), CARSHOP.CONFIG.ExplodeRadius, 150 ) 
    
    self:Fire( "lock", 1 )
    self:Fire( "turnoff", 1 )
    
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetOrigin( vPoint )
    util.Effect( "explosion_car", effectdata )
    
    local pos = self:GetPos()
    local r = math.Rand( 1, 5 )
    
    for i=1, r do   // Random Fire
        local f = ents.Create( "ent_fire" )
        f:SetPos( Vector( math.Rand( pos.x - 100, pos.x + 100 ), math.Rand( pos.y - 100, pos.y + 100 ), pos.z ) )
        f:Spawn()
    end
    
    self:GetPhysicsObject():ApplyForceCenter( (self:GetPhysicsObject():GetMass()*self:GetUp()) * 500 )
    
    --local tbl = self.Owner:GetRPVar( "garage_table" )[self:GetTable().VehicleName]
    --tbl.repair = os.time() + CARSHOP.CONFIG.RepairTime
    --self:SetRPVar( "garage_table", tbl )
end

hook.Add( "EntityTakeDamage", "VehicleDamageMod", function( ent, info )
    if !(IsValid( ent )) then return info end
    if ent:IsVehicle() then
        ent.JobCar = ent.JobCar or false
        if !(ent.JobCar) and !(ent.VehicleTable) or ent.VehicleTable == nil then return info end
        
        local armor = ent:GetRPVar( "Armor" )
        local Health = ent:Health()
        local Type = info:GetDamageType( )
        armor = armor or 0
        
        if info:IsBulletDamage() then
            info:ScaleDamage( 1000 )
            info:SetDamage( info:GetDamage() )
        end
      
        if armor > 0 then
            info:ScaleDamage( 0.8 )
            ent:SetRPVar( "Armor", math.Clamp(armor - 3, 0, 9999) )
            ent:SetHealth( Health - info:GetDamage() )
            ent:CheckCarHealth()
            print( ammor )
            print( Health )
            return info
        end
        
        if Type == DMG_BULLET then info:ScaleDamage( 0.7 ) end
        if Type == DMG_SLASH then info:ScaleDamage( 0.2 ) end
        if Type == DMG_BURN then info:ScaleDamage( 0.4 ) end
        if Type == DMG_VEHICLE then info:ScaleDamage( 0.6 ) end
        if Type == DMG_BLAST then info:ScaleDamage( 1.2 ) end
        if Type == DMG_CLUB then info:ScaleDamage( 0.2 ) end
        if Type == DMG_SHOCK then info:ScaleDamage( 0.2 ) end
        
        ent:SetHealth( math.Clamp(Health - info:GetDamage(), 0, 9999999) )
        print( ammor )
        print( Health )
        ent:CheckCarHealth()
        
        return info
    end
end)

hook.Add("PlayerSpawnedVehicle", "BuildTowTruck", function( ply, veh )
	if (IsValid( veh ) && veh:GetModel() == "models/tdmcars/trucks/scania_high.mdl") then
        veh:SetColor(Color(186, 136, 0, 255))
        
        local towholder = ents.Create("prop_physics")
        towholder:SetModel( "models/sligwolf/towtruckaddon/crane.mdl" )
        towholder:SetPos(veh:LocalToWorld(Vector(0, 0, 0)))
        towholder:SetAngles(veh:LocalToWorldAngles(Angle(0,180,0)))
        towholder:Spawn()
        constraint.NoCollide( towholder, veh, 0, 0 )
        constraint.Weld(veh, towholder, 0, 0, 0, 0)
        towholder:Activate()
        towholder:GetPhysicsObject():SetMass( 1000 )
        veh:DeleteOnRemove( towholder )

        local obj = towholder:LookupAttachment( "RopePos1" )
        local ropepos = towholder:GetAttachment( obj )
        
        local towhook = ents.Create("tow_hook")
        towhook:SetPos(ropepos.Pos + Vector( 0, 0, -50 ))
        towhook:SetAngles(veh:LocalToWorldAngles(Angle(0,0,0)))
        towhook:Spawn()
        towhook.truck = veh
        towhook.holder = towholder
        towhook:Activate()
        veh:DeleteOnRemove( towhook )
        
        veh.Hook = towhook
        veh.Holder = towholder
        veh.rope_begin = towholder:WorldToLocal(ropepos.Pos)
        
        local commandbox = ents.Create( "tow_commandbox" )
        commandbox:SetPos(veh:LocalToWorld(Vector(-45, -35, 30)))
        commandbox:SetAngles(veh:LocalToWorldAngles(Angle(0,180,0)))
        commandbox:Spawn()
        constraint.NoCollide( commandbox, veh, 0, 0 )
        constraint.NoCollide( commandbox, towholder, 0, 0 )
        constraint.Weld(veh, commandbox, 0, 0, 0, 0)
        commandbox:Activate()
        veh:DeleteOnRemove( commandbox )
        
        if !(ply:IsAdmin()) then
            for k, v in pairs(ents.GetAll()) do
                if v:IsVehicle() && IsValid( v ) && v != veh && v:GetModel() == "models/tdmcars/trucks/scania_high.mdl" then
                    v:Remove()
                end
            end
        end
	end
end)
