--[[
Now supports Novacars
Added text above NPCs

Configs Added:
Jailer NPC text
Bailer NPC text
]]
RHC_JAILER_MODEL = "models/player/Group01/Female_01.mdl"
RHC_JailerText = "Jailer"

RHC_BAILER_MODEL = "models/Barney.mdl"
RHC_BailerText = "Bailer"

//The bail price for each year so -> YEARS*ThisConfig, so 10 years = 5000 in this case
RHC_BailPricePerYear = 500
//How many years(minutes) can a player be arrested for?
RHC_MaxJailYears = 10
//How long it takes to lockpick the cuffs
RHC_CuffPickTime = 15
//How long it takes to cuff someone
RHC_CuffTime = 2
//Range for cuffing
RHC_CuffRange = 75
//Range while dragging, if player is too far away the dragging will cancel
RHC_DragMaxRange = 175
//Does the player has to be cuffed in order to arrest him?
RHC_RestrainArrest = true
//Can only arrest players through the jailer NPC
RHC_NPCArrestOnly = true
//Should the player stay cuffed after arrested?
RHC_RestrainOnArrest = true
//Cuffs must be removed before you can unarrest if this is set to true
RHC_UnarrestMustRemoveCuffs = true
//Give rewards when successfully arrested someone?
RHC_ArrestReward = true
//Reward amount
RHC_ArrestRewardAmount = 250
--[[
1 = Only cuffing player can drag
2 = Only jobs in the RHC_PoliceJobs can drag
3 = Anyone can drag
]]
RHC_DraggingPermissions = 1
//Key to drag a player
//https://wiki.garrysmod.com/page/Enums/IN
RHC_KEY = IN_USE

//Disables drawing player shadow
//Only use this if the shadows are causing issues
//This is a temp fix, will be fixed in the future
RHC_DisablePlayerShadow = false

//Sets players to a specific team when arrested
RHC_SetTeamOnArrest = false
//Allow DarkRP to create teams
timer.Simple(3, function()
	RHC_ArrestTeam = TEAM_GANG
	RHC_PoliceJobs = {TEAM_POLICE,TEAM_CHIEF}
end)

//Add all female models here or the handcuffs positioning will be weird
//It's case sensitive, make sure all letters are lowercase
RHC_FEMALE_MODELS = {
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_05.mdl",	
	"models/player/group01/female_06.mdl",
	"models/player/group03/female_01.mdl",
	"models/player/group03/female_02.mdl",
	"models/player/group03/female_03.mdl",
	"models/player/group03/female_04.mdl",
	"models/player/group03/female_05.mdl",	
	"models/player/group03/female_06.mdl",
}