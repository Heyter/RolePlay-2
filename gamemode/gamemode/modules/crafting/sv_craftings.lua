AddCSLuaFile(GM.FolderName.."/gamemode/modules/crafting/cl_craftings.lua")

util.AddNetworkString( "CRAFTINGS_CANCRAFT" )

local meta = FindMetaTable( "Player" )

function meta:HasItem( item, count )
	if !(IsValid( self )) then return false end
	if !(item) then return false end
	if !(self.Inventory:CountItems( item ) >= ( count or 1 )) then return false end
	
	return true
end

function GiveCraftItem( ply, item_table, isweapon )
    isweapon = isweapon or false
    local class
    local wepclass
    local index = item_table.item
    
    class = CRAFT_TABLE[index].UniqueName
    wepclass = class
    
    if isweapon then class = "spawned_weapon" end
    
    local tbl = CRAFT_TABLE[index]
    --if isweapon then tbl = CRAFT_TABLE[tostring(index)] end
    
    local item = itemstore.Item( class )
    item:SetData( "Class", wepclass )
    item:SetData( "Model", tbl.Model )
    item:SetData( "Name", tbl.Name )
    item:SetData( "CraftOwner", ply:GetRPVar( "rpname" ) )
    ply.Inventory:AddItem( item )
    
    ply:RPNotify( "Du hast einmal: " .. tbl.Name .. " hergestellt!", 5 )
end

function CraftItem( um )
	local tbl = net.ReadTable()
	local removetbl = {}
	
	if !(tbl) then return end
	
	local ply = tbl.ply
	local item = tbl.item

    if CRAFT_TABLE[item].Category != "Weapon" && !(ply.Inventory:FirstEmptySlot()) then return end
    for k, v in pairs( CRAFT_TABLE[item].Skills ) do
        if ply:GetSkill( k ) < v then ply:RPNotify( "Du hast nicht die nötigen Skills für diese Rezeptur!", 5 ) return end
    end
	
	for k, v in pairs( CRAFT_TABLE[item].Items ) do
		if ply:HasItem( k, v ) then
			table.insert( removetbl, { item = k, count = v } )
		else
			return
		end
	end
	
	for k, v in pairs( removetbl ) do
        ply.Inventory:TakeItems( v.item, v.count )
	end

	if CRAFT_TABLE[item].Category == "Items" then
		--ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl )
	elseif CRAFT_TABLE[item].Category == "Weapon" then
		--ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl, true )
	elseif CRAFT_TABLE[item].Category == "Food" then
		--ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl )
	elseif CRAFT_TABLE[item].Category == "Shipments" then
		--ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl )
    elseif CRAFT_TABLE[item].Category == "Misc" then
        --ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl )
    elseif CRAFT_TABLE[item].Category == "Props" then
        --ply:AddInvItem( item, 1 )
        GiveCraftItem( ply, tbl )
	end
end
net.Receive( "CRAFTINGS_CANCRAFT", CraftItem )