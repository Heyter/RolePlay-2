ITEM.Name = "Prop"
ITEM.Description = ""
ITEM.Model = "models/weapons/w_dmg_vally.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false

function ITEM:SaveData( ent )
    self:SetData( "Name", (ent.name or "Unbekannt" ) )
    self:SetData( "Model", ent:GetModel() )
    self:SetData( "CraftOwner", (ent.craftowner or "Unbekannt") )
end

function ITEM:LoadData( ent )
	ent:SetModel( self:GetData( "Model" ) )
end

function ITEM:GetName()
	return self:GetData( "Name" )
end

function ITEM:GetModel()
	return self:GetData( "Model" )
end

/*
function ITEM:Use( pl )
	pl:Give( self:GetData( "Class" ) )
	local wep = pl:GetWeapon( self:GetData( "Class" ) )
	
	-- If something went horribly wrong and for some reason we didn't receive the weapon coughdarkrpcough
	-- then don't decrease the amount we have and don't try to give ammo. 
	if ( IsValid( wep ) ) then
		
		if ( self:GetData( "Clip1" ) ) then
			wep:SetClip1( 0 )
		end
	
		if ( self:GetData( "Clip2" ) ) then
			wep:SetClip2( 0 )
		end
		
		pl:GiveAmmo( 0, wep:GetPrimaryAmmoType() )
		
       return true
	end
end
*/
