DRUGDEALER = DRUGDEALER or {}
DRUGDEALER.CONFIG = {}

// Don't touch!
DRUGDEALER.CurDealer = nil
DRUGDEALER.LastSwitch = CurTime() - 601
DRUGDEALER.Purchasing = true
DRUGDEALER.Selling = true
DRUGDEALER.Stocks = {}
//

DRUGDEALER.CONFIG.DrugTranslate = {}		// Erste = Endprodukt | Zweite = Vorprodukt | Name | Name2
DRUGDEALER.CONFIG.DrugTranslate["Weed"] = {"drug_weed", "weed_seed", "Weed Samen", "Weed"}

DRUGDEALER.CONFIG.RotationTime = 600        // Wie lange es dauert, bis ein neuer Drugdealer ausgewählt wird
DRUGDEALER.CONFIG.QualityCheckTime = 10     // Wie lange es dauert, bis man die Qualität sieht. ( je nach erfahrung| schlägt fehl / nicht )
DRUGDEALER.CONFIG.QualitySucceedChance = 40	// 40%


// Growing
DRUGDEALER.CONFIG.DefaultMinQuality = -10		// Kann maxiamal 10 weniger qualität als der Samen haben
DRUGDEALER.CONFIG.DefaultMaxQuality = 25		// Kann maxiamal ... mehr qualität als der Samen haben + Erfahrung
DRUGDEALER.CONFIG.EXPQualityIncrease = 2		// Bekommt pro skillpunkt +2 maximale bessere qualität

DRUGDEALER.CONFIG.MinGramm = 7			// 10€ Max Verlust
DRUGDEALER.CONFIG.MaxGramm = 25			// Maximale Gramm was man bekommen kann
DRUGDEALER.CONFIG.SkillGIncrease = 0.6		// 10 punkte = 6 erhöhte min gramm


///

function DRUGDEALER.TranslateToEntName( type )
    return DRUGDEALER.CONFIG.DrugTranslate[type]
end

function DRUGDEALER.GetFirstProduct( type )
    return DRUGDEALER.CONFIG.DrugTranslate[type][1]
end

function DRUGDEALER.GetSecondProduct( type )
    return DRUGDEALER.CONFIG.DrugTranslate[type][2]
end

function DRUGDEALER.GetSellingIndex( type )
	for k, v in pairs( DRUGDEALER.Dealers[DRUGDEALER.CurDealer].selling ) do
		if v == type then return k end
	end
	return nil
end

function DRUGDEALER.TranslateFromEntName( type )
    for k, v in pairs( DRUGDEALER.CONFIG.DrugTranslate ) do
        if v[2] == type then return v[3] end
    end
end

function DRUGDEALER.TranslateClassToName( class )
    for k, v in pairs( DRUGDEALER.CONFIG.DrugTranslate ) do
        if v[1] == class then return v[4] end
    end
end