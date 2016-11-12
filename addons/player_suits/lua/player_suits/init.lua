include( "mysql.lua" )
include( "config.lua" )

AddCSLuaFile( "config.lua" )


hook.Add( "Initialize", "PSuit_ConnectDatabase", function()
	timer.Simple( 5, function()
		InitializeDatabase()
	end)
end)

function LoadSuits()
	local map = game.GetMap()
	local suits = {}
	
	Query( "SELECT * IN suits WHERE map='" .. tostring(map) .. "'", function( data )
		suits = data
		print( tostring( data ) )
	end, function() print( "Error, can't load suits!") end)
	
	for k, v in pairs( suits ) do
		local ent = ents.Create( "suit_admin")
		ent:SetPos( Vector( v.admin_x, v.admin_y, v.admin_z ) )
		ent:SetAngles( Vector( v.admina_y, v.admina_p, v.admina_r ) )
		ent:Spawn()
	end
end