net.Receive( "ShowCharMenu", function()
	local max_models = #SETTINGS.CharModels
	local elements = {}
	local curmodel = 1
	local points, maxpoints = SETTINGS.StartGenePoints, SETTINGS.StartGenePoints

	local DFrame1 = vgui.Create( "DFrame" )
	DFrame1:SetSize( ScrW(), ScrH() )
	DFrame1:SetTitle( " " )
	DFrame1:MakePopup()
    DFrame1:ShowCloseButton( false )
	DFrame1.Paint = function()
		draw.RoundedBox( 0, 0, 0, DFrame1:GetWide(), DFrame1:GetTall(), HUD_SKIN.LIST_BG_FIRST)
        draw.RoundedBox( 0, 0, 0, DFrame1:GetWide(), 130, HUD_SKIN.THEME_COLOR)
        draw.RoundedBox( 0, 0, 130, DFrame1:GetWide(), 2, Color( 230, 230, 230, 255 ))
		draw.SimpleTextOutlined( "Vorname:","RPNormal_45", DFrame1:GetWide()/2.55, DFrame1:GetTall()/3.8, Color( 255, 255, 255, 255 ), 0, 0, 0.5, Color( 0, 0, 0, 50 ))
		draw.SimpleTextOutlined( "Nachname:","RPNormal_45", DFrame1:GetWide()/2.55, DFrame1:GetTall()/2.34, Color( 255, 255, 255, 255 ), 0, 0, 0.5, Color( 0, 0, 0, 50 ))
		draw.SimpleTextOutlined( "Erstelle ein Spieleraccount","RPNormal_35", 35, 80, Color( 255, 102, 0, 255 ), 0, 0, 0.5, Color( 0, 0, 0, 50 ))
		draw.SimpleTextOutlined( "Willkommen auf unseren EPG RP!","RPNormal_45", 35, 25, Color( 255, 255, 255, 255 ), 0, 0, 0.5, Color( 0, 0, 0, 50 ))
		draw.SimpleTextOutlined( "Passwort:","RPNormal_45", DFrame1:GetWide()/1.52, DFrame1:GetTall()/2.34, Color( 255, 255, 255, 255 ), 0, 0, 0.5, Color( 0, 0, 0, 50 ))
	end
	 
	local icon = vgui.Create( "DModelPanel", DFrame1 )
	icon:SetModel( SETTINGS.CharModels[1] )
	 
	icon:SetSize( DFrame1:GetWide()/3, DFrame1:GetTall() )
	icon:SetCamPos( Vector( 40, 40, 30 ) )
	icon:SetLookAt( Vector( 0, 0, 25 ) )
	icon:SetPos( 10, 35 )

	local back = vgui.Create("DButton", DFrame1)
	back:SetSize( 80, 35 )
	back:SetText( "" )
	back:SetPos( 40, DFrame1:GetTall() - 100 )
	back.DoClick = function()
		curmodel = curmodel - 1
		if curmodel < 1 then curmodel = #SETTINGS.CharModels end
		icon:SetModel( SETTINGS.CharModels[curmodel] )
	end
    back.Paint = function()
        draw.RoundedBox( 2, 0, 0, back:GetWide(), back:GetTall(), HUD_SKIN.THEME_COLOR )
        local text = "Back"
        local font = "RPNormal_35"
        surface.SetFont( font )
        local w,h = surface.GetTextSize( text )
        draw.SimpleText( text, font, (back:GetWide() - w) / 2, (back:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
    end

	local forward = vgui.Create("DButton", DFrame1)
	forward:SetSize( 80, 35 )
	forward:SetText( "->" )
	forward:SetPos( 350, DFrame1:GetTall() - 100 )
	forward.DoClick = function()
		curmodel = curmodel + 1
		if curmodel > #SETTINGS.CharModels then curmodel = 1 end
		icon:SetModel( SETTINGS.CharModels[curmodel] )
	end
    forward.Paint = function()
        draw.RoundedBox( 2, 0, 0, forward:GetWide(), forward:GetTall(), HUD_SKIN.THEME_COLOR )
        local text = "Next"
        local font = "RPNormal_35"
        surface.SetFont( font )
        local w,h = surface.GetTextSize( text )
        draw.SimpleText( text, font, (forward:GetWide() - w) / 2, (forward:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
    end

	local RPName = vgui.Create("DTextEntry", DFrame1)
	RPName:SetText("John")
	RPName:SetWide( 100 )
	RPName:SetTall( 30 )
	RPName:SetPos( DFrame1:GetWide()/2.5, DFrame1:GetTall()/3 )
	RPName.err = false
	RPName.Paint = function(self)
		if !(RPName.err) then
			surface.SetDrawColor(150, 150, 150)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		else
			surface.SetDrawColor(math.Clamp(math.sin(CurTime()*10)*150, 100, 255), 0, 0)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
	end

	local RPName2 = vgui.Create("DTextEntry", DFrame1)
	RPName2:SetText("Doe")
	RPName2:SetWide( 100 )
	RPName2:SetTall( 30 )
	RPName2:SetPos( DFrame1:GetWide()/2.5, DFrame1:GetTall()/2 )
	RPName2.err = false
	RPName2.Paint = function(self)
		if !(RPName2.err) then
			surface.SetDrawColor(150, 150, 150)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		else
			surface.SetDrawColor(math.Clamp(math.sin(CurTime()*10)*150, 100, 255), 0, 0)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
	end

	local RPName3 = vgui.Create("DTextEntry", DFrame1)
	RPName3:SetText("Mein Passwort")
	RPName3:SetWide( 250 )
	RPName3:SetTall( 30 )
	RPName3:SetPos( DFrame1:GetWide()/1.5, DFrame1:GetTall()/2 )
	RPName3.err = false
	RPName3.Paint = function(self)
		if !(RPName3.err) then
			surface.SetDrawColor(150, 150, 150)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		else
			surface.SetDrawColor(math.Clamp(math.sin(CurTime()*10)*150, 100, 255), 0, 0)
			surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
		end
	end
    
    DFrame1.craft_table = {}
	
	function CreateSpezializeElement( name, desc, min, max, func, func2, value )
		local k = #elements or 0
        
        DFrame1.craft_table[ value ] = 0
		
		local b1 = vgui.Create("DImageButton", DFrame1)
		b1:SetMaterial( "icon16/add.png" )
		b1:SetSize( 16, 16 )
        b1:SetPos( DFrame1:GetWide()/1.2,  DFrame1:GetTall()/1.7 + (50*k))
		b1.DoClick = function()
			func()
		end
		
		local b2 = vgui.Create("DImageButton", DFrame1)
		b2:SetMaterial( "icon16/delete.png" )
		b2:SetSize( 16, 16 )
		b2:SetPos( DFrame1:GetWide()/2.5, DFrame1:GetTall()/1.7 + (50*k) )
		b2.DoClick = function()
			func2()
		end
		
		local b3 = vgui.Create("DButton", DFrame1)
		b3:SetSize( DFrame1:GetWide()/2.43, 25 )
		b3:SetText( " " )
		b3:SetPos( DFrame1:GetWide()/2.4, DFrame1:GetTall()/1.715 + (50*k) )
        b3.percent = b3:GetWide() / max
		b3.Paint = function()
            draw.RoundedBox( 2, 0, 0, b3:GetWide(), b3:GetTall(), Color( 150, 150, 150, 255 ))
			draw.RoundedBox( 2, 0, 0, b3.percent * DFrame1.craft_table[ value ], b3:GetTall(), HUD_SKIN.THEME_COLOR)
            draw.SimpleText( name, "RPNormal_27", 2, -1, Color( 255, 255, 255, 255 ) )
            
            local font = "RPNormal_27"
            local text = (DFrame1.craft_table[ value ] .. " / " .. points)
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
            
            draw.SimpleText( DFrame1.craft_table[ value ] .. " / " .. points, "RPNormal_27", (b3:GetWide() - 10) - w, -1, Color( 255, 255, 255, 255 ) )
		end
		
		table.insert( elements, k )
	end
    
    for k, v in pairs( SETTINGS.GeneTypes ) do
        if !(v.show_in_registration) then continue end              // Skip the Gene -/ Skill
        
        CreateSpezializeElement( (v.name or "Error - Invalid Name"), (v.desc or ""), 0, SETTINGS.StartGenePoints, function() 
            points = points - 1
            if points < 0 then points = points + 1 return end
            DFrame1.craft_table[v.name] = DFrame1.craft_table[v.name] + 1
            if DFrame1.craft_table[v.name] > SETTINGS.StartGenePoints then DFrame1.craft_table[v.name] = SETTINGS.StartGenePoints end
        end,  function()
            if DFrame1.craft_table[v.name] > 0 then points = points + 1 end
            if points > maxpoints then points = maxpoints return end
            DFrame1.craft_table[v.name] = DFrame1.craft_table[v.name] - 1 
            if DFrame1.craft_table[v.name] < 0 then DFrame1.craft_table[v.name] = 0 end
        end, v.name)
    end

    /*
	CreateSpezializeElement( "Stärke", "LOL", 0, 10, function() 
        points = points - 1
        if points < 0 then points = points + 1 return end
		DFrame1.craft_table["stärke"] = DFrame1.craft_table["stärke"] + 1
		if DFrame1.craft_table["stärke"] > 10 then DFrame1.craft_table["stärke"] = 10 end
	end,  function()
        points = points + 1
        if points > maxpoints then points = maxpoints return end
		DFrame1.craft_table["stärke"] = DFrame1.craft_table["stärke"] - 1 
		if DFrame1.craft_table["stärke"] < 0 then DFrame1.craft_table["stärke"] = 0 end
	end, "stärke")
    
    CreateSpezializeElement( "Intelligenz", "LOL", 0, 10, function() 
        points = points - 1
        if points < 0 then points = points + 1 return end
		DFrame1.craft_table["intelligenz"] = DFrame1.craft_table["intelligenz"] + 1
		if DFrame1.craft_table["intelligenz"] > 10 then DFrame1.craft_table["intelligenz"] = 10 end
	end,  function()
        points = points + 1
        if points > maxpoints then points = maxpoints return end
		DFrame1.craft_table["intelligenz"] = DFrame1.craft_table["intelligenz"] - 1 
		if DFrame1.craft_table["intelligenz"] < 0 then DFrame1.craft_table["intelligenz"] = 0 end
	end, "intelligenz")
    
    CreateSpezializeElement( "Einfluss Fähigkeit", "LOL", 0, 10, function() 
        points = points - 1
        if points < 0 then points = points + 1 return end
		DFrame1.craft_table["einfluss"] = DFrame1.craft_table["einfluss"] + 1
		if DFrame1.craft_table["einfluss"] > 10 then DFrame1.craft_table["einfluss"] = 10 end
	end,  function()
        points = points + 1
        if points > maxpoints then points = maxpoints return end
		DFrame1.craft_table["einfluss"] = DFrame1.craft_table["einfluss"] - 1 
		if DFrame1.craft_table["einfluss"] < 0 then DFrame1.craft_table["einfluss"] = 0 end
	end, "einfluss")
    
    CreateSpezializeElement( "Vertrauenswürdigkeit", "LOL", 0, 10, function() 
        points = points - 1
        if points < 0 then points = points + 1 return end
		DFrame1.craft_table["vertrauen"] = DFrame1.craft_table["vertrauen"] + 1
		if DFrame1.craft_table["vertrauen"] > 10 then DFrame1.craft_table["vertrauen"] = 10 end
	end,  function()
        points = points + 1
        if points > maxpoints then points = maxpoints return end
		DFrame1.craft_table["vertrauen"] = DFrame1.craft_table["vertrauen"] - 1 
		if DFrame1.craft_table["vertrauen"] < 0 then DFrame1.craft_table["vertrauen"] = 0 end
	end, "vertrauen")
    
    CreateSpezializeElement( "Handwerks Geschick", "LOL", 0, 30, function() 
        points = points - 1
        if points < 0 then points = points + 1 return end
		DFrame1.craft_table["geschick"] = DFrame1.craft_table["geschick"] + 1
		if DFrame1.craft_table["geschick"] > 10 then DFrame1.craft_table["geschick"] = 10 end
	end,  function()
        points = points + 1
        if points > maxpoints then points = maxpoints return end
		DFrame1.craft_table["geschick"] = DFrame1.craft_table["geschick"] - 1 
		if DFrame1.craft_table["geschick"] < 0 then DFrame1.craft_table["geschick"] = 0 end
	end, "geschick")
    */
	local enter = vgui.Create("DButton", DFrame1)
	enter:SetSize( DFrame1:GetWide()/2, 50 )
	enter.canuse = true
	enter:SetText( "" )
	enter:SetPos( DFrame1:GetWide()/2.5, DFrame1:GetTall() - 115 )
    enter.Paint = function()
        draw.RoundedBox( 2, 0, 0, enter:GetWide(), enter:GetTall(), HUD_SKIN.THEME_COLOR )
        local text = "Account Erstellen"
        local font = "RPNormal_35"
        surface.SetFont( font )
        local w,h = surface.GetTextSize( text )
        draw.SimpleText( text, font, (enter:GetWide() - w) / 2, (enter:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
    end
	enter.DoClick = function()
		local err = false
		if !(enter.canuse) then return end
		
		if string.len(RPName:GetValue()) <= 3 then
			RPName.err = true
			err = true
			timer.Simple( 2, function() RPName.err = false end)
		end
		
		if RPName2:GetValue() == "Doe" then
			RPName2.err = true
			err = true
			timer.Simple( 2, function() RPName2.err = false end)
		elseif string.len(RPName2:GetValue()) <= 3 then
			RPName2.err = true
			err = true
			timer.Simple( 2, function() RPName2.err = false end)
		end
		
		if RPName3:GetValue() == "Mein Passwort" then
			RPName3.err = true
			err = true
			timer.Simple( 2, function() RPName3.err = false end)
		elseif string.len(RPName3:GetValue()) <= 4 then
			RPName3.err = true
			err = true
			timer.Simple( 2, function() RPName3.err = false end)
		end
        
        if points > 0 then err = true end
		
		if err then return end
		
		net.Start( "SendCharInfo_Creation" )
			net.WriteTable( {fname = RPName:GetValue(), sname = RPName2:GetValue(), pass = RPName3:GetValue(), playermodel = SETTINGS.CharModels[curmodel], craft_skills=DFrame1.craft_table} )
		net.SendToServer()
		
		enter.canuse = false
		enter:SetText( "Lade Daten..." )
	end
	
	net.Receive( "HideCharMenu", function() if IsValid( DFrame1 ) then tutorial.PlayMove() DFrame1:Close() end end )
	
end)