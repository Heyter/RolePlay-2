local JOB = {}

JOB.Name = "Polizei"                            // Wie der Job heißt
JOB.Description = "Bla Bla Bla"                 // Beschreibung vom Job
JOB.Model = {"models/taggart/police01/male_01.mdl",
            "models/taggart/police01/male_02.mdl",
            "models/taggart/police01/male_03.mdl",
            "models/taggart/police01/male_04.mdl",
            "models/taggart/police01/male_05.mdl",
            "models/taggart/police01/male_06.mdl",
            "models/taggart/police01/male_07.mdl",
            "models/taggart/police01/male_08.mdl",
            "models/taggart/police01/male_09.mdl"
            }       // Das/-Die Model/s vom Job
JOB.Color = Color( 0, 0, 200, 255 )             // Welche Farbe hat das Team?
JOB.Armor = 30                                   // Wie viel Rüstung der Spieler bekommt
JOB.Weapons = { "weapon_physcannon",               // Was hat der Job für Waffen?
                "keys",
				"weapon_arc_atmcard",
                "weapon_fists",
                "m9k_sig_p229r", 
                "weapon_r_handcuffs", 
                "weapon_stick"
}
JOB.DemoteOnDeath = false
JOB.DemoteMessage = nil

// Economy
JOB.Max = 4                                     // Maximale anzahl muss in den ECONOMY EINSTELLUNGEN angepasst werden. Dies ist nur der anfangswert
JOB.Lohn = 100                                  // Wie viel Lohn der angestellte bekommt
JOB.CanWarrant = true                           // Kann der Job ein Warrant beantragen / erstellen?
JOB.MaxCars = 8                                 // Wie viele Dienstwagen die Stadt haben darf / kann. Auch dies muss in den ECONOMY EINSTELLUNGEN angepasst werden

// Restrictions
JOB.RequiredGameMinutes = 720                  // Wie lange der Spieler gespielt haben muss, bevor er diesen Job ausführen kann
JOB.RequiredSex = 0                             // Welches geschlecht der Spieler haben muss. 0 = egal, 1 = Mann, 2 = Frau
JOB.RequiredBodySize = 0                        // Welche Körpergröße der Spieler haben muss, damit er diesen Job ausführen kann. 0 = egal

JOB.CarType = "mitsuevoxpoltdm"
JOB.CarArmor = 100
JOB.CarColor = nil
JOB.CarSkin = nil
JOB.CarSpawns = {}
JOB.CarSpawns[1] = {pos=Vector(-7567, -9209, -186), ang=Angle(0, -90, 0)}
JOB.CarSpawns[2] = {pos=Vector(-6967, -9475, -183), ang=Angle(0, -90, 0)}
JOB.CarSpawns[3] = {pos=Vector(-6970, -9464, -186), ang=Angle(0, 90, 0)}
JOB.CarSpawns[4] = {pos=Vector(-6970, -9226, -186), ang=Angle(0, 90, 0)}



// Now we load the Job. The Function will return the Job index.
JOB.ENUM = "TEAM_POLICE"
TEAM_POLICE = RegisterTeam( JOB )

