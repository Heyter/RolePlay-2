/*
--[[---------------------------------------------------------
   Name: meta:Name()
   Desc: RPName Stuff
-----------------------------------------------------------]]
local meta = FindMetaTable( "Player" )
meta.SteamName = meta.Name
function meta:Name()
	return self:GetRPVar( "rpname" )
end
meta.Nick = meta.Name
meta.GetName = meta.Name
*/

if CLIENT then
    function ConvPlaytime( Time )
        Time = tonumber( Time )
        
        if Time < 60 then
            return Time .. " Minuten"
        elseif Time < 1439 then
            Time = math.floor( Time / 60 )
            local Hours = Time % 24
            return Hours .. " Stunden "
        elseif Time > 1439 then
            Time = math.floor( Time / 60 )
            local Hours = Time % 24
            Time = math.floor( Time / 24 )
            local Days = Time % 24
            return Days .. " Tage, " .. Hours .. " Stunden"
        end
    end
	
	function ConvPlaytimeArrest( Time )
        Time = tonumber(  math.Round( Time ) )
        
       -- if Time < 60 then
            return Time .. " Sekunden"
			/*
		elseif (Time > 60 && Time < 3600) then
			local s_c = (Time - 60) / 60
			local calc = (s_c / 10)
			print( s_c, calc )
			local Seconds = math.floor( calc )
			Time = math.floor( Time / 60 )
			local Minutes = Time
            local Hours = Time % 24
            return tostring( Minutes ) .. " minuten, " .. tostring( Seconds ) .. " sekunden"
        elseif Time < 1439 then
            Time = math.floor( Time / 60 )
			local Seconds = Time * 60
			local Minutes = Time
            local Hours = Time % 24
            return tostring( Hours ).. "s, " .. tostring( Minutes ) .. "m, " .. tostring( Seconds ) .. "s"*/
        --end
    end
end