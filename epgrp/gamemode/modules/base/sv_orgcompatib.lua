RP.PLUGINS.CHATCOMMAND.AddChatCommand( "!orgc", function( ply, args, public )
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
end)

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "!orgmenu", function( ply, args, public )
	if pl:hasOrg() then
		org_menu( pl )
	else
		pl:ChatPrint(ORGS_Lang.havenoorg)
	end
end)
	

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "!org_admin", function( ply, args, public )
	if pl:IsSuperAdmin() pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
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
end)
	
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "!orgnpc", function( ply, args, public )
	if pl:IsSuperAdmin() or pl:IsUserGroup("superadmin") or pl:IsUserGroup("owner") then
		pl:ConCommand("org_npc")
	else
		pl:ChatPrint("Admins ONLY!")
	end
end)

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "!orghelp", function( ply, args, public )
	if pl:hasOrg() then
		pl:ChatPrint(ORGS_Lang.orghelp1)
		pl:ChatPrint(ORGS_Lang.orghelp2)
		pl:ChatPrint(ORGS_Lang.orghelp3)
	else
		pl:ChatPrint(ORGS_Lang.havenoorg)
	end
end)