function org_npc( pl, cmd, org )
	if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		QueryValue("SELECT * FROM `orgs_npcs` WHERE `map` = '".. game.GetMap() .."'", function( r )
			if r == nil then
				Query("INSERT INTO `orgs_npcs` (`pos`, `angle`, `map`) VALUES ( '".. pl:GetPos().x ..", ".. pl:GetPos().y ..", ".. pl:GetPos().z .."', '".. pl:GetAngles().p ..", ".. pl:GetAngles().y ..", ".. pl:GetAngles().r .."', '".. game.GetMap() .."')")
				sendNotify( pl, "The NPC is added successfully!", "NOTIFY_HINT" )
			else
				Query("UPDATE `orgs_npcs` SET `pos` = '".. pl:GetPos().x ..", ".. pl:GetPos().y ..", ".. pl:GetPos().z .."', `angle` = '".. pl:GetAngles().p ..", ".. pl:GetAngles().y ..", ".. pl:GetAngles().r .."' WHERE `map` = '" .. game.GetMap() .. "'")
				for i,v in ipairs(ents.FindByClass("ent_npcorg")) do
					v:Remove()
				end
				sendNotify( pl, "The NPC Position has updated!", "NOTIFY_HINT" )
			end
		end)
		orgNPC = ents.Create("ent_npcorg")
		orgNPC:SetPos(pl:GetPos())
		orgNPC:SetAngles(pl:GetAngles())
		orgNPC:Spawn()
	end
end
concommand.Add("org_npc", org_npc)

function org_leave( pl )
	if pl:hasOrg() then
		notifyOrg( pl:getOrgID(), pl:Nick() .. " " .. ORGS_Lang.orgleft)
		sendNotify( pl, ORGS_Lang.orgleft1, "NOTIFY_HINT" )
		pl:leaveOrg()
	else
		sendNotify( pl, ORGS_Lang.havenoorg, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_leave", org_leave)

function org_new( pl, cmd, arg )
	if !pl:hasOrg() then
		if pl:CanAfford( ORGS_Config.createPrice ) then
			Query("INSERT INTO `orgs_orgs` (`name`, `motd`, `bankbalance`) VALUES ('".. SQLStr( arg[1], true ) .."', 'Set a new MOTD!', '0')")
			QueryValue("SELECT `id` FROM `orgs_orgs` WHERE `name` = '".. SQLStr( arg[1], true ) .."'", function( r )
				Orgs.newMember( pl, tostring(r), "o" )
			end)
			sendNotify( pl, ORGS_Lang.neworg, "NOTIFY_HINT" )
			sendNotify( pl, ORGS_Lang.neworg1, "NOTIFY_HINT" )
			pl:AddCash(-ORGS_Config.createPrice)		
		else
			sendNotify( pl, ORGS_Lang.cantafford, "NOTIFY_ERROR" )	
		end
	else
		sendNotify( pl, ORGS_Lang.alreadyin, "NOTIFY_ERROR" )
		sendNotify( pl, ORGS_Lang.alreadyin1, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_neworg", org_new)

function org_invite( pl, cmd, arg )
	if pl:havePermission( "c" ) then
		local ply = getPlayer(arg[1])
		if ply != pl then
			if !ply:hasOrg() or ply:getOrgID() != pl:getOrgID() then
				if ply.invitedata == nil then
					ply.invitedata = {true, pl:getOrgID()}
					net.Start( "orginvitebox" )
						if ply:hasOrg() then
							net.WriteString( arg[2] .." (You are already in ".. ORGS_Config.addonName .." if you will accept this, you will leave your ".. ORGS_Config.addonName ..".)" )
						else
							net.WriteString( arg[2] )
						end
					net.Send( ply )
					sendNotify( pl, ORGS_Lang.sent, "NOTIFY_HINT" )
				else
					sendNotify( pl, "You have been invited this player already!", "NOTIFY_ERROR" )
				end
			else
				sendNotify( pl, ORGS_Lang.alreadyin2, "NOTIFY_ERROR" )
			end
		else
			sendNotify( pl, ORGS_Lang.cant, "NOTIFY_ERROR" )
		end
	else
		sendNotify( pl, ORGS_Lang.leader, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_inviteplayer", org_invite)

function org_accept( pl, cmd )
	if pl.invitedata != nil then
		if pl.invitedata[1] == true then
			if pl:hasOrg() and pl:getOrgID() != tostring(pl.invitedata[2]) then
				pl:ChatPrint(ORGS_Lang.leaving)
				pl:leaveOrg()
			end
			Orgs.newMember(pl, pl.invitedata[2], "n")
			sendNotify( pl, ORGS_Lang.accept, "NOTIFY_HINT" )
			notifyOrg( pl:getOrgID(), pl:Nick() .. " " .. ORGS_Lang.joined)
			Query("SELECT * FROM `orgs_players` WHERE `orgid` = '".. pl:getOrgID() .."'", function( r )
				for k,v in pairs( player.GetAll() ) do
					if v:getOrgID() == pl:getOrgID() then
						net.Start("refreshclientplayerlist")
							net.WriteTable( r )
						net.Send( v )
					end
				end
			end)
			pl.invitedata = nil
		end
	else
		sendNotify( pl, ORGS_Lang.notinvited, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_accept", org_accept)

function org_deny( pl, cmd, org )
	if pl.invitedata != nil then
		if pl.invitedata[1] == true then
			sendNotify( pl, ORGS_Lang.deny, "NOTIFY_HINT" )
			pl.invitedata = nil
		end
	else
		sendNotify( pl, ORGS_Lang.notinvited, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_deny", org_deny)

function org_deposit( pl, cmd, arg )
	if pl:havePermission( "a" ) then
		if isnumber(tonumber(arg[1])) and tonumber(arg[1]) > 0 then
			if pl:CanAfford(arg[1]) then
				Orgs.AddCash(pl:getOrgID(), arg[1])
				pl:AddCash(-arg[1])
				sendNotify( pl, "You have been deposited " .. arg[1] .. "$ to the ".. ORGS_Config.addonName .." bank!", "NOTIFY_HINT" )
				notifyOrg( pl:getOrgID(), "" .. pl:Nick() .. " has been deposited " .. arg[1] .. "$ to the ".. ORGS_Config.addonName .." bank!")
				QueryValue("SELECT `bankbalance` FROM `orgs_orgs` WHERE `id` = '".. pl:getOrgID() .."'", function( r )
					for k,v in pairs( player.GetAll() ) do
						if v:getOrgID() == pl:getOrgID() then
							net.Start("refreshclientbank")
								net.WriteString( tostring(r) )
							net.Send( v )
						end
					end
				end)
			else
				sendNotify( pl, ORGS_Lang.plnomoney, "NOTIFY_ERROR" )
			end
		else
			sendNotify( pl, ORGS_Lang.validnum, "NOTIFY_ERROR" )
		end
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_deposit", org_deposit)

function org_withdraw( pl, cmd, arg )
	if pl:havePermission( "b" ) then
		if isnumber( tonumber(arg[1]) ) and tonumber(arg[1]) > 0 then
			QueryValue("SELECT `bankbalance` FROM `orgs_orgs` WHERE `id` = '".. pl:getOrgID() .."'", function( r )
				if tonumber( r ) >= tonumber( arg[1] ) then
					pl:AddCash(arg[1])
					Orgs.AddCash(pl:getOrgID(), -arg[1])
					sendNotify( pl, "You have been withdrawn " ..arg[1].. "$ from the ".. ORGS_Config.addonName .." bank!", "NOTIFY_HINT" )
					notifyOrg( pl:getOrgID(), "" .. pl:Nick() .. " has been withdrawn " ..arg[1].. "$ from the ".. ORGS_Config.addonName .." bank!")
					for k,v in pairs( player.GetAll() ) do
						if v:getOrgID() == pl:getOrgID() then
							net.Start("refreshclientbank")
								net.WriteString( tostring(r - arg[1]) )
							net.Send( v )
						end
					end
				else
					sendNotify( pl, ORGS_Lang.orgnomoney, "NOTIFY_ERROR" )
				end
			end)
		else
			sendNotify( pl, ORGS_Lang.validnum, "NOTIFY_ERROR" )
		end
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_withdraw", org_withdraw)

function org_motd( pl, cmd, args )
	if pl:havePermission( "d" ) then
		Orgs.setMotd(pl:getOrgID(), args[1])
		sendNotify( pl, ORGS_Lang.motdchange, "NOTIFY_HINT" )
		for k,v in pairs( player.GetAll() ) do
			if v:getOrgID() == pl:getOrgID() then
				net.Start("refreshclientmotd")
					net.WriteString(args[1])
				net.Send( v )
			end
		end
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_setmotd", org_motd)

function org_kickmember( pl, cmd, args )
	if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		local orgid
		if !player.GetBySteamID( args[1] ) then
			Query("SELECT `name`, `orgid` FROM `orgs_players` WHERE `steamid` = '" .. args[1] .. "'", function( r )
				notifyOrg( r[1]["orgid"], "" .. r[1]["name"] .. " " ..ORGS_Lang.memberkicked)
				orgid = r[1]["orgid"]
				org.steamIDKick( args[1] )
			end)
		else
			local ply = player.GetBySteamID( args[1] )
			notifyOrg( ply:getOrgID(), "" .. ply:Nick() .. " " ..ORGS_Lang.memberkicked)
			sendNotify( ply, ORGS_Lang.youkicked, "NOTIFY_HINT" )
			orgid = ply:getOrgID()
			ply:leaveOrg()
		end
		Query("SELECT * FROM `orgs_players` WHERE `orgid` = '" .. orgid .. "'", function(r)
			if r then
				for k,v in pairs( player.GetAll() ) do
					if v:getOrgID() == orgid then
						net.Start("refreshclientplayerlist")
								net.WriteTable(r)
						net.Send( v )
					end
				end
			end
		end)
	elseif pl:havePermission( "e" ) then
		QueryValue("SELECT * FROM `orgs_players` WHERE `orgid` = '".. pl:getOrgID() .."' AND `rank` = 'o' AND `steamid` = '" .. args[1] .. "'", function( r )
			if !r then
				if !player.GetBySteamID( args[1] ) then
					Query("SELECT `name` FROM `orgs_players` WHERE `steamid` = '" .. args[1] .. "'", function( r )
						notifyOrg( r[1]["orgid"], "" .. r[1]["name"] .. " " ..ORGS_Lang.memberkicked)
						org.steamIDKick( args[1] )
					end)
				else
					local ply = player.GetBySteamID( args[1] )
					notifyOrg( ply:getOrgID(), "" .. ply:Nick() .. " " ..ORGS_Lang.memberkicked)
					sendNotify( ply, ORGS_Lang.youkicked, "NOTIFY_HINT" )
					ply:leaveOrg()
				end
			else
				sendNotify( pl, ORGS_Lang.cantkickowner, "NOTIFY_ERROR" )
			end
		end)
		Query("SELECT * FROM `orgs_players` WHERE `orgid` = '" .. pl:getOrgID() .. "'", function(r)
			if r then
				for k,v in pairs( player.GetAll() ) do
					if v:getOrgID() == pl:getOrgID() then
						net.Start("refreshclientplayerlist")
								net.WriteTable(r)
						net.Send( v )
					end
				end
			end
		end)
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_kickmember", org_kickmember)

function org_setrank( pl, cmd, args )
	if pl:havePermission( "f" ) then
		local ply = player.GetBySteamID( args[1] )
		if ply then
			if ply:getOrgRank() != "o" then				
				QueryValue("SELECT `name` from `orgs_ranks` WHERE `id` = '" .. args[2] .. "'", function( r )
					if r != nil then
						ply:setOrgRank( tostring(args[2]) )
						sendNotify( ply, "You have been made a " .. r .. " !", "NOTIFY_HINT" )
						notifyOrg( pl:getOrgID(), "".. ply:Nick() .. " has been made a " .. r .. " !")
						Query("SELECT * FROM `orgs_players` WHERE `orgid` = '".. pl:getOrgID() .."'", function( r )
							for k,v in pairs( player.GetAll() ) do
								if v:getOrgID() == pl:getOrgID() then
									net.Start("refreshclientplayerlist")
										net.WriteTable( r )
									net.Send( v )
								end
							end
						end)
					end
				end)
			else
				sendNotify( pl, ORGS_Lang.cantrankowner, "NOTIFY_ERROR" )
			end
		else
			sendNotify( pl, ORGS_Lang.offine, "NOTIFY_HINT" )
		end
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_setrank", org_setrank)

function org_newrank( pl, cmd, args )
	if pl:havePermission( "g" ) then
		rank.new( args[1], args[2], pl:getOrgID() )
		sendNotify( pl, ORGS_Lang.rankcreate, "NOTIFY_HINT" )
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_newrank", org_newrank)

function org_editrank( pl, cmd, args )
	if pl:havePermission( "g" ) then
		rank.edit( args[1], {args[2], args[3]} )
		sendNotify( pl, ORGS_Lang.rankupdate, "NOTIFY_HINT" )
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_editrank", org_editrank)

function org_delrank( pl, cmd, args )
	if pl:havePermission( "g" ) then
		Query("SELECT * FROM `orgs_players` WHERE `rank` = '" .. tostring(args[1]) .. "'", function( r )
			if r then
				sendNotify( pl, "You cant delete this rank. Players are in this rank", "NOTIFY_HINT" )
			else
				sendNotify( pl, ORGS_Lang.rankdelete, "NOTIFY_HINT" )
				rank.delete( args[1] )
			end
		end)
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_delrank", org_delrank)

function org_delete( pl, cmd, args )
	if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		for k,v in pairs( player.GetAll() ) do
			if v:getOrgID() == args[1] then
				v:leaveOrg()
			end
		end
		Query("DELETE FROM `orgs_orgs` WHERE `id` = '".. args[1] .."'")
		Query("DELETE * FROM `orgs_players` WHERE `orgid` = '".. args[1] .."'")
		sendNotify( pl, "The organisation has been deleted", "NOTIFY_HINT" )
	else
		pl:ChatPrint("Admins ONLY!")
	end
end
concommand.Add("org_delete", org_delete)

function org_meetup( pl, cmd, arg )
	if pl:havePermission( "h" ) and ORGS_Config.enableOrgMeetups then
		if arg[1] != nil then
			for k,v in pairs(player.GetAll()) do
				if pl:getOrgID() == v:getOrgID() then
					net.Start("meetuppoint")
						net.WriteTable({ arg[1], pl:GetPos(), pl:Nick(), arg[2] })
					net.Send( v )
				end
			end
		end
	else
		sendNotify( pl, ORGS_Lang.nopermission, "NOTIFY_ERROR" )
	end
end
concommand.Add("org_meetup", org_meetup)

hook.Add( "PlayerSay", "orgChat", function( pl, text, public )
	if (string.sub(text, 1, 5) == "!orgc") then
		if pl:hasOrg() then
			if string.len(string.sub(text, 6)) > 0 then
				for k,v in pairs(player.GetAll()) do
					if v:hasOrg() and v:getOrgID() == pl:getOrgID() then
						net.Start("orgchatmsg")
							local rankname
							if pl:getOrgRank() == "o" then 
								rankname = ORGS_Lang.rankowner
							elseif pl:getOrgRank() == "n" then 
								rankname = ORGS_Lang.ranknewmember
							else
								rankname = pl:getOrgRank()["name"]
							end
							net.WriteTable({pl:Nick(), rankname, string.sub(text, 6)})
						net.Send( v )	
					end
				end	
			end
		else
			pl:ChatPrint(ORGS_Lang.havenoorg)
		end
	end
	if(string.sub(text, 1, 8) == "!orgmenu") then
		if pl:hasOrg() then
			org_menu( pl )
		else
			pl:ChatPrint(ORGS_Lang.havenoorg)
		end
	end
	if(string.sub(text, 1, 9) == "!orgadmin") then
		if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
			Query("SELECT * FROM `orgs_orgs`", function( r )
				if r == nil then 
					sendNotify( pl, "There are no organisations.", "NOTIFY_HINT" )
				else
					net.Start("orgsadminselect")
						net.WriteTable( r )
					net.Send( pl )
				end
			end)
		else
			pl:ChatPrint("Admins ONLY!")
		end
	end
	if(string.sub(text, 1, 7) == "!orgnpc") then
		if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
			pl:ConCommand("org_npc")
		else
			pl:ChatPrint("Admins ONLY!")
		end
	end
	if(string.sub(text, 1, 8) == "!orghelp") then
		if pl:hasOrg() then
			pl:ChatPrint(ORGS_Lang.orghelp1)
			pl:ChatPrint(ORGS_Lang.orghelp2)
			pl:ChatPrint(ORGS_Lang.orghelp3)
		else
			pl:ChatPrint(ORGS_Lang.havenoorg)
		end
	end
end)

function org_menu( pl )
	if pl:hasOrg() then
		sendNotify( pl, "Loading Menu...", "NOTIFY_HINT" )
		local orgdata = {}
		Query("SELECT * FROM `orgs_orgs` WHERE `id` = '" .. pl:getOrgID() .. "'", function(r)
			table.insert(orgdata, r[1])
			if pl.org["rank"] == "o" then
				table.insert(orgdata, {"a","b","c","d","e","f","g","h"})
			elseif pl.org["rank"] == "n" then
				table.insert(orgdata, {})
			else
				table.insert(orgdata, string.Explode(",", pl.org["rank"]["flags"]))
			end
			Query("SELECT * FROM `orgs_players` WHERE `orgid` = '" .. pl:getOrgID() .. "'", function(r)
				table.insert(orgdata, r)
				Query("SELECT * FROM `orgs_ranks` WHERE `orgid` = '" .. pl:getOrgID() .. "'", function(r)
					if r then
						table.insert(orgdata, r)
					end
					net.Start("orgmenu")
						net.WriteTable(orgdata)
					net.Send( pl )
				end)
			end)
		end)
	else
		pl:ChatPrint(ORGS_Lang.havenoorg)		
	end
end
concommand.Add("org_menu", org_menu)

net.Receive( "requestorg", function( l, pl )
	if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		local orgid = net.ReadString()
		local orgdata = {}
		Query("SELECT * FROM `orgs_orgs` WHERE `id` = '" .. SQLStr( orgid, true ) .. "'", function(r)
			table.insert(orgdata, r[1])
			Query("SELECT * FROM `orgs_players` WHERE `orgid` = '" .. SQLStr( orgid, true ) .. "'", function(r)
				table.insert(orgdata, r)
				net.Start("requestorganswer")
					net.WriteTable(orgdata)
				net.Send( pl )
			end)
		end)
	end
end)

net.Receive( "editorg", function( l, pl )
	if pl:IsAdmin() or pl:IsSuperAdmin() or pl:IsUserGroup("admin") or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		local org = net.ReadTable()
		Query("UPDATE `orgs_orgs` SET `name` = '" .. org[2] .. "', `bankbalance` = '".. org[3]  .."', `motd` = '".. org[4] .."' WHERE `ID` = '" .. org[1] .. "'")
		sendNotify( pl, "The organisation has been edited.", "NOTIFY_HINT" )
	end
end)

net.Receive("orgcheckname", function( l, pl )
	local name = net.ReadString()
	QueryValue("SELECT `name` FROM `orgs_orgs` WHERE `name` LIKE '".. SQLStr( name, true ) .."'", function( r )
		net.Start("returnorgcheckname")
		if r == nil then
			net.WriteBool( true )
		else
			net.WriteBool( false )
		end
		net.Send( pl )
		print( r )
	end)
end)