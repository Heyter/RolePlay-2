local inspecting = inspecting or {}

local function GetDrugs()
	local inv = itemstore.containers.Get( LocalPlayer().InventoryID )
	
	local drugs = {}
	for k, v in pairs( inv:GetItems() ) do
		local match = string.match( v:GetClass(), "drug_" )
		if match != nil && string.len( match ) > 2 && v:GetClass() != "drug_pot" then
			print( v:GetClass() )
			table.insert( drugs, v )
		end
	end
	return drugs
end

local function Add_Inspecting( info )
	local uid = info.uid
	local succeed = info.succeed
	
	table.insert( inspecting, {
		uid = uid,
		start = CurTime(),
		finish = CurTime() + DRUGDEALER.CONFIG.QualityCheckTime,
		succeed = succeed
	})
	timer.Simple( DRUGDEALER.CONFIG.QualityCheckTime, function() table.remove( inspecting, #inspecting ) end)		// Removes itself
	
	for k, v in pairs( List:GetItems() ) do
		if v.uid == uid then
			v.inspecting = true
			v.inspect_table = inspecting[#inspecting]
		end
	end
end
net.Receive( "DrugDealer_Inspect_Drug", function() local info = net.ReadTable() Add_Inspecting( info ) end)

local function Remove_SoldWeed( uid )
	for k, v in pairs( List2:GetItems() ) do
		if !(v.uid == uid) then continue end
		v:Remove()
		break
	end
end
net.Receive( "Purchase_Succeed", function() local id = net.ReadInt( 32 ) Remove_SoldWeed( id ) end )





local function AddSaleItems()
    if !(DRUGDEALER.Purchasing) then return end
    
	local inv = itemstore.containers.Get( LocalPlayer().InventoryID )
	
	local c = 0
	for k, v in pairs( GetDrugs() ) do
		local color = Color( 230, 230, 230, 255 )
        
        c = c + 1
        if c == 2 then c = 0 color = Color( 220, 220, 220, 255 ) end
        
        local p = vgui.Create( "DPanel" )
        p:SetWide( List:GetWide() )
        p:SetTall( List:GetTall()/4 )
		p.item = v
        p.color = color
		p.uid = math.Round( math.Rand(1,10000))
        p.Paint = function() 
            draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), p.color )
            DrawCircle( (p:GetTall()/2), (p:GetTall()/2), (p:GetTall()/2 - 10), 1, Color( 190, 190, 190, 255 ) )
            
            local w = draw.SimpleText( DRUGDEALER.TranslateClassToName( p.item.Class ), "RPNormal_35", p:GetTall() + 10, 15, Color( 50, 50, 50, 200 ) )
			draw.SimpleText( "Gramm: " .. tostring( p.item:GetData("Gramm") ), "RPNormal_22", p:GetTall() + 10 + w + 5, 26, Color( 50, 50, 50, 200 ) )
			
			draw.RoundedBox( 0, (p:GetTall()) + 10, p:GetTall() - 40, 300, 30, Color( 0, 0, 0, 150 ))
			local qual = (v:GetData( "Quality" ) or 0)
			local rech = 296 / 100
			rech = rech * qual
			draw.RoundedBox( 0, (p:GetTall()) + 12, p:GetTall() - 38, rech, 26, Color( 0, 200, 0, 150 ))
			
			local l, h = (p:GetTall() + 12) * 2, (p:GetTall() - 38) * 1.2
			draw.SimpleText( "Qualität - " .. tostring( qual ) .. "%", "RPNormal_25", l, h, Color( 255, 255, 255, 255 ), 0, 1)
        end
        
        local icon = vgui.Create( "DModelPanel", p )
        icon:SetModel( v.Model )
        icon:SetSize( (p:GetTall()/2), (p:GetTall()/2) )
        icon:SetPos( p:GetTall()/4, p:GetTall()/4 )
        local max, min = icon:GetEntity():GetRenderBounds()
        icon:SetCamPos( Vector( 0.2, 0.2, 0.3 ) * min:Distance( max ) )
        icon:SetLookAt( ( min + max ) / 4 )
        icon.LayoutEntity = function( self ) 
            if ( self.bAnimated ) then
                    self:RunAnimation()
            end
        end
		
		local sell = vgui.Create( "DButton", p )
		sell:SetText( "" )
		sell:SetSize( 150, 30 )
		sell:SetPos( p:GetWide() - (sell:GetWide() + 20), p:GetTall() - (sell:GetTall() + 10) )
		sell.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255))
			draw.SimpleText( "Verkaufen", "RPNormal_25", 75, 15, Color( 255, 255, 255, 255 ), 1, 1)
		end
		sell.DoClick = function( self )
			net.Start( "DrugDealer_SellDrug" )
				net.WriteTable( {
					uid=p.uid, 
					slot=p.item.Slot,
					type = p.item.Class
				} )
			net.SendToServer()
		end
		
        
        List2:AddItem( p )
	end
end

local function AddPurchaseItems()
    if !(DRUGDEALER.IsSelling) then AddSaleItems() return end
    
    local c = 0
    for k, v in pairs( DRUGDEALER.Stocks ) do
        local color = Color( 230, 230, 230, 255 )
        
        c = c + 1
        if c == 2 then c = 0 color = Color( 220, 220, 220, 255 ) end
        
        local p = vgui.Create( "DPanel" )
		p.sold = false
		p.uid = v.uid
		p.succeed = false
		p.inspecting = false
		p.inspect_table = nil
		p.disp_time = CurTime()
        p:SetWide( List:GetWide() )
        p:SetTall( List:GetTall()/4 )
        p.color = color
        p.Paint = function( self ) 
            draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), p.color )
            DrawCircle( (p:GetTall()/2), (p:GetTall()/2), (p:GetTall()/2 - 10), 1, Color( 190, 190, 190, 255 ) )
            
            draw.SimpleText( DRUGDEALER.CONFIG.DrugTranslate[v.type][3] or "Unknown", "RPNormal_35", p:GetTall() + 10, 5, Color( 50, 50, 50, 200 ) )
			draw.SimpleText( v.price .. ",-€", "RPNormal_25", p:GetTall() + 10, 35, Color( 50, 50, 50, 200 ) )
			
			local l, h = (p:GetTall() + 12) * 2, (p:GetTall() - 38) * 1.2
			if self.succeed then
				self.disp_time = CurTime() - 1
				draw.RoundedBox( 0, (self:GetTall()) + 10, self:GetTall() - 40, 300, 30, Color( 0, 0, 0, 150 ))
				local rech = 296 / 100
				rech = rech * v.quality
				draw.RoundedBox( 0, (self:GetTall()) + 12, self:GetTall() - 38, rech, 26, Color( 0, 200, 0, 150 ))
				
				draw.SimpleText( "Qualität - " .. tostring( v.quality ) .. "%", "RPNormal_25", l, h, Color( 255, 255, 255, 255 ), 0, 1)
			elseif !(self.succeed) && self.inspecting then
				if self.uid != self.inspect_table.uid then return end
				
				draw.RoundedBox( 0, (self:GetTall()) + 10, self:GetTall() - 40, 300, 30, Color( 0, 0, 0, 150 ))
				local r1 = math.Clamp( self.inspect_table.finish - CurTime(), 0, DRUGDEALER.CONFIG.QualityCheckTime )
				local rech = 296 / (self.inspect_table.finish - self.inspect_table.start)
				rech = rech * r1
				
				if CurTime() >= self.inspect_table.finish then self.succeed = self.inspect_table.succeed end
				if self.inspect_table.succeed == false && CurTime() >= self.inspect_table.finish then self.inspecting = false self.inspect_table = nil self.disp_time = CurTime() + 2 end
				
				draw.RoundedBox( 0, (self:GetTall()) + 12, self:GetTall() - 38, 296 - rech, 26, Color( 0, 200, 0, 150 ))
				draw.SimpleText( "Inspiziere...", "RPNormal_25", l, h, Color( 255, 255, 255, 255 ), 0, 1)
				
			elseif self.inspect_table == nil then
				draw.RoundedBox( 0, (self:GetTall()) + 10, self:GetTall() - 40, 300, 30, Color( 0, 0, 0, 150 ))
				if CurTime() < self.disp_time then
					draw.SimpleText( "Fehlgeschlagen!", "RPNormal_25", l, h, Color( 200, 0, 0, 200 ), 0, 1)
				else
					draw.SimpleText( "Unbekannnte Qualität", "RPNormal_25", l, h, Color( 255, 255, 255, 255 ), 0, 1)
				end
			end
        end
        
        local icon = vgui.Create( "DModelPanel", p )
        icon:SetModel( v.model )
        icon:SetSize( (p:GetTall()/2), (p:GetTall()/2) )
        icon:SetPos( p:GetTall()/4, p:GetTall()/4 )
        local max, min = icon:GetEntity():GetRenderBounds()
        icon:SetCamPos( Vector( 0.2, 0.2, 0.3 ) * min:Distance( max ) )
        icon:SetLookAt( ( min + max ) / 4 )
        icon.LayoutEntity = function( self ) 
            if ( self.bAnimated ) then
                    self:RunAnimation()
            end
        end
		
		local purchase = vgui.Create( "DButton", p )
		purchase:SetText( "" )
		purchase:SetSize( 150, 30 )
		purchase:SetPos( p:GetWide() - (purchase:GetWide() + 20), p:GetTall() - (purchase:GetTall() + 10) )
		purchase.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255))
			if p.sold then
				draw.SimpleText( "Verkauft!", "RPNormal_25", 75, 15, Color( 200, 0, 0, 200 ), 1, 1)
			else
				draw.SimpleText( "Kaufen", "RPNormal_25", 75, 15, Color( 255, 255, 255, 255 ), 1, 1)
			end
		end
		purchase.DoClick = function( self )
			if p.sold then return end
			
			net.Start( "DrugDealer_PurchaseDrug" )
				net.WriteInt( p.uid, 32 )
				net.WriteString( v.type )
			net.SendToServer()
		end
		
		
		local inspect = vgui.Create( "DButton", p )
		inspect:SetText( "" )
		inspect:SetSize( 150, 30 )
		inspect.uid = v.uid
		inspect:SetPos( p:GetWide() - (inspect:GetWide() + 20), p:GetTall() - (inspect:GetTall() + 45) )
		inspect.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255))
			if p.sold then
				draw.SimpleText( "Verkauft!", "RPNormal_25", 75, 15, Color( 200, 0, 0, 200 ), 1, 1)
			else
				draw.SimpleText( "Inspizieren", "RPNormal_25", 75, 15, Color( 255, 255, 255, 255 ), 1, 1)
			end
		end
		inspect.DoClick = function( self )
			if p.sold then return end
			
			net.Start( "DrugDealer_Inspect_Drug" )
				net.WriteInt( self.uid, 32 )
			net.SendToServer()
		end
		inspect.Think = function( self )
			if p.succeed then inspect:Remove() return end
		end
		
        
        List:AddItem( p )
    end
	
	AddSaleItems()
end

local Frame = nil
function OpenDDealerPanel()
    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 850, 450 )
    frame:Center()
    frame:SetTitle( "" )
    frame:MakePopup()
    frame.Paint = function()
        draw.RoundedBox( 0, 0, 0, frame:GetWide(), frame:GetTall(), Color( 230, 230, 230, 255 ) )
        draw.RoundedBox( 0, 0, 0, frame:GetWide()/4, frame:GetTall(), HUD_SKIN.THEME_COLOR )

		if LocalPlayer():GetSkill( "Ruf" ) > DRUGDEALER.Dealers[DRUGDEALER.Dealer].ruf then
			local text = "Du brauchst weniger Ruf um mit diesen Dealer Handeln zu können! ( <" .. tostring( DRUGDEALER.Dealers[DRUGDEALER.Dealer].ruf ) .. "% )"
			local left = (frame:GetWide() - frame:GetWide()/4 - 1)/2
			draw.SimpleText( text, "RPNormal_25", left + (frame:GetWide()/4 + 1), frame:GetTall()/2, Color( 50, 50, 50, 150 ), 1, 1 ) 
		else
			draw.RoundedBox( 0, 25, 25, frame:GetWide()/4 - 50, frame:GetTall()/2, Color( 0, 0, 0, 100 ) )
			draw.SimpleText( "- Merkmale -", "RPNormal_25", frame:GetWide()/8, frame:GetTall()/1.6, Color( 50, 50, 50, 255 ), 1, 1 )
		end
    end
	Frame = frame
	
	--if LocalPlayer():GetSkill( "Ruf" ) > DRUGDEALER.Dealers[DRUGDEALER.Dealer].ruf then return end

    // Buttons

    local purchase = vgui.Create( "DButton", frame )
    purchase:SetPos( frame:GetWide()/4 + 1, 0 )
    purchase:SetTall( 50 )
    purchase:SetWide( 150 )
    purchase:SetText( "" )
    purchase.Paint = function( self )
        draw.RoundedBox( 0, 0, 0, purchase:GetWide(), purchase:GetTall(), Color( 240, 240, 240, 255 ) )
        draw.RoundedBox( 0, purchase:GetWide() - 1, 0, 1, purchase:GetTall(), Color( 0, 0, 0, 25 ) )
        draw.RoundedBox( 0, purchase:GetWide() - .5, 0, .5, purchase:GetTall(), Color( 0, 0, 0, 50 ) )
        
        draw.SimpleText( "Shop", "RPNormal_20", self:GetWide()/2, self:GetTall()/2, Color( 0, 0, 0, 150 ) , 1, 1 )
        
        if !(DRUGDEALER.Purchasing) then
            local id = "roleplay/pictures/lock_20.png"
            surface.SetMaterial( Material( id ) )
            surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
            surface.DrawTexturedRect( purchase:GetWide() - 35, (purchase:GetTall() - 16) /2, 16, 16 )
        end
    end
    purchase.DoClick = function()
        if !(DRUGDEALER.Purchasing) then return end
        List:Show()
        List2:Hide()
    end

    local sell = vgui.Create( "DButton", frame )
    sell:SetPos( frame:GetWide()/4 + 151, 0 )
    sell:SetTall( 50 )
    sell:SetWide( 150 )
    sell:SetText( "" )
    sell.Paint = function( self )
        draw.RoundedBox( 0, 0, 0, sell:GetWide(), sell:GetTall(), Color( 240, 240, 240, 255 ) )
        draw.RoundedBox( 0, sell:GetWide() - 1, 0, 1, sell:GetTall(), Color( 0, 0, 0, 25 ) )
        draw.RoundedBox( 0, sell:GetWide() - .5, 0, .5, sell:GetTall(), Color( 0, 0, 0, 50 ) )
        
        draw.SimpleText( "Inventar", "RPNormal_20", self:GetWide()/2, self:GetTall()/2, Color( 0, 0, 0, 150 ) , 1, 1 )

        if !(DRUGDEALER.IsSelling) then
            local id = "roleplay/pictures/lock_20.png"
            surface.SetMaterial( Material( id ) )
            surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
            surface.DrawTexturedRect( sell:GetWide() - 35, (sell:GetTall() - 16) /2, 16, 16 )
        end
    end
    sell.DoClick = function()
        if !(DRUGDEALER.IsSelling) then return end
        
        List2:Show()
        List:Hide()
    end


    local desc = vgui.Create( "DLabel", frame )
    desc:SetText( DRUGDEALER.Dealers[DRUGDEALER.Dealer].description )
    desc:SetFont( "RPNormal_20" )
    desc:SetColor( Color( 50, 50, 50, 255 ) )
    desc:SizeToContents()
    desc.Think = function()
        local d = DRUGDEALER.Dealers[DRUGDEALER.Dealer].description
        surface.SetFont( "RPNormal_20" )
        local w, h = surface.GetTextSize( d )
        
        desc:SetPos( frame:GetWide()/8 - w/2, frame:GetTall()/1.5 )
    end

    local icon = vgui.Create( "DModelPanel", frame )
    icon:SetModel( DRUGDEALER.Dealers[DRUGDEALER.Dealer].model )
    icon:SetSize( frame:GetWide()/4 - 50, frame:GetTall()/2 )
    icon:SetPos( 25, 25 )
    icon:SetCamPos( Vector( 20, 0, 60 ) )
    icon:SetLookAt( Vector( 0, 0, 60 ) )
    icon.LayoutEntity = function( self ) 
        if ( self.bAnimated ) then
                self:RunAnimation()
        end
    end

    // Listing

    List = vgui.Create( "DPanelList", frame )
    List:SetPos( frame:GetWide()/4 + 1, 50 )
    List:SetSize( frame:GetWide() - frame:GetWide()/4 - 1, frame:GetTall() - 51 )
    List:SetSpacing( 0 ) -- Spacing between items
    List:EnableHorizontal( false ) -- Only vertical items
    List:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
    List.Paint = function()
        draw.RoundedBox( 0, 0, 0, List:GetWide(), List:GetTall(), Color( 0, 0, 0, 10 ) )
        
        if !(DRUGDEALER.IsSelling) then
            draw.SimpleText( "Keine Waren verfügbar!!", "RPNormal_35", List:GetWide()/2, List:GetTall()/2, Color( 50, 50, 50, 200 ), 1, 1 )
        end
    end
    
    List2 = vgui.Create( "DPanelList", frame )
    List2:SetPos( frame:GetWide()/4 + 1, 50 )
    List2:SetSize( frame:GetWide() - frame:GetWide()/4 - 1, frame:GetTall() - 51 )
    List2:SetSpacing( 0 ) -- Spacing between items
    List2:EnableHorizontal( false ) -- Only vertical items
    List2:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
    List2.Paint = List.Paint
    
    List2:Show()
    List2:Hide()
    
    AddPurchaseItems()
end

function DRUGDEALER_Refresh_List( cache )
	if Frame != nil && IsValid( Frame ) then
		
	end
end

net.Receive( "DrugDealer_Shop_Update_Items", function()
	local uid = net.ReadInt( 32 )
	
	for k, v in pairs( List:GetItems() ) do
		if v.uid == uid then v.sold = true break end
	end
end)
