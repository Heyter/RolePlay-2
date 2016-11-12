ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Npc Point"
ENT.Author = "Xt4zzi"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

RESTRICT = {
    disallowed = {
	    TEAM_POLICE,
		TEAM_CHIEF,
	}
}	

function ENT:InitializeAnimation ( animID )
        if animID != -1 then
            if (animID == ACT_HL2MP_IDLE) then
                self:ResetSequence(self:SelectWeightedSequence( animID ) );
            else    
                self:ResetSequence(animID);
				timer.Simple( 3, function() self:SetSequence( animID ) end )
            end
        end
    self.AutomaticFrameAdvance = true;
end