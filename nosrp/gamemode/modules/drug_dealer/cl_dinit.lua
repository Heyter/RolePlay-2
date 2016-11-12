// Cl Init
DRUGDEALER = DRUGDEALER or {}


local function Refresh_DTable()
	local i = net.ReadTable()
    if i == nil then return end
	
	local cache = DRUGDEALER.Stocks		// cache old table
    for k, v in pairs( i ) do
        DRUGDEALER[ k ] = v
    end
	
	DRUGDEALER_Refresh_List( cache )
end
net.Receive( "DrugDealer_Send_ClientInfo", Refresh_DTable )