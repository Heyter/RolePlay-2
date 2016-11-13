AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/alien_nl/busstop/busstop.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
    self.useable = true
    
end

concommand.Add( "SaveBusStop", function( ply, cmd, args )
    if !(ply:IsSuperAdmin()) then return end
    local trace = ply:GetEyeTraceNoCursor()
    local ent = trace.Entity
    
    if !(IsValid( ent )) then return end
    if !(args[1]) then return end
    if !(args[2]) then return end
    
    local pos = tostring( ent:GetPos().x ) .. " " .. tostring( ent:GetPos().y ) .. " " .. tostring( ent:GetPos().z )
    local ang = tostring( ent:GetAngles().p ) .. " " .. tostring( ent:GetAngles().y ) .. " " .. tostring( ent:GetAngles().r )
    
    Query( "INSERT INTO busstops( name, cost, pos, ang) VALUES('" .. args[1] .. "'," .. tonumber(args[2]) .. ",'" .. pos .. "','" .. ang .. "')" )
end)

function ENT:Think()
    for k, v in pairs( BUSSTOP.TRAVELS ) do
        if !(IsValid( v.ply )) then table.remove( BUSSTOP.TRAVELS, k ) continue end
        if v.from:GetPos():Distance( v.ply:GetPos() ) >= 70 && v.start > (CurTime() + 1) then
            net.Start( "BUSSTOP_FinishTravel" )
                net.WriteString( "1" )
            net.Send( v.ply )
            table.remove( BUSSTOP.TRAVELS, k ) 
            continue
        end
        if v.start > (CurTime() - 0.5) then continue end
        
        net.Start( "BUSSTOP_FinishTravel" )
            net.WriteString( "0" )
        net.Send( v.ply )
        
        v.ply:SetPos( v.target:LocalToWorld( Vector( 30, math.Rand( -20, 20 ), 0 ) ) )
        table.remove( BUSSTOP.TRAVELS, k )
        if !(v.ply:CanAfford( v.cost )) then v.ply:SetStars( v.ply, 2, true ) v.ply:SetCash( 0 ) else v.ply:AddCash( v.cost ) end
        continue
    end
end