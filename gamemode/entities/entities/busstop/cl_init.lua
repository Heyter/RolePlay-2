include("shared.lua")
local bus_travel = false
local bus_wait = 0
local stop = nil

net.Receive( "BUSSTOP_DoTravel", function()
    local stop = net.ReadEntity()
    local time = tonumber(net.ReadString())
    
    bus_wait = time
    stop = stop
    bus_travel = true
    surface.PlaySound( "buttons/button9.wav" )
end)

net.Receive( "BUSSTOP_FinishTravel", function()
    local sound = tonumber(net.ReadString())
    sound = sound or 0
    
    bus_travel = false
    bus_wait = 0
    
    if sound == 1 then surface.PlaySound( "buttons/button10.wav" ) end
end)

hook.Add( "HUDPaint", "BUSSTOP.Paint", function()
    local alpha = 0
    
    if !(bus_travel) then return end
    
    local start = ( CurTime() - BUSSTOP.SETTINGS.WaitTime )
    if (bus_wait - CurTime()) <= BUSSTOP.SETTINGS.FadeTime + 0.3 then
        local combined = (bus_wait - CurTime())
        alpha = (255 / BUSSTOP.SETTINGS.FadeTime) * (combined -0.3)
    else
        local combined = (bus_wait - start) - (bus_wait - CurTime())
        alpha = (255 / BUSSTOP.SETTINGS.FadeTime) * (combined)
    end
    draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 - alpha ) )
end)

function ENT:Initialize()
    
end

function ENT:Draw()
	self:DrawModel()
    
    local pos = self:LocalToWorld( Vector( 31.6, 0, 0 ) )
    local ang = self:LocalToWorldAngles( Angle( 0, 90, 90 ) )
    local info = self:FindMe()
    
    if info == nil then return end
    cam.Start3D2D( pos, ang, .5 )
        draw.SimpleText( info.name, "Trebuchet22", 0, -188, Color( 255, 255, 255, 255 ), 1 )
    cam.End3D2D()
    
    pos = self:LocalToWorld( Vector( 25, -73, 0 ) )
    ang = self:LocalToWorldAngles( Angle( 0, 180, 90 ) )
    
    cam.Start3D2D( pos, ang, .5 )
        draw.RoundedBox( 0, 0, -150, 100, 130, Color( 200, 200, 200, 255 ) )
        draw.RoundedBox( 0, 0, -150, 100, 12, Color( 0, 153, 204, 255 ) )
    cam.End3D2D()
    
    cam.Start3D2D( pos, ang, .2 )
        draw.SimpleText( "NOS - Gaming", "Trebuchet22", 65, -370, Color( 230, 230, 230, 200 ) )
    cam.End3D2D()
    
    pos = self:LocalToWorld( Vector( 25, -80, 0 ) )
    ang = self:LocalToWorldAngles( Angle( 0, 180, 90 ) )
    
    cam.Start3D2D( pos, ang, .5 )
        draw.RoundedBox( 0, 0, -150, 100, 130, Color( 200, 200, 200, 255 ) )
    cam.End3D2D()
    
    
    // Wait Notify
    pos = self:LocalToWorld( Vector( 28, 68, 0 ) )
    ang = self:LocalToWorldAngles( Angle( 0, -90, 90 ) )
    
    if bus_travel then
        cam.Start3D2D( pos, ang, .5 )
            draw.RoundedBox( 0, 0, -170, 290, 188, Color( 0, 150, 0, 150 ) )
            draw.SimpleText( "Warte Hier...", "Trebuchet22", 152, -100, Color( 255, 255, 255, 150 ), 1 )
            if math.Round(bus_wait - CurTime()) > 0 then
                draw.SimpleText( math.Round(bus_wait - CurTime()), "Trebuchet22", 152, -80, Color( 255, 255, 255, 150 ), 1 )
            end
        cam.End3D2D()
    end
    
    // Draw the inside menu
   BUSSTOP = BUSSTOP or {}
   BUSSTOP.STOPS = BUSSTOP.STOPS or {}
   for k, v in pairs( BUSSTOP.STOPS ) do
        local info = v
        if !(IsValid( info.ent )) then continue end
        
        vgui.Start3D2D( info.ent:LocalToWorld( Vector( 22, -73, 65 ) ), info.ent:LocalToWorldAngles( Angle( 0, 180, 90 ) ), .2 )
            if IsValid( info.ent.frame ) then info.ent.frame:Paint3D2D() end
        vgui.End3D2D()
   end
end

function ENT:FindMe()
    BUSSTOP.STOPS = BUSSTOP.STOPS or {}
    for k, v in pairs( BUSSTOP.STOPS ) do
        if self:GetPos():Distance( v.pos ) < 5 then return v end
    end
    return nil
end

function ENT:Think()
    BUSSTOP.STOPS = BUSSTOP.STOPS or {}
    for k, v in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 500 ) ) do
        if !(IsValid( v )) then continue end
        if !(v:GetClass()) == "busstop" then continue end
        local me = self:FindMe()
        if me == nil then continue end
        
        if me.pos:Distance( v:GetPos() ) < 5 then
            if !(IsValid( me.ent )) then me.ent = v continue end
        end
    end
    local info = self:FindMe()
    self:DrawMenu( info )
end

function ENT:DrawMenu( info )
    local origin = Vector( 300, -1919, 200 )
    self.frame = self.frame or {}
    local dist = LocalPlayer():GetPos():Distance( self:GetPos() )
    
    if IsValid( self.frame ) then 
        if dist > 100 then self.frame:Remove() end
        return 
    end
    
    if dist > 100 then return end

    frame = vgui.Create( "DFrame" )
    frame:SetPos( 0, 0 )
    frame:ShowCloseButton( false )
    frame:SetSize( 219, 250 )
    frame:SetTitle( "" )
    frame.Paint = function()
        draw.RoundedBox( 0, 0, 0, frame:GetWide(), frame:GetTall(), Color( 0, 0, 0, 100 ) )
    end
    
    local new_tbl = {}
    for k, v in pairs( BUSSTOP.STOPS ) do
        if info.name == v.name then continue end
        table.insert( new_tbl, {i = v, index = k} )
    end
    for k, v in pairs( new_tbl ) do
        local btn = vgui.Create( "DButton", frame )
        btn:SetPos( 0, 25*(k-1) )
        btn:SetTall( 20 )
        btn:SetWide( frame:GetWide() )
        btn:SetText( " " )
        btn.col = Color( 255, 255, 255, 150 )
        btn.DoClick = function()
            net.Start( "BUSSTOP_WantTravel" )
                net.WriteString( v.index )
                net.WriteEntity( info.ent )
            net.SendToServer()
        end
        btn.OnCursorEntered = function()
            if LocalPlayer():CanAfford( v.i.cost ) then
                btn.col = Color( 0, 200, 0, 150 )
            else
                btn.col = Color( 200, 0, 0, 150 )
            end
        end
        btn.OnCursorExited = function()
            btn.col = Color( 255, 255, 255, 150 )
        end
        btn.Paint = function()
            draw.RoundedBox( 0, 0, 0, btn:GetWide(), btn:GetTall(), btn.col )
            draw.SimpleText( v.i.name, "Default", btn:GetWide()/2.5, btn:GetTall()/2, Color( 0, 153, 204, 255 ), 1, 1 )
            draw.SimpleText( v.i.cost .. ",-EUR", "Default", btn:GetWide()/1.2, btn:GetTall()/2, Color( 0, 153, 204, 255 ), 1, 1 )
        end
    end

    self.frame = frame
end