AddCSLuaFile()

EMV_DEBUG = false

local name = "C5500 Ambulance"

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"


// RUNNING LIGHT DATA

local PI = {}

PI.Meta = {

	tail_light = {
		AngleOffset = 90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 2,
		VisRadius = 0
	},

	headlight = {
		AngleOffset = -90,
		W = 7.5,
		H = 5,
		Sprite = "sprites/emv/square_src",
		Scale = 1.4,
		VisRadius = 0
	},

	reverse_lights = {
		AngleOffset = 90,
		W = 6,
		H = 6,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.8,
		VisRadius = 0
	},
	reverse_lights_top = {
		AngleOffset = 90,
		W =8,
		H = 8,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.5,
		VisRadius = 0
	},
	runninglight = {
		AngleOffset = -90,
		W = 11,
		H = 15,
		Sprite = "sprites/emv/emv_whelen_src",
		Scale = 1.6,
		VisRadius = 0
	},
	sidelights_r = {
		AngleOffset = 90,
		W = 10.7,
		H = 10,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 2.6,
	},
	turnsignal_f = {
		AngleOffset = -90,
		W = 15,
		H = 15,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.4,
		WMult = 1.2,
		VisRadius = 0
	},
	turnsignal_r = {
		AngleOffset = 90,
		W = 15,
		H = 15,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.4,
		WMult = 1.2,
		VisRadius = 0
	},
}

PI.Positions = {

	[1] = { Vector( -39.2, -178.5, 23.9 ), Angle(0,0,0), "tail_light" },
	[2] = { Vector( 39.35, -178.5, 23.6 ), Angle(0,0,0), "tail_light" },
	 
	[3] = { Vector( -32.2, -178.5, 24 ), Angle(0,0,0), "reverse_lights" },
	[4] = { Vector( 32.4, -178.5, 23.6 ), Angle(0,0,0), "reverse_lights" },
	
	[5] = { Vector( -43.5, 105.5, 38 ), Angle(0,0,0), "headlight" },
	[6] = { Vector( 43.5, 105.5, 38 ), Angle(0,0,0), "headlight" },
	 
	[7] = { Vector( 13.5, 118, 24), Angle(0,0,0), "runninglight" },
	[8] = { Vector( -13.5, 118, 24), Angle(0,0,0), "runninglight" },
	
	[9] = { Vector( 0.3, -177, 107.2), Angle(0,0,0), "reverse_lights_top" },
	
	[10] = { Vector( 9, -177, 107.2), Angle(0,0,0), "reverse_lights_top" },
	[11] = { Vector( -8.2, -177, 107.2), Angle(0,0,0), "reverse_lights_top" },
	
	[12] = {Vector(-36.2, -176.2, 40.6), Angle(0,0,0), "sidelights_r" },
	[13] = {Vector(36.2, -176.2, 40.6), Angle(0,0,0), "sidelights_r" },
	
	[14] = {Vector(-46.4, 107.5, 50.2), Angle(0,0,0), "turnsignal_f" },
	[15] = {Vector(-46.4, 104.5, 50.2), Angle(0,0,0), "turnsignal_r" },
	
	[16] = {Vector(46.4, 107.5, 50.2), Angle(0,0,0), "turnsignal_f" },
	[17] = {Vector(46.4, 104.5, 50.2), Angle(0,0,0), "turnsignal_r" },

}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 }, {9, DR, 1 },
}

PI.States.Blink_Left = {
{12,A,1},{14,A,1},{15,A,1},
}
PI.States.Blink_Right = {
{13,A,1},{16,A,1},{17,A,1},
}

PI.States.Reverse = {
	{ 3, SW }, { 4, SW }, {10,SW},{11,SW},
}

PI.States.Running = {
	{ 5, SW, .5 }, { 6, SW, .5 }, 
	{ 7,A,1},{8,A,1},
	{ 1, DR, .25 }, { 2, DR, .25 }, {9, DR, .40 },
}

Photon.VehicleLibrary["sgm_g5500ambu"] = PI

// EMV DATA

local EMV = {}

EMV.Siren = 3

EMV.Color = Color( 255, 255, 255 )
EMV.Skin = 0

EMV.BodyGroups = {}

EMV.Props = {}

EMV.Meta = {
	siren_main = {
		AngleOffset = "-90",
		W =10,
		H =6.4,
		Sprite = "sprites/emv/square_src",
		WMult = 2,
		Scale = 1.8,
	},
	siren_small = {
		AngleOffset = "-90",
		W =6.3,
		H =6.4,
		Sprite = "sprites/emv/square_src",
		WMult = 2,
		Scale = 1.8,
	},
	test_light = {
		AngleOffset = 90,
		W = 15,
		H = 15,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.4,
		WMult = 1.2,
		VisRadius = 0
	},
	headlight = {
		AngleOffset = -90,
		W = 7.5,
		H = 5,
		Sprite = "sprites/emv/square_src",
		Scale = 1.4,
		VisRadius = 0
	},
	grilllight = {
		AngleOffset = -90,
		W = 6.9,
		H = 4.3,
		Sprite = "sprites/emv/square_src",
		Scale = 1.75,
	},
	toputil_light_f = {
		AngleOffset = -90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.1,
		VisRadius = 0
	},
	toputil_light_r = {
		AngleOffset = 90,
		W = 10,
		H = 10,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.3,
		VisRadius = 0
	},
	sidelights_f = {
		AngleOffset = -90,
		W = 10.7,
		H = 10,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 2.6,
	},
	sidelights_r = {
		AngleOffset = 90,
		W = 10.7,
		H = 10,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 2.6,
	},
	sidelightssmall_f = {
		AngleOffset = -90,
		W = 9,
		H = 5,
		Sprite = "sprites/emv/emv_lightglow",
		Scale = 1.4,
	},
	cockpit_light = {
		AngleOffset = 90,
		W = 3,
		H = 3,
		Sprite = "sprites/emv/emv_lightglow",
		WMult =.4,
		Scale = .2,
		VisRadius = 0
	},
	
}		



EMV.Positions = {
// SIREN LIGHTS
	[1] = {Vector(0, 15, 103), Angle(0,0,0), "siren_main" },
	[2] = {Vector(10.8, 15, 103), Angle(0,0,0), "siren_main" },
	[3] = { Vector( 20.7,15, 103), Angle(0,0,0), "siren_main" },
	[4] = { Vector( 30.7,15, 103 ), Angle(0,0,0), "siren_main" },
	[5] = {Vector(39, 15, 103), Angle(0,0,0), "siren_small" },
	[6] = {Vector(-9.8, 15, 103), Angle(0,0,0), "siren_main" },	 
	[7] = {Vector(-19.9,15, 103), Angle(0,0,0), "siren_main" },
	[8] = {Vector(-30, 15, 103.3), Angle(0,0,0), "siren_main" },
	[9] = {Vector(-38.3, 15, 103.3), Angle(0,0,0), "siren_small" },
	
// HEADLIGHTS	
	 [10] = { Vector( -35.5, 109, 38.2 ), Angle(0,0,0), "headlight" },
	 [11] = { Vector( 35.5, 109, 38 ), Angle(0,0,0), "headlight" },
	 [12] = { Vector( -43.5, 105.5, 38 ), Angle(0,0,0), "headlight" },
	 [13] = { Vector( 43.5, 105.5, 38 ), Angle(0,0,0), "headlight" },

//GRILL LIGHTS	 
	 [14] = { Vector( -19.3, 119.6, 42.5 ), Angle(0,0,0), "grilllight" },
	 [15] = { Vector(  19.3, 119.6, 42.5 ), Angle(0,0,0), "grilllight" },
	 
	 [16] = { Vector(-51.5, 91.2, 46), Angle(5,90,5), "grilllight" },
	 [17] = { Vector(51.55, 91.2, 46), Angle(-5,-90,8), "grilllight" },
	 
// TOP UTIL LIGHTS
	[18] = { Vector(0.5, 45.8, 92), Angle(0,0,30), "toputil_light_f" },
	[19] = { Vector(8, 45.9, 92), Angle(0,0,30), "toputil_light_f" },
	[20] = { Vector(-7.3, 45.8, 92), Angle(0,0,30), "toputil_light_f" },
	[21] = { Vector(25.5, 44.1, 90.3), Angle(0,0,30), "toputil_light_f" },
	[22] = { Vector(-24.5, 44.1, 90.5), Angle(0,0,30), "toputil_light_f" },

	[23] = { Vector(0.5, 45.8, 92), Angle(0,0,30), "toputil_light_r" },
	[24] = { Vector(8, 45.9, 92), Angle(0,0,30), "toputil_light_r" },
	[25] = { Vector(-7.3, 45.8, 92), Angle(0,0,30), "toputil_light_r" },
	[26] = { Vector(25.5, 44.1, 90.3), Angle(0,0,30), "toputil_light_r" },
	[27] = { Vector(-24.5, 44.1, 90.5), Angle(0,0,30), "toputil_light_r" },

// SIDE RED AND WHITE LIGHTS
--f
[28] = {Vector(20.6, 12.85, 95.6), Angle(0,0,0), "sidelightssmall_f" },
[29] = {Vector(39, 12.8, 94.3), Angle(0,0,0), "sidelights_f" },
[30] = {Vector(-20.6, 12.85, 95.6), Angle(0,0,0), "sidelightssmall_f" },
[31] = {Vector(-38.2, 12.8, 94.5), Angle(0,0,0), "sidelights_f" },
--r
[32] = {Vector(52.4, -2.3, 99), Angle(0,-90,0), "sidelights_f" },
[33] = {Vector(52.4, -28.5, 99), Angle(0,-90,0), "sidelights_f" },
[34] = {Vector(52.4, -136.5, 100.5), Angle(0,-90,0), "sidelights_f" },
[35] = {Vector(52.4, -162.9, 100.5), Angle(0,-90,0), "sidelights_f" },
--l
[36] = {Vector(-52.4, -2.3, 99), Angle(0,90,0), "sidelights_f" },
[37] = {Vector(-52.4, -28.5, 99.5), Angle(0,90,0), "sidelights_f" },
[38] = {Vector(-52.4, -136.5, 100.5),Angle(0,90,0), "sidelights_f" },
[39] = {Vector(-52.4, -162.9, 100.5),Angle(0,90,0), "sidelights_f" },
--r
[40] = {Vector(22.5, -176, 106.5), Angle(0,0,0), "sidelights_r" },	
[41] = {Vector(37, -176, 106.5), Angle(0,0,0), "sidelights_r" },	
[42] = {Vector(-22, -176, 106.5), Angle(0,0,0), "sidelights_r" },	
[43] = {Vector(-36.2, -176, 106.5), Angle(0,0,0), "sidelights_r" },
//test
[44] = {Vector(-5, 52.65, 66.8), Angle(0,-6,-9), "cockpit_light" },
//cockpit
[45] = {Vector(-1, 51.9, 66.7), Angle(0,-6,-5), "cockpit_light" },

[46] = {Vector(-2.7, 52.3, 66.8), Angle(0,-6,-0), "cockpit_light" },

[47] = {Vector(-3.8, 52.5, 66.8), Angle(0,-6,-0), "cockpit_light" },

[48] = {Vector(-5, 52.65, 66.8), Angle(0,-6,-9), "cockpit_light" },


	 
}

EMV.Sections = {
	["siren"] = {
		{ { 1, W }, { 2, DR }, { 3, W}, { 4, DR },{5,W},{6,DR},{7,W},{8,DR},{9,W}, },
		{ { 1, W },{ 2, DR }, { 3, W}, { 4, DR },{5,W},},
		{{ 1, W },{6,DR},{7,W},{8,DR},{9,W}, },
		{{ 2, DR }, { 3, W}, { 4, DR },{5,W},},
		{{6,DR},{7,W},{8,DR},{9,W}, },
		
		
		
	},
	["headlights"] = {
		{ {10,SW,.75 },{11,SW,.75},{12,SW,.3},{13,SW,.3},},
		{ { 10, SW, { 16, .5, 10 } },{ 11, SW, { 16, .5, 10 } }, },
	},
	["grilllights"] = {
		{{14,W},{15,W},{16,W},{17,W},},
		{{15,W},{17,W},},
		{{14,W},{16,W},},
	
	},
	["toputil"] = {
		{{18,A},{19,A},{20,A},{21,A},{22,A},{23,A},{24,A},{25,A},{26,A},{27,A},},
	},
	["sidelights"] = {
		{{28,W},{29,R},{30,W},{31,R},{32,R},{33,W},{34,W},{35,R},{36,R},{37,W},{38,W},{39,R},{40,W},{41,R},{42,W},{43,R},},
		{{28,W},{30,W},{33,W},{34,W},{37,W},{38,W},{40,W},{42,W},},
		{{29,R},{31,R},{32,R},{35,R},{36,R},{39,R},{41,R},{43,R},},
		
	},
	["cockpit"] = {
		{{45,DR,.8},},
		{{45,DR,.8},{46,R,{ 16, .5, 10 } },},
		{{45,DR,.8},{47,B,{ 16, .5, 10 } },},
		{{45,DR,.8},{48,A,{ 16, .5, 10 },}, },
	},
	["test"] = {
		{{44,A,.8}},
	},
}

EMV.Patterns = { -- 0 = blank
	["siren"] = {
		["all"] = {
			1
		},
		["alt"] = {
			4,4,4,5,5,5,4,4,4,5,5,5
		},
		["altflash"] = {
			2,2,0,3,3,0,2,2,0,3,3,0
		},
		["rapidflash"] = {
			2,0,2,0,1,0,3,0,3,0,1,0
		},
	},
	["headlights"] = {
		["all"] = {
			1
		},
		["pulse"] = {
			2
		},
	},
	["grilllights"] = {
		["all"] = {
			1
		},
		["alt"] = {
			2,2,2,3,3,3,2,2,2,3,3,3
		},
		["altflash"] = {
			2,2,0,3,3,0,2,2,0,3,3
		},
		["rapidflash"] = {
			2,0,2,0,1,0,3,0,3,0,1,0
		},
		
	},
	["toputil"] = {
		["all"] = {
			1
		},
	},
	["sidelights"] = {
		["all"] = {
			1
		},
		["alt"] = {
			2,2,2,3,3,3,2,2,2,3,3,3
		},
		["altflash"] = {
			2,2,0,3,3,0,2,2,0,3,3
		},
		["rapidflash"] = {
			2,0,2,0,1,0,3,0,3,0,1,0
		},
	},
	["cockpit"] = {
		["on"] = {
			1
		},
		["c1"] = {
			2
		},
		["c2"] = {
			3
		},
		["c3"] = {
			4
		},
	},
	["test"] = {
		["all"] ={
			1
		},
	},
}


EMV.Sequences = {
		Sequences = {
		{
			Name = "MARKER",
			Components = {
				["siren"] = "all",
				["headlights"] = "all",
				["grilllights"] = "all",
				["toputil"] = "all",
				["sidelights"] = "all",
				--["test"] = "all",
				["cockpit"] = "on",
			},
			Disconnect = {}
		},
		{
			Name = "CODE 1",
			Components = {
				["siren"] = "alt",
				["headlights"] = "pulse",
				["grilllights"] = "alt",
				["toputil"] = "all",
				["sidelights"] = "alt",
				["cockpit"] = "c1",
			},
			Disconnect = {}
		},
				{
			Name = "CODE 2",
			Components = {
				["siren"] = "altflash",
				["headlights"] = "pulse",
				["grilllights"] = "altflash",
				["toputil"] = "all",
				["sidelights"] = "altflash",
				["cockpit"] = "c2",
			},
			Disconnect = {}
		},
				{
			Name = "CODE 3",
			Components = {
				["siren"] = "rapidflash",
				["headlights"] = "pulse",
				["grilllights"] = "rapidflash",
				["toputil"] = "all",
				["sidelights"] = "rapidflash",
				["cockpit"] = "c3",
			},
			Disconnect = {}
		},
	}
}




local V = {
				// Required information
				Name =	name,
				Class = "prop_vehicle_jeep",
				Category = "Emergency Vehicles",

				// Optional information
				Author = "SGM, Schmal,",
				Information = "vroom vroom",
				Model =	"models/sentry/c5500_ambu.mdl",

			
				KeyValues = {				
						vehiclescript =	"scripts/vehicles/sentry/c5500.txt"
					    },
				IsEMV = true,
				EMV = EMV,
				HasPhoton = true,
				Photon = "sgm_g5500ambu"	

}

list.Set( "Vehicles", V.Name, V )

if EMVU then EMVU:OverwriteIndex( name, EMV ) end