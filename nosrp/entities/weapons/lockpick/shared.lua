AddCSLuaFile( )

SWEP.PrintName = "Lock Pick"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

-- Variables that are used on both client and server

SWEP.Author = "Camotrax"
SWEP.Instructions = "Left click to pick a lock"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
    self.max_picks = self.max_picks or ( math.Round( math.Rand(15, 40 -(15-(self.Owner:GetSkill( "Schloss Knacken" ) or 0))) ) )
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	local trace = self.Owner:GetEyeTrace()
    
    if !(IsValid( trace.Entity )) then return end
    if !(IsDoor( trace.Entity )) then return end
    if trace.Entity:GetPos():Distance( self.Owner:GetPos() ) > 65 then return end
    
    local snd = {1,3,4}
    self:EmitSound("weapons/357/357_reload".. tostring(snd[math.random(1, #snd)]) ..".wav", 50, 100)
    if CLIENT then return end
    
    self.max_picks = self.max_picks - 1
    print( self.max_picks )
    if self.max_picks < 1 then self.Owner:RPNotify( "Dein Lockpick ist kaputt gegangen!", 5 ) self:Remove() return end
    
    local max = 35 - (self.Owner:GetSkill( "Schloss Knacken" ) or 0)
    
    local rand = math.Rand( 1, max )
    rand = math.Round( rand )
    
    if rand == math.Round(max/5) or rand == math.Round(max/1.5) or rand == math.Round(max/6) then
        trace.Entity:Fire("open", "", .6)
        trace.Entity:Fire("unlock", "", .6)
		trace.Entity:Fire("setanimation","open",.6)
        self.Owner:SetSkill( "Schloss Knacken", 0.05, true )
        self.Owner:SetSkill( "Ruf", -0.05, true )
    end 
end

function SWEP:Holster()
    return true
end

function SWEP:Think()

end

function SWEP:DrawHUD()

end

function SWEP:SecondaryAttack()
	return false
end
