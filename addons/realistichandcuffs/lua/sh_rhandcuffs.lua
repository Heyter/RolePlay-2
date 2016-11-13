
local PLAYER = FindMetaTable( "Player" )

function PLAYER:IsRHCWhitelisted()
    return table.HasValue(RHC_PoliceJobs, self:Team())
end

hook.Add("canLockpick", "AllowCuffPicking", function(Player, CuffedP, Trace)
	if CuffedP:GetNWBool("rhc_cuffed", false) then
		return true
	end
end)

hook.Add("lockpickTime", "SetupCuffPickTime", function()
	return RHC_CuffPickTime
end)