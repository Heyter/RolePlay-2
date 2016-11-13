local Category = "SGM Cars"

local V = {
				// Required information
				Name =	"2012 Lamborghini Aventador",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "SentryGunMan, Turn 10",
				Information = "vroom vroom",
				Model =	"models/sentry/aventador.mdl",

			
				KeyValues = {				
								vehiclescript =	"scripts/vehicles/sentry/aventador.txt"
					    }
}

list.Set( "Vehicles", "aventador", V )
