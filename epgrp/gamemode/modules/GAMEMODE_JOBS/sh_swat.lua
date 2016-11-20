local JOB = {}

JOB.Name = "SWAT"                               // Wie der Job heißt
JOB.Description = "Bla Bla Bla"                 // Beschreibung vom Job
JOB.Model = {"models/gign remasteredhd.mdl"}       // Das/-Die Model/s vom Job
JOB.Color = Color( 51, 153, 255, 255 )             // Welche Farbe hat das Team?
JOB.Armor = 100                                 // Wie viel Rüstung der Spieler bekommt
JOB.Weapons = { "hands",               // Was hat der Job für Waffen?
                "keys",
				"weapon_arc_atmcard",
                "weapon_fists",
                "door_ram",
                "m9k_hk45",
                "weapon_stick",
                "riot_shield",
                "m9k_mp5sd",
				"weapon_policeshield"
}
JOB.DemoteOnDeath = false
JOB.DemoteMessage = nil

// Economy
JOB.Max = 4                                     // Maximale anzahl muss in den ECONOMY EINSTELLUNGEN angepasst werden. Dies ist nur der anfangswert
JOB.Lohn = 180                                  // Wie viel Lohn der angestellte bekommt
JOB.CanWarrant = false                          // Kann der Job ein Warrant beantragen / erstellen?
JOB.MaxCars = 2                                 // Wie viele Dienstwagen die Stadt haben darf / kann. Auch dies muss in den ECONOMY EINSTELLUNGEN angepasst werden

// Restrictions
JOB.RequiredGameMinutes = 1440                   // Wie lange der Spieler gespielt haben muss, bevor er diesen Job ausführen kann
JOB.RequiredSex = 0                             // Welches geschlecht der Spieler haben muss. 0 = egal, 1 = Mann, 2 = Frau
JOB.RequiredBodySize = 0                        // Welche Körpergröße der Spieler haben muss, damit er diesen Job ausführen kann. 0 = egal
JOB.RequiredRuf = 50							// Wie viel Ruf man braucht um diesen Job ausüben zu können

JOB.CarType = {}
JOB.CarType["escaladetdm"] = "Der Normale SWAT-Truck"

JOB.CarArmor = 100
JOB.CarColor = Color( 0, 0, 0, 255 )
JOB.CarSkin = nil
JOB.CarSpawns = {}
JOB.CarSpawns[1] = {pos=Vector(-7555, -10011, -186), ang=Angle(0, -90, 0)}
JOB.CarSpawns[2] = {pos=Vector(-7555, -9765 -186), ang=Angle(0, -90, 0)}
JOB.CarSpawns[3] = {pos=Vector(-6999, -9757, -186), ang=Angle(0, 125, 0)}

// Now we load the Job. The Function will return the Job index.
JOB.ENUM = "TEAM_SWAT"
TEAM_SWAT = RegisterTeam( JOB )

