
local CameraSwapIcon = "dan/rphone/icons/camera_swap.png"
local SaveIcon = "dan/rphone/icons/save.png"


local APP = rPhone.CreateAppPackage( "camera" )

APP.Launchable = true
APP.DisplayName = "Camera"
APP.Icon = "dan/rphone/icons/camera.png"
APP.HideTitle = true


local shouldDrawBeam = true
local shouldDrawPlayer = false

hook.Add( "ShouldDrawLocalPlayer", "cl_camera_apk_drawplayer", function()
	if shouldDrawPlayer then return true end
end )

hook.Add( "DrawPhysgunBeam", "cl_camera_apk_drawbeam", function()
	if !shouldDrawBeam then return false end
end )




function APP:Initialize()
	local pk_os = rPhone.AssertPackage( "os" )

	self.canv = self:GetCanvas()
	local cw, ch = self.canv:GetSize()

	self:SetMode( "eye" )

	local preview = self.canv:AddPanel( "RPDContentButton" )
		preview:SetSize( cw, ch )
		preview.Paint = function( pnl, w, h )
			local x, y = pnl:LocalToScreen()

			self:DrawPreview( x, y, w, h )
		end
		preview.OnMouseWheeled = function( pnl, ds )
			if self.mode == "pan" then
				self.pan_dist = math.Clamp( self.pan_dist - (ds * self.pan_zoom_speed), 20, 1000 )
			else
				self.eye_fov = math.Clamp( self.eye_fov - (ds * 2), 20, 90 )
			end
		end
		preview.Think = function( pnl )
			if !pnl:IsHovered() or !pnl:IsDown() then
				self.lastpos = nil

				return
			end

			local mx, my = gui.MousePos()

			self.lastpos = self.lastpos or { x = mx, y = my }

			local dx = mx - self.lastpos.x
			local dy = my - self.lastpos.y

			if self.mode == "eye" then
				self.eye_ang.p = math.Clamp( self.eye_ang.p - (dy * self.eye_speed), -89.9, 89.9 )
				self.eye_ang.y = self.eye_ang.y + (dx * self.eye_speed)
			elseif self.mode == "pan" then
				self.pan_ang.p = math.Clamp( self.pan_ang.p - (dy * self.pan_speed), -89.9, 89.9 )
				self.pan_ang.y = self.pan_ang.y - (dx * self.pan_speed)
			end

			self.lastpos.x = mx
			self.lastpos.y = my
		end

	local btnmode = self.canv:AddPanel( "RPDImageButton" )
		btnmode:SetSize( 48, 48 )
		btnmode:SetPos( 5, ch - btnmode:GetTall() )
		btnmode:SetPadding( 0 )
		btnmode:SetColor( Color( 255, 255, 255, 80 ) )
		btnmode:SetHoveredColor( Color( 255, 255, 255, 255 ) )
		btnmode:SetDepressedColor( Color( 255, 255, 255, 180 ) )
		btnmode:SetImage( CameraSwapIcon )
		btnmode.DoClick = function( pnl )
			self:SetMode( (self.mode == "pan") and "eye" or "pan" )
		end

	local btnsave = self.canv:AddPanel( "RPDImageButton" )
		btnsave:SetSize( 32, 32 )
		btnsave:SetPos( cw - btnsave:GetWide() - 5, ch - btnsave:GetTall() - 7 )
		btnsave:SetPadding( 0 )
		btnsave:SetColor( Color( 255, 255, 255, 80 ) )
		btnsave:SetHoveredColor( Color( 255, 255, 255, 255 ) )
		btnsave:SetDepressedColor( Color( 255, 255, 255, 180 ) )
		btnsave:SetImage( SaveIcon )
		btnsave.DoClick = function( pnl )
			self:Capture( APP.GetShouldCaptureFullscreen() )
		end

	pk_os.AddAppAction( self, "Settings", function()
		pk_os.LaunchApp( "settings", { PageName = APP.DisplayName } )
	end )
end

function APP:SetMode( mode )
	if mode != "eye" and mode != "pan" or mode == self.mode then return end

	self.mode = mode

	local aimang = LocalPlayer():GetAimVector():Angle()

	if mode == "eye" then
		self.eye_ang = aimang
		self.eye_speed = 0.175
		self.eye_fov = 45
	elseif mode == "pan" then
		self.pan_ang = aimang
		self.pan_dist = 200
		self.pan_speed = 0.35
		self.pan_zoom_speed = 10
	end
end

function APP:DrawView( x, y, w, h, pos, ang, fov, drawplayer )
	local ratio = w / h

	shouldDrawBeam = false
	shouldDrawPlayer = (drawplayer == true)

	cam.Start3D()
		render.RenderView( {
			origin = pos,
			angles = ang,
			aspectratio = ratio,
			fov = fov,
			x = x, y = y,
			w = w, h = h,
			dopostprocess = false, 
			drawhud = false,
			drawmonitors = true,
			drawviewmodel = false
		} )
	cam.End3D()

	shouldDrawBeam = true
	shouldDrawPlayer = false	
end

function APP:DrawPreview( x, y, w, h )
	local sp = LocalPlayer():GetShootPos()

	if self.mode == "eye" then
		self:DrawView( 
			x, y, w, h,
			sp, self.eye_ang,
			self.eye_fov,
			false
		)
	elseif self.mode == "pan" then
		local dir = self.pan_ang:Forward()
		local trace = util.QuickTrace( sp, dir * self.pan_dist, player.GetAll() )
		local vpos = sp + self.pan_ang:Forward() * self.pan_dist

		if trace.Hit then
			vpos = trace.HitPos + (trace.HitNormal * 10)
		end

		self:DrawView( 
			x, y, w, h,
			vpos, (sp - vpos):Angle(),
			45,
			true
		)
	end
end

function APP:Capture( fullscr )
	local px, py = 0, 0
	local pw, ph = ScrW(), ScrH()

	if !fullscr then
		local cw, ch = self.canv:GetSize()
		local scale = math.min( pw / cw, ph / ch )

		pw = math.floor( cw * scale )
		ph = math.floor( ch * scale )

		px = math.floor( (ScrW() - pw) / 2 )
		py = math.floor( (ScrH() - ph) / 2 )
	end

	local pnl = vgui.Create( "DPanel" )
		pnl:SetSize( ScrW(), ScrH() )
		pnl.Paint = function( pnl, w, h )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, w, h )

			self:DrawPreview( px, py, pw, ph )
		end
		pnl:MakePopup()

	RunConsoleCommand( "screenshot" )

	timer.Simple( 0.05, function() pnl:Remove() end )
end
