
util.AddNetworkString("RHC_Jailer_Menu")
util.AddNetworkString("RHC_jail_player")
util.AddNetworkString("RHC_Bailer_Menu")
util.AddNetworkString("RHC_bail_player")

hook.Add("Initialize", "CreateJailerNPCFolder", function()
	file.CreateDir("rhandcuffs")
end)

concommand.Add("save_rhc_npcs", function(Player, CMD, Args)
	if !Player:IsAdmin() then return end

	local NPCTbl = {}		
	for k,v in pairs(ents.FindByClass("npc_jailer")) do
		local tr = util.TraceLine( {
			start = v:GetPos(),
			endpos = v:GetPos()-Vector(0,0,50),
			filter = {"npc_jailer"}
		} )
		
		local NPCIns = {}
		NPCIns.Pos = tr.HitPos
		NPCIns.Angles = v:GetAngles()
		NPCIns.Ent = v:GetClass()
		table.insert(NPCTbl,NPCIns)
	end
	
	for k,v in pairs(ents.FindByClass("npc_bailer")) do
		local tr = util.TraceLine( {
			start = v:GetPos(),
			endpos = v:GetPos()-Vector(0,0,50),
			filter = {"npc_bailer"}
		} )
		
		local NPCIns = {}
		NPCIns.Pos = tr.HitPos
		NPCIns.Angles = v:GetAngles()
		NPCIns.Ent = v:GetClass()
		table.insert(NPCTbl,NPCIns)
	end	
		
	local CurrentMap = string.lower(game.GetMap())	
	file.Write("rhandcuffs/" .. CurrentMap .. ".txt", util.TableToJSON(NPCTbl))

	DarkRP.notify(Player, 1, 4, "Successfully saved " .. #NPCTbl .. " NPCs.")		
end)

function RHandCuffsNPCSpawn()
	local CurrentMap = string.lower(game.GetMap())
	
	local NPCLocTable = {}
	if file.Exists( "rhandcuffs/" .. CurrentMap .. ".txt" ,"DATA") then
		NPCLocTable = util.JSONToTable(file.Read( "rhandcuffs/" .. CurrentMap .. ".txt" ))
	end
	
	for k,v in pairs(NPCLocTable) do		
		local PNPC = ents.Create(v.Ent)
		PNPC:SetPos(v.Pos)
		PNPC:SetAngles(v.Angles)
		PNPC:Spawn()
		local Phys = PNPC:GetPhysicsObject()
		if Phys then
			Phys:EnableMotion(false)
		end
	end
end
hook.Add( "InitPostEntity", "RHandCuffsNPCSpawn", RHandCuffsNPCSpawn)

hook.Add("PostCleanupMap", "RepsawnJailerNPCCleanup", function()
	RHandCuffsNPCSpawn()
end)

hook.Add("canArrest", "MustBeArrestAtJailerNPC", function(Player, ArrestedPlayer)
    if RHC_NPCArrestOnly then
        return false,"Talk with the jailer NPC while dragging a player in order to arrest."
    end
end)

net.Receive("RHC_jail_player", function(len, Player)
	local APlayer, Time = net.ReadEntity(), net.ReadFloat()
	if APlayer != Player.Dragging or !Player:IsRHCWhitelisted() then return end
	if APlayer:isArrested() then DarkRP.notify(Player, 1, 4, "This player is already arrested!")   return end
	
	Time = math.Clamp(math.Round(Time), 1, RHC_MaxJailYears)
	Time = Time*60
	
	APlayer:arrest(Time, Player)
end)

net.Receive("RHC_bail_player", function(len, Player)
	local ToBailP = net.ReadEntity()
	if !IsValid(ToBailP) or !ToBailP:IsPlayer() or !ToBailP:isArrested() then return end
	
	local BailCost = ToBailP.ArrestTime/60 * RHC_BailPricePerYear
	if Player:canAfford(BailCost) then
		ToBailP:unArrest()
		Player:addMoney(-BailCost)
		DarkRP.notify(Player, 1, 4, "You successfully bailed " .. ToBailP:Nick() .. " out of jail.")
	end
end)

local TGBlacklist = {"rhandcuffsent","npc_jailer"}
hook.Add("CanTool", "DisableRemovingRHCEntsTool", function(Player, trace, tool)
    local ent = trace.Entity
 
	if table.HasValue(TGBlacklist, ent:GetClass()) then
		if !Player:IsAdmin() then
			return false
		end
	end
end)

hook.Add("CanProperty", "DisableRemovingRHCEntsProperty", function(Player, stringproperty, ent)
	if table.HasValue(TGBlacklist, ent:GetClass()) then
		if !Player:IsAdmin() then
			return false
		end
	end
end)
