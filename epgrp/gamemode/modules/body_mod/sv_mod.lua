function PLAYER_META:HasBrokenLegs()  
    if (self:GetRPVar( "hit_lleg" ) or false) then return 1 end
    if (self:GetRPVar( "hit_rleg" ) or false) then return 2 end
    return 0
end

function PLAYER_META:FixLegs()
	self:SetRPVar("hit_rleg", false)
    self:SetRPVar("hit_lleg", false)
	self:SetRunSpeed(SETTINGS.RunSpeed)
	self:SetWalkSpeed(SETTINGS.WalkSpeed)
end

function PLAYER_META:FixArms()
	self:SetRPVar("hit_rarm", false)
    self:SetRPVar("hit_larm", false)
end

function PLAYER_META:FixBleeding()
    self:SetRPVar("hit_bleeding", false)
end

function PLAYER_META:DoChanceBleeding()
    local b = math.Round(math.Rand( 1, 15 ))
    if b == 7 then
        self:AddBleeding()
        return true
    end
    return false
end

function PLAYER_META:AddBleeding()
    self:SetRPVar("hit_bleeding", true)
end

function PLAYER_META:BreakLegs( code )
    local Player = self
    code = code or 3
    
    if code == 1 then
        Player:SetRPVar("hit_lleg", true)
        if !(Player:GetRPVar("hit_lleg") or false) then Player:RPNotify("Dein linkes Bein wurde verletzt!", 5); end
    elseif code == 2 then
        Player:SetRPVar("hit_rleg", true)
        if !(Player:GetRPVar("hit_rleg") or false) then Player:RPNotify("Dein rechtes Bein wurde verletzt!", 5); end
    else
        Player:SetRPVar("hit_rleg", true)
        Player:SetRPVar("hit_lleg", true)
        if !(Player:GetRPVar("hit_rleg") or false) && !(Player:GetRPVar("hit_rleg") or false) then Player:RPNotify("Du hast dir deine Beine gebrochen!", 5); end
    end
    
    Player:EmitSound( "nosrp/human_sounds/bone_crush_hurt.wav", 50, 90 )
    Player:DoChanceBleeding()
end

hook.Add( "PlayerSpawn", "FIX_BODY", function( ply )
    ply:FixLegs()
    ply:FixArms()
    ply:FixBleeding()
end)

function ErmitHitSound( Player, HitGroup, DmgInfo )
	local attacker = DmgInfo:GetAttacker()

	local MoanFile

    if DmgInfo:GetDamageType() == DMG_FALL then
        Player:BreakLegs()
    end
	
	if (Player:Alive()) then
        local r = math.Round(math.Rand(-3, 3))
        local r2 = math.Round(math.Rand(-3, 3))
        local r3 = math.Round(math.Rand(-3, 3))
        Player:ViewPunch( Angle( r, r2, r3 ) )
        
		if (HitGroup == HITGROUP_HEAD) then
                DmgInfo:ScaleDamage(100);
				MoanFile = Sound("vo/npc/male01/ow0"..math.random(1, 2)..".wav");				
		elseif (HitGroup == HITGROUP_CHEST or HitGroup == HITGROUP_GENERIC) then
                Player:DoChanceBleeding()
				MoanFile = Sound("vo/npc/male01/hitingut0"..math.random(1, 2)..".wav");
		elseif (HitGroup == HITGROUP_LEFTARM) then
                Player:SetRPVar( "hit_larm", true )
                Player:DoChanceBleeding()
				MoanFile = Sound("vo/npc/male01/myarm0"..math.random(1, 2)..".wav");
        elseif HitGroup == HITGROUP_RIGHTARM then
                Player:SetRPVar( "hit_rarm", true )
                Player:DoChanceBleeding()
                MoanFile = Sound("vo/npc/male01/myarm0"..math.random(1, 2)..".wav");
		elseif (HitGroup == HITGROUP_GEAR) then
				MoanFile = Sound("vo/npc/male01/startle0"..math.random(1, 2)..".wav");
		elseif (HitGroup == HITGROUP_LEFTLEG and !(Player:HasBrokenLegs() == 2)) then
			if !((Player:GetRPVar("hit_lleg") or false)) then
                Player:BreakLegs( 1 )
                Player:SetRunSpeed(SETTINGS.CrippledRunSpeed)
                Player:SetWalkSpeed(SETTINGS.CrippledWalkSpeed)
			end
			
				MoanFile = Sound('vo/npc/male01/myleg0' .. math.random(1, 2) .. '.wav');
        elseif (HitGroup == HITGROUP_RIGHTLEG and !(Player:HasBrokenLegs() == 2)) then
			if !((Player:GetRPVar("hit_rleg") or false)) then
                Player:BreakLegs( 2 )
                Player:SetRunSpeed(SETTINGS.CrippledRunSpeed)
                Player:SetWalkSpeed(SETTINGS.CrippledWalkSpeed)
			end
			
				MoanFile = Sound('vo/npc/male01/myleg0' .. math.random(1, 2) .. '.wav');
		else
				MoanFile = Sound("vo/npc/male01/pain0"..math.random(1, 9)..".wav");
		end
		
		sound.Play( MoanFile, Player:GetPos(), 100, 100, 1 )
	
		DmgInfo:ScaleDamage(1.5)
	
	return DmgInfo
end
end
hook.Add("ScalePlayerDamage", "ErmitHitSound", ErmitHitSound)

hook.Add( "Think", "HIT_Bleeding", function()
    for k, v in pairs( player.GetAll() ) do
        if !(v:GetRPVar( "hit_bleeding" ) or false) then continue end
        v.hit_bleed_next = v.hit_bleed_next or CurTime() + 10
        if CurTime() < v.hit_bleed_next then continue end
        
        local rand = math.Round(math.Rand( 1, 3 ))
        v:SetHealth( v:Health() - rand )
        v:ViewPunch( Angle( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ) )
        if v:Health() < 1 && v:Alive() then v:RPNotify( "Du bist verblutet!", 10 ) v:Kill() end
        v.hit_bleed_next = CurTime() + 10
        continue
    end
end)