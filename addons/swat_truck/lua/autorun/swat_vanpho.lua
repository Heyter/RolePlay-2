AddCSLuaFile()

EMV_DEBUG = false

local name = "SWAT Van "

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
		W = 5.5,
		H = 5.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.2
	},

	headlight = {
		AngleOffset = -90,
		W = 6.5,
		H = 6.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.6,
		VisRadius = 0
	},

	reverse_lights = {
		AngleOffset = 90,
		W = 5.5,
		H = 5.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.6
	},
	side_orange = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.1
	},
	rear_orange = {
		AngleOffset = 90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.1
	},

}

PI.Positions = {

	 [1] = { Vector(-40.5, -134.2, 37.7), Angle(0,0,0), "tail_light" },
	 [2] = { Vector(40.4, -134.2, 37.7), Angle(0,0,0), "tail_light" },

	 [3] = { Vector(-40.5, -134.2, 67.3), Angle(0,0,0), "reverse_lights" },
	 [4] = { Vector(40.4, -134.2, 67.3), Angle(0,0,0), "reverse_lights" },
	 

	[5] = { Vector( -48.5, 118.7, 43.5 ), Angle(0,30,-2), "headlight" },
	[6] = { Vector( 48.5, 118.6, 43.5 ), Angle(0,-30,-2), "headlight" },
	
	[7] = { Vector( -48.3,122.75, 35.8 ), Angle(0,30,-2), "side_orange" },
	[8] = { Vector( 48,122.75, 35.8 ), Angle(0,-30,-2), "side_orange" },
	
	[9] = { Vector( -54.95,84.6, 44.7 ), Angle(0,90,-2), "side_orange" },
	[10] = { Vector( -53.8,10, 20.1 ), Angle(0,90,-2), "side_orange" },
	[11] = { Vector( -53.8,-37.1, 20.1 ), Angle(0,90,-2), "side_orange" },
	[12] = { Vector( -53.8,-118.3, 20.1 ), Angle(0,90,-2), "side_orange" },
	
	[13] = { Vector( 54.7,84.6, 44.7 ), Angle(0,-90,-2), "side_orange" },
	[14] = { Vector( 53.5,10, 20.1 ), Angle(0,-90,-2), "side_orange" },
	[15] = { Vector( 53.5,-37.1, 20.1 ), Angle(0,-90,-2), "side_orange" },
	[16] = { Vector( 53.5,-118.3, 20.1 ), Angle(0,-90,-2), "side_orange" },
	
	[17] = { Vector( -41.9,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[18] = { Vector( -14.1,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[19] = { Vector( 14,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[20] = { Vector( 41.8,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },

}

PI.States = {}

PI.States.Headlights = { -- NOT YET IMPLEMENTED
	
}

PI.States.Brakes = {
	{ 1, DR, 1 }, { 2, DR, 1 }, 
	}

PI.States.Blink_Left = {
{7,A},{9,A},{10,A},{11,A},{12,A},{17,A},{18,A},
}
PI.States.Blink_Right = {
{8,A},{13,A},{14,A},{15,A},{16,A},{19,A},{20,A},
}

PI.States.Reverse = {
	{ 3, SW }, { 4, SW }
}

PI.States.Running = {
	{ 5, SW, 1 }, { 6, SW, 1 }, 
	{ 1, DR, .25 }, { 2, DR, .25 }
}

Photon.VehicleLibrary["sgm_swatvan"] = PI

// EMV DATA

local EMV = {}

EMV.Siren = 2

EMV.Color = Color( 255, 255, 255 )
EMV.Skin = 0

EMV.BodyGroups = {
	{2,1}
}

EMV.Props = {
	{
		Model = "models/lonewolfie/whelenliberty_sub.mdl",
		Scale = .92,
		Pos = Vector(0, 46, 110.1),
		Ang = Angle( 0, -90, 0),
		BodyGroups = {
			{ 1, 1 }
		},
	},

	{
		Model = "models/lonewolfie/whelenliberty_sub.mdl",
		Scale = .99,
		Pos = Vector(0, -107, 110.15),
		Ang = Angle( 0, -90, 0),
		BodyGroups = {
			{ 1, 1 }
		},
	},
}

EMV.Meta = {
	liberty_f_main = {
		AngleOffset = -90,
		W = 7.5,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	liberty_takedown = {
		AngleOffset = -90,
		W = 3.6,
		H = 3.6,
		Sprite = "sprites/emv/emv_whelen_tri",
		WMult = 1,
		Scale = 1.2
	},
	liberty_f_ang = {
		AngleOffset = -90,
		W = 15,
		H = 14,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6,
		VisRadius = 0
	},
	liberty_r_ang = {
		AngleOffset = 90,
		W = 15,
		H = 14,
		Sprite = "sprites/emv/emv_whelen_corner",
		WMult = 3,
		Scale = 1.6
	},
	liberty_r_main = {
		AngleOffset = 90,
		W = 7.5,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	headlight = {
		AngleOffset = -90,
		W = 6.5,
		H = 6.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 3,
		VisRadius = 0
	},
	liberty_grill = {
		AngleOffset = -90,
		W = 5.5,
		H = 8,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.4
	},
	side_white = {
		AngleOffset = -90,
		W = 7,
		H = 18,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 2
	},
	side_red = {
		AngleOffset = -90,
		W = 7,
		H = 9,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 2
	},
	rear_white = {
		AngleOffset = 90,
		W = 7,
		H = 18,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 2
	},
	rear_red = {
		AngleOffset = 90,
		W = 7,
		H = 9,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 2
	},
	side_orange = {
		AngleOffset = -90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = .8,
	},
	rear_orange = {
		AngleOffset = 90,
		W = 7,
		H = 7,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 1.2,
		Scale = 1.1
	},
	small_rear_orange = {
		AngleOffset = 90,
		W = 3.4,
		H = 5.5,
		Sprite = "sprites/emv/emv_whelen_src",
		WMult = 2,
		Scale = 1.1
	},
	test_light ={
		AngleOffset = 90,
		W = 5.5,
		H = 5.5,
		Sprite = "sprites/emv/light_circle",
		Scale = 1.2,
		VisRadius = 0
	},
	
}		


EMV.Positions = {

	 [1] = { Vector( -3.37, 52.6, 112.5 ), Angle(0,0,-2), "liberty_f_main" },
	 [2] = { Vector( 3.37, 52.6, 112.5 ), Angle(0,0,-2), "liberty_f_main" },

	 [3] = { Vector( -9.45, 52.6, 112.5 ), Angle(0,0,-2), "liberty_f_main" },
	 [4] = { Vector( 9.45, 52.6, 112.5 ), Angle(0,0,-2), "liberty_f_main" },
	
	 [5] = { Vector( -24.23, 50.2, 112.6 ), Angle(1,32.4,-2), "liberty_f_ang" },
	 [6] = { Vector( 24.33, 50.2, 112.6 ), Angle(-1,-32.4,-2), "liberty_f_ang" },

	 [7] = { Vector( -24.3, 41.4, 112.6 ), Angle(-1,-33,-2), "liberty_r_ang" },
	 [8] = { Vector( 24.3, 41.4, 112.6 ), Angle(1,33,-2), "liberty_r_ang" },

	 [9] = { Vector( -15.5, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },
	[10] = { Vector( 15.5, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },

	[11] = { Vector( -9.45, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },
	[12] = { Vector( 9.45, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },

	[13] = { Vector( -3.37, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },
	[14] = { Vector( 3.37, 38.9, 112.55 ), Angle(0,0,-2), "liberty_r_main" },

	[15] = { Vector( -15.58, 52.6, 112.5 ), Angle(0,0,-2), "liberty_takedown" },
	[16] = { Vector( 15.58, 52.6, 112.5 ), Angle(0,0,-2), "liberty_takedown" },

	[17] = { Vector( -28.6, 45.7, 112.5 ), Angle(0,90,0), "liberty_takedown" },
	[18] = { Vector( 28.6,45.7, 112.5 ), Angle(0,-90,0), "liberty_takedown" },

	[19] = { Vector( -41, 121.4, 43.6 ), Angle( 0, 30, 0 ), "headlight" },
	[20] = { Vector( 41, 121.4, 43.6 ), Angle( 0, -30, 0 ), "headlight" },
	
	[21] = { Vector( -3.53, -99.84, 112.7 ), Angle(0,0,-2), "liberty_f_main" },
	[22] = { Vector( 3.53, -99.84, 112.7 ), Angle(0,0,-2), "liberty_f_main" },

	[23] = { Vector( -10.2, -99.84, 112.7 ), Angle(0,0,-2), "liberty_f_main" },
	[24] = { Vector( 10.2, -99.84, 112.7 ), Angle(0,0,-2), "liberty_f_main" },
	
	[25] = { Vector( -26.23, -102.3, 112.7 ), Angle(1,32.4,-2), "liberty_f_ang" },
	[26] = { Vector( 26.33, -102.3, 112.7 ), Angle(-1,-32.4,-2), "liberty_f_ang" },

	[27] = { Vector( -26.2, -112, 112.7 ), Angle(-1,-33,-2), "liberty_r_ang" },
	[28] = { Vector( 26.2, -112, 112.7 ), Angle(1,33,-2), "liberty_r_ang" },

	[29] = { Vector( -16.6, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },
	[30] = { Vector( 16.6, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },

	[31] = { Vector( -10.1, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },
	[32] = { Vector( 10.1, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },

	[33] = { Vector( -3.37, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },
	[34] = { Vector( 3.37, -114.6, 112.7 ), Angle(0,0,-2), "liberty_r_main" },

	[35] = { Vector( -16.8, -99.5, 112.7 ), Angle(0,0,-2), "liberty_takedown" },
	[36] = { Vector( 16.8, -99.5, 112.7 ), Angle(0,0,-2), "liberty_takedown" },

	[37] = { Vector( -30.5, -107.3, 112.7 ), Angle(0,90,0), "liberty_takedown" },
	[38] = { Vector( 30.5,-107.3, 112.7 ), Angle(0,-90,0), "liberty_takedown" },

	[39] = { Vector( -23.5, 137, 50.1 ), Angle(0,0,-2), "liberty_grill" },
	[40] = { Vector( 23.5,137, 50.1 ), Angle(0,0,-2), "liberty_grill" },
	
	[41] = { Vector( -53.7, -35.9, 93.5 ), Angle(0,90,-2), "side_white" },
	[42] = { Vector( -53.7,-35.9, 97.7 ), Angle(0,90,-2), "side_red" },
	
	[43] = { Vector( 53.7, -35.9, 93.5 ), Angle(0,-90,-2), "side_white" },
	[44] = { Vector( 53.7,-35.9, 97.7 ), Angle(0,-90,-2), "side_red" },
	
	[45] = { Vector( -42, -134.8, 93.5 ), Angle(0,0,-2), "rear_white" },
	[46] = { Vector( -42,-134.8, 97.7 ), Angle(0,0,-2), "rear_red" },
	
	[47] = { Vector( 42, -134.8, 93.5 ), Angle(0,0,-2), "rear_white" },
	[48] = { Vector( 42,-134.8, 97.7 ), Angle(0,0,-2), "rear_red" },
	
	[49] = { Vector( -48.3,122.75, 35.8 ), Angle(0,30,-2), "side_orange" },
	[50] = { Vector( 48,122.75, 35.8 ), Angle(0,-30,-2), "side_orange" },
	
	[51] = { Vector( -54.95,84.6, 44.7 ), Angle(0,90,-2), "side_orange" },
	[52] = { Vector( -53.8,10, 20.1 ), Angle(0,90,-2), "side_orange" },
	[53] = { Vector( -53.8,-37.1, 20.1 ), Angle(0,90,-2), "side_orange" },
	[54] = { Vector( -53.8,-118.3, 20.1 ), Angle(0,90,-2), "side_orange" },
	
	[55] = { Vector( 54.7,84.6, 44.7 ), Angle(0,-90,-2), "side_orange" },
	[56] = { Vector( 53.5,10, 20.1 ), Angle(0,-90,-2), "side_orange" },
	[57] = { Vector( 53.5,-37.1, 20.1 ), Angle(0,-90,-2), "side_orange" },
	[58] = { Vector( 53.5,-118.3, 20.1 ), Angle(0,-90,-2), "side_orange" },
	
	[59] = { Vector( -41.9,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[60] = { Vector( -14.1,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[61] = { Vector( 14,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	[62] = { Vector( 41.8,-134.8, 20.1 ), Angle(0,0,-2), "rear_orange" },
	
	[63] = { Vector( -15.3,-134, 105.1 ), Angle(0,0,-2), "small_rear_orange" },
	[64] = { Vector( -5.1,-134, 105.1  ), Angle(0,0,-2), "small_rear_orange" },
	[65] = { Vector( 4.9,-134, 105.1  ), Angle(0,0,-2), "small_rear_orange" },
	[66] = { Vector( 15.1,-134, 105.1  ), Angle(0,0,-2), "small_rear_orange" },
	
	[67] = { Vector(40.4, -134.2, 67.3), Angle(0,0,0), "test_light" },
	
}

EMV.Sections = {
	["liberty"] = {
		{ { 1, R }, { 2, B }, { 3, R }, { 4, B }, { 5, R }, { 6, B }, { 7, R }, { 8, B }, { 9, R }, { 10, B },  { 11, R }, { 12, B },  { 13, R }, { 14, B }, { 15, W }, { 16, W }, { 17, W }, { 18, W }, },
		{ { 1, R }, { 3, R }, { 5, R }, { 7, R }, { 9, R }, { 11, R }, { 13, R }, },
		{ { 2, B }, { 4, B }, { 6, B }, { 8, B }, { 10, B }, { 12, B }, { 14, B }, },
		{ { 1, R, .75 }, { 2, B, .75 }, { 3, R, .75 }, { 4, B, .75 }, { 5, R, .75 }, { 6, B, .75 }, { 7, R, .75 }, { 8, B, .75 }, { 9, R, .75 }, { 10, B, .75 },  { 11, R, .75 }, { 12, B, .75 },  { 13, R, .75 }, { 14, B, .75 }, },
		{ { 1, R, 1 }, { 2, B, 1 }, { 3, R, 1 }, { 4, B, 1 }, { 5, R, 1 }, { 6, B, 1 }, { 7, R, 1 }, { 8, B, 1 }, { 9, R, 1 }, { 10, B, 1 },  { 11, R, 1 }, { 12, B, 1 },  { 13, R, 1 }, { 14, B, 1 }, },
		{ { 3, R, 1 }, { 4, B, 1 }, { 5, R, 1 }, { 6, B, 1 }, { 7, R, 1 }, { 8, B, 1 }, { 15, W }, { 16, W }, { 17, W }, { 18, W } },
		{ { 3, R, .75 }, { 4, B, .75 }, { 5, R, .75 }, { 6, B, .75 }, { 7, R, .75 }, { 8, B, .75 }, { 15, W }, { 16, W }, { 17, W }, { 18, W } },
	},
	["liberty_corner"] = {
		{ { 5, R }, { 7, R } },
		{ { 6, B }, { 8, B } },
	},
	["liberty_front"] = {
		{ { 1, R} },
		{ { 2, B} },
		{ { 3, R} },
		{ { 4, B} },
		{ { 1, R}, {3, R} },
		{ { 2, B}, {4, B} },
	},
	["liberty_rear"] = {
		{ { 11, R } },
		{ { 9, R }, { 13, R }, },
		{ { 12, B } },
		{ { 10, B }, { 14, B }, },
		{ { 9, R }, { 11, R }, { 13, R }, },
		{ { 10, B }, { 12, B }, { 14, B }, },
	},
	["headlights"] = {
		{ { 19, SW, { 16, .5, 10 } }, { 20, SW, { 16, .5, 0 } }, },
		{ { 19, SW}, {20, SW}, },
	},
	["back_liberty"] = {
		{ { 21, R }, { 22, B }, { 23, R }, { 24, B }, { 25, R }, { 26, B }, { 27, R }, { 28, B }, { 29, R }, { 30, B },  { 31, R }, { 32, B },  { 33, R }, { 34, B }, { 35, W }, { 36, W }, { 37, W }, { 38, W }, },
		{ { 21, R }, { 23, R }, { 25, R }, { 27, R }, { 29, R }, { 31, R }, { 33, R }, },
		{ { 22, B }, { 24, B }, { 26, B }, { 28, B }, { 30, B }, { 32, B }, { 34, B }, },
		{ { 21, R, .75 }, { 22, B, .75 }, { 23, R, .75 }, { 24, B, .75 }, { 25, R, .75 }, { 26, B, .75 }, { 27, R, .75 }, { 28, B, .75 }, { 29, R, .75 }, { 30, B, .75 },  { 31, R, .75 }, { 32, B, .75 },  { 33, R, .75 }, { 34, B, .75 }, },
		{ { 21, R, 1 }, { 22, B, 1 }, { 23, R, 1 }, { 24, B, 1 }, { 25, R, 1 }, { 26, B, 1 }, { 27, R, 1 }, { 28, B, 1 }, { 29, R, 1 }, { 30, B, 1 },  { 31, R, 1 }, { 32, B, 1 },  { 33, R, 1 }, { 34, B, 1 }, },
		{ { 23, R, 1 }, { 24, B, 1 }, { 25, R, 1 }, { 26, B, 1 }, { 27, R, 1 }, { 28, B, 1 }, { 35, W }, { 36, W }, { 37, W }, { 38, W } },
		{ { 23, R, .75 }, { 24, B, .75 }, { 25, R, .75 }, { 26, B, .75 }, { 27, R, .75 }, { 28, B, .75 }, { 35, W }, { 36, W }, { 37, W }, { 38, W } },
	
	},
	["back_liberty_corner"] = {
		{ { 25, R }, { 27, R } },
		{ { 26, B }, { 28, B } },
	},
	["back_liberty_front"] = {
		{ { 21, R} },
		{ { 22, B} },
		{ { 23, R} },
		{ { 24, B} },
		{ { 21, R}, {23, R} },
		{ { 22, B}, {24, B} },
	},
	["back_liberty_rear"] = {
		{ { 31, R } },
		{ { 29, R }, { 33, R }, },
		{ { 32, B } },
		{ { 30, B }, { 34, B }, },
		{ { 29, R }, { 31, R }, { 33, R }, },
		{ { 30, B }, { 32, B }, { 34, B }, },
	},
	["liberty_grill"] = {
		{ { 39, R } },
		{ { 40, B } },
	},
	["side_rnw"] = {
		{ { 41, W }, { 42, R }, { 43, W }, { 44, R }, { 45, W }, { 46, R }, { 47, W }, { 48, R },},
		{ { 41, W, 1 }, { 42, R, 1 }, { 43, W, 1 }, { 44, R, 1 }, { 45, W, 1 }, { 46, R, 1 }, { 47, W, 1 }, { 48, R, 1 },},
		{ { 41, W, .75 }, { 42, R, .75 }, { 43, W, .75 }, { 44, R, .75 }, { 45, W, .75 }, { 46, R, .75 }, { 47, W, .75 }, { 48, R, .75 },},
		{ { 41, W }, { 42, R }, { 45, W }, { 46, R }, },
		{ { 43, W }, { 44, R }, { 47, W }, { 48, R }, },
	},
	["side_util_orange"] = {
		{ { 49, A,.4 }, {50, A,.4 }, {51, A,.4 }, {52, A,.4 }, {53, A }, {54, A,.4 }, {55, A,.4 }, {56, A,.4 }, {57, A,.4 }, {58, A,.4 }, {59, A,.4 }, {60, A,.4 }, {61, A,.4 }, {62, A,.4 },{63, A,.4 },{64, A,.4 },{65, A,.4 },{66, A,.4 },},
	},
	["test_light"] = {
		{ {67, SW}, },
	},
}

EMV.Patterns = { -- 0 = blank
	["liberty"] = {
		["all"] = {
			1
		},
		["alt"] = {
			2, 2, 2, 3, 3, 3
		},
		["alt_urgent"] = {
			2, 2, 3, 3, 0, 3, 3, 2, 2, 0
		},
		["onscene"] = {
			6, 7
		},
		["pulse"] = {
			8
		}
	},
	["liberty_corner"] = {
		["tri_flash"] = {
			1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0
		},
		["duo_flash"] = {
			1, 0, 1, 0, 2, 0, 2, 0,
		},
	},
	["liberty_front"] = {
		["alt"] = {
			5, 5, 6, 6, 0, 6, 6, 5, 5, 0
		},
		["alt_urgent"] = {
			5, 6, 0, 6, 5, 0
		}
	},
	["liberty_rear"] = {
		["trio"] = {
			1, 1, 3, 3, 2, 2, 4, 4
		},
		["alt"] = {
			5, 5, 6, 6, 0, 6, 6, 5, 5, 0
		},
		["alt_urgent"] = {
			5, 6, 0, 6, 5, 0
		},
	},
	["headlights"] = {
		["wig-wag"] = {
			1
		},
		["all"] = {
			2
		},
	},
	["back_liberty"] = {
		["all"] = {
			1
		},
		["alt"] = {
			2, 2, 2, 3, 3, 3
		},
		["alt_urgent"] = {
			2, 2, 3, 3, 0, 3, 3, 2, 2, 0
		},
		["onscene"] = {
			6, 7
		},
		["pulse"] = {
			8
		}
	},
	["back_liberty_corner"] = {
		["tri_flash"] = {
			1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0
		},
		["duo_flash"] = {
			1, 0, 1, 0, 2, 0, 2, 0,
		},
	},
	["back_liberty_front"] = {
		["alt"] = {
			5, 5, 6, 6, 0, 6, 6, 5, 5, 0
		},
		["alt_urgent"] = {
			5, 6, 0, 6, 5, 0
		}
	},
	["back_liberty_rear"] = {
		["trio"] = {
			1, 1, 3, 3, 2, 2, 4, 4
		},
		["alt"] = {
			5, 5, 6, 6, 0, 6, 6, 5, 5, 0
		},
		["alt_urgent"] = {
			5, 6, 0, 6, 5, 0
		},
	},
	["liberty_grill"] = {
		["alt"] = {
			1,1,2,2,0,1,1,2,2,0
		},
		["alt_urgent"] = {
			1,2,0,1,2,0
		},
	},
	["side_rnw"] = {
		["all"] = {
			1
		},
		["pulse"] = {
			2,3
		},
		["alt"] = {
			4,4,5,5,0,4,4,5,5,0
		},
		["alt_urgent"] = {
			4,5,0,4,5,0
		},
	},
	["side_util_orange"] = {
		["all"] = {
			1
		},
	},
	["test_light"] = {
		["all"] = {
			1
		},
	},
}

EMV.Sequences = {
		Sequences = {
		{
			Name = "MARKER",
			Components = {
				["liberty"] = "onscene",
				["back_liberty"] = "onscene",
				["side_rnw"] = "pulse",
			["side_util_orange"] = "all",
				["headlights"] = "all"
				--["test_light"] = "all",
			},
			Disconnect = {}
		},
		{
			Name = "CODE 1",
			Components = {
				["liberty"] = "alt_urgent",
				["back_liberty"] = "alt_urgent",
				["liberty_grill"] = "alt_urgent",
				["side_rnw"] = "alt_urgent",
			--	["side_util_orange"] = "all",
				["headlights"] = "wig-wag",
				
			},
			Disconnect = {}
		},
		{
			Name = "CODE 2",
			Components = {
				["liberty_corner"] = "tri_flash",
				["liberty_front"] = "alt",
				["liberty_rear"] = "alt",
				["back_liberty_corner"] = "tri_flash",
				["back_liberty_front"] = "alt",
				["back_liberty_rear"] = "alt",
				["liberty_grill"] = "alt",
				["side_rnw"] = "alt",
			--	["side_util_orange"] = "all",
				["headlights"] = "wig-wag",
				
			},
			Disconnect = {}
		},
		{
			Name = "CODE 3",
			Components = {
				["liberty_corner"] = "tri_flash",
				["liberty_front"] = "alt_urgent",
				["liberty_rear"] = "alt_urgent",
				["headlights"] = "wig-wag",
				["back_liberty_corner"] = "tri_flash",
				["back_liberty_front"] = "alt_urgent",
				["back_liberty_rear"] = "alt_urgent",
				["liberty_grill"] = "alt_urgent",
				["side_rnw"] = "alt_urgent",
			--	["side_util_orange"] = "all",


			},
			Disconnect = { 15, 16 }
		},
	}
}




local V = {
				// Required information
				Name =	name,
				Class = "prop_vehicle_jeep",
				Category = "Emergency Vehicles",

				// Optional information
				Author = "SentryGunMan, Schmal",
				Information = "vroom vroom",
				Model =	"models/sentry/swatvan.mdl",

			
				KeyValues = {				
						vehiclescript =	"scripts/vehicles/sentry/vswat.txt"
					    },
				IsEMV = true,
				EMV = EMV,
				HasPhoton = true,
				Photon = "sgm_swatvan"	

}

list.Set( "Vehicles", V.Name, V )

if EMVU then EMVU:OverwriteIndex( name, EMV ) end