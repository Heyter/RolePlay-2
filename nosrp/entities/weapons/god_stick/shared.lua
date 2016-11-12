AddCSLuaFile( )
 
 
SWEP.PrintName = "God Stick";
SWEP.Slot = 0;
SWEP.SlotPos = 5;
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = true;
 
// Variables that are used on both client and server
 
SWEP.Author             = "ThaRealCamotrax"
SWEP.Instructions       = "Left click to fire, right click to change"
SWEP.Contact       		= ""
SWEP.Purpose        	= ""
 
SWEP.ViewModelFOV       = 62
SWEP.ViewModelFlip      = false
SWEP.AnimPrefix  		= "stunstick"

SWEP.Spawnable      	= false
SWEP.AdminSpawnable     = true
 
SWEP.NextStrike = 0;

SWEP.ViewModel = Model( "models/weapons/v_stunbaton.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_stunbaton.mdl" );
  
SWEP.Sound = Sound( "weapons/stunstick/stunstick_swing1.wav" );
SWEP.Sound1 = Sound( "npc/metropolice/vo/moveit.wav" );
SWEP.Sound2 = Sound( "npc/metropolice/vo/movealong.wav" );

SWEP.Primary.ClipSize      = -1                                   // Size of a clip
SWEP.Primary.DefaultClip        = 0                    // Default number of bullets in a clip
SWEP.Primary.Automatic    = false            // Automatic/Semi Auto
SWEP.Primary.Ammo                     = ""
 
SWEP.Secondary.ClipSize  = -1                    // Size of a clip
SWEP.Secondary.DefaultClip      = 0            // Default number of bullets in a clip
SWEP.Secondary.Automatic        = false    // Automatic/Semi Auto
SWEP.Secondary.Ammo               = ""
 
/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
 
        if( SERVER ) then

				self.Gear = 1;
        
        end
		
		self:SetWeaponHoldType( "normal" );
		
end

local SLAP_SOUNDS = {
	"physics/body/body_medium_impact_hard1.wav",
	"physics/body/body_medium_impact_hard2.wav",
	"physics/body/body_medium_impact_hard3.wav",
	"physics/body/body_medium_impact_hard5.wav",
	"physics/body/body_medium_impact_hard6.wav",
	"physics/body/body_medium_impact_soft5.wav",
	"physics/body/body_medium_impact_soft6.wav",
	"physics/body/body_medium_impact_soft7.wav"
}
 
 
/*---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------*/
function SWEP:Precache()
end
 
function SWEP:DoFlash( ply )
 
        umsg.Start( "StunStickFlash", ply ); umsg.End();
 
end

local Gears = {};

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
  function SWEP:PrimaryAttack()
        if( CurTime() < self.NextStrike ) then return; end
		if !self.Owner:IsAdmin() then
			self.Owner:Kick("God Stick with no Admin?");
			return false;
		end
		
 
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		
		local r, g, b, a = self.Owner:GetColor();
		
		
		if a != 0 then
			self.Weapon:EmitSound( self.Sound );
		end
		
		
        self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER );
 
        self.NextStrike = ( CurTime() + .3 );

        if( CLIENT ) then return; end
 
        local trace = self.Owner:GetEyeTrace();
        
        local Gear = self.Owner:GetTable().CurGear or 1;
		
		if Gears[Gear][3] and !self.Owner:IsSuperAdmin() then
			self.Owner:Notify("This gear requires Super Admin status.");
			return false;
		end
		
		Gears[self.Owner:GetTable().CurGear][4](self.Owner, trace);
  end
  

  local function AddGear ( Title, Desc, SA, Func, spacer, icon )
		spacer = spacer or false
		submenu = submenu or ""
		icon = icon or nil
		table.insert(Gears, {Title, Desc, SA, Func, spacer, icon});
  end

AddGear( "--- Entity ---", "", false, function() end, true )
AddGear("ENT Info", "Left Click to get Info of an Entity.", false,
function ( Player )
	local Eyes = Player:GetEyeTrace().Entity:GetPos();
	local ent = Player:GetEyeTrace().Entity
	local Eyes3 = Player:GetEyeTrace().Entity:GetModel();
	local class = Player:GetEyeTrace().Entity:GetClass();

	if (CLIENT) then
		SetClipboardText('Vector(' .. math.Round(Eyes.x) .. ', ' .. math.Round(Eyes.y) .. ', ' .. math.Round(Eyes.z) .. ')');
	end
	Player:PrintMessage(HUD_PRINTTALK, class);
	Player:PrintMessage(HUD_PRINTTALK, Eyes3);
    if FindPlayerBySteamID( ent.owner ) != nil then
        Player:PrintMessage(HUD_PRINTTALK, "Owner: " .. (FindPlayerBySteamID( ent.owner ):GetRPVar( "rpname" ) or "Unknown"));
    end
end
, false, "icon16/information.png");

AddGear("Unlock Door", "Aim at a door to unlock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('unlock', '', 0);
				Trace.Entity:Fire('open', '', .5);
				Player:PrintMessage(HUD_PRINTTALK, "Door unlocked.");
			end
	end
, false, "icon16/door.png");

AddGear("Lock Door", "Aim at a door to lock it.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				Trace.Entity:Fire('lock', '', 0);
				Trace.Entity:Fire('close', '', .5);
				Player:PrintMessage(HUD_PRINTTALK, "Door locked.");
			end
	end
, false, "icon16/door_open.png");

AddGear("Refill Shop Storage", "Aim at a npc to refill it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) && Trace.Entity:GetClass() == "npc_ventor" then
				RunConsoleCommand( "shop_refill" )
				Player:PrintMessage(HUD_PRINTTALK, "Shop has been successfully refilled!.");
			else
				Player:PrintMessage(HUD_PRINTTALK, "Aim at a Shop NPC to refill it.");
			end
	end
, false, "icon16/basket_put.png");

AddGear( "--- Player ---", "", false, function() end, true )

AddGear("Force Name Change", "Aim at a player to force him, to change his name", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			RP.ForceNameChange( Trace.Entity )
		end
	end
, false, "icon16/pencil.png");

AddGear("Kill Player", "Aim at a player to slay him. Or kil lthe entity owner", false,
	function ( Player, Trace )
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			Trace.Entity:Kill();
			Player:PrintMessage(HUD_PRINTTALK, "Player killed.");
        elseif IsValid(Trace.Entity) and Trace.Entity.owner then
            FindPlayerBySteamID( Trace.Entity.owner ):Kill()
            Player:PrintMessage(HUD_PRINTTALK, "Player killed.");
		end
	end
, false, "icon16/user_delete.png");

AddGear("Slap Player", "Aim at an entity to slap him.", false,
	function ( Player, Trace )
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Entity slapped.");
				else
					local RandomVelocity = Vector( math.random(500) - 250, math.random(500) - 250, math.random(500) - (500 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Player slapped.");
				end
	end
);

AddGear("Warn Player", "Aim at a player to warn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:RPNotify("Du wurdest vom Admin gewarnt. Den Grund solltest du kennen.", 15);
				Player:PrintMessage(HUD_PRINTTALK, "Player warned.");
            elseif IsValid(Trace.Entity) and Trace.Entity.owner then
                FindPlayerBySteamID( Trace.Entity.owner ):RPNotify("Du wurdest vom Admin gewarnt. Den Grund solltest du kennen. ( Prop )", 15);
				Player:PrintMessage(HUD_PRINTTALK, "Player warned.");
			end
	end
, false, "icon16/thumb_down.png");

AddGear("Respawn Player", "Aim at a player to respawn him.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				Trace.Entity:RPNotify("Ein Administrator hat dich neu Spawnen lassen.", 10);
				Trace.Entity:Spawn();
				Player:PrintMessage(HUD_PRINTTALK, "Player respawned.");
			end
	end
);

AddGear("Demote Player", "Left click to demote a player.", false,
	function ( Player, Trace )				
		if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
			if Trace.Entity:Team() == TEAM_CITIZEN then return false end
            
            Trace.Entity:SwapTeam( TEAM_CITIZEN, true )
            Trace.Entity:RPNotify("Du wurdest von ein Admin Demoted.", 5);
		else
			return false;
		end;
		
	end
, false, "icon16/status_offline.png");

AddGear("Revive Player", "Aim at a corpse to revive the player.", false,
	function ( Player, Trace )
        if !(IsValid( Trace.Entity )) then return end
        RevivePlayer( Trace.Entity, Player, true )
        Player:PrintMessage(HUD_PRINTTALK, "Player Revived.");
	end
, false, "icon16/pill.png");

AddGear("Freeze", "Target a player to change his freeze state.", false,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsPlayer() then
				if Trace.Entity.IsFrozens then
					Trace.Entity:Freeze(false);
					Player:PrintMessage(HUD_PRINTTALK, "Player unfrozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been unfrozen.");
					Trace.Entity.IsFrozens = nil;
				else
					Trace.Entity.IsFrozens = true;
					Trace.Entity:Freeze(true);
					Player:PrintMessage(HUD_PRINTTALK, "Player frozen.");
					Trace.Entity:PrintMessage(HUD_PRINTTALK, "You have been frozen.");
				end
			end
	end
);

AddGear( "--- Other ---", "", false, function() end, true )

AddGear("Super Slap Player", "Aim at an entity to super slap him.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if !Trace.Entity:IsPlayer() then
					local RandomVelocity = Vector( math.random(50000) - 25000, math.random(50000) - 25000, math.random(50000) - (50000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:GetPhysicsObject():SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Entity super slapped.");
				else
					local RandomVelocity = Vector( math.random(5000) - 2500, math.random(5000) - 2500, math.random(5000) - (5000 / 4 ) )
					local RandomSound = SLAP_SOUNDS[ math.random(#SLAP_SOUNDS) ]
					
					Trace.Entity:EmitSound( RandomSound )
					Trace.Entity:SetVelocity( RandomVelocity )
					Player:PrintMessage(HUD_PRINTTALK, "Player super slapped.");
				end
			end
	end
, false, "icon16/sport_football.png");

AddGear("Ignite", "Spawns a fire wherever you're aiming.", true,
	function ( Player, Trace )
		if IsValid(Trace.Entity) then
			Trace.Entity:Ignite(300);
		else
			local Fire = ents.Create('ent_fire');
			Fire:SetPos(Trace.HitPos);
			Fire:Spawn();
			
			Player:PrintMessage(HUD_PRINTTALK, "Fire started.");
		end
	end
, false, "icon16/lightning.png");

AddGear("Teleport", "Teleports you to a targeted location.", true,
	function ( Player, Trace )
		local EndPos = Player:GetEyeTrace().HitPos;
		local CloserToUs = (Player:GetPos() - EndPos):Angle():Forward();
		
		Player:SetPos(EndPos + (CloserToUs * 20));
		Player:PrintMessage(HUD_PRINTTALK, "Teleported.");
	end
);

AddGear("Extinguish ( Local )", "Extinguishes the fires near where you aim.", true,
	function ( Player, Trace )
        for k, v in pairs(ents.FindInSphere(Trace.HitPos, 250)) do
            if v:GetClass() == 'ent_fire' then
                v:Remove();
            end
        end
        
        Player:PrintMessage(HUD_PRINTTALK, "Fires extinguished nearby.");
	end
);

 AddGear("Extinguish ( All )", "Extinguishes all fires on the map.", true,
	function ( Player, Trace )
			for k, v in pairs(ents.FindByClass('ent_fire')) do
				v:Remove();
			end
			
			for k, v in pairs(player.GetAll()) do
				v:RPNotify("Alle Feuer wurden von ein Admin gelöscht.", 5);
			end
			
			Player:PrintMessage(HUD_PRINTTALK, "Fires extinguished.");
	end
);

AddGear("Repair Car", "Aim at a disabled car to fix it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				if CARSHOP.AdminRepairCar( Trace.Entity ) then
                    Player:PrintMessage(HUD_PRINTTALK, "Vehicle repaired.");
                else
                    Player:PrintMessage(HUD_PRINTTALK, "Der Owner existiert nicht. Das Auto wurde entfernt!");
                end
			end
	end
, false, "icon16/wrench.png");

AddGear("Destroy Car", "Aim at a disabled car to fix it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				Trace.Entity:ExplodeCar()
                Player:PrintMessage(HUD_PRINTTALK, "Vehicle destructed.");
			end
	end
, false, "icon16/bomb.png");

AddGear("Fuel Car", "Aim at a disabled car to fix it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
				Trace.Entity:SetNWInt("fuel", 100)
                Trace.Entity:SetNWBool("Empty", false)
			end
	end
);

AddGear("Remover", "Aim at any object to remove it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "ticket_check") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "car_display") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "prop_vehicle_prisoner_pod") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx_repeater") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control2") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				end;
				
				if Trace.Entity:IsPlayer() then
					Trace.Entity:Kill();
				else
					Trace.Entity:Remove();
				end
			end
	end
, false, "icon16/bin_closed.png");

/*
AddGear("Explode", "Aim at any object to explode it.", true,
	function ( Player, Trace )
			if IsValid(Trace.Entity) then
				if Trace.Entity:IsVehicle() and IsValid(Trace.Entity:GetDriver()) then
					Trace.Entity:GetDriver():ExitVehicle();
				end
				
				if string.find(tostring(Trace.Entity), "door") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "npc") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "ticket_check") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "car_display") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "prop_vehicle_prisoner_pod") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx_repeater") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "gmod_playx") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				elseif string.find(tostring(Trace.Entity), "theater_control2") then
					return Player:PrintMessage(HUD_PRINTTALK, "Nope.");
				end;
				
				ExplodeInit(Trace.Entity:GetPos(), Player)
				
				timer.Simple(.5, function ( )
					if IsValid(Trace.Entity) then
						if Trace.Entity:IsPlayer() then
							Trace.Entity:Kill();
						elseif string.find(tostring(Trace.Entity), "jeep") then
							Trace.Entity:DisableVehicle(true, false)
						else
							Trace.Entity:Remove();
						end
					end
				end);
			end
	end
);*/

AddGear("Telekinesis ( Stupid )", "Left click to make it float.", true,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = nil;
			end
	end
);

AddGear("Telekinesis ( Smart )", "", true,
	function ( Player, Trace )
			local self = Player:GetActiveWeapon();
			
			if self.Floater then
				self.Floater = nil;
				self.FloatSmart = nil;
			elseif IsValid(Trace.Entity) then
				self.Floater = Trace.Entity;
				self.FloatSmart = true;
			end
	end
);
AddGear( "--- Drugdealer ---", "", false, function() end, true )
AddGear("Switch Dealer", "Left click to make it float and follow your crosshairs.", true,
	function ( Player, Trace )
		DRUGDEALER.RollNewDealer()
		Player:RPNotify("Drugdealer table has been mixed!", 5)
	end
);
AddGear("Enable -/ Disable Purchasings", "", true,
	function ( Player, Trace )
		if DRUGDEALER.Purchasing then 
			DRUGDEALER.Purchasing = false
		elseif not DRUGDEALER.Purchasing then 
			DRUGDEALER.Purchasing = true 
		end
		
		local cache = {
			Dealer = DRUGDEALER.CurDealer,
			Purchasing = DRUGDEALER.Purchasing,
			IsSelling = DRUGDEALER.IsSelling,
			Autoclose = DRUGDEALER.LastSwitch + DRUGDEALER.CONFIG.RotationTime,
			Stocks = DRUGDEALER.Stocks,
			MinRuf = DRUGDEALER.MaxRuf
		}
		
		net.Start( "DrugDealer_Send_ClientInfo" )
			net.WriteTable( cache )
		net.Send( player.GetAll() )
		Player:RPNotify("Drugdealer Purchasing:" .. tostring(DRUGDEALER.Purchasing), 5)
	end
);
AddGear("Enable -/ Disable Sales", "", true,
	function ( Player, Trace )
		if DRUGDEALER.IsSelling then 
			DRUGDEALER.IsSelling = false
		elseif not DRUGDEALER.IsSelling then 
			DRUGDEALER.IsSelling = true 
		end
		
		local cache = {
			Dealer = DRUGDEALER.CurDealer,
			Purchasing = DRUGDEALER.Purchasing,
			IsSelling = DRUGDEALER.IsSelling,
			Autoclose = DRUGDEALER.LastSwitch + DRUGDEALER.CONFIG.RotationTime,
			Stocks = DRUGDEALER.Stocks,
			MinRuf = DRUGDEALER.MaxRuf
		}
		
		net.Start( "DrugDealer_Send_ClientInfo" )
			net.WriteTable( cache )
		net.Send( player.GetAll() )
		Player:RPNotify("Drugdealer Selling:" .. tostring(DRUGDEALER.Selling), 5)
	end
);
--[[
AddGear("Weather Delete", "Left click to delete the current weather.", true,
	function ( Player, Trace )
		GAMEMODE.CloudCondition = 1;
		Player:PrintMessage(HUD_PRINTTALK, "Weather Deleted.");
	end
);
]]--	

--[[ 
AddGear("[O] Weather Storm", "Left click to change the weather to stormy.", false,
	function ( Player, Trace )
		if Player:GetLevel() != 0 then
			Player:Notify("This gear requires Owner status.");
			return false;
		end
		
		GAMEMODE.CloudCondition = 8;
		Player:PrintMessage(HUD_PRINTTALK, "Weather changed to stormy.");
	end
);
 ]]--
 
--[[ 
AddGear("[DvL] Rain Storm", "Left click to change the weather to stormy.", false,
		function ( Player, Trace )
		if Player:GetLevel() > 1 then
			Player:Notify("This gear requires Council/DvL status.");
			return false;
		end
		
		
		GAMEMODE.CloudCondition = 8;
		Player:PrintMessage(HUD_PRINTTALK, "Weather changed to stormy.");
	end
]]--

/*
AddGear("Flying Car", "Left click to make a car fly.", false,
	function ( Player, Trace )		
		if IsValid(Trace.Entity) and Trace.Entity:IsVehicle() then
			Trace.Entity.CanFly = true;
			Player:PrintMessage(HUD_PRINTTALK, "You are now the proud owner of a flying car.");
		end
	end
);*/

/*
AddGear("Druggy Buy Meth", "Left click to make the druggy buy meth.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_buy', 2);
	end
);

AddGear("Druggy Buy Weed", "Left click to make the druggy buy weed.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_buy', 1);
	end
);

AddGear("Druggy Buy Coke", "Left click to make the druggy buy coke.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_buy', 4);
	end
);

AddGear("Druggy Buy Shrooms", "Left click to make the druggy buy shrooms.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_buy', 3);
	end
);

AddGear("Druggy Buy Nothing", "Left click to make the druggy buy nothing.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_buy', 0);
	end
);

AddGear("Druggy Sell Weed", "Left click to make the druggy sell weed.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_sell', 1);
	end
);

AddGear("Druggy Sell Coke", "Left click to make the druggy sell coke.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_sell', 3);
	end
);

AddGear("Druggy Sell Shrooms", "Left click to make the druggy sell shrooms.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_sell', 2);
	end
);

AddGear("Druggy Sell Nothing", "Left click to make the druggy sell nothing.", false,
	function( Player, Trace )
		SetGlobalInt('perp_druggy_sell', 0);
	end
);
*/
function SWEP:Think ( )
	if self.Floater then
			local trace = {}
			trace.start = self.Floater:GetPos()
			trace.endpos = trace.start - Vector(0, 0, 100000);
			trace.filter = { self.Floater }
			local tr = util.TraceLine( trace )
		
		local altitude = tr.HitPos:Distance(trace.start);
		
		local ent = self.Spazzer;
		local vec;
		
		if self.FloatSmart then
			local trace = {}
			trace.start = self.Owner:GetShootPos()
			trace.endpos = trace.start + (self.Owner:GetAimVector() * 400)
			trace.filter = { self.Owner, self.Weapon }
			local tr = util.TraceLine( trace )
			
			vec = trace.endpos - self.Floater:GetPos();
		else
			vec = Vector(0, 0, 0);
		end
		
		if altitude < 150 then
			if vec == Vector(0, 0, 0) then
				vec = Vector(0, 0, 25);
			else
				vec = vec + Vector(0, 0, 100);
			end
		end
		
		vec:Normalize()
		
		if self.Floater:IsPlayer() then
			local speed = self.Floater:GetVelocity()
			self.Floater:SetVelocity( (vec * 1) + speed)
		else
			local speed = self.Floater:GetPhysicsObject():GetVelocity()
			self.Floater:GetPhysicsObject():SetVelocity( (vec * math.Clamp((self.Floater:GetPhysicsObject():GetMass() / 20), 10, 20)) + speed)
		end

	end
end

 // Draw the Crosshair
 local chRotate = 0;
 function SWEP:DrawHUD( )
 if (!CLIENT) then return; end
	/*
	 local godstickCrosshair = surface.GetTextureID("perp2/crosshairs/godstick_crosshairv4");
	 local trace = self.Owner:GetEyeTrace();
	 local x = (ScrW()/2);
	 local y = (ScrH()/2);
					
		if IsValid(trace.Entity) then
			draw.WordBox( 8, 8, 10, "Target: " .. tostring(trace.Entity), "IMP22", Color(50,50,75,100), Color(255,0,0,255) );
			surface.SetDrawColor(255, 0, 0, 255);
			chRotate = chRotate + 8;
		else
			draw.WordBox( 8, 8, 10, "Target: " .. tostring(trace.Entity), "IMP22", Color(50,50,75,100), Color(255,255,255,255) );
			surface.SetDrawColor(255, 255, 255, 255);
			chRotate = chRotate + 3;
		end
		
		surface.SetTexture(godstickCrosshair);
		surface.DrawTexturedRectRotated(x, y, 64, 64, 0 + chRotate);
		
		*/
 end
 
 function MonitorWeaponVis ( )
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() and IsValid(v:GetActiveWeapon()) then
			local pr, pg, pb, pa = v:GetColor();
			local wr, wg, wb, wa = v:GetActiveWeapon():GetColor();
			
			if pa == 0 and wa == 255 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 0);
			elseif pa == 255 and wa == 0 then
				v:GetActiveWeapon():SetColor(wr, wg, wb, 255);
			end
		end
		
		/*
		if v:InVehicle() and v:GetVehicle().CanFly then
			local t, r, a = v:GetVehicle();
			
			if ValidEntity(t) then
				local p = t:GetPhysicsObject();
				a = t:GetAngles();
				r = 180 * ((a.r-180) > 0 && 1 or -1) - (a.r - 180);
				p:AddAngleVelocity(p:GetAngleVelocity() * -1 + Angle(a.p * -1, 0, r));
			end
		end
		*/
	end
 end
 hook.Add('Think', 'MonitorWeaponVis', MonitorWeaponVis);
 
 function MonitorKeysForFlymobile ( Player, Key )
	if Player:InVehicle() and Player:GetVehicle().CanFly then
		local Force;
		
		if Key == IN_ATTACK then
			Force = Player:GetVehicle():GetUp() * 450000;
		elseif Key == IN_ATTACK2 then
			Force = Player:GetVehicle():GetForward() * 100000;
		end
		
		if Force then
			Player:GetVehicle():GetPhysicsObject():ApplyForceCenter(Force);
		end
	end
 end
 hook.Add('KeyPress', 'MonitorKeysForFlymobile', MonitorKeysForFlymobile);
 
 if SERVER then
	  function GodSG ( Player, Cmd, Args )
			Player:GetTable().CurGear = tonumber(Args[1]);
	  end
	  concommand.Add('god_sg', GodSG);
 end
 
 timer.Simple(.5, function () GAMEMODE.StickText = Gears[1][1] .. ' - ' .. Gears[1][2] end);
 
  /*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
  ---------------------------------------------------------*/
function SWEP:SecondaryAttack()	
	if SERVER then return false end
	local MENU = DermaMenu()
	
	// 5 = spacer
	// 6 = icon
	
	for k, v in pairs(Gears) do
		local Title = v[1];
		
		if v[3] then
			Title = "[SA] " .. Title;
		end
		
		local menu = MENU:AddOption(Title, 	function()
									RunConsoleCommand('god_sg', k) 
									LocalPlayer():PrintMessage(HUD_PRINTTALK, v[2]);
									GAMEMODE.StickText = v[1] .. ' - ' .. v[2];
								end )
		if v[5] then MENU:AddSpacer() end
		if v[6] then menu:SetIcon( v[6] ) end
	end
	
	MENU:Open( 100, 100 )	
	timer.Simple( 0, function() gui.SetMousePos(110, 110 ) end)

end 
  
 function TryRevive ()
	//if !LocalPlayer():IsSuperAdmin() then return false; end
	
	local EyeTrace = LocalPlayer():GetEyeTrace();
	
 			for k, v in pairs(player.GetAll()) do
				if !v:Alive() then
					for _, ent in pairs(ents.FindInSphere(EyeTrace.HitPos, 5)) do						
						if ent == v:GetRagdollEntity() then
							RunConsoleCommand('perp_m_h', v:UniqueID());
							LocalPlayer():PrintMessage(HUD_PRINTTALK, "Player revived.");
							return;
						end
					end
				end
			end
 end
 usermessage.Hook('god_try_revive', TryRevive);