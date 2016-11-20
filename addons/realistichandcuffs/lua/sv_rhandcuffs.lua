
local PLAYER = FindMetaTable( "Player" )
 
resource.AddWorkshop("761228248")
 
util.AddNetworkString("rhc_sendcuffs")
util.AddNetworkString("rhc_sendjailtime")
 
function PLAYER:CanRHCDrag(CPlayer)
    if !CPlayer.Restrained or (CPlayer.DraggedBy or self.Dragging) and (self.Dragging != CPlayer or CPlayer.DraggedBy != self) then return end

    if RHC_DraggingPermissions == 1 and CPlayer.CuffedBy == self then
        return true
    elseif RHC_DraggingPermissions == 2 and self:IsRHCWhitelisted() then
        return true
    elseif RHC_DraggingPermissions == 3 then
        return true
    end
end

function PLAYER:CleanUpRHC(GWeapons, NoReset)
    self.Restrained = false
    self:SetupRBones()
    if !NoReset then
        local CBy = self.CuffedBy
        if IsValid(CBy) then
            CBy.CuffedPlayer = nil
        end
        self.CuffedBy = nil
    end
    self:SetupCuffs()
    self:CancelDrag()
    if GWeapons then
        self:SetupWeapons()
    end
end
 
function PLAYER:SetupRBones()
    local L_UPPERARM = self:LookupBone("ValveBiped.Bip01_L_UpperArm")
    local R_UPPERARM = self:LookupBone("ValveBiped.Bip01_R_UpperArm")
    local L_FOREARM = self:LookupBone("ValveBiped.Bip01_L_Forearm" )
    local R_FOREARM = self:LookupBone("ValveBiped.Bip01_R_Forearm" )
    local L_HAND = self:LookupBone("ValveBiped.Bip01_L_Hand" ) 
    local R_HAND = self:LookupBone("ValveBiped.Bip01_R_Hand" )
	
	if L_UPPERARM and R_UPPERARM and L_FOREARM and R_FOREARM and L_HAND and R_HAND then
		if self.Restrained then
			if table.HasValue(RHC_FEMALE_MODELS, self:GetModel()) then
				self:ManipulateBoneAngles(L_UPPERARM, Angle(5, 5, 0))
				self:ManipulateBoneAngles(R_UPPERARM, Angle(-5, 10, 0))
				self:ManipulateBoneAngles(L_FOREARM, Angle(16, 5, 0))
				self:ManipulateBoneAngles(R_FOREARM, Angle(-16, 5, 0))         
				self:ManipulateBoneAngles(L_HAND, Angle(-25, -10, 0))
				self:ManipulateBoneAngles(R_HAND, Angle(25, -10, 0))
			else
				self:ManipulateBoneAngles(L_UPPERARM, Angle(5, 5, 0))
				self:ManipulateBoneAngles(R_UPPERARM, Angle(-5, 10, 0))
				self:ManipulateBoneAngles(L_FOREARM, Angle(25, 5, 0))
				self:ManipulateBoneAngles(R_FOREARM, Angle(-25, 5, 0))
				self:ManipulateBoneAngles(L_HAND, Angle(-25, -10, 0))                  
				self:ManipulateBoneAngles(R_HAND, Angle(25, -10, 0))           
			end
			if RHC_DisablePlayerShadow then
				self:DrawShadow(false)
			end
		elseif !self.Restrained then
			self:ManipulateBoneAngles(L_UPPERARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(R_UPPERARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(L_FOREARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(R_FOREARM, Angle(0, 0, 0))
			self:ManipulateBoneAngles(L_HAND, Angle(0, 0, 0))  
			self:ManipulateBoneAngles(R_HAND, Angle(0, 0, 0))  
		end
	end
end
 
function PLAYER:SetupCuffs()
    if self.Restrained then
        local Cuffs = ents.Create("rhandcuffsent")
        Cuffs.CuffedPlayer = self
        self.Cuffs = Cuffs
        Cuffs:SetPos(self:GetPos())
        Cuffs:Spawn()
        //Returns nil otherwise
        timer.Simple(0.1, function()
            net.Start("rhc_sendcuffs")
                net.WriteEntity(self)
                net.WriteEntity(Cuffs)
            net.Broadcast()
        end)
        self:SetNWBool("rhc_cuffed", true)
    elseif !self.Restrained then
        if IsValid(self.Cuffs) then
            self.Cuffs:Remove()
        end    
        self:SetNWBool("rhc_cuffed", false)
    end
end
 
function PLAYER:SetupWeapons()
    if self.Restrained then
        self.StoreWTBL = {}
        for k,v in pairs(self:GetWeapons()) do
            self.StoreWTBL[k] = v:GetClass()
        end
        self:StripWeapons()
    elseif !self.Restrained then
        for k,v in pairs(self.StoreWTBL) do
            self:Give(v)
			local SWEPTable = weapons.GetStored(v)
			if SWEPTable then
				local DefClip = SWEPTable.Primary.DefaultClip
				local AmmoType = SWEPTable.Primary.Ammo
				if (DefClip and DefClip > 0) and AmmoType then
					local AmmoToRemove = DefClip - SWEPTable.Primary.ClipSize
					self:RemoveAmmo(AmmoToRemove, AmmoType)
				end
			end
        end
        self.StoreWTBL = {}
    end
end

function PLAYER:RHCRestrain(HandcuffedBy)
    if !self.Restrained then
        self.Restrained = true
        self.CuffedBy = HandcuffedBy
        self:SetupRBones()
        self:SetupCuffs()
        self:SetupWeapons()
		if HandcuffedBy != nil then
			HandcuffedBy.CuffedPlayer = self
			self:RPNotify( "Du wurdest von " .. HandcuffedBy:Nick() .. " in Handschellen gelegt.", 3 )
			HandcuffedBy:RPNotify( "Du hast " .. self:Nick() .. " erfolgreich Handschellen angelegt.", 3 )   
		end
    elseif self.Restrained then
        self:CleanUpRHC(true)
		if HandcuffedBy != nil then
			self:RPNotify( "Du wurdest von " .. HandcuffedBy:Nick() .. " befreit.", 3 )
			HandcuffedBy:RPNotify( "Du hast " .. self:Nick() .. " erfolgreich befreit.", 3 ) 
		end
    end
end
 
local PGettingDragged = {}
function PLAYER:DragPlayer(TPlayer)
    if self == TPlayer.DraggedBy then
        TPlayer:CancelDrag()
    elseif !self.Dragging then
		TPlayer.DraggedBy = self
        TPlayer:Freeze(true)
        self.Dragging = TPlayer
        if !table.HasValue(PGettingDragged, TPlayer) then
            table.insert(PGettingDragged, TPlayer)
        end    
    end    
end
 
function PLAYER:CancelDrag()
    if !IsValid(self) then return end
    if !table.HasValue(PGettingDragged, self) then
        table.RemoveByValue(PGettingDragged, self)
    end
	self:Freeze(false)
	local DraggedByP = self.DraggedBy
	if IsValid(DraggedByP) then
		DraggedByP.Dragging = nil
	end
	self.DraggedBy = nil
end
 
local KeyToCheck = RHC_KEY
hook.Add("KeyPress", "AllowDragging", function(Player, Key)
	if Key == KeyToCheck then
        if !Player:InVehicle() then
			local Trace = {}
			Trace.start = Player:GetShootPos();
			Trace.endpos = Trace.start + Player:GetAimVector() * 100;
			Trace.filter = Player;
	 
			local Tr = util.TraceLine(Trace);
			local TEnt = Tr.Entity
			if IsValid(TEnt) and TEnt:IsPlayer() and Player:CanRHCDrag(TEnt) then
				Player:DragPlayer(TEnt)			
			end
		end
    end
end)
 
local DragRange = RHC_DragMaxRange
hook.Add("Think", "HandlePlayerDraggingRange", function()
    for k,v in pairs(PGettingDragged) do
        if !IsValid(v) then table.RemoveByValue(PGettingDragged, v) end
        local DPlayer = v.DraggedBy
        if IsValid(DPlayer) then
            local Distance = v:GetPos():Distance(DPlayer:GetPos());
            if Distance > DragRange then
                v:CancelDrag()
            end
        else
            v:CancelDrag()
        end
    end
end)
 
hook.Add( "Move", "rhc_drag_move", function( Player, mv)
    local CuffedPlayer = Player.Dragging
    if IsValid(CuffedPlayer) and Player == CuffedPlayer.DraggedBy then
		
		local DragerPos = Player:GetPos()
		local DraggedPos = CuffedPlayer:GetPos()
		local Distance = DragerPos:Distance(DraggedPos)
		
		local DragPosNormal = DragerPos:GetNormal()
		local Difx = math.abs(DragPosNormal.x)
		local Dify = math.abs(DragPosNormal.y)	
		
		local Speed = (Difx + Dify)*math.Clamp(Distance/150,0,15)

		local ang = mv:GetMoveAngles()
        local pos = mv:GetOrigin()
        local vel = mv:GetVelocity()
		
        vel.x = vel.x * Speed
        vel.y = vel.y * Speed
		vel.z = 15
 
        pos = pos + vel + ang:Right() + ang:Forward() + ang:Up()
		
		if Distance > 55 then
			CuffedPlayer:SetVelocity( vel )
		end
    end
end )
 
hook.Add("playerCanChangeTeam", "RestrictTCHANGECuffed", function(Player, Team)
    if Player.Restrained then return false, "Can't change team while cuffed." end
end)
 
hook.Add("SetupMove", "CuffMovePenalty", function(Player, mv)
    if Player.Restrained then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() / 2.5)
    elseif Player.Dragging then
        mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() / 2)
    end
end)
 
hook.Add("PlayerDeath", "ManageCuffsDeath", function( Player, Inflictor, Attacker )
    if Player.Restrained then
        Player:CleanUpRHC(false)
    end
end)
 
hook.Add("onLockpickCompleted", "OnSuccessPickCuffs", function(Player, Success, CuffedP)
    if CuffedP:GetNWBool("rhc_cuffed", false) and Success then
        CuffedP:CleanUpRHC(true)
		
        CuffedP:RPNotify("Du wurdest erfolgreich von " .. Player:Nick() .. " befreit.", 3)
        Player:RPNotify("Du hast " .. CuffedP:Nick() .. " erfolgreich befreit.", 3)
        if CuffedP:isArrested() then
            CuffedP:unArrest(Player)
        end
    end
end)
 
hook.Add("CanPlayerEnterVehicle", "RestrictEnteringVCuffs", function(Player, Vehicle)
    if Player.Restrained and !Player.DraggedBy then
		Player:RPNotify("Du kannst nicht fahren, während du in Handschellen bist!", 3)
        return false
	elseif Player.Dragging then
		return false
    end
end)
 
hook.Add("PlayerEnteredVehicle", "FixCuffsInVehicle", function(Player,Vehicle)
    if Player.Restrained then
        Player:CleanUpRHC(false, true)
        Player.Restrained = true		
    end
end)
 
hook.Add("PlayerLeaveVehicle", "ReaddCuffsLVehicle", function(Player, Vehicle)
    if Player.Restrained then
        Player:SetupCuffs()
        Player:SetupRBones()
    end
end)
 
hook.Add("CanExitVehicle", "RestrictLeavingVCuffs", function(Vehicle, Player)
    if Player.Restrained then
		Player:RPNotify("Du kannst das Fahrzeug mit Handschellen nicht verlassen!", 3)
        return false
    end
end)

hook.Add("PlayerDisconnected", "RHC_StopDragOnDC", function(Player)
	local Dragger = Player.DraggedBy
	if IsValid(Dragger) then
		if !table.HasValue(PGettingDragged, Player) then
			table.RemoveByValue(PGettingDragged, Player)
		end
		Dragger.Dragging = nil
	end
end)
 
hook.Add("PlayerInitialSpawn", "SendCuffInfo", function(Player)
    //Allow to intialize fully first
    timer.Simple(3, function()
        for k,v in pairs(ents.FindByClass("rhandcuffsent")) do
            net.Start("rhc_sendcuffs")
                net.WriteEntity(v.CuffedPlayer)
                net.WriteEntity(v)
            net.Send(Player)   
        end
    end)
end)
 
hook.Add("PlayerSpawnProp", "DisablePropSpawningCuffed", function(Player)
    if Player.Restrained then
		Player:RPNotify("Du kannst keine Props spawnen, während du in Handschellen bist!", 3)
        return false
    end
end)

hook.Add("PlayerLoadout", "AddCuffsWToCP", function(Player)
    if Player:IsRHCWhitelisted() then
        Player:Give("weapon_r_handcuffs")
    end
end)
 
hook.Add("canArrest", "MustbeCuffedArrest", function(Player, ArrestedPlayer)
    if RHC_RestrainArrest then
        if !ArrestedPlayer.Restrained then
            return false,"Der Spieler muss in Handschellen sein, damit er weggesperrt werden kann!"
		elseif ArrestedPlayer:isArrested() then
			return false, "Der Spieler ist bereits eingesperrt!"
        end
    end
end)
 
hook.Add("playerArrested", "SetTeamArrested", function(Player, time, Arrester)
	if RHC_SetTeamOnArrest then	
		Player.PreCArrestT = Player:Team()
		Player.PreCArrestM = Player:GetModel()
		Player:SetTeam(RHC_ArrestTeam)
		
        local jobTable = Player:getJobTable()
        if jobTable then
			local JobModel = ""					
			if istable(jobTable.model) then
				JobModel = jobTable.model[math.random(#jobTable.model)]
			else
				JobModel = jobTable.model
			end		
			Player:SetModel(JobModel)
		end
	end	
    if Player.Restrained then
        Player:CleanUpRHC(false, true)
		if RHC_RestrainOnArrest then
			timer.Simple(.5, function()
				Player.Restrained = true
				Player:SetupCuffs()
				Player:SetupRBones()
			end)
		end
    end
	Player.ArrestTime = time
	
	local ANick = "None"
	if IsValid(Arrester) then
		ANick = Arrester:Nick()
		if RHC_ArrestReward then
			local RAmount = RHC_ArrestRewardAmount
			Arrester:addMoney(RAmount)
			Arrester:RPNotify("Du hast " .. RAmount .. "€ als Belhnung für das Einsperren von " .. Player:Nick() .. " erhalten.", 5)
		end	
	end

	Player.HCArrestedBy = ANick
	
	net.Start("rhc_sendjailtime")
		net.WriteEntity(Player)
		net.WriteString(ANick)
		net.WriteFloat(time)
	net.Broadcast()
end)
 
hook.Add("playerUnArrested", "RemoveCuffsUnarrest", function(Player, UnarrestPlayer)
    if Player.Restrained then
        Player:CleanUpRHC(false)
    end
	if RHC_SetTeamOnArrest then
		if Player.PreCArrestT then
			Player:SetTeam(Player.PreCArrestT)
			Player.PreCArrestT = nil
		end
		if Player.PreCArrestM then
			Player:SetModel(Player.PreCArrestM)
			Player.PreCArrestM = nil
		end
	end	
	Player.StoreWTBL = {}
end)
 
hook.Add("canUnarrest", "RestrictUnArrestCuffed", function(Player, UnarrestPlayer)
    if RHC_UnarrestMustRemoveCuffs and UnarrestPlayer.Restrained and !Player:IsRHCWhitelisted() then
        return false, "Verwende einen Dietrich um diesen Spieler zu befreien!"
    end
end)

hook.Add("PlayerCanPickupWeapon", "DisablePickingupWeaponsRHC", function(Player)
	if Player.Restrained then return false end
 end)
 
hook.Add("VC_CanEnterPassengerSeat", "RHC_VCMOD_EnterSeat", function(Player, Seat, Vehicle)
    local DraggedPlayer = Player.Dragging
    if IsValid(DraggedPlayer) then
        DraggedPlayer:EnterVehicle(Seat)
        return false
    end
end)

hook.Add("VC_CanSwitchSeat", "RHC_VCMOD_SwitchSeat", function(Player, SeatFrom, SeatTo)
	if Player.Restrained then
		return false
	end
end)