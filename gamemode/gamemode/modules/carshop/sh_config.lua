CARSHOP = CARSHOP or {}
CARSHOP.CONFIG = {}
CARSHOP.CARTABLE = {}
CARSHOP.CARTABLE.CARS = {}
CARSHOP.CARTABLE.SHOP = {}
CARSHOP.CARTABLE.TUNER = {}

CARSHOP.CONFIG.NosPointsEnabled = false

CARSHOP.CONFIG.TuningEnabled = false
CARSHOP.CONFIG.ShopEnabled = true
CARSHOP.CONFIG.KatalogEnabled = true
CARSHOP.CONFIG.MarketplaceEnabled = false
CARSHOP.CONFIG.CarDamageEnabled = true
CARSHOP.CONFIG.CarShippingEnabled = true
CARSHOP.CONFIG.CarSellingEnabled = true

CARSHOP.CONFIG.ExplodeRadius = 350

CARSHOP.CONFIG.MinDamageClass = 0.1
CARSHOP.CONFIG.MaxDamageClass = 2

CARSHOP.CONFIG.RepairTime = 320
CARSHOP.CONFIG.CarChangeInterval = 3600
CARSHOP.CONFIG.CarShippingTime = 320
CARSHOP.CONFIG.MinCarsInShop = 10
CARSHOP.CONFIG.MaxCarsInShop = 20

CARSHOP.CONFIG.MaxCars = 3
CARSHOP.CONFIG.VIPMaxCars = 1   // + * 3 ( Vip 1 = +1, VIP = +2 ... )

CARSHOP.CONFIG.CarSpawningCost = false
CARSHOP.CONFIG.CarSpawnCost = 50

CARSHOP.CONFIG.CanBuyInstaRepair = true


// Dont remove!
function CARSHOP.CalculateRepairCost( carname, ply )
    local tbl = CARSHOP.CARTABLE.CARS[carname] or nil
    --local garage = ply:GetRPVar( "garage_table" )[carname]
    if tbl == nil then return 3500 end
    
    return (tbl.Cost*tbl.Damage_Class)/4
end
//

CARSHOP.CONFIG.GarageSpawns = {}
CARSHOP.CONFIG.GarageSpawns["rp_evocity_v33x"] = {
    {
		ang = Angle(0, 90, 0),
		pos = Vector(4094.517334, -3754.564453, 64.031250)
	},
    {
		ang = Angle(0, 90, 0),
		pos = Vector(4094.433350, -4265.530762, 64.031250)
	},
    {
		ang = Angle(0, 180, 0),
		pos = Vector(-5275, -10593, 71)
	},
    {
		ang = Angle(0, 180, 0),
		pos = Vector(-5125, -10593, 71)
	},
    {
		ang = Angle(0, 180, 0),
		pos = Vector(-5075, -10593, 71)
	}
}

CARSHOP.CARTABLE.CARS["v12vantagetdm"] = {
    Name = "Aston Martin V12 Vantage 2010",
    Desc = "Sport",
    Model = "models/tdmcars/aston_v12vantage.mdl",
    Damage_Class = 0.4, // 1.2 * den Kaufpreis als Repair Kosten
    Katalog_Shipping_Time = 3600,
    Cost = 270000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["audir8spydtdm"] = {
    Name = "Audi R8 GT Spyder",
    Desc = "Sport",
    Model = "models/tdmcars/audi_r8_spyder.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 300000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["audir8plustdm"] = {
    Name = "Audi R8+",
    Desc = "Sport",
    Model = "models/tdmcars/audi_r8_plus.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 320000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["rs4avanttdm"] = {
    Name = "Audi RS4 Avant",
    Desc = "Limousine",
    Model = "models/tdmcars/aud_rs4avant.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 280000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["s5tdm"] = {
    Name = "Audi S5",
    Desc = "Limousine",
    Model = "models/tdmcars/s5.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 280000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["auditttdm"] = {
    Name = "Audi TT 07",
    Desc = "Coupé",
    Model = "models/tdmcars/auditt.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 285000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["m3e92tdm"] = {
    Name = "BMW M3 E92",
    Desc = "Sport",
    Model = "models/tdmcars/bmwm3e92.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 260000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["m5e34tdm"] = {
    Name = "BMW M5 E34",
    Desc = "Oldtimer",
    Model = "models/tdmcars/bmwm5e34.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 210000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["bmwm5e60tdm"] = {
    Name = "BMW M5 E60",
    Desc = "Sport",
    Model = "models/tdmcars/bmwm5e60.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 275000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["bmwm613tdm"] = {
    Name = "BMW M6 2013",
    Desc = "Sport",
    Model = "models/tdmcars/bmw_m6_13.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 310000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["veyrontdm"] = {
    Name = "Bugatti Veyron",
    Desc = "Sport",
    Model = "models/tdmcars/bug_veyron.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 750000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["veyronsstdm"] = {
    Name = "Bugatti Veyron SS",
    Desc = "Sport",
    Model = "models/tdmcars/bug_veyronss.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 850000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["escaladetdm"] = {
    Name = "Cadillac Escalade 2012",
    Desc = "Pickup",
    Model = "models/tdmcars/cad_escalade.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["69camarotdm"] = {
    Name = "Chevrolet Camaro SS 69",
    Desc = "Oldtimer",
    Model = "models/tdmcars/69camaro.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 225000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["camarozl1tdm"] = {
    Name = "Chevrolet Camaro ZL1",
    Desc = "Sport",
    Model = "models/tdmcars/chev_camzl1.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 260000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["chevellesstdm"] = {
    Name = "Chevrolet Chevelle SS",
    Desc = "Oldtimer",
    Model = "models/tdmcars/chevelless.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 210000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["challenger70tdm"] = {
    Name = "Dodge Challenger 1970",
    Desc = "Oldtimer",
    Model = "models/tdmcars/dod_challenger70.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["charger2012tdm"] = {
    Name = "Dodge Charger SRT8 2012",
    Desc = "Sport",
    Model = "models/tdmcars/dod_challenger70.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["458spidtdm"] = {
    Name = "Ferrari 458 Spider",
    Desc = "Sport",
    Model = "models/tdmcars/fer_458spid.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 285000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["ferf12tdm"] = {
    Name = "Ferrari F12 Berlinetta",
    Desc = "Sport",
    Model = "models/tdmcars/fer_f12.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 300000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["lafertdm"] = {
    Name = "Ferrari LaFerrari",
    Desc = "Sport",
    Model = "models/tdmcars/fer_lafer.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 325000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["focusrstdm"] = {
    Name = "Ford Focus RS",
    Desc = "Sport",
    Model = "models/tdmcars/focusrs.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 250000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["gt05tdm"] = {
    Name = "Ford GT 05",
    Desc = "Sport",
    Model = "models/tdmcars/gt05.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 320000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["mustanggttdm"] = {
    Name = "Ford Mustang GT",
    Desc = "Sport",
    Model = "models/tdmcars/for_mustanggt.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 260000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["gallardotdm"] = {
    Name = "Lamborghini Gallardo",
    Desc = "Sport",
    Model = "models/tdmcars/gallardo.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 360000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["gallardospydtdm"] = {
    Name = "Lamborghini Gallardo LP570-4 Spyder Performante",
    Desc = "Sport",
    Model = "models/tdmcars/lam_gallardospyd.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 400000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["murcielagotdm"] = {
    Name = "Lamborghini Murcielago",
    Desc = "Sport",
    Model = "models/tdmcars/murcielago.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 380000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["murcielagosvtdm"] = {
    Name = "Lamborghini Murcielago LP 670-4 SV",
    Desc = "Sport",
    Model = "models/tdmcars/lambo_murcielagosv.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 450000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["reventonrtdm"] = {
    Name = "Lamborghini Reventon Roadster",
    Desc = "Sport",
    Model = "models/tdmcars/reventon_roadster.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 490000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["mere63tdm"] = {
    Name = "Mercedes-Benz E63 AMG",
    Desc = "Limousine",
    Model = "models/tdmcars/mer_e63.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["merml63tdm"] = {
    Name = "Mercedes-Benz ML63 AMG",
    Desc = "Pickup",
    Model = "models/tdmcars/mer_ml63.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 180000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["sl65amgtdm"] = {
    Name = "Mercedes-Benz SL65 AMG",
    Desc = "Sport",
    Model = "models/tdmcars/sl65amg.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 270000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["350ztdm"] = {
    Name = "Nissan 350z",
    Desc = "Coupé",
    Model = "models/tdmcars/350z.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 240000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["370ztdm"] = {
    Name = "Nissan 370z",
    Desc = "Coupé",
    Model = "models/tdmcars/nis_370z.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 260000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["gtrtdm"] = {
    Name = "Nissan 370z",
    Desc = "Sport",
    Model = "models/tdmcars/nissan_gtr.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 290000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["r34tdm"] = {
    Name = "Nissan Skyline R34",
    Desc = "Sport",
    Model = "models/tdmcars/skyline_r34.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["vipvipertdm"] = {
    Name = "Viper GTS",
    Desc = "Sport",
    Model = "models/tdmcars/vip_viper.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 280000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["vwcampertdm"] = {
    Name = "Volkswagen Camper 1965",
    Desc = "Oldtimer",
    Model = "models/tdmcars/vw_camper65.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 150000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["golfmk2tdm"] = {
    Name = "Volkswagen Golf MKII",
    Desc = "Oldtimer",
    Model = "models/tdmcars/golf_mk2.mdl",
    Damage_Class = 0.4,
    Katalog_Shipping_Time = 3600,
    Cost = 150000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["vw_golfr32tdm"] = {
    Name = "Volkswagen Golf R32",
    Desc = "Sport",
    Model = "models/tdmcars/vw_golfr32.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 220000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

CARSHOP.CARTABLE.CARS["vwsciroccortdm"] = {
    Name = "Volkswagen Scirocco R",
    Desc = "Sport",
    Model = "models/tdmcars/vw_sciroccor.mdl",
    Damage_Class = 0.5,
    Katalog_Shipping_Time = 3600,
    Cost = 200000,
    Fuel = 100,
    Health = 300,
    Armor = 150,
    Tuneable = false,
    Vip = 0,
    Tuning_File = ""
}

function CARSHOP.GetHighestAmount( key )
    local amd = 0
    for k, v in pairs( CARSHOP.CARTABLE.CARS ) do
        if !(v[key]) then return nil end
        if amd < v[key] then amd = v[key] end
    end
    return amd
end

function CARSHOP.CalculateSellPrice( ply, index )
    local tbl = ply:GetRPVar( "garage_table" ) or {}
    if !(tbl) then return 0 end
    if !(tbl[index]) then return 0 end
    if !(CARSHOP.CARTABLE.CARS[index]) then return 0 end

    local normal = CARSHOP.CARTABLE.CARS[index].Cost / 2
    local wreck_rech = (normal / CARSHOP.CARTABLE.CARS[index].Health) * tbl[index].Health
    
    return wreck_rech
end

function CARSHOP.FindSpawnPos( ply, near )
	CARSHOP.CONFIG.GarageSpawns[tostring(game.GetMap())] = CARSHOP.CONFIG.GarageSpawns[tostring(game.GetMap())] or {}
	near = near or false
	if not near then
		for k, v in pairs( CARSHOP.CONFIG.GarageSpawns[tostring(game.GetMap())] ) do
			if ply:GetPos():Distance( v.pos ) > 1500 then continue end
			local blocks = ents.FindInSphere( v.pos, 20 )
			local found_block = false
			for _, block in pairs( blocks ) do
				block.Owner = block.Owner or nil
				if IsValid( block ) && block:IsVehicle() && block.Owner == ply then CARSHOP.SaveCar( block ) block:Remove() return v end
				if IsValid( block ) then found_block = true continue end
			end
			if found_block then continue end
			return v
		end
		return nil
	else
		for k, v in pairs( CARSHOP.CONFIG.GarageSpawns[tostring(game.GetMap())] ) do
			if ply:GetPos():Distance( v.pos ) > 100 then continue end
			local blocks = ents.FindInSphere( v.pos, 20 )
			local found_block = false
			for _, block in pairs( blocks ) do
				block.Owner = block.Owner or nil
				if IsValid( block ) && block.Owner == ply then return v end
				if IsValid( block ) then found_block = true continue end
			end
			if found_block then continue end
			return v
		end
		return nil
	end
end