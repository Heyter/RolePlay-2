TRASHMOD = TRASHMOD or {}

function TRASHMOD.Initialize()
	
	// First random spawns
	TRASHMOD.FillUpSpawns()
	
end

function TRASHMOD.FillUpSpawns()
	for k, v in pairs( TRASHMOD.SETTINGS.SpawnPositions ) do
		timer.Simple( 0.05*k, function()
			local rand = math.Round( math.Rand( 1, TRASHMOD.SETTINGS.MaxPerTimeSpawnings ) )
			
			for i = 1, rand do
				if TRASHMOD.SpawnLimit() then break end		// we got the spawn limit!
				
				local bag = ents.Create( "garbage" )
				bag:SetModel( "models/sligwolf/garbagetruck/sw_trashbag.mdl" )
				bag:SetPos( pos + Vector( math.Rand( -25, 25 ), math.Rand( -25, 25 ), 0) )
				bag.OnEmpty = false
				bag:Activate()
				bag:SetNWVector( "scale", Vector( 1.5, 1.5, 1.5) )
				bag:EnableMotion( true )
				
				timer.Simple( TRASHMOD.SETTINGS.SpawnCooldown - 2, function()
					if bag != nil && IsValid( bag ) then bag:Remove() end
				end)
			end
		end)
	end
end

function TRASHMOD.CreateSpawnTimer()
	timer.Create( "Trashmod_RandomSpawns", TRASHMOD.SETTINGS.SpawnCooldown, 0, function()
		if TRASHMOD.SpawnLimit() then return end
		TRASHMOD.FillUpSpawns()
	end)
end

function TRASHMOD.SpawnLimit()
	return (table.Count(ents.FindByClass( "models/sligwolf/garbagetruck/sw_trashbag.mdl" )) < TRASHMOD.SETTINGS.MaxSpawns)
end