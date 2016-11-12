ITEM.Name = "Food"
ITEM.Description = "Nom.\n\nNutritional value: %d"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Base = "base_darkrp"

function ITEM:GetDescription()
	return string.format( self.Description, self:GetData( "Nutrition" ) )
end

function ITEM:Use( pl )
	local energy = pl:getSelfDarkRPVar( "Energy" ) + self:GetData( "Nutrition" )
	pl:setSelfDarkRPVar( "Energy", math.Clamp( energy, 0, 100 ) )

	umsg.Start( "AteFoodIcon", pl ) umsg.End()

	return self:TakeOne()
end

function ITEM:SaveData( ent )
	self:SetData( "Owner", ent:Getowning_ent() )
	self:SetData( "Nutrition", ent.FoodEnergy )
	self:SetData( "Model", ent:GetModel() )
end

function ITEM:LoadData( ent )
	ent:Setowning_ent( self:GetData( "Owner" ) )
	ent:SetModel( self:GetModel() )
	ent.FoodEnergy = self:GetData( "Nutrition" )
end
