local JOB = {}

JOB.Name = "Secret Service"                     // Wie der Job heißt
JOB.Description = "Bla Bla Bla"                 // Beschreibung vom Job
JOB.Model = {"models/player/suits/male_05_open.mdl",
            "models/player/suits/male_02_open_tie.mdl",
            "models/player/suits/male_07_open.mdl",
            "models/player/suits/male_09_open_tie.mdl",
            "models/player/suits/male_08_open.mdl"
            }       // Das/-Die Model/s vom Job
JOB.Color = Color( 0, 200, 0, 255 )             // Welche Farbe hat das Team?
JOB.Armor = 50                                   // Wie viel Rüstung der Spieler bekommt
JOB.Weapons = { "weapon_physgun",               // Was hat der Job für Waffen?
                "weapon_physcannon",
                "weapon_fists",
                "keys", 
				"weapon_arc_atmcard",
                "m9k_usp", 
                "m9k_mp7", 
                "weapon_stick"
}
JOB.DemoteOnDeath = false
JOB.DemoteMessage = nil
JOB.RequireMayor = true

// Economy
JOB.Max = 4                                     // Maximale anzahl muss in den ECONOMY EINSTELLUNGEN angepasst werden. Dies ist nur der anfangswert
JOB.Lohn = 110                                  // Wie viel Lohn der angestellte bekommt
JOB.CanWarrant = true                           // Kann der Job ein Warrant beantragen / erstellen?
JOB.MaxCars = 2                                 // Wie viele Dienstwagen die Stadt haben darf / kann. Auch dies muss in den ECONOMY EINSTELLUNGEN angepasst werden

// Restrictions
JOB.RequiredGameMinutes = 360                   // Wie lange der Spieler gespielt haben muss, bevor er diesen Job ausführen kann
JOB.RequiredSex = 0                             // Welches geschlecht der Spieler haben muss. 0 = egal, 1 = Mann, 2 = Frau
JOB.RequiredBodySize = 0                        // Welche Körpergröße der Spieler haben muss, damit er diesen Job ausführen kann. 0 = egal

JOB.CarType = "lambosine"
JOB.CarArmor = 100
JOB.CarColor = Color( 0, 0, 0, 255 )
JOB.CarSkin = nil
JOB.CarSpawns = {}
JOB.CarSpawns[1] = {pos=Vector(-6974, -8557, 66), ang=Angle(-8, -90, 0)}



// Now we load the Job. The Function will return the Job index.
JOB.ENUM = "TEAM_SECRETSERVICE"
TEAM_SECRETSERVICE = RegisterTeam( JOB )

