

net.Receive( "ECONOMY_SEND_SETTINGS", function( um )
    local tbl = net.ReadTable()
    local zins_tbl = net.ReadTable()
    
    GAMEMODE.TEAMS = tbl
    ECONOMY = zins_tbl
end)