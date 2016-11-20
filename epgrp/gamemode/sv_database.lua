--[[---------------------------------------------------------
   File: sv_database.lua
   Desc: Handles database connection and provides query function
-----------------------------------------------------------]]

require("tmysql4")

RP.SQL = RP.SQL or {}

RP.SQL.connected = false

RP.SQL.DBName = "crp"
RP.SQL.DBUser = "gmod"
RP.SQL.DBHost = "62.75.253.86"
RP.SQL.DBPassword = "lachen12"
RP.SQL.DBPort = 3306

--[[---------------------------------------------------------
   Name: Escape
   Desc: Escapes string for SQL
-----------------------------------------------------------]]
function RP.SQL:Escape(sqlstring)
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
function RP.SQL:InitializeDatabase()
    RP.SQL.db, error = db or tmysql.initialize(RP.SQL.DBHost, RP.SQL.DBUser, RP.SQL.DBPassword, RP.SQL.DBName, RP.SQL.DBPort)
    
    if not error then
        print("[RP] MySQL Connected")

        RP.SQL.connected = true

        return true
    else
        print("[RP] MySQL Error: " .. error)

        RP.SQL.connected = false

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
function RP.SQL:Query(sql, replacements, callback, errcallback)
    if RP.SQL.connected then
      if replacements and istable(replacements) then
        for k, v in pairs(replacements) do
          sql = string.Replace(sql, "%"..k.."%", self:Escape(v))
        end
      end

      print("[RP][DEBUG] " .. sql)

      RP.SQL.db:Query(sql, function(results)
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
    else
      print("[RP][ERROR] Tried to executed Query while not connected to database!")
    end
end
