AddCSLuaFile()


SWEP.PrintName = "Absperr Band"
SWEP.Slot = 1
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false


SWEP.Author = "CaMoTraX"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

// Custom Settings
SWEP.holder = {}
SWEP.Clientmodel = nil
SWEP.MaxUnits = 1500	// How long the Band can be
SWEP.Distance = 300
SWEP.PlacedUnits = 0

local ShootSound = Sound( "Metal.SawbladeStick" ) 

function SWEP:Initialize()
	self.holstered = false
	self.mode = 1
	self.units = 0
	self.cache = nil
	
	self:SetNWInt( "total", self:GetTotalLength() )
end

--[[---------------------------------------------------------
	Reload does nothing
-----------------------------------------------------------]]
function SWEP:Reload()
	if CLIENT then return end
	self.nreload = self.nreload or CurTime() + 1
	if self.nreload > CurTime() then return end
	self.nreload = CurTime() + 0.2
	
	if #self.holder < 1 then return end
	local prop = self.holder[table.Count( self.holder )]
	local band = self.holder[math.Clamp(table.Count( self.holder ) - 1, 1, 999)].band
	
	// Sort table
	local tbl = {}
	for k, v in pairs( self.holder ) do
		if v == nil or v == NULL or (!IsValid(v)) then continue end
		table.insert( tbl, v )
	end
	self.holder = tbl

	if prop != nil && IsValid( prop ) then
		if band != nil && IsValid( band ) then band:Remove() end
		prop:Remove()
		self.holder[#self.holder] = nil
		
		local new = {}
		for k, v in pairs( self.holder ) do
			if v != nil then table.insert( new, v ) end
		end
		self.holder = new
		
		self.mode = 2
		self.cache = self.holder[table.Count( self.holder)]
		
		if self.cache == nil then self.mode = 1 end
		
		self:SetNWInt( "total", self:GetTotalLength() )
	end
end

--[[---------------------------------------------------------
	PrimaryAttack
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if SERVER then
		local data = self:DoTrace()
		if data.Entity:GetClass() != "police_band_holder" then
			if self.mode == 1 then
				if data.HitPos:Distance( self.Owner:GetPos() ) > self.Distance then return end
				if !(self:HasLeftBand( data )) then return end
				
				local holder = ents.Create( "police_band_holder" )
				holder:SetPos( data.HitPos + Vector( 0, 0, 15 ) )
				holder:Spawn()
				holder:GetPhysicsObject():EnableMotion( false )
				holder.owner = self.Owner
				
				if self.cache != nil && IsValid( self.cache ) then self.cache:Connect( holder ) end
				
				table.insert( self.holder, holder )
				self.mode = 2
				self.cache = holder
				
				self:SetNWInt( "total", self:GetTotalLength() )
			elseif self.mode == 2 then
				if self.cache == nil or self.cache == NULL then self.mode = 1 return end
				if data.HitPos:Distance( self.Owner:GetPos() ) > self.Distance then return end
				if !(self:HasLeftBand( data )) then return end 
				
				local holder = ents.Create( "police_band_holder" )
				holder:SetPos( data.HitPos + Vector( 0, 0, 15 ) )
				holder:Spawn()
				holder:GetPhysicsObject():EnableMotion( false )
				holder.owner = self.Owner
				
				table.insert( self.holder, holder )
				self.cache:Connect( holder )
				
				self.mode = 1
				self.cache = holder
				self:SetNWInt( "total", self:GetTotalLength() )
			end
		else
			if self.cache == nil then
				self.cache = data.Entity
				self.mode = 1
			else
				if !(self:HasLeftBand( data )) then return end
				self.cache:Connect( data.Entity )
				self.cache = nil
				self.mode = 1
				self:SetNWInt( "total", self:GetTotalLength() )
			end
		end
	end
end

--[[---------------------------------------------------------
	SecondaryAttack
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
	if SERVER then
		local data = self:DoTrace()
		
		if data.Entity:GetClass() != "police_band_holder" then
			self.cache = nil
			self.mode = 1
		else
			if IsValid(data.Entity.owner) then 
				for k, wep in pairs( data.Entity.owner:GetWeapons() ) do
					if wep:GetClass() != self:GetClass() then continue end
					
					wep:SetNWInt( "total", wep:GetTotalLength() )
				end
			end
			data.Entity:Remove()
		end
	end
end

function SWEP:Holster()
	self.holstered = true
	
	if CLIENT then
		if self.Clientmodel != nil && IsValid( self.Clientmodel ) then self.Clientmodel:Remove() self.Clientmodel = nil end
		if self.worldmodel != nil && IsValid( self.worldmodel ) then self.worldmodel:Remove() self.worldmodel = nil end
	end
	return true
end

function SWEP:Deploy()
	self.holstered = false
	self:SetHoldType( "slam" )
	
	if SERVER then self.Owner:DrawViewModel(false) end
	
	return true
end


--[[---------------------------------------------------------
   Think does nothing
-----------------------------------------------------------]]
function SWEP:Think()	

end

function SWEP:OnRemove()
	if SERVER then
		for k, v in pairs( self.holder ) do
			if v != nil && IsValid( v ) then
				v:Remove()
			end
		end
		self.holder = {}
	end
	
	if CLIENT then
		if self.Clientmodel != nil && IsValid( self.Clientmodel ) then self.Clientmodel:Remove() self.Clientmodel = nil end
		if self.worldmodel != nil && IsValid( self.worldmodel ) then self.worldmodel:Remove() self.worldmodel = nil end
	end
	
end

// Important Functions

function SWEP:GetTotalLength()
	local count = self:CountHolder() or 0
	local units = 0
	
	for k, v in pairs( self.holder ) do		// Lasst uns alle zwischendurch gelöschten holder als nil kennzeichnen, damit wir es später aussortieren können.
		if v == NULL then v = nil end
	end
	
	for k, v in pairs( self.holder ) do
		if k == count then continue end
		if self.holder[k+1] == NULL or self.holder[k+1] == nil then continue end
		if v == NULL or v == nil then continue end
		
		if v.band == NULL or v.band == nil or !(IsValid( v.band )) then continue end	// Distanz zwischen zwei holdern nicht messen, die überhaupt kein Band besitzen *
		if self.holder[k+1].band == NULL or self.holder[k+1].band == nil or !(IsValid( self.holder[k+1].band )) then continue end		// * Jedoch nacheinander in der Tabelle kommen
		
		units = units + (v:GetPos():Distance( self.holder[k+1]:GetPos() ))
	end
	return units
end

function SWEP:HasLeftBand( data )
	local count = self:CountHolder()
	if count < 1 then return true end
	
	if self.cache == NULL and count > 0 then	// Einige Bänder wurden aus der mitte gelöscht. Cache = NULL .. also neuer anfangspunkt
		self.Owner:RPNotify( "Bitte setze ein neuen Anfagspunkt", 3 )
		return
	end
	
	if self.cache == nil then return true end	// Neuer Punkt
	
	if (self:GetTotalLength() + data.HitPos:Distance( self.cache:GetPos() )) > self.MaxUnits then 
		self.Owner:RPNotify( "Du hast nicht mehr Absperrband!", 4)
		return false
	end
	return true
end

function SWEP:CountHolder()
	local i = 0
	for k, v in pairs( self.holder ) do
		if v == nil or v == NULL then continue end
		i = i + 1
	end
	return i
end
////

if CLIENT then
	function SWEP:DrawHUD()
		draw.SimpleText( "Rechts Klick - Löscht die anvisierte Absperrung. Oder Fertigstellen der Absperrung", "Trebuchet24", ScrW()/2, ScrH() - 75, Color( 255, 255, 255, 200 ), 1, 1 )
		draw.SimpleText( "Links Klick - Setzt ein Eckpunkt", "Trebuchet24", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 200 ), 1, 1 )
		draw.SimpleText( "R - Löscht den letzten Eckpunkt", "Trebuchet24", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 200 ), 1, 1 )
		
		local total = math.Round( self:GetNWInt( "total" ) )
		draw.SimpleText( "Band verbleibend: " .. tostring( self.MaxUnits - total ) .. " Meter", "Trebuchet40", ScrW()/2, ScrH() - 125, Color( 255, 255, 255, 200 ), 1, 1 )
	end
	
	function SWEP:PostDrawViewModel()
		if self.Clientmodel == nil && not self.holstered then
			self.Clientmodel = ClientsideModel( "models/props_junk/TrafficCone001a.mdl", RENDERGROUP_VIEWMODEL_TRANSLUCENT ) 
		end
		if self.Clientmodel != nil then
			local data = self:DoTrace()
			self.Clientmodel:SetPos( data.HitPos + Vector( 0, 0, 15 ) )
			self.Clientmodel:SetColor( Color( 255, 255, 255, 150 ) )
			self.Clientmodel:SetRenderMode( RENDERMODE_TRANSALPHA )
		end
		
	end
	
	function SWEP:DrawWorldModel()
		
		if self.Owner == nil or self.Owner == NULL then return end
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		local pos, ang = self.Owner:GetBonePosition( bone )
		
		self.worldmodel = self.worldmodel or nil
		if self.worldmodel == nil then
			self.worldmodel = ClientsideModel( "models/props_junk/TrafficCone001a.mdl", RENDERGROUP_VIEWMODEL_TRANSLUCENT )
			
			local scale = Vector( .5, .5, .5 )
			local mat = Matrix()
			mat:Scale( scale )
			self.worldmodel:EnableMatrix( "RenderMultiply", mat )
		end
		
		self.worldmodel:SetPos( pos + self.worldmodel:WorldToLocal( Vector( 3, -3, 3 ) ) )
		self.worldmodel:SetAngles( self.worldmodel:WorldToLocalAngles( ang ) )
	end
end

function SWEP:DoTrace()
	local tr = util.TraceLine( {
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 10000,
		filter = {self.Owner}
	} )

	return tr
end
