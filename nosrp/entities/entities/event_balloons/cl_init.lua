include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawModel()       -- Draw the model.
 
end

local Alpha = 0

usermessage.Hook("bett_schlafen", function()
	surface.PlaySound("gmn_drp/gmod-Sleep.mp3")
	timer.Create("bett_einschlafen", 0.01, 256, function()
		if Alpha < 255 then
			Alpha = Alpha + 1
		else
			timer.Destroy("bett_einschlafen")
			timer.Create("bett_ruhezeit", 30, 1, function()
				timer.Destroy("bett_ruhezeit")
				timer.Create("bett_aufwachen", 0.01, 256, function()
					if Alpha > 0 then
						Alpha = Alpha - 1
					else
						timer.Destroy("bett_aufwachen")
					end
				end)
			end)
		end
	end)
end)

hook.Add("HUDPaint", "Bett_Schlafen", function()
	draw.RoundedBox ( 0, 0, 0, ScrW(), ScrH(), Color(0,0,0, Alpha) )
end)