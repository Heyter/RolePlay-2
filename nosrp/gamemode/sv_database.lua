--[[---------------------------------------------------------
   File: sv_database.lua
   Desc: Handles database connection and provides query function
-----------------------------------------------------------]]

require("tmysql4")

--[[---------------------------------------------------------
   File: sv_LCONFIG-dist.lua
   Desc: LCONFIG template
-----------------------------------------------------------]]

local LCONFIG = {}

LCONFIG.DBName = "crp"
LCONFIG.DBUser = "gmod"
LCONFIG.DBHost = "62.75.253.86"
LCONFIG.DBPassword = "lachen12"
LCONFIG.DBPort = 3306

--[[---------------------------------------------------------
   Name: Escape
   Desc: Escapes string for SQL
-----------------------------------------------------------]]
function Escape(sqlstring)
    local allowedStrings = {}

    if table.HasValue(allowedStrings,sqlstring) then
      return sqlstring
    end

    return "'"..self.db:Escape(tostring(sqlstring)).."'"
end

--[[---------------------------------------------------------
   Name: InitializeDatabase
   Desc: Connects to database
-----------------------------------------------------------]]
function InitializeDatabase()
    RP.db, error = db or tmysql.initialize(LCONFIG.DBHost, LCONFIG.DBUser, LCONFIG.DBPassword, LCONFIG.DBName, LCONFIG.DBPort)
    
    if not error then
        print("[RP] MySQL Connected")
        return true
    else
        print("[RP] MySQL Error: " .. error)
        return false
    end
end

--[[---------------------------------------------------------
   Name: Query
   Desc: Queries the database, retrys if connection failed
   Parameters:
        sql: Query string, don't forget to escape with variables
        callback: Function called on success; with data as parameter
-----------------------------------------------------------]]
function Query(sql, callback, errcallback)
    print("[RP][DEBUG] " .. sql)

    RP.db:Query(sql, function(results)
      if results[1].status then
        if callback and isfunction(callback) then
          callback(results[1]["data"])
        end
      else
        print("[RP] Error while executing Query:\n"..results[1].error.."\n\nQuery:\n"..sql)
        if errcallback and isfunction(errcallback) then
          errcallback(results[1]["error"])
        end
      end
    end)
end
