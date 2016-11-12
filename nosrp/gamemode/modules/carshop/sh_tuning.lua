CARSHOP = CARSHOP or {}
CARSHOP.TuningStrings = CARSHOP.TuningStrings or {}

function CARSHOP.ApplyVisuals( ply, car, carname )
    local model = false
    if !(IsValid( ply )) then return end
    if !(IsValid( car )) then return end
    if !(car:IsVehicle()) then model = true end
    carname = carname or nil
    
    local garage = ply:GetRPVar( "garage_table" )
    local car_tbl
    
    if model then car_tbl = garage[carname] else car_tbl = garage[car:GetTable().VehicleName] end
    
    local bg = car_tbl.data
    bg.bodygroups = bg.bodygroups or {}
   
    for k, v in pairs( bg.bodygroups ) do
        car:SetBodygroup( k, v )
    end
    car:SetColor( Color( car_tbl.col_r, car_tbl.col_g, car_tbl.col_b, 255 ) )
    if car:GetSkin() == 0 then car:SetSkin( 1 ) end
end

function CARSHOP.ApplyEngineStats( ply, car )
    if !(IsValid( ply )) then return end
    if !(IsValid( car )) then return end
    if !(car:IsVehicle()) then return end
    
    local garage = ply:GetRPVar( "garage_table" )
    local car_tbl = garage[car:GetClass()]
    local tuning = car_tbl.tuning
    tuning = tuning or {}
   
    for k, v in pairs( tuning ) do
        --car:SetBodygroup( k, v )
    end
end


// Adding Feature
/*
function CARSHOP.AddCarTuningString( info )
    info = info or nil
    if info == nil then return end
    
    CARSHOP.TuningStrings[info.CarTableName] = info
    CARSHOP.CARTABLE.CARS[info.CarTableName].Tuneable = true
    
    local cnt = 0
    
    for k, v in pairs( info.Tuning ) do cnt = cnt + 1 end
    
    print( "Tuning String: " .. tostring( info.CarTableName ) .. " successfully added! Tuning Options: " .. tostring(cnt) )
end*/


// Shop functions
if SERVER then
    

end