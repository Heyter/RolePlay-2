RP.RPGivenNames = {}

function RP.IsRPNameFree( name )
    for k, v in pairs( RP.RPGivenNames ) do
        if string.lower( v ) == string.lower( name ) then return false end
    end
    return true
end

if SERVER then
    util.AddNetworkString( "RP_LoadGivenRPNames" )
    util.AddNetworkString( "RP_ChangeName" )
    util.AddNetworkString( "RP_DenyNameChange" )
    util.AddNetworkString( "RP_AcceptNameChange" )
    util.AddNetworkString( "RP_WantNameChange" )
    
    function RP.LoadGivenRPNames()
        Query("SELECT * FROM players", function( data )
            for k, v in pairs( data ) do
                table.insert( RP.RPGivenNames, v.rpname )
            end
            
            net.Start( "RP_LoadGivenRPNames" )
                net.WriteTable( RP.RPGivenNames )
            net.Send( player.GetAll() )
        end)
    end
    timer.Simple( 10, function() RP.LoadGivenRPNames() end)
    
    function RP.ForceNameChange( ply )
        ply.namechange_forced = true
        ply:SendLua( 'OpenNameChangePanel()' )
    end
    
    function RP.DoNameChange( ply )
        if !(ply:CanAfford( SETTINGS.NameChangeCost )) then
            net.Start( "NPC_DialogOpen" )
                net.WriteEntity( ply )
                net.WriteString( "CANT_DO_NAMECHANGE" )
            net.Send( ply )
            return
        else
            ply.namechange_forced = false
            ply:SendLua( 'OpenNameChangePanel()' )
        end
    end
    net.Receive( "RP_WantNameChange", function( data, ply ) RP.DoNameChange( ply ) end )
    
    hook.Add( "PlayerAuthed", "RP_SendGivenRPNames", function( ply )
        net.Start( "RP_LoadGivenRPNames" )
            net.WriteTable( RP.RPGivenNames )
        net.Send( ply )
        
        ply.namechange_forced = false
    end)
    
    net.Receive( "RP_ChangeName", function( data, ply )
        local name = (net.ReadString() or "")
        if name == "" then return end
        if !(RP.IsRPNameFree( name )) then 
            net.Start( "RP_DenyNameChange" )
            net.Send( ply )
            
            return
        else
            net.Start( "RP_AcceptNameChange" )
            net.Send( ply )
            
            ply:SetRPVar( "rpname", name )
            if !(ply.namechange_forced) then
                ply:AddCash( -SETTINGS.NameChangeCost )
            end
            Query( "UPDATE players SET rpname = '" .. name .. "' WHERE sid = '" .. tostring(ply:SteamID()) .. "'", function() end )
            hook.Call( "NOSRP_PlayerChangeName", {}, ply )
        end
    end)
end

if CLIENT then
    net.Receive( "RP_LoadGivenRPNames", function()
        RP.RPGivenNames = (net.ReadTable() or {})
    end)
    
    function OpenNameChangePanel()
        
        local f = vgui.Create( "DFrame" )
        f:SetTitle( "" )
        f:SetSize( 450, 250 )
        f:Center()
        f:MakePopup()
        f.forgiven = CurTime() - 1
        f.Paint = function( self )
            draw.RoundedBox( 0, 0, 0, f:GetWide(), f:GetTall(), Color( 230,230,230,255 ) )
            draw.RoundedBox( 2, 0, 0, f:GetWide(), (f:GetTall()/6), HUD_SKIN.THEME_COLOR )
            draw.RoundedBox( 2, 0, (f:GetTall()/6) - 2, f:GetWide(), 2, Color( 0, 102, 204, 50 ) )
            draw.SimpleText( "Name - Switch", "RPNormal_35", 25, 3, Color( 255, 255, 255, 255 ) )
            
            draw.SimpleText( "Vorname:", "RPNormal_30", 25, self:GetTall()/4, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Nachname:", "RPNormal_30", 25, self:GetTall()/1.8, Color( 0, 0, 0, 200 ) )
            
            if self.forgiven > CurTime() then
                draw.SimpleText( "- Name vergeben -", "RPNormal_30", 250, 64, Color( 200, 0, 0, 200 ) )
            end
        end
        
        local first = vgui.Create( "DTextEntry", f )
        first:SetSize( f:GetWide() - 50, 30 )
        first:SetPos( 25, f:GetTall()/2.7 )
        first:SetText( "" )
        first:SetFont( "RPNormal_30" )
        first:SetTextColor( Color( 0, 0, 0, 200 ) )
        
        local last = vgui.Create( "DTextEntry", f )
        last:SetSize( f:GetWide() - 50, 30 )
        last:SetPos( 25, f:GetTall()/1.48 )
        last:SetText( "" )
        last:SetFont( "RPNormal_30" )
        last:SetTextColor( Color( 0, 0, 0, 200 ) )
        
        local accept = vgui.Create( "DButton", f )
        accept:SetSize( f:GetWide(), 35 )
        accept:SetPos( 0, f:GetTall() - 35 )
        accept:SetText( "" )
        accept.Paint = function( self )
            draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Akzeptieren", "RPNormal_25", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ), 1, 1 )
        end
        accept.DoClick = function()
            if tonumber( first:GetValue() ) then return end
            if tonumber( last:GetValue() ) then return end
            if string.len( first:GetValue() ) < 2 then return end
            if string.len( last:GetValue() ) < 2 then return end
            
            net.Start( "RP_ChangeName" )
                net.WriteString( tostring(first:GetValue()) .. " " .. tostring(last:GetValue()) )
            net.SendToServer()
        end
        
        net.Receive( "RP_DenyNameChange", function()
            f.forgiven = CurTime() + 5
            
        end)
        
        net.Receive( "RP_AcceptNameChange", function()
            f:Close()
        end)
    end
end