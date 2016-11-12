net.Receive( "SendOrganisations", function()
	local tbl = net.ReadTable()
	if !(tbl) then return end
	
	RP.Organisations = tbl
end)