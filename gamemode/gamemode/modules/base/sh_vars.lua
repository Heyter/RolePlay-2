local meta = FindMetaTable( "Entity" )

function meta:GetRPVar( var )
    if !(IsValid( self )) then return end
    self.RPVars = self.RPVars or {}
    self.RPVars[var] = self.RPVars[var] or nil
    return self.RPVars[var]
end

if SERVER then
    util.AddNetworkString( "SendPlayerVar" ) 
    
    function meta:UpdateRPVars( )
        for k, v in pairs( player.GetAll() ) do
            net.Start( "SendPlayerVar" )
                net.WriteEntity( v )
                net.WriteTable( v.RPVars or {} )
            net.Send( self )
        end
        
        for k, v in pairs( ents.GetAll() ) do
            if !(IsValid( v )) then continue end
            
            net.Start( "SendPlayerVar" )
                net.WriteEntity( v )
                net.WriteTable( v.RPVars or {})
            net.Send( self )
        end
    end

    function meta:SetRPVar( var, value )
        if !(IsValid( self )) then return end
        self.RPVars = self.RPVars or {}
        self.RPVars[var] = self.RPVars[var] or nil
        
        self.RPVars[var] = value
        
        net.Start( "SendPlayerVar" )
            net.WriteEntity( self )
            net.WriteTable( self.RPVars or {} )
        net.Send( player.GetAll() )
    end
    
    function meta:UpdateRPVarTable( table_name, table_index, _input )
        self.RPVars = self.RPVars or {}
        
        if !(table_name) then return end
        if !(table_index) then return end
        
        if self.RPVars[table_name] && self.RPVars[table_name][table_index] && type( self.RPVars[table_name][table_index] ) == "table" then
            self.RPVars[table_name][table_index] = _input
            
            net.Start( "SendPlayerVar" )
                net.WriteEntity( self )
                net.WriteTable( self.RPVars or {} )
            net.Send( player.GetAll() )
        end
    end
    
    net.Receive( "SendPlayerVar", function( data, ply )
        ply.last_var_request = ply.last_var_request or CurTime() - 1
        if ply.last_var_request < CurTime() + 2 then
            ply:UpdateRPVars( )
            ply.last_var_request = CurTime() + 2
        end
    end)
    
    --net.Receive( "CSLoaded", function()
    --    ply:UpdateRPVars( )
    --end)
end

if CLIENT then
    net.Receive( "SendPlayerVar", function( len, client )
        local ent = net.ReadEntity()
        local data = net.ReadTable()
        ent.RPVars = ent.RPVars or {}
        ent.RPVars = data
    end)
    
    function meta:SetRPVar( var, value )
        if !(IsValid( self )) then return end
        self.RPVars = self.RPVars or {}
        self.RPVars[var] = self.RPVars[var] or nil
        
        self.RPVars[var] = value
    end
end