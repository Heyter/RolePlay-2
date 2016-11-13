
local app_packages = {}
local app_instances = rPhone.NewWeakTable( 'k' )

local APP = {}

function APP:IsRunning()
	return rPhone.IsAppRunning( self )
end

function APP:Kill()
	rPhone.KillApp( self )
end

function APP:RegisterEventCallback( event, ident, callback )
	local inst = app_instances[self]

	if !inst then return end

	inst.events[event] = inst.events[event] or {}

	if !callback then
		callback = ident
		ident = #inst.events[event] + 1
	end
	
	inst.events[event][ident] = callback
end

function APP:UnregisterEventCallback( event, ident )
	local inst = app_instances[self]

	if !inst then return end

	inst.events[event] = inst.events[event] or {}
	inst.events[event][ident] = nil
end

function APP:TriggerEvent( event, ... )
	local inst = app_instances[self]

	if !inst then return end

	if self[event] then self[event]( self, ... ) end

	if !inst.events[event] then return end

	for _, cb in pairs( inst.events[event] ) do
		cb( self, ... )
	end
end

function APP:TriggerEventForResult( event, ... )
	local inst = app_instances[self]

	if !inst then return end

	if self[event] then
		local result = self[event]( self, ... )

		if result != nil then
			return result
		end
	end

	if !inst.events[event] then return end

	for _, cb in pairs( inst.events[event] ) do
		local result = cb( self, ... )

		if result != nil then 
			return result 
		end
	end
end

function APP:IsStarted()
	local inst = app_instances[self]

	if !inst then return end

	return inst.started == true
end

function APP:Start( canv, params )
	if !canv then return false end

	local inst = app_instances[self]

	if !inst or inst.started then return false end

	inst.started = true
	inst.canvas = canv

	canv.Draw = function( canv, w, h )
		self:TriggerEvent( "PreDraw", w, h )
		self:TriggerEvent( "Draw", w, h )
		self:TriggerEvent( "PostDraw", w, h )
	end

	self:TriggerEvent( "Initialize", params )

	return self:IsRunning()
end

function APP:GetCanvas()
	local inst = app_instances[self]

	if !inst then return end

	return inst.canvas
end

function APP:Hide()
	local inst = app_instances[self]

	if !inst or !inst.canvas then return end

	inst.canvas:SetVisible( false )
end

function APP:Show()
	local inst = app_instances[self]

	if !inst or !inst.canvas then return end

	inst.canvas:SetVisible( true )
end


function APP:Draw( w, h )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawRect( 0, 0, w, h )
end



function rPhone.RegisterAppPackage( pname )
	local pack = rPhone.GetPackage( pname )

	if !pack then
		rPhone.Error( 
			([["Attempted to register nonexistent application package '%s'.]]):format( pname ), 
			true
		)

		return
	end

	app_packages[pname] = true
end

function rPhone.CreateAppPackage( pname )
	local pack = rPhone.CreatePackage( pname )
	rPhone.RegisterAppPackage( pname )

	return pack
end

function rPhone.IsAppPackage( pname )
	return app_packages[pname] == true
end

function rPhone.GetAppPackages()
	local ret = {}

	for pname in pairs( app_packages ) do
		ret[pname] = rPhone.GetPackage( pname )
	end

	return ret
end

function rPhone.CreateAppInstance( pname )
	local pack = rPhone.GetPackage( pname )

	if !pack or !rPhone.IsAppPackage( pname ) then
		rPhone.Error( 
			([[Attempted to create instance of non-application package '%s'.]]):format( pname ), 
			true
		)

		return
	end

	local inst = {}
	local mt = { __index = function( self, k ) return pack[k] or APP[k] end }
	local data = {
		events = {}
	}

	app_instances[inst] = data

	return setmetatable( inst, mt )
end
