-- Initialize
if SERVER then
	AddCSLuaFile("cartuning/cl_cartuning.lua");
	AddCSLuaFile("cartuning/sh_cartuning.lua");
	include("cartuning/sh_cartuning.lua");
	include("cartuning/sv_cartuning.lua");
else
	include("cartuning/cl_cartuning.lua"); 
	include("cartuning/sh_cartuning.lua"); 
end
