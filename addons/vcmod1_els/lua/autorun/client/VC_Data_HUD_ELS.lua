// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

local AnimCT = 500 if !VC_DrawFT then VC_DrawFT = {} end

VC_DrawFT["ELS_Siren"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl)
	local Lrp = Lrp VC_DrawFT["Lerp"](SrnTbl and SrnTbl.Sounds and table.Count(SrnTbl.Sounds) > 0 and Veh == GVeh, Lrp, FTm, (0.02+Lrp/AnimCT), (0.01+Lrp/AnimCT))
	local MainSz = 32

	if VC_Anim_Lerp[Lrp] then
	local Rat_L = VC_Anim_Lerp[Lrp]*2 if Rat_L > 1 then Rat_L = 1 end local Rat_B = VC_Anim_Lerp[Lrp]*3 if Rat_B > 1 then Rat_B = 1 end local Rat_T = VC_Anim_Lerp[Lrp]*2-1 if Rat_T < 0 then Rat_T = 0 end
	draw.RoundedBox(4, ScrW()-150+CARot[1]-20, Sart_Height+CARot[2], 180-CARot[1], MainSz, Color(0, 0, 0, 225*Rat_B))

	local Sel = GVeh and GVeh:GetNWInt("VC_ELS_Snd_Sel")
	draw.SimpleText("Siren", "VC_Regular2", ScrW()-160+CARot[1], Sart_Height+22+CARot[2], Color(255, 255,255,255*Rat_T), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	local Mnl = GVeh and GVeh:GetNWBool("VC_ELS_ManualOn") local Off = GVeh and GVeh:GetNWBool("VC_ELS_S_Disabled") local Txt = "off" local Clr = Color(255,255,255,255*Rat_T)
	if (Mnl or Sel and Sel > 0) and !Off and GVeh and GVeh:GetNWBool("VC_HornOn") and GVeh:GetNWBool("VC_Siren_BullHorn") then Txt = "Bull Horn" Clr = Color(120,205,255,255*Rat_T)
	elseif Mnl then Txt = "Manual" Clr = Color(255,200,0,255*Rat_T)
	elseif Off then Txt = Sel and Sel > 0 and (SrnTbl and SrnTbl.Sounds and SrnTbl.Sounds[Sel].Name or "Unknown") or "Off" Clr = Color(255,100,100,255*Rat_T)
	elseif Sel and Sel > 0 then Txt = SrnTbl and SrnTbl.Sounds and SrnTbl.Sounds[Sel].Name or "Unknown" Clr = Color(100,255,55,255*Rat_T)
	end

	draw.SimpleText(string.upper(Txt), "VC_HUD_Bisgs", ScrW()-25+CARot[1], Sart_Height+22+CARot[2], Clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	Clr.a=255 draw.RoundedBox(0, ScrW()-165*Rat_L+CARot[1], Sart_Height+24+CARot[2], 170-CARot[1], 2, Clr)
	end
	if VC_Anim_Lerp[Lrp] then Sart_Height=Sart_Height+MainSz+2 end return Sart_Height
end


local LhtCL = {
[0] = {"Off"},
{"Code 1"},
{"Code 2"},
{"Code 3"},
{"Code 4"},
{"Code 5"},
{"Caution"},
{"High Prior"},
{"Escort"},
{"Pull Over"},
{"Dir Left"},
{"Dir L/R"},
{"Dir Right"},
{"Stable"},
{"Illuminate"},
}

local SectionNames = {"Front Bumper", "Front Window", "Light Bar", "Light Bar 2", "Rear Window", "Rear Bumper"}
VC_DrawFT["ELS_Lights"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl)
	local Lrp = Lrp VC_DrawFT["Lerp"](SrnTbl and SrnTbl.Sequences and GVeh and Veh == GVeh, Lrp, FTm, (0.02+Lrp/AnimCT), (0.01+Lrp/AnimCT))
	local MainSz = 32

	if VC_Anim_Lerp[Lrp] then
	if SrnTbl and SrnTbl.Sections then MainSz=MainSz+20*table.Count(SrnTbl.Sections) end

	local Rat_L = VC_Anim_Lerp[Lrp]*2 if Rat_L > 1 then Rat_L = 1 end local Rat_B = VC_Anim_Lerp[Lrp]*3 if Rat_B > 1 then Rat_B = 1 end local Rat_T = VC_Anim_Lerp[Lrp]*2-1 if Rat_T < 0 then Rat_T = 0 end
	draw.RoundedBox(4, ScrW()-150+CARot[1]-20, Sart_Height+CARot[2], 180-CARot[1], MainSz, Color(0, 0, 0, 225*Rat_B))
	draw.SimpleText("ELS", "VC_Regular2", ScrW()-160+CARot[1], Sart_Height+22+CARot[2], Color(255, 255,255,255*Rat_T), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	local Lht = GVeh and LhtCL[GVeh:GetNWInt("VC_ELS_Lht_Sel")][1] or "Off" local Off = GVeh and GVeh:GetNWBool("VC_ELS_L_Disabled") local Txt = "off" local Clr = Color(255,255,255,255*Rat_T) if Off then Clr = Color(255,100,100,255*Rat_T) elseif Lht != "Off" then Clr = Color(100,255,55,255*Rat_T) end

	draw.SimpleText(string.upper(Lht), "VC_HUD_Bisgs", ScrW()-25+CARot[1], Sart_Height+22+CARot[2], Clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	Clr.a = 255 draw.RoundedBox(0, ScrW()-165*Rat_L+CARot[1], Sart_Height+24+CARot[2], 170-CARot[1], 2, Clr)

		if SrnTbl and SrnTbl.Sections and Veh.VC_LastRenderedL then
		local int = 0
			for k,v in SortedPairs(SrnTbl.Sections) do
			draw.SimpleText("ELS", "VC_Regular2", ScrW()-160+CARot[1], Sart_Height+22+CARot[2], Color(255, 255,255,255*Rat_T), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			local Am = table.Count(v)
			draw.SimpleText(SectionNames[k], "VC_Regular_S", ScrW()-160+CARot[1], Sart_Height+36+5+20*int+CARot[2], Color(255, 255,255,120*Rat_T), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				for i=1,Am do
				local Sel = nil for k2,v2 in pairs(v[i]) do
				if Veh.VC_LastRenderedL[k2] then Sel = true break end end
				local Size = 160/Am draw.RoundedBox(0, ScrW()-165*Rat_L+CARot[1]+(Size*(i-1)), Sart_Height+36+5+20*int+CARot[2], Size-3, 4, Sel and Color(100,255,55,255*Rat_T) or Color(255,255,255,20*Rat_T))
				end
			int = int+1
			end
		end
	end
	if VC_Anim_Lerp[Lrp] then Sart_Height=Sart_Height+MainSz+2 end return Sart_Height
end

local VC_ELS_LastRanSeqL = {}

function VC_Handle_Siren_Sequence(ent, ltable, SeqTbl, distnum, PRenL)
-- ent.VC_ELS_Lht_Sel = 1
	if ltable.Sequences then
		if !ent.VC_BG_NotAllowedTbl then ent.VC_BG_NotAllowedTbl = {} end
		local LhtRanTbl = {}
			if ltable.InterSec and PRenL then
				for k,v in pairs(ltable.InterSec) do
				local Done = {} local Vis = nil local P1,P2,MP,Sz,Clr,Am = v.Pos1 or Vector(0,0,0), v.Pos2 or Vector(0,0,0), ent:LocalToWorld(v.MPos or Vector(0,0,0)), v.SzM or 1, v.UseClr and v.Color, v.Am or 10
				if v.Lights then for k2,v2 in pairs(v.Lights) do if PRenL[k2] and !Done[v2[1]] then Vis = VC_Render_Interior_Light(ent, Vis, v2, ent:LocalToWorld(LerpVector((v2[1]-1)/(Am-1), P1, P2)), MP, Sz, Clr or PRenL[k2]) Done[v2[1]] = true end end end
				end
			end

		VC_ELS_LastRanSeqL = {}
		for Seqk, Seqv in pairs(ltable.Sequences) do
			if !Seqv.VC_BG_Check_T or CurTime() >= Seqv.VC_BG_Check_T then
				ent.VC_BG_NotAllowedTbl[Seqk] = false
				if Seqv.BGroups then ent.VC_BG_NotAllowedTbl[Seqk] = true for k,v in pairs(Seqv.BGroups) do local BGrp = ent:GetBodygroup(k) if BGrp and v[BGrp] then ent.VC_BG_NotAllowedTbl[Seqk] = false break end end end
				if Seqv.BGroups_B then ent.VC_BG_NotAllowedTbl[Seqk] = false for k,v in pairs(Seqv.BGroups_B) do local BGrp = ent:GetBodygroup(k) if BGrp and !v[BGrp] then ent.VC_BG_NotAllowedTbl[Seqk] = true break end end end
			end
			if !ent.VC_BG_NotAllowedTbl[Seqk] and Seqv.SubSeq and ent.VC_ELS_Lht_Sel and ent.VC_ELS_Lht_Sel != 0 then
			local CdOv, SpM, SpStg, SzO, SSeqO, SeqO, MnlC = ent.VC_ELS_Lht_Sel, nil, nil, nil, nil, nil, ent.VC_ELS_Lht_Sel > 12
				if ltable.Codes and ltable.Codes[CdOv] and !MnlC then
				local Ovr = ltable.Codes[CdOv].OvrC if ltable.Codes[CdOv].Ovr and Ovr then CdOv = Ovr end
				local SpdM = ltable.Codes[ent.VC_ELS_Lht_Sel].Spd_Sub_M if ltable.Codes[ent.VC_ELS_Lht_Sel].Spd_Sub and SpdM then SpM = SpdM end
				local SpdS = ltable.Codes[ent.VC_ELS_Lht_Sel].Spd_Stg_M if ltable.Codes[ent.VC_ELS_Lht_Sel].Spd_Stg and SpdS then SpStg = SpdS end
				local Sz = ltable.Codes[ent.VC_ELS_Lht_Sel].SzM if ltable.Codes[ent.VC_ELS_Lht_Sel].Sz and Sz then SzO = Sz end
				local SO = ltable.Codes[ent.VC_ELS_Lht_Sel].SSeq_Ovr_SSeq if ltable.Codes[ent.VC_ELS_Lht_Sel].SSeq_Ovr and SO then SSeqO = SO end
				local SO = ltable.Codes[ent.VC_ELS_Lht_Sel].Seq_Ovr_Seq if ltable.Codes[ent.VC_ELS_Lht_Sel].Seq_Ovr and SO then SeqO = SO end
				end
				if (!SeqO or SeqO == Seqk) and (ent.VC_ELS_Lht_Sel_NCodes or Seqv.Codes and Seqv.Codes[CdOv] or MnlC) then
					if ent.VC_ELS_Lht_Sel == 14 then
					for k, v in pairs(VC_Global_Data[ent.VC_Model].LightTable.Siren) do local CTbl = v.SirenColor if !LhtRanTbl[k] and CTbl[1] > 199 and CTbl[2] > 199 and CTbl[3] > 199 then LhtRanTbl[k] = true VC_Handle_Light_Draw_Single(ent, k,v, "SirenColor", 1, nil, distnum, 2, 2) end end
					elseif ent.VC_ELS_Lht_Sel == 13 then
					for k, v in pairs(VC_Global_Data[ent.VC_Model].LightTable.Siren) do local CTbl = v.SirenColor if !LhtRanTbl[k] and (!(ltable.Codes and ltable.Codes[13] and ltable.Codes[13].Exclude_White) or CTbl[1] < 199 or CTbl[2] < 199 or CTbl[3] < 199) then LhtRanTbl[k] = true VC_Handle_Light_Draw_Single(ent, k,v, "SirenColor", 1, nil, distnum) end end
					else
						if !SeqTbl[Seqk] then SeqTbl[Seqk] = {} end
						local Sequence = SeqTbl[Seqk]
							if SSeqO then
							Sequence.SubSeqSel = SSeqO
							else
								if !Sequence.SubSeqSelectTime or CurTime() >= Sequence.SubSeqSelectTime then
								local SSAmount, NxTm, NxSg = #Seqv.SubSeq, nil, nil
									if SSAmount > 0 then
										if SSAmount > 1 then
										NxSg = (Sequence.SubSeqSel or 0)+1 if NxSg > SSAmount then NxSg = 1 end
										NxTm = Seqv.SubSeq[NxSg].Time or 1 if SpM then NxTm=NxTm/SpM end
										else
										NxSg = 1 NxTm = 10
										end
									end

									if Sequence.SubSeqSel != NxSg then
									Sequence.StageSelectTime = nil Sequence.StageSel = nil
									Sequence.SubSeqSel = NxSg
									else
									NxTm = 10
									end
								Sequence.SubSeqSelectTime = CurTime()+ NxTm
								end
							end

							if Sequence.SubSeqSel and Seqv.SubSeq[Sequence.SubSeqSel] then
								if !Sequence.StageSelectTime or CurTime() >= Sequence.StageSelectTime then
									if Seqv.SubSeq[Sequence.SubSeqSel].Stages then
									local SStageAmount, NxTm, NxSSg = #Seqv.SubSeq[Sequence.SubSeqSel].Stages, nil, nil
										if SStageAmount > 0 then
											if SStageAmount > 1 then
											NxSSg = (Sequence.StageSel or 0)+1
											if NxSSg > SStageAmount then NxSSg = 1 end
											NxTm = Seqv.SubSeq[Sequence.SubSeqSel].Stages[NxSSg].Time or 0.5 if SpStg then NxTm=NxTm/SpStg end
											else
											NxSSg = 1 NxTm = 10
											end
										end
									if Sequence.StageSel != NxSSg then Sequence.StageSel = NxSSg end
									Sequence.StageSelectTime = CurTime()+ NxTm
									end
								end
							end
						if ltable.Sequences[Seqk] and Sequence.SubSeqSel and
						Sequence.StageSel and ltable.Sequences[Seqk].SubSeq[Sequence.SubSeqSel] and ltable.Sequences[Seqk].SubSeq[Sequence.SubSeqSel].Stages[Sequence.StageSel] and ltable.Sequences[Seqk].SubSeq[Sequence.SubSeqSel].Stages[Sequence.StageSel].Lights then							
							local AlDLTbl = {}
							VC_ELS_LastRanSeqL[Seqk] = true
							for _, Lht in pairs(ltable.Sequences[Seqk].SubSeq[Sequence.SubSeqSel].Stages[Sequence.StageSel].Lights) do
							VC_Handle_Light_Draw_Single(ent, Lht, VC_Global_Data[ent.VC_Model].LightTable.Siren[Lht], "SirenColor", 1, nil, distnum, SzO,SzO)
							end
						end
					end
				end
			end
		end
	ent.VC_BG_Check_T = CurTime()+2
	end
end

function VC_Handle_Light_ELS_Draw(ent, LhtTbl, PRenL)
	if ent:GetNWBool("VC_DrawSirenLights") then if !ent.VC_SirenTable and LhtTbl.Siren then ent.VC_SirenTable = {} end VC_Handle_Siren_Sequence(ent, VC_Global_Data[ent.VC_Model].Siren, ent.VC_SirenTable, ent.VC_Lht_DstCheckMult, PRenL) end
	if VC_Global_Data[ent.VC_Model].Siren.InterBtn then
	local SndInit = nil
		for k,v in pairs(VC_Global_Data[ent.VC_Model].Siren.InterBtn) do
		local function Rndr(Pos) VC_Render_Interior_Light(ent, nil, v, Pos, Pos, v.SzM or 1, v.UseClr and v.Color or {55,255,0}) end
			if v.Sel then
			local Pos = ent:LocalToWorld(v.Pos or Vector(0,0,0))
				if v.Sel[1] == "Codes" and ent.VC_ELS_Lht_Sel and ent.VC_ELS_Lht_Sel == v.Sel[2] or v.Sel[1] == "Sequences" and VC_ELS_LastRanSeqL[v.Sel[2]] then Rndr(Pos)
				else
				if !SndInit then SndInit = {ent:GetNWInt("VC_ELS_Snd_Sel"), ent:GetNWBool("VC_ELS_ManualOn"), ent:GetNWBool("VC_ELS_S_Disabled"), ent:GetNWBool("VC_HornOn"), ent:GetNWBool("VC_Siren_BullHorn")} end
				if v.Sel[1] == "Manual" and SndInit[2] or v.Sel[1] == "Horn" and SndInit[4] and SndInit[5] or v.Sel[1] == "Sounds" and !SndInit[3] and SndInit[1] and SndInit[1] == v.Sel[2] then Rndr(Pos) end
				if v.Sel[1] == "Radio" and VC_ELS_Chatter_Sound then Rndr(Pos) end
				if v.Sel[1] == "ELS_Active" and ent.VC_ELS_Lht_Sel and ent.VC_ELS_Lht_Sel != 0 and !ent:GetNWBool("VC_ELS_L_Disabled") then Rndr(Pos) end
				end
			end
		end
	end
end