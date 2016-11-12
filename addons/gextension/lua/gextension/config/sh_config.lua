//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

--The ID of the server. Assign a new ID for each server!
GExtension.ServerID = 6

--URL to GmodWeb
GExtension.WebURL = "https://gmodweb.epic-gaming.de/"

--TimeFormat | https://www.lua.org/pil/22.1.html
GExtension.TimeFormat = "%d.%m.%Y %H:%M"

--Every X seconds, the server checks for new rewards
GExtension.RewardRefreshTime = 30

--Commands, that will open the donate page
GExtension.DonateCmds = {"!donate"}

--Commands, that will open the ticket page
GExtension.TicketCmds = {"!tickets", "!ticket", "!help"}

--Number of reserved slots. At least 1, more are better. 0 to disable.
--Example: 34 slot server, RSlotsNumber = 2. The server will now have 32 slots.
--         If the server is full, a player with RSlot permissions will connect on slot 33
--         and kick the newest player. Players need some time to connect, so it's useful
--         to have multiple RSlots.
GExtension.RSlotsNumber = 5

--Language Code
GExtension.LanguageCode = "de"

--Print executed rewards to console
GExtension.PrintExecutedRewards = true

--Debug
GExtension.Debug = false
GExtension.DebugSQL = false