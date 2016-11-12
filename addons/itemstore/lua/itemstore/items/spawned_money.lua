ITEM.Name = "Money"
ITEM.Description = "Lods of emone."
ITEM.Model = "models/props/cs_assault/money.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = true
ITEM.DropStack = true
ITEM.MaxStack = math.huge

function ITEM:Use( pl )
	itemstore.gamemodes.GiveMoney( pl, self:GetAmount() )
	return true
end

function ITEM:SaveData( ent )
	self:SetAmount( ent:Getamount() )
end

function ITEM:LoadData( ent )
	ent:Setamount( self:GetAmount() )
end
