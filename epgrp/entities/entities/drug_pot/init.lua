AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.SeizeReward = 100

function ENT:Initialize()
	self:SetModel( "models/props_c17/pottery06a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	self:SetColor(Color(120,88,0,255))
	self.plant = NULL
	self.done = false
	self.canuse = true
	self.gotseed = false
    self.pickup = false
	
	self.locked = false
	
	self.cantouch = CurTime() + 2
	
	phys:Wake()
end

function ENT:Touch( ent )
	if !(ent:GetClass() == "weed_seed") then return end
	if self.gotseed then return end
	self.cantouch = self.cantouch or CurTime()
	if !(CurTime() > self.cantouch) then return end
	
	self.cantouch = CurTime() + 2
	
	
	local ply = FindPlayerBySteamID( self.owner )

	if self:CanPlant( ply ) == "max" then 
		ply:RPNotify( "Du kannst nicht mehr Drogen anpflanzen!", 5 )
		return 
    elseif self:CanPlant( ply ) == "job" then
        ply:RPNotify( "Dein Job lässt das anpflanzen von Drogen nicht zu!", 5 )
        return
    elseif self:CanPlant( ply ) == "skill" then
        ply:RPNotify( "Du brauchst mehr Intelligenz um Drogen zu pflanzen!", 5 )
        return
	end
	ent:EmitSound("/buttons/button19.wav", 50, 100)
    self.locked = true
	
	// NEW SYSTEM
	local skill = ply:GetSkill( "Weed Erfahrung" ) or 0
	local quality_increase = DRUGDEALER.CONFIG.EXPQualityIncrease * skill
	local gramm_calc = DRUGDEALER.CONFIG.SkillGIncrease * skill
	
	local gramm = math.Round( math.Rand( DRUGDEALER.CONFIG.MinGramm + gramm_calc,DRUGDEALER.CONFIG.MaxGramm ) )
	local quality = math.Clamp( math.Round( math.Rand( ent.quality + DRUGDEALER.CONFIG.DefaultMinQuality, (ent.quality + DRUGDEALER.CONFIG.DefaultMaxQuality) + quality_increase ) ), 0, 100 )
	
	self.gramm = gramm
	self.quality = quality
	///
    
    local angrand = math.Rand(-180, 180)

    local leaf = ents.Create( "drug_leaf" )
    leaf:SetPos(self:LocalToWorld(Vector(0,0,10)))
    leaf:SetColor( Color( 89, 47, 0, 255 ) )
    leaf:SetAngles(self:LocalToWorldAngles(Angle(0, angrand, 0)))
    leaf.dt.status = 1
    leaf:SetParent( self )
    leaf:Spawn()
    self.plant = leaf
    self:DeleteOnRemove( leaf )
    
    timer.Create("growing_plant_timer" .. self:EntIndex(), 0.1, 0, function()
        self.plant.dt.status = self.plant.dt.status + 1
        if self.plant.dt.status >= 100 then
            self.done = true
            self.canuse = true
            self.locked = false
            self:SetColor(Color(182, 133, 0, 255))
            timer.Destroy("growing_plant_timer" .. self:EntIndex())
        end
    end)
	
	self.gotseed = true
	ent:Remove()
    
    ply:SetSkill( "Weed Erfahrung", 0.02, true )
end

function ENT:CanPlant( ply )
	local founds = 0
    if ply:IsPolice() or ply:IsSWAT() then return "job" end
    if ply:GetSkill( "Intelligenz" ) < 1 then return "skill" end
	for k, v in pairs( ents.FindByClass( "drug_pot" ) ) do
		if !(IsValid( v.plant )) then continue end -- Ist nicht angepflanzt
		if tostring(v.owner) != tostring(ply:SteamID()) then continue end -- Owner ist nicht der Player
		founds = founds + 1
	end

	local max_drugs = SETTINGS.MaxWeedDrugs or 0
    max_drugs = max_drugs + (SETTINGS.VIPWeedAdd*ply:GetVIPLevel())
    
    if ply:IsAdmin() then max_drugs = max_drugs + 6 end
	
	if founds >= max_drugs then
		return "max"
	else
		return "ok"
	end
end

function ENT:OnRemove()
	timer.Destroy("growing_plant_timer" .. self:EntIndex())
end

function ENT:OnTakeDamage(dmg)
	--self:Remove()
end

function ENT:Use(ply,caller)
    if self.pickup then
        ply:PickupItem( self )
        return
    end
	if !self.canuse then return end
	
	if !self.done then return end
	
	self.canuse = false
	timer.Simple(1, function() self.canuse = true end)
	
	local pos = self:GetPos()
	local seeddroprate = math.Round(math.Rand(1,3))
	
	
	local skill = ply:GetSkill( "Weed Erfahrung" ) or 0
	local quality_increase = DRUGDEALER.CONFIG.EXPQualityIncrease * skill
	if seeddroprate == 2 then
		local seed = ents.Create( "weed_seed" )
		seed:SetPos(pos + Vector( 0, 0, 10 ))
        seed.owner = self.owner
		seed:Spawn()
		seed.dealer = ply:GetRPVar( "rpname" )
		seed.quality = math.Clamp( math.Round( math.Rand( self.quality + DRUGDEALER.CONFIG.DefaultMinQuality, (self.quality + DRUGDEALER.CONFIG.DefaultMaxQuality) + quality_increase ) ), 0, 100 )
		seed.canuse = false
		seed.dt.owning_ent = self.dt.owning_ent
		local phys = seed:GetPhysicsObject()
		phys:SetVelocity( Vector( math.Rand(-25, 25), math.Rand(-25, 25), 50) )
		seed:Activate()
		timer.Simple(1, function() seed.canuse = true end)
	end
	
	local weed = ents.Create( "drug_weed" )
	weed:SetPos(pos + Vector( 0, 0, 10 ))
	weed:Spawn()
	weed.canuse = false
	weed.owner = ply
	weed.gramm = self.gramm
	weed.quality = self.quality
	local phys = weed:GetPhysicsObject()
	phys:SetVelocity( Vector( math.Rand(-25, 25), math.Rand(-25, 25), 50) )
	weed:Activate()
	timer.Simple(3, function() weed.canuse = true end)
	
	self.canuse = false
    self.pickup = true
    self.plant:Remove()

	--self:Remove()
    self.done = false
    self.gotseed = false
    self.locked = false
end

function ENT:OnTakeDamage( info )    
    if self.HP == nil then 
		self.HP = self:GetPhysicsObject():GetMass() or 100
		self.pmaxhealth = self:GetPhysicsObject():GetMass() or 100
	end
    
    info:ScaleDamage( 0.5 )
    self.HP = self.HP - info:GetDamage()
    
    if self.HP < 1 then self:Remove() end
   
    return info
end
