SETTINGS.PICKUP_TIME = 0.5
SETTINGS.PICKUP_DISTANCE = 150
SETTINGS.PICKUP_DELAY = 1
SETTINGS.PICKUP_BLACKLIST  = {"item_sale"}

PLUGINS.PICKUP = PLUGINS.PICKUP or {}
PLUGINS.PICKUP.Registered = PLUGINS.PICKUP.Registered or {}

if SERVER then
    util.AddNetworkString( "NOSRP_SendUseData" )
    util.AddNetworkString( "NOSRP_DeleteUseData" )
    
    local function IsBlacklistedUseItem( item )
        for k, v in pairs( SETTINGS.PICKUP_BLACKLIST ) do
            if type( item ) == "entity" then
                if v == item:GetClass() then return true end
            else
                if v == item then return true end
            end
        end
        return false
    end
    
    hook.Add( "KeyPress", "NOSRP_UsePlugin_Use", function( ply, key )
        if key != IN_USE then return end
        if !(IsValid( ply )) then return end
        if (ply:InVehicle()) then return end
        
        ply.PickupDelay = ply.PickupDelay or (CurTime() + SETTINGS.PICKUP_DELAY)
        if ply.PickupDelay > CurTime() then return end
        ply.PickupDelay = CurTime() + SETTINGS.PICKUP_DELAY
        
        local trace = ply:GetEyeTrace()
        if !(IsValid( trace.Entity )) then return end
        if !(trace.Entity.owner == ply:SteamID()) then return end
        if trace.Entity.locked then return end
        if trace.StartPos:Distance( trace.HitPos ) > SETTINGS.PICKUP_DISTANCE then return end
        if IsBlacklistedUseItem( trace.Entity ) then return end
        --if !(itemstore.items.CanPickup( trace.Entity:GetClass() )) then return end
        
        ply.pickup_registered = true
        
        local e_t = trace.Entity:GetPhysicsObject():GetMass()/100
        table.insert( PLUGINS.PICKUP.Registered, {ply=ply,ent=trace.Entity,time=CurTime()+SETTINGS.PICKUP_TIME+e_t} )
        
        net.Start( "NOSRP_SendUseData" )
            net.WriteEntity( trace.Entity )
            net.WriteString( tostring(CurTime()+SETTINGS.PICKUP_TIME+e_t) )
        net.Send( ply ) 
    end)
    
    hook.Add( "KeyRelease", "NOSRP_UsePlugin_UseRelease", function( ply, key )
        if key != IN_USE then return end
        if !( IsValid( ply ) ) then return end
        if !( ply.pickup_registered ) then return end
        
        for k, v in pairs( PLUGINS.PICKUP.Registered ) do
            if !( IsValid( v.ply ) ) then table.remove( PLUGINS.PICKUP.Registered, k ) continue end
            if !( v.ply == ply ) then continue end
            
            table.remove( PLUGINS.PICKUP.Registered, k ) 
        end
        
        ply.pickup_registered = false
        
        net.Start( "NOSRP_DeleteUseData" )
        net.Send( ply )
    end)
    
    hook.Add( "Think", "NOSRP_UsePlugin_Think", function()
        for k, v in pairs( PLUGINS.PICKUP.Registered ) do
            if v.time < CurTime() then
                v.ply:PickupItem( v.ent )
                table.remove( PLUGINS.PICKUP.Registered, k )
                continue
            end
        end
    end)
end


if CLIENT then
    local message_time = CurTime() - 1
	local recieved_time = CurTime()
    local ent = ent or nil
    
    net.Receive( "NOSRP_SendUseData", function() ent=net.ReadEntity() message_time=tonumber(net.ReadString()) recieved_time=CurTime() end )
    net.Receive( "NOSRP_DeleteUseData", function() message_time=(CurTime() - 1) ent=nil end)
    
    local function DrawUseHUD()
        if message_time < CurTime() then return end
        if !(IsValid( ent )) then return end
        
		local pos = {}
        pos.x, pos.y = ScrW()/2, ScrH()/2
        local time = math.Round( message_time - CurTime() )
        
        if time < 1 then time = "jetzt!" end
        
        local text = "Hebe auf... "
        local font = "RPNormal_25"
        surface.SetFont( font )
        local w, h = surface.GetTextSize( text )
        
        local col = Color( 0, 0, 0, 150 )
        /*
        local triangle =
        {
        	{ x = pos.x, y = pos.y },
        	{ x = pos.x+25, y = pos.y-25 },
        	{ x = pos.x+25, y = pos.y+25 }
        
        }
        
        surface.SetDrawColor( Color( 0, 153, 204, 150 ) )
        draw.NoTexture()
        surface.DrawPoly( triangle )
        
        draw.RoundedBox( 0, pos.x + 24.8, pos.y - 25, 10 + w, 50, col )
    
        draw.SimpleText( text, font, pos.x + 30, pos.y - h/2, Color( 0, 153, 204, 150 ) )
        */
		
		local time = message_time - recieved_time
		local percent = (1 / time) * (message_time - CurTime())
		
		draw.RoundedBox( 4, pos.x - 2, pos.y, w, h, Color( 255, 255, 255, 255 ) )
		
		draw.SimpleText( text, "RPNormal_21", pos.x + 2, pos.y + 2, Color( 0, 0, 0, 230 ), 0, 0 )
		DrawCircle( pos.x + w, pos.y +h/2, h/1.8, 1, Color( 150, 150, 150, 150 ) )
		DrawCircle( pos.x + w, pos.y +h/2, h/1.8, percent, HUD_SKIN.THEME_COLOR  )
		DrawCircle( pos.x + w, pos.y +h/2, (h/1.8) - 4, 1, Color( 255, 255, 255, 255 ) )
		
		draw.SimpleText( "i", "Trebuchet22", pos.x + w - 0.5, pos.y +h/2, Color( 50, 50, 50, 200 ), 1, 1 )
    end
    hook.Add( "HUDPaint", "NOSRP_UsePlugin_DrawHUD", DrawUseHUD )
end
