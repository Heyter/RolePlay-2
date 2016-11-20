local JOB = {}

JOB.Name = "Mayor"                            // Wie der Job heißt
JOB.Description = "Bla Bla Bla"                 // Beschreibung vom Job
JOB.Model = {"models/player/breen.mdl"}       // Das/-Die Model/s vom Job
JOB.Color = Color( 200, 0, 0, 255 )             // Welche Farbe hat das Team?
JOB.Armor = 50                                   // Wie viel Rüstung der Spieler bekommt
JOB.Weapons = { "hands",            // Was hat der Job für Waffen?
                "keys",
				"weapon_arc_atmcard",
                "weapon_fists"
}
JOB.DemoteOnDeath = true
JOB.DemoteMessage = "Der Mayor ist durch ein Unglück gestorben!"

// Economy
JOB.Max = 1                                     // Maximale anzahl muss in den ECONOMY EINSTELLUNGEN angepasst werden. Dies ist nur der anfangswert
JOB.Lohn = 150                                  // Wie viel Lohn der angestellte bekommt
JOB.CanWarrant = true                           // Kann der Job ein Warrant beantragen / erstellen?
JOB.MaxCars = 0                                 // Wie viele Dienstwagen die Stadt haben darf / kann. Auch dies muss in den ECONOMY EINSTELLUNGEN angepasst werden

// Restrictions
JOB.RequiredGameMinutes = 2880                   // Wie lange der Spieler gespielt haben muss, bevor er diesen Job ausführen kann
JOB.RequiredSex = 0                             // Welches geschlecht der Spieler haben muss. 0 = egal, 1 = Mann, 2 = Frau
JOB.RequiredBodySize = 0                        // Welche Körpergröße der Spieler haben muss, damit er diesen Job ausführen kann. 0 = egal



// Now we load the Job. The Function will return the Job index.
JOB.ENUM = "TEAM_MAYOR"
TEAM_MAYOR = RegisterTeam( JOB )

