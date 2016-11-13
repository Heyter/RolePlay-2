local Config = {}

--- 3D ESCAPE MENU CONFIGURATION ---

Config.DeathrunWorkaround = false
Config.IgnoreConsole = false -- set this to false if you want your console to bypass the esc menu
Config.CameraCollision = true -- set this to false if you would rather have the camera phase through walls when the menu is active

Config.Header = {}
Config.Header.Text = "EPG RolePlay"
Config.Header.Font = "Roboto Condensed"
Config.Header.Size = 64
Config.Header.Weight = 700
Config.Header.FontColor = Color( 236, 240, 241, 255 )
Config.Header.BackgroundColor = Color( 52, 152, 219, 200 )

Config.Category = {}
Config.Category.Font = "Roboto Bold"
Config.Category.Size = 16
Config.Category.Weight = 60
Config.Category.FontColor = Color( 127, 140, 141, 255 )
Config.Category.BackgroundColor = Color( 236, 240, 241, 200 )

Config.Button = {}
Config.Button.Font = "Roboto"
Config.Button.Size = 32
Config.Button.Weight = 500
Config.Button.FontColor = Color( 236, 240, 241, 255 )
Config.Button.BackgroundColor = Color( 0, 0, 0, 200 )

-- Format:
-- { "<type of entry>", "<label>", "<action>", "<argument (url, cmd to run, etc)>" },

Config.Entries = {
	{ "Category", "COMMUNITY" },
	{ "Button", "Forums", "URL", "https://epic-gaming.de" }
}

--- CONFIGURATION END ---

surface.CreateFont( "3DEscapeHeader", {
	font = Config.Header.Font,
	size = Config.Header.Size,
	weight = Config.Header.Weight
} )

surface.CreateFont( "3DEscapeCategory", {
	font = Config.Category.Font,
	size = Config.Category.Size,
	weight = Config.Category.Weight
} )

surface.CreateFont( "3DEscapeButton", {
	font = Config.Button.Font,
	size = Config.Button.Size,
	weight = Config.Button.Weight
} )

local Blur = Material( "3dblur" )

local function DrawBlur( x, y, w, h )
	--render.UpdateFullScreenDepthTexture()
	--render.UpdatePowerOfTwoTexture()
	--render.UpdateRefractTexture()

	surface.SetMaterial( Blur )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRect( x, y, w, h )
end

local Panel = {}

function Panel:Inherit()
	return setmetatable( {}, { __index = self } )
end

function Panel:New()
	local obj = {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
		Hovered = false
	}

	setmetatable( obj, { __index = self } )

	obj:Init()

	return obj
end

function Panel:Init()
end

function Panel:Think()
end

function Panel:Render( x, y, w, h )
end

function Panel:OnHover()
end

function Panel:OnUnhover()
end

function Panel:Clicked()
end

function Panel:GetPos()
	return self.x, self.y
end

function Panel:SetPos( x, y )
	self.x = x
	self.y = y
end

function Panel:GetSize()
	return self.w, self.h
end

function Panel:SetSize( w, h )
	self.w = w
	self.h = h
end

function Panel:GetWidth()
	return self.w
end

function Panel:SetWidth( w )
	self.w = w
end

function Panel:GetHeight()
	return self.h
end

function Panel:SetHeight( h )
	self.h = h
end

local Button = Panel:Inherit()

function Button:New()
	local obj = Panel.New( self )

	obj.Text = ""
	obj.Font = "3DEscapeButton"

	obj.FontColor = table.Copy( Config.Button.FontColor )
	obj.BackgroundColor = table.Copy( Config.Button.BackgroundColor )

	return obj
end

function Button:GetText()
	return self.Text
end

function Button:SetText( txt )
	self.Text = txt
end

function Button:GetFont()
	return self.Font
end

function Button:SetFont( fnt )
	self.Font = fnt
end

function Button:Think()
	if self.Hovered then
		self.FontColor.r = Lerp( FrameTime() * 10, self.FontColor.r, Config.Button.BackgroundColor.r )
		self.FontColor.g = Lerp( FrameTime() * 10, self.FontColor.g, Config.Button.BackgroundColor.g )
		self.FontColor.b = Lerp( FrameTime() * 10, self.FontColor.b, Config.Button.BackgroundColor.b )

		self.BackgroundColor.r = Lerp( FrameTime() * 10, self.BackgroundColor.r, Config.Button.FontColor.r )
		self.BackgroundColor.g = Lerp( FrameTime() * 10, self.BackgroundColor.g, Config.Button.FontColor.g )
		self.BackgroundColor.b = Lerp( FrameTime() * 10, self.BackgroundColor.b, Config.Button.FontColor.b )
	else
		self.FontColor.r = Lerp( FrameTime() * 10, self.FontColor.r, Config.Button.FontColor.r )
		self.FontColor.g = Lerp( FrameTime() * 10, self.FontColor.g, Config.Button.FontColor.g )
		self.FontColor.b = Lerp( FrameTime() * 10, self.FontColor.b, Config.Button.FontColor.b )

		self.BackgroundColor.r = Lerp( FrameTime() * 10, self.BackgroundColor.r, Config.Button.BackgroundColor.r )
		self.BackgroundColor.g = Lerp( FrameTime() * 10, self.BackgroundColor.g, Config.Button.BackgroundColor.g )
		self.BackgroundColor.b = Lerp( FrameTime() * 10, self.BackgroundColor.b, Config.Button.BackgroundColor.b )
	end
end

function Button:OnHover()
	surface.PlaySound( "garrysmod/ui_hover.wav" )
end

function Button:Clicked()
	surface.PlaySound( "garrysmod/ui_click.wav" )
end

function Button:Render( x, y, w, h )
	DrawBlur( x, y, w, h )

	surface.SetDrawColor( self.BackgroundColor )
	surface.DrawRect( x, y, w, h )

	draw.SimpleText( self:GetText(), self:GetFont(), x + 10, y + h / 2, self.FontColor,
		TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

local Category = Panel:Inherit()

function Category:New()
	local obj = Panel.New( self )

	obj.FontColor = table.Copy( Config.Category.FontColor )
	obj.BackgroundColor = table.Copy( Config.Category.BackgroundColor )

	obj.Text = ""
	obj.Font = "3DEscapeCategory"

	return obj
end

function Category:GetText()
	return self.Text
end

function Category:SetText( txt )
	self.Text = txt
end

function Category:GetFont()
	return self.Font
end

function Category:SetFont( fnt )
	self.Font = fnt
end

function Category:Render( x, y, w, h )
	DrawBlur( x, y, w, h )

	surface.SetDrawColor( self.BackgroundColor )
	surface.DrawRect( x, y, w, h )

	draw.SimpleText( self:GetText(), self:GetFont(), x + 25, y + h / 2, self.FontColor,
		TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
end

local Header = Panel:Inherit()

function Header:New()
	local obj = Panel.New( self )

	obj.Text = Config.Header.Text
	obj.Font = "3DEscapeHeader"

	obj.FontColor = table.Copy( Config.Header.FontColor )
	obj.BackgroundColor = table.Copy( Config.Header.BackgroundColor )

	return obj
end

function Header:GetText()
	return self.Text
end

function Header:SetText( txt )
	self.Text = txt
end

function Header:GetFont()
	return self.Font
end

function Header:SetFont( fnt )
	self.Font = fnt
end

function Header:Render( x, y, w, h )
	DrawBlur( x, y, w, h )

	surface.SetDrawColor( self.BackgroundColor )
	surface.DrawRect( x, y, w, h )

	draw.SimpleText( self:GetText(), self:GetFont(), x + w / 2, y + h / 2, self.FontColor,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

local Menu = {}

function Menu:New()
	local obj = {
		Panels = {},

		Pos = vector_origin,
		Ang = angle_zero,
		Scale = 1,

		Width = 0,
		Height = 0,

		Padding = 5,

		CursorX = nil,
		CursorY = nil,

		CameraLerp = 0,

		Opened = false,

		ForceMainMenu = false,
		NextClose = 0,
	}

	setmetatable( obj, { __index = self } )

	obj:Init()

	return obj
end

function Menu:Init()
	hook.Add( "PostDrawTranslucentRenderables", self, self.Render )
	hook.Add( "RenderScene", self, self.UpdateCursor )
	hook.Add( "Think", self, self.Think )
	hook.Add( "GUIMousePressed", self, self.MousePressed )
	hook.Add( "PreventScreenClicks", self, self.PreventScreenClicks )

	hook.Add( "ShouldDrawLocalPlayer", self, self.ShouldDrawLocalPlayer )
	hook.Add( "CalcView", self, self.CalcView )

	hook.Add( "PreRender", self, self.PreRender )
	hook.Add( "HUDShouldDraw", self, self.HideCrosshair )
	hook.Add( "CreateMove", self, self.DropInput )
end

function Menu:IsValid()
	return true
end

function Menu:IsOpen()
	return self.Opened
end

function Menu:SetOpen( o )
	self.Opened = o
	gui.EnableScreenClicker( o )

	if Config.DeathrunWorkaround and HUD then HUD:SetVisible( not o ) end
end

function Menu:Open()
	self:SetOpen( true )
end

function Menu:Close()
	self:SetOpen( false )
end

function Menu:GetPos()
	return self.Pos
end

function Menu:SetPos( v )
	self.Pos = v
end

function Menu:GetAngles()
	return self.Ang
end

function Menu:SetAngles( a )
	self.Ang = a
end

function Menu:GetScale()
	return self.Scale
end

function Menu:SetScale( s )
	self.Scale = s
end

function Menu:GetSize()
	return self.Width, self.Height
end

function Menu:SetSize( w, h )
	self.Width = w
	self.Height = h
end

function Menu:GetPadding()
	return self.Padding
end

function Menu:SetPadding( p )
	self.Padding = p
end

function Menu:UpdateCursor( pos, ang, fov )
	self.CursorX = nil
	self.CursorY = nil

	local intersect = util.IntersectRayWithPlane( pos, gui.ScreenToVector( gui.MousePos() ),
		self:GetPos(), self:GetAngles():Forward() )

	if not intersect then return end

	local local_pos = intersect - self:GetPos()
	local_pos:Rotate( -self:GetAngles() )
	local_pos = local_pos / self:GetScale()

	self.CursorX = math.floor( local_pos.y )
	self.CursorY = math.floor( -local_pos.z )
end

function Menu:GetCursor()
	if self.CursorX and self.CursorY then return self.CursorX, self.CursorY end
end

function Menu:GetPanelUnderCursor()
	local cx, cy = self:GetCursor()
	if not cx or not cy then return end

	for k, v in ipairs( self.Panels ) do
		local x, y = v:GetPos()
		local w, h = v:GetSize()

		if cx >= x and cy >= y and x + w >= cx and y + h >= cy then return v end
	end
end

function Menu:IsPanelHovered( p )
	local cx, cy = self:GetCursor()
	if not cx or not cy then return false end

	local x, y = p:GetPos()
	local w, h = p:GetSize()

	return cx >= x and cy >= y and x + w >= cx and y + h >= cy
end

function Menu:IsLookedAt()
	if not self:IsOpen() then return false end
	
	local x, y = self:GetCursor()
	if not x or not y then return false end

	local w, h = self:GetSize()

	return x >= 0 and w >= x and y >= 0 and h >= y
end

function Menu:Layout()
	local x, y = 0, 0 
	local w, h = self:GetSize()

	for k, v in ipairs( self.Panels ) do
		local pw, ph = v:GetSize()

		v:SetPos( x, y )
		v:SetSize( w, ph )

		y = y + ph + self:GetPadding()
	end
end

function Menu:Autosize()
	local max_x, max_y = 0, 0

	for k, v in ipairs( self.Panels ) do
		local x, y = v:GetPos()
		local w, h = v:GetSize()

		if x + w > max_x then max_x = x + w end
		if y + h > max_y then max_y = y + h end
	end

	self:SetSize( max_x, max_y )
	return max_x, max_y
end

function Menu:AddPanel( p )
	local i = table.insert( self.Panels, p )
	self:Layout()

	return i
end

function Menu:RemovePanel( i )
	table.remove( self.Panels, i )
end

function Menu:Render()
	if self.CameraLerp <= 0.1 then return end

	local pos, ang, s = self:GetPos(), self:GetAngles(), self:GetScale()

	local ang_rotated = ang * 1
	ang_rotated:RotateAroundAxis( ang:Up(), 90 )
	ang_rotated:RotateAroundAxis( ang:Right(), 270 )

	cam.IgnoreZ( true )
	cam.Start3D2D( pos, ang_rotated, s )

	for k, v in ipairs( self.Panels ) do
		local x, y = v:GetPos()
		local w, h = v:GetSize()
		v:Render( x, y, w, h )
	end

	cam.End3D2D()
	cam.IgnoreZ( false )
end

function Menu:Think()
	self.CameraLerp = Lerp( FrameTime() * 5, self.CameraLerp, self:IsOpen() and 1 or 0 )

	-- 76561198144499214
	if not self:IsOpen() then return end

	local pl = LocalPlayer()

	if pl:GetObserverMode() == OBS_MODE_IN_EYE or pl:GetObserverMode() == OBS_MODE_CHASE then
		pl = pl:GetObserverTarget()
	end

	local w, h = self:GetSize()
	local rel_pos = Vector( 0, 0, h / 2 * self:GetScale() )
	local rel_ang = Angle( 0, pl:EyeAngles().y, 0 )

	local pos = pl:GetPos() + Vector( 0, 0, 35 ) + rel_pos + rel_ang:Right() * -40
	local ang = rel_ang + Angle( 0, -30, 0 )

	self:SetPos( pos )
	self:SetAngles( ang )

	for k, v in ipairs( self.Panels ) do
		v:Think()

		if self:IsPanelHovered( v ) and not v.Hovered then
			v.Hovered = true
			v:OnHover()
		elseif not self:IsPanelHovered( v ) and v.Hovered then
			v.Hovered = false
			v:OnUnhover()
		end
	end
end

function Menu:CalcView( pl, pos, ang, fov )
	if self.CameraLerp <= 0.0001 then return end

	local menu_pos = self:GetPos()
	local menu_ang = self:GetAngles()
	local w, h = self:GetSize()

	local center = menu_pos - Vector( 0, 0, h / 2 * self:GetScale() )

	local ideal_pos = center + menu_ang:Forward() * 100 + Vector( 0, 0, 15 )
	local ideal_ang = ( center - ideal_pos ):Angle()

	local lerp_pos = LerpVector( self.CameraLerp, pos, ideal_pos )
	local lerp_ang = LerpAngle( self.CameraLerp, ang, ideal_ang )

	if Config.CameraCollision then 
		local tr = util.TraceLine{
			start = LocalPlayer():EyePos(), --menu_pos - lerp_ang:Forward() * 5,
			endpos = lerp_pos,
			filter = LocalPlayer()
		}

		if tr.Hit then
			lerp_pos = tr.HitPos + tr.HitNormal * 5
		end
	end
	
	local view = {}
	view.origin = lerp_pos
	view.angles = lerp_ang
	view.fov = fov

	return view
end

function Menu:ShouldDrawLocalPlayer( pl )
	if self.CameraLerp > 0.25 then return true end
end

function Menu:HideCrosshair( el )
	if self:IsOpen() and el == "CHudCrosshair" then return false end
end

function Menu:PreventScreenClicks()
	if self:IsLookedAt() then return true end
end

function Menu:MousePressed( mc )
	if not self:IsLookedAt() then return end

	local p = self:GetPanelUnderCursor()
	if not p then return end

	p:Clicked()
end

function Menu:PreRender()
	if not Config.IgnoreConsole and gui.IsConsoleVisible() then self.ForceMainMenu = true end

	if self.ForceMainMenu and self.NextClose < CurTime() 
		and not gui.IsGameUIVisible() then self.ForceMainMenu = false end

	if gui.IsGameUIVisible() and not self.ForceMainMenu then
		gui.HideGameUI()
		self:SetOpen( not self:IsOpen() )
	end
end

function Menu:DropInput( cmd )
	if not self:IsOpen() then return end

	cmd:ClearMovement()
	cmd:ClearButtons()
end

if MENU then
	hook.Remove( "PostDrawTranslucentRenderables", MENU )
	hook.Remove( "RenderScene", MENU )
	hook.Remove( "Think", MENU )
	hook.Remove( "GUIMousePressed", MENU )
	hook.Remove( "PreventScreenClicks", MENU )

	hook.Remove( "ShouldDrawLocalPlayer", MENU )
	hook.Remove( "CalcView", MENU )

	hook.Remove( "PreRender", MENU )
	hook.Remove( "HUDShouldDraw", MENU )

	MENU = nil
end

MENU = Menu:New()
MENU:SetAngles( Angle( 0, 90, 0 ) )
MENU:SetScale( 0.15 )
MENU:SetSize( 500, 800 )

local h = Header:New()
h:SetHeight( 72 )
MENU:AddPanel( h )

for k, v in ipairs( Config.Entries ) do
	local p

	if v[ 1 ] == "Category" then
		p = Category:New()
		p:SetHeight( 24 )
		p:SetText( v[ 2 ] )	
	elseif v[ 1 ] == "Button" then
		p = Button:New()
		p:SetHeight( 48 )
		p:SetText( v[ 2 ] )

		function p:Clicked()
			surface.PlaySound( "garrysmod/ui_click.wav" )

			if v[ 3 ] == "URL" then
				gui.OpenURL( v[ 4 ] )
			elseif v[ 3 ] == "Command" then
				RunConsoleCommand( unpack( string.Explode( " ", v[ 4 ] ) ) )
			elseif v[ 3 ] == "Lua" then
				RunString( v[ 4 ] )
			end
		end
	end

	MENU:AddPanel( p )
end

-- I will show up at your home and personally kick your face in if you remove these
local b = Category:New()
b:SetHeight( 24 )
b:SetText( "GARRY'S MOD" )
MENU:AddPanel( b )

local b = Button:New()
b:SetHeight( 48 )
b:SetText( "Disconnect" )

function b:Clicked()
	surface.PlaySound( "garrysmod/ui_click.wav" )
	RunConsoleCommand( "disconnect" )
end

MENU:AddPanel( b )

local b = Button:New()
b:SetHeight( 48 )
b:SetText( "Main Menu" )

function b:Clicked()
	surface.PlaySound( "garrysmod/ui_click.wav" )
	MENU.ForceMainMenu = true
	MENU.NextClose = CurTime() + 1
	gui.ActivateGameUI()
end

MENU:AddPanel( b )

local b = Button:New()
b:SetHeight( 48 )
b:SetText( "Close" )

function b:Clicked()
	surface.PlaySound( "garrysmod/ui_click.wav" )
	MENU:Close()
end

MENU:AddPanel( b )
MENU:Autosize()