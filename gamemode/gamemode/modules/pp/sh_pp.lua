// Don't Touch! ///////////////
PLUGINS.PP = PLUGINS.PP or {}
PLUGINS.PP.SETTINGS = {}
///////////////////////////////


// CONFIG   ///////////////////////////////////
PLUGINS.PP.SETTINGS.Recent_History_Max = 10         //  Die maximale Anzahl von Einträgen in der History
PLUGINS.PP.SETTINGS.Recent_History_Last = 2880      //  Wie lange die Freunde in der History bleiben
///////////////////////////////////////////////


function PLAYER_META:IsBuddy( ply )
    local tbl = self:GetBuddies()
    if !(tbl) then return false end
    
    for k, v in pairs( tbl ) do
        if tostring( k ) == tostring( ply:SteamID() ) then return true end
    end
    return false
end

function PLAYER_META:GetBuddies()
    return (self:GetRPVar( "pp_table" ).buddies or nil)
end

function PLAYER_META:GetRecentBuddies()
    return (self:GetRPVar( "pp_table" ).recent_buddies or nil)
end