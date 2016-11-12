ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Npc Point"
ENT.Author = "Xt4zzi"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function GetCarInfo( vehsname )
	for k, v in pairs( CSVehicles.Cars ) do
		if v.vehsname == vehsname then return v end
	end
	return nil
end

CSVehicles = {}
CSVehicles.config = {}
CSVehicles.config.TESTTIME = 30
CSVehicles.config.MaxVehicles = 3

CSVehicles.Cars = {}
CSVehicles.CarSpawns = {}
CSVehicles.Number = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}
CSVehicles.Letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

function GenerateNumberShield()
	local shield = "DE-"
	for i=1, 2 do
		shield = shield .. table.Random( CSVehicles.Letters )
	end
	shield = shield .. "-"
	for i=1, 3 do
		shield = shield .. table.Random( CSVehicles.Number )
	end
	return shield
end

CSVehicles.CarSpawns["rp_townsend_v2"] = {
  {
    ang = Angle(-0.044, -135.060, 0.000),
    pos = Vector(4599.937500, -2686.625000, -205.875000)
  },
  {
    ang = Angle(-0.044, -135.060, 0.000),
    pos = Vector(4776.781250, -2686.625000, -205.875000)
  },
  {
    ang = Angle(-0.044, -135.060, 0.000),
    pos = Vector(4953.593750, -2686.625000, -205.875000)
  },
  {
    ang = Angle(-0.044, -135.060, 0.000),
    pos = Vector(5130.406250, -2686.625000, -205.875000)
  },
  {
    ang = Angle(-0.044, -135.060, 0.000),
    pos = Vector(5307.218750, -2686.625000, -205.875000)
  },
  {
    ang = Angle(0.000, -45.005, 0.000),
    pos = Vector(4555.437500, -3701.781250, -205.812500)
  },
  {
    ang = Angle(0.000, -45.005, 0.000),
    pos = Vector(4555.437500, -3525.000000, -205.812500)
  },
  {
    ang = Angle(0.000, -45.005, 0.000),
    pos = Vector(4555.437500, -3348.218750, -205.812500)
  },
  {
    ang = Angle(0.000, -45.005, 0.000),
    pos = Vector(4555.437500, -3171.406250, -205.812500)
  },
  {
    ang = Angle(0.000, -45.005, 0.000),
    pos = Vector(4555.437500, -2994.625000, -205.812500)
  }
}
CSVehicles.CarSpawns["rp_evocity_v2d"] = {
  {
    ang = Angle(0.000, 45.005, 0.088),
    pos = Vector(5689.656250, -4808.625000, 60)
  },
  {
    ang = Angle(0.000, 45.005, 0.088),
    pos = Vector(5517.562500, -4808.625000, 60)
  },
  {
    ang = Angle(0.000, 45.005, 0.088),
    pos = Vector(5345.437500, -4808.625000, 60)
  },
  {
    ang = Angle(0.000, 45.005, 0.088),
    pos = Vector(5173.312500, -4808.625000, 60)
  },
  {
    ang = Angle(0.000, -45.005, 0.132),
    pos = Vector(3940.375000, -4799.937500, 60)
  },
  {
    ang = Angle(0.000, -45.005, 0.132),
    pos = Vector(4112.500000, -4799.937500, 60)
  },
  {
    ang = Angle(0.000, -45.005, 0.132),
    pos = Vector(4284.625000, -4799.937500, 60)
  },
  {
    ang = Angle(0.000, -45.005, 0.132),
    pos = Vector(4456.750000, -4799.937500, 60)
  }
}

CSVehicles.CarSpawns["rp_evocity_v33x"] = {
  {
    ang = Angle(-0.176, -20.874, 0.659),
    pos = Vector( 4368.5, -5876.3125, 50.71875 )
  },
  {
    pos = Vector( 4534.65625, -5879.21875, 51.5625 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 4704.625, -5882.34375, 53.3125 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 4862.96875, -5878.40625, 52.625 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 5037.28125, -5884.9375, 53.9375 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 5201.71875, -5883.625, 52.25 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 5364.09375, -5881.96875, 52.71875 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 5538.375, -5882.5, 53.125 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 5709.3125, -5873.40625, 52.34375 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 6049.15625, -5605.875, 52.4375 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 6224.34375, -5623.75, 52.9375 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 6414.96875, -5624, 53.09375 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 6593.25, -5622.25, 52.71875 ),
    ang = Angle(-0.044, -20.566, 0.000)
  },
  {
    pos = Vector( 6784.78125, -5633.3125, 53.40625 ),
    ang = Angle(-0.044, -20.566, 0.000)
  }
}

 -- Auskommentiert weil sie immoment nicht funktionieren!
 CSVehicles.Cars[1] = {--
    name="VW Golf MKII",
    model="models/tdmcars/golf_mk2.mdl",
    cost=40000,
    desc="Alt aber gut fuer den Anfang!",
	entity="prop_vehicle_jeep",
	vehsname="golfmk2tdm",
	DOnly=false,
	fuel=100,
	hp=250
}
CSVehicles.Cars[2] = {--
    name="Volvo 242 Turbo",
    model="models/tdmcars/242turbo.mdl",
    cost=50000,
    desc="Eine alte aber schnelle Kiste",
	entity="prop_vehicle_jeep",
	vehsname="242turbotdm",
	DOnly=false,
	fuel=100,
	hp=280
}
CSVehicles.Cars[3] = {--
    name="Mitsubishi Colt Rilliart",
    model="models/tdmcars/coltralliart.mdl",
    cost=55000,
    desc="Klein und Kompakt.",
	entity="prop_vehicle_jeep",
	vehsname="colttdm",
	DOnly=false,
	fuel=100,
	hp=380
}
CSVehicles.Cars[4] = {--
    name="Jeep Wrangler",
    model="models/tdmcars/wrangler.mdl",
    cost=58000,
    desc="Sehr guter Geleandewagen! Leider mit schlechter Beschleunigung.",
	entity="prop_vehicle_jeep",
	vehsname="wranglertdm",
	DOnly=false,
	fuel=100,
	hp=290
}
CSVehicles.Cars[5] = {--
    name="Toyota Prius",
    model="models/tdmcars/prius.mdl",
    cost=65000,
    desc="Ein guter Familienwagen.",
	entity="prop_vehicle_jeep",
	vehsname="priustdm",
	DOnly=false,
	fuel=100,
	hp=300
}
CSVehicles.Cars[6] = {--
    name="Kia Ceed",
    model="models/tdmcars/kia_ceed.mdl",
    cost=68000,
    desc="Ein guter Familienwagen mit einer schoenen Form.",
	entity="prop_vehicle_jeep",
	vehsname="ceedtdm",
	DOnly=false,
	fuel=100,
	hp=310
}
CSVehicles.Cars[7] = {--
    name="Honda Civic Type R",
    model="models/tdmcars/civic_typer.mdl",
    cost=75000,
    desc="Schnittig und etwas schneller als andere Autos in dieser Preisklasse.",
	entity="prop_vehicle_jeep",
	vehsname="civictypertdm",
	DOnly=false,
	fuel=100,
	hp=320
}
CSVehicles.Cars[8] = {--
    name="Ferrari 512 TR",
    model="models/tdmcars/ferrari512tr.mdl",
    cost=80000,
    desc="Ein sehr gutes Auto.",
	entity="prop_vehicle_jeep",
	vehsname="ferrari512trtdm",
	DOnly=false,
	fuel=100,
	hp=330
}
CSVehicles.Cars[9] = {--
    name="GMC Vandura",
    model="models/tdmcars/gmcvan.mdl",
    cost=95000,
    desc="Ein gepanzerter Transporter. Gut fuer illegale sachen.",
	entity="prop_vehicle_jeep",
	vehsname="gmcvantdm",
	DOnly=false,
	fuel=100,
	hp=850
}
CSVehicles.Cars[10] = {--
    name="Ford Transit",
    model="models/tdmcars/ford_transit.mdl",
    cost=110000,
    desc="Modernes Design und durchschnittliche Geschwindigkeit.",
	entity="prop_vehicle_jeep",
	vehsname="transittdm",
	DOnly=false,
	fuel=100,
	hp=450
}
CSVehicles.Cars[11] = {--
    name="BMW M3 E92",
    model="models/tdmcars/bmwm3e92.mdl",
    cost=125000,
    desc="Schnell und wenig Verbrauch!",
	entity="prop_vehicle_jeep",
	vehsname="m3e92tdm",
	DOnly=false,
	fuel=100,
	hp=380
}
CSVehicles.Cars[12] = {--
    name="Hummer H1",
    model="models/tdmcars/hummerh1.mdl",
    cost=135000,
    desc="Direkt von der Army importiert! Natuerlich mit neuen Felgen.",
	entity="prop_vehicle_jeep",
	vehsname="h1tdm",
	DOnly=true,
	fuel=100,
	hp=950
}
CSVehicles.Cars[13] = {--
    name="Audi S5",
    model="models/tdmcars/s5.mdl",
    cost=140000,
    desc="Schnittiges Design und Schnell.",
	entity="prop_vehicle_jeep",
	vehsname="s5tdm",
	DOnly=false,
	fuel=100,
	hp=400
}
CSVehicles.Cars[14] = {--
    name="Cevrolet Camaro SS 69",
    model="models/tdmcars/69camaro.mdl",
    cost=148500,
    desc="Ein schoener alter Camaro.",
	entity="prop_vehicle_jeep",
	vehsname="69camarotdm",
	DOnly=false,
	fuel=100,
	hp=420
}
CSVehicles.Cars[15] = {--
    name="Audi TT 69",
    model="models/tdmcars/auditt.mdl",
    cost=165500,
    desc="Ein schoenes auto mit sportlichen Design.",
	entity="prop_vehicle_jeep",
	vehsname="auditttdm",
	DOnly=false,
	fuel=100,
	hp=440
}
CSVehicles.Cars[16] = {--
    name="Dodge Charger SRT-8",
    model="models/tdmcars/chargersrt8.mdl",
    cost=180000,
    desc="Gutes Handling und gute Fahrweise.",
	entity="prop_vehicle_jeep",
	vehsname="chargersrt8tdm",
	DOnly=false,
	fuel=100,
	hp=460
}
CSVehicles.Cars[17] = {--
    name="Dodge RAM SRT-10",
    model="models/tdmcars/dodgeram.mdl",
    cost=195000,
    desc="Sehr schnelles Auto und gut fuer Transporte.",
	entity="prop_vehicle_jeep",
	vehsname="dodgeramtdm",
	DOnly=false,
	fuel=100,
	hp=750
}
CSVehicles.Cars[18] = {--
    name="Toyota Supra",
    model="models/tdmcars/supra.mdl",
    cost=200000,
    desc="Ein schnelles Auto.",
	entity="prop_vehicle_jeep",
	vehsname="supratdm",
	DOnly=false,
	fuel=100,
	hp=480
}
CSVehicles.Cars[19] = {--
    name="Land Rover Range",
    model="models/tdmcars/landrover.mdl",
    cost=205500,
    desc="Ein gutaussehender Geleandewagen.",
	entity="prop_vehicle_jeep",
	vehsname="landrovertdm",
	DOnly=true,
	fuel=100,
	hp=780
}
CSVehicles.Cars[20] = {--
    name="Porsche Cayenne",
    model="models/tdmcars/cayenne.mdl",
    cost=225500,
    desc="Ein gutaussehender Geleandewagen.",
	entity="prop_vehicle_jeep",
	vehsname="cayennetdm",
	DOnly=true,
	fuel=100,
	hp=800
}
CSVehicles.Cars[21] = {--
    name="Mazda RX-8",
    model="models/tdmcars/rx8.mdl",
    cost=235850,
    desc="Ein sehr gutes Auto mit guter Beschleunigung.",
	entity="prop_vehicle_jeep",
	vehsname="rx8tdm",
	DOnly=false,
	fuel=100,
	hp=500
}
CSVehicles.Cars[22] = {--
    name="Audi R8 V10",
    model="models/tdmcars/audir8v10.mdl",
    cost=245800,
    desc="Schnell, gutes Handling und Gutaussehend! Einfach nur Perfekt.",
	entity="prop_vehicle_jeep",
	vehsname="audir8v10tdm",
	DOnly=false,
	fuel=100,
	hp=520
}
CSVehicles.Cars[23] = {--
    name="Nissan Skyline R34",
    model="models/tdmcars/skyline_r34.mdl",
    cost=265000,
    desc="Schnell und Gutaussehend!",
	entity="prop_vehicle_jeep",
	vehsname="r34tdm",
	DOnly=false,
	fuel=100,
	hp=540
}
CSVehicles.Cars[24] = {--
    name="Ford GT 05",
    model="models/tdmcars/gt05.mdl",
    cost=285500,
    desc="Schnell und einfach nur geiler Sound!",
	entity="prop_vehicle_jeep",
	vehsname="gt05tdm",
	DOnly=false,
	fuel=100,
	hp=560
}
CSVehicles.Cars[25] = {--
    name="Porsche 997 GT3",
    model="models/tdmcars/997gt3.mdl",
    cost=300000,
    desc="Schnell und einfach nur geiler Sound!",
	entity="prop_vehicle_jeep",
	vehsname="997gt3tdm",
	DOnly=true,
	fuel=100,
	hp=580
}
CSVehicles.Cars[26] = {--
    name="Lamborghini Murcielago",
    model="models/tdmcars/murcielago.mdl",
    cost=315000,
    desc="Schnell und einfach nur geiler Sound!",
	entity="prop_vehicle_jeep",
	vehsname="murcielagotdm",
	DOnly=false,
	fuel=100,
	hp=600
}
CSVehicles.Cars[27] = {--
    name="Lamborghini Gallardo",
    model="models/tdmcars/gallardo.mdl",
    cost=330000,
    desc="Schnell und cooles Design!",
	entity="prop_vehicle_jeep",
	vehsname="gallardotdm",
	DOnly=true,
	fuel=100,
	hp=620
}
CSVehicles.Cars[28] = {--
    name="Mercedes SL65 AMG",
    model="models/tdmcars/sl65amg.mdl",
    cost=865500,
    desc="Sehr Schnell und cooles Design!",
	entity="prop_vehicle_jeep",
	vehsname="sl65amgtdm",
	DOnly=false,
	fuel=100,
	hp=950
}
CSVehicles.Cars[29] = {--
    name="Paganie Zonda C12",
    model="models/tdmcars/zondac12.mdl",
    cost=395000,
    desc="Sehr Schnell und direkt von der Rennstrecke!",
	entity="prop_vehicle_jeep",
	vehsname="c12tdm",
	DOnly=false,
	fuel=100,
	hp=680
}
CSVehicles.Cars[30] = {--
    name="Anston Martin DBS",
    model="models/tdmcars/dbs.mdl",
    cost=535500,
    desc="Gutes Handling, Beschleunigung sowie kleiner Verbraucht.",
	entity="prop_vehicle_jeep",
	vehsname="dbstdm",
	DOnly=false,
	fuel=100,
	hp=700
}
CSVehicles.Cars[31] = {--
    name="Bugatti Veyron 16.4",
    model="models/tdmcars/bugattiveyron.mdl",
    cost=1350500,
    desc="Dieses Auto ist das pure Monster. Sehr gute Beschleunigung, Verarbeitung jedoch schlechtes Handling.",
	entity="prop_vehicle_jeep",
	vehsname="bugattiveyrontdm",
	DOnly=true,
	fuel=100,
	hp=950
}