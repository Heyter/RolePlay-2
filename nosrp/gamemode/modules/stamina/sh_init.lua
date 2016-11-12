Stamina = {}
Stamina.Sound = nil
Stamina.LastSound = CurTime()

if SERVER then
	function PLAYER_META:IsRunning()
		return self:KeyDown( IN_SPEED ) and (self:GetVelocity():Length() > 2 && not self:InVehicle())
	end

	function PLAYER_META:StaminaCooldown( bool )
		self.staminacooldown = bool
	end

	function PLAYER_META:HasStaminaCooldown()
		return self.staminacooldown
	end

	function Stamina.GetStamina( ply )
		return math.Round( math.min( ply:GetNWInt( "stamina" ) ) )
	end

	function Stamina.PlayerInitialize( ply )
	   if IsValid( ply ) then
		   ply:SetNWInt( "stamina", 100 )
		   ply.defaultrunspeed = ply:GetRunSpeed()
		   timer.Create( ply:UniqueID() .. "_staminacheck", SETTINGS.STAMINA_REFILL_SPEED, 0, function() Stamina.Check( ply ) end )
	   end
	end
	hook.Add( "PlayerInitialSpawn", "NOS Stamina Timer", Stamina.PlayerInitialize )

	function Stamina.Check( ply )
		if IsValid( ply ) then
		   	ply:SendLua('Stamina.PlayExhaustSound()')	   	   // Play Sound if needend
		   
		   	if ply:GetNWInt( "stamina" ) > 0 then
			   	if ply:IsRunning() then
				   	if not ply:HasStaminaCooldown() then
					  	local skill = math.Clamp( (ply:GetSkill( "Ausdauer" ) or 0)/100, 0, 100 )
					   	ply:SetNWInt( "stamina", ply:GetNWInt( "stamina" ) - (SETTINGS.STAMINA_REFILL_DRAIN - (SETTINGS.STAMINA_REFILL_DRAIN*skill)) )
				   	end
			   	end
		   	else
			   	ply:SetRunSpeed( ply:GetWalkSpeed() )
		   	end
		
			ply.cuffed = ply.cuffed or false
		   	if ply:GetNWInt( "stamina" ) >= 15 && !(ply.cuffed) then
				local speed = 0
				if ply:HasBrokenLegs() > 0 then speed = SETTINGS.CrippledRunSpeed else speed = SETTINGS.RunSpeed end
			
			   	ply:SetRunSpeed( speed )
			  	ply:StaminaCooldown( false )
		   	end

		   	if ply:GetNWInt( "stamina" ) <= 0 then
			   	ply:StaminaCooldown( true )
		   	end
		
		   	if not ply:IsRunning() or ply:HasStaminaCooldown() then
			   	if ply:GetNWInt( "stamina" ) < 100 then
				   	ply:SetNWInt( "stamina", math.Clamp( ply:GetNWInt( "stamina" ) + SETTINGS.STAMINA_REFILL_REFILLAMD, 0, 100 ) )
				   
				   	// Stamina EXP
				   	ply.stamina_exp = ply.stamina_exp or 0
				   	ply.stamina_exp = ply.stamina_exp + SETTINGS.STAMINA_REFILL_REFILLAMD
				   	if ply.stamina_exp >= SETTINGS.STAMINA_EXP_GIVE_AT then
					   	local exp = ply.stamina_exp / SETTINGS.STAMINA_EXP
					   	ply.stamina_exp = 0
					   
					   	ply:SetSkill( "Ausdauer", exp, true )
				   	end
			   	end
		   	end
	   	else
		   	timer.Destroy( ply:UniqueID() .. "_staminacheck" )
		   	return
	   	end
	end
end

if CLIENT then
	function Stamina.PlayExhaustSound()
		if Stamina and IsValid(LocalPlayer()) then
			local stamina = LocalPlayer():GetNWInt( "stamina" )
			if stamina <= 40 then
				if !Stamina.Sound then
					Stamina.Sound = CreateSound(LocalPlayer(), Sound( SETTINGS.STAMINA_SOUND ))
				end
				
				local rech = 2/stamina
				
				Stamina.LastSound = Stamina.LastSound or 0;
				
				if Stamina.LastSound + SETTINGS.STAMINA_REPLAY <= CurTime() then
					Stamina.LastSound = CurTime();
					if not Stamina.Sound:IsPlaying() then
						Stamina.Sound:Stop();
						Stamina.Sound:Play();
					end
					Stamina.Sound:ChangeVolume( math.Clamp(rech, 0, 0.8), 0 )
				end
			elseif Stamina.Sound then
				Stamina.Sound:Stop();
				Stamina.Sound = nil;
			end
		end
	end
	
	hook.Add( "RenderScreenspaceEffects", "stamina_blur", function()
		local stamina = LocalPlayer():GetNWInt( "stamina" )
		local r = (0.6 / 30) * ( 30 - stamina )
		
		if stamina < 30 then
			DrawMotionBlur( 0.15, r, 0.01 )
		end
	end)
end