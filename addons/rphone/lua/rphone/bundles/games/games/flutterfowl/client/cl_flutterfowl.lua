
--Special thanks to Tommy228 (http://coderhire.com/users/view/9) for much of the code and content for Flutter Fowl

local ObstacleScrollPeriod = 1.75
local VerticalAcceleration = 2.25
local FlapVelocity = 0.6
local InputButtons = {
	KEY_SPACE,
	MOUSE_LEFT
}
local Instructions = "Press LMB or Space to jump"


local function assertMaterial( mat, params )
	local mat = Material( mat, params )

	if !mat or mat:IsError() then
		rPhone.Error( "Missing Flutter Fowl textures." )
	end

	return mat
end

local bird_mats = {}
local number_mats = {}
local background_mat = assertMaterial( "dan/rphone/bundles/games/flutterfowl/background.png", "noclamp" )
local ground_mat = assertMaterial( "dan/rphone/bundles/games/flutterfowl/ground.png", "noclamp smooth" )
local pole1_mat = assertMaterial( "dan/rphone/bundles/games/flutterfowl/pipe1.png" )
local pole2_mat = assertMaterial( "dan/rphone/bundles/games/flutterfowl/pipe2.png" )
local pole_ar = pole1_mat:Width() / pole1_mat:Height()

local die_snd = Sound( "dan/rphone/bundles/games/flutterfowl/die.mp3" )
local flap_snd = Sound( "dan/rphone/bundles/games/flutterfowl/flap.mp3" )
local hit_snd = Sound( "dan/rphone/bundles/games/flutterfowl/hit.mp3" )
local point_snd = Sound( "dan/rphone/bundles/games/flutterfowl/point.mp3" )

do
	for i=1, 3 do
		bird_mats[i] = assertMaterial( "dan/rphone/bundles/games/flutterfowl/bird" .. i .. ".png" )
	end

	for i=0, 9 do
		number_mats[i] = assertMaterial( "dan/rphone/bundles/games/flutterfowl/" .. i .. ".png" )
	end	
end

local apk_games = rPhone.AssertPackage( "games" )
local GAME = apk_games.RegisterGame( "Flutter Fowl" )  --if a material fails to load, so will the game



function GAME:Initialize( gdb )
	self.pk_os = rPhone.AssertPackage( "os" )

	local w, h = self:GetSize()

	self.ground_height = math.floor( h * (1/5) )

	self.bird_size = math.floor( h / 13 )

	self.pole_height = h - self.ground_height
	self.pole_width = math.floor( self.pole_height * pole_ar )
	self.pole_cap = self.pole_height / 10

	self.obstacle_spacing = 3.5 * self.pole_width
	self.obstacle_length = self.pole_width + self.obstacle_spacing
	self.obstacle_max = math.ceil( w / self.obstacle_length ) + 1
	self.obstacle_gap = self.bird_size * 2.75

	self.scroll_velocity = self.obstacle_length / ObstacleScrollPeriod

	self.started = false
	self.inprogress = false

	self:Reset()

	self.best_score = gdb.best_score or 0

	self.button_states = {}


	self.lblinstr = rPhone.CreatePanel( "DLabel", self:GetPanel() )
		self.lblinstr:SetText( Instructions )
		self.lblinstr:SetFont( "Trebuchet18" )
		self.lblinstr:SizeToContents()
		self.lblinstr:SetPos( 
			(w - self.lblinstr:GetWide()) / 2, 
			h - ((self.ground_height + self.lblinstr:GetTall()) / 2)
		)
end

function GAME:Reset()
	local w, h = self:GetSize()

	self.bird_x = h * (1/5)
	self.bird_y = h * (3/5)
	self.bird_velocity = 0

	self.scroll_pos = -(w * (6/5))

	self.dead = false
	self.obstacles = {}
	self.score = 0
end

function GAME:PlayDeathSound()
	surface.PlaySound( hit_snd )

	timer.Simple( 0.3, function()
		surface.PlaySound( die_snd )
	end )
end

function GAME:WasButtonPressed()
	if !self:IsInForeground() then return false end

	local hpnl = vgui.GetHoveredPanel()
	local pressed = false

	for _, bid in pairs( InputButtons ) do
		local isdown = input.IsButtonDown( bid )
		
		if isdown and self.button_states[bid] == false and
			(!(bid == MOUSE_LEFT or bid == MOUSE_RIGHT) or 
				(hpnl == self:GetPanel() or hpnl == self.lblinstr)) then
			pressed = true
		end

		self.button_states[bid] = isdown
	end

	return pressed
end

function GAME:Think( dt )
	if dt > (1/12) then return end  --rudimentary lag compensation

	if self:WasButtonPressed() and self.pk_os.HasKeyboardFocus() then
		if !self.inprogress then
			if self.dead then
				self:Reset()
			end

			self.started = true
			self.inprogress = true

			self.obstacles = {}

			for i=1, self.obstacle_max do
				self.obstacles[i] = math.random()
			end

			if IsValid( self.lblinstr ) then
				self.lblinstr:AlphaTo( 0, 1, 3, function()
					self.lblinstr:Remove()
				end )
			end
		elseif !self.dead then
			self.bird_velocity = (FlapVelocity * self:GetHeight())

			surface.PlaySound( flap_snd )
		end
	end

	if self.bird_y > self.ground_height then
		if self.started then
			self.bird_velocity = self.bird_velocity - (VerticalAcceleration * dt * self:GetHeight())
			self.bird_y = math.max( self.ground_height, self.bird_y + (self.bird_velocity * dt) )
		end
	elseif !self.dead then
		self.dead = true
		self.inprogress = false

		self:PlayDeathSound()
	end

	if self.inprogress then
		self.scroll_pos = self.scroll_pos + (self.scroll_velocity * dt)

		local brx = self.scroll_pos + self.bird_x
		local brfx = brx + self.bird_size
		local obidx = math.floor( brfx / self.obstacle_length ) + 1

		if obidx > 0 then
			local ob = self.obstacles[obidx]
			local gap = self.obstacle_gap
			local cap = self.pole_cap

			if !self.obstacles[obidx + self.obstacle_max] then
				self.obstacles[obidx + self.obstacle_max] = math.random()
			end

			local obrx = (obidx - 1) * self.obstacle_length
			local oby = self.ground_height + (gap / 2) + cap + (ob * (self:GetHeight() - self.ground_height - gap - (cap * 2)))

			if (brfx >= obrx and brx <= obrx + self.pole_width) and 
				((self.bird_y + self.bird_size >= oby + (gap / 2)) or 
					(self.bird_y < oby - (gap / 2))) then
				self.dead = true
				self.inprogress = false

				self.bird_velocity = 0

				self:PlayDeathSound()
			end

			local newscore = math.floor( (math.max( brx, 0 ) - self.pole_width + self.obstacle_length) / self.obstacle_length )

			if newscore > self.score then
				self.score = newscore
				self.best_score = math.max( self.score, self.best_score )

				surface.PlaySound( point_snd )
			end
		end
	end
end

function GAME:Draw( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( background_mat )
	surface.DrawTexturedRectUV(
		0, 0, 
		w, h,
		0, 0,
		(h / background_mat:Height()) * (3/2), 1
	)


	if self.started then
		local brx = self.scroll_pos + self.bird_x
		local brfx = brx + self.bird_size
		local obidx = math.floor( brfx / self.obstacle_length ) + 1
		local gap = self.obstacle_gap
		local cap = self.pole_cap
		local start = obidx - 1

		for i=start, start + self.obstacle_max do
			local ob = self.obstacles[i]

			if ob then
				local obrx = (i - 1) * self.obstacle_length
				local obx = obrx - self.scroll_pos
				local oby = self.ground_height + (gap / 2) + cap + (ob * (self:GetHeight() - self.ground_height - gap - (cap * 2)))

				if obx + self.pole_width >= 0 and obx <= w then
					surface.SetMaterial( pole1_mat )
					surface.DrawTexturedRect( obx, h - (oby + (gap / 2) + self.pole_height), self.pole_width, self.pole_height )

					surface.SetMaterial( pole2_mat )
					surface.DrawTexturedRect( obx, h - (oby - (gap / 2)), self.pole_width, self.pole_height )
				end
			end
		end
	end


	local gmw = ground_mat:Width()
	local grndscr = (self.started and self.scroll_pos or (SysTime() * self.scroll_velocity)) * (2 / gmw)

	surface.SetMaterial( ground_mat )
	surface.DrawTexturedRectUV(
		0, h - self.ground_height,
		w, self.ground_height,
		grndscr, 0,
		((w / gmw) * 2) + grndscr, 1
	)


	surface.SetMaterial( bird_mats[math.floor( ((SysTime() % 0.5) * 6) ) + 1] )
	surface.DrawTexturedRectRotated( 
		self.bird_x + (self.bird_size / 2), 
		h - (self.bird_y + self.bird_size / 2),
		self.bird_size, self.bird_size, 
		90 * (self.bird_velocity / 1000) 
	)


	local scorestr = tostring( self.score )
	local xoff = (w - ((#scorestr * 24) + ((#scorestr - 1) * 5))) / 2

	for i=1, #scorestr do
		surface.SetMaterial( number_mats[math.floor( tonumber( scorestr[i] ) )] )
		surface.DrawTexturedRect( xoff + ((i - 1) * (24 + 5)), 25, 24, 36 )
	end

	draw.SimpleText( 
		"Best: " .. self.best_score,
		"Trebuchet18",
		w - 5, 5,
		Color( 255, 255, 255, 175 ),
		TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP
	)
end

function GAME:Finalize( gdb )
	gdb.best_score = self.best_score
end
