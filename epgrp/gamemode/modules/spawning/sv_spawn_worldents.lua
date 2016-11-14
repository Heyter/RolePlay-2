function SpawnNPCs( )	
	for k, v in pairs( ents.GetAll() ) do
		if v:GetClass() == "npc_ventor" then v:Remove() end
	end
	
    LoadNPCSpawns()
	timer.Simple( 10, function()
		for name, spawndata in pairs( NPC_SPAWNS or {} ) do
			
			local pos = spawndata.pos
			local ang = spawndata.ang
            
			local npc = ents.Create( "npc_ventor" )
			npc:SetPos( pos )
			npc:SetAngles( ang )
            npc.spawndata = spawndata
			npc:Spawn()
			npc:Activate()
            if string.len(NPC_SPAWNS[name].model) > 2 then
                npc:SetModel( NPC_SPAWNS[name].model )
            end
            spawndata.sequence = spawndata.sequence or nil
            if !(spawndata.sequence == nil) then
                npc:SetRPVar( "sequence", spawndata.sequence )
            end
		end
		timer.Simple( 1, function() CreateAllEnts() end )
	end)
end

function SpawnEnt( ent, pos, ang, mdl )
	if ent == "prop_physics" then
		local entity = ents.Create( ent )
		entity:SetPos( pos )
		entity:SetModel( mdl )
		entity:SetAngles( ang )
		entity:Spawn()
		local phys = entity:GetPhysicsObject()
		phys:EnableMotion( false )
		phys:SetMass(300)
	else
		local entity = ents.Create( ent )
		entity:SetPos( pos )
		entity:SetAngles( ang )
		entity:Spawn()
	end
end

function LoadNPCSpawns()
    NPC_SPAWNS = {}
    NPC_SPAWNS["Police"] = {
        Team = TEAM_POLICE,
        pos = Vector(-7187.291992, -9230, 72),
        ang = Angle( 0, 88.257, 0.000 ),
        model = "models/ecpd/male_05.mdl",
        callfunc = "NPC_PoliceHello",
        teamHello = "NPC_PoliceInTeam"
    }
    NPC_SPAWNS["Firefighter"] = {
        Team = TEAM_FIRE,
        pos = Vector(-3871, -6969, 210),
        ang = Angle( 0, -150, 0),
        model = "models/fearless/fireman2.mdl",
        callfunc = "NPC_FireHello",
        teamHello = "NPC_FireInTeam"
    }
    NPC_SPAWNS["SWAT"] = {
        Team = TEAM_SWAT,
        pos = Vector(-7250, -9230, 72),
        ang = Angle( 0, 90, 0 ),
        model = "models/gign remasteredhdnpc.mdl",
        callfunc = "NPC_SwatHello",
        teamHello = "NPC_SwatInTeam"
    }
    NPC_SPAWNS["SecretService"] = {
        Team = TEAM_SECRETSERVICE,
        pos = Vector(-7343, -9230, 72), 
        ang = Angle( 0, 90, 0.000 ),
        model = "models/Combine_Soldier.mdl",
        callfunc = "NPC_SecretHello",
        teamHello = "NPC_SecretInTeam"
    }
    NPC_SPAWNS["MEDIC"] = {
        Team = TEAM_MEDIC,
        pos = Vector(-9665, 9196, 80),
        ang = Angle( 0, 90, 0 ),
        model = "models/Humans/Group03m/Female_01.mdl",
        callfunc = "NPC_MedicHello",
        teamHello = "NPC_MedicInTeam"
    }
    NPC_SPAWNS["RoadService"] = {
        Team = TEAM_ROAD,
        pos = Vector(529, 4416, 72), 
        ang = Angle( 0, 180, 0 ),
        model = "models/odessa.mdl",
        callfunc = "NPC_RoadHello",
        teamHello = "NPC_RoadInTeam"
    }
    NPC_SPAWNS["HouseRent"] = {
        pos = Vector(-7580.016602, -7814.006836, 72),
        ang = Angle( 0, 0, 0 ),
        model = "models/alyx.mdl",
        callfunc = "NPC_HouseRentHello",
        teamHello = ""
    }
	/*
    NPC_SPAWNS["Bank_1"] = {
        pos = Vector(-7582, -7676, 72),
        ang = Angle( 0, 0, 0 ),
        model = "models/mossman.mdl",
        callfunc = "NPC_BankHello",
        teamHello = ""
    }*/
    NPC_SPAWNS["CarDealer#1"] = {
        pos = Vector(5184, -4718, 64),
        ang = Angle( 0, 90, 0 ),
        model = "models/Humans/Group02/Female_02.mdl",
        callfunc = "NPC_CarDealerHello",
        teamHello = ""
    }
    NPC_SPAWNS["Garage #1"] = {
        pos = Vector(5138, -4718, 64),
        ang = Angle( 0, 90, 0 ),
        model = "models/Humans/Group02/male_02.mdl",
        callfunc = "NPC_GarageHello",
        teamHello = ""
    }
    NPC_SPAWNS["Garage #2"] = {
        pos = Vector(-5382, -10265, 72),
        ang = Angle( 0, 0, 0 ),
        model = "models/Humans/Group02/male_02.mdl",
        callfunc = "NPC_GarageHello",
        teamHello = ""
    }
    NPC_SPAWNS["Name Change #1"] = {
        pos = Vector(-6617, -9202, 95),
        ang = Angle( 0, -90, 0 ),
        model = "models/Humans/Group02/Female_02.mdl",
        callfunc = "NAMECHANGE_HELLO",
        teamHello = "",
        sequence = "Sit_Ground"
    }
end

function CreateAllEnts()
if game.GetMap() == "rp_evocity_v33x" then
	timer.Create("SpawnShops", 2, 1, function()
		--SpawnEnt( 'bank_atm', Vector(-7204.71875, -7923.46875, 72.59375), Angle(0.000 ,90.055 ,0.000), 'models/bankautomat/bankautomat.mdl' )
		--SpawnEnt( 'bank_atm', Vector(-7327.59375, -7923.34375, 72.59375), Angle(0.000 ,90.011 ,0.000), 'models/bankautomat/bankautomat.mdl' )
		--SpawnEnt( 'bank_atm', Vector(-7448.15625, -7923.46875, 72.625), Angle(0.044 ,89.923 ,-0.088), 'models/bankautomat/bankautomat.mdl' )
		--SpawnEnt( 'bank_atm', Vector(-7454, -7478.40625, 72.40625), Angle(0.000 ,-90.011 ,0.000), 'models/bankautomat/bankautomat.mdl' )
		--SpawnEnt( 'bank_atm', Vector(-7330.4375, -7478.46875, 72.59375), Angle(0.088 ,-89.967 ,0.088), 'models/bankautomat/bankautomat.mdl' )
        SpawnEnt( 'npc_newdrug', Vector(-9364, -9572, 75), Angle(0, 180, 0), '' )
        --SpawnEnt( 'npc_cardealer', Vector(5184.598145, -4718.879395, 64.031250), Angle(0, 91.459, 0), '' )	
        --SpawnEnt( 'npc_cardealer_garage', Vector(4577.999512, -3804.216553, 64.031250), Angle(0, 180, 0), '' )

		
		SpawnEnt( 'ent_gaspump', Vector(-6533.1459960938, -6582.296875, 72.305557250977), Angle(0.000, 90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(-6449.5356445313, -6582.6518554688, 72.30549621582), Angle(0.000, -90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(-6450.359375, -6288.068359375, 72.305557250977), Angle(0.000, -90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(-6531.1577148438, -6288.1206054688, 72.305557250977), Angle(0.000, 90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(-6449.2719726563, -5992.8857421875, 72.305511474609), Angle(0.000, -90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(-6531.9252929688, -5992.6708984375, 72.305557250977), Angle(0.000, 90.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10975.532226563, 13270.958007813, 66.305557250977), Angle(0.000, 0.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10974.997070313, 13580.907226563, 66.276275634766), Angle(0.000, 180.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10740.784179688, 13586.130859375, 66.305557250977), Angle(0.000, 180.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10741.344726563, 13278.27734375, 66.305557250977), Angle(0.000, 0.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10042.737304688, 13268.529296875, 66.305557250977), Angle(0.000, 0.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(10042.854492188, 13584.234375, 66.305557250977), Angle(0.000, 180.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(9809.3349609375, 13279.049804688, 66.305541992188), Angle(0.000, 0.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )
		SpawnEnt( 'ent_gaspump', Vector(9808.6435546875, 13584.049804688, 66.305541992188), Angle(0.000, 180.000, 0.000), 'models/props_wasteland/gaspump001a.mdl' )	
        
        /*
        SpawnEnt( 'e_wall_plugholder', Vector(-807.44775390625, 4656.4580078125, -119.20896911621), Angle(0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-824.57415771484, 4649.541015625, -118.38199615479), Angle(0.001, -89.998, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1011.6186523438, 4430.2080078125, -120.48064422607), Angle(-0.000, -0.001, -0.006), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1202.4370117188, 4656.3901367188, -118.96907806396), Angle(-0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1279.5645751953, 4497.4350585938, -119.93260192871), Angle(-0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1397.5556640625, 4431.3383789063, -116.38751983643), Angle(-0.000, -0.059, -0.203), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1397.4377441406, 4316.6879882813, -115.26756286621), Angle(0.000, 0.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-831.08978271484, 4656.416015625, 22.676586151123), Angle(0.002, 89.999, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-837.86608886719, 4649.6303710938, 22.696296691895), Angle(-0.011, -89.990, 0.088), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1011.51171875, 4431.365234375, 21.136867523193), Angle(-0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1213.232421875, 4656.373046875, 27.04002571106), Angle(-0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1275.5461425781, 4497.361328125, 21.060707092285), Angle(0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1397.6650390625, 4429.037109375, 22.593965530396), Angle(0.004, -0.015, 0.175), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(341.3349609375, 4692.396484375, -182.6457824707), Angle(-0.005, 90.018, -0.039), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(664.13055419922, 4692.4077148438, -181.18434143066), Angle(0.013, 89.950, -0.070), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(525.15014648438, 4692.4721679688, -180.6248626709), Angle(-0.000, 90.000, -0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1144.5693359375, 3246.6169433594, -179.16677856445), Angle(-0.000, 0.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-683.45446777344, 3309.2287597656, -53.106651306152), Angle(0.000, -179.999, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-683.46423339844, 3488.3166503906, -55.352504730225), Angle(-0.000, -180.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-906.59979248047, 3205.9431152344, -51.961978912354), Angle(0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1144.5456542969, 3413.3098144531, -49.873790740967), Angle(0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(337.53845214844, 5199.662109375, -185.30981445313), Angle(-0.001, 179.997, -0.656), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(537.52612304688, 5378.7700195313, -183.44346618652), Angle(-0.000, 180.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(391.18435668945, 5075.59375, -182.64920043945), Angle(0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(337.48190307617, 5654.8740234375, -183.72120666504), Angle(0.012, 179.993, 0.012), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(397.45944213867, 5420.486328125, -181.64483642578), Angle(-0.002, 89.991, 0.041), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(371.89511108398, 5851.4970703125, -180.28402709961), Angle(-0.003, -89.996, 0.242), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(172.98516845703, 5955.5, -55.93380355835), Angle(0.000, -90.000, 0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(102.99881744385, 5514.4223632813, -55.241954803467), Angle(0.000, 90.000, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(366.76623535156, 5748.3500976563, -57.196762084961), Angle(-0.000, 90.000, 0.006), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(126.27188110352, 5075.4638671875, -55.506526947021), Angle(0.003, 90.000, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(92.200500488281, 5509.5400390625, -55.381534576416), Angle(-0.000, -90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(278.349609375, 5074.4897460938, -54.991123199463), Angle(0.000, 90.194, -0.035), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(400.51800537109, 5074.4140625, -55.651523590088), Angle(0.001, 90.005, 0.167), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(157.5749206543, 5393.240234375, 74.255073547363), Angle(-0.000, 179.999, -0.007), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(173.43487548828, 5074.3959960938, 76.405548095703), Angle(-0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(162.35215759277, 5424.0517578125, 77.660804748535), Angle(-0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(114.83811187744, 5648.474609375, 78.618370056152), Angle(-0.000, 90.000, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(333.02615356445, 5955.5678710938, 76.591407775879), Angle(-0.001, -89.997, 0.009), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(107.84574890137, 5955.5834960938, 76.121894836426), Angle(0.000, -90.012, 0.019), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(18.339622497559, 5538.7573242188, 83.305641174316), Angle(0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(337.53256225586, 5541.857421875, 77.459686279297), Angle(-0.000, -179.999, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-751.49761962891, 6713.0473632813, -168.34451293945), Angle(-0.014, 135.021, -0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-860.85943603516, 7433.4560546875, -171.48860168457), Angle(0.001, -89.999, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1440.6484375, 7433.5849609375, -170.99591064453), Angle(0.047, -90.203, 0.630), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1495.5554199219, 7069.7065429688, -168.5256652832), Angle(-0.000, -0.034, -0.077), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1416.4429931641, 6640.447265625, -169.06053161621), Angle(-0.014, 89.978, 0.046), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1859.4682617188, 6305.9775390625, -169.05332946777), Angle(0.000, 180.000, 0.006), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-2173.7983398438, 6351.5395507813, -36.926887512207), Angle(0.000, -90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-622.55682373047, 3538.6271972656, -185.15374755859), Angle(-0.006, -89.930, 0.296), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-632.06915283203, 3041.4926757813, -181.55120849609), Angle(0.122, 90.153, -0.348), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(21.255361557007, 3651.4328613281, -181.86567687988), Angle(-0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(50.398998260498, 3579.8559570313, -181.83671569824), Angle(-0.001, 0.018, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(320.52615356445, 4093.7229003906, -184.25367736816), Angle(-0.000, 180.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(12.612205505371, 4135.5244140625, -179.79580688477), Angle(0.000, -90.004, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(50.499797821045, 3587.4453125, -36.046127319336), Angle(-0.000, -0.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(13.32377910614, 3651.2924804688, -36.349067687988), Angle(-0.003, 89.993, -0.011), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(320.61483764648, 4101.9423828125, -36.801578521729), Angle(-0.008, 179.965, 0.038), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(3.1354718208313, 4135.6137695313, -35.335468292236), Angle(-0.000, -90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-164.41761779785, 6618.6079101563, -540.17987060547), Angle(0.000, 180.000, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-164.49476623535, 6440.8823242188, -540.63244628906), Angle(0.000, -179.989, 0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-448.60827636719, 6597.2836914063, -536.82025146484), Angle(-0.000, -0.000, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-448.64697265625, 6399.560546875, -539.8095703125), Angle(-0.000, -0.000, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-179.3076171875, 6092.5, -539.77642822266), Angle(-0.000, 90.000, -0.076), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-212.58522033691, 6345.5859375, -535.18463134766), Angle(0.000, -90.000, 0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-620.08422851563, 5555.50390625, -554.55285644531), Angle(0.013, 90.014, -0.009), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-262.35394287109, 5917.11328125, -550.90606689453), Angle(0.000, 180.000, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1334.4067382813, 4146.4155273438, -537.04339599609), Angle(0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4556.9995117188, 6042.638671875, -176.77325439453), Angle(0.000, -90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4844.5151367188, 6042.5473632813, -173.55207824707), Angle(-0.000, -90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4567.8774414063, 5701.4677734375, -173.18704223633), Angle(-0.000, 90.036, 0.048), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4504.4653320313, 5540.91796875, -172.74694824219), Angle(-0.000, -0.002, -0.004), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4858.6826171875, 5507.4228515625, -171.01586914063), Angle(-0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4539.0087890625, 5494.53125, -175.26119995117), Angle(0.000, -90.007, 0.032), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4838.71484375, 5494.6049804688, -175.16091918945), Angle(0.000, -90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4579.7407226563, 5153.390625, -176.25491333008), Angle(0.010, 90.030, 0.038), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4504.3823242188, 4989.66015625, -175.75665283203), Angle(0.015, 0.018, 0.054), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4888.228515625, 4959.3891601563, -173.96961975098), Angle(-0.002, 90.005, 0.092), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6037.3872070313, 5615.544921875, -167.7491607666), Angle(0.002, -0.003, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6037.4194335938, 5870.7485351563, -167.66612243652), Angle(0.000, -0.001, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6382.9575195313, 6039.6357421875, -168.22840881348), Angle(0.000, -90.001, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6164.4990234375, 6039.6513671875, -164.32763671875), Angle(-0.009, -90.013, 0.396), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6225.1713867188, 5298.4985351563, -165.4031829834), Angle(0.049, 89.973, 0.024), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6455.7114257813, 5246.3178710938, -163.54553222656), Angle(0.061, 179.815, 0.221), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6167.625, 5098.3823242188, -166.21473693848), Angle(0.095, 90.080, -0.119), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(5927.4516601563, 5232.6123046875, -165.37805175781), Angle(0.001, 0.005, -0.015), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6154.0048828125, 5291.6352539063, -165.02876281738), Angle(-0.013, -89.979, -0.012), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6080.8759765625, 3162.4777832031, -173.81568908691), Angle(-0.000, 90.002, 0.014), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6195.2641601563, 3074.1394042969, -177.36709594727), Angle(-0.002, -0.298, -0.363), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6324.01953125, 2918.3681640625, -177.07743835449), Angle(-0.000, 90.001, -0.005), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6957.5234375, 3267.8840332031, -160.16949462891), Angle(0.029, 179.971, 0.022), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6957.673828125, 3105.2124023438, -162.20121765137), Angle(0.000, -179.999, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6745.326171875, 3413.6525878906, -173.97874450684), Angle(0.025, -90.018, 0.031), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6763.7348632813, 2918.4558105469, -175.19107055664), Angle(-0.000, 90.043, -0.047), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6659.0346679688, -2999.6606445313, -190.67457580566), Angle(0.020, 89.911, -0.088), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6465.9331054688, -2999.69921875, -190.0099029541), Angle(-0.011, 89.952, 0.063), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6691.7084960938, -2481.4819335938, -189.77262878418), Angle(-0.000, 179.999, 0.004), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6306.5639648438, -2750.3076171875, -59.990665435791), Angle(-0.000, -89.997, -0.010), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6314.0405273438, -3422.4282226563, -61.530075073242), Angle(0.027, -89.951, -0.140), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6658.8974609375, -3671.560546875, -188.47351074219), Angle(0.008, 89.989, 0.053), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6448.431640625, -3671.5456542969, -188.0654296875), Angle(-0.029, 90.090, -0.396), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6691.7036132813, -3138.8635253906, -188.5041809082), Angle(-0.074, 179.992, 0.661), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6168.6293945313, -6267.6206054688, -121.36722564697), Angle(-0.004, 90.027, -0.047), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6167.8173828125, -5500.4145507813, -124.0651473999), Angle(0.000, -90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6341.7192382813, -5500.4409179688, -178.75769042969), Angle(0.001, -90.118, 0.295), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6695.1713867188, -5500.4780273438, -174.21934509277), Angle(0.000, -90.032, 0.009), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6766.6904296875, -5969.2456054688, -178.06796264648), Angle(-0.005, -179.977, -0.096), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(6255.421875, -6156.8784179688, -172.83418273926), Angle(-0.000, -0.005, -0.042), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4963.4248046875, -4465.93359375, -179.8171081543), Angle(0.004, -0.030, -0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.3256835938, -4321.693359375, -179.24070739746), Angle(0.016, -0.042, 0.004), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.3969726563, -4152.5849609375, -176.73318481445), Angle(-0.192, -0.064, 0.559), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.4365234375, -4060.3806152344, -179.11711120605), Angle(0.000, 0.008, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.369140625, -3893.4245605469, -180.6526184082), Angle(-0.000, 0.001, 0.011), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(5286.5249023438, -4036.3461914063, -179.54447937012), Angle(-0.002, -90.031, 0.052), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.4208984375, -4683.267578125, -179.4292755127), Angle(0.000, -0.074, -0.039), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4574.4165039063, -4448.1411132813, -180.34675598145), Angle(0.261, 0.234, -0.588), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4874.7001953125, -4365.326171875, -177.13473510742), Angle(-0.014, -89.974, -0.056), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4508.4018554688, -6370.564453125, -185.39649963379), Angle(0.005, 90.004, -0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(3676.9506835938, -6370.5087890625, -187.41136169434), Angle(0.122, 90.338, -0.942), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(2899.3986816406, -6279.490234375, -182.57475280762), Angle(0.022, -0.075, 0.169), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(2899.4296875, -5717.7602539063, -185.10722351074), Angle(-0.056, 0.004, -0.084), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(3023.7612304688, -5363.38671875, -183.91744995117), Angle(0.000, -90.000, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(3836.802734375, -5363.3295898438, -186.21000671387), Angle(-0.005, -90.003, -0.006), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(4504.8725585938, -5363.5615234375, -185.97050476074), Angle(-0.174, -89.834, 0.074), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(5125.9165039063, -5363.4555664063, -183.02848815918), Angle(0.000, -90.001, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(5244.6206054688, -5742.1557617188, -183.02098083496), Angle(0.003, -179.984, -0.048), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1917.5650634766, -903.44171142578, -176.21307373047), Angle(-0.000, -90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1688.4025878906, -1094.2369384766, -178.76171875), Angle(-0.022, 179.986, 0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1816.4515380859, -689.69610595703, -176.00657653809), Angle(0.001, 179.995, 0.016), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1946.955078125, -647.62829589844, -172.3283996582), Angle(0.000, 90.000, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-1761.1334228516, -90.328063964844, -175.6932220459), Angle(0.010, -90.016, 0.003), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-2042.0415039063, -90.41081237793, -175.76052856445), Angle(0.001, -90.178, 0.185), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-2007.8845214844, -444.65438842773, -180.57229614258), Angle(-0.002, 90.001, -0.012), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3527.26953125, -19.396553039551, -174.5811920166), Angle(0.000, -90.002, 0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3100.4304199219, -370.49368286133, -178.04475402832), Angle(-0.000, 179.990, 0.029), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3100.3981933594, -555.57781982422, -178.5699005127), Angle(0.000, -179.999, -0.002), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3419.6081542969, -543.92620849609, -174.458984375), Angle(0.009, 0.036, 0.008), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3611.6066894531, -426.91421508789, -177.68055725098), Angle(0.009, 0.016, 0.207), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4218.63671875, -2156.5747070313, -176.93133544922), Angle(-0.000, 90.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3964.3515625, -1996.3254394531, -175.92575073242), Angle(-0.000, -180.00, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3957.6281738281, -1981.1806640625, -176.82464599609), Angle(0.084, -0.152, -0.585), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3957.6635742188, -2124.0229492188, -176.91160583496), Angle(-0.001, 0.003, -0.012), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3742.3171386719, -2052.3715820313, -174.55473327637), Angle(-0.001, -179.994, -0.021), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4193.8891601563, -19.511064529419, -175.05851745605), Angle(0.016, -89.987, -0.012), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4412.515625, -611.69470214844, -177.03015136719), Angle(-0.003, -179.997, -0.008), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4597.517578125, -573.41638183594, -172.72787475586), Angle(0.000, -0.000, -0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4597.60546875, -366.74371337891, -173.24639892578), Angle(0.000, -0.000, 0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4086.3779296875, -487.18560791016, -175.16641235352), Angle(0.010, 179.933, 0.128), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-6402.1865234375, -2192.1376953125, -184.18110656738), Angle(0.001, 90.001, -0.001), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-6134.3920898438, -2192.5986328125, -187.19929504395), Angle(0.003, 89.984, 0.007), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-6831.5844726563, -2152.1552734375, -184.32609558105), Angle(-0.000, -0.012, -0.009), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-6831.6157226563, -2314.8439941406, -186.43258666992), Angle(0.044, -0.124, 0.066), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4770.3984375, 203.18507385254, -176.55773925781), Angle(0.011, -179.868, -0.506), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4973.4809570313, 588.50836181641, -177.25511169434), Angle(-0.001, -89.837, 0.302), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4514.4033203125, 554.64819335938, -177.01307678223), Angle(0.002, -179.999, -0.009), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4514.4301757813, 712.9775390625, -176.03388977051), Angle(-0.012, -179.876, -0.168), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-2194.5034179688, 5210.0068359375, -144.92729187012), Angle(-0.087, -179.764, 0.832), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-2194.5048828125, 5382.6875, -145.01983642578), Angle(0.007, -179.579, 0.755), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4634.6875, 2424.8591308594, -1826.7850341797), Angle(0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4316.53515625, 2202.03125, -1826.408203125), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4206.3017578125, 2143.03125, -1828.6710205078), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3630.2978515625, 2420.8999023438, -1826.4410400391), Angle(0.000, -180.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3916.6962890625, 2202.03125, -1826.3139648438), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4027.28125, 2143.03125, -1827.5555419922), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3636.2978515625, 2833.7094726563, -1825.4029541016), Angle(0.000, 180.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3922.8193359375, 2592.0229492188, -1828.4587402344), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4028.7319335938, 2533.03125, -1829.1187744141), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3630.2978515625, 1622.8369140625, -1825.4382324219), Angle(0.000, -180.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3914.4401855469, 1387.03125, -1825.6550292969), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4021.8168945313, 1328.03125, -1827.8532714844), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4634.6875, 1585.5061035156, -1828.9210205078), Angle(0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4315.8022460938, 1381.03125, -1827.3559570313), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4206.4970703125, 1322.03125, -1826.5799560547), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3624.2978515625, 1219.2719726563, -1823.6309814453), Angle(0.000, -180.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-3909.2917480469, 997.03125, -1827.1916503906), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4641.6875, 1211.9150390625, -1825.6691894531), Angle(0.000, 0.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4324.0268554688, 997.03125, -1827.9200439453), Angle(0.000, 90.000, 0.000), "" )
        SpawnEnt( 'e_wall_plugholder', Vector(-4214.62109375, 938.03125, -1828.1610107422), Angle(0.000, 90.000, 0.000), "" )        
        */
        
		for k, v in pairs(ents.FindByClass("prop_dynamic")) do
			if v:GetModel() == "models/props_equipment/gas_pump.mdl" then
				v:Remove()
			end
		end
	end)
end
end