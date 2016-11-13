
local APP = rPhone.CreateAppPackage( "tray" )


local note_instances = rPhone.NewWeakTable( 'k' )

local function priorityInsert( tbl, ntbl )
	for i, v in ipairs( tbl ) do
		if v.priority <= ntbl.priority then
			table.insert( tbl, i, ntbl )

			return
		end
	end

	table.insert( tbl, ntbl )
end

local NMT = {}

function NMT:GetWide()
	local note = note_instances[self]
	if !note then return end

	return note.width
end

function NMT:GetTall()
	local note = note_instances[self]
	if !note then return end

	return note.height
end

function NMT:GetSize()
	local note = note_instances[self]
	if !note then return end

	return note.width, note.height
end

function NMT:IsValid()
	local note = note_instances[self]
	if !note then return false end

	local tray = note.tray

	if !rPhone.IsAppRunning( tray ) or !tray:HasNotification( self ) then return false end

	return true
end

function NMT:Remove()
	local note = note_instances[self]
	if !note then return end

	local tray = note.tray

	if !rPhone.IsAppRunning( tray ) then return end

	tray:RemoveNotification( self )
end

function NMT:Draw()
end



function APP:Initialize()
	local canv = self:GetCanvas()
	local cw, ch = canv:GetSize()

	self.icon_size = ch - 4
	self.icon_cnt = math.floor( (cw - 2) / (self.icon_size + 2) )

	local xspc = (cw - (self.icon_cnt * self.icon_size)) / (self.icon_cnt + 1)

	for i=1, self.icon_cnt do
		local pnl = canv:AddPanel( "RPDSimpleButton" )
			pnl:SetSize( self.icon_size, self.icon_size )
			pnl:SetPos(
				(i * xspc) + ((i - 1) * self.icon_size),
				2
			)
			pnl.Paint = function( pnl, w, h )
				local nidx = self.visible[i]

				if nidx then
					self.notifications[nidx].note:Draw( w, h )
				end
			end
			pnl.OnCursorEntered = function( pnl )
				local nidx = self.visible[i]
				
				pnl:SetCursor( (nidx and self.notifications[nidx].note.DoClick) and "hand" or "arrow" )
			end
			pnl.DoClick = function( pnl )
				local nidx = self.visible[i]

				if nidx then
					local note = self.notifications[nidx].note
					
					if note.DoClick then note:DoClick() end
				end
			end
	end

	self.visible = {}
	self.notifications = {}
end

function APP:UpdateVisible()
	self.visible = {}

	local l, r = 1, 0

	for i=1, self.icon_cnt do
		local ntbl = self.notifications[i]

		if !ntbl then break end

		if ntbl.side == 'l' then
			self.visible[l] = i
			l = l + 1
		else
			self.visible[self.icon_cnt - r] = i
			r = r + 1
		end
	end
end

function APP:AddNotification( nbt, priority, side )
	side = side or "left"
	side = (side[1] == 'l') and 'l' or 'r'
	priority = priority or 1

	local note = setmetatable( {}, { __index = function( self, k ) return nbt[k] or NMT[k] end } )
	local ninfo = { side = side, priority = priority, note = note }

	priorityInsert( self.notifications, ninfo )

	note_instances[note] = { tray = self, width = self.icon_size, height = self.icon_size }

	self:UpdateVisible()

	return note
end

function APP:HasNotification( note )
	for _, ninfo in pairs( self.notifications ) do
		if ninfo.note == note then
			return true
		end
	end

	return false
end

function APP:RemoveNotification( note )
	for k, ninfo in pairs( self.notifications ) do
		if ninfo.note == note then
			table.remove( self.notifications, k )

			self:UpdateVisible()

			return
		end
	end
end
