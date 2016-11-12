print(" --- CL Craftings Loaded! --- " )
RP.CRAFTING = RP.CRAFTING or {}
RP.CRAFTING.Tabs = {}
RP.CRAFTING.Buttons = {}

RP.CRAFTING.PageListings = 3
RP.CRAFTING.ButtonFont = "RPNormal_25"
RP.CRAFTING.ButtonH = 50
RP.CRAFTING.ButtonSpace = 15
RP.CRAFTING.SheetSize = 50
RP.CRAFTING.SheetSpace = 5

RP.CRAFTING.Tabs[1] = {name="Items", icon="gui/silkicons/user", desc="Let's craft some Items :D"}
RP.CRAFTING.Tabs[2] = {name="Weapon", icon="gui/silkicons/user", desc="Let's craft some Items :D"}
RP.CRAFTING.Tabs[3] = {name="Food", icon="gui/silkicons/user", desc="Let's craft some Items :D"}
RP.CRAFTING.Tabs[4] = {name="Props", icon="gui/silkicons/user", desc="Let's craft some Items :D"}
RP.CRAFTING.Tabs[5] = {name="Misc", icon="gui/silkicons/user", desc="Let's craft some Items :D"}

function HasItem( item, count )
	if !(IsValid( LocalPlayer() )) then return false end
	if !(item) then return false end
	if !(itemstore.containers.Get( LocalPlayer().InventoryID ):CountItems( item ) >= ( count or 0 )) then return false end
	
	return true
end
	
local function GetTextSize( text, font )
	surface.SetFont( font or "Default")
	return surface.GetTextSize( text )
end

local function GetItemName( item )
	for k, v in pairs( CRAFT_LANG ) do
		if k == item then return v end
	end
	return item
end

f2_menu.AddButton( "Strukturen", "roleplay/f2_menu/icons/structures.png", function( pnl ) 
	RP.CRAFTING.CreateButtonClasses( pnl )
    RP.CRAFTING.BuildCraftingTabs()
end)

// Painting
function RP.CRAFTING.PaintList( panel )    
    local i = 0
    for c = 0, panel.count do
        panel.col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then panel.col = HUD_SKIN.LIST_BG_SECOND i = 0 end
    end
    
    draw.RoundedBox( 0, 0, 0, panel:GetWide(), panel:GetTall(), panel.col )
end
// Paint End

function RP.CRAFTING.FindPanelParent( category )
    for k, v in pairs( RP.CRAFTING.Tabs ) do
        if v.name == category then return v.panel end
    end
    return nil
end

function RP.CRAFTING.BuildCraftingTabs()
    for k, info in pairs( CRAFT_TABLE ) do
        RP.CRAFTING.CreateCraftingTabItem( info, k )
    end
end

function RP.CRAFTING.CreateCraftingTabItem( info, index )
    local parent = RP.CRAFTING.FindPanelParent( info.Category )
    if parent == nil then return end

    local p = vgui.Create( "DPanel", parent )
    p.parent = parent
    p.count = #(parent:GetItems() or 0)
    p.col = Color( 0, 0, 0, 255 )
    p:SetSize( parent:GetWide(), parent:GetTall()/RP.CRAFTING.PageListings )
    p.Paint = function() 
        RP.CRAFTING.PaintList( p )
        
        draw.SimpleText( info.Name, "RPNormal_40", p:GetTall(), 5, Color( 0, 0, 0, 220 ) )
        draw.SimpleText( info.Description, "RPNormal_20", p:GetTall(), 35, Color( 0, 0, 0, 220 ) )
        
        local i = 0
        for k, v in pairs( info.Skills ) do
            local skill = (LocalPlayer():GetSkill( k ) or 0)
            local col = Color( 0, 200, 0, 200 )
            if !(skill >= v) then col = Color( 200, 0, 0, 200 ) end
            i = i + 1
            
            draw.SimpleText( k .. " - " .. v, "RPNormal_20", p:GetWide() - 250, 10 + (18*(i-1)), col )
        end
    end
    
    local icon = vgui.Create( "DModelPanel", p )
    icon:SetModel( info.Model )
    icon:SetPos( 5, 5 )
	icon:SetSize( p:GetTall() - 10, p:GetTall() - 10 )
    local ent = icon:GetEntity()
    local max, min = icon:GetEntity():GetRenderBounds()
    icon:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
	icon:SetLookAt( ( min + max ) / 2 )
    
    local craft = vgui.Create( "DButton", icon )
    craft:SetSize( icon:GetWide(), icon:GetTall() )
    craft:SetPos( 0, 0 )
    craft:SetText( "" )
    craft.over = false
    craft.DoClick = function()
        net.Start( "CRAFTINGS_CANCRAFT" )
            net.WriteTable( {ply = LocalPlayer(), item = index} )
        net.SendToServer()
    end
    craft.OnCursorEntered = function()
        craft.over = true
    end
    craft.OnCursorExited = function()
        craft.over = false
    end
    craft.Paint = function( self )
        if craft.over then
            local col = Color( 255, 255, 255, 200 )
            local text = "Herstellen"
            if info.VIP && LocalPlayer():GetVIPLevel() <= 0 then
                col = Color( 200, 0, 0, 200 )
                text = "VIP Benötigt"
            end
            draw.RoundedBox( 0, 0, 0, self:GetWide(), 32, Color( 0, 0, 0, 150 ) )
            draw.SimpleText( text, "RPNormal_30", self:GetWide()/2, 1, col, 1, 0 )
        end
    end
    
    RP.CRAFTING.CreateCraftItemSheet( info, p )
    parent:AddItem( p )
end

// Custom Sheet
function RP.CRAFTING.CreateButtonClasses( panel )
    for index, v in pairs( RP.CRAFTING.Tabs ) do
        surface.SetFont( RP.CRAFTING.ButtonFont )
        local w, h = surface.GetTextSize( v.name )
        local left = 0
        
        local end_panel_h, end_panel_y = (panel:GetTall() - (RP.CRAFTING.ButtonH + 10)), (RP.CRAFTING.ButtonH + 10)
        
        for l=1, #RP.CRAFTING.Buttons do
			if RP.CRAFTING.Buttons[l] == nil then 
				LocalPlayer():PrintMessage( HUD_PRINTTALK, "Error loading craftings! Retry in 4 seconds! Rejoin if you keep getting this message!" ) 
				timer.Simple( 4, function()
					RP.CRAFTING.CreateButtonClasses( panel )
				end)
			return 
			end
            left = left + (RP.CRAFTING.Buttons[l]:GetWide() + (RP.CRAFTING.ButtonSpace*math.Clamp(l, 0, 1)))
        end
        
        local btn = vgui.Create( "DButton", panel )
        btn:SetSize( w + 30, RP.CRAFTING.ButtonH )
        btn:SetText( "" )
        btn:SetPos( left, 0 )
        btn.Paint = function( self )
            draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.FULL_GREY )
            draw.SimpleText( v.name, RP.CRAFTING.ButtonFont, self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 200 ), 1, 1 )
        end
        btn.DoClick = function()
            for k, tbl_panel in pairs( RP.CRAFTING.Buttons ) do
                tbl_panel.panel:Show()
                tbl_panel.panel:Hide()
            end
            RP.CRAFTING.Buttons[index].panel:Show()
        end
        
        local p = vgui.Create( "DPanel", panel )
        p:SetPos( 0, end_panel_y )
        p:SetSize( panel:GetWide(), end_panel_h )
        p.Paint = function() end
        p:Show()
        p:Hide()
        
        btn.panel = p
        
        local item_list = vgui.Create( "DPanelList", p )
        item_list:SetPos( 0, 0 )
        item_list:SetSize( p:GetWide(), p:GetTall())
        item_list:SetSpacing( 0 ) -- Spacing between items
        item_list:EnableHorizontal( false ) -- Only vertical items
        item_list:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
        item_list.VBar.Paint = function() end
        item_list.VBar.btnUp.Paint = function() end
        item_list.VBar.btnDown.Paint = function() end
        item_list.VBar.btnGrip.Paint = function() 
            draw.RoundedBox( 2, 0, 0, item_list.VBar:GetWide(), item_list.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        
        v.panel = item_list
        
        table.insert( RP.CRAFTING.Buttons, btn )
    end
    RP.CRAFTING.Buttons[1].panel:Show()
end

function RP.CRAFTING.CreateCraftItemSheet( info, panel )
    for k, v in pairs( info.Items ) do
        panel.item_sheets = panel.item_sheets or {}
        
        local craftitem_info = RP.CRAFTING.GetItemInfo( k )
        if craftitem_info == nil then Msg( "[CRAFTING - ERROR] Couldn't get item info from Inventory Addon! Crafting does not show proper - " .. k ) return end
        local end_panel_x, end_panel_y = 150, (panel:GetTall() - (RP.CRAFTING.SheetSize + 5))
        local left = 0
        
        for l=1, #panel.item_sheets do
            left = left + (panel.item_sheets[l]:GetWide() + (RP.CRAFTING.SheetSpace*math.Clamp(l, 0, 1)))
        end
        
        local p = vgui.Create( "DPanel", panel )
        p:SetSize( RP.CRAFTING.SheetSize, RP.CRAFTING.SheetSize )
        p:SetPos( end_panel_x + left, end_panel_y )
        p.Paint = function( self )
            draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        
        
        local ico = vgui.Create( "DModelPanel", p )
        ico:SetModel( craftitem_info.Model )
        ico:SetPos( 2, 2 )
		ico:SetSize( RP.CRAFTING.SheetSize - 4, RP.CRAFTING.SheetSize - 4 )
		
        local ent = ico:GetEntity()
        local max, min = ico:GetEntity():GetRenderBounds()
		ico:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
		ico:SetLookAt( ( min + max ) / 2 )
		
        ico:SetToolTip( CRAFT_LANG[k] )
		
		local overlay = vgui.Create( "DPanel", ico )
		overlay:SetSize( RP.CRAFTING.SheetSize - 4, RP.CRAFTING.SheetSize - 4 )
		overlay.Paint = function( self )
		draw.SimpleTextOutlined( "x" .. tostring( v ), "Trebuchet15", 0, 0, Color( 0, 0, 0, 230 ), 0, 0, 1, Color( 255, 255, 255, 100 ) )
            if !(HasItem( k, v )) then
                surface.SetDrawColor( 255, 255, 255, 255 )
                surface.SetMaterial( Material( "icon16/cross.png" ) )
                surface.DrawTexturedRect( ico:GetWide() - 16, ico:GetTall() - 16, 16, 16 )
            else
                surface.SetDrawColor( 255, 255, 255, 255 )
                surface.SetMaterial( Material( "icon16/tick.png" ) )
                surface.DrawTexturedRect( ico:GetWide() - 16, ico:GetTall() - 16, 16, 16 )
            end
		end
        
        table.insert( panel.item_sheets, p )
    end
end