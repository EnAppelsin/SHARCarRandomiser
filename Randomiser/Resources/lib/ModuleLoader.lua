-- Local references for optimisation
local assert = assert
local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring = tostring
local type = type

Module = setmetatable({
	AddLevelHandler = function(self, callback, levels)
		assert(type(callback) == "function", "Callback (Arg #1) must be a function.")
		if levels ~= nil then
			assert(type(levels) == "table", "Levels (Arg #2) must be a table.")
			for k in pairs(levels) do
				assert(type(k) == "number", "Levels (Arg #2) keys must only contain numbers. Key " .. tostring(k) .. " is not a number.")
			end
		end
		
		local levelHandlers = self.Handlers.Level
		for Level=1,7 do
			local level = levelHandlers[Level]
			if levels == nil or levels[Level] then
				level[#level + 1] = callback
			end
		end
	end,
	AddSundayDriveHandler = function(self, callback, missions)
		assert(type(callback) == "function", "Callback (Arg #1) must be a function.")
		if missions ~= nil then
			assert(type(missions) == "table", "Missions (Arg #2) must be a table.")
			for level, levelMissions in pairs(missions) do
				assert(type(level) == "number", "Missions (Arg #2) keys must only contain numbers. Key " .. tostring(level) .. " is not a number.")
				assert(type(levelMissions) == "table", "Missions (Arg #2) values must only contain tables. Key " .. level .. " is not a table.")
				for mission in pairs(levelMissions) do
					assert(type(mission) == "number", "Missions (Arg #2) subkeys must only contain numbers. Key " .. tostring(mission) .. " is not a number.")
				end
			end
		end
		
		local sundayDriveHandlers = self.Handlers.SundayDrive
		for Level=1,7 do
			local level = sundayDriveHandlers[Level]
			for Mission=1,8 do
				local mission = level[Mission]
				if missions == nil or missions[Level] == nil or missions[Level][Mission] then
					mission[#mission + 1] = callback
				end
			end
		end
	end,
	AddMissionHandler = function(self, callback, missions)
		assert(type(callback) == "function", "Callback (Arg #1) must be a function.")
		if missions ~= nil then
			assert(type(missions) == "table", "Missions (Arg #2) must be a table.")
			for level, levelMissions in pairs(missions) do
				assert(type(level) == "number", "Missions (Arg #2) keys must only contain numbers. Key " .. tostring(level) .. " is not a number.")
				assert(type(levelMissions) == "table", "Missions (Arg #2) values must only contain tables. Key " .. level .. " is not a table.")
				for mission in pairs(levelMissions) do
					assert(type(mission) == "number", "Missions (Arg #2) subkeys must only contain numbers. Key " .. tostring(mission) .. " is not a number.")
				end
			end
		end
		
		local missionHandlers = self.Handlers.Mission
		for Level=1,7 do
			local level = missionHandlers[Level]
			for Mission=1,8 do
				local mission = level[Mission]
				if missions == nil or missions[Level] == nil or missions[Level][Mission] then
					mission[#mission + 1] = callback
				end
			end
		end
	end,
	AddRaceHandler = function(self, callback, races)
		assert(type(callback) == "function", "Callback (Arg #1) must be a function.")
		if races ~= nil then
			assert(type(races) == "table", "Races (Arg #2) must be a table.")
			for level, levelRaces in pairs(races) do
				assert(type(level) == "number", "Races (Arg #2) keys must only contain numbers. Key " .. tostring(level) .. " is not a number.")
				assert(type(levelRaces) == "table", "Races (Arg #2) values must only contain tables. Key " .. level .. " is not a table.")
				for race in pairs(levelRaces) do
					assert(type(race) == "number", "Races (Arg #2) subkeys must only contain numbers. Key " .. tostring(race) .. " is not a number.")
				end
			end
		end
		
		local raceHandlers = self.Handlers.Race
		for Level=1,7 do
			local level = raceHandlers[Level]
			for Race=1,4 do
				local race = level[Race]
				if races == nil or races[Level] == nil or races[Level][Race] then
					race[#race + 1] = callback
				end
			end
		end
	end,
	AddCONHandler = function(self, path, callback)
		assert(type(path) == "string", "Path (Arg #1) must be a string.")
		assert(type(callback) == "function", "Callback (Arg #2) must be a function.")
		
		self.Handlers.CON[#self.Handlers.CON + 1] = {
			Path = path,
			Callback = callback
		}
	end,
	AddP3DHandler = function(self, path, callback)
		assert(type(path) == "string", "Path (Arg #1) must be a string.")
		assert(type(callback) == "function", "Callback (Arg #2) must be a function.")
		
		self.Handlers.P3D[#self.Handlers.P3D + 1] = {
			Path = path,
			Callback = callback
		}
	end,
	AddSPTHandler = function(self, path, callback)
		assert(type(path) == "string", "Path (Arg #1) must be a string.")
		assert(type(callback) == "function", "Callback (Arg #2) must be a function.")
		
		self.Handlers.SPT[#self.Handlers.SPT + 1] = {
			Path = path,
			Callback = callback
		}
	end,
	AddGenericHandler = function(self, path, callback)
		assert(type(path) == "string", "Path (Arg #1) must be a string.")
		assert(type(callback) == "function", "Callback (Arg #2) must be a function.")
		
		self.Handlers.Generic[#self.Handlers.Generic + 1] = {
			Path = path,
			Callback = callback
		}
	end,
}, 
{
	__call = function(self, name, setting, priority)
		assert(type(name) == "string", "Name (Arg #1) must be a string.")
		assert(setting == nil or type(setting) == "string", "Setting (Arg #2) must be a string.")
		assert(priority == nil or type(priority) == "number", "Priority (Arg #3) must be a number.")
		
		local Data = {
			-- Config
			Name = name,
			Setting = setting,
			Priority = priority or 5,
			
			-- Handlers
			Handlers = {
				Level = {},
				SundayDrive = {},
				Mission = {},
				Race = {},
				MFK = {},
				
				P3D = {},
				
				CON = {},
				
				SPT = {},
				
				Generic = {},
			}
		}
		
		local handlers = Data.Handlers
		for level=1,7 do
			handlers.Level[level] = {}
			
			local SundayDrive = {}
			local Mission = {}
			local Race = {}
			
			for mission=1,8 do
				SundayDrive[mission] = {}
				Mission[mission] = {}
			end
			for race=1,4 do
				Race[race] = {}
			end
			
			handlers.SundayDrive[level] = SundayDrive
			handlers.Mission[level] = Mission
			handlers.Race[level] = Race
		end
		
		self.__index = self
		return setmetatable(Data, self)
	end
})

ModuleLoader = {}

local function CompareModules(Module1, Module2)
	return Module1.Priority < Module2.Priority
end

function ModuleLoader.LoadModules(path)
	assert(type(path) == "string", "Path (Arg #1) must be a string.")
	assert(Exists(path, false, true), "Path (Arg #1) must be a directory that exists.")
	
	local ModuleFiles = {}
	GetFilesInDirectory(path, ModuleFiles, ".lua", true)
	assert(#ModuleFiles > 0, "No module files found in Path (Arg #1)")
	
	Modules = Modules or {}
	local ModulesN = #Modules
	
	for i=1,#ModuleFiles do
		local ModuleFile = ModuleFiles[i]
		
		local contents = ReadFile(ModuleFile)
		local chunk, err = load(contents, "@" .. ModuleFile)
		assert(chunk, string.format("Error loading module \"%s\":\n%s", ModuleFile, err))
		
		local success, result = pcall(chunk)
		assert(success, string.format("Error executing module \"%s\":\n%s", ModuleFile, result))
		assert(getmetatable(result) == Module, string.format("Invalid return value from module \"%s\". Invalid metatable.", ModuleFile))
		
		if result.Setting == nil or Settings[result.Setting] then
			ModulesN = ModulesN + 1
			Modules[ModulesN] = result
			print("Loaded module: " .. ModuleFile)
		else
			print("Skipping module due to setting disabled: " .. ModuleFile)
		end
	end
	
	table.sort(Modules, CompareModules)
	print("Module priority:")
	for i=1,ModulesN do
		print("", Modules[i].Priority, Modules[i].Name)
	end
end