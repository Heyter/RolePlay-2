include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
    
    local Mat = Matrix()
    Mat:Scale(Vector(.1, 1, 1))
    self:EnableMatrix("RenderMultiply",Mat)
    
    cam.Start3D2D( self:GetPos(), Angle( 0, 0, 90 ), 1 ) 
        draw.RoundedBox( 0, 0, 0, 100, 100, Color( 255, 255, 255, 0 ) )
    cam.End3D2D()
end

function ENT:Think()
end