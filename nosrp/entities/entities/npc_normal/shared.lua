--[[---------------------------------------------------------
   entity: npc_normal
   Desc: Represents a NPC
-----------------------------------------------------------]]

ENT.Type                = "anim";
ENT.Base                = "base_anim";
ENT.PrintName           = "NPC";
ENT.Author              = "Johnny & Sapd";
ENT.Purpose             = "";

ENT.Spawnable           = false;
ENT.AdminSpawnable      = false;

function ENT:OnRemove ( )

end

function ENT:InitializeAnimation ( animID )
    if SERVER then
        if animID != -1 then
            if (animID == ACT_HL2MP_IDLE) then
                self:ResetSequence(self:SelectWeightedSequence( animID ) );
            else    
                self:ResetSequence(animID);
            end
        end
    end
    self.AutomaticFrameAdvance = true;
end
