function Load_Plugins()
GM.RPPluginLoad = GM.RPPluginLoad or true

    if SERVER then
        if GM.RPPluginLoad then
            AddCSLuaFile( GM.FolderName.."/gamemode/modules/npc_dialogs/cl_npcs.lua" )
            AddCSLuaFile( GM.FolderName.."/gamemode/modules/npc_dialogs/sh_npcs.lua" )
            include( GM.FolderName.."/gamemode/modules/npc_dialogs/sh_npcs.lua" )
            
            local fol_important = GM.FolderName.."/gamemode/important_modules/"
            local imp_files, imp_folders = file.Find(fol_important .. "*", "LUA")
            
            for k,v in pairs(imp_files) do
                include(fol_important .. v)
            end
            
            for _, folder in SortedPairs(imp_folders, true) do
                    for _, File in SortedPairs(file.Find(fol_important .. folder .."/sh_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol_important..folder .. "/" ..File)
                        include(fol_important.. folder .. "/" ..File)
                    end

                    for _, File in SortedPairs(file.Find(fol_important .. folder .."/sv_*.lua", "LUA"), true) do
                        include(fol_important.. folder .. "/" ..File)
                    end

                    for _, File in SortedPairs(file.Find(fol_important .. folder .."/cl_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol_important.. folder .. "/" ..File)
                    end
                    
                    for _, File in SortedPairs(file.Find(fol_important .. folder .."/gui_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol_important.. folder .. "/" ..File)
                    end
            end
            
            local fol = GM.FolderName.."/gamemode/modules/"
            local files, folders = file.Find(fol .. "*", "LUA")
            --for k,v in pairs(files) do
            --    include(fol .. v)
            --end

            local fol2 = GM.FolderName.."/gamemode/npc_panels/"
            local files2, folders2 = file.Find(fol2 .. "*", "LUA")
            for k,v in pairs(files2) do
                AddCSLuaFile( fol2 .. v )
                include(fol2 .. v)
            end

            for _, folder in SortedPairs(folders, true) do
                    for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol..folder .. "/" ..File)
                        include(fol.. folder .. "/" ..File)
                    end

                    for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
                        include(fol.. folder .. "/" ..File)
                    end

                    for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol.. folder .. "/" ..File)
                    end
                    
                    for _, File in SortedPairs(file.Find(fol .. folder .."/gui_*.lua", "LUA"), true) do
                        AddCSLuaFile(fol.. folder .. "/" ..File)
                    end
            end
            
            local fol3 = GM.FolderName.."/gamemode/mixtures/"
            local files3, folders3 = file.Find(fol3 .. "*", "LUA")
            for k,v in pairs(files3) do
                AddCSLuaFile( fol3 .. v )
                include(fol3 .. v)
            end
            GM.RPPluginLoad = false
        end
    end

    if CLIENT then
        if GM.RPPluginLoad then
            include( GM.FolderName.."/gamemode/modules/npc_dialogs/cl_npcs.lua" )
            include( GM.FolderName.."/gamemode/modules/npc_dialogs/sh_npcs.lua" )
            
            local root = GM.FolderName.."/gamemode/modules/"

            local _, folders = file.Find(root.."*", "LUA")

            for _, folder in SortedPairs(folders, true) do

                for _, File in SortedPairs(file.Find(root .. folder .."/sh_*.lua", "LUA"), true) do
                    include(root.. folder .. "/" ..File)
                end
                for _, File in SortedPairs(file.Find(root .. folder .."/cl_*.lua", "LUA"), true) do
                    include(root.. folder .. "/" ..File)
                end
                for _, File in SortedPairs(file.Find(root .. folder .."/gui_*.lua", "LUA"), true) do
                    include(root.. folder .. "/" ..File)
                end
            end
            
            local fol2 = GM.FolderName.."/gamemode/npc_panels/"
            local files2, folders2 = file.Find(fol2 .. "*", "LUA")
            for k,v in pairs(files2) do
                include(fol2 .. v)
            end
            
            local fol3 = GM.FolderName.."/gamemode/mixtures/"
            local files3, folders3 = file.Find(fol3 .. "*", "LUA")
            for k,v in pairs(files3) do
                include(fol3 .. v)
            end
            GM.RPPluginLoad = false
        end
    end
end
Load_Plugins()

concommand.Add( "rp_reloadmodules", fcuntion( ply )
	if !(ply:IsSuperAdmin()) then return false end
	print( tostring( ply:Nick() ) .. " refreshed the RP MODULES!" )
	Load_Plugins()
end)