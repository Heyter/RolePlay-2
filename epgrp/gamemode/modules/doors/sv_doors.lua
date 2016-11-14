local meta = FindMetaTable( "Player" )

util.AddNetworkString( "SendDoorTable" )
util.AddNetworkString( "RequestDoorTable" )

net.Receive( "RequestDoorTable", function( len, ply )
	net.Start( "SendDoorTable" )
		net.WriteTable( RP.Doors or {} )
	net.Send( ply )
end)

hook.Add( "PlayerDisconnected", "RemoveOwnedDoors", function( ply )
	for k, v in pairs( RP.Doors ) do
        local doordata = v.door:GetRPVar( "doordata" )
	    if doordata.owner == ply then
	      	--v.door:SetRPVar( "doordata", {owner=nil, title=v.title, cost=v.cost, teams=v.teams, pos=v.position, subdoors=v.subdoors, locked=v.locked, door=v.door} )
            ply:UnownDoor( v.door )
	    end
    end
end)

function LoadDoors()
	Query("SELECT * FROM Doors", function(q)
        RP.Doors = {}
        
        for k, v in pairs( q ) do
            local door = FindDoor( CompareVector( v.position ) )
            if door == nil then continue end
            if !(IsValid( door )) then continue end
            
            timer.Simple( (0.1*k), function()
                door:SetRPVar( "doordata", {owner=nil, title=v.title, cost=v.cost, teams=util.JSONToTable(v.teams), pos=v.position, subdoors=util.JSONToTable(v.subdoors), locked=v.locked, door=door} )
                EditDoorTable( door, {owner=nil, title=v.title, cost=v.cost, teams=util.JSONToTable(v.teams), pos=v.position, subdoors=util.JSONToTable(v.subdoors), locked=v.locked, door=door} )
                OwnSubDoors( door, nil )
            end)
        end
        print( "Loading doors ... takes: " .. tostring(0.1*(#q)) .. " seconds!" )
    end)
end

function meta:OwnDoor( door )
	if !(IsValid( door )) then return false end
	if !(IsDoor( door )) then return false end
	
	local doordata = door:GetRPVar( "doordata" )
	if !(doordata.owner == nil) or #doordata.teams > 0 then return false end
	if !(self:CanAfford( doordata.cost )) then return false end
	
	self:AddCash( -doordata.cost )
	
	local v = doordata
	door:SetRPVar( "doordata", {owner=self, title=v.title, cost=v.cost, teams=v.teams, pos=v.position, subdoors=v.subdoors, locked=v.locked, door=door} )
	EditDoorTable( door, {owner=self, title=v.title, cost=v.cost, teams=v.teams, pos=v.position, subdoors=v.subdoors, locked=v.locked, door=door} )
	
	OwnSubDoors( door, self )
	return true
end

function meta:UnownDoor( door )
	if !(IsValid( door )) then return false end
	if !(IsDoor( door )) then return false end
	
	local doordata = door:GetRPVar( "doordata" )
	if !(IsValid( doordata.owner )) or !(doordata.owner == self) then return false end
	
	local v = doordata
    
    self:AddCash( v.cost / 2 )
    
	door:SetRPVar( "doordata", {owner=nil, title=v.title, cost=v.cost, teams=v.teams, pos=v.position, subdoors=v.subdoors, locked=v.locked, door=door} )
	EditDoorTable( door, {owner=nil, title=v.title, cost=v.cost, teams=v.teams, pos=v.position, subdoors=v.subdoors, locked=v.locked, door=door} )
	
	OwnSubDoors( door, nil )
	return true
end


function CacheMasterDoor( ply, cmd, args )
	if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
	
	ply.mdoorcache = tr.Entity
end
concommand.Add( "RP_cachedoor", CacheMasterDoor )

function AddSubDoor( ply, cmd, args )
	if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
	
	ply.mdoorcache = ply.mdoorcache or nil
	if ply.mdoorcache == nil then return end
	
	--owner=owner, title=v.title, cost=v.cost, teams=v.teams, position=v.position, subdoors=v.subdoors, locked=v.locked, masterdoor=master, door=door
	
	local door = ply.mdoorcache:GetRPVar( "doordata" )
	
	for k, v in pairs( door.subdoors ) do
		if tostring(v) == tostring(tr.Entity:GetPos()) then table.remove( door.subdoors, k ) end
	end
	
	table.insert( door.subdoors, tostring(tr.Entity:GetPos()) )
	
	door.door:SetRPVar( "doordata", door )
	
	Query("UPDATE Doors SET subdoors='" .. tostring(util.TableToJSON( door.subdoors )) .. "' WHERE position='" .. door.pos .. "'")
	
	LoadDoors()
end
concommand.Add( "RP_addsubdoor", AddSubDoor )

function CreateMasterDoor( ply, cmd, args )
	if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
    
    local teams = {}
    if #args > 2 then
        for i=2, #args do
            table.insert( teams, tostring(args[i]) )
        end
    end
    teams = util.TableToJSON( teams )
	
	Query("SELECT * FROM Doors", function(q)
        for k, v in pairs( q ) do
            Query("DELETE FROM Doors WHERE position='" .. tostring( tr.Entity:GetPos() ) .. "'", function() end)
        end
		
		Query("INSERT INTO Doors(title, cost, teams, position, subdoors, locked) VALUES('" .. tostring(args[1]) .. "'," .. tonumber(args[2]) .. ",'" .. teams .. "','" .. tostring(tr.Entity:GetPos()) .. "','" .. tostring("[]") .. "'," .. 0 .. ")", function() LoadDoors() end)
    end)
end
concommand.Add( "RP_createmasterdoor", CreateMasterDoor )

function CM_OwnDoor( ply, cmd, args )
	if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
	
	ply:OwnDoor( tr.Entity )
end
concommand.Add( "RP_owndoor", CM_OwnDoor )

function CM_UnownDoor( ply, cmd, args )
	if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
	
	ply:UnownDoor( tr.Entity )
end
concommand.Add( "RP_unowndoor", CM_UnownDoor )

/*///////////////////////////////////////
	Don't touch Functions!
//////////////////////////////////////*/

function EditDoorTable( door, tbl )
	local found = false
	for k, v in pairs( RP.Doors ) do
		if v.door == door then
			found = true
			RP.Doors[k] = tbl
		end
	end
	if !(found) then table.insert( RP.Doors, tbl ) end
	
	net.Start( "SendDoorTable" )
		net.WriteTable( RP.Doors )
	net.Send( player.GetAll() )
end

function OwnSubDoors( master, owner )
	local doordata = master:GetRPVar( "doordata" )
	
	for k, pos in pairs( doordata.subdoors ) do
		local door = FindDoor( CompareVector( pos ) )
        if !(IsValid( door )) then continue end
		door:SetRPVar( "doordata", {owner=owner, title=doordata.title, cost=doordata.cost, teams=doordata.teams, pos=doordata.position, subdoors=doordata.subdoors, locked=doordata.locked, masterdoor=master, door=door} )
	end
end

function GM:PlayerSpawnedVehicle( ply, veh )
    veh:SetRPVar( "owner", ply )
    veh:SetRPVar( "doordata", {owner=ply, locked=true} )
    veh:Fire("lock", "", 1)
end

function CM_AddDoorTeam( ply, cmd, args )
    if !(ply:IsAdmin()) then return end
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*100
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
	if !(IsValid( tr.Entity )) then return end
	if !(IsDoor( tr.Entity )) then return end
    local data = tr.Entity:GetRPVar( "doordata" )
    if !(data) or data == nil then return end
    if data.masterdoor or data.masterdoor != nil then return end
    if !(args[1]) then return end
    
    local teams = data.teams
    
    for k, v in pairs( teams ) do
        if tostring(v) == tostring(args[1]) then return end
    end
    
    table.insert( teams, args[1] )
    
    data.door:SetRPVar( "doordata", {owner=data.owner, title=data.title, cost=data.cost, teams=teams, pos=data.pos, subdoors=data.subdoors, locked=data.locked, door=tr.Entity} )
    
    for k, pos in pairs( data.subdoors ) do
        local sdoor = FindDoor( CompareVector( pos ) )
        local doordata = sdoor:GetRPVar( "doordata" )
        if !(IsValid( sdoor )) then continue end
        sdoor:SetRPVar( "doordata", {owner=owner, title=doordata.title, cost=doordata.cost, teams=teams, pos=doordata.pos, subdoors=doordata.subdoors, locked=doordata.locked, masterdoor=tr.Entity, door=sdoor} )
    end
    
    Query("UPDATE Doors SET teams='" .. tostring(util.TableToJSON( teams )) .. "' WHERE position='" .. data.pos .. "'")
end
concommand.Add( "RP_adddoorteam", CM_AddDoorTeam )

/*///////////////////////////////////////
	Sell & Purchase of Doors
//////////////////////////////////////*/

util.AddNetworkString( "PurchaseHouse" )
util.AddNetworkString( "SellHouse" )

net.Receive( "PurchaseHouse", function( len, ply )
	local index = tonumber(net.ReadString()) or nil
	
	if !(IsValid( ply )) then return end
	if index == nil then return end
	
	if ply:OwnDoor( RP.Doors[index].door ) then ply:RPNotify( "Du hast das Haus Erfolgreich erworben!", 5 ) end
end)

net.Receive( "SellHouse", function( len, ply )
	local index = tonumber(net.ReadString()) or nil
	
	if !(IsValid( ply )) then return end
	if index == nil then return end
	
	if ply:UnownDoor( RP.Doors[index].door ) then ply:RPNotify( "Du hast dein Haus Erfolgreich verkauft!", 5 ) end
end)

/*///////////////////////////////////////
	Lock & Unlock of Doors
//////////////////////////////////////*/

function PLAYER_META:LockDoor( door )
    if !(IsValid( self )) then return end
    if !(IsValid( door )) then return end
    if !(IsDoor( door )) then return end
    
    local data = door:GetRPVar( "doordata" )
    if !(data) or data == nil then return end
    if door:GetNWInt("Welded") >= 1 then self:RPNotify( "Diese Tür wurde verschweißt!", 5 ) return false end
    if door:IsVehicle() && (data.owner == self or data.owner:IsBuddy( self )) then
        door:Fire( "lock", "", 1 )
        return true
    end

    if data and data.owner and IsValid(data.owner) then
    	if !(door:IsVehicle()) && data.owner == self or data.owner:IsBuddy( self ) then
	        door:Fire( "lock", "", 1 )
	        return true
	    end
	    
	    local master = data.masterdoor
	    if !(IsValid( master )) then return end
	    
	    local teams = data.teams
	    
	    if master.owner == self then
	        door:Fire( "lock", "", 1 )
	        return true
	    else
	        for k, v in pairs( teams ) do
	            if self:Team() == GetTeamByEnum( v ) then
	                door:Fire( "lock", "", 1 )
	                return true
	            end
	        end
	    end  
    end
    
    return false
end

function PLAYER_META:UnLockDoor( door )
    if !(IsValid( self )) then return end
    if !(IsValid( door )) then return end
    if !(IsDoor( door )) then return end
    
    local data = door:GetRPVar( "doordata" )
    if !(data) or data == nil then return end
    if door:GetNWInt("Welded") >= 1 then self:RPNotify( "Diese Tür wurde verschweißt!", 5 ) return false end
    if door:IsVehicle() && (data.owner == self or data.owner:IsBuddy( self )) then
        door:Fire( "unlock", "", 1 )
        return true
    end
    
    if !(door:IsVehicle()) && data.owner == self or data.owner:IsBuddy( self ) then
        door:Fire( "unlock", "", 1 )
        return true
    end
    
    local master = data.masterdoor
    if !(IsValid( master )) then return end
    
    local teams = data.teams
    
    if master.owner == self then
        door:Fire( "unlock", "", 1 )
        return true
    else
        for k, v in pairs( teams ) do
            if self:Team() == GetTeamByEnum( v ) then
                door:Fire( "unlock", "", 1 )
                return true
            end
        end
    end
    return false
end
