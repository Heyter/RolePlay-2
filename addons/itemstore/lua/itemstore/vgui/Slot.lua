local PANEL = {}

AccessorFunc( PANEL, "Item", "Item" )
AccessorFunc( PANEL, "ContainerID", "ContainerID", FORCE_NUMBER )
AccessorFunc( PANEL, "Slot", "Slot", FORCE_NUMBER )

function PANEL:Init()
	self.BaseClass.Init( self )

	self:Droppable( "ItemStore" )
	self:Receiver( "ItemStore", function( receiver, droptable, dropped )
		local droppable = droptable[ 1 ]

		if not dropped then return end

		local droppable = droptable[ 1 ]

		local from_con = droppable:GetContainerID()
		local to_con = droppable:GetContainerID()

		if not from_con then return end
		if not to_con then return end

		local from_slot = droppable:GetSlot()
		local to_slot = receiver:GetSlot()

		if not from_slot then return end
		if not to_slot then return end

		local from_item = droppable:GetItem()
		local to_item = receiver:GetItem()

		if from_item and to_item and ( from_item:CanMerge( to_item ) or
			from_item:CanUseWith( to_item ) ) then
			local menu = DermaMenu()

			if from_item:CanUseWith( to_item ) then
				menu:AddOption( itemstore.Translate( "usewith" ), function()
					LocalPlayer():UseItemWith( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/wrench_orange.png" )

				menu:AddSpacer()
			end

			menu:AddOption( itemstore.Translate( "move" ), function()
				LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
					receiver:GetContainerID(), receiver:GetSlot() )
			end ):SetIcon( "icon16/arrow_switch.png" )

			if from_item:CanMerge( to_item ) then
				menu:AddOption( itemstore.Translate( "merge" ), function()
					LocalPlayer():MergeItem( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/arrow_join.png" )
			end

			menu:Open()
		else
			LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
				receiver:GetContainerID(), receiver:GetSlot() )
		end
	end )
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( HUD_SKIN.INV_CONTAINER_BG )
	surface.DrawRect( 0, 0, w, h )

	surface.SetDrawColor( HUD_SKIN.INV_BORDER )
	surface.DrawOutlinedRect( 0, 0, w, h )

	surface.SetDrawColor( itemstore.config.Colours.InnerBorder )
	surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )

	self.BaseClass.Paint( self, w, h )

	local item = self:GetItem()
	if item and item:GetAmount() > 1 then
		draw.SimpleTextOutlined( "x" .. item:GetAmount(), "DermaDefault", 4, 
			h - 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black )
	end
end

function PANEL:Refresh()
	local item = self:GetItem()

	if item then
		self:SetModel( item:GetModel() )

		self.Entity:SetMaterial( item:GetMaterial() )
		self:SetColor( item:GetColor() or color_white )

		min, max = self.Entity:GetRenderBounds()

		self:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
		self:SetLookAt( ( min + max ) / 2 )
	else
		self.Entity = nil
		self:SetTooltip( nil )
	end
end

function PANEL:DoDoubleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end
	if not item.Use then return end

	LocalPlayer():UseItem( con_id, slot )
end

function PANEL:DoMiddleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end

	LocalPlayer():DropItem( con_id, slot )
end

function PANEL:DoRightClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end

	local menu = DermaMenu()
	
	menu:AddOption( "Verkaufen", function()
		RunConsoleCommand( "itemstore_sell", con_id, slot )
	end ):SetIcon( "icon16/arrow_out.png" )

	if item.Use then
		menu:AddOption( itemstore.Translate( "use" ), function()
			LocalPlayer():UseItem( con_id, slot )
		end ):SetIcon( "icon16/wrench.png" )

		menu:AddSpacer()
	end

	menu:AddOption( itemstore.Translate( "drop" ), function()
		LocalPlayer():DropItem( con_id, slot )
	end ):SetIcon( "icon16/arrow_out.png" )

	menu:AddOption( itemstore.Translate( "destroy" ), function()
		Derma_Query( itemstore.Translate( "destroy_confirmation" ), itemstore.Translate( "destroy_title" ), itemstore.Translate( "ok" ), function()
			LocalPlayer():DestroyItem( con_id, slot )
		end, itemstore.Translate( "cancel" ) ):SetSkin( "itemstore" )
	end ):SetIcon( "icon16/delete.png" )

	if item:CanSplit( 1 ) then
		menu:AddSpacer()

		local submenu, entry = menu:AddSubMenu( itemstore.Translate( "split" ) )
		entry:SetIcon( "icon16/arrow_divide.png" )

		local half = math.floor( item:GetAmount() / 2 )

		submenu:AddOption( itemstore.Translate( "split_half", half ), function()
			LocalPlayer():SplitItem( con_id, slot, half )
		end )

		submenu:AddSpacer()

		for _, amount in ipairs( { 1, 2, 5, 10, 25, 50, 100, 250, 1000 } ) do
			if item:CanSplit( amount ) then
				submenu:AddOption( amount, function()
					LocalPlayer():SplitItem( con_id, slot, amount )
				end )
			end
		end

		menu:Open()
	end

	item:Run( "PopulateMenu", menu )

	menu:Open()
end

local Tooltip

function PANEL:CreateTooltip()
	if IsValid( Tooltip ) then
		Tooltip:SetVisible( true )
		return
	end

	Tooltip = vgui.Create( "ItemStoreTooltip" )
	self:UpdateTooltip()
end

function PANEL:UpdateTooltip()
	if not IsValid( Tooltip ) then return end

	Tooltip:SetContainerID( self:GetContainerID() )
	Tooltip:SetSlot( self:GetSlot() )
	Tooltip:SetItem( self:GetItem() )
	Tooltip:Refresh()
end

function PANEL:HideTooltip()
	if IsValid( Tooltip ) then Tooltip:SetVisible( false ) end
end

function PANEL:OnCursorEntered()
	if not self:GetItem() then return end

	self:CreateTooltip()
	self:UpdateTooltip()
end

function PANEL:OnCursorMoved()
	if not IsValid( Tooltip ) then return end

	local x, y = gui.MousePos()
	Tooltip:SetPos( x, y - Tooltip:GetTall() )
end

function PANEL:OnCursorExited()
	self:HideTooltip()
end

vgui.Register( "ItemStoreSlot", PANEL, "DModelPanel" )
