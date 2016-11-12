RP.PLUGINS.PLAYTIME = {}
RP.PLUGINS.PLAYTIME.Players = {}

--------------------------------------------
--  PLAYER STUFF
--------------------------------------------
function PLAYER_META:LoadPlaytime()
    Query( "SELECT * FROM players WHERE sid = '" .. self:SteamID() .. "'", function( q )
        if !(q[1]) then return end
        
        self:SetRPVar( "playtime", q[1].playtime )
        
        for k, v in pairs( RP.PLUGINS.PLAYTIME.Players ) do
            if v.sid == self:SteamID() then
                table.remove( RP.PLUGINS.PLAYTIME.Players, k )
                continue
            end
        end
        
        table.insert( RP.PLUGINS.PLAYTIME.Players, {ply=self, sid=self:SteamID(), playtime=self:GetRPVar( "playtime" ), nextcount=CurTime() + 60} )
    end)
end

function PLAYER_META:SavePlaytime()
    Query( "UPDATE players SET playtime = " .. (self:GetRPVar( "playtime" ) or 0) .. " WHERE sid = '" .. self:SteamID() .. "'", function( q ) end)
end

function PLAYER_META:HasPlaytime( time )
    return self:GetRPVar( "playtime" ) >= time
end
--------------------------------------------
--  PLAYER STUFF - END
--------------------------------------------

hook.Add( "PlayerAuthed", "RP_CreatePlaytimeTable", function( ply )
    ply:LoadPlaytime()
end)
hook.Add( "PlayerDisconnected", "RP_SavePlayerPlaytime", function( ply )
    ply:SavePlaytime()
end)

function RP.PLUGINS.PLAYTIME.Think()
    for k, v in pairs( RP.PLUGINS.PLAYTIME.Players ) do
        if !(IsValid( v.ply )) then table.remove( RP.PLUGINS.PLAYTIME.Players, k ) continue end
        if v.nextcount < CurTime() then
            v.nextcount = CurTime() + 300
            local playtime = v.ply:GetRPVar( "playtime" ) or 0
            
            v.ply:SetRPVar( "playtime", playtime + 5 )
            v.ply:SavePlaytime()
        end
    end
end
hook.Add( "Think", "RP.PLUGINS.PLAYTIME:Think", function() RP.PLUGINS.PLAYTIME.Think() end )