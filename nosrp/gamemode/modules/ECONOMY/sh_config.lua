ECONOMY = ECONOMY or {}

// General
ECONOMY.MAX = 25000
ECONOMY.MIN = 0
ECONOMY.CAR_COST = 150                  // Wie teuer ein Dienstwagen ist
ECONOMY.MONTH_LAST = 1800                // Wie lange ein Monat dauert ( Für das log usw )
ECONOMY.ADMINISTRATORS = { TEAM_MAYOR } // Welche Jobs auf die Economy einstellungen zugreifen können.

// Munition
ECONOMY.AMMOROUND_COST = 2

// Gas
ECONOMY.GASPREIS = 2

// Bank
ECONOMY.BANKZINSEN = 0.2
ECONOMY.MAX_BANKZINSEN = 0.5            // Wie viel der Mayor maximal einstellen kann.
ECONOMY.BANKZINSINTERVAL = 760          // Alle < Sekunden > werden die BANKZINSEN gutgeschrieben.

// Kauf - und Verkaufssteuer
ECONOMY.KAUFSTEUER = 0.1
ECONOMY.MAX_KAUFSTEUER = 0.3            // Wie viel der Mayor maximal einstellen kann.

ECONOMY.VERKAUFSSTEUER = 0.2            // Wie viel der Mayor maximal einstellen kann.
ECONOMY.MAX_VERKAUFSSTEUER = 0.5

ECONOMY.PAYDAY_STEUER = 0.2

ECONOMY.SHOPITEMS = {}
ECONOMY.SPAWN_DISTANCE = 150

ECONOMY.SHOPITEMS["Geld Drucker"] = {
        desc = "Pleite? Dann ist dies die beste Lösung!",
        model="models/props/cs_assault/MoneyPallet.mdl",
        ent="city_printer", 
        cost=0, 
        max=4
    }
ECONOMY.SHOPITEMS["Blitzanlage"] = {
        desc = "Stelle eine Blitzanlage auf, um Speed-Raudies den gar auszumachen.( 30 Minuten Standzeit ).",
        model="models/blitzer/blitzer.mdl",
        ent="ent_blitzer", 
        cost=500, 
        max=6
    }
ECONOMY.SHOPITEMS["Rüstungs Terminal"] = {
        desc = "Hier können SWAT, Polizei sowie Secret Service ihre Munition auffüllen und Waffen verwalten.",
        model="models/Items/ammocrate_smg1.mdl",
        ent="supply_box", 
        cost=1500, 
        max=6
    }


// Steuer Administration
ECONOMY.STEUERPANEL = {}

ECONOMY.STEUERPANEL["Kaufsteuer"] = {
    description = "Dies ist die Kaufsteuer. Sie wird erhoben wenn ein Spieler ein Gegenstand kauft.",
    min = 0,
    max = ECONOMY.MAX_KAUFSTEUER,
    key = "KAUFSTEUER"
}
ECONOMY.STEUERPANEL["Benzin Preis"] = {
    description = "Hier regelst du, was ein Liter Benzin kosten soll.",
    min = 0.1,
    max = 5,
    key = "GASPREIS"
}
ECONOMY.STEUERPANEL["Zahltag Steuer"] = {
    description = "Dies ist die Zahltagssteuer. Sie wird erhoben wenn ein Spieler sein Lohn bekommt.",
    min = 0,
    max = 0.8,
    key = "PAYDAY_STEUER"
}
ECONOMY.STEUERPANEL["Bankzinsen"] = {
    description = "Hier kannst du einstellen wie viele Zinsen Spieler auf ihr Bankgeld bekommen sollen.",
    min = 0,
    max = ECONOMY.MAX_BANKZINSEN,
    key = "BANKZINSEN"
}



// Job Administration
ECONOMY.JOBPANELS = {}

/*  Types:
        1. slider
        2. text
        3. checkbox
*/

ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_FIRE )] = {
        Job = TEAM_SECRETSERVICE,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=250},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=10},
        SETTING4 = {Name="Armor", key="Armor", typ="slider", min=0, max=30},
        SETTING5 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=6}   // Kann nur gepanzerte Wagen anfordern
}
ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_TRASH )] = {
        Job = TEAM_SECRETSERVICE,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=150},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=6},
        SETTING5 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=5}   // Kann nur gepanzerte Wagen anfordern
}
ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_SECRETSERVICE )] = {
        Job = TEAM_SECRETSERVICE,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=300},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=6},
        SETTING3 = {Name="Warrant Rights", key="CanWarrant", typ="checkbox"},
        SETTING4 = {Name="Armor", key="Armor", typ="slider", min=0, max=20},
        SETTING5 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=2}   // Kann nur gepanzerte Wagen anfordern
}

ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_POLICE )] = {
        Job = TEAM_POLICE,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=150},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=10},
        SETTING3 = {Name="Warrant Rights", key="CanWarrant", typ="checkbox"},
        SETTING4 = {Name="Armor", key="Armor", typ="slider", min=0, max=10},
        SETTING5 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=10}
}

ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_SWAT )] = {
        Job = TEAM_SWAT,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=250},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=8},
        SETTING3 = {Name="Warrant Rights", key="CanWarrant", typ="checkbox"},
        SETTING4 = {Name="Armor", key="Armor", typ="slider", min=0, max=100},
        SETTING5 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=8}
}

ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_MEDIC )] = {
        Job = TEAM_MEDIC,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=120},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=6},
        SETTING3 = {Name="Armor", key="Armor", typ="slider", min=0, max=10},
        SETTING4 = {Name="Available Vehicles", key="MaxCars", typ="slider", min=0, max=3}
}
ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_ROAD )] = {
        Job = TEAM_ROAD,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=45},
        SETTING2 = {Name="Max Employee", key="Max", typ="slider", min=0, max=4}
}
ECONOMY.JOBPANELS["TEAM_" .. tostring( TEAM_CITIZEN )] = {
        Job = TEAM_CITIZEN,
        SETTING1 = {Name="Lohn", key="Lohn", typ="slider", min=0, max=45}
}

function GetMayor()
    return (team.GetPlayers( TEAM_MAYOR )[1] or nil)
end