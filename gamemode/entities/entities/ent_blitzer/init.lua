AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

resource.AddFile("models/blitzer/blitzer.mdl")
 
function ENT:Initialize()
 
	self:SetModel( "models/blitzer/blitzer.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_NONE )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Damage = 100000
	self.Strafgeld = 10 // Multipliziert so oft wie die Toleranz überstiegen wurde
	self.SpeedLimit = 50 // Maximale Geschwindigkeit ( + 5 Km/h Toleranz )
    --self.removetime = CurTime() + 1800
    timer.Simple( 1800, function() if IsValid( self ) then self:Remove() end end )
    timer.Simple( 2, function()
        self:SetRPVar( "speed_limit", 50 )
        self:SetRPVar( "remove_time", CurTime() + 1798 )
    end)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
		phys:SetMass(9999999999999)
        phys:EnableMotion(false)
	end
end

function ENT:Use( activator, caller )
  if self.Useable == 1 then

  end
end

function ENT:OnTakeDamage(dmg)
   self.Damage = self.Damage - dmg:GetDamage()
  if self.Damage <= 150 then

	self:Ignite(999999)
	self:SetColor(self.Damage, self.Damage, self.Damage, 255)
	self.Useable = 0
	
	local NearbyEnts = ents.FindInSphere(self:GetPos(), math.random(100, 200));
									
		for k, v in pairs(NearbyEnts) do
		if v:IsValid() then
             v:Ignite(360, 50)
			end
	    end
	
   end
   
   if self.Damage <= 0 then
	self:Destruct()
   end
end

function ENT:Destruct()
    timer.Destroy("Destroy Timer")
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	self:Remove()
end
/*
local function GetSpeed( ent )
if not ent:IsValid() then return 0 end
    local vehicleVel = ent:GetVelocity():Length()
    local vehicleConv = -1
    local terminal = 0
               
    terminal = math.Clamp(vehicleVel/2000, 0, 1)
    vehicleConv = math.Round(vehicleVel / 10)
	
	return vehicleConv
end
*/
function ENT:Think()
local cars = ents.FindInSphere(self.Entity:GetPos(), 200)

for k, v in pairs(cars) do
	if v:IsVehicle() and v:GetDriver():IsValid() and not ( v:GetDriver():IsPolice() or v:GetDriver():IsSWAT() ) then
		local speed = v:GetSpeed()
		if speed > self.SpeedLimit and not ( v:GetNWBool("GotBlitzed") ) then
		local toleranz = 5
		local rech = speed - self.SpeedLimit
			if (rech) > toleranz then
			
				local strafgeld = self.Strafgeld * rech
				
				v:GetDriver():EmitSound("nosrp/blitzer.wav", 100, 100)
				self.Entity:EmitSound("nosrp/blitzer.wav", 100, 100)
				
				v:GetDriver():SendLua( "BlitzerFlash()" )
			
				if not ( v:GetDriver():CanAfford(strafgeld) ) then // Wenn er es nicht bezahlen kann!
					v:GetDriver():SetStars( v:GetDriver(), 2, true )
					v:GetDriver():ChatPrint("Du wurdest geblitzt und konntest nicht bezahlen, ab jetzt bist du bei der Polzei gesucht!")
					v:SetNWBool("GotBlitzed", true)
					timer.Create("Blitzed" .. v:GetDriver():UniqueID(), 10, 1, function()
						v:SetNWBool("GotBlitzed", false)
					end)
					return 
				end
				
				v:GetDriver():AddCash(-strafgeld)
				ECONOMY.AddCityCash( strafgeld )
                ECONOMY.AddToLog( "+" .. strafgeld .. ",-EUR | " .. (v:GetDriver():GetRPVar( "rpname" ) or v:GetDriver():Nick()) .. " wurde geblitzt! ( " .. speed .. " Km/h | Limit: " .. self.SpeedLimit .. " Km/h )" )
				v:GetDriver():ChatPrint("Du bist zu schnell gefahren und wurdest geblitzt! Du musst: $" .. strafgeld .. " bezahlen!")
				v:GetDriver():ChatPrint("Zugelassene Geschwindigkeit: " .. self.SpeedLimit .. " Km/h | Deine Geschwindigkeit: " .. speed .. " Km/h")
				v:SetNWBool("GotBlitzed", true)
				timer.Create("Blitzed" .. v:GetDriver():UniqueID(), 10, 1, function()
					v:SetNWBool("GotBlitzed", false)
				end)
			end
		end
	end
end

end

function SetSpeedLimit( ply, args )
	if  not tonumber(args[1]) then return "" end
	local trace = {}

	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	
	if tr.Entity:IsValid() and tr.Entity:GetClass() == "ent_blitzer" and ( GetMayor() == ply or ply:IsAdmin() ) then
	if tonumber(args[1]) < 30 then ply:RPNotify("Du kannst minimal 30 Km/h einstellen!", 5) return "" end
	
		tr.Entity.SpeedLimit = tonumber(args[1])
        tr.Entity:SetRPVar( "speed_limit", args[1] )
		ply:RPNotify("Die Geschwindigkeits-begrenzung wurde erfolgreich auf -> " .. args[1] .. " Km/h gestellt!", 5)
	end
	return ""
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/speedlimit", SetSpeedLimit )