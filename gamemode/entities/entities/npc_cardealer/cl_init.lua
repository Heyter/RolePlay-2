include ("shared.lua")

net.Receive( "carinfo", function()
	local tbl = net.ReadTable()
	tbl.ent.carinfo = tbl.carinfo
end)

net.Receive( "send_garage_table", function()
	local tbl = net.ReadTable()
	LocalPlayer().garage_table = tbl
end)

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
end

function CreateCarSpawnTable()
	CSVehicles.CarSpawns[tostring(game.GetMap())] = {}
	for k, v in pairs( ents.GetAll() ) do
		if !(IsValid( v )) then continue end
		if !(v:GetModel() == "models/tdmcars/rx8.mdl") then continue end
		table.insert( CSVehicles.CarSpawns[tostring(game.GetMap())], {pos=Vector( v:GetPos().x, v:GetPos().y, v:GetPos().z ), ang=Angle( v:GetAngles().p, v:GetAngles().y, v:GetAngles().r)} )
	end
	PrintTable( CSVehicles.CarSpawns[tostring(game.GetMap())] )
	print( "found " .. tostring(#CSVehicles.CarSpawns[tostring(game.GetMap())]) .. " car spawns!" )
end