if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Handcuffs"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "ToBadForYou"
SWEP.Instructions = "Left Click: Restrain/Release. \nRight Click: Force Players out of vehicle."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.HoldType = "melee";
SWEP.ViewModel = "models/katharsmodels/handcuffs/handcuffs-2.mdl";
SWEP.WorldModel = "models/katharsmodels/handcuffs/handcuffs-1.mdl";

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "melee"
SWEP.Category = "ToBadForYou"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize() self:SetWeaponHoldType("melee") end
function SWEP:CanPrimaryAttack ( ) return true; end

function SWEP:Think()
	local PlayerToCuff = self.AttemptToCuff
	if IsValid(PlayerToCuff) then
		local Trace = self.Owner:GetEyeTrace()
		if !IsValid(Trace.Entity) or Trace.Entity != PlayerToCuff or Trace.Entity:GetPos():Distance(self.Owner:GetPos()) > RHC_CuffRange then
			self.AttemptToCuff = nil
		elseif CurTime() >= self.AttemptCuffFinish then
			if SERVER then
				PlayerToCuff:RHCRestrain(self.Owner)
			end
			self.AttemptToCuff = nil	
		end	
	end	
end

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound("npc/vort/claw_swing" .. math.random(1, 2) .. ".wav")
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local Trace = self.Owner:GetEyeTrace()
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		
	local TPlayer = Trace.Entity
	local Distance = self.Owner:EyePos():Distance(TPlayer:GetPos());
	if Distance > 100 then return false; end		
	if IsValid(TPlayer) and TPlayer:IsPlayer() and !TPlayer:IsRHCWhitelisted() and !IsValid(self.AttemptToCuff) then
		if TPlayer:GetNWBool("rhc_cuffed", false) then
			if SERVER then
				TPlayer:RHCRestrain(self.Owner)
			end
		else
			self.AttemptToCuff = TPlayer
			self.AttemptCuffFinish = CurTime() + RHC_CuffTime
			self.AttemptCuffStart = CurTime()
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then 
		self.Weapon:SetNextSecondaryFire(CurTime() + 1)
		local Player = self.Owner
		local Trace = Player:GetEyeTrace()
	
		local TVehicle = Trace.Entity
		local Distance = Player:GetPos():Distance(TVehicle:GetPos());
		if Distance > 300 then return false; end	
		if IsValid(TVehicle) and TVehicle:IsVehicle() then
			if vcmod1 and !Player.Dragging then
				for k,v in pairs(TVehicle:VC_GetPlayers()) do
					if v.Restrained then 
						local DraggedByP = v.DraggedBy
						if IsValid(DraggedByP) then
							DraggedByP.Dragging = nil
						end
						v.DraggedBy = nil
						v:ExitVehicle()
					end
				end
			elseif vcmod1 and Player.Dragging then	
				local PlayerDragged = Player.Dragging
				if IsValid(PlayerDragged) then
					local SeatsTBL = TVehicle:VC_GetSeatsAvailable()
					if #SeatsTBL < 1 then DarkRP.notify(Player, 1, 4, "No seats available!") return end
					for k,v in pairs(SeatsTBL) do
						local SeatsDist = Player:GetPos():Distance(v:GetPos())
						if SeatsDist < 80 then
							PlayerDragged:EnterVehicle(v)
							break
						end
					end
				end
			elseif NOVA_Config and !Player.Dragging then
				for k,v in pairs(TVehicle:CMGetAllPassengers()) do
					local Empty = v:IsWorld()
					if !Empty then
						local Passenger = v
						if Passenger and Passenger:IsPlayer() and Passenger.Restrained then
							local DraggedByP = v.DraggedBy
							if IsValid(DraggedByP) then
								DraggedByP.Dragging = nil
							end
							v.DraggedBy = nil
							v:ExitVehicle()	
						end	
					end
				end
			elseif NOVA_Config and Player.Dragging then		
				local PlayerDragged = Player.Dragging
				if IsValid(PlayerDragged) then
					local SeatsTBL = TVehicle.CmodSeats
					for k,v in pairs(SeatsTBL) do
						local Driver = v:GetDriver()
						if IsValid(Driver) and Driver:IsPlayer() then
							SeatsTBL[k] = nil
						end
					end
					
					if #SeatsTBL < 1 then DarkRP.notify(Player, 1, 4, "No seats available!") return end
					for k,v in pairs(SeatsTBL) do
						local SeatsDist = Player:GetPos():Distance(v:GetPos())
						if SeatsDist < 80 then
							PlayerDragged:EnterVehicle(v)
							break
						end
					end
				end		
			elseif Player.Dragging and !vcmod1 then
				local DragPlayer = Player.Dragging
				if IsValid(DragPlayer) then
					DragPlayer:EnterVehicle(TVehicle)
				end	
			elseif IsValid(TVehicle:GetDriver()) and TVehicle:GetDriver().Restrained then
				TVehicle:GetDriver():ExitVehicle()				
			end	
		end
	end			
end

if CLIENT then
function SWEP:GetViewModelPosition ( Pos, Ang )
	Ang:RotateAroundAxis(Ang:Forward(), 0);
	Ang:RotateAroundAxis(Ang:Up(), 180);
	Ang:RotateAroundAxis(Ang:Right(), 0);
	Pos = Pos + Ang:Forward() * -20;
	Pos = Pos + Ang:Right() * -10;
	Pos = Pos + Ang:Up() * -8;
		
	return Pos, Ang;
end 
	
function SWEP:DrawWorldModel()
	if not IsValid(self.Owner) then
		return
	end

	local boneindex = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if boneindex then
		local HPos, HAng = self.Owner:GetBonePosition(boneindex)

		local offset = HAng:Right() * 1.5 + HAng:Forward() * 4 + HAng:Up() * -1

		HAng:RotateAroundAxis(HAng:Right(), 0)
		HAng:RotateAroundAxis(HAng:Forward(),  0)
		HAng:RotateAroundAxis(HAng:Up(), 90)
		
		self:SetRenderOrigin(HPos + offset)
		self:SetRenderAngles(HAng)

		self:DrawModel()
	end
end

function SWEP:DrawHUD()
    local PlayerToCuff = self.AttemptToCuff
	if !IsValid(PlayerToCuff) then return end

    local time = self.AttemptCuffFinish - self.AttemptCuffStart
    local curtime = CurTime() - self.AttemptCuffStart
    local percent = math.Clamp(curtime / time, 0, 1)	
    local w = ScrW()
    local h = ScrH()

	local TPercent = math.Round(percent*100)
    draw.DrawNonParsedSimpleText("Cuffing " .. PlayerToCuff:Nick() .. " (" .. TPercent .. "%)", "Trebuchet24", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
end
end