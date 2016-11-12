local holster = {}
holster.config = {}
holster.weapons = {}

holster.config.draw_distance = 1200
holster.config.max_draws = 5


holster.weapons["m9k_colt1911"] = {
    type = "pistol",
    description = "",
    parent = "ValveBiped.Bip01_R_Tigh",
    forward = -7.5,
    right = 3,
    up = 2,
    ang = Angle( 190, 0, 45 )
}
holster.weapons["m9k_m92beretta"] = {
    type = "pistol",
    description = "",
    parent = "ValveBiped.Bip01_R_Tigh",
    forward = -8,
    right = -3,
    up = -3,
    ang = Angle( 10, 0, -15 )
}
holster.weapons["m9k_deagle"] = {
    type = "pistol",
    description = "",
    parent = "ValveBiped.Bip01_R_Tigh",
    forward = -7.5,
    right = 3,
    up = 2,
    ang = Angle( 190, 0, 45 )
}
holster.weapons["m9k_auga3"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = -3,
    right = 5,
    up = -3,
    ang = Angle( 0, 0, 0 )
}
holster.weapons["m9k_mossberg590"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = -8,
    right = 6,
    up = -4,
    ang = Angle( 0, 0, 0 )
}
holster.weapons["m9k_uzi"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = -0,
    right = 6,
    up = -4,
    ang = Angle( 5, 0, 0 )
}
holster.weapons["m9k_val"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = 3,
    right = 3.7,
    up = 1,
    ang = Angle( 90, 0, 30 )
}
holster.weapons["m9k_m416"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = -8,
    right = 6,
    up = -4,
    ang = Angle( 0, 0, 0 )
}
holster.weapons["m9k_ak74"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = -6,
    right = 4.7,
    up = -1,
    ang = Angle( 0, 0, 0 )
}
holster.weapons["m9k_m24"] = {
    type = "rifle",
    description = "",
    parent = "ValveBiped.Bip01_Spine2",
    forward = 0,
    right = 6,
    up = 0,
    ang = Angle( -90, -10, 0 )
}

function holster.CheckForWeapons( ply )
    local weps = {}
    for k, v in pairs( ply:GetWeapons() ) do
        if !(IsValid( v )) then continue end
        if !(IsValid( ply:GetActiveWeapon() )) then continue end
        if ply:GetActiveWeapon():GetClass() == v:GetClass() then continue end
        if !( holster.weapons[v:GetClass()] ) or holster.weapons [v:GetClass()] == nil then continue end
        ply.holster[v:GetClass()] = ply.holster[v:GetClass()] or {}
        ply.holster[v:GetClass()].ent = ply.holster[v:GetClass()].ent or nil
        if IsValid( ply.holster[v:GetClass()].ent ) then continue end
        weps[v:GetClass()] = {model = v:GetModel()}
    end
    
    for k, v in pairs( ply.holster ) do
        if v or v != nil then
            if holster.weapons[k] == nil then 
                if IsValid( v.ent ) then v.ent:Remove() v.ent = nil end
                continue
            end
            v.ent = v.ent or nil
            if !(IsValid( ply:GetActiveWeapon() )) then continue end
            if v.ent != nil && IsValid( v.ent ) && ply:GetActiveWeapon():GetClass() == k then v.ent:Remove() continue end
            if v.ent != nil && IsValid( v.ent ) then
                local tbl = holster.weapons[ k ]
                local bonePos, boneAng = ply:GetBonePosition( ply:LookupBone( holster.weapons[ k ].parent ) or 0 )
                v.ent:SetPos( bonePos + boneAng:Forward( ) * tbl.forward + boneAng:Right( ) * tbl.right + boneAng:Up( ) * tbl.up )
	   	   	   	         v.ent:SetAngles( boneAng + tbl.ang )
            end
            
            if v.ent != nil && v.ent:IsValid() && (!v.ent:GetParent( ) or !v.ent:GetParent( ):IsValid( )) then
 	   	   	            v.ent:SetParent( ply )
 	   	   	        end
        end
    end
    
    return weps
end

hook.Add( "Think", "HolsterThink", function()
    for k, ply in pairs( player.GetAll() ) do
        ply.holster = ply.holster or {}
        if !(ply:Alive()) then 
            for _, w in pairs( ply.holster ) do
                if IsValid( w.ent ) then w.ent:Remove() end
            end
            ply.holster = {}
            continue 
        end
        if ply == LocalPlayer() && LocalPlayer():ShouldDrawLocalPlayer() == false then continue end
        if ply:GetPos():Distance( LocalPlayer():GetPos() ) > holster.config.draw_distance then 
            for _, w in pairs( ply.holster ) do
                if IsValid( w.ent ) then w.ent:Remove() end
            end
            continue 
        end
        
        local weps = holster.CheckForWeapons( ply ) or {}
        
        for class, wep in pairs( weps ) do
            local tbl = holster.weapons[ class ]
            ply.holster[class].ent = ply.holster[class].ent or nil
            if ply.holster[class].ent != nil && IsValid( ply.holster[class].ent ) then continue end
            local bonePos, boneAng = ply:GetBonePosition( ply:LookupBone( holster.weapons[ class ].parent ) or 0 )
            local ent = ents.CreateClientProp( wep.model )
            ent:SetPos( bonePos + boneAng:Forward( ) * tbl.forward + boneAng:Right( ) * tbl.right + boneAng:Up( ) * tbl.up )
            ent:SetAngles( boneAng + tbl.ang )
            ent:SetParent( ply )
            ply.holster[class] = {ent=ent, type=tbl.type, desc=tbl.description}
        end
    end
end)