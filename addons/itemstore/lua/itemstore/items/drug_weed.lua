ITEM.Name = "Weed"
ITEM.Description = "Quality: %q\nGramm: %g"
ITEM.Model = "models/props_junk/garbage_bag001a.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false


function ITEM:LoadData( ent )		// Wenn gedroppt wird
	local q = self:GetData( "Quality" ) or 0
	local g = self:GetData( "Gramm" ) or 0
	
    ent.quality = q
	ent.gramm = g
end

function ITEM:SaveData( ent )	// Wenn aufgehoben wird
	local q = ent.Quality
	local g = ent.Gramm
	
    self:SetData( "Quality", q )
	self:SetData( "Gramm", g )
end

function ITEM:GetDescription()
	local desc = self.Description
	local q = self:GetData( "Quality" ) or 0
	local g = self:GetData( "Gramm" ) or 0
	
	desc = string.Replace( desc, "%q", tostring( q ) ) 
	desc = string.Replace( desc, "%g", tostring( g ) ) 
	return desc
end