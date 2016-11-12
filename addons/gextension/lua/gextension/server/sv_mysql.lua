//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

--returnes an escaped version of the given string
function GExtension:Escape(sqlstring)
	local allowedStrings = {}

	if table.HasValue(allowedStrings,sqlstring) then
		return sqlstring
	end

	if self.module == "tmysql4" then
		return "'"..self.db:Escape(tostring(sqlstring)).."'"
	elseif self.module == "mysqloo" then
		return "'"..self.db:escape(tostring(sqlstring)).."'"
	end
end

--connects to the mysql server and sets some variables
function GExtension:InitSQL()
	self.connected = false
	self.module = ""
	
	local use_tmysql, use_mysqloo =  file.Exists("bin/gmsv_tmysql4_*.dll", "LUA"), file.Exists("bin/gmsv_mysqloo_*.dll", "LUA")
	self.db = false
		
	if use_tmysql then
		require("tmysql4")
		self.module = "tmysql4"
		local error = false

		if not self.socketpath and self.socketpath == "" then
			self.db, error = tmysql.initialize(self.ip, self.username, self.password, self.database, self.port)
		else
			self.db, error = tmysql.initialize(self.ip, self.username, self.password, self.database, self.port, self.socketpath)
		end
		
		if !error then
			self.connected = true
			self:Print("success", "tMySQL connection successfull!")
			hook.Run("GExtensionMySQLConnected")
		else
			self:Print("error", "tMySQL connection failure: "..error)
		end
	elseif use_mysqloo then
		require("mysqloo")

		self.module = "mysqloo"
		self.db = mysqloo.connect(self.ip, self.username, self.password, self.database, self.port)

		if not self.socketpath or self.socketpath == "" then
			self.db = mysqloo.connect(self.ip, self.username, self.password, self.database, self.port)
		else
			self.db = mysqloo.connect(self.ip, self.username, self.password, self.database, self.port, self.socketpath)
		end

		self.db:connect()

		function self.db:onConnected()
			GExtension.connected = true
			GExtension:Print("success", "MySQLoo connection successfull!")
			hook.Run("GExtensionMySQLConnected")
		end
		function self.db:onConnectionFailed(error)
			GExtension:Print("error", "Mysqloo connection failure: "..error)
		end
	else
		self:Print("error", "You need to have tmysql4 or mysqloo installed. Please install one of these modules in order to use GExtension!")
	end
end

function GExtension:SQLDebug(query, result)
	if self.DebugMode then
		if !string.StartWith(query, "UPDATE gex_console SET") then
			self:Print("neutral", "[DEBUG] [QUERY] " .. query)
		else
			self:Print("neutral", "[DEBUG] [QUERY] UPDATE gex_console SET ... <removed>")
		end
	end

	if self.DebugSQL and result then
		self:Print("neutral", "[DEBUG] [QUERY] Result:")
		PrintTable(result)
	end
end

--executes the given query and calls the callback function.
--TODO! Change the data callback to always have the same structure!
function GExtension:Query(query, replacements, callback)
	if !self.connected then
		self:Print("error", "Tried to execute query with no database object being connected!")
		return
	end
	
	if replacements and istable(replacements) then
		for k, v in pairs(replacements) do
			query = string.Replace(query, "%"..k.."%", self:Escape(v))
		end
	end
	
	if self.module == "tmysql4" then
		self.db:Query(query, function(results)
			if results[1].status then
				self:SQLDebug(query, results[1]["data"])

				if callback and isfunction(callback) then
					callback(results[1]["data"])
				end
			else
				self:Print("error", "Error while executing Query:\n"..results[1].error.."\n\nQuery:\n"..query)
			end
		end)
	elseif self.module == "mysqloo" then
		local q = GExtension.db:query(query)
		function q:onSuccess(results)
			GExtension:SQLDebug(query, results)

			if callback and isfunction(callback) then
				callback(results)
			end
		end
		function q:onError(error)
			if GExtension.db:status() == mysqloo.DATABASE_NOT_CONNECTED then
				GExtension:Print("error", "MySQL server is not connected, trying to reconnect...")
				GExtension:InitSQL()
			end

			GExtension:Print("error", "Error while executing Query:\n"..error.."\n\nQuery:\n"..query)
		end
		q:start()
	end
end