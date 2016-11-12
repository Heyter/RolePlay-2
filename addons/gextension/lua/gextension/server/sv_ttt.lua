//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

--Spectator Prop
local propspec_retime = CreateConVar("ttt_spec_prop_rechargetime", "1")

function GExtension:TTT_PROPSPEC_Recharge(ply)
	if IsValid(ply) then
		local pr = ply.propspec

	    if table.HasValue(self.SpecPropPlayers, ply:SteamID64()) then
			if pr.retime < CurTime() then
				pr.punches = math.min(pr.punches + 1, pr.max)
				ply:SetNWFloat("specpunches", pr.punches / pr.max)

				pr.retime = CurTime() + 0.1
			end
		else
			if pr.retime < CurTime() then
				pr.punches = math.min(pr.punches + 1, pr.max)
				ply:SetNWFloat("specpunches", pr.punches / pr.max)

				pr.retime = CurTime() + propspec_retime:GetFloat()
			end
		end
	end
end

hook.Add("GExtensionInitialized", "GExtension_TTT_GExtensionInitialized", function()
	if GAMEMODE_NAME == "terrortown" and PROPSPEC then
		PROPSPEC.Recharge = function(ply)
			GExtension:TTT_PROPSPEC_Recharge(ply)
		end
	end
end)