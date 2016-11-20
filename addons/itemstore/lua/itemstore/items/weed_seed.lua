ITEM.Name = "Weed Samen"
ITEM.Description = "Qualität: %q\nDealer: %d"
ITEM.Model = "models/props_junk/garbage_bag001a.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false


function ITEM:LoadData( ent )		// Wenn gedroppt wird
	local q = self:GetData( "Quality" ) or 0
	local d = self:GetData( "Dealer" ) or 0
	
    ent.dealer = d
	ent.quality = q
end

function ITEM:SaveData( ent )	// Wenn aufgehoben wird
	local q = ent.Quality
	local d = ent.Dealer
	
    self:SetData( "Quality", q )
	self:SetData( "Dealer", d )
end

function ITEM:GetDescription()
	local desc = self.Description
	local d = self:GetData( "Dealer" ) or 0
	local q = self:GetData( "Quality" ) or 0
	
	desc = string.Replace( desc, "%q", tostring( q ) ) 
	desc = string.Replace( desc, "%d", tostring( d ) ) 
	return desc
end
