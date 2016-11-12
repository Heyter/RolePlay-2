//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

GExtension.Bundle = -1

function GExtension:InitServer(callback, second)
	GExtension.Bundle = -1

	local ipAndPort = string.Explode(':', game.GetIPAddress())
	local ip = ipAndPort[1]
	local port = ipAndPort[2]

	if ip != "0.0.0.0" then
		self:Query("INSERT INTO gex_servers (id, hostname, ip, port, users_online) VALUES(%1%, %2%, %3%, %4%, '') ON DUPLICATE KEY UPDATE hostname = %2%, ip = %3%, port = %4%;", {self.ServerID, GetHostName(), ip, port}, function()
			self:Query("SELECT * FROM gex_serverbundles WHERE servers LIKE '%" .. self.ServerID .. ",%' OR servers LIKE '%" .. self.ServerID .. "]%';", {}, function(data)
				if #data > 0 and data[1]["id"] then
					local bundleid = data[1]["id"]

					self.Bundle = bundleid
					self:Print("neutral", "Serverbundle found: " .. data[1]['name'])

					--[[timer.Create("GExtension_Server_RefreshOnlinePlayers", 45, 0, function()
						GExtension:RefreshOnlinePlayers()
					end)]]--

					callback()
				else
					self:Print("error", "Could not initialize: Server is not assigned to a serverbundle.")
				end
			end)
		end)
	else
		self:Print("error", "Could not initialize: IP invalid.")
	end
end

function GExtension:GetServerIP()
    local hostip = GetConVarString( "hostip" )
    hostip = tonumber( hostip )
    local ip = {}
    ip[ 1 ] = bit.rshift( bit.band( hostip, 0xFF000000 ), 24 )
    ip[ 2 ] = bit.rshift( bit.band( hostip, 0x00FF0000 ), 16 )
    ip[ 3 ] = bit.rshift( bit.band( hostip, 0x0000FF00 ), 8 )
    ip[ 4 ] = bit.band( hostip, 0x000000FF )

    return table.concat( ip, "." )
end

--[[
function GExtension:RefreshOnlinePlayers()
	local plys = {}

	for _, ply in pairs(player.GetHumans()) do
		plys[#plys+1] = ply:SteamID64()
	end

	self:Query("UPDATE gex_servers SET users_online = %1% WHERE id = %2%", {self:ToJson(plys), self.ServerID})
end
]]--