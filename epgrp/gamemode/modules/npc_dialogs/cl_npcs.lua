canDoCallback = function( ) end
function CanDoJob( job, fnCallback )
	canDoCallback = fnCallback
	net.Start( "NPC_CanTakeJob" )
        net.WriteString( tostring(job) )
	net.SendToServer( )
end

DIALOG = DIALOG or {}

local function openDialog( dialog, npc )
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 490, 250 )
	frame:SetTitle( "" )
	frame:SetPos( ScrH( ) - frame:GetTall( ), ScrW( ) / 2 - frame:GetWide( ) / 2 )
	frame:SetVisible( true )
	frame:SetDraggable( true ) -- Draggable by mouse?
	frame:ShowCloseButton( true ) -- Show the close button?
	frame:MakePopup( ) -- Show the frame
    frame.Paint = function()
        draw.RoundedBox( 4, 0, 0, frame:GetWide(), frame:GetTall(), HUD_SKIN.LIST_BG_FIRST )
        draw.RoundedBox( 2, 0, 0, frame:GetWide(), 25, HUD_SKIN.THEME_COLOR )
    end
	
	local topPanel = vgui.Create( "DPanel", frame )
	topPanel:DockMargin( 5, 5, 5, 5 )
	topPanel:Dock( FILL )
	
	local npcSay = vgui.Create( "DLabel", topPanel )
	npcSay:DockMargin( 5, 5, 5, 5 )
	npcSay:SetColor( Color( 0, 0, 0, 255 ) )
	npcSay:Dock( FILL )
	
	local bottomPanel = vgui.Create( "DScrollPanel", frame )
	bottomPanel:DockMargin( 5, 5, 5, 5 )
	bottomPanel:Dock( BOTTOM )
	bottomPanel:SetTall( 100 )
    bottomPanel.VBar.Paint = function() 
        local h = bottomPanel.VBar.btnUp:GetTall() + bottomPanel.VBar.btnDown:GetTall()
        draw.RoundedBox( 2, 0, h/2, bottomPanel.VBar:GetWide(), bottomPanel.VBar:GetTall() - h, Color( 0, 0, 0, 100 ) )
    end
    bottomPanel.VBar.btnUp.Paint = function() end
    bottomPanel.VBar.btnDown.Paint = function() end
    bottomPanel.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, bottomPanel.VBar:GetWide(), bottomPanel.VBar:GetTall(), Color( 255, 255, 255, 200 ) )
    end
	
	local modelPanel = vgui.Create( "DModelPanel", topPanel )
	modelPanel:DockMargin( 5, 5, 5, 5 )
	modelPanel:Dock( LEFT )
	modelPanel:SetModel( npc:GetModel( ) )
	modelPanel:SetWide( 100 )
	modelPanel:SetAnimated( false )

	function modelPanel:LayoutEntity( Entity ) end

	local p = modelPanel.Paint
	function modelPanel:Paint( )
		draw.RoundedBox( 6, 0, 0, self:GetWide( ), self:GetTall( ), Color( 80, 80, 80 ) )
		p( self )
	end

	local eyepos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	eyepos:Add( Vector( 0, 16, 38) )	-- Move up slightly
	modelPanel:SetLookAt( eyepos )
	modelPanel:SetCamPos( eyepos-Vector( -230, 0, 0 ) )

	function frame:GoToStage( iStage )
		for k, v in pairs( self.buttons ) do
			v:Remove( )
		end
		self:SetDialog( self.dialogs[iStage] )
	end
	
	frame.buttons = { }
	function frame:SetDialog( dialogTable )
		npcSay:SetText( dialogTable.npcsay )
		local add = 0
		local Next = CurTime()
		local delay = 0.2
		local i = 0
		for k, v in pairs( dialogTable.options ) do
			i = i + 1
			local btn = vgui.Create( "DButton", bottomPanel )
			btn:SetText( "" )
			btn:SetPos( 0, add )
			
			btn.Next = Next
			btn.s = 0
			btn.max = frame:GetWide()
			btn:SetWide( btn.s )
			
			function btn.DoClick( )
				v( self )
			end
            btn.Paint = function()
                local font = "RPNormal_20"
                local text = k
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                draw.RoundedBox( 4, 0, 0, btn:GetWide(), btn:GetTall(), HUD_SKIN.THEME_COLOR )
                draw.SimpleText( k, "RPNormal_20", (btn:GetWide() - w) / 2, (btn:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
            end
			btn.Think = function()
				if (btn.Next > CurTime()) then return end
				if !(btn.s >= btn.max) then btn.s = btn.s + 20 end
				btn:SetWide( btn.s )
			end
			
			Next = CurTime() + delay*i
			add = add + btn:GetTall() + 5
			table.insert( self.buttons, btn )
		end
	end
	if type( dialog ) == "function" then
		frame.dialogs = dialog( )
	else
		frame.dialogs = dialog
	end
	
	frame:GoToStage( 1 )
end

net.Receive( "NPC_DialogOpen", function( )
	local npc = net.ReadEntity( )
	local dialog = net.ReadString( )
	openDialog( DIALOG[dialog], npc )
end )