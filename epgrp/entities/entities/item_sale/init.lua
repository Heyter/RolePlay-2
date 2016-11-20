AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "OpenItemPurchaseMenu" )

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()

    self.damage = self.damage or 250
    
    // Dont touch!
    self.locked = true
    self.sold = false
    self.owner = self.owner or nil
    self.itemclass = self.itemclass or "base_item"
    --if self:GetRPVar( "price" ) == nil then self:SetRPVar( "price", 0 ) end
    // End
end

function ENT:OnRemove()
	if !(self.sold) && IsValid( self.owner ) then
		self.owner:AddInvItem( self.itemclass, 1 )
        self:Remove()
	end
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end

function ENT:Use(activator,caller)
	local ply = activator
    
    ply.lastuse = ply.lastuse or CurTime()
    if ply.lastuse > CurTime() then return end
    
    if ply:SteamID() == self.owner then
        ply.lastuse = CurTime() + 1
        local item = itemstore.Item( self.itemclass )
		
		self.data = self.data or nil
		if self.data != nil then				// Parameter übernehmen
			for k, v in pairs( self.data ) do
				self[k] = v
			end
			PrintTable( self.data )
		end
		
        item:Run( "CanPickup", ply, self )
        item:Run( "SaveData", self )
		item:Run( "Pickup", ply, self )
       -- item:SetData( "Amount", -1 )
        ply.Inventory:AddItem( item )
        self.sold = true
        self:Remove()
        return
    end
    
	if IsValid( ply ) then
        net.Start( "OpenItemPurchaseMenu" )
            net.WriteEntity( self )
        net.Send( ply )
        ply.lastuse = CurTime() + 1
	end
end

function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(5)
	util.Effect("Explosion", effectdata)
	
	local fents = ents.FindInSphere( self:GetPos(), self.dierange ) 
	
	for k, v in pairs(fents) do
		if IsValid( v ) then
			v:Ignite( 120 )
		end
	end
	
	self:Remove()
	self.stove:Remove()
	
	self.dt.owning_ent.plantedmeth = math.Clamp( self.dt.owning_ent.plantedmeth - 1, 0, self.maxmeth )
	
	for k, v in pairs(player.GetAll()) do // Kill all players they're near 300 units of the meth!
		if v:GetPos():Distance(self:GetPos()) <= self.dierange then
			v:Kill()
		end
	end
end

function ENT:Think()
    return false
end