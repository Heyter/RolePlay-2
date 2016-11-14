
if Signs.RemoveOnDisconnect then
	timer.Create( "sv_signs_cleanup", 5, 0, function()
		for _, ent in pairs( ents.GetAll() ) do
			if IsValid( ent ) and (ent.Base == "signs_base" or ent.Base == "signs_ticker_base") and 
				ent.Owned and ent.Getowning_ent and !IsValid( ent:Getowning_ent() ) then

				ent:Remove()
			end
		end
	end )
else
	hook.Add( "PlayerInitialSpawn", "sv_rprotect_setowner", function( ply )
		local sid = ply:SteamID()

		for _, ent in pairs( ents.GetAll() ) do
			if (
				IsValid( ent ) and 
				(ent.Base == "signs_base" or ent.Base == "signs_ticker_base") and 
				ent.OwnerSteamID == sid
			) then
				ent:Setowning_ent( ply )

				if ent.CPPISetOwner then
					ent:CPPISetOwner( ply )
				end
			end
		end
	end )
end

local function HasPerm(ply)
	local allowedgroups = {"superadmin", "moderator"}
	
	for k,v in pairs(allowedgroups) do
		if ply:IsUserGroup(v) then
			return true
		end
	end
	
	return false
end

local function getPermSigns()
	return util.JSONToTable( file.Read( "perm_signs/" .. game.GetMap() .. ".txt" ) or '' ) or {}
end

concommand.Add( "signs_perm", function( ply )
	if !IsValid( ply ) or !HasPerm(ply) then return end

	local ent = ply:GetEyeTrace().Entity

	if !IsValid( ent ) then return end

	local signs = getPermSigns()
	local psid = tostring( ent._permSignId or (table.Count( signs ) + 1) ) -- update old id or generate new one

	if ent.Base == "signs_base" then
		signs[psid] = {
			class = ent:GetClass(),
			pos = ent:GetPos(),
			ang = ent:GetAngles(),

			backgroundColor = ent:GetBackgroundColor(),
			imageUrl = ent:GetImageUrl(),
			imageCropMode = ent:GetImageCropMode(),
			textOverlays = ent:GetTextOverlays(),
			url = ent:GetInteractionUrl()
		}
	elseif ent.Base == "signs_ticker_base" then
		signs[psid] = {
			class = ent:GetClass(),
			pos = ent:GetPos(),
			ang = ent:GetAngles(),

			backgroundColor = ent:GetBackgroundColor(),
			text = ent:GetText(),
			textColor = ent:GetTextColor(),
			textSpeed = ent:GetTextSpeed(),
			textCycleDelay = ent:GetTextCycleDelay(),
			font = ent:GetFont(),
			fontBold = ent:GetFontBold(),
			fontItalic = ent:GetFontItalic(),
			fontOutline = ent:GetFontOutline()
		}
	else
		ply:PrintMessage( HUD_PRINTCONSOLE, "This entity is not a sign." )

		return
	end

	ent._permSignId = psid

	if !file.Exists( "perm_signs", "DATA" ) then
		file.CreateDir( "perm_signs" )
	end

	file.Write( "perm_signs/" .. game.GetMap() .. ".txt", util.TableToJSON( signs ) )

	ply:PrintMessage( HUD_PRINTCONSOLE, "Success" )
end )

concommand.Add( "signs_unperm", function( ply )
	if !IsValid( ply ) or !HasPerm(ply) then return end
	
	local ent = ply:GetEyeTrace().Entity

	if !IsValid( ent ) or !ent._permSignId then return end

	local signs = getPermSigns()

	signs[ent._permSignId] = nil
	ent._permSignId = nil
	
	file.Write( "perm_signs/" .. game.GetMap() .. ".txt", util.TableToJSON( signs ) )

	ply:PrintMessage( HUD_PRINTCONSOLE, "Success" )
end )

concommand.Add( "signs_isperm", function( ply )
	if !IsValid( ply ) or !HasPerm(ply) then return end

	local ent = ply:GetEyeTrace().Entity

	if !IsValid( ent ) then return end

	ply:PrintMessage( HUD_PRINTCONSOLE, "The sign " .. (ent._permSignId and "is" or "isn't") .. " permanent." )
end )

concommand.Add( "signs_seturl", function( ply, _, args )
	if !IsValid( ply ) or !HasPerm(ply) then return end

	local ent = ply:GetEyeTrace().Entity

	if !IsValid( ent ) then return end
	
	if args[1] == nil then return end
	
	ent:SetInteractionUrl(args[1])

	ply:PrintMessage( HUD_PRINTCONSOLE, "Url set." )
end )


local function spawnPermSigns()
	for sid, sinfo in pairs( getPermSigns() ) do
		local sign = ents.Create( sinfo.class )

		if !IsValid( sign ) then return end

		sign:SetPos( sinfo.pos )
		sign:SetAngles( sinfo.ang )
		sign:Spawn()

		sign:GetPhysicsObject():EnableMotion( false )

		if sign.Base == "signs_base" then
			sign:SetBackgroundColor( sinfo.backgroundColor )
			sign:SetImageUrl( sinfo.imageUrl )
			sign:SetImageCropMode( sinfo.imageCropMode )
			sign:SetTextOverlays( sinfo.textOverlays )
			sign:SetInteractionUrl( sinfo.url )
		elseif sign.Base == "signs_ticker_base" then
			sign:SetBackgroundColor( sinfo.backgroundColor )
			sign:SetText( sinfo.text )
			sign:SetTextColor( sinfo.textColor )
			sign:SetTextSpeed( sinfo.textSpeed )
			sign:SetTextCycleDelay( sinfo.textCycleDelay )
			sign:SetFont( sinfo.font )
			sign:SetFontBold( sinfo.fontBold )
			sign:SetFontItalic( sinfo.fontItalic )
			sign:SetFontOutline( sinfo.fontOutline )
		end

		sign._permSignId = sid
		sign:BroadcastData()
	end
end

function removeSigns()
	local signclasses = {'signs_small', 'signs_small_wide', 'signs_large', 'signs_large_wide', 'signs_ticker_large', 'signs_ticker_small'}
	
	for _, class in pairs(signclasses) do
		for k, v in pairs(ents.FindByClass( class )) do
			v:Remove()
		end
	end
	
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("signs_removehtml")
	end
end

hook.Add( "InitPostEntity", "sv_signs_loadsigns", spawnPermSigns )
hook.Add( "PostCleanupMap", "sv_signs_reloadsigns", spawnPermSigns )
hook.Add( "PreCleanupMap", "sv_signs_reloadsigns_pre", removeSigns )