include('shared.lua')

net.Receive("rhc_sendcuffs", function()
	local Player, Cuffs = net.ReadEntity(), net.ReadEntity()
	
	Cuffs.CuffedPlayer = Player
end)

function ENT:Think ()	
end

function ENT:Draw()
	local owner = self.CuffedPlayer

	if owner == LocalPlayer() then return end	
	if !IsValid(owner) or !owner or !owner:IsPlayer() or !owner:Alive() then return end
	
	local boneindex = owner:LookupBone("ValveBiped.Bip01_R_Hand")
	if boneindex then
		local pos, ang = owner:GetBonePosition(boneindex)
		if pos and pos ~= owner:GetPos() then	

			ang:RotateAroundAxis(ang:Right(),30)
			ang:RotateAroundAxis(ang:Up(),30)
			ang:RotateAroundAxis(ang:Forward(),102)
				
			self:SetModelScale(1.1,0)
				
			self.Entity:SetPos(pos + ang:Right()*0 + ang:Up()*6 + ang:Forward()*0 )			
					
			self.Entity:SetAngles(ang)
		end
    end	
	self.Entity:DrawModel()
end

function ENT:OnRemove( )
end	
