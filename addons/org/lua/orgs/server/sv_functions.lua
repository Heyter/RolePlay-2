local meta = FindMetaTable( "Player" )

function meta:loadOrg()
	Query("SELECT * FROM `orgs_players` WHERE `steamid` = '".. self:SteamID() .."'", function(r)
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
	Query( "UPDATE `orgs_players` SET `rank` = '".. rankid .."' WHERE `steamid` = '" .. self:SteamID() .. "'", function( r )
		self:loadOrg()
	end)
end

function meta:setLastSeen( time )
	local setLastseenQuery = Query("UPDATE `orgs_players` SET `lastseen` = '" .. time ..  "' WHERE `steamid` = '".. self:SteamID() .."'")
	return setLastseenQuery
end

function meta:leaveOrg()
	local query = Query("DELETE FROM `orgs_players` WHERE `steamid` = '".. self:SteamID() .."'")
	local oldorgid = self:getOrgID()
	self:SetNWString("orgName", "")
	self.org = nil
	-- Delete org if no one is there.
	local checkquery = Query("SELECT * FROM `orgs_players` WHERE `orgid` = '".. oldorgid .."'", function( r )
		if r == nil then
			Query("DELETE FROM `orgs_orgs` WHERE `id` = '".. oldorgid .."'")
		end
	end)
	net.Start("leaveorg")
	net.Send( self )
end

Orgs = {}

function Orgs.newMember( pl, orgid, rank )
	local newMemberQuery = Query("INSERT INTO `orgs_players` (`steamid`, `name`, `rank`, `orgid`, `lastseen`) VALUES ('".. pl:SteamID() .."', '".. pl:Nick() .."', '".. rank .."', '" .. orgid .. "', '" .. tostring( os.date() ) .. "')")
	pl:loadOrg()
end

function Orgs.AddCash( orgid, amount )
	QueryValue("SELECT `bankbalance` FROM `orgs_orgs` WHERE `id` = '".. orgid  .."'", function( r )
		Query("UPDATE `orgs_orgs` SET `bankbalance` = '".. r + amount .."' WHERE `ID` = '" .. orgid .. "'")
	end)
end

function Orgs.setMotd( orgid, motd )
	local orgMOTDQuery = Query("UPDATE `orgs_orgs` SET `motd` = '".. motd .."' WHERE `ID` = '" .. orgid .. "'")
	return orgMOTDQuery
end

function Orgs.steamIDKick( steamid )
	local checkquery = Query("SELECT * FROM `orgs_players` WHERE `steamid` = '".. steamid .."'", function( r )
		if r then
			local query = Query("DELETE FROM `orgs_players` WHERE `steamid` = '".. steamid .."'")
			local x = r[1]["orgid"]
			Query("SELECT * FROM `orgs_players` WHERE `orgid` = '".. x .."'", function( r )
				if r != nil then
					local query2 = Query("DELETE FROM `orgs_orgs` WHERE `id` = '".. x .."'")
				end
			end)
		end
	end)
end

rank = {}

function rank.new( rankname, flags, orgid )
	local newrankquery = Query("INSERT INTO `orgs_ranks` (`name`, `flags`, `orgid`) VALUES ('".. rankname .."', '".. flags .."', '".. orgid .."')")
	return newrankquery
end

function rank.edit( rankid, data )
	local editrankQuery = Query("UPDATE `orgs_ranks` SET `name` = '".. data[1] .."', `flags` = '".. data[2] .."' WHERE `id` = '" .. rankid .. "'")
	return editrankQuery
end

function rank.delete( rankid )
	local deletequery = Query("DELETE FROM `orgs_ranks` WHERE `id` = '".. rankid .."'")
	return deletequery
end

local mysqlConnected = true

function createTables()
	if mysqlConnected then
		Query("CREATE TABLE IF NOT EXISTS `orgs_orgs` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` text NOT NULL, `motd` text NOT NULL, `bankbalance` int(11) NOT NULL, PRIMARY KEY (`id`))")
		Query("CREATE TABLE IF NOT EXISTS `orgs_players` ( `id` int(11) NOT NULL AUTO_INCREMENT, `steamid` text NOT NULL, `name` text NOT NULL, `rank` text NOT NULL, `orgid` int(11) NOT NULL, `lastseen` text NOT NULL, PRIMARY KEY (`id`))")
		Query("CREATE TABLE IF NOT EXISTS `orgs_ranks` ( `id` int(11) NOT NULL AUTO_INCREMENT, `name` text NOT NULL, `flags` text NOT NULL, `orgid` int(11) NOT NULL, PRIMARY KEY (`id`))")
		Query("CREATE TABLE IF NOT EXISTS `orgs_npcs` ( `id` int(11) NOT NULL AUTO_INCREMENT, `pos` text NOT NULL, `angle` text NOT NULL, `map` text NOT NULL, PRIMARY KEY (`id`))")
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
		Query("SELECT * FROM `orgs_npcs` WHERE `map` = '".. game.GetMap() .."'", function( r )
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
		local query = Query( query, function( d ) 
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