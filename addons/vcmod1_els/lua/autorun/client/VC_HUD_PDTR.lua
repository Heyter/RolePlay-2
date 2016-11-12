// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

local UsedMat = Material("sprites/light_ignorez") local UsedMat_HD = Material("vcmod/lights/hd") local UsedMat_Glow = Material("vcmod/lights/glow")

function VC_Lerp_Points(int, Tbl) for k,v in pairs(Tbl) do local NDP = Tbl[k+1] if NDP and NDP[2] >= int then return LerpVector((NDP[2]-int)/(NDP[2]-v[2]), NDP[1], v[1]) end end end

local function Bazzier(var, p1, p2, p3)
return ((1-var)^2)*p1+2*(1-var)*(var)*p2+(var^2)*p3
end

function VC_Handle_Light_Init(Lhv, IsELS, col, SPos, Size)
	if IsELS and Lhv[col][2] == 55 then if Lhv[col][1] == 255 and Lhv[col][3] == 0 then Lhv[col] = {255,0,0} elseif Lhv[col][1] == 0 and Lhv[col][3] == 255 then Lhv[col] = {0,0,255} end end
	Lhv.SpecTable = nil local STSz = 0
		if Lhv.SpecLine and Lhv.SpecLine.Use then
		if !Lhv.SpecTable then Lhv.SpecTable = {} end
		if Lhv.SpecLine.Amount and Lhv.SpecLine.Amount > 1 then local Am = Lhv.SpecLine.Amount-2 for i=1,Am do Lhv.SpecTable[i] = LerpVector(i/(Am+1), SPos, Lhv.SpecLine.Pos or Vector(0,0,0)) end STSz=STSz+Am end
		local Cnt = table.Count(Lhv.SpecTable) Lhv.SpecTable[Cnt+1] = Lhv.Pos or Vector(0,0,0) Lhv.SpecTable[Cnt+2] = Lhv.SpecLine.Pos or Vector(0,0,0)
		end

		if Lhv.SpecMLine and Lhv.SpecMLine.Use and Lhv.SpecMLine.LTbl then
		if !Lhv.SpecTable then Lhv.SpecTable = {Lhv.Pos} end
		local PT = {Lhv.Pos} local TotalDist = 0 local DistT = {{Lhv.Pos, 0}}
			if Lhv.SpecMLine.Amount and Lhv.SpecMLine.Amount > 0 then
			for k,v in pairs(Lhv.SpecMLine.LTbl) do PT[k+1] = v.Pos end STSz=STSz+Lhv.SpecMLine.Amount
			for k,v in pairs(PT) do if PT[k+1] then local TD = v:Distance(PT[k+1]) TotalDist=TotalDist+TD DistT[k+1] = {PT[k+1], TotalDist} else break end end
			for i=1,Lhv.SpecMLine.Amount do Lhv.SpecTable[i+1] = VC_Lerp_Points(TotalDist*(i/Lhv.SpecMLine.Amount), DistT) end
			else
			local LPos = SPos for k,v in pairs(Lhv.SpecMLine.LTbl) do local Cnt = table.Count(Lhv.SpecTable) local Am = (v.Amount or 2)-2 for i=1,Am do Lhv.SpecTable[Cnt+i] = LerpVector(i/(Am+1), LPos, v.Pos or Vector(0,0,0)) end Lhv.SpecTable[table.Count(Lhv.SpecTable)+1] = v.Pos PT[k+1] = v.Pos STSz=STSz+Am LPos = v.Pos end
			end
		end

		if Lhv.SpecCircle and Lhv.SpecCircle.Use then
		if !Lhv.SpecTable then Lhv.SpecTable = {} end
		local Am, SAm = Lhv.SpecCircle.Amount or 3, table.Count(Lhv.SpecTable) for i=1,Am do local TVec = Vector(Lhv.SpecCircle.Radius or 1,0,0) TVec:Rotate(Angle(i/Am*360, 0, 0)) Lhv.SpecTable[SAm+i] = SPos+TVec end STSz=STSz+Am
		end

		if Lhv.SpecRec and Lhv.SpecRec.Use then
		if !Lhv.SpecTable then Lhv.SpecTable = {} end local SAm = table.Count(Lhv.SpecTable)
		local Pos1, Pos2, Pos3, Pos4, AmH, AmV = Lhv.SpecRec.Pos1, Lhv.SpecRec.Pos2, Lhv.SpecRec.Pos3, Lhv.SpecRec.Pos4, (Lhv.SpecRec.AmountH or 2)-2, (Lhv.SpecRec.AmountV or 2)-2
		Lhv.SpecTable[SAm+1] = Lhv.SpecRec.Pos1 Lhv.SpecTable[SAm+2] = Lhv.SpecRec.Pos2 Lhv.SpecTable[SAm+3] = Lhv.SpecRec.Pos3 Lhv.SpecTable[SAm+4] = Lhv.SpecRec.Pos4
		SAm = table.Count(Lhv.SpecTable) for i=1, AmH do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmH+1), Pos1, Pos2) end STSz=STSz+AmH
		SAm = table.Count(Lhv.SpecTable) for i=1, AmV do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmV+1), Pos2, Pos3) end STSz=STSz+AmV
		SAm = table.Count(Lhv.SpecTable) for i=1, AmH do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmH+1), Pos3, Pos4) end STSz=STSz+AmH
		SAm = table.Count(Lhv.SpecTable) for i=1, AmV do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmV+1), Pos4, Pos1) end STSz=STSz+AmV
		if Lhv.SpecRec.Mid then SAm = table.Count(Lhv.SpecTable) for i=1, AmH do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmH+1), (Pos1+Pos4)/2, (Pos2+Pos3)/2) end end
		if Lhv.SpecRec.Mid_V then SAm = table.Count(Lhv.SpecTable) for i=1, AmV do Lhv.SpecTable[SAm+i] = LerpVector(i/(AmV+1), (Pos1+Pos2)/2, (Pos3+Pos4)/2) end end
		end

		if Lhv.Spec3D and Lhv.Spec3D.Use and Lhv.Spec3D.Mat and Lhv.Spec3D.Mat != "" then
		Lhv.Data_3D = {Pos1 = Lhv.Spec3D.Pos1, Pos2 = Lhv.Spec3D.Pos2, Pos3 = Lhv.Spec3D.Pos3, Pos4 = Lhv.Spec3D.Pos4, Mat = Material(Lhv.Spec3D.Mat), Color = Lhv.Spec3D.UseColor and Lhv.Spec3D.Color}
		end

	Lhv.Srn_CenterSz = (STSz*6+Size*3.5)/2

	local CTbl = Lhv[col] if CTbl[1] > CTbl[2] and CTbl[1] > CTbl[3] then Lhv.midColor = {255,200,0} elseif CTbl[2] > CTbl[1] and CTbl[2] > CTbl[3] then Lhv.midColor = {255,255,255} elseif CTbl[3] > CTbl[1] and CTbl[3] > CTbl[2] then Lhv.midColor = {0,200,255} else Lhv.midColor = CTbl end
end

function VC_Handle_Light_Draw_Single(ent, Lhk, Lhv, col, colid, sideid, distnum, sizem, sizemd)
	if !ent.VC_DamagedLights or !ent.VC_DamagedLights[Lhk] then
	local SPos = Lhv.Pos or Vector(0,0,0) local SPosM = nil local IsELS = col == "SirenColor"
		if !sideid or (sideid == 1 and SPos.x < 0 or sideid == 2 and SPos.x > 0) then
		local car = LocalPlayer():GetVehicle() if IsValid(car) then if IsValid(car:GetParent()) then car = car:GetParent() end else car = nil end local NotDark = ent.VC_Lht_CarBrght > 0.2
			if (car and VC_IsDrawn() or GetViewEntity() != LocalPlayer() or car != ent) and Lhv.UseSprite and Lhv.Sprite then
			if !ent.VC_Lights_PixVisTbl then ent.VC_Lights_PixVisTbl = {} end if !ent.VC_Lights_PixVisTbl[Lhk] then ent.VC_Lights_PixVisTbl[Lhk] = util.GetPixelVisibleHandle() end
			if !SPosM then SPosM = ent:LocalToWorld(Lhv.SLSPos or SPos) end
			local Vis = util.PixelVisible(SPosM, (Lhv.Sprite.GlowPrxSize or 2)*0.5, ent.VC_Lights_PixVisTbl[Lhk])*255
			local Size = (Lhv.Sprite.Size or 6)*100*distnum if sizem then Size = Size*sizem end if NotDark then Size = Size*1.1 end
				if Vis > 0 then
				if !Lhv.Inited then VC_Handle_Light_Init(Lhv, IsELS, col, SPos, Size) Lhv.Inited = true end
				local IntLS = Lhv.Srn_CenterSz if NotDark then IntLS = IntLS*1.1 end local RegColor = Color(Lhv[col][1], Lhv[col][2], Lhv[col][3], Vis)

					if Lhv.Data_3D and VC_Settings.VC_Light_3D then
					render.SetMaterial(Lhv.Data_3D.Mat)
					render.DrawQuad(ent:LocalToWorld(Lhv.Data_3D.Pos1), ent:LocalToWorld(Lhv.Data_3D.Pos2), ent:LocalToWorld(Lhv.Data_3D.Pos3), ent:LocalToWorld(Lhv.Data_3D.Pos4), Lhv.Data_3D.Color and Color(Lhv.Data_3D.Color[1], Lhv.Data_3D.Color[2], Lhv.Data_3D.Color[3], Vis) or Color(Lhv.midColor[1],Lhv.midColor[2],Lhv.midColor[3], Vis))
					end

					local InDetail = ent.VC_Lht_DstCheck < 2000
					local ExrGlw = IsELS and VC_Settings.VC_ELS_ExtraGlow local DrawM = !Lhv.DD_Main and VC_Settings.VC_Light_Main local DrawHD = !Lhv.DD_HD and VC_Settings.VC_Light_HD and InDetail local DrawGlow = !Lhv.DD_Glow and VC_Settings.VC_Light_Glow and InDetail local DrawIn = VC_Settings.VC_Light_Warm and InDetail and (Lhv.RenderInner or IsELS and !Lhv.DD_In)
					if DrawM then DrawM = VC_Settings.VC_Light_Main_M end if DrawHD then DrawHD = VC_Settings.VC_Light_HD_M end if DrawGlow then DrawGlow = VC_Settings.VC_Light_Glow_M end if DrawIn then DrawIn = VC_Settings.VC_Light_Warm_M end if ExrGlw then ExrGlw = VC_Settings.VC_ELS_ExtraGlow_M end

					if Lhv.SpecTable then
					if IsELS and DrawHD then local Sz = IntLS*DrawHD if sizem then Sz=Sz*sizem end render.SetMaterial(UsedMat_HD) render.DrawSprite(SPosM, Sz, Sz, RegColor) end
						if DrawIn or DrawM then
						render.SetMaterial(UsedMat) local Sz = Size/2.5
						local LastPos = nil
							for i=1, table.Count(Lhv.SpecTable) do
							local TempPos = ent:LocalToWorld(Lhv.SpecTable[i])
								if Lhv.Beam_Use then
								if LastPos then local Clr = nil if Lhv.Beam_Clr_Use and Lhv.Beam_Clr then Clr = Color(Lhv.Beam_Clr[1],Lhv.Beam_Clr[2],Lhv.Beam_Clr[3], Vis) else Clr = Color(Lhv.midColor[1],Lhv.midColor[2],Lhv.midColor[3], Vis) end render.SetMaterial(UsedMat_Beam) render.DrawBeam(TempPos, LastPos, Sz, 1, 1, Clr) end
								LastPos = TempPos
								render.SetMaterial(UsedMat)
								elseif DrawIn then
								local Sz2=Sz*DrawIn render.DrawSprite(TempPos, Sz2, Sz2, Color(Lhv.midColor[1],Lhv.midColor[2],Lhv.midColor[3], Vis))
								end
							if DrawM then local Sz2 = Size*DrawM render.DrawSprite(TempPos, Sz2, Sz2, RegColor) end
							end
						end
						if DrawGlow then
						local Sz = IntLS*DrawGlow*1.5 render.SetMaterial(UsedMat_Glow)
							if ExrGlw then
							Sz=Sz*7*ExrGlw render.DrawSprite(SPosM, Sz, Sz, Color(RegColor.r, RegColor.g, RegColor.b, RegColor.a*0.08))
							else
							Sz=Sz*1.1 render.DrawSprite(SPosM, Sz, Sz, Color(RegColor.r, RegColor.g, RegColor.b, RegColor.a*0.11))
							end
						end
					else
					local HLOf = 1 local HLSOf = nil if Lhv.UsePrjTex then HLOf = 0.5 local CAng = ent.VC_HighBeam and 30 or 60 local Ang = math.abs(VC_AngleDifference(ent:GetForward():Angle(), (SPosM-EyePos()):Angle())-90) if Ang < CAng then HLOf = HLOf+(1-VC_EaseInOut(Ang/CAng))*(ent.VC_HighBeam and 0.8 or 0.4) end HLSOf = (Size/1.5+Vis/255)*HLOf end
					
					Size = Size*HLOf*0.85 if !HLSOf then HLSOf = Size end
					render.SetMaterial(UsedMat)
					if DrawIn then local Sz = Size/2.5*DrawIn render.DrawSprite(SPosM, Sz, Sz, Color(Lhv.midColor[1],Lhv.midColor[2],Lhv.midColor[3], Vis)) end
						if DrawM then HLSOf=HLSOf*DrawM render.DrawSprite(SPosM, HLSOf, HLSOf, RegColor) end
						if DrawHD then
						Size=Size*DrawHD
						render.SetMaterial(UsedMat_HD) render.DrawSprite(SPosM, Size*0.85, Size*0.85, RegColor)
							if Size > 19 then
							local NVis = Vis-155
								if NVis > 0 then
								render.DrawSprite(SPosM, Size/3, Size*2, Color(Lhv[col][1], Lhv[col][2], Lhv[col][3], NVis))
								if DrawGlow then local Sz = IntLS*2*DrawGlow render.SetMaterial(UsedMat_Glow) render.DrawSprite(SPosM, Sz, Sz, Color(RegColor.r, RegColor.g, RegColor.b, RegColor.a*0.3*NVis/255)) end
								end
							end
						end
						if DrawGlow then
						local Sz = IntLS*3*HLOf*DrawGlow render.SetMaterial(UsedMat_Glow)
							if ExrGlw then
							Sz=Sz*2*ExrGlw render.DrawSprite(SPosM, Sz, Sz, Color(RegColor.r, RegColor.g, RegColor.b, RegColor.a*0.1))
							else
							Sz=Sz*1.1 render.DrawSprite(SPosM, Sz, Sz, Color(RegColor.r, RegColor.g, RegColor.b, RegColor.a*0.1))
							end
						end
					end
				end
			end

			if Lhv.UseDynamic and Lhv.Dynamic and VC_Settings.VC_DynamicLights and ent.VC_LhtSzOffset_D > 0 and (!IsELS or VC_Settings.VC_ELS_Dyn_Enabled)  then
			if !SPosM then SPosM = ent:LocalToWorld(Lhv.SLSPos or SPos) end
				if !NotDark then
				local DLight = DynamicLight(ent:EntIndex()..Lhk..colid)
				DLight.Pos = SPosM
				DLight.r = Lhv[col][1] DLight.g = Lhv[col][2] DLight.b = Lhv[col][3]
				DLight.Brightness = (Lhv.Dynamic.Brightness or 1)/2
				local Sz = 180*(Lhv.Dynamic.Size or 1)*distnum if sizemd then Sz=Sz*sizemd end DLight.Size = Sz*ent.VC_LhtSzOffset_D*(IsELS and VC_Settings.VC_ELS_Dyn_Mult or 1)
				DLight.Decay = 500
				DLight.DieTime = CurTime()+0.5
				end
			end
		end
	end
	ent.VC_LastRenderedL[Lhk] = Lhv[col]
end

local function Handle_Light_Draw_Multi(ent, ltable, col, colid, sideid, distnum, sizem) for Lhk, Lhv in pairs(ltable) do VC_Handle_Light_Draw_Single(ent, Lhk, Lhv, col, colid, sideid, distnum) end end

function VC_Render_Interior_Light(ent, Vis, Tbl, P1, P2, SzM, Clr)
	if VC_Settings.VC_ELS_Dyn_Interior then
	if !Vis then if !ent.VC_Lights_PixVisTbl then ent.VC_Lights_PixVisTbl = {} end if !ent.VC_Lights_PixVisTbl["Int"] then ent.VC_Lights_PixVisTbl["Int"] = util.GetPixelVisibleHandle() end Vis = util.PixelVisible(P2, 3, ent.VC_Lights_PixVisTbl["Int"])*255 end
		if Vis > 0 then
		local Sz = 6 if SzM then Sz=Sz*SzM*VC_Settings.VC_ELS_Dyn_Interior_M end Clr = Color(Clr[1], Clr[2], Clr[3], Vis)
		if !Tbl.MidCol then if Clr.r > Clr.g and Clr.r > Clr.b then Tbl.MidCol = {255,200,0} elseif Clr.g > Clr.r and Clr.g > Clr.b then Tbl.MidCol = {255,255,255} elseif Clr.b > Clr.r and Clr.b > Clr.g then Tbl.MidCol = {0,200,255} else Tbl.MidCol = Clr end end
		render.SetMaterial(UsedMat) render.DrawSprite(P1, Sz, Sz, Clr) render.DrawSprite(P1, Sz/2.5, Sz/2.5, Color(Tbl.MidCol[1] or 0, Tbl.MidCol[2] or 0, Tbl.MidCol[3] or 0, Vis))
		render.SetMaterial(UsedMat_HD) render.DrawSprite(P1, Sz/3, Sz*2, Clr)
		Clr.a = Vis*0.1 Sz = Sz*8 render.SetMaterial(UsedMat_Glow) render.DrawSprite(P1, Sz, Sz, Clr)
		end
	return Vis
	end
end

function VC_DataReqCheck(ent)
	if !ent.VC_Model then
	net.Start("VC_RequestVehData_Model") net.WriteEntity(LocalPlayer()) net.WriteEntity(ent) net.SendToServer()
	elseif !VC_Global_Data[ent.VC_Model] then
		net.Start("VC_RequestVehData") net.WriteEntity(LocalPlayer()) net.WriteEntity(ent) net.SendToServer()
		if !VC_RequestedLng then timer.Simple(10, function() VC_Lng_Get() end) VC_RequestedLng = true end
	end
end

hook.Add("PostDrawTranslucentRenderables", "VC_PostDrawTranslucentRenderables", function()
	local CanUpdate = !VC_SyncTimeCheck or CurTime() >= VC_SyncTimeCheck
	local Tbl = ents.FindByClass("prop_vehicle_jeep*") for k,v in pairs(ents.FindByClass("prop_physics*")) do if v.VC_Used then table.insert(Tbl, v) end end
	for _, ent in pairs(Tbl) do
	local PRenL = ent.VC_LastRenderedL ent.VC_LastRenderedL = {}
		if (ent:GetNWInt("VC_MaxHealth") == 0 or ent:GetNWInt("VC_Health") > 0) or !ent:IsVehicle() then
		if CanUpdate then VC_DataReqCheck(ent) end //local gxccg = 76561252636330179

			if ent.VC_AlarmLightOnTime and CurTime() >= ent.VC_AlarmLightOnTime then ent.VC_AlarmLightOnTime = nil ent.VC_AlarmLightOffTime = CurTime()+3 elseif ent.VC_AlarmLightOffTime and CurTime() >= ent.VC_AlarmLightOffTime then ent.VC_AlarmLightOffTime = nil ent.VC_AlarmLightOnTime = CurTime()+0.15 end
			if ent.VC_AlarmLightOnTime then VC_Handle_Light_Draw_Single(ent, -35, {Pos = ent.VC_AlarmLightPos, UseSprite = true, Sprite = {Size = 0.15}, UseDynamic = true, Dynamic = {Size = 0.5, Brightness = 3}, Color = {255, 0, 0}}, "Color", 1, nil, ent.VC_Lht_DstCheckMult) end

			if ent.VC_Model and VC_Global_Data[ent.VC_Model] then	
				if !ent.VC_Lht_ChkT or CurTime() >= ent.VC_Lht_ChkT then
				local LInt = render.GetLightColor(ent:LocalToWorld(ent:OBBCenter())) ent.VC_Lht_CarBrght = (LInt.x+LInt.y+LInt.z)/3
				ent.VC_Lht_DstCheck = LocalPlayer():GetPos():Distance(ent:GetPos()) ent.VC_Lht_DstCheck_B = ent.VC_Lht_DstCheck < (VC_Settings.VC_LightDistance or 8000) if !ent.VC_Lht_DstCheckMult then ent.VC_Lht_DstCheckMult = 1 end
					if VC_Settings.VC_DynamicLights and ((VC_Settings.VC_DynamicLights_OffDist or 2500)-1000) < (ent.VC_Lht_DstCheck) then
					local Am = VC_Settings.VC_DynamicLights_OffDist or 2500
					if Am < ent.VC_Lht_DstCheck then ent.VC_LhtSzOffset_D = 0 else ent.VC_LhtSzOffset_D = (Am-ent.VC_Lht_DstCheck)/1000 end
					else
					ent.VC_LhtSzOffset_D = 1
					end
				ent.VC_Lht_ChkT = CurTime()+0.5
				end

				if ent.VC_Lht_DstCheck_B then
				if ent.VC_Lht_DstCheckMult < 1 then ent.VC_Lht_DstCheckMult = ent.VC_Lht_DstCheckMult+0.01*VC_FTm() if ent.VC_Lht_DstCheckMult > 1 then ent.VC_Lht_DstCheckMult = 1 end end
				elseif ent.VC_Lht_DstCheckMult > 0 then ent.VC_Lht_DstCheckMult = ent.VC_Lht_DstCheckMult-0.01*VC_FTm() if ent.VC_Lht_DstCheckMult < 0 then ent.VC_Lht_DstCheckMult = 0 end
				end

				if ent.VC_Lht_DstCheckMult > 0 then
				local LhtTbl = VC_Global_Data[ent.VC_Model].LightTable
				if LhtTbl and LhtTbl.Siren and VC_Global_Data[ent.VC_Model].Siren and VCMod1_ELS then VC_Handle_Light_ELS_Draw(ent, LhtTbl, PRenL) end
				-- if LhtTbl and LhtTbl.Siren and VC_Global_Data[ent.VC_Model].Siren then if !ent.VC_SirenTable and LhtTbl.Siren then ent.VC_SirenTable = {} end Handle_Siren_Sequence(ent, VC_Global_Data[ent.VC_Model].Siren, ent.VC_SirenTable, ent.VC_Lht_DstCheckMult, PRenL) end
				if ent:GetNWBool("VC_Lights_Brk_Created") and LhtTbl and LhtTbl.Brake then Handle_Light_Draw_Multi(ent, LhtTbl.Brake, "BrakeColor", 2, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Normal_Created") and LhtTbl and LhtTbl.Normal then Handle_Light_Draw_Multi(ent, LhtTbl.Normal, "NormalColor", 3, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Rev_Created") and LhtTbl and LhtTbl.Reverse then Handle_Light_Draw_Multi(ent, LhtTbl.Reverse, "ReverseColor", 4, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Head_Created") and LhtTbl and LhtTbl.Head then ent.VC_HighBeam = ent:GetNWBool("VC_HighBeam") Handle_Light_Draw_Multi(ent, LhtTbl.Head, "HeadColor", 5, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Alarm_Created") and LhtTbl and LhtTbl.Blinker then Handle_Light_Draw_Multi(ent, LhtTbl.Blinker, "BlinkersColor", 6, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Hazards_Created") and LhtTbl and LhtTbl.Blinker then Handle_Light_Draw_Multi(ent, LhtTbl.Blinker, "BlinkersColor", 6, nil, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Blinker_Created_Left") and LhtTbl and LhtTbl.Blinker then Handle_Light_Draw_Multi(ent, LhtTbl.Blinker, "BlinkersColor", 6, 1, ent.VC_Lht_DstCheckMult) end
				if ent:GetNWBool("VC_Lights_Blinker_Created_Right") and LhtTbl and LhtTbl.Blinker then Handle_Light_Draw_Multi(ent, LhtTbl.Blinker, "BlinkersColor", 6, 2, ent.VC_Lht_DstCheckMult) end
				local LhtTbl = VC_Global_Data[ent.VC_Model].LightTable
					if ent:GetNWBool("VC_Lights_Door_Created") then
					if !ent.VC_Initialized then VC_Initialize(ent) ent.VC_Initialized = true end
					VC_Handle_Light_Draw_Single(ent, -45, {Pos = ent.VC_DoorLightPos or Vector(0,0,0), UseDynamic = true, Dynamic = {Brightness = 5, Size = 0.6}, DoorColor = {255,255,255}}, "DoorColor", 1, nil, ent.VC_Lht_DstCheckMult)
					end
				end
			end
		end
	end
	if CanUpdate then VC_SyncTimeCheck = CurTime()+1 end
end)