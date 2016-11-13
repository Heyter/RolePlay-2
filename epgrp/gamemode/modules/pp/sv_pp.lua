file.CreateDir( "nosrp_pp" )
function PLUGINS.PP.LoadPlayer( ply )
    if !(file.Exists( "nosrp_pp/" .. tostring(ply:UniqueID()) .. ".txt", "DATA" )) then
        local tbl = {
            recent_buddies = {},
            buddies = {},
        }
        ply:SetRPVar( "pp_table", tbl )
        file.Write( "nosrp_pp/" .. tostring(ply:UniqueID()) .. ".txt", util.TableToJSON( tbl ) )
    else
        local tbl = file.Read( "nosrp_pp/" .. tostring(ply:UniqueID()) .. ".txt", "DATA" )
        if !(tbl) or tbl == "" then return end
        tbl = util.JSONToTable( tbl )
        
        tbl.recent_buddies = tbl.recent_buddies or {}
        tbl.buddies = tbl.buddies or {}
        
        ply:SetRPVar( "pp_table", tbl )
    end
end
hook.Add( "PlayerAuthed", "PLUGINS.PP.LoadPlayer", PLUGINS.PP.LoadPlayer )


function PLUGINS.PP.Save( ply )
    local tbl = ply:GetRPVar( "pp_table" )
    if !(tbl) then return end
    
    tbl.recent_buddies = tbl.recent_buddies or {}
    tbl.buddies = tbl.buddies or {}
    
    file.Write( "nosrp_pp/" .. tostring(ply:UniqueID()) .. ".txt", util.TableToJSON( tbl ) )
end


function PLUGINS.PP.AddBuddy( ply, buddy, access )
    access = access or {}
    print("called")
    if !(IsValid( ply )) then return end
    if !(ply:IsPlayer()) then return end
    if !(IsValid( buddy )) then return end
    if !(buddy:IsPlayer()) then  return end
    
    local buddy_table = ply:GetRPVar( "pp_table" )
    if !(buddy_table) then return end
    
    PrintTable( buddy_table )
    
    for index, item in pairs( buddy_table.buddies ) do
        if tostring(item.sid) == tostring(buddy:SteamID()) then buddy_table = table.RemoveByKey( buddy_table, index ) end
    end

    for k, v in pairs( buddy_table.recent_buddies ) do      // Remove him from the recent list, if exists
        if tostring(v.sid) == tostring(buddy:SteamID()) then buddy_table.recent_buddies = table.RemoveByKey( buddy_table.recent_buddies, k ) end
    end
    
    print( "Added" )
    buddy_table.buddies[tostring(buddy:SteamID())] = { name = (buddy:GetRPVar( "rpname" ) or buddy:Nick()), sid=buddy:SteamID(), access = access }
    ply:SetRPVar( "pp_table", buddy_table )
    PLUGINS.PP.Save( ply )
end

function PLUGINS.PP.RemoveBuddy( ply, buddy )
    if !(IsValid( ply )) then return end
    if !(ply:IsPlayer()) then return end
    
    local buddy_table = ply:GetRPVar( "pp_table" )
    if !(buddy_table) then return end
    buddy = buddy or "NULL"
    if buddy == "NULL" then buddy = "BOT" end

    //  Recent Buddy
    if #buddy_table.recent_buddies >= PLUGINS.PP.SETTINGS.Recent_History_Max then   //  Let's delete the last item
        table.remove( buddy_table.recent_buddies, #buddy_table.recent_buddies )
    end
    local found = false
    for _, v in pairs( buddy_table.recent_buddies ) do
        if tostring(v.sid) == tostring(buddy) then
            v.expires = CurTime() + PLUGINS.PP.SETTINGS.Recent_History_Last
            found = true
        end
    end

    local buddy_player = FindPlayerBySteamID( buddy ) or nil
    if !(found) then
        local name = ""
        if buddy_player == nil then name = "Unbekannt" else name = (buddy_player:GetRPVar( "rpname" ) or buddy_player:Nick()) end
        buddy_table.recent_buddies[buddy] = {name=name, expires = CurTime() + PLUGINS.PP.SETTINGS.Recent_History_Last}
    end
    
    //  The actual remove
    buddy_table.buddies = table.RemoveByKey( buddy_table.buddies, buddy )
    ply:SetRPVar( "pp_table", buddy_table )
    PLUGINS.PP.Save( ply )
end

util.AddNetworkString( "PP_AddBuddy" )
util.AddNetworkString( "PP_RemoveBuddy" )
net.Receive( "PP_AddBuddy", function( data, caller )
    local ply = net.ReadEntity()
    if !(IsValid( ply )) then return end
    if !(IsValid( caller )) then return end
    if !(ply:IsPlayer()) then return end
    
    PLUGINS.PP.AddBuddy( caller, ply )
end)

net.Receive( "PP_RemoveBuddy", function( data, caller )
    local buddy_steamid = tostring(net.ReadString())
    if !(IsValid( caller )) then return end
    
    PLUGINS.PP.RemoveBuddy( caller, buddy_steamid )
end)