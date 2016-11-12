local Info = {}
Info.TuningStrings = {}

Info.Name = "Corvette"
Info.CarTableName = "audir8"

Info.VIPLevel = 0

Info.Tuning = {}
Info.Tuning["%NOSRP_HorsePower%"] = {
    type = "Engine",
    default = 650,
    max = 1250,
    cost = 4.5,     // 4.5 * Anzahl der HP
    title = "PS",
    desc = "Wer schnell sein will braucht erstmal genug Dampf!"
}
Info.Tuning["%NOSRP_RPM%"] = {
    type = "Engine",
    default = 4000,
    max = 8000,
    cost = 2.5,     // 2.5 * Anzahl der HP
    title = "RPM",
    desc = ""
}
Info.Tuning["%NOSRP_Speed%"] = {
    type = "Engine",
    default = 108,
    max = 350,
    cost = 5.5,     // 5.5 * Anzahl der HP
    title = "Endgeschwindigkeit",
    desc = ""
}
Info.Tuning["%NOSRP_RevSpeed%"] = {
    type = "Engine",
    default = 23,
    max = 40,
    cost = 2.5,     // 2.5 * Anzahl der HP
    title = "Rückwärts-Geschwindigkeit",
    desc = ""
}

Info.TuningStrings[Info.CarTableName] = {file.Read( "scripts/nos_tuning_strings/" .. Info.CarTableName )}

CARSHOP.AddCarTuningString( Info )