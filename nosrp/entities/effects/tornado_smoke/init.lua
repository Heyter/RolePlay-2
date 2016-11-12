

function EFFECT:Init(data)
	
	local pos = data:GetOrigin();
	local norm = data:GetNormal();
	local em = ParticleEmitter(pos);
	
	local color_id = math.Rand(0,4)
	
	for i=1, 5 do
		local smoke = em:Add( "particle/particle_smokegrenade", pos+norm )
		smoke:SetVelocity(VectorRand( 0, 0, 10))
		smoke:SetGravity(Vector(math.sin(CurTime())*60, math.cos(CurTime())*60, 100))
		smoke:SetLifeTime( 0 )
		smoke:SetDieTime(100)
		smoke:SetStartAlpha(math.Rand(245, 255))
		smoke:SetEndAlpha(0)
		smoke:SetStartSize(80)
		smoke:SetEndSize(150)
		smoke:SetRoll(math.Rand(-180, 180))
		smoke:SetRollDelta(math.Rand(-0.2,0.2))
		smoke:SetColor(50,50, 50)
		smoke:SetAirResistance(250)
		smoke:SetLighting( false )
		smoke:SetCollide( true )
		smoke:SetBounce( 0.5 )
	end
end

function EFFECT:Think() return false end; -- Make it die instantly
function EFFECT:Render() end
