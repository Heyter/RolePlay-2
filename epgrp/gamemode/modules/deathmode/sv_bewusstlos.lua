local verwesung = 60

function HideRag( ply, attacker, dmginfo )
	local deathtime
	
	if dmginfo:GetDamageType() == DMG_CRUSH then
		deathtime = 35
	elseif dmginfo:GetDamageType() == DMG_BULLET then
		deathtime = 60
	elseif dmginfo:GetDamageType() == DMG_SLASH then
		deathtime = 60
	elseif dmginfo:GetDamageType() == DMG_BURN or dmginfo:GetDamageType() == DMG_BLAST then
		deathtime = 40
	elseif dmginfo:GetDamageType() == DMG_FALL then
		deathtime = 120
	else
		deathtime = 60
	end
    
	local model = ply:GetModel()
	local ang = ply:GetAngles()
	local pos = ply:GetPos()
	
	local phys = ply:GetPhysicsObject()
	local vel = phys:GetVelocity()
    local zombierand = math.Rand( 1, 100 )
	
	local Rag = ents.Create( "prop_ragdoll" )
	Rag:SetModel( model )
	Rag:SetPos( pos )
	Rag:SetAngles( ang )
	Rag:Activate()
	Rag:Spawn()
    Rag:SetRPVar( "ply", ply )
    Rag:SetRPVar( "revived", false )
    Rag:SetRPVar( "has_zombievirus", false )
    Rag.HP = 100
	local apvel = Rag:GetPhysicsObject()
	
	ply.ragweps = ply:GetWeapons()
	ply.ragteam = ply:Team()

	apvel:SetVelocity(vel*6)
	
	ply:ConCommand("pp_motionblur 1")
	ply:ConCommand("pp_motionblur_addalpha 0.06 ")
	ply:ConCommand("pp_motionblur_delay 0")
	ply:ConCommand("pp_motionblur_drawalpha 0.99 ")
	
	ply:Spectate( OBS_MODE_CHASE )
	ply:SpectateEntity( Rag )
	
	ply:Lock()
    
    if zombierand == 82 or zombierand == 41 then
        Rag:SetRPVar( "has_zombievirus", true )
    end
    
    timer.Simple( deathtime, function()
        if !(ply:Alive()) then RevivePlayer( Rag ) end
    end)
    
    timer.Create( "Ragdoll_verwesung_" .. Rag:EntIndex(), deathtime + verwesung, 1, function()
        if !(IsValid( Rag )) then return end
        timer.Destroy("ragmoan" .. Rag:EntIndex())
        
        --Rag:SetModel( "models/player/corpse1.mdl" )
        Rag:SetRPVar( "revived", true )
        timer.Create( "Rag_verwesung_flies_" .. Rag:EntIndex(), 5, 0, function()
            if !(IsValid( Rag)) then timer.Destroy( "Rag_verwesung_flies_" .. Rag:EntIndex() ) return end
            Rag:EmitSound( "ambient/creatures/flies" .. math.Round(math.Rand( 1, 5 )) .. ".wav", 100, 100 )
        end)
        Rag:Remove()
        --timer.Simple( 120, function( Rag ) if IsValid( Rag ) then Rag:Remove() end end )
        timer.Destroy( "Ragdoll_verwesung_" .. Rag:EntIndex() )
    end)
	
	return false
end
hook.Add("DoPlayerDeath", "HidePLRagdoll", HideRag)

function RagHit( ent, dmginfo )
    if ent:IsRagdoll() && !(ent:GetRPVar( "revived" )) then
		if dmginfo:GetDamageType() == DMG_CRUSH then return end
		local dmg = dmginfo:GetDamage()
		
		if dmginfo:IsBulletDamage() then dmg = dmg * 2 end
        
        ent.HP = math.Clamp( ent.HP - dmg, 0, 100 )
		
		if ent.HP < 2 then
			RevivePlayer( ent )
		end
		
	end
end
hook.Add( "EntityTakeDamage", "RagHit", RagHit )

function RevivePlayer( rag, medic, admin )
	if !(IsValid( rag )) then return end
	local ply = rag:GetRPVar( "ply" ) or nil
    
    medic = medic or nil
    admin = admin or nil
	
	if (ply == nil) then return end
    if medic && admin == nil then medic:AddCash( SETTINGS.ReviveReward ) medic:RPNotify( "Du bekommst $" .. tostring(SETTINGS.ReviveReward) .. " weil du ein Spieler wiederbelebt hast.", 5 ) end
    
	ply:UnLock()
	ply:Spawn()
    ply:UnSpectate()
	ply:ConCommand("pp_motionblur 0")
    if medic then
        ply:SetHealth(50)
        ply:SetPos(rag:GetPos())
    end
	if medic then rag:Remove() end
	timer.Destroy("ragmoan" .. rag:EntIndex())
	
    rag:SetRPVar( "revived", true )
    hook.Call( "NOSRP_PlayerDeath", {}, ply )
    /*
	if ply:Team() == ply.ragteam then // Changeteam Exploit
		for k, v in pairs(ply.ragweps) do
			if ply:HasWeapon( v:GetClass() ) then continue end
			ply:Give( v:GetClass() )
		end
	end*/
end
/*
hook.Add("PlayerDisconnected", "removeragondisconnect", function( ply )
	for _,v in pairs(ents.FindByClass("prop_ragdoll")) do
		if tostring(ply:SteamID()) == tostring(v:GetNetworkedEntity("ibslp"):SteamID()) then
			timer.Destroy("ragmoan" .. v:EntIndex())
			local effectdata = EffectData()
			effectdata:SetOrigin(v:GetPos())
			util.Effect("balloon_pop", effectdata)
			
			v:EmitSound( "vo/npc/male01/question06.wav", 80, 100 )
			v:Remove()
			break
		end
	end
end)
*/