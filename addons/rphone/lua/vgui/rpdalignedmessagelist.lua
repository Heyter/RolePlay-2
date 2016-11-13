
local PANEL = {}

AccessorFunc( PANEL, "msgspacer", "MessageSpacer", FORCE_NUMBER )
AccessorFunc( PANEL, "msgcol", "MessageColor" )
AccessorFunc( PANEL, "msgbrdcol", "MessageBorderColor" )

function PANEL:Init()
	self:SetPadding( 5 )
	self:SetSpacing( 5 )
	self:EnableVerticalScrollbar( true )

	self:SetMessageSpacer( 50 )

    self.lines = {}
end

function PANEL:AddLine( mkstr, align, top )
	local line = vgui.Create( "RPDAlignedMessage", self )
		line:SetAlignment( align )
		line:SetSpacer( self.msgspacer )
		line:SetPadding( 4 )
		line:SetText( mkstr )
		if self.msgcol then
			line:SetColor( self.msgcol )
		end
		if self.msgbrdcol then
			line:SetBorderColor( self.msgbrdcol )
		end

	table.insert( self.lines, line )

	if top then
		self:InsertAtTop( line )
	else
		self:AddItem( line )
	end

    local pnlcanv = self:GetCanvas()

    if IsValid( pnlcanv ) then
        self:PerformLayout()
        self.VBar:SetScroll( pnlcanv:GetTall() )
        self:PerformLayout()
    end

   return line
end

function PANEL:Paint( w, h )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, w, h )
end

derma.DefineControl( "RPDAlignedMessageList", "", PANEL, "DPanelList" )
