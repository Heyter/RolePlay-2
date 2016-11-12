function PropSetColor( prop, col )
	prop:SetRenderMode( RENDERMODE_TRANSALPHA )
	prop:SetColor( col )
end

hook.Add("PlayerSpawnedProp", "PD_PlayerSpawnedProp", function( ply, model, ent )
	if !(IsValid( ent )) then ent.health = 0 end
	
	ent.phealth = ent:GetPhysicsObject():GetMass()
	ent.pmaxhealth = ent:GetPhysicsObject():GetMass()
end)

/*
hook.Add("EntityTakeDamage", "PD_EntityTakeDamage", function( ent, info )
	if ent:IsPlayer() then return end
    if !(IsValid( ent )) then return end
    if !(ent:GetClass() == "prop_physics") then return end

	if !(ent.phealth) then 
		ent.phealth = ent:GetPhysicsObject():GetMass()
		ent.pmaxhealth = ent:GetPhysicsObject():GetMass()
	end
	local rech = ent.pmaxhealth/255
	local rech2 = ent.phealth/rech
	
	PropSetColor( ent, Color( rech2, rech2, rech2, 255 ) )
	
	ent.phealth = ent.phealth - (info:GetDamage()/50)
	if ent.phealth <= 0 then
		ent:Remove()
	end
end)
*/