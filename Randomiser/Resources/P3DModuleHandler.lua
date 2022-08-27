local Path = GetPath()
local GamePath = GetGamePath(Path)

local P3DFile

local Changed = false
for i=1,#Modules do
	local Module = Modules[i]
	
	if Module.HandleP3D then
		local process
		if Module.P3DFilters == nil then
			process = true
		else
			for i=1,#Module.P3DFilters do
				local filter = Module.P3DFilters[i]
				if WildcardMatch(Path, filter, true, true) then
					process = true
					break
				end
			end
		end
		
		if process then
			P3DFile = P3DFile or P3D.P3DFile(GamePath)
			
			if Module.HandleP3D(GamePath, P3DFile) then
				Changed = true
			end
		end
	end
end

if Changed then
	print("Modified: " .. Path)
	P3DFile:Output()
end