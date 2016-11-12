--[[---------------------------------------------------------
   weapon: fists
   Desc:
-----------------------------------------------------------]]

AddCSLuaFile( )

if CLIENT then
    SWEP.PrintName = "Fäuste"
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
    SWEP.WepSelectIcon = surface.GetTextureID("weapons/gtfists")

    SWEP.Author = ""
    SWEP.Instructions = "Linksklick: Boxen, Rechtsklick: Schlagen\nBENUTZE DIE SCHLUESSEL FUER NORMALES RP"
    SWEP.Contact = ""
    SWEP.Purpose = ""

    SWEP.ViewModelFOV = 62
    SWEP.ViewModelFlip = false
    SWEP.AnimPrefix  = "rpg"

    SWEP.LockSound = "doors/door_latch1.wav"
    SWEP.UnlockSound = "doors/door_latch3.wav"

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

    SWEP.ViewModel = "models/gtrp/fists/v_fists.mdl";
    SWEP.WorldModel = "models/gtrp/fists/w_fists.mdl";
end

function SWEP:Initialize()
    self:SetWeaponHoldType("fist")
end

function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:PrimaryAttack()   
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav");
    self.Owner:SetAnimation(ACT_HL2MP_GESTURE_RANGE_ATTACK)
        
    self.Weapon:SetNextPrimaryFire(CurTime() + .5)

    local EyeTrace = self.Owner:GetEyeTrace();
    
    local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
    if Distance > 75 then return false; end
    
    if EyeTrace.MatType == MAT_GLASS then
        self.Weapon:EmitSound("physics/glass/glass_cup_break" .. math.random(1, 2) .. ".wav");
        return false
    end
    
    if EyeTrace.HitWorld then
        self.Weapon:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 5) .. ".wav");
        
        return false;
    end
    
    if !EyeTrace.Entity or !EyeTrace.Entity:IsValid() or !EyeTrace.HitNonWorld then return false; end
    
    if EyeTrace.MatType == MAT_FLESH then
        -- probably another person or NPC
        self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(1, 5) .. ".wav")
        
        local OurEffect = EffectData();
        OurEffect:SetOrigin(EyeTrace.HitPos);
        util.Effect("BloodImpact", OurEffect);
        
        if SERVER and !EyeTrace.Entity:IsNPC() then
			if self.Owner:GetNWInt( "IsMighty" ) == 1 then
				EyeTrace.Entity:TakeDamage(25 + self.Owner:GetRPVar( "skills_Stärke" )/2, self.Owner, self.Weapon);
			else
				EyeTrace.Entity:TakeDamage(5 + self.Owner:GetRPVar( "skills_Stärke" )/2, self.Owner, self.Weapon);
				--self.Owner:GiveExperience(SKILL_UNARMED_COMBAT, 2, true);
			end
        end
        
        return false;
    else
        -- something else?
        
        self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet" .. math.random(1, 5) .. ".wav")
    end
end

function SWEP:SecondaryAttack()
    local EyeTrace = self.Owner:GetEyeTrace()

    if !EyeTrace.Entity:IsValid() or !EyeTrace.Entity:IsDoor() then return false; end
    
    local Distance = self.Owner:EyePos():Distance(EyeTrace.HitPos);
    
    if Distance > 75 then return false; end
    
    self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    self.Weapon:EmitSound("physics/plastic/plastic_box_impact_hard" .. tostring(math.random(1, 4)) .. ".wav", 100, 100)
    self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
    
    self.Weapon:SetNextSecondaryFire(CurTime() + .25)
end

function SWEP:SetWeaponHoldType( )
    self.ActivityTranslate = {}
    
    self.ActivityTranslate[ACT_HL2MP_IDLE]                  = ACT_HL2MP_IDLE_FIST;
    self.ActivityTranslate[ACT_HL2MP_WALK]                  = ACT_HL2MP_IDLE_FIST + 1;
    self.ActivityTranslate[ACT_HL2MP_RUN]                   = ACT_HL2MP_IDLE_FIST + 2;
    self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH]           = ACT_HL2MP_IDLE_FIST + 3;
    self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH]           = ACT_HL2MP_IDLE_FIST + 4;
    self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK]  = ACT_HL2MP_IDLE_FIST + 5;
    self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD]        = ACT_HL2MP_IDLE_FIST + 6;
    self.ActivityTranslate[ACT_HL2MP_JUMP]                  = ACT_HL2MP_IDLE_FIST + 7;
    self.ActivityTranslate[ACT_RANGE_ATTACK1]               = ACT_HL2MP_IDLE_FIST + 8;
end
