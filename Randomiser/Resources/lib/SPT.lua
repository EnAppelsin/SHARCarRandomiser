local assert = assert
local type = type

local string_find = string.find
local string_format = string.format
local string_gmatch = string.gmatch
local string_match = string.match

local table_concat = table.concat

SPT = {}

local function LoadSPTFromData(self, contents)
	assert(type(contents) == "string", "Contents must be a string")
	
	local Classes = {}
	local ClassesN = 0
	
	for classType, className, classData in string_gmatch(contents, "create%s+(.-)%s+named%s+(.-)\r?\n(%b{})") do
		local Class = SPT.Class(classType, className, classData)
		
		ClassesN = ClassesN + 1
		Classes[ClassesN] = Class
	end
	
	self.__index = self
	return setmetatable({Classes = Classes}, self)
end

local function LoadSPTFile(self, Path)
	if Path == nil then
		self.__index = self
		return setmetatable({}, self)
	else
		local success, contents = pcall(ReadFile, Path)
		assert(success, string_format("Failed to read file at '%s': %s", Path, contents))
		
		
		return LoadSPTFromData(self, contents)
	end
end

SPT.SPTFile = setmetatable({load = LoadSPTFile, new = LoadSPTFile, LoadFromData = LoadSPTFromData}, {__call = LoadSPTFile})

function SPT.SPTFile:__tostring()
	local Output = {}
	local Classes = self.Classes
	for i=1,#Classes do
		Output[i] = tostring(Classes[i])
	end
	return table_concat(Output, "\r\n") .. "\r\n"
end

SPT.Class = setmetatable({}, {
	__call = function(self, classType, className, classData)
		assert(type(classType) == "string", "ClassType (Arg #1) must be a string.")
		assert(type(className) == "string", "ClassName (Arg #2) must be a string.")
		
		local Data = {
			Type = classType,
			Name = className,
		}
		
		local Variables = {}
		local VariablesN = 0
		Data.Variables = Variables
		
		for line in string_gmatch(classData, "[^\r\n]+") do
			local name, argumentsStr, option = string_match(line, "%s+(.-)%s+%(%s+(.-)%s+%)%s+option%s+(.+)")
			if name == nil then
				name, argumentsStr = string_match(line, "%s+(.-)%s+%(%s+(.-)%s+%)")
			end
			if name ~= nil then
				local variable = {
					Name = name,
					Option = option,
				}
				VariablesN = VariablesN + 1
				Variables[VariablesN] = variable
				
				local arguments = {}
				local argumentsN = 0
				variable.Arguments = arguments
				
				local openString = false
				local str
				local strN
				for word in string_gmatch(argumentsStr, "[^ ]+") do
					if string_match(word, "^\".-\"$") then
						argumentsN = argumentsN + 1
						arguments[argumentsN] = SPT.Argument(word:sub(2, -2), "string")
					else
						if word:sub(1, 1) == "\"" then
							openString = true
							str = {word:sub(2)}
							strN = 1
						end
						
						if openString then
							strN = strN + 1
							if word:sub(-1) == "\"" then
								str[strN] = word:sub(1, -2)
								argumentsN = argumentsN + 1
								arguments[argumentsN] = SPT.Argument(table_concat(str, " "), "string")
								openString = false
							else
								str[strN] = word
							end
						elseif string_match(word, "^%d+%.%d+$") then
							argumentsN = argumentsN + 1
							arguments[argumentsN] = SPT.Argument(tonumber(word), "float")
						elseif string_match(word, "^%d+$") then
							argumentsN = argumentsN + 1
							arguments[argumentsN] = SPT.Argument(tonumber(word), "int")
						elseif word == "true" then
							argumentsN = argumentsN + 1
							arguments[argumentsN] = SPT.Argument(true, "bool")
						elseif word == "false" then
							argumentsN = argumentsN + 1
							arguments[argumentsN] = SPT.Argument(false, "bool")
						else
							error("Invalid argument: " .. word)
						end
					end
				end
			end
		end
		
		self.__index = self
		return setmetatable(Data, self)
	end,
})

function SPT.Class:__tostring()
	local data = {}
	local variables = self.Variables
	for i=1,#variables do
		local variable = variables[i]
		local arguments = {}
		for j=1,#variable.Arguments do
			arguments[j] = tostring(variable.Arguments[j])
		end
		arguments =table_concat(arguments, " ")
		if variable.Option then
			data[i] = string_format("    %s ( %s ) option %s", variable.Name, arguments, variable.Option)
		else
			data[i] = string_format("    %s ( %s )", variable.Name, arguments)
		end
	end
	return string_format("create %s named %s\r\n{\r\n%s\r\n}", self.Type, self.Name, table_concat(data, "\r\n"))
end

local TypeMap = {
	["string"] = "string",
	["float"] = "number",
	["int"] = "number",
	["bool"] = "boolean",
}
SPT.Argument = setmetatable({}, {
	__call = function(self, Value, Type)
		local luaType = TypeMap[Type]
		assert(luaType, "Invalid Type (Arg #2) specified. Valid types are: string; float; int; bool.")
		
		assert(type(Value) == luaType, string_format("Invalid Value (Arg #1) specified. Lua Type must be \"%s\" for Argument Type \"%s\".", luaType, Type))
		
		assert(Type ~= "string" or string_find(Value, "[\r\n]", 1) == nil, "Invalid Valid (Arg #1) specified. String values cannot contain new lines.")
		
		self.__index = self
		return setmetatable({ Value = Value, Type = Type }, self)
	end,
})

function SPT.Argument:__tostring()
	if self.Type == "string" then
		return string_format("\"%s\"", self.Value)
	end
	
	if self.Type == "float" then
		return string_format("%.6f", self.Value)
	end
	
	if self.Type == "int" then
		return string_format("%i", self.Value)
	end
	
	if self.Type == "bool" then
		return self.Value and "true" or "false"
	end
	
	error("Invalid argument type")
end