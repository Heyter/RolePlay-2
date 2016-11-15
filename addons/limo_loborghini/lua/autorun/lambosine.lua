local Category = "SGM Cars"

local V = {
				// Required information
				Name =	"2012 Lamborghini Aventador Lambosine",
				Class = "prop_vehicle_jeep",
				Category = Category,

				// Optional information
				Author = "SentryGunMan, Turn 10",
				Information = "vroom vroom",
				Model =	"models/sentry/lambosine.mdl",

			
				KeyValues = {				
								vehiclescript =	"scripts/vehicles/sentry/lambosine.txt"
					    }
}

list.Set( "Vehicles", "lambosine", V )
