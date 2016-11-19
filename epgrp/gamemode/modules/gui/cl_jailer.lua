local arrest_panel = {}
local index = 1
local selected_player = nil

local function GoLeft( frame )
	if index == 1 then return end
	index = index - 1
	
	panel = frame.panel[1]
	
	local left, up = panel:GetPos()
	panel:MoveTo( left + (panel:GetWide()*(index)), up, 1, 0, -1, function() print( "done" ) end) 
end

local function GoRight( frame )
	if (index + 1) > #frame.panel then return end
	index = index + 1
	
	panel = frame.panel[1]
	
	local left, up = panel:GetPos()
	panel:MoveTo( left - (panel:GetWide()*(index-1)), up, 1, 0, -1, function() print( "done" ) end ) 
end

arrest_panel[1] = {
	title = "Wähle ein Spieler zum inhaftieren.",
	func = function( parent )
		local pos = LocalPlayer():GetPos()
		local max = SETTINGS.ArrestRange
		
		local l = vgui.Create( "DPanelList", parent )
		l:SetPos( 0, 0 )
		l:SetSize( parent:GetWide(), parent:GetTall() )
        l:SetAutoSize( false )
        l:SetSpacing( 0 )
        l:EnableHorizontal( false )
        l:EnableVerticalScrollbar( true )
		l.Paint = function( self )
			if table.Count( l:GetItems() ) < 1 then
				draw.SimpleText( "Keine Spieler in der Nähe!", "RPNormal_35", self:GetWide()/2, self:GetTall()/2, Color( 0, 0, 0, 100 ), 1, 1 )
			end
		end
        
		local i = 0
		for k, v in pairs( ents.FindInSphere( parent.npc:GetPos(), SETTINGS.ArrestRange ) ) do
			if !(IsValid( v )) then continue end
			if !(v:IsPlayer()) then continue end
			if !(v:GetNWBool( "rhc_cuffed" )) then continue end		// we dont want to show uncuffed persons here
			print( v )
			if v:IsPolice() or v:IsSWAT() then continue end		// We dont want to show goverments here, why should they be cuffed anyways?!?
			
			local col = HUD_SKIN.LIST_BG_FIRST
			
			i = i + 1
			if i > 1 then
				i = 0
				col = HUD_SKIN.LIST_BG_SECOND
			end
		
			local p = vgui.Create( "DPanel", l )
			p:SetPos( 0, 0 )
			p:SetSize( l:GetWide(), l:GetTall() / 4 )
			p.Paint = function( self )
				draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), col )
				draw.SimpleText( v:GetRPVar( "rpname") or "Unknown", "RPNormal_40", p:GetTall() + 15, p:GetTall()/2 , HUD_SKIN.FULL_GREY, 0, 1 )
			end
			
			local icon = vgui.Create( "DModelPanel", l )
			icon:SetPos( 0, 0 )
			icon:SetSize( p:GetTall(), p:GetTall() )
			icon:SetModel( v:GetModel() ) -- you can only change colors on playermodels
			function icon:LayoutEntity( Entity ) return end -- disables default rotation
			function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end
			
			local btn = vgui.Create( "DButton", l )
			btn:SetPos( 0, 0 )
			btn:SetSize( p:GetWide(), p:GetTall() )
			btn:SetText( "" )
			btn.Paint = function ( self ) end
			btn.DoClick = function( self )
				selected_player = v
				GoRight( parent.frame )	// Next step
			end
			
			l:AddItem( p )
		end
	end
}
arrest_panel[2] = {
	title = "Gebe eine Zeit ( Max:" .. SETTINGS.MaxArrestTime .. " ) und ein Grund ein.",
	func = function( parent )
		local p = vgui.Create( "DPanel", parent )
		p:SetPos( 0, 0 )
		p:SetSize( parent:GetWide(), parent:GetTall() )
		p.Paint = function( self ) 
			draw.SimpleText( "!!! ACHTUNG !!!", "RPNormal_30", parent:GetWide()/2, 30, Color( 0, 0, 0, 200 ), 1, 1 )
			draw.SimpleText( "Der Grund wird beim Mayor im LOG angezeigt.", "RPNormal_21", parent:GetWide()/2, 50, Color( 0, 0, 0, 200 ), 1, 1 )
			draw.SimpleText( "Falsche Gründe, bzw Random Gründe haben ein,", "RPNormal_21", parent:GetWide()/2, 70, Color( 0, 0, 0, 200 ), 1, 1 )
			draw.SimpleText( "Kick -/ Blacklist", "RPNormal_21", parent:GetWide()/2, 90, Color( 200, 0, 0, 200 ), 1, 1 )
			draw.SimpleText( "vom Job zu folge", "RPNormal_21", parent:GetWide()/2, 110, Color( 0, 0, 0, 200 ), 1, 1 )
			
			draw.SimpleText( "Zeit:", "RPNormal_36", 100, (parent:GetTall()/2) - 70, Color( 0, 0, 0, 150 ), 0, 1 )
			draw.SimpleText( "Grund:", "RPNormal_36", parent:GetWide()/2, (parent:GetTall()/2) + 5, Color( 0, 0, 0, 150 ), 1, 1 )
		end
		
		local time = vgui.Create( "DTextEntry", p )
		time:SetFont( "RPNormal_25" )
		time:SetSize( parent:GetWide() - 200, 30 )
		time:SetPos( (parent:GetWide() - time:GetWide())/2, (parent:GetTall()/2) - 50 )
		time:SetSize( 150, 30 )
		time:SetText( "" )
		time.OnEnter = function( self ) 
		
		end
		time:SetNumeric( true )
		
		local reason = vgui.Create( "DTextEntry", p )
		reason:SetFont( "RPNormal_25" )
		reason:SetSize( parent:GetWide() - 200, 30 )
		reason:SetPos( (parent:GetWide() - reason:GetWide())/2, parent:GetTall()/2 + 25 )
		reason:SetText( "" )
		reason.OnEnter = function( self ) 
		
		end
		
		local ok = vgui.Create( "DButton", parent )
		ok:SetSize( p:GetWide(), 50 )
		ok:SetPos( 0, p:GetTall() - ok:GetTall() )
		ok:SetText( "" )
		ok.Paint = function( self ) 
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )
			draw.SimpleText( "Inhaftieren", "RPNormal_30", self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ), 1, 1 )
		end
		ok.DoClick = function( self )
			if string.len( time:GetValue() ) < 1 then return end
			if tonumber(time:GetValue()) > SETTINGS.MaxArrestTime then return end
			if string.len( reason:GetValue() ) < 3 then return end
			
			net.Start( "Request_Arrest" )
				net.WriteEntity( selected_player )
				net.WriteInt( math.Clamp( tonumber( time:GetValue() ), 0, SETTINGS.MaxArrestTime ), 32 )
				net.WriteString( tostring( reason:GetValue() ) )
			net.SendToServer()
			
			parent.frame:Remove()
		end
		
	end
}

net.Receive( "Open_ArrestPanel", function() 
	local npc = net.ReadEntity()
	if !(IsValid(npc)) then return end
	OpenJailerMenu( npc )
end)

function OpenJailerMenu( npc )
	index = 1
	selected_player = nil
	
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "" )
	frame:SetSize( 500, 500 )
	frame:Center()
	frame:MakePopup()
	frame.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_BGCOLOR )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), 50, HUD_SKIN.THEME_COLOR )
		
		draw.SimpleText( arrest_panel[index].title, "RPNormal_26", frame:GetWide()/2, 25, Color( 255, 255, 255, 200 ), 1, 0 )
	end
	frame.panel = {}
	
	local close_btn = vgui.Create( "DButton", frame )
    close_btn:SetSize( 100, 25 )
    close_btn:SetPos( frame:GetWide() - 100, 0 )
    close_btn:SetText( "" )
    close_btn.DoClick = function() 
        frame:Remove()
    end
    close_btn.Paint = function()
        draw.RoundedBox( 0, 0, 0, close_btn:GetWide(), close_btn:GetTall(), HUD_SKIN.FULL_GREY )
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( "Close" )
        draw.SimpleText( "Close", "RPNormal_25", (close_btn:GetWide() - w)/2, (close_btn:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
    end
	
	for k, v in pairs( arrest_panel ) do
		local p = vgui.Create( "DPanel", frame )
		p:SetSize( frame:GetWide(), frame:GetTall() - 50 )
		p:SetPos( p:GetWide() * (k-1), 50)
		p.Paint = function( self ) end
		p.index = k
		p.Think = function( self )
			if p.index == 1 then return end
			
			local left, up = frame.panel[1]:GetPos()
			local w, h = frame.panel[1]:GetSize()
			self:SetPos( left + (w * (self.index-1)), up )
		end
		p.frame = frame
		frame.panel[k] = p
		p.npc = npc
		
		arrest_panel[k].func( p )
	end
	
	local lb = vgui.Create( "DButton", frame )
	lb:SetText( "" )
	lb:SetSize( 25, 25 )
	lb:SetPos( 5, (frame:GetTall() - lb:GetTall())/2 )
	lb.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.FULL_GREY )
		draw.SimpleText( "<", "RPNormal_25", lb:GetWide()/2, lb:GetTall()/2, Color( 255, 255, 255, 200 ), 1, 1 )
	end
	lb.DoClick = function( self )
		GoLeft( frame )
	end
	
	local rb = vgui.Create( "DButton", frame )
	rb:SetText( "" )
	rb:SetSize( 25, 25 )
	rb:SetPos( frame:GetWide() - (rb:GetWide() + 5), (frame:GetTall() - rb:GetTall())/2 )
	rb.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.FULL_GREY )
		draw.SimpleText( ">", "RPNormal_25", rb:GetWide()/2, rb:GetTall()/2, Color( 255, 255, 255, 200 ), 1, 1 )
	end
	rb.DoClick = function( self )
		if selected_player == nil then return end
		GoRight( frame )
	end
end