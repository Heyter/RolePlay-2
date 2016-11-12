local JOB = {}

JOB.Name = "Trash Man"                               // Wie der Job heißt
JOB.Description = "Bla Bla Bla"                 // Beschreibung vom Job
JOB.Model = {"models/player/odessa.mdl"}       // Das/-Die Model/s vom Job
JOB.Color = Color( 102, 51, 0, 255 )             // Welche Farbe hat das Team?
JOB.Armor = 0                                // Wie viel Rüstung der Spieler bekommt
JOB.Weapons = {"weapon_physcannon",
               "weapon_fists",
               "keys"
}
JOB.DemoteOnDeath = false
JOB.DemoteMessage = nil

// Economy
JOB.Max = 2                                     // Maximale anzahl muss in den ECONOMY EINSTELLUNGEN angepasst werden. Dies ist nur der anfangswert
JOB.Lohn = 75                                  // Wie viel Lohn der angestellte bekommt
JOB.CanWarrant = false                          // Kann der Job ein Warrant beantragen / erstellen?
JOB.MaxCars = 2                                 // Wie viele Dienstwagen die Stadt haben darf / kann. Auch dies muss in den ECONOMY EINSTELLUNGEN angepasst werden

// Restrictions
JOB.RequiredGameMinutes = 0                   // Wie lange der Spieler gespielt haben muss, bevor er diesen Job ausführen kann
JOB.RequiredSex = 0                             // Welches geschlecht der Spieler haben muss. 0 = egal, 1 = Mann, 2 = Frau
JOB.RequiredBodySize = 0                        // Welche Körpergröße der Spieler haben muss, damit er diesen Job ausführen kann. 0 = egal

JOB.CarType = "scaniahtdm"
JOB.CarArmor = 0
JOB.CarColor = Color( 255, 255, 255, 255 )
JOB.CarSkin = nil
JOB.CarSpawns = {}
JOB.CarSpawns[1] = {pos=Vector(509, 4019, 64), ang=Angle(0, 90, 0)}
JOB.CarSpawns[2] = {pos=Vector(194, 4024, 61), ang=Angle(0, 90, 0)}

// Now we load the Job. The Function will return the Job index.
JOB.ENUM = "TEAM_TRASH"
TEAM_TRASH = RegisterTeam( JOB )

