// DON'T TOUCH THIS OR THE GAMEMODE WILL BREAK!!!   
PLUGINS = {}
SETTINGS = {}
////////////////////////////////////////////////


///////////////////////////////////////////////////////
//                                                   //
//          Konfiguration des Role-Play's            //  
//                                                   //
///////////////////////////////////////////////////////
// GAMEMEMODE BY: ThaRealCamotrax                    //
///////////////////////////////////////////////////////

SETTINGS.LANGUAGE = "GER" 
SETTINGS.SCOREBOARD_TITLE = "EPG - RolePlay"
SETTINGS.SCOREBOARD_SUBTITLE = "- PreAlpha -"

// Stamina Settings
SETTINGS.STAMINA_REFILL_SPEED = 0.75
SETTINGS.STAMINA_REFILL_REFILLAMD = 0.5
SETTINGS.STAMINA_REFILL_DRAIN = 3
SETTINGS.STAMINA_EXP_GIVE_AT = 1000					// Bei wie viel wiederhergestellten stamina die exp vergeben werden sollen
SETTINGS.STAMINA_EXP = 1980							// Wie oft der anteil der wiederhergestellten Stamina als exp gegeben wird. ( 1000 / 1980 = 0.5051 ... )
SETTINGS.STAMINA_SOUND = "nosrp/human_sounds/breath.wav"
SETTINGS.STAMINA_REPLAY = 0.717

// Warrant
SETTINGS.MAX_STARS = 5                              //  Maximale Anzahl der Warrant Stufen
SETTINGS.WARRANT_LENGHT = {320, 320, 320, 320, 320}        //  Abklingzeiten der einzelnen Sterne

// Name Change
SETTINGS.NameChangeCost = 10000

// Item Settings
SETTINGS.SaleItemHP = 300                           //  + Skill level
SETTINGS.PropHP = 100                               //  + die masse

// GENE -/ SKILL SETTINGS
SETTINGS.StartGenePoints = 5                       //  Wie viele Gene -/ Skillpunkte man am anfang hat.
SETTINGS.GenePointCost = 5000                       //  Wie viel ein Gene-Point kostet
SETTINGS.GenePointVIPDiscount = 10                  //  ( % ) wie viel bekommen Vip's rabatt auf gene punkte
SETTINGS.GeneTypes = {}

// Haupt Skills
SETTINGS.GeneTypes[1] = {name="Kraft", desc="Benötigt für das herstellen von Items oder auch zum ergänzen der Schlagkraft mit den Fäusten.", standart_wert=0, max=25, show_in_registration=true, can_skill=true}
SETTINGS.GeneTypes[2] = {name="Intelligenz", desc="Wird zum herstellen von Item benötigt.", standart_wert=0, max=25, show_in_registration=true, can_skill=true}
SETTINGS.GeneTypes[3] = {name="Einfluss", desc="Diese Fähigkeit wird benötigt wenn du z.B die Stadt oder Clan's verwalten möchtest.", standart_wert=0, max=25, show_in_registration=true, can_skill=true}
SETTINGS.GeneTypes[4] = {name="Vertrauen", desc="Dies ist eine Sehr wichtige Eigenschaft deines Charakters, wenn du Legal tätig bist.", standart_wert=0, max=25, show_in_registration=true, can_skill=true}
SETTINGS.GeneTypes[5] = {name="Handwerks Geschick", desc="Wird benötigt um komplizierte Items herzustellen.", standart_wert=0, max=25, show_in_registration=true, can_skill=true}

// Passive Skills
SETTINGS.GeneTypes[6] = {name="Ausdauer", desc="Dies ist deine Ausdauer. Desto mehr Punkte du hast, desto länger -/ stärker kannst du Rennen -/ Zuschlagen.", standart_wert=0, max=10, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[7] = {name="Erste Hilfe", desc="Wenn du viele Punkte in diesem Bereich hast, werden deine Heilungen stärker. ( Heal-Pots )", standart_wert=0, max=10, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[8] = {name="Ruf", desc="Dies ist dein Ruf in der Stadt. Er variiert je nachdem was du tust.", standart_wert=50, max=100, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[9] = {name="Handels Fähigkeit", desc="Diese Fähigkeit levelst du indem du sachen Verkauft. Mehr Punkte = Mehr Lebenspunkte deiner Artikel.", standart_wert=0, max=150, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[10] = {name="Management", desc="Solltest du mal die Stadt verwalten, kann dieser Skill sehr hilfreich sein. Finde raus weshalb.", standart_wert=0, max=100, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[11] = {name="Weed Erfahrung", desc="Dies ist deine Erfahrung mit Weed-Pflanzen. Je nach Punkte, variiert auch die Ausbeute.", standart_wert=0, max=10, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[12] = {name="Cocaine Erfahrung", desc="Dies ist deine Erfahrung mit Cocaine-Pflanzen. Je nach Punkte, variiert auch die Ausbeute.", standart_wert=0, max=10, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[13] = {name="Schloss Knacken", desc="Um so höher dieser Skill ist, desto schneller werden Schlösser geknackt.", standart_wert=0, max=15, show_in_registration=false, can_skill=false}
SETTINGS.GeneTypes[14] = {name="Abhärtung", desc="Um so mehr Abhärung du dast, desto mehr Schmerz kannst du ertragen.", standart_wert=0, max=10, show_in_registration=false, can_skill=false}

// Body Mod
SETTINGS.CrippledWalkSpeed = 90                     // Schritt Tempo, wenn die Beine gebrochen sind
SETTINGS.CrippledRunSpeed = 100                     // Lauf Tempo, wenn die Beine gebrochen sind

// GENERAL SETTINGS
SETTINGS.WalkSpeed = 150                            //  Maximales Schritt-Tempo
SETTINGS.RunSpeed = 260                             //  Maximales Lauf-Tempo
SETTINGS.PayDayTime = 600                           //  Wie viel Zeit vergehen soll, sobald ein PayDay eintritt. ( Sekunden )
SETTINGS.StartingCash = 10000                       //  Mit wie viel Geld der Spieler starten soll
SETTINGS.StartingBank = 5000                        //  Mit wie viel GELD AUF DER BANK der Spieler starten soll
SETTINGS.VoiceRadius = 500                         //  Die Reichweite des Voicechats
SETTINGS.AdvertCost = 25                           // Wie viel eine Werbung ist
SETTINGS.CharModels = {                             //  Alle Models, die ein Spieler in der Char-Creation auswählen kann
"models/player/group01/female_01.mdl",
"models/player/group01/female_02.mdl",
"models/player/group01/female_03.mdl",
"models/player/group01/female_04.mdl",
"models/player/group01/female_05.mdl",
"models/player/group01/female_06.mdl",
"models/player/group01/male_01.mdl",
"models/player/group01/male_02.mdl",
"models/player/group01/male_03.mdl",
"models/player/group01/male_04.mdl",
"models/player/group01/male_05.mdl",
"models/player/group01/male_06.mdl",
"models/player/group01/male_07.mdl",
"models/player/group01/male_08.mdl",
"models/player/group01/male_09.mdl"
}

// Job Related
SETTINGS.VIPPayDayPercent = 15                      //  ( % ) Wie viel mehr die Vips bekommen sollen. ( Wird multipliziert *1, *2, *3 )!
SETTINGS.VIPPlaytimePercent = 15                    //  ( % ) Reduzierung der benötigten Spielzeit z.B bei Jobs, bei Vip's
SETTINGS.ReviveReward = 50

// Drugs
SETTINGS.MaxWeedDrugs = 6                           //  Wie viele Weed Drogen man anpflanzen kann
SETTINGS.VIPWeedAdd = 2                             //  Wie viel mehr Weed-Pflanzen man anbauen darf PRO Vip Level. ( *1, *2, *3 )