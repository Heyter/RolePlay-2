--[[---------------------------------------------------------
	Usage Examples:
	resource.AddCollection(136455077)
	resource.AddCollection(136455077, true)
	resource.AddCollections({"136455077", "136455077", "136455077"})
	resource.AddWorkshops({"128089118", "128089119", "128089117"})
-----------------------------------------------------------]]

--[[---------------------------------------------------------
	Adds a table of workshop file IDs
-----------------------------------------------------------]]
function resource.AddWorkshops(tbl)
	if not tbl then return end
	if not type(tbl) == "table" then error("Invalid table sent into resource.AddWorkshops()") end
	
	for _, id in pairs(tbl) do
		resource.AddWorkshop(tostring(id))
	end
end

local function useCacheCollection(id, force)
	
	if not id then return end

	local cache = "collections/" .. tostring(id) .. ".txt"
	if file.Exists(cache, "DATA") and ((os.time() - file.Time(cache, "DATA")) <= 300 or force) then
		local workshops = util.JSONToTable(file.Read(cache, "DATA"))
		if workshops and #workshops > 0 then
			resource.AddWorkshops(workshops)
			MsgN(string.format("Loading collection '%s' with %d workshop files from cache...", tostring(id), #workshops))
			return true
		end
	end
	if force then ErrorNoHalt(string.format("ERROR: Unable to find a collection cache for '%s'...\n", tostring(id))) end
	return false
end

if not file.Exists("collections", "DATA") then
	file.CreateDir("collections")
end

--[[---------------------------------------------------------
	Adds the workshop files from a workshop collection ID
	set the second parameter to true to never use the cache
-----------------------------------------------------------]]
function resource.AddCollection(id, noCache)
	if not id then return end
	local cache = "collections/" .. tostring(id) .. ".txt"
	
	if not noCache then 
		if useCacheCollection(id, false) then return end
	end
	
	timer.Simple(0, function()
		http.Fetch("http://steamcommunity.com/sharedfiles/filedetails/?id=" .. id,
			function(body)
				local workshops = {}
				for workshop in string.gmatch(body, '<a href="http://steamcommunity.com/sharedfiles/filedetails/%?id=(%d+)"><div class="workshopItemTitle">') do
					table.insert(workshops, workshop)
				end
				
				if #workshops <= 0 then
					ErrorNoHalt(string.format("ERROR: Unable to find workshop files in collection '%s'.\n", tostring(id)))
				else
					MsgN(string.format("Loading collection '%s' with %d workshop files...", tostring(id), #workshops))
					resource.AddWorkshops(workshops)
					if not noCache then file.Write(cache, util.TableToJSON(workshops)) end
				end
			end,
			function(err)
				ErrorNoHalt(string.format("ERROR: Unable to fetch collection '%s' (%s).\n", tostring(id), tostring(err)))
				if not noCache then useCacheCollection(cache, true) end
			end
		)
	end)
end

--[[---------------------------------------------------------
	Adds a table of workshop collection IDs
-----------------------------------------------------------]]
function resource.AddCollections(tbl)
	if not tbl then return end
	if not type(tbl) == "table" then error("Invalid table sent into resource.AddCollections()") end
	
	for _, id in pairs(tbl) do
		resource.AddCollection(tostring(id))
	end
end
