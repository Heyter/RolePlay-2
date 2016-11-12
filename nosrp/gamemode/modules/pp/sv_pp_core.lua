function PLUGINS.PP.PhysgunCanPickup( ply, ent )
    if !(IsValid( ply )) then return false end
    if !(IsValid( ent )) then return false end
    if IsDoor( ent ) then return false end
    
    local result = false
    local owner = nil
    ent.owner = ent.owner or "None"
    if ent.owner != "None" then
        owner = FindPlayerBySteamID( ent.owner )
    end
    
    if owner == ply then result = true end
    if !(owner == ply) then result = false end
    if IsValid( owner ) && owner:IsBuddy( ply ) then result = true end
    if !(ent:GetClass() == "nosrp_prop") then result = false end
    
    if ply:IsAdmin() then result = true end
    
    return result
end
hook.Add( "PhysgunPickup", "PLUGINS.PP.PhysgunCanPickup", PLUGINS.PP.PhysgunCanPickup )


function PLUGINS.PP.PhysgunCanReload( wep, ply )
    if !(IsValid( ply )) then return false end
    local ent = ply:GetEyeTrace().Entity
    if !(IsValid( ent )) then return false end
    if IsDoor( ent ) then return false end
    
    local result = false
    local owner = nil
    ent.owner = ent.owner or "None"
    
    if ent.owner != "None" then
        owner = FindPlayerBySteamID( ent.owner )
    end
    
    if owner == ply then result = true end
    if !(owner == ply) then result = false print("no") end
    if IsValid( owner ) && owner:IsBuddy( ply ) then result = true print("ok") end
    if !(ent:GetClass() == "nosrp_prop") then result = false end
    
    if ply:IsAdmin() then result = true end
    return result
end
hook.Add( "OnPhysgunReload", "PLUGINS.PP.PhysgunCanReload", PLUGINS.PP.PhysgunCanReload )
