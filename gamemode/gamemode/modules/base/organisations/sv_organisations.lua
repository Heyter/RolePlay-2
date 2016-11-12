util.AddNetworkString( "SendOrganisations" )
util.AddNetworkString( "ChangeOrgPicture" )

/*---------------------------------------------------------
   Name: LoadOrganisations()
   Desc: Mit dieser Funktion werden alle Gruppen geladen um sie Später schneller verarbeiten zu können.
---------------------------------------------------------*/

function LoadOrganisations()
	RP.Organisations = {}
	Query("SELECT * FROM Organisations", function( q )
		if #q > 0 then
			local tbl = {}
			for k, v in pairs( q ) do
				v.leader = util.JSONToTable( v.leader )
				v.member = util.JSONToTable( v.member )
				table.insert( RP.Organisations, v )
			end
			net.Start( "SendOrganisations" )
				net.WriteTable( RP.Organisations or {} )
			net.Send( player.GetAll() )
		end
    end)
end


/*---------------------------------------------------------
   Name: PlayerAuthed( Hook )
   Desc: Hier werden alle benötigten Daten geladen die der Client später benötigt.
---------------------------------------------------------*/
hook.Add( "PlayerAuthed", "SendOrganisationTable", function( ply )
	net.Start( "SendOrganisations" )
		net.WriteTable( RP.Organisations or {} )
	net.Send( ply )
	ply:SetRPVar( "organisation", ply:GetOrganisation() )
end)

/*---------------------------------------------------------
   Name: CreateOrganisation( name, level, exp, leader, member )
   Desc: Hier wird eine neue Organisation erstellt. Dann wird der bestehende Table noch angepasst.
---------------------------------------------------------*/
function CreateOrganisation( name, level, exp, leader, member )
	local leadertable = {}
	for k, v in pairs( leader ) do
		table.insert( leadertable, {name=v:Name(), sid=tostring(v:SteamID())} )
	end
	
	local leaders = util.TableToJSON( leadertable )
	local members = util.TableToJSON( member )
	Query("INSERT INTO Organisations(name,level,exp,leader,member) VALUES('" .. tostring(name) .. "'," .. tonumber(level) .. "," .. tonumber(exp) .. ",'" .. tostring(leaders) .. "','" .. tostring(members) .. "')", function( q )
		table.insert(RP.Organisations, {name=name, level=level, exp=exp, leader=leader, member=member} )
    end)
	
	LoadOrganisations()
end