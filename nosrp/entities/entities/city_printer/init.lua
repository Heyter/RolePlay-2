-- RRPX Money Printer reworked for DarkRP by philxyz
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local PrintMore
function ENT:Initialize()
	self:SetModel("models/props/cs_assault/MoneyPallet.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.sparking = false
	self.IsMoneyPrinter = true
	self.prints = 15
	self.PlayerAddAmount = 15
	timer.Simple(math.random(200, 300), function() PrintMore(self) end)
	timer.Simple(2, function() self:GetPhysicsObject():SetMass(150) end)
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

PrintMore = function(ent)
	if ent:IsValid() then
		ent.sparking = true
		
		timer.Simple(3, function() ent.CreateMoneybag(ent) end)
	end
end

function ENT:CreateMoneybag()
	if not self:IsValid() then return end
	if self:IsOnFire() then return end
	local MoneyPos = self:GetPos()
	
	local amount-- = GetConVarNumber("mprintamount")
	amount = 100
	
	local CashBag = ents.Create("city_cashbag")
	CashBag:SetPos(Vector(MoneyPos.x + 50, MoneyPos.y, MoneyPos.z + 30))
	CashBag.CashValue = amount +(self.PlayerAddAmount * #player.GetAll())
	CashBag:Spawn()

	self.sparking = false
	
	timer.Simple(math.random(250, 350), function() PrintMore(self) end)
	
	self.prints = self.prints - 1
	if self.prints < 1 then self:Remove() end
	
	local getmayorcount = team.GetPlayers(TEAM_MAYOR)
	local mcount = 0
	for k,v in pairs(getmayorcount) do
		mcount = mcount + 1
	end
	if mcount == 0 then
		self:Remove()
	end
end

function ENT:Think()
	if not self.sparking then return end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
end
