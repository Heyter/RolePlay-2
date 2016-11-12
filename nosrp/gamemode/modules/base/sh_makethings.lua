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
        elseif Time > 59 then
            Time = math.floor( Time / 60 )
            local Hours = Time % 24
            return Hours .. " Stunden "
        elseif Time > 1439 then
            Time = math.floor( Time / 60 )
            local Hours = Time % 24
            Time = math.floor( Time / 24 )
            local Days = Time
            return Days .. " Tage, " .. Hours .. " Stunden"
        end
    end
end