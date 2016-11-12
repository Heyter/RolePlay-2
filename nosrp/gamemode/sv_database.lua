--[[---------------------------------------------------------
   File: sv_database.lua
   Desc: Handles database connection and provides query function
-----------------------------------------------------------]]

require("mysqloo")

--[[---------------------------------------------------------
   File: sv_LCONFIG-dist.lua
   Desc: LCONFIG template
-----------------------------------------------------------]]

print("DB: CONNECT")

local LCONFIG = {}

LCONFIG.DBName = "crp"
LCONFIG.DBUser = "gmod"
LCONFIG.DBHost = "62.75.253.86"
LCONFIG.DBPassword = "lachen12"
LCONFIG.DBPort = 3306


local db = db or mysqloo.connect(LCONFIG.DBHost, LCONFIG.DBUser, LCONFIG.DBPassword, LCONFIG.DBName, LCONFIG.DBPort)
local queue = {} 

--[[---------------------------------------------------------
   Name: db:onConnected
   Desc: Called by mysqloo when connection is established
-----------------------------------------------------------]]
function db:onConnected()
    for k, v in pairs(queue) do

        Query(v[1], v[2])

    end
    queue = {}
    print("Connected to Database ", LCONFIG.DBName, "!")
    
    --DatabaseConnected()
end

--[[---------------------------------------------------------
   Name: db:onConnectionFailed
   Desc: Called by mysqloo when connection failed
-----------------------------------------------------------]]
function db:onConnectionFailed(err)
    print("Connection to database failed!")
    print("Error:", err)
end
local canconnect = true
--[[---------------------------------------------------------
   Name: InitializeDatabase
   Desc: Connects to database
-----------------------------------------------------------]]
function InitializeDatabase()
    db:connect()
    canconnect = false
    return true
end

--[[---------------------------------------------------------
   Name: Query
   Desc: Queries the database, retrys if connection failed
   Parameters:
        sql: Query string, don't forget to escape with variables
        callback: Function called on success; with data as parameter
-----------------------------------------------------------]]
function Query(sql, callback, errcallback)
    local q = db:query(sql)
    
    errcallback = errcallback or nil
  
    
    print( sql )
    
    function q:onSuccess(data)
        callback(data)
    end

    function q:onError(err)
        
        
        if errcallback != nil then
            errcallback( err )
        else
            print("Query Errored, error:", err, " sql: ", sql)
        end
    end

    q:start()
end

--[[---------------------------------------------------------
   Name: Escape
   Desc: Escapes a String, for save use
-----------------------------------------------------------]]
function Escape(string)
    return db:escape(string)
end

