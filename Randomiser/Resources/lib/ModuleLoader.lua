local ModuleFiles = {}
GetFilesInDirectory(Paths.Modules, ModuleFiles, ".lua")

assert(#ModuleFiles > 0, "No modules found.")

Modules = {}
ModulesN = 0
for i=1,#ModuleFiles do
	local ModuleFile = ModuleFiles[i]
	
	local contents = ReadFile(ModuleFiles[i])
	local chunk, err = load(contents, "@" .. ModuleFile)
	assert(chunk, string.format("Error loading module \"%s\":\n%s", ModuleFile, err))
	
	local success, result = pcall(chunk)
	assert(success, string.format("Error executing module \"%s\":\n%s", ModuleFile, result))
	assert(type(result) == "table", string.format("Invalid return value from module \"%s\":\nGot type %s, expected table", ModuleFile, type(result)))
	
	if result.Setting == nil or Settings[result.Setting] then
		ModulesN = ModulesN + 1
		Modules[ModulesN] = result
	end
end

print("Loaded " .. ModulesN .. " modules")