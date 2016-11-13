AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
 
include("shared.lua");

function ENT:Initialize ( )
    self:SetSolid(SOLID_BBOX);
    self:PhysicsInit(SOLID_BBOX);
    self:SetMoveType(MOVETYPE_STEP);
    self:DrawShadow(true);
    self:SetUseType(SIMPLE_USE);
end

function ENT:Use(activator,caller)
    OnNPCUse(caller,self.NPCId)
end

function ENT:SetDisplayName(name)
    -- debug
    print("SetName" .. name)
    self:SetNetworkedString("name",name)
end
