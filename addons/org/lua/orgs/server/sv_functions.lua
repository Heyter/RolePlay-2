local meta = FindMetaTable( "Player" )

function meta:loadOrg()
	RP.SQL:Query("SELECT * FROM `orgs_players` WHERE `steamid` = %1%", {self:SteamID()}, function(r)
		PrintTable( r )
		if r then
			RP.SQL:Query("SELECT `name` FROM `orgs_orgs` WHERE `id` = %1%", {r[1]["orgid"]}, function(r)
				if r then
					print( r[1] )
					self:SetNWString("orgName", r[1]["name"])
				end
			end)
			self.org = r[1]
			if tostring(self.org["rank"]) != "o" then
				if tostring(self.org["rank"]) != "n" then
					Query("SELECT * FROM `orgs_ranks` where `id` = %1%", {self.org["rank"]}, function( r )
						self.org["rank"] = r[1]
					end)
				end
			end
		end
	end)	
end

function meta:hasOrg()
	if self.org then
		return true
	else
		return false
	end
end

function meta:getOrgID()
	if self:hasOrg() then
		return self.org["orgid"]
	else
		return false
	end
end

function meta:getLastSeen( time )
	if self:hasOrg() then
		return self.org["lastseen"]
	else
		return false
	end
end

function meta:havePermission( flag )
	if self:hasOrg() then
		if self.org["rank"] == "o" then
			return true
		elseif self.org["rank"] == "n" then
			return false
		else
			if table.HasValue(string.Explode(",", self.org["rank"]["flags"]), flag) then
				return true
			else
				return false
			end
		end
	end
end

function meta:getOrgRank()
	if self:hasOrg() then
		return self.org["rank"]
	else
		return false
	end
end

function meta:setOrgRank( rankid )
	RP.SQL:Query( "UPDATE `orgs_players` SET `rank` = %1% WHERE `steamid` = %2%", {rankid, self:SteamID()}, function( r )
		self:loadOrg()
	end)
end

function meta:setLastSeen( time )
	local setLastseenQuery = Query("UPDATE `orgs_players` SET `lastseen` = %1% WHERE `steamid` = %2%", {time, self:SteamID()})
	return setLastseenQuery
end

function meta:leaveOrg()
	local query = RP.SQL:Query("DELETE FROM `orgs_players` WHERE `steamid` = %1%", {self:SteamID()})
	local oldorgid = self:getOrgID()
	self:SetNWString("orgName", "")
	self.org = nil
	-- Delete org if no one is there.
	local checkquery = RP.SQL:Query("SELECT * FROM `orgs_players` WHERE `orgid` = %1%", {oldorgid}, function( r )
		if r == nil then
			RP.SQL:Query("DELETE FROM `orgs_orgs` WHERE `id` = %1%", {oldorgid})
		end
	end)
	net.Start("leaveorg")
	net.Send( self )
end

Orgs = {}

function Orgs.newMember( pl, orgid, rank )
	RP.SQL:Query("INSERT INTO `orgs_players` (`steamid`, `name`, `rank`, `orgid`, `lastseen`) VALUES (%1%, %2%, %3%, %4%, %5%)",
	{pl:SteamID(), pl:Nick(), rank, orgid, os.date()}, function()
		pl:loadOrg()
	end)
end

function Orgs.AddCash( orgid, amount )
	QueryValue("SELECT `bankbalance` FROM `orgs_orgs` WHERE `id` = %1%", {orgid}, function( r )
		RP.SQL:Query("UPDATE `orgs_orgs` SET `bankbalance` = %1% WHERE `ID` = %2%", {r + amount, orgid})
	end)
end

function Orgs.setMotd( orgid, motd )
	local orgMOTDQuery = RP.SQL:Query("UPDATE `orgs_orgs` SET `motd` = %1% WHERE `ID` = %2%", {motd, orgid})
	return orgMOTDQuery
end

function Orgs.steamIDKick( steamid )
	local checkquery = RP.SQL:Query("SELECT * FROM `orgs_players` WHERE `steamid` = %1%", {steamid} function( r )
		if r then
			local query = RP.SQL:Query("DELETE FROM `orgs_players` WHERE `steamid` = %1%", {steamid})
			local x = r[1]["orgid"]
			RP.SQL:Query("SELECT * FROM `orgs_players` WHERE `orgid` = %1%", {x}, function( r )
				if r != nil then
					local query2 = RP.SQL:Query("DELETE FROM `orgs_orgs` WHERE `id` = %1%", {x})
				end
			end)
		end
	end)
end

rank = {}

function rank.new( rankname, flags, orgid )
	local newrankquery = RP.SQL:Query("INSERT INTO `orgs_ranks` (`name`, `flags`, `orgid`) VALUES (%1%, %2%, %3%)", {rankname, flags, orgid})
	return newrankquery
end

function rank.edit( rankid, data )
	local editrankQuery = RP.SQL:Query("UPDATE `orgs_ranks` SET `name` = %1%, `flags` = %2% WHERE `id` = %3%" , {data[1], data[2], rankid})
	return editrankQuery
end

function rank.delete( rankid )
	local deletequery = RP.SQL:Query("DELETE FROM `orgs_ranks` WHERE `id` = %1%", rankid)
	return deletequery
end

local mysqlConnected = true

function createTables()
	if mysqlConnected then
		RP.SQL:Query("CREATE TABLE IF NOT EXISTS `orgs_orgs` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` text NOT NULL, `motd` text NOT NULL, `bankbalance` int(11) NOT NULL, PRIMARY KEY (`id`))")
		RP.SQL:Query("CREATE TABLE IF NOT EXISTS `orgs_players` ( `id` int(11) NOT NULL AUTO_INCREMENT, `steamid` text NOT NULL, `name` text NOT NULL, `rank` text NOT NULL, `orgid` int(11) NOT NULL, `lastseen` text NOT NULL, PRIMARY KEY (`id`))")
		RP.SQL:Query("CREATE TABLE IF NOT EXISTS `orgs_ranks` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` text NOT NULL, `flags` text NOT NULL, `orgid` int(11) NOT NULL, PRIMARY KEY (`id`))")
		RP.SQL:Query("CREATE TABLE IF NOT EXISTS `orgs_npcs` ( `id` int(11) NOT NULL AUTO_INCREMENT, `pos` text NOT NULL, `angle` text NOT NULL, `map` text NOT NULL, PRIMARY KEY (`id`))")
	else
		if !sql.TableExists( "orgs_orgs" ) then
			sql.Query("CREATE TABLE `orgs_orgs` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `motd` TEXT, `bankbalance` INTEGER);")
		end
		if !sql.TableExists("orgs_players") then
			sql.Query("CREATE TABLE `orgs_players` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `steamid` TEXT, `name` TEXT, `rank` INTEGER, `orgid` TEXT, `lastseen` TEXT);")
		end
		if !sql.TableExists("orgs_ranks") then
			sql.Query("CREATE TABLE `orgs_ranks` ( `id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `flags` TEXT, `orgid` INTEGER);")
		end
		if !sql.TableExists("orgs_npcs") then
			sql.Query("CREATE TABLE `orgs_npcs` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `pos` TEXT, `angle` TEXT, `map` TEXT);")
		end
	end
	print( "[ORG ADDON]: The addon has been loaded!" )
	timer.Simple(5, function()
		RP.SQL:Query("SELECT * FROM `orgs_npcs` WHERE `map` = %1%", {game.GetMap()}, function( r )
			if r != nil then
				print( "[ORG ADDON]: The NPC has been spawned in the map!" )
				orgNPC = ents.Create("ent_npcorg")
				pos = string.Split(r[1]["pos"], ", ")
				orgNPC:SetPos(Vector(tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3])))
				ang = string.Split(r[1]["angle"], ", ")
				orgNPC:SetAngles(Angle(tonumber(ang[1]), tonumber(ang[2]), tonumber(ang[3])))
				orgNPC:Spawn()
			end
		end)
	end)
end

function QueryValue( query, callback )
	if mysqlConnected then
		local query = RP.SQL:Query( query, _, function( d ) 
			for k,v in pairs(d[1] or {}) do
				print( v )
				callback(v)
				return
			end
			callback( d[1] )
		end )
		return
	else
		callback(sql.QueryValue( query ))
	end
end

function getPlayer( playerNick )
	local pNick = string.lower( playerNick )
	for _, pl in pairs(player.GetAll()) do
		if (string.lower(string.sub(pl:Nick(), 1, #pNick)) == pNick) then
			return pl
		end
	end
	return nil
end

function notifyOrg(orgID, msg)
	for k,v in pairs( player.GetAll() ) do
		if v:getOrgID() == orgID then
			sendNotify( v, msg, "NOTIFY_HINT" )
		end
	end
end