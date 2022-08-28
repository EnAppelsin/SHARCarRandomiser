local Path = GetPath()
local GamePath = GetGamePath(Path)

local MFKFile

local Changed = false
for j=1,#ModuleKeys do
	local Modules = Modules[ModuleKeys[j]]
	for i=1,#Modules do
		local Module = Modules[i]
		
		if Module.HandleMFK then
			local process
			if Module.MFKFilters == nil then
				process = true
			else
				for i=1,#Module.MFKFilters do
					local filter = Module.MFKFilters[i]
					if WildcardMatch(Path, filter, true, true) then
						process = true
						break
					end
				end
			end
			
			if process then
				MFKFile = MFKFile or MFKLexer.Lexer:Parse(ReadFile(GamePath))
				
				if Module.HandleMFK(GamePath, MFKFile) then
					Changed = true
				end
			end
		end
	end
end

if Changed then
	MFKFile:Output(true)
end