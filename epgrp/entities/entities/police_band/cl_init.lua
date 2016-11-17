include("shared.lua")

function ENT:Initialize()
	self.mat = Material( "roleplay/police_band" ) -- Calling Material() every frame is quite expensive
end

function ENT:Draw()
	--self:DrawModel()
	
	local a = self:GetAngles()
	a:RotateAroundAxis( a:Right(), 90 ) 
	a:RotateAroundAxis( a:Forward(), 90 ) 
	
	cam.Start3D2D( self:GetPos(), a, 1 )
		local dist = self:GetNWInt( "wide" )
		
		
		surface.SetDrawColor( Color( 255, 165, 0, 100 ) )
		surface.DrawRect( -2.5, -dist/2, 5, dist )
		
		local calc = math.Round(dist/25)
		--draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", 0, -150, Color( 255, 0, 0, 255), 1, 1 )
		--for i=1, calc do
			--draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", dist/2, 0, Color( 0, 0, 0, 255), 1, 1 )
		--end
	cam.End3D2D()
	
	
	a = self:GetAngles()
	a:RotateAroundAxis( a:Forward(), 90 ) 
	cam.Start3D2D( self:GetPos(), a, .2 )
		local calc = math.Round(dist/25)
		draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", 0, -2, Color( 255, 255, 255, 200), 1, 1 )
		--for i=1, calc do
			--draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", dist/2, 0, Color( 0, 0, 0, 255), 1, 1 )
		--end
	cam.End3D2D()
	
	a = self:GetAngles()
	a:RotateAroundAxis( a:Forward(), -90 ) 
	a:RotateAroundAxis( a:Up(), 180 ) 
	cam.Start3D2D( self:GetPos(), a, .2 )
		local calc = math.Round(dist/25)
		draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", 0, -2, Color( 255, 255, 255, 200), 1, 1 )
		--for i=1, calc do
			--draw.SimpleText( "Polizei - Nicht überschreiten!", "Trebuchet24", dist/2, 0, Color( 0, 0, 0, 255), 1, 1 )
		--end
	cam.End3D2D()
end

function ENT:Think()
end