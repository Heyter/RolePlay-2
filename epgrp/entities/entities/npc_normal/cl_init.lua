include("shared.lua");
surface.CreateFont("npc_name", 
{
    font = "coolvetica",
    size = 24,
    weight = 400,
    antialias = true
})

function ENT:Initialize ( ) 
    self:InitializeAnimation()
    self.NextChangeAngle = CurTime();
    self.angy = 0
    hook.Add("PostDrawTranslucentRenderables","DrawNPCNames" .. self:EntIndex(),function()
        
        local name = self:GetNWString("name")
        surface.SetFont( "npc_name" )
        local width, height = surface.GetTextSize( name )

        self.pos = self:GetPos() + Vector(0,0,90)
        cam.Start3D2D( self.pos, Angle( 0, self.angy, 90 ), 0.15 )
            surface.SetDrawColor(0,0,0,100)
            surface.DrawRect(-width/2 - 5,0,width + 5, height + 5)
            draw.SimpleText( name, "npc_name", -width/2, 0, Color( 0, 255, 255, 255 ) )
        cam.End3D2D()

        cam.Start3D2D( self.pos, Angle( 0, self.angy  + 180, 90 ), 0.15 )
            draw.SimpleText( name, "npc_name", -width/2, 0, Color( 0, 255, 255, 255 ) )
        cam.End3D2D()

    end)
end

function ENT:Think()
    if (self.NextChangeAngle <= CurTime()) then
        self.angy = self.angy + 0.25
        self.NextChangeAngle = self.NextChangeAngle + (1 / 60)
    end
end