//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

hook.Add("GExtensionInitialized", "GExtension_Console_GExtensionInitialized", function()
	GExtension.TimeStamp = GExtension:CurrentTime()

	if tobool(GExtension:GetSetting("settings_console_enabled")) then
		GExtension:Query("INSERT INTO gex_console (timecode, server) VALUES(%1%, %2%);", {GExtension.TimeStamp, GExtension.ServerID}, function()
			GExtension:Query("DELETE FROM gex_console WHERE id IN(SELECT id FROM (SELECT id FROM gex_console WHERE server = %1% ORDER BY created DESC LIMIT 18446744073709551615 OFFSET 3) a )", {GExtension.ServerID}, function()
				timer.Create("GExtension_UpdateLog", 10, 0, function()
					GExtension:UpdateLog()
				end)
			end)
		end)
	end

	timer.Create("GExtension_CheckForCommands", 10, 0, function()
		GExtension:CheckForCommands()
	end)
end)

function GExtension:UpdateLog()
	if file.Exists("console.log", "GAME") then
		local log = file.Read("console.log", "GAME")
		log = string.sub(log, (#log-30000))
		log = string.Replace(log,'\n','<br />')
		
		/*log = string.Explode("\n", log)
		log = table.Reverse(log)
		
		local latestLog = {}

		for k,v in pairs(log) do
			if #latestLog < 500 then
				if !string.StartWith(v, "[GExtension] [DEBUG] [QUERY] INSERT INTO gex_console") then
					latestLog[#latestLog+1] = self:HTMLSpecialChars(v)
				end
			end
		end

		latestLog = self:ToJson(table.Reverse(latestLog))*/
		
		GExtension:Query("UPDATE gex_console SET log = %1%, updated = NOW() WHERE server = %2% AND timecode = %3%;", {log, self.ServerID, self.TimeStamp})
	end
end	

function GExtension:CheckForCommands()
	GExtension:Query("SELECT * FROM gex_commands WHERE server = %1% AND executed = 0;", {self.ServerID}, function(data)
		for _, v in pairs(data) do
			GExtension:Query("UPDATE gex_commands SET executed = 1 WHERE id = %1%;", {v["id"]});
			game.ConsoleCommand(v["command"] .. "\n");
			self:Print("neutral", "Command received: " .. v["command"])
		end
	end)
end