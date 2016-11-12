--[[---------------------------------------------------------
   File: sh_player_class.lua
   Desc: Player class, derives from base player class
            and overrides its functions
-----------------------------------------------------------]]

DEFINE_BASECLASS( "player_default" )

local PLAYER = {} 

--
-- See gamemodes/base/player_class/player_default.lua for all overridable variables
--
PLAYER.WalkSpeed            = SETTINGS.WalkSpeed
PLAYER.RunSpeed             = SETTINGS.RunSpeed
PLAYER.DropWeaponOnDie	    = false
PLAYER.TeammateNoCollide    = false


function PLAYER:Loadout()
    self.Player:RemoveAllAmmo()
    
    self.Player:SetWalkSpeed( self.WalkSpeed )
    self.Player:SetRunSpeed( self.RunSpeed )
    
    local t = self.Player:Team()
    if t >= 1 then
        for k, v in pairs( GAMEMODE.TEAMS[t].Weapons ) do 
            self.Player:Give( v ) 
        end
    end
    
    if self.Player:GetVIPLevel() > 0 or self.Player:IsAdmin() then self.Player:Give( "weapon_physgun" ) end
    if self.Player:IsAdmin() then self.Player:Give( "god_stick" ) end
end

function PLAYER:Spawn()
    BaseClass.Spawn(self)
    self:GetHandsModel()
end

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
	return player_manager.TranslatePlayerHands( playermodel )
end

player_manager.RegisterClass("player_roleplay", PLAYER, "player_default")
