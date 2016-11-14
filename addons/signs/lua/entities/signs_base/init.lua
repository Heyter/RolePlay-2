
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "signs_edit" )
util.AddNetworkString( "signs_send_data" )


function ENT:Initialize()
	self:SetModel( self.Model )
	self:SetMaterial( "models/debug/debugwhite" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON ) -- don't collide with players
	
	self:SetUseType( SIMPLE_USE )
	
	local owner = self:Getowning_ent()

	self.Owned = IsValid( owner )

	if self.Owned then
		self.OwnerSteamID = owner:SteamID()

		if self.CPPISetOwner then
			self:CPPISetOwner( owner )
		end
	end
	
	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then 
		phys:Wake()
	end
end

function ENT:BroadcastData( ply )
	local bgColor = self:GetBackgroundColor()
	local imgUrl = self:GetImageUrl()
	local imgCropMode = self:GetImageCropMode()
	local textOverlays = self:GetTextOverlays() 

	net.Start( "signs_send_data" )
		net.WriteEntity( self )

		net.WriteUInt( bgColor.r, 8 )
		net.WriteUInt( bgColor.g, 8 )
		net.WriteUInt( bgColor.b, 8 )
		net.WriteUInt( bgColor.a, 8 )

		net.WriteString( imgUrl )
		net.WriteUInt( imgCropMode, 8 )

		net.WriteUInt( #textOverlays, 8 )

		for _, overlay in ipairs( textOverlays ) do
			net.WriteString( overlay.text )
			net.WriteString( overlay.font )
			net.WriteUInt( overlay.size, 8 )

			net.WriteInt( overlay.x, 16 )
			net.WriteInt( overlay.y, 16 )

			net.WriteUInt( overlay.color.r, 8 )
			net.WriteUInt( overlay.color.g, 8 )
			net.WriteUInt( overlay.color.b, 8 )
			net.WriteUInt( overlay.color.a, 8 )

			net.WriteBool( overlay.bold )
			net.WriteBool( overlay.italic )
			net.WriteBool( overlay.outline )
		end

	if ply then 
		net.Send( ply )
	else
		net.Broadcast()
	end
end
function HasPerm(ply)
	local allowedgroups = {"superadmin", "moderator"}
	
	for k,v in pairs(allowedgroups) do
		if ply:IsUserGroup(v) then
			return true
		end
	end
	
	return false
end

function ENT:AllowInteraction( ply )
	return HasPerm(ply) or (self.Owned and ply == self:Getowning_ent())
end


function ENT:Use( ply )
	ply:SendLua([[gui.OpenURL("]] .. self:GetInteractionUrl() .. [[")]])

	if !self:AllowInteraction( ply ) then return end

	net.Start( "signs_edit" )
		net.WriteEntity( self )
	net.Send( ply )
end

function ENT:UpdateTransmitState() -- not ideal, but ensures sign exists when sending data to clients (could also queue it up and check when needed, which would be better)
	return TRANSMIT_ALWAYS
end

function ENT:PhysgunPickup( ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	return self:AllowInteraction( ply )
end

function ENT:OnPhysgunFreeze( _, _, _, ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	local interact = self:AllowInteraction( ply )

	if interact then 
		return nil -- return nil to allow freeze (weird)
	else
		return false
	end
end

function ENT:GravGunPickup( ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	return self:AllowInteraction( ply )
end

function ENT:GravGunPunt( ply )
	if Signs.EnableDefaultFPPBehaviors then 
		return ply:IsAdmin() 
	end
end

function ENT:CanTool( ply ) 
	if Signs.EnableDefaultFPPBehaviors then 
		return ply:IsAdmin() 
	end
end


local playerDataDelays = {}

local function updateSign( ent, bgColor, imgUrl, imgCropMode, overlays )
	ent:SetBackgroundColor( bgColor )
	ent:SetImageUrl( imgUrl )
	ent:SetImageCropMode( imgCropMode )
	ent:SetTextOverlays( overlays )

	ent:BroadcastData()
end

net.Receive( "signs_send_data", function( ply, len )
	if playerDataDelays[ply] and (CurTime() - playerDataDelays[ply]) < 1 then return end -- prevents spam

	playerDataDelays[ply] = CurTime()

	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_base" then return end

	local bgColor = Color(
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )
	)
	local imgUrl = net.ReadString()
	local imgCropMode = net.ReadUInt( 8 )
	local overlays = {}

	for i=1, net.ReadUInt( 8 ) do
		local text = net.ReadString()
		local font = net.ReadString()
		local size = net.ReadUInt( 8 )

		if #text > Signs.TextLengthMax then return end -- overlay text length max
		if !table.HasValue( Signs.Fonts, font ) then return end -- not valid font
		if size > Signs.TextOverlayFontSizeMax or size < Signs.TextOverlayFontSizeMin then return end -- overlay size allowed interval

		overlays[i] = {
			text = text,
			font = font,
			size = size,

			x = net.ReadInt( 16 ), y = net.ReadInt( 16 ),

			color = Color(
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 )			
			),

			bold = net.ReadBool(),
			italic = net.ReadBool(),
			outline = net.ReadBool()
		}
	end

	if #overlays > Signs.TextOverlayMax then return end -- overlay count max
	if #imgUrl > 256 then return end -- URL too long

	if #imgUrl > 0 then
		imgUrl = imgUrl:gsub( -- not great, but should be good enough
			'[^%w _~%.%-%%:/\\]', 
			function( str ) 
				return ('%%%02X'):format( str:byte() ) 
			end
		)

		http.Fetch( imgUrl, function( _, len ) -- check if exceeds size limit
			if IsValid( ent ) and len <= Signs.ImageFileSizeMax * 1000 then
				updateSign( ent, bgColor, imgUrl, imgCropMode, overlays )
			end
		end )
	else
		updateSign( ent, bgColor, imgUrl, imgCropMode, overlays )
	end
end )

hook.Add( "PlayerInitialSpawn", "signs_playerinitialspawn", function( ply )
	timer.Simple( 10, function()
		if !IsValid( ply ) then return end

		for _, ent in pairs( ents.GetAll() ) do
			if ent.Base == "signs_base" then
				ent:BroadcastData( ply )
			end
		end
	end )
end )
