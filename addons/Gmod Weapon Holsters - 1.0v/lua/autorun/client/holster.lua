local holsteredgunsconvar = CreateConVar( "cl_holsteredguns", "1", { FCVAR_ARCHIVE, }, "Enable/Disable the rendering of the weapons on any player" )
 
local NEXT_WEAPONS_UPDATE=CurTime();
 
local weaponsinfos={}
weaponsinfos["weapon_physcannon"]={}
weaponsinfos["weapon_physcannon"].Model=""
weaponsinfos["weapon_physcannon"].Bone="ValveBiped.Bip01_Spine1"
weaponsinfos["weapon_physcannon"].BoneOffset={Vector(6,15,0),Angle(90,180,0)}
weaponsinfos["weapon_physcannon"].Priority="weapon_physgun"
 
weaponsinfos["weapon_physgun"]={}
weaponsinfos["weapon_physgun"].Model=""
weaponsinfos["weapon_physgun"].Bone="ValveBiped.Bip01_Spine1"
weaponsinfos["weapon_physgun"].DrawFunction=function(ent) end
weaponsinfos["weapon_physgun"].BoneOffset={Vector(6,15,0),Angle(90,180,0)}
weaponsinfos["weapon_physgun"].Skin=1;  
 
 
weaponsinfos["weapon_physgun"].DrawFunction=function(ent)
    local attachment=ent:GetAttachment( 1)
    local StartPos = attachment.Pos + attachment.Ang:Forward()*4
    render.SetMaterial(physgunmat)
    render.DrawSprite(attachment.Pos,20,20,Color(255,255,255,255));
    render.SetMaterial(physgunmat1)
    render.DrawSprite(StartPos,20,20,Color(255,255,255,255));   
end

weaponsinfos["weapon_pistol"]={}
weaponsinfos["weapon_pistol"].Model="models/weapons/W_pistol.mdl"
weaponsinfos["weapon_pistol"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_pistol"].BoneOffset={Vector(0,-8,0),Angle(0,90,0)}
 
weaponsinfos["weapon_357"]={}
weaponsinfos["weapon_357"].Model="models/weapons/W_357.mdl"
weaponsinfos["weapon_357"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_357"].BoneOffset={Vector(-5,8,0),Angle(0,270,0)}
weaponsinfos["weapon_357"].Priority="gmod_tool"
 
 
weaponsinfos["weapon_frag"]={}
weaponsinfos["weapon_frag"].Model="models/Items/grenadeAmmo.mdl"
weaponsinfos["weapon_frag"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_frag"].BoneOffset={Vector(3,-5,6),Angle(-95,0,0)}
 
weaponsinfos["weapon_slam"]={}
weaponsinfos["weapon_slam"].Model="models/weapons/w_slam.mdl"
weaponsinfos["weapon_slam"].Bone="ValveBiped.Bip01_Spine2"
weaponsinfos["weapon_slam"].BoneOffset={Vector(-9,0,-7),Angle(270,90,-25)}
 
weaponsinfos["weapon_crowbar"]={}
weaponsinfos["weapon_crowbar"].Model="models/weapons/w_crowbar.mdl"
weaponsinfos["weapon_crowbar"].Bone="ValveBiped.Bip01_Spine1"
weaponsinfos["weapon_crowbar"].BoneOffset={Vector(3,0,0),Angle(0,0,45)}
 
weaponsinfos["weapon_stunstick"]={}
weaponsinfos["weapon_stunstick"].Model="models/weapons/W_stunbaton.mdl"
weaponsinfos["weapon_stunstick"].Bone="ValveBiped.Bip01_Spine1"
weaponsinfos["weapon_stunstick"].BoneOffset={Vector(3,0,0),Angle(0,0,-45)}
 
weaponsinfos["weapon_shotgun"]={}
weaponsinfos["weapon_shotgun"].Model="models/weapons/W_shotgun.mdl"
weaponsinfos["weapon_shotgun"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["weapon_shotgun"].BoneOffset={Vector(10,5,2),Angle(0,90,0)}
 
weaponsinfos["weapon_rpg"]={}
weaponsinfos["weapon_rpg"].Model="models/weapons/w_rocket_launcher.mdl"
weaponsinfos["weapon_rpg"].Bone="ValveBiped.Bip01_L_Clavicle"
weaponsinfos["weapon_rpg"].BoneOffset={Vector(-16,5,0),Angle(90,90,90)}
 
weaponsinfos["weapon_smg1"]={}
weaponsinfos["weapon_smg1"].Model="models/weapons/w_smg1.mdl"
weaponsinfos["weapon_smg1"].Bone="ValveBiped.Bip01_Spine1"
weaponsinfos["weapon_smg1"].BoneOffset={Vector(5,0,-5),Angle(0,0,230)}
 
weaponsinfos["weapon_ar2"]={}
weaponsinfos["weapon_ar2"].Model="models/weapons/W_irifle.mdl"
weaponsinfos["weapon_ar2"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["weapon_ar2"].BoneOffset={Vector(-5,0,7),Angle(0,270,0)}
 
weaponsinfos["weapon_crossbow"]={}
weaponsinfos["weapon_crossbow"].Model="models/weapons/W_crossbow.mdl"
weaponsinfos["weapon_crossbow"].Bone="ValveBiped.Bip01_L_Clavicle"
weaponsinfos["weapon_crossbow"].BoneOffset={Vector(0,5,-5),Angle(180,90,0)}

 -- 의사 치료킷
 
weaponsinfos["med_kit"]={}
weaponsinfos["med_kit"].Model="models/Items/HealthKit.mdl"
weaponsinfos["med_kit"].Bone="ValveBiped.Bip01_Spine2"
weaponsinfos["med_kit"].BoneOffset={Vector(1,8.5,0),Angle(90,180,0)}
 
 -- 경찰 스턴봉
 
weaponsinfos["stunstick"]={}
weaponsinfos["stunstick"].Model="models/weapons/w_stunbaton.mdl"
weaponsinfos["stunstick"].Bone="ValveBiped.Bip01_Spine2"
weaponsinfos["stunstick"].BoneOffset={Vector(-7,-11,6.5),Angle(0,0,0)}
 
 -- 경찰 체포봉
 
-- weaponsinfos["arrest_stick"]={}
-- weaponsinfos["arrest_stick"].Model="models/weapons/w_stunbaton.mdl"
-- weaponsinfos["arrest_stick"].Bone="ValveBiped.Bip01_Spine2"
-- weaponsinfos["arrest_stick"].BoneOffset={Vector(-6,-13,7.5),Angle(0,0,0)}
-- weaponsinfos["arrest_stick"].Color={Color(255,0,0,255)}

 -- 경찰 체포봉
 
-- weaponsinfos["unarrest_stick"]={}
-- weaponsinfos["unarrest_stick"].Model="models/weapons/w_stunbaton.mdl"
-- weaponsinfos["unarrest_stick"].Bone="ValveBiped.Bip01_Spine2"
-- weaponsinfos["unarrest_stick"].BoneOffset={Vector(-6,-13,7.5),Angle(0,0,0)}
-- weaponsinfos["unarrest_stick"].Color={Color(0,255,0,255)}

-- FA:S 2.0 자동소총
 
weaponsinfos["fas2_ak47"]={}
weaponsinfos["fas2_ak47"].Model="models/weapons/w_rif_ak47.mdl"
weaponsinfos["fas2_ak47"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_ak47"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_ak74"]={}
weaponsinfos["fas2_ak74"].Model="models/weapons/w_rif_galil.mdl"
weaponsinfos["fas2_ak74"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_ak74"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_famas"]={}
weaponsinfos["fas2_famas"].Model="models/weapons/w_rif_famas.mdl"
weaponsinfos["fas2_famas"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_famas"].BoneOffset={Vector(16,5,4),Angle(90,0,100)}

weaponsinfos["fas2_g36c"]={}
weaponsinfos["fas2_g36c"].Model="models/weapons/w_g36e.mdl"
weaponsinfos["fas2_g36c"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_g36c"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_g3"]={}
weaponsinfos["fas2_g3"].Model="models/weapons/w_g3a3.mdl"
weaponsinfos["fas2_g3"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_g3"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m14"]={}
weaponsinfos["fas2_m14"].Model="models/weapons/w_m14.mdl"
weaponsinfos["fas2_m14"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m14"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m21"]={}
weaponsinfos["fas2_m21"].Model="models/weapons/w_m14.mdl"
weaponsinfos["fas2_m21"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m21"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m24"]={}
weaponsinfos["fas2_m24"].Model="models/weapons/w_m24.mdl"
weaponsinfos["fas2_m24"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m24"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m3s90"]={}
weaponsinfos["fas2_m3s90"].Model="models/weapons/w_m3.mdl"
weaponsinfos["fas2_m3s90"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m3s90"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m4a1"]={}
weaponsinfos["fas2_m4a1"].Model="models/weapons/w_m4.mdl"
weaponsinfos["fas2_m4a1"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m4a1"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_m82"]={}
weaponsinfos["fas2_m82"].Model="models/weapons/w_m82.mdl"
weaponsinfos["fas2_m82"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_m82"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_mp5a5"]={}
weaponsinfos["fas2_mp5a5"].Model="models/weapons/w_mp5.mdl"
weaponsinfos["fas2_mp5a5"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_mp5a5"].BoneOffset={Vector(13,4,4),Angle(90,0,100)}

weaponsinfos["fas2_pp19"]={}
weaponsinfos["fas2_pp19"].Model="models/weapons/w_smg_biz.mdl"
weaponsinfos["fas2_pp19"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_pp19"].BoneOffset={Vector(-4,7,4),Angle(90,0,100)}

weaponsinfos["fas2_rpk"]={}
weaponsinfos["fas2_rpk"].Model="models/weapons/w_ak47.mdl"
weaponsinfos["fas2_rpk"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_rpk"].BoneOffset={Vector(14,3,4),Angle(90,0,100)}

weaponsinfos["fas2_rk95"]={}
weaponsinfos["fas2_rk95"].Model="models/weapons/world/rifles/rk95.mdl"
weaponsinfos["fas2_rk95"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_rk95"].BoneOffset={Vector(5,3,4),Angle(90,0,100)}

weaponsinfos["fas2_sg550"]={}
weaponsinfos["fas2_sg550"].Model="models/weapons/w_rif_sg552.mdl"
weaponsinfos["fas2_sg550"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_sg550"].BoneOffset={Vector(14,8,4),Angle(90,0,100)}

weaponsinfos["fas2_sg552"]={}
weaponsinfos["fas2_sg552"].Model="models/weapons/w_rif_sg552.mdl"
weaponsinfos["fas2_sg552"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_sg552"].BoneOffset={Vector(14,8,4),Angle(90,0,100)}

weaponsinfos["fas2_sks"]={}
weaponsinfos["fas2_sks"].Model="models/weapons/world/rifles/sks.mdl"
weaponsinfos["fas2_sks"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_sks"].BoneOffset={Vector(14,0,4),Angle(90,0,100)}

weaponsinfos["fas2_sr25"]={}
weaponsinfos["fas2_sr25"].Model="models/weapons/w_sr25.mdl"
weaponsinfos["fas2_sr25"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["fas2_sr25"].BoneOffset={Vector(14,3,4),Angle(90,0,100)}

-- FA:S 2.0 자동소총 외
 
weaponsinfos["fas2_ragingbull"]={}
weaponsinfos["fas2_ragingbull"].Model="models/weapons/W_357.mdl"
weaponsinfos["fas2_ragingbull"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_ragingbull"].BoneOffset={Vector(-5,8,0),Angle(0,270,0)}
weaponsinfos["fas2_ragingbull"].Priority="gmod_tool"

weaponsinfos["fas2_glock20"]={}
weaponsinfos["fas2_glock20"].Model="models/weapons/w_pist_glock18.mdl"
weaponsinfos["fas2_glock20"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_glock20"].BoneOffset={Vector(-2,-8,-2),Angle(5,270,0)}

weaponsinfos["fas2_m67"]={}
weaponsinfos["fas2_m67"].Model="models/weapons/w_eq_fraggrenade_thrown.mdl"
weaponsinfos["fas2_m67"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_m67"].BoneOffset={Vector(3,4,6),Angle(-95,0,0)}

weaponsinfos["fas2_m79"]={}
weaponsinfos["fas2_m79"].Model="models/weapons/w_m79.mdl"
weaponsinfos["fas2_m79"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_m79"].BoneOffset={Vector(-4,-2,-7),Angle(-85,0,90)}

weaponsinfos["fas2_ifak"]={}
weaponsinfos["fas2_ifak"].Model="models/weapons/w_ifak.mdl"
weaponsinfos["fas2_ifak"].Bone="ValveBiped.Bip01_Spine2"
weaponsinfos["fas2_ifak"].BoneOffset={Vector(-8,0,6),Angle(180,95,30)}

weaponsinfos["fas2_machete"]={}
weaponsinfos["fas2_machete"].Model="models/weapons/w_machete.mdl"
weaponsinfos["fas2_machete"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_machete"].BoneOffset={Vector(2,-7.5,2),Angle(0,800,90)}

weaponsinfos["fas2_dv2"]={}
weaponsinfos["fas2_dv2"].Model="models/weapons/w_dv2.mdl"
weaponsinfos["fas2_dv2"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["fas2_dv2"].BoneOffset={Vector(3,-8,0),Angle(0,800,90)}

-- 딱건

weaponsinfos["pist_weagon"]={}
weaponsinfos["pist_weagon"].Model="models/weapons/w_pist_deagle.mdl"
weaponsinfos["pist_weagon"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["pist_weagon"].BoneOffset={Vector(-2,-8,-2),Angle(5,270,0)}

-- 레인보우 나이프

weaponsinfos["weapon_m9fade"]={}
weaponsinfos["weapon_m9fade"].Model="models/weapons/w_knife_t.mdl"
weaponsinfos["weapon_m9fade"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_m9fade"].BoneOffset={Vector(-1,-7,0),Angle(0,80,90)}

-- VC모드 렌치

weaponsinfos["vc_repair"]={}
weaponsinfos["vc_repair"].Model="models/props_c17/tools_wrench01a.mdl"
weaponsinfos["vc_repair"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["vc_repair"].BoneOffset={Vector(2,8,0),Angle(-50,180,70)}

-- 뉴스기자 카메라

weaponsinfos["news_camera"]={}
weaponsinfos["news_camera"].Model="models/dav0r/camera.mdl"
weaponsinfos["news_camera"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["news_camera"].BoneOffset={Vector(-6,0,-16),Angle(0,180,180)}

-- ARC Bank 카드

weaponsinfos["weapon_arc_atmcard"]={}
weaponsinfos["weapon_arc_atmcard"].Model="models/arc/card.mdl"
weaponsinfos["weapon_arc_atmcard"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_arc_atmcard"].BoneOffset={Vector(-2,5,4.4),Angle(0,-180,32)}

-- 문폭파기

weaponsinfos["weapon_doorbreak"]={}
weaponsinfos["weapon_doorbreak"].Model="models/weapons/custom/w_batram.mdl"
weaponsinfos["weapon_doorbreak"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["weapon_doorbreak"].BoneOffset={Vector(2,-3.5,-10.8),Angle(0,180,160)}

-- 키패드 해커

weaponsinfos["keycrack"]={}
weaponsinfos["keycrack"].Model="models/weapons/spy/w_keypadcracker.mdl"
weaponsinfos["keycrack"].Bone="ValveBiped.Bip01_Pelvis"
weaponsinfos["keycrack"].BoneOffset={Vector(9,-29.3,-37),Angle(0,120,0)}

-- M9K Assault Rifles

weaponsinfos["m9k_winchester73"]={}
weaponsinfos["m9k_winchester73"].Model="models/weapons/w_winchester_1873.mdl"
weaponsinfos["m9k_winchester73"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_winchester73"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_acr"]={}
weaponsinfos["m9k_acr"].Model="models/weapons/w_masada_acr.mdl"
weaponsinfos["m9k_acr"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_acr"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_ak47"]={}
weaponsinfos["m9k_ak47"].Model="models/weapons/w_ak47_m9k.mdl"
weaponsinfos["m9k_ak47"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ak47"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_ak74"]={}
weaponsinfos["m9k_ak74"].Model="models/weapons/w_ak47_m9k.mdl"
weaponsinfos["m9k_ak74"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ak74"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_amd65"]={}
weaponsinfos["m9k_amd65"].Model="models/weapons/w_amd_65.mdl"
weaponsinfos["m9k_amd65"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_amd65"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}
 
weaponsinfos["m9k_an94"]={}
weaponsinfos["m9k_an94"].Model="models/weapons/w_rif_an_94.mdl"
weaponsinfos["m9k_an94"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_an94"].BoneOffset={Vector(1,-2,4),Angle(90,-2,100)}

weaponsinfos["m9k_val"]={}
weaponsinfos["m9k_val"].Model="models/weapons/w_dmg_vally.mdl"
weaponsinfos["m9k_val"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_val"].BoneOffset={Vector(9,2,4.3),Angle(5,12,242)}

weaponsinfos["m9k_f2000"]={}
weaponsinfos["m9k_f2000"].Model="models/weapons/w_fn_f2000.mdl"
weaponsinfos["m9k_f2000"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_f2000"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_famas"]={}
weaponsinfos["m9k_famas"].Model="models/weapons/w_tct_famas.mdl"
weaponsinfos["m9k_famas"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_famas"].BoneOffset={Vector(2,1.5,6),Angle(12,10,240)}

weaponsinfos["m9k_fal"]={}
weaponsinfos["m9k_fal"].Model="models/weapons/w_fn_fal.mdl"
weaponsinfos["m9k_fal"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_fal"].BoneOffset={Vector(3,5,3.2),Angle(90,0,100)}

weaponsinfos["m9k_g36"]={}
weaponsinfos["m9k_g36"].Model="models/weapons/w_hk_g36c.mdl"
weaponsinfos["m9k_g36"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_g36"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_m416"]={}
weaponsinfos["m9k_m416"].Model="models/weapons/w_hk_416.mdl"
weaponsinfos["m9k_m416"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m416"].BoneOffset={Vector(3,5,4),Angle(90,0,100)}

weaponsinfos["m9k_g3a3"]={}
weaponsinfos["m9k_g3a3"].Model="models/weapons/w_hk_g3.mdl"
weaponsinfos["m9k_g3a3"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_g3a3"].BoneOffset={Vector(3,5,3.2),Angle(90,0,100)}

weaponsinfos["m9k_l85"]={}
weaponsinfos["m9k_l85"].Model="models/weapons/w_l85a2.mdl"
weaponsinfos["m9k_l85"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_l85"].BoneOffset={Vector(7,5,4),Angle(90,0,100)}

weaponsinfos["m9k_m14sp"]={}
weaponsinfos["m9k_m14sp"].Model="models/weapons/w_snip_m14sp.mdl"
weaponsinfos["m9k_m14sp"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m14sp"].BoneOffset={Vector(3,2,5),Angle(90,0,100)}

weaponsinfos["m9k_m16a4_acog"]={}
weaponsinfos["m9k_m16a4_acog"].Model="models/weapons/w_dmg_m16ag.mdl"
weaponsinfos["m9k_m16a4_acog"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m16a4_acog"].BoneOffset={Vector(8,1,3.3),Angle(180,10,95)}

weaponsinfos["m9k_m4a1"]={}
weaponsinfos["m9k_m4a1"].Model="models/weapons/w_m4a1_iron.mdl"
weaponsinfos["m9k_m4a1"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m4a1"].BoneOffset={Vector(3,5,5),Angle(90,-5,100)}

weaponsinfos["m9k_scar"]={}
weaponsinfos["m9k_scar"].Model="models/weapons/w_fn_scar_h.mdl"
weaponsinfos["m9k_scar"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_scar"].BoneOffset={Vector(3,5,3.8),Angle(90,-5,100)}

weaponsinfos["m9k_vikhr"]={}
weaponsinfos["m9k_vikhr"].Model="models/weapons/w_dmg_vikhr.mdl"
weaponsinfos["m9k_vikhr"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_vikhr"].BoneOffset={Vector(0,1,5),Angle(90,-5,100)}

weaponsinfos["m9k_auga3"]={}
weaponsinfos["m9k_auga3"].Model="models/weapons/w_auga3.mdl"
weaponsinfos["m9k_auga3"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_auga3"].BoneOffset={Vector(4.5,5,4),Angle(90,-10,100)}

weaponsinfos["m9k_tar21"]={}
weaponsinfos["m9k_tar21"].Model="models/weapons/w_imi_tar21.mdl"
weaponsinfos["m9k_tar21"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_tar21"].BoneOffset={Vector(8.5,3,3.5),Angle(90,0,100)}

--M9K Heavy Weapons

weaponsinfos["m9k_ares_shrike"]={}
weaponsinfos["m9k_ares_shrike"].Model="models/weapons/w_ares_shrike.mdl"
weaponsinfos["m9k_ares_shrike"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ares_shrike"].BoneOffset={Vector(8.5,5,3.5),Angle(90,-10,100)}

weaponsinfos["m9k_minigun"]={}
weaponsinfos["m9k_minigun"].Model="models/weapons/w_m134_minigun.mdl"
weaponsinfos["m9k_minigun"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_minigun"].BoneOffset={Vector(-10,5,5),Angle(90,-10,100)}

weaponsinfos["m9k_fg42"]={}
weaponsinfos["m9k_fg42"].Model="models/weapons/w_fg42.mdl"
weaponsinfos["m9k_fg42"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_fg42"].BoneOffset={Vector(5,3,6),Angle(265,10,230)}

weaponsinfos["m9k_m1918bar"]={}
weaponsinfos["m9k_m1918bar"].Model="models/weapons/w_m1918_bar.mdl"
weaponsinfos["m9k_m1918bar"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m1918bar"].BoneOffset={Vector(1,3,6),Angle(265,10,230)}

weaponsinfos["m9k_m249lmg"]={}
weaponsinfos["m9k_m249lmg"].Model="models/weapons/w_m249_machine_gun.mdl"
weaponsinfos["m9k_m249lmg"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m249lmg"].BoneOffset={Vector(1,3,6),Angle(265,25,230)}

weaponsinfos["m9k_m60"]={}
weaponsinfos["m9k_m60"].Model="models/weapons/w_m60_machine_gun.mdl"
weaponsinfos["m9k_m60"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m60"].BoneOffset={Vector(1,3,6.5),Angle(265,25,230)}

weaponsinfos["m9k_pkm"]={}
weaponsinfos["m9k_pkm"].Model="models/weapons/w_mach_russ_pkm.mdl"
weaponsinfos["m9k_pkm"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_pkm"].BoneOffset={Vector(1,5,4.2),Angle(265,25,230)}

-- M9K pistols

weaponsinfos["m9k_colt1911"]={}
weaponsinfos["m9k_colt1911"].Model="models/weapons/s_dmgf_co1911.mdl"
weaponsinfos["m9k_colt1911"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_colt1911"].BoneOffset={Vector(13,5.5,-2.5),Angle(180,-20,45)}

weaponsinfos["m9k_coltpython"]={}
weaponsinfos["m9k_coltpython"].Model="models/weapons/w_colt_python.mdl"
weaponsinfos["m9k_coltpython"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_coltpython"].BoneOffset={Vector(13,5.5,-2.5),Angle(0,0,0)}

weaponsinfos["m9k_deagle"]={}
weaponsinfos["m9k_deagle"].Model="models/weapons/w_tcom_deagle.mdl"
weaponsinfos["m9k_deagle"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_deagle"].BoneOffset={Vector(18,5.5,-2.5),Angle(180,-11,0)}

weaponsinfos["m9k_glock"]={}
weaponsinfos["m9k_glock"].Model="models/weapons/w_dmg_glock.mdl"
weaponsinfos["m9k_glock"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_glock"].BoneOffset={Vector(5,-1.5,4),Angle(180,-150,-70)}

weaponsinfos["m9k_hk45"]={}
weaponsinfos["m9k_hk45"].Model="models/weapons/w_hk45c.mdl"
weaponsinfos["m9k_hk45"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_hk45"].BoneOffset={Vector(4,5,0),Angle(0,0,0)}

weaponsinfos["m9k_m29satan"]={}
weaponsinfos["m9k_m29satan"].Model="models/weapons/w_m29_satan.mdl"
weaponsinfos["m9k_m29satan"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m29satan"].BoneOffset={Vector(6,6.2,-2.5),Angle(0,0,-10)}

weaponsinfos["m9k_m92beretta"]={}
weaponsinfos["m9k_m92beretta"].Model="models/weapons/w_beretta_m92.mdl"
weaponsinfos["m9k_m92beretta"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m92beretta"].BoneOffset={Vector(8,5,0),Angle(15,18,15)}

weaponsinfos["m9k_luger"]={}
weaponsinfos["m9k_luger"].Model="models/weapons/w_luger_p08.mdl"
weaponsinfos["m9k_luger"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_luger"].BoneOffset={Vector(7,4.2,0),Angle(0,0,0)}

weaponsinfos["m9k_ragingbull"]={}
weaponsinfos["m9k_ragingbull"].Model="models/weapons/w_taurus_raging_bull.mdl"
weaponsinfos["m9k_ragingbull"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ragingbull"].BoneOffset={Vector(7,4.5,-1),Angle(0,-5,0)}

weaponsinfos["m9k_scoped_taurus"]={}
weaponsinfos["m9k_scoped_taurus"].Model="models/weapons/w_raging_bull_scoped.mdl"
weaponsinfos["m9k_scoped_taurus"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_scoped_taurus"].BoneOffset={Vector(13,3,3.9),Angle(-90,180,50)}

weaponsinfos["m9k_remington1858"]={}
weaponsinfos["m9k_remington1858"].Model="models/weapons/w_remington_1858.mdl"
weaponsinfos["m9k_remington1858"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_remington1858"].BoneOffset={Vector(5,5,-2),Angle(0,0,0)}

weaponsinfos["m9k_model3russian"]={}
weaponsinfos["m9k_model3russian"].Model="models/weapons/w_model_3_rus.mdl"
weaponsinfos["m9k_model3russian"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_model3russian"].BoneOffset={Vector(5,4.3,-2),Angle(0,0,0)}

weaponsinfos["m9k_model500"]={}
weaponsinfos["m9k_model500"].Model="models/weapons/w_sw_model_500.mdl"
weaponsinfos["m9k_model500"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_model500"].BoneOffset={Vector(5,4.3,-2),Angle(0,0,0)}

weaponsinfos["m9k_model627"]={}
weaponsinfos["m9k_model627"].Model="models/weapons/w_sw_model_627.mdl"
weaponsinfos["m9k_model627"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_model627"].BoneOffset={Vector(5,4.3,-2),Angle(0,0,0)}

weaponsinfos["m9k_sig_p229r"]={}
weaponsinfos["m9k_sig_p229r"].Model="models/weapons/w_pist_fokkususp.mdl"
weaponsinfos["m9k_sig_p229r"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_sig_p229r"].BoneOffset={Vector(10,5.5,2),Angle(0,90,0)}

-- M9K ShotGuns

weaponsinfos["m9k_m3"]={}
weaponsinfos["m9k_m3"].Model="models/weapons/w_benelli_m3.mdl"
weaponsinfos["m9k_m3"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m3"].BoneOffset={Vector(3,5,2.8),Angle(90,0,100)}

weaponsinfos["m9k_browningauto5"]={}
weaponsinfos["m9k_browningauto5"].Model="models/weapons/w_browning_auto.mdl"
weaponsinfos["m9k_browningauto5"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_browningauto5"].BoneOffset={Vector(3,5,2.9),Angle(90,0,100)}

weaponsinfos["m9k_dbarrel"]={}
weaponsinfos["m9k_dbarrel"].Model="models/weapons/w_double_barrel_shotgun.mdl"
weaponsinfos["m9k_dbarrel"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_dbarrel"].BoneOffset={Vector(3,5,2.8),Angle(90,0,100)}

weaponsinfos["m9k_ithacam37"]={}
weaponsinfos["m9k_ithacam37"].Model="models/weapons/w_ithaca_m37.mdl"
weaponsinfos["m9k_ithacam37"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ithacam37"].BoneOffset={Vector(3,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_mossberg590"]={}
weaponsinfos["m9k_mossberg590"].Model="models/weapons/w_mossberg_590.mdl"
weaponsinfos["m9k_mossberg590"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mossberg590"].BoneOffset={Vector(3,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_jackhammer"]={}
weaponsinfos["m9k_jackhammer"].Model="models/weapons/w_pancor_jackhammer.mdl"
weaponsinfos["m9k_jackhammer"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_jackhammer"].BoneOffset={Vector(3,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_remington870"]={}
weaponsinfos["m9k_remington870"].Model="models/weapons/w_remington_870_tact.mdl"
weaponsinfos["m9k_remington870"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_remington870"].BoneOffset={Vector(3,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_spas12"]={}
weaponsinfos["m9k_spas12"].Model="models/weapons/w_spas_12.mdl"
weaponsinfos["m9k_spas12"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_spas12"].BoneOffset={Vector(3,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_striker12"]={}
weaponsinfos["m9k_striker12"].Model="models/weapons/w_striker_12g.mdl"
weaponsinfos["m9k_striker12"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_striker12"].BoneOffset={Vector(3,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_usas"]={}
weaponsinfos["m9k_usas"].Model="models/weapons/w_usas_12.mdl"
weaponsinfos["m9k_usas"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_usas"].BoneOffset={Vector(3,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_1897winchester"]={}
weaponsinfos["m9k_1897winchester"].Model="models/weapons/w_winchester_1887.mdl"
weaponsinfos["m9k_1897winchester"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_1897winchester"].BoneOffset={Vector(0,5,3.8),Angle(90,0,100)}

weaponsinfos["m9k_1887winchester"]={}
weaponsinfos["m9k_1887winchester"].Model="models/weapons/w_winchester_1897_trench.mdl"
weaponsinfos["m9k_1887winchester"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_1887winchester"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

-- M9K Sniper Rifles

weaponsinfos["m9k_aw50"]={}
weaponsinfos["m9k_aw50"].Model="models/weapons/w_acc_int_aw50.mdl"
weaponsinfos["m9k_aw50"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_aw50"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_barret_m82"]={}
weaponsinfos["m9k_barret_m82"].Model="models/weapons/w_barret_m82.mdl"
weaponsinfos["m9k_barret_m82"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_barret_m82"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_m98b"]={}
weaponsinfos["m9k_m98b"].Model="models/weapons/w_barrett_m98b.mdl"
weaponsinfos["m9k_m98b"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m98b"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_svu"]={}
weaponsinfos["m9k_svu"].Model="models/weapons/w_dragunov_svu.mdl"
weaponsinfos["m9k_svu"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_svu"].BoneOffset={Vector(5,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_sl8"]={}
weaponsinfos["m9k_sl8"].Model="models/weapons/w_hk_sl8.mdl"
weaponsinfos["m9k_sl8"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_sl8"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_intervention"]={}
weaponsinfos["m9k_intervention"].Model="models/weapons/w_acc_int_aw50.mdl"
weaponsinfos["m9k_intervention"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_intervention"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_m24"]={}
weaponsinfos["m9k_m24"].Model="models/weapons/w_snip_m24_6.mdl"
weaponsinfos["m9k_m24"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_m24"].BoneOffset={Vector(5,2.5,6.5),Angle(0,0,90)}

weaponsinfos["m9k_psg1"]={}
weaponsinfos["m9k_psg1"].Model="models/weapons/w_hk_psg1.mdl"
weaponsinfos["m9k_psg1"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_psg1"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_remington7615p"]={}
weaponsinfos["m9k_remington7615p"].Model="models/weapons/w_remington_7615p.mdl"
weaponsinfos["m9k_remington7615p"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_remington7615p"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_dragunov"]={}
weaponsinfos["m9k_dragunov"].Model="models/weapons/w_svd_dragunov.mdl"
weaponsinfos["m9k_dragunov"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_dragunov"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

weaponsinfos["m9k_svt40"]={}
weaponsinfos["m9k_svt40"].Model="models/weapons/w_svt_40.mdl"
weaponsinfos["m9k_svt40"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_svt40"].BoneOffset={Vector(0,5,3.5),Angle(90,0,100)}

-- M9K Submachine Guns

weaponsinfos["m9k_honeybadger"]={}
weaponsinfos["m9k_honeybadger"].Model="models/weapons/w_aac_honeybadger.mdl"
weaponsinfos["m9k_honeybadger"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_honeybadger"].BoneOffset={Vector(0,5.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_bizonp19"]={}
weaponsinfos["m9k_bizonp19"].Model="models/weapons/w_pp19_bizon.mdl"
weaponsinfos["m9k_bizonp19"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_bizonp19"].BoneOffset={Vector(0,5.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_smgp90"]={}
weaponsinfos["m9k_smgp90"].Model="models/weapons/w_fn_p90.mdl"
weaponsinfos["m9k_smgp90"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_smgp90"].BoneOffset={Vector(5.5,3,4.2),Angle(90,0,100)}

weaponsinfos["m9k_mp5"]={}
weaponsinfos["m9k_mp5"].Model="models/weapons/w_hk_mp5.mdl"
weaponsinfos["m9k_mp5"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mp5"].BoneOffset={Vector(3,5.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_mp7"]={}
weaponsinfos["m9k_mp7"].Model="models/weapons/w_mp7_silenced.mdl"
weaponsinfos["m9k_mp7"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mp7"].BoneOffset={Vector(10,-2,3.5),Angle(90,0,100)}

weaponsinfos["m9k_ump45"]={}
weaponsinfos["m9k_ump45"].Model="models/weapons/w_hk_ump45.mdl"
weaponsinfos["m9k_ump45"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_ump45"].BoneOffset={Vector(2,5.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_usc"]={}
weaponsinfos["m9k_usc"].Model="models/weapons/w_hk_usc.mdl"
weaponsinfos["m9k_usc"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_usc"].BoneOffset={Vector(1.5,3.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_kac_pdw"]={}
weaponsinfos["m9k_kac_pdw"].Model="models/weapons/w_kac_pdw.mdl"
weaponsinfos["m9k_kac_pdw"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_kac_pdw"].BoneOffset={Vector(1,3.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_vector"]={}
weaponsinfos["m9k_vector"].Model="models/weapons/w_kriss_vector.mdl"
weaponsinfos["m9k_vector"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_vector"].BoneOffset={Vector(0,4.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_magpulpdr"]={}
weaponsinfos["m9k_magpulpdr"].Model="models/weapons/w_magpul_pdr.mdl"
weaponsinfos["m9k_magpulpdr"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_magpulpdr"].BoneOffset={Vector(7,3,4.2),Angle(90,0,100)}

weaponsinfos["m9k_mp40"]={}
weaponsinfos["m9k_mp40"].Model="models/weapons/w_mp40smg.mdl"
weaponsinfos["m9k_mp40"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mp40"].BoneOffset={Vector(-2,2,5),Angle(90,0,100)}

weaponsinfos["m9k_mp5sd"]={}
weaponsinfos["m9k_mp5sd"].Model="models/weapons/w_hk_mp5sd.mdl"
weaponsinfos["m9k_mp5sd"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mp5sd"].BoneOffset={Vector(-1,5.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_mp9"]={}
weaponsinfos["m9k_mp9"].Model="models/weapons/w_brugger_thomet_mp9.mdl"
weaponsinfos["m9k_mp9"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_mp9"].BoneOffset={Vector(2,4,4.2),Angle(90,0,100)}

weaponsinfos["m9k_sten"]={}
weaponsinfos["m9k_sten"].Model="models/weapons/w_sten.mdl"
weaponsinfos["m9k_sten"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_sten"].BoneOffset={Vector(-3,3,10.2),Angle(90,100,90)}

weaponsinfos["m9k_tec9"]={}
weaponsinfos["m9k_tec9"].Model="models/weapons/w_intratec_tec9.mdl"
weaponsinfos["m9k_tec9"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_tec9"].BoneOffset={Vector(0,2,4.2),Angle(0,0,90)}

weaponsinfos["m9k_thompson"]={}
weaponsinfos["m9k_thompson"].Model="models/weapons/w_tommy_gun.mdl"
weaponsinfos["m9k_thompson"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_thompson"].BoneOffset={Vector(5,3.5,4.2),Angle(90,0,100)}

weaponsinfos["m9k_uzi"]={}
weaponsinfos["m9k_uzi"].Model="models/weapons/w_uzi_imi.mdl"
weaponsinfos["m9k_uzi"].Bone="ValveBiped.Bip01_R_Clavicle"
weaponsinfos["m9k_uzi"].BoneOffset={Vector(9,2.5,4.2),Angle(90,0,100)}

function LPGB(dotrace)
    if !dotrace then
    for i=0,LocalPlayer():GetBoneCount()-1 do
        print(LocalPlayer():GetBoneName(i))
    end
    else
    local entity=LocalPlayer():GetEyeTrace().Entity
    if !IsValid(entity) then return end
    for i=0,entity:GetBoneCount()-1 do
        print(entity:GetBoneName(i))
    end
    end
end
 
local function CalcOffset(pos,ang,off)
        return pos + ang:Right() * off.x + ang:Forward() * off.y + ang:Up() * off.z;
end
     
local function clhasweapon(pl,weaponclass)
    for i,v in pairs(pl:GetWeapons()) do
        if string.lower(v:GetClass())==string.lower(weaponclass) then return true end
    end
     
    return false;
end
 
local function clgetweapon(pl,weaponclass)
    for i,v in pairs(pl:GetWeapons()) do
        if string.lower(v:GetClass())==string.lower(weaponclass) then return v end
    end
     
    return nil;
end
 
local function playergettf2class(ply)
    return ply:GetPlayerClass()
end
 
local function IsTf2Class(ply)
   return LocalPlayer().IsHL2 && !LocalPlayer():IsHL2()
end
 
local function GetHolsteredWeaponTable(ply,indx)
    local class=IsTf2Class(ply) and playergettf2class(ply) or nil
    if !class then  return weaponsinfos[indx]
    else return (weaponsinfos[indx] && weaponsinfos[indx][class]) and weaponsinfos[indx][class] or nil
    end
end
 
local function thinkdamnit()
    if !holsteredgunsconvar:GetBool() then return end
    for _,pl in pairs(player.GetAll()) do
        if !IsValid(pl) then continue end
         
        if !pl.CL_CS_WEPS then
            pl.CL_CS_WEPS={}
        end
         
        if !pl:Alive() then pl.CL_CS_WEPS={} continue end
         
        if NEXT_WEAPONS_UPDATE<CurTime() then
            pl.CL_CS_WEPS={} 
            NEXT_WEAPONS_UPDATE=CurTime()+5
        end
         
        for i,v in pairs(pl:GetWeapons())do
            if !IsValid(v) then continue; end
             
            if pl.CL_CS_WEPS[v:GetClass()] then continue end
             
            if !pl.CL_CS_WEPS[v:GetClass()] then
                local worldmodel=v.WorldModelOverride or v.WorldModel
                local attachedwmodel=v.AttachedWorldModel;
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).Model then
                    worldmodel=GetHolsteredWeaponTable(pl,v:GetClass()).Model
                end
                if !worldmodel || worldmodel=="" then continue end;
                 
                 
                pl.CL_CS_WEPS[v:GetClass()]=ClientsideModel(worldmodel,RENDERGROUP_OPAQUE)
                pl.CL_CS_WEPS[v:GetClass()]:SetNoDraw(true)
                pl.CL_CS_WEPS[v:GetClass()]:SetSkin(v:GetSkin())
                pl.CL_CS_WEPS[v:GetClass()]:SetColor(v:GetColor())
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).Scale then
                    pl.CL_CS_WEPS[v:GetClass()]:SetModelScale(GetHolsteredWeaponTable(pl,v:GetClass()).Scale);
                end
                 
                if GetHolsteredWeaponTable(pl,v:GetClass()) && GetHolsteredWeaponTable(pl,v:GetClass()).BBP then
                    pl.CL_CS_WEPS[v:GetClass()].BuildBonePositions=GetHolsteredWeaponTable(pl,v:GetClass()).BBP;
                end
                 
                if v.MaterialOverride || v:GetMaterial() then
                    pl.CL_CS_WEPS[v:GetClass()]:SetMaterial(v.MaterialOverride || v:GetMaterial())
                end
                if worldmodel == "models/weapons/w_models/w_shotgun.mdl" then
                    pl.CL_CS_WEPS[v:GetClass()]:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
                end
                 
                pl.CL_CS_WEPS[v:GetClass()].WModelAttachment=v.WModelAttachment
                pl.CL_CS_WEPS[v:GetClass()].WorldModelVisible=v.WorldModelVisible
                 
                 
                if attachedwmodel then
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel=ClientsideModel(attachedwmodel,RENDERGROUP_OPAQUE)
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetNoDraw(true)
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetSkin(v:GetSkin())
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:SetParent(pl.CL_CS_WEPS[v:GetClass()])
                    pl.CL_CS_WEPS[v:GetClass()].AttachedModel:AddEffects( EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES )
                end
            end
        end
    end
end
 
local function playerdrawdamnit(pl,legs)
    if !holsteredgunsconvar:GetBool() then return end
    if !IsValid(pl) then return end
    if !pl.CL_CS_WEPS then return end
    for i,v in pairs(pl.CL_CS_WEPS) do
 
             
        if GetHolsteredWeaponTable(pl,i) && (pl:GetActiveWeapon()==NULL || pl:GetActiveWeapon():GetClass()~=i) && clhasweapon(pl,i) then
            if GetHolsteredWeaponTable(pl,i).Priority then
                local priority=GetHolsteredWeaponTable(pl,i).Priority
                local bol=GetHolsteredWeaponTable(pl,priority) && (pl:GetActiveWeapon()==NULL || pl:GetActiveWeapon():GetClass()!=priority) && clhasweapon(pl,priority)
                if bol then continue; end
            end
             
            local oldpl=pl;
            local wep=clgetweapon(oldpl,i)
             
            if legs && IsValid(legs) then
            pl=legs;
            end
             
            if legs && IsValid(legs) && (string.find(string.lower(GetHolsteredWeaponTable(oldpl,i).Bone),"spine") or string.find(string.lower(GetHolsteredWeaponTable(oldpl,i).Bone),"clavi") ) then
            pl=oldpl;
            continue;
            end
             
            local bone=pl:LookupBone(GetHolsteredWeaponTable(oldpl,i).Bone or "")
            if !bone then pl=oldpl;continue; end
 
             
            local matrix = pl:GetBoneMatrix(bone)
            if !matrix then pl=oldpl;continue; end
            local pos = matrix:GetTranslation()
			local ang = matrix:GetAngles()
            local pos=CalcOffset(pos,ang,GetHolsteredWeaponTable(oldpl,i).BoneOffset[1])
            if GetHolsteredWeaponTable(oldpl,i).Skin then v:SetSkin(GetHolsteredWeaponTable(oldpl,i).Skin) end
             
            v:SetRenderOrigin(pos)
             
            ang:RotateAroundAxis(ang:Forward(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].p)
            ang:RotateAroundAxis(ang:Up(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].y)
            ang:RotateAroundAxis(ang:Right(),GetHolsteredWeaponTable(oldpl,i).BoneOffset[2].r)
             
            v:SetRenderAngles(ang)
            if v.WorldModelVisible==nil || (v.WorldModelVisible!=false) then
                v:DrawModel();
            end
             
            if IsValid(v.AttachedModel) then
                v.AttachedModel:DrawModel();
            end
            if v.WModelAttachment && multimodel then
                multimodel.Draw(v.WModelAttachment, wep, {origin=pos, angles=ang})
                multimodel.DoFrameAdvance(v.WModelAttachment, CurTime(),wep)
            end
             
            if GetHolsteredWeaponTable(oldpl,i).DrawFunction then
                GetHolsteredWeaponTable(oldpl,i).DrawFunction(v,oldpl)
            end
            pl=oldpl;
        end
    end
end
 
local function drawlegsdamnit(legs)
    playerdrawdamnit(LocalPlayer(),legs)
end
 
hook.Add("PostLegsDraw","HG_DrawOnLegs",drawlegsdamnit)
hook.Add("Think","HG_Think",thinkdamnit)
hook.Add("PostPlayerDraw","HG_Draw",playerdrawdamnit)