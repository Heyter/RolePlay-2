include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
    
    local ang = Angle( 0, 0, 0 )
    ang:RotateAroundAxis( ang:Up(), 90 )
    ang:RotateAroundAxis( ang:Forward(), 90 )
    local min, max = self:GetRenderBounds()
    
    cam.Start3D2D( self:LocalToWorld( Vector( 16.5, 0, -7 ) ), self:LocalToWorldAngles(ang), .1 )
		draw.SimpleText( "Rüstungs Terminal", "RPNormal_50", 0, 0, Color( 255, 255, 255, 200 ), 1 )
	cam.End3D2D()
end

function ENT:Think()
end

net.Receive( "Supply_Box_Use", function( data )
    OpenSupplyPanel( net.ReadEntity() )
end)

function OpenSupplyPanel( box )
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 550, 650 )
    frame:SetTitle( "" )
    frame:SetPos( ScrW() - (frame:GetWide() + 5), (ScrH() - frame:GetTall())/2 )
    frame:MakePopup()
    frame:ShowCloseButton( false )
    frame.Paint = function( self )
        -- Background
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(230,230,230,255))
        surface.SetDrawColor(200,200,200)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        
        -- Top
        draw.RoundedBox(0,0,0,self:GetWide(),55,HUD_SKIN.THEME_COLOR)
        draw.DrawText("Rüstungs Box","RPNormal_30",25,5,Color(255,255,255,255),TEXT_ALIGN_LEFT)
        draw.DrawText("Hier kannst du deine Munition auffüllen","RPNormal_20",25,30,Color(255,255,255,255),TEXT_ALIGN_LEFT)
        
        draw.DrawText("!!! Wichtig !!!.","RPNormal_25",
        25,55,Color( 50, 50, 50, 200 ),TEXT_ALIGN_LEFT)
        draw.DrawText("Alle entestehenden Kosten werden von der Stadt bezahlt.","RPNormal_25",
        25,80,Color( 50, 50, 50, 200 ),TEXT_ALIGN_LEFT)
        draw.DrawText("Munition sollte nur gekauft werden, wenn sie wirklich nötig ist.","RPNormal_25",
        25,100,Color( 50, 50, 50, 200 ),TEXT_ALIGN_LEFT)
        draw.DrawText("Kaufen von Munition ohne aufweisbare Wichtigkeit ist ein Demote Grund!","RPNormal_25",
        25,120,Color( 200, 0, 0, 200 ),TEXT_ALIGN_LEFT)
    end
    
    local HideBtn = vgui.Create( "DButton", frame )
    HideBtn:SetSize( 100, 25 )
    HideBtn:SetPos( frame:GetWide() - 100, 0 )
    HideBtn:SetText( "" )
    HideBtn.DoClick = function() 
        net.Start( "Supply_Box_Close" ) 
            net.WriteEntity( box ) 
        net.SendToServer()
        
        frame:Close() 
    end
    HideBtn.Paint = function( self )
        draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.FULL_GREY )
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( "Close" )
        draw.SimpleText( "Close", "RPNormal_25", (self:GetWide() - w)/2, (self:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
    end
    
    local PropertySheet = vgui.Create( "DPropertySheet", frame )
    PropertySheet:SetPos( 0, 150 )
    PropertySheet:SetSize( frame:GetWide(), frame:GetTall() - 150 )
    
    local w_list = vgui.Create( "DPanelList" )
    w_list:SetPos( 0, 0 )
    w_list:SetSize( PropertySheet:GetWide() - 26, PropertySheet:GetTall() - 35 )
    w_list.Paint = function( self )
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(230,230,230,255))
    end
    
    PropertySheet:AddSheet( "Munition", w_list, "icon16/bomb.png", 
    false, false )
    
    
    -- Weapon thing
    local t = LocalPlayer():Team()
    local tbl = GAMEMODE.TEAMS[t]
    local i = 0
    
    for k, v in pairs( tbl.Weapons ) do
         local list_col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
        
        local w_tbl = weapons.GetStored( v ) or nil
        if w_tbl == nil then continue end
        w_tbl.NoSupplyShow = w_tbl.NoSupplyShow or false
        
        if v == "weapon_fists" then continue end
        
        if w_tbl.Primary.Ammo == "" then continue end
        if w_tbl.NoSupplyShow then continue end
        
        local p = vgui.Create( "DPanel" )
        p:SetSize( w_list:GetWide(), w_list:GetTall()/4 )
        p:SetPos( 0, 0 )
        p.Paint = function()
            draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), list_col )
            
            draw.SimpleText( w_tbl.PrintName, "RPNormal_35", p:GetTall() +  10, 15, Color( 50, 50, 50, 200 ) )
            draw.SimpleText( "Schaden: " .. tostring(w_tbl.Primary.Damage or 0), "RPNormal_25", 
            p:GetTall() +  10, 45, Color( 50, 50, 50, 200 ) )
            draw.SimpleText( "RPM: " .. tostring(w_tbl.Primary.RPM or 0), "RPNormal_25", 
            p:GetTall() +  10, 65, Color( 50, 50, 50, 200 ) )
            w_tbl.FiresUnderwater = w_tbl.FiresUnderwater or false
            local text = "Nein"
            if w_tbl.FiresUnderwater then text = "Ja" end
            draw.SimpleText( "Wasser Tauglich: " .. text, "RPNormal_25", 
            p:GetTall() +  10, 90, Color( 50, 50, 50, 200 ) )
        end

        local icon = vgui.Create( "DModelPanel", p )
        icon:SetModel( w_tbl.WorldModel or "error.mdl" )
        icon:SetPos( 10, 10 )
        icon:SetSize( p:GetTall() - 20, p:GetTall() - 20 )
        
        local max, min = icon:GetEntity():GetRenderBounds()
        icon:SetCamPos( Vector( .6, .6, 0.4 ) * min:Distance( max ) )
		      icon:SetLookAt( ( min + max ) / 4 )
        
        local refill = vgui.Create( "DButton", p )
        refill.state = 1
        refill:SetSize( 120, p:GetTall() / 4 )
        refill:SetText( "" )
        refill:SetPos( p:GetWide() - refill:GetWide() + 5, 5)
        refill.Paint = function( self )
            draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )
            if self.state == 1 then
                draw.SimpleTextOutlined( "Auffüllen", "RPNormal_25", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ),
                1, 1, 0, Color( 0, 0, 0, 255 ) )
            else
                draw.SimpleTextOutlined( tostring(GetSupplyAmmoPrice()) .. ",-EUR/ Kugel", "RPNormal_25", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ),
                1, 1, 0, Color( 0, 0, 0, 255 ) )
            end
        end
        refill.DoClick = function()
            surface.PlaySound( "npc/turret_floor/click1.wav" )
            net.Start( "Supply_Box_Refill" )
                net.WriteEntity( box )
                net.WriteString( w_tbl.Primary.Ammo )
            net.SendToServer()
        end
        refill.OnCursorEntered = function( self )
            self.state = 2
        end
        refill.OnCursorExited = function( self )
            self.state = 1
        end
        
        local repair = vgui.Create( "DButton", p )
        repair:SetSize( 120, p:GetTall() / 4 )
        repair:SetText( "" )
        repair:SetPos( p:GetWide() - refill:GetWide() + 5, (p:GetTall() / 4) + 10)
        repair.Paint = function( self )
            draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.FULL_GREY )
            draw.SimpleTextOutlined( "Reparieren", "RPNormal_25", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ),
            1, 1, 0, Color( 0, 0, 0, 255 ) ) 
        end
        
        w_list:AddItem( p )
    end
end