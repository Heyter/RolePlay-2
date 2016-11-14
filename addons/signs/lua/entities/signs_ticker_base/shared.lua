
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = ""
ENT.Author = "Dan"
ENT.Spawnable = false
ENT.AdminSpawnable = false

Signs.AccessorFunc( ENT, "bgColor", "BackgroundColor", Signs.TickerBackgroundColorDefault, true )
Signs.AccessorFunc( ENT, "text", "Text", "New Text" )
Signs.AccessorFunc( ENT, "textColor", "TextColor", Signs.TickerTextColorDefault, true )
Signs.AccessorFunc( ENT, "textSpeed", "TextSpeed", Signs.TickerSpeedDefault )
Signs.AccessorFunc( ENT, "textDelay", "TextCycleDelay", Signs.TickerCycleDelayDefault )
Signs.AccessorFunc( ENT, "font", "Font", Signs.TickerFontDefault )
Signs.AccessorFunc( ENT, "fontBold", "FontBold", false )
Signs.AccessorFunc( ENT, "fontItalic", "FontItalic", false )
Signs.AccessorFunc( ENT, "fontOutline", "FontOutline", false )


function ENT:WriteData()
	local bgColor = self:GetBackgroundColor()
	local textColor = self:GetTextColor()

	net.WriteUInt( bgColor.r, 8 )
	net.WriteUInt( bgColor.g, 8 )
	net.WriteUInt( bgColor.b, 8 )
	net.WriteUInt( bgColor.a, 8 )

	net.WriteString( self:GetText() )
	net.WriteString( self:GetFont() )

	net.WriteUInt( textColor.r, 8 )
	net.WriteUInt( textColor.g, 8 )
	net.WriteUInt( textColor.b, 8 )
	net.WriteUInt( textColor.a, 8 )

	net.WriteBool( self:GetFontBold() )
	net.WriteBool( self:GetFontItalic() )
	net.WriteBool( self:GetFontOutline() )

	net.WriteFloat( self:GetTextSpeed() )
	net.WriteFloat( self:GetTextCycleDelay() )
end

function ENT:ReadData()
	local bgColor = Color(
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )
	)
	
	local text = net.ReadString()
	local font = net.ReadString()

	if #text > Signs.TextLengthMax then return false end -- overlay text length max
	if !table.HasValue( Signs.Fonts, font ) then return false end -- not valid font

	local textColor = Color(
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )			
	)

	local bold = net.ReadBool()
	local italic = net.ReadBool()
	local outline = net.ReadBool()

	local speed = net.ReadFloat()
	local delay = math.abs( net.ReadFloat() )

	if math.abs( speed ) > 100 or delay > 100 then return end -- shouldn't really exceed these

	self:SetBackgroundColor( bgColor )

	self:SetText( text )
	self:SetFont( font )
	self:SetTextColor( textColor )
	self:SetFontBold( bold )
	self:SetFontItalic( italic )
	self:SetFontOutline( outline )
	self:SetTextSpeed( speed )
	self:SetTextCycleDelay( delay )

	return true
end

function ENT:AddNetworkVar( type, name )
	self.nwvarscnt = self.nwvarscnt or {}

	self.nwvarscnt[type] = (self.nwvarscnt[type] or -1) + 1

	self:NetworkVar( type, self.nwvarscnt[type], name )
end

function ENT:SetupDataTables()
	self:AddNetworkVar( "Entity", "owning_ent" )
end
