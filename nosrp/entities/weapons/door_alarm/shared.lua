AddCSLuaFile()

SWEP.PrintName = "Tür Alarm"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

-- Variables that are used on both client and server
SWEP.Base = "weapon_base"

SWEP.Author = "Camotrax"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.UseHands	= false

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/props_lab/reciever01d.mdl")
SWEP.WorldModel = Model("models/props_lab/reciever01d.mdl")
SWEP.AnimPrefix = "slam"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
end

function SWEP:Deploy()
    self:SetWeaponHoldType("slam")
    return true
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if CLIENT then return end
    
    local trace = self.Owner:GetEyeTraceNoCursor()
	local door = trace.Entity
    if !(IsValid( door )) then return end
    if !(door:GetClass() == "prop_door_rotating") then return end
    if self.Owner:GetPos():Distance( trace.HitPos ) > 80 then return end
    local data = door:GetRPVar( "doordata" )
    if data == nil then return end
    
    data.owner = data.owner or nil
    if data.owner == nil then return end
    if data.owner != self.Owner or data.owner:IsBuddy( self.Owner ) then return end
    
    local ang = (self.Owner:GetPos() - trace.HitPos):Angle()
    local y, p, r = ang.y, ang.p, ang.r
    
    local ent = ents.Create( "door_alarm_entity" )
    ent:SetPos( trace.HitPos )
    ent:SetAngles( Angle( 0, y, r ) )
    ent.door = door
    ent.owner = self.Owner
    ent:Spawn()
    self.Owner:DeleteOnRemove( ent )
    constraint.Weld( ent, door, 0, 0, 0, 1, false )
    self:Remove()
end

function SWEP:SecondaryAttack()
	self.LastIron = CurTime()
	self.Ready = not self.Ready
    
	if self.Ready then
		self:SetWeaponHoldType("rpg")
	else
		self:SetWeaponHoldType("normal")
	end
end

function SWEP:Reload()
    self.nextswitch = self.nextswitch or CurTime() - 1
    if self.nextswitch > CurTime() then return false end
    self.nextswitch = CurTime() + 1
    if CLIENT then surface.PlaySound( "buttons/button16.wav" ) end
    print( self.AdminMode )
    if self.AdminMode && self.Owner:IsAdmin() then self.AdminMode = false return false end
    if !(self.AdminMode) && self.Owner:IsAdmin() then self.AdminMode = true return false end
end

function SWEP:DrawWorldModel()
    if IsValid(self.Owner) then
        local obj = self.Owner:LookupAttachment( "Anim_Attachment_RH" )
        local tbl = self.Owner:GetAttachment( obj )
        local pos, ang = tbl.Pos, tbl.Ang
        if(tbl) then
            self:SetRenderOrigin(pos )
            self:SetRenderAngles(ang + Angle( -50, 15, 0 ))
            local Mat = Matrix()
            Mat:Scale(Vector(.5, .5, 1))
            self:EnableMatrix("RenderMultiply",Mat)
        end
    end
	
	self:DrawModel()
end

function SWEP:GetViewModelPosition(pos, ang)
    pos = (pos + (self.Owner:GetForward() * 25) + (self:GetRight()*14) + (self:GetUp()*-10))
    ang:RotateAroundAxis(ang:Up(), 120)
	ang:RotateAroundAxis(ang:Right(), 45)
	return pos,ang
end