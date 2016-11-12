DRUGDEALER = DRUGDEALER or {}
DRUGDEALER.Dealers = DRUGDEALER.Dealers or {}


///////////     WICHTIG!    /////////// /////////// /////////// ///////////
// Kauf Ausgangsrechung = 16(Drogenfaktor) x 15(Preisfaktor) = 240,-EURO || 
// Stunden Rechnung || 240 x 6 ( Pflanzen ) x 3 ( 3 x 20 Minuten = 1 Stunde ) = 4320,-EURO für Normale Spieler!
////////// /////////// /////////// /////////// /////////// /////////// ///////////

DRUGDEALER.Dealers["John.D"] = {
    description = "Fauler dummer Dealer, \nnicht zu empfehlen!",
    ruf = 75,       // Wie viel Ruf du maximal haben darfst, um was bei diesen Dealer kaufen zu können!
    chance = 50,
    model = "models/Humans/Group03/Male_05.mdl",
    
    
    selling = {"Weed"},
    sell_prices = {Weed=80},
    purchase_prices = {Weed=200},
    
    
    quality_check_price = 100,      // Wie teuer es ist, das gras bevor den kauf auf Qualität zu überprüfen.
    sale_quality = {
        Weed = {max=30, min=10, model="models/props_junk/garbage_bag001a.mdl"}
    },
    max_drugs = 50,
    min_drugs = 25
}   // 120 EURO GEWINN | Falls Verkauf! ( 20 Minuten )

DRUGDEALER.Dealers["CrackX"] = {
    description = "Erfahrener Dealer\nSehr qualitativ! \nZumindest meistens.",
    ruf = 30,       // Wie viel Ruf du maximal haben darfst, um was bei diesen Dealer kaufen zu können!
    chance = 10,
    model = "models/Humans/Group03/Male_09.mdl",
    
    
    selling = {"Weed"},
    sell_prices = {Weed=160},
    purchase_prices = {Weed=320},
    
    
    quality_check_price = 175,      // Wie teuer es ist, das gras bevor den kauf auf Qualität zu überprüfen.
    sale_quality = {
        Weed = {max=100, min=80, model="models/props_junk/garbage_bag001a.mdl"}
    },
    max_drugs = 50,
    min_drugs = 25
}