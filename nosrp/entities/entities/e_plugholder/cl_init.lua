include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
    
    local matLight = Material( "sprites/light_ignorez" )
    render.SetMaterial( matLight )
    
    self.PixVis = util.GetPixelVisibleHandle()
    
    local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
    
    local d = 100
    local r = (255 / d) * math.Clamp( Distance, 0, d )
    
    local pos = Vector( 4, 0, 1.3 )
    
    if self.dt.plugged == 1 then
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 0, 255, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 0, 255, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 0, 255, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 0, 255, 0, 255 - r ) )
    else
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 255, 0, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 255, 0, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 255, 0, 0, 255 - r ) )
        render.DrawSprite( self.Entity:LocalToWorld( pos ), 2, 2, Color( 255, 0, 0, 255 - r ) )
    end
end

function ENT:Think()
end