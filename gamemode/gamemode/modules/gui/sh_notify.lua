if CLIENT then
    surface.CreateFont( "GModNotify",
    {
    font	= "Arial",
    size	= 20,
    weight	= 1000
    })

    PLUGINS.NOTIFY = {}

    NOTIFY_GENERIC	= 0
    NOTIFY_ERROR	= 1
    NOTIFY_UNDO	= 2
    NOTIFY_HINT	= 3
    NOTIFY_CLEANUP	= 4

    module( "notification", package.seeall )

    local NoticeMaterial = {}

    NoticeMaterial[ NOTIFY_GENERIC ] = Material( "vgui/notices/generic" )
    NoticeMaterial[ NOTIFY_ERROR ] = Material( "vgui/notices/error" )
    NoticeMaterial[ NOTIFY_UNDO ] = Material( "vgui/notices/undo" )
    NoticeMaterial[ NOTIFY_HINT ] = Material( "vgui/notices/hint" )
    NoticeMaterial[ NOTIFY_CLEANUP ] = Material( "vgui/notices/cleanup" )

    local Notices = {}

    function PLUGINS.NOTIFY.AddProgress( uid, text )

        local parent = nil
        if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

        local Panel = vgui.Create( "NoticePanel", parent )
        Panel.StartTime = SysTime()
        Panel.Length = 1000000
        Panel.VelX	= -5
        Panel.VelY	= 0
        Panel.fx = ScrW() + 200
        Panel.fy = ScrH()
        Panel:SetAlpha( 255 )
        Panel:SetText( text )
        Panel:SetPos( Panel.fx, Panel.fy )
        Panel:SetProgress()

        Notices[ uid ] = Panel
    end

    function PLUGINS.NOTIFY.Kill( uid )

        if ( !IsValid( Notices[ uid ] ) ) then return end

        Notices[ uid ].StartTime = SysTime()
        Notices[ uid ].Length = 0.8

    end

    function PLUGINS.NOTIFY.AddNotify( text, type, length, letter )
    
        letter = letter or "i"
        if letter == nil then letter = "i" end

        local parent = nil
        if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

        local Panel = vgui.Create( "NoticePanel", parent )
        Panel.StartTime = SysTime()
        Panel.Length = length
        Panel.VelX	= -5
        Panel.VelY	= 0
        Panel.fx = ScrW() + 200
        Panel.fy = ScrH()
        Panel:SetAlpha( 255 )
        local l = string.len( text )
        local s = ""
        for i=0, l + 10 do
            s = s .. " "
        end
        Panel:SetText( s )
        Panel:SetLegacyType( type )
        Panel:SetPos( Panel.fx, Panel.fy )
        Panel.Paint = function( self )
            local timeleft = Panel.StartTime - (SysTime() - Panel.Length)
            local rech = 1 / Panel.Length --Panel:GetWide() / Panel.Length
            local wide = rech * timeleft
            
            draw.RoundedBox( 4, 0, 9, Panel:GetWide() - 18, Panel:GetTall() - 20, Color( 255, 255, 255, 255 ) )
            
            surface.SetFont( "RPNormal_21" )
            local w, h = surface.GetTextSize( text )
            
            draw.SimpleText( text, "RPNormal_21", 8, Panel:GetTall() / 2.1, Color( 0, 0, 0, 230 ), 0, 1 )
            DrawCircle( Panel:GetWide() - 16, Panel:GetTall()/2, 14, 1, Color( 150, 150, 150, 150 ) )
            DrawCircle( Panel:GetWide() - 16, Panel:GetTall()/2, 14, wide, HUD_SKIN.THEME_COLOR  )
            DrawCircle( Panel:GetWide() - 16, Panel:GetTall()/2, 10, 1, Color( 255, 255, 255, 255 ) )
            
            draw.SimpleText( letter, "Trebuchet22", Panel:GetWide() - 16, Panel:GetTall()/2, Color( 50, 50, 50, 200 ), 1, 1 )
        end

        table.insert( Notices, Panel )

    end

    function PLUGINS.NOTIFY.Die( uid, delay )

        MsgN( "PLUGINS.NOTIFY.Die", uid, delay )

    end

    -- This is ugly because it's ripped straight from the old notice system
    function PLUGINS.NOTIFY.UpdateNotice( i, Panel, Count )

        local x = Panel.fx
        local y = Panel.fy

        local w = Panel:GetWide()
        local h = Panel:GetTall()

        w = w + 16
        h = h + 16

        local ideal_y = ScrH() - (Count - i) * (h-12) - 350
        local ideal_x = ScrW() - w - 20

        local timeleft = Panel.StartTime - (SysTime() - Panel.Length)

        -- Cartoon style about to go thing
        if ( timeleft < 0.7 ) then
        ideal_x = ideal_x - 50
        end

        -- Gone!
        if ( timeleft < 0.2 ) then

        ideal_x = ideal_x + w * 2

        end

        local spd = FrameTime() * 15

        y = y + Panel.VelY * spd
        x = x + Panel.VelX * spd

        local dist = ideal_y - y
        Panel.VelY = Panel.VelY + dist * spd * 1
        if (math.abs(dist) < 2 && math.abs(Panel.VelY) < 0.1) then Panel.VelY = 0 end
        local dist = ideal_x - x
        Panel.VelX = Panel.VelX + dist * spd * 1
        if (math.abs(dist) < 2 && math.abs(Panel.VelX) < 0.1) then Panel.VelX = 0 end

        -- Friction.. kind of FPS independant.
        Panel.VelX = Panel.VelX * (0.95 - FrameTime() * 8 )
        Panel.VelY = Panel.VelY * (0.95 - FrameTime() * 8 )

        Panel.fx = x
        Panel.fy = y
        Panel:SetPos( Panel.fx, Panel.fy )

    end


    function PLUGINS.NOTIFY.Update()

        if ( !Notices ) then return end

        local i = 0
        local Count = table.Count( Notices );
        for key, Panel in pairs( Notices ) do

        i = i + 1
        PLUGINS.NOTIFY.UpdateNotice( i, Panel, Count )

        end

        for k, Panel in pairs( Notices ) do

        if ( !IsValid(Panel) || Panel:KillSelf() ) then Notices[ k ] = nil end

        end

    end

    hook.Add( "Think", "NotificationThink", PLUGINS.NOTIFY.Update )

    local PANEL = {}

    --[[---------------------------------------------------------
    Name: Init
    -----------------------------------------------------------]]
    function PANEL:Init()

        self:DockPadding( 3, 3, 3, 3 )

        self.Label = vgui.Create( "DLabel", self )
        self.Label:Dock( FILL )
        self.Label:SetFont( "GModNotify" )
        self.Label:SetTextColor( Color( 255, 255, 255, 255 ) )
        self.Label:SetExpensiveShadow( 1, Color( 0, 0, 0, 200 ) )
        self.Label:SetContentAlignment( 5 )

        self:SetBackgroundColor( Color( 20, 20, 20, 255*0.6 ) )

    end

    function PANEL:SetText( txt )

        self.Label:SetText( txt )
        self:SizeToContents()

    end

    function PANEL:SizeToContents()

        self.Label:SizeToContents()

        local width = self.Label:GetWide()

        if ( IsValid( self.Image ) ) then

        width = width + 32 + 8

        end

        width = width + 20
        self:SetWidth( width )

        self:SetHeight( 32 + 6 )

        self:InvalidateLayout()

    end

    function PANEL:SetLegacyType( t )

        /*
        self.Image = vgui.Create( "DImage", self )
        self.Image:SetMaterial( NoticeMaterial[ t ] )
        self.Image:SetSize( 32, 32 )
        self.Image:Dock( LEFT )
        self.Image:DockMargin( 0, 0, 8, 0 )

        self:SizeToContents()
        */
        
    end


    function PANEL:SetProgress()

        -- Quick and dirty, just how I like it.
        self.Paint = function( s, w, h )

        self.BaseClass.Paint( self, w, h )


        surface.SetDrawColor( 0, 100, 0, 150 )
        surface.DrawRect( 4, self:GetTall() - 10, self:GetWide() - 8, 5 )

        surface.SetDrawColor( 0, 50, 0, 255 )
        surface.DrawRect( 5, self:GetTall() - 9, self:GetWide() - 10, 3 )

        local w = self:GetWide() * 0.25
        local x = math.fmod( SysTime() * 200, self:GetWide() + w ) - w

        if ( x + w > self:GetWide() - 11 ) then w = ( self:GetWide() - 11 ) - x end
        if ( x < 0 ) then w = w + x; x = 0 end

        surface.SetDrawColor( 0, 255, 0, 255 )
        surface.DrawRect( 5 + x, self:GetTall() - 9, w, 3 )

        end

    end

    function PANEL:KillSelf()

        if ( self.StartTime + self.Length < SysTime() ) then

        self:Remove()
        return true

        end

        return false
    end
    
    net.Receive( "GM_AddNotify", function()
        local text = net.ReadString() or "Unknown"
        local time = tonumber( net.ReadString() or 2 )
        local icon = 1
        local letter = tostring( net.ReadString() or "i" )
        
        PLUGINS.NOTIFY.AddNotify( text, icon, time, letter )
    end)

    vgui.Register( "NoticePanel", PANEL, "DPanel" )
end


if SERVER then
    util.AddNetworkString( "GM_AddNotify" )
    
    function PLAYER_META:RPNotify( text, time, letter )
        letter = letter or "i"
        
        net.Start( "GM_AddNotify" )
            net.WriteString( tostring(text) )
            net.WriteString( tostring(time) )
            net.WriteString( tostring(letter) )
        net.Send( self )
    end
    
end