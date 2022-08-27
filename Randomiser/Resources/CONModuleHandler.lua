local Path = GetPath()
local GamePath = GetGamePath(Path)

local CONFile

local Changed = false
for i=1,#Modules do
	local Module = Modules[i]
	
	if Module.HandleCON then
		local process
		if Module.CONFilters == nil then
			process = true
		else
			for i=1,#Module.CONFilters do
				local filter = Module.CONFilters[i]
				if WildcardMatch(Path, filter, true, true) then
					process = true
					break
				end
			end
		end
		
		if process then
			CONFile = CONFile or MFKLexer.Lexer:Parse(ReadFile(GamePath))
			
			if Module.HandleCON(GamePath, CONFile) then
				Changed = true
			end
		end
	end
end

if Changed then
	CONFile:Output(true)
end