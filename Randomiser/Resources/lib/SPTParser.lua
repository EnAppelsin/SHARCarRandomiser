local assert = assert
local setmetatable = setmetatable
local tostring = tostring
local type = type

local string_find = string.find
local string_format = string.format
local string_gmatch = string.gmatch
local string_match = string.match
local string_rep = string.rep
local string_sub = string.sub
local string_unpack = string.unpack

local table_concat = table.concat
local table_remove = table.remove
local table_unpack = table.unpack

local Exists = Exists

-- Gotta love some good ol' radical hardcoding.
-- Key is actual class name.
-- Value is SPT entry name.
local ClassMap = {
	["IDaSoundResourceData"] = "daSoundResourceData",
	["ICarSoundParameters"] = "carSoundParameters",
	["IPositionalSoundSettings"] = "positionalSoundSettings",
	["IGlobalSettings"] = "globalSettings",
	["IReverbSettings"] = "reverbSettings",
}
-- Key is C++ type
-- Value is Lua type
local TypeMap = {
	["char*"] = "string",
	["float"] = "number",
	["int"] = "number",
	["unsigned int"] = "number",
	["bool"] = "boolean",
}
-- Key is C++ type
-- Value is Lua pattern
local TypePatternMap = {
	["char*"] = "\"(.-)\"",
	["float"] = "(-?%d+%.%d+)",
	["int"] = "(-?%d+)",
	["unsigned int"] = "(%d+)",
	["bool"] = "(%a%a%a%a%a?)",
}
-- Key is C++ type
-- Value is Lua format
local TypeFormatMap = {
	["char*"] = "\"%s\"",
	["float"] = "%.6f",
	["int"] = "%i",
	["unsigned int"] = "%u",
	["bool"] = "%s",
}
-- I hate this, but Lua
local BoolMap = {
	["true"] = true,
	["false"] = false,
}
-- Hate this too
local CurlyBraces = {
	["{"] = true,
	["}"] = true,
}

local KnownClasses = {}
local Enums = {}

do
	local srrtypesPath = "/GameData/sound/typ/srrtypes.typ"
	assert(Exists(srrtypesPath, true, false), "Could not find \"srrtypes.typ\".")
	local srrtypes = ReadFile(srrtypesPath)
	
	local StartTime = GetTime()
	local TokenType = {
		Version = 0x43,
		Class = 0x40,
		Method = 0x41,
		Enum = 0x44,
	}

	local function NullTerminate(str)
		if str == nil then return nil end
		local strLen = #str
		if strLen == 0 then return str end
		local null = string_find(str, "\0", 1, true)
		if null == nil then return str end
		return string_sub(str, 1, null-1)
	end
	
	local token
	local pos = 1

	local knownClass = false
	while pos < #srrtypes do
		token, pos = string.unpack("<I", srrtypes, pos)
		
		if token == TokenType.Version then
			local version
			version, pos = string_unpack("<I", srrtypes, pos)
			
			assert(version == 4, "Unknown version")
		elseif token == TokenType.Class then
			if knownClass then
				knownClass = nil
			end
			
			local name, totalMethodCount, totalEnumCount
			name, totalMethodCount, totalEnumCount, pos = string_unpack("<s4II", srrtypes, pos)
			name = NullTerminate(name)
			totalMethodCount = totalMethodCount + 1
			
			local className = ClassMap[name]
			if className then
				knownClass = {}
				KnownClasses[className] = knownClass
			end
		elseif token == TokenType.Method then
			local name, numParams, paramName, paramType, indirectLevel
			name, numParams, paramName, paramType, indirectLevel, pos = string_unpack("<s4Is4s4I", srrtypes, pos)
			name = NullTerminate(name)
			paramName = NullTerminate(paramName)
			paramType = NullTerminate(paramType) .. string_rep("*", indirectLevel)
			
			local method = {
				ReturnType = paramType
			}
			
			if knownClass then
				knownClass[name] = method
			end
			
			for i=1,numParams do
				paramName, paramType, indirectLevel, pos = string.unpack("<s4s4I", srrtypes, pos)
				paramName = NullTerminate(paramName)
				paramType = NullTerminate(paramType) .. string_rep("*", indirectLevel)
				
				assert(knownClass == nil or TypeMap[paramType], "Unknown param type: " .. paramType)
				method[i] = { paramName, paramType }
			end
		elseif token == TokenType.Enum then
			local name, numEnum, literalName, literalValue
			name, numEnum, pos = string.unpack("s4I", srrtypes, pos)
			name = NullTerminate(name)
			
			assert(knownClass == nil, "A known class has an enum. This is currently unsupported.")
			
			local values = {}
			Enums[name] = values
			
			for i=1,numEnum do
				literalName, literalValue, pos = string.unpack("s4I", srrtypes, pos)
				literalName = NullTerminate(literalName)
				values[i] = literalName
			end
		else
			error(string.format("Unknown token: 0x%X", token))
		end
	end
	local EndTime = GetTime()
	print("SPTParser", string_format("Parsed SPT type data in: %.2fms", (EndTime - StartTime) * 1000))
end

if IsTesting() then
	for name, data in pairs(KnownClasses) do
		print("SPTParser", "Known Class: " .. name)
		for methodName,methodData in pairs(data) do
			local params = {}
			for i=1,#methodData do
				params[i] = methodData[i][2] .. " " .. methodData[i][1]
			end
			print("SPTParser", "", methodData.ReturnType .. " " .. methodName .. "(" .. table.concat(params, ", ") .. ")")
		end
	end
	for name, data in pairs(Enums) do
		print("SPTParser", "Enum: " .. name)
		for i=1,#data do
			print("SPTParser", "", data[i])
		end
	end
end

SPTParser = {}

local function LoadSPTFromData(self, contents)
	assert(type(contents) == "string", "Contents must be a string")
	
	local Classes = {}
	local ClassesN = 0
	
	for classType, className, classData in string_gmatch(contents, "create%s+(.-)%s+named%s+(.-)\r?\n(%b{})") do
		local Class = SPTParser.Class(classType, className, classData)
		
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

SPTParser.SPTFile = setmetatable({load = LoadSPTFile, new = LoadSPTFile, LoadFromData = LoadSPTFromData}, {__call = LoadSPTFile})

function SPTParser.SPTFile:GetClasses(Type, Backwards, Name)
	assert(Type == nil or type(Type) == "string", "Arg #1 (Type) must be a string.")
	assert(Name == nil or type(Name) == "string", "Arg #3 (Name) must be a string.")
	
	local classes = self.Classes
	local classesN = #classes
	
	local index, finish, step
	if Backwards then
		index = classesN
		finish = 0
		step = -1
	else
		index = 1
		finish = classesN + 1
		step = 1
	end
	
	return function()
		while index ~= finish do
			assert(Backwards or classesN == #classes, string_format("Class count changed from %d to %d. To add or remove classes whilst iterating, you must iterate backwards", classesN, #classes))
			local Class = classes[index]
			index = index + step
			if (Type == nil or Class.Type == Type) and (Name == nil or Class.Name == Name) then
				return Class, index - step
			end
		end
		return nil
	end
end

function SPTParser.SPTFile:GetClass(Type, Backwards, Name)
	return self:GetClasses(Type, Backwards, Name)()
end

function SPTParser.SPTFile:RemoveClass(Index)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number.")
	assert(Index > 0 and Index <= #self.Classes, "Arg #1 (Index) out of bounds.")
	table_remove(self.Classes, Index)
end

function SPTParser.SPTFile:__tostring()
	local Classes = self.Classes
	
	local Output = {}
	for i=1,#Classes do
		Output[i] = tostring(Classes[i])
	end
	
	return table_concat(Output)
end

SPTParser.Class = setmetatable({}, {
	__call = function(self, classType, className, classData)
		assert(type(classType) == "string", "ClassType (Arg #1) must be a string.")
		assert(type(className) == "string", "ClassName (Arg #2) must be a string.")
		assert(classData == nil or type(classData) == "string", "ClassData (Arg #3) must be a string.")
		
		local knownClass = KnownClasses[classType]
		assert(knownClass, "Unknown class type: " .. classType)
		
		local Class = {
			Type = classType,
			Name = className,
		}
		
		local Methods = {}
		local MethodsN = 0
		Class.Methods = Methods
		
		if classData then
			for line in string_gmatch(classData, "[^\r\n]+") do
				if not CurlyBraces[line] then
					local methodName, methodParameters, methodOption = string_match(line, "%s+(.-)%s+%(%s+(.-)%s+%)%s+option%s+(.+)")
					if methodName == nil then
						methodName, methodParameters = string_match(line, "%s+(.-)%s+%(%s+(.-)%s+%)")
					end
					
					if methodName ~= nil then
						local knownMethod = knownClass[methodName]
						assert(knownMethod, string_format("Unknown method: %s->%s", classType, methodName))
						local numParameters = #knownMethod
						
						local method = {
							Name = methodName,
							Option = methodOption,
						}
						MethodsN = MethodsN + 1
						Methods[MethodsN] = method
						
						if numParameters == 0 then
							-- No arguments
							assert(#methodParameters == 0, string_format("Method \"%s->%s\" should have no parameters, but some where specified.", classType, methodName))
							method.Parameters = {}
						else
							local parameterPattern = {}
							for i=1,numParameters do
								local param = knownMethod[i]
								local paramType = param[2]
								
								local pattern = TypePatternMap[paramType]
								assert(pattern, string_format("Unknown param type: %s", paramType))
								
								parameterPattern[i] = pattern
							end
							parameterPattern = table_concat(parameterPattern, "%s+")
							
							local parameters = {string_match(methodParameters, "^" .. parameterPattern .. "$")}
							assert(#parameters == numParameters, string_format("Method \"%s->%s\" should have %i parameters.", classType, methodName, numParameters))
							
							for i=1,numParameters do
								local param = knownMethod[i]
								local paramType = param[2]
								
								local luaType = TypeMap[paramType]
								if luaType == "string" then
									-- Already a string
								elseif luaType == "number" then
									parameters[i] = tonumber(parameters[i])
								elseif luaType == "boolean" then
									local bool = BoolMap[parameters[i]]
									assert(bool ~= nil, "Invalid bool parameter value")
									parameters[i] = bool
								end
							end
							
							method.Parameters = parameters
						end
					end
				end
			end
		end
		
		self.__index = self
		return setmetatable(Class, self)
	end,
})

function SPTParser.Class:GetMethods(Backwards, Name)
	assert(Name == nil or type(Name) == "string", "Arg #2 (Name) must be a string.")
	
	local methods = self.Methods
	local methodsN = #methods
	
	local index, finish, step
	if Backwards then
		index = methodsN
		finish = 0
		step = -1
	else
		index = 1
		finish = methodsN + 1
		step = 1
	end
	
	return function()
		while index ~= finish do
			assert(Backwards or methodsN == #methods, string_format("Method count changed from %d to %d. To add or remove methods whilst iterating, you must iterate backwards", methodsN, #methods))
			local Method = methods[index]
			index = index + step
			if Name == nil or Method.Name == Name then
				return Method, index - step
			end
		end
		return nil
	end
end

function SPTParser.Class:GetMethod(Backwards, Name)
	return self:GetMethods(Backwards, Name)()
end

function SPTParser.Class:AddMethod(Name, Parameters, Option)
	assert(type(Name) == "string", "Name (Arg #1) must be a string.")
	assert(type(Parameters) == "table", "Parameters (Arg #2) must be a table.")
	assert(Option == nil or type(Option) == "string", "Option (Arg #3) must be a string.")
	
	local knownClass = KnownClasses[self.Type]
	assert(knownClass, string_format("Unknown class type: %s", self.Type))
	local knownMethod = knownClass[Name]
	assert(knownMethod, string_format("Unknown method: %s->%s", self.Type, Name))
	local numParameters = #knownMethod
	assert(numParameters == #Parameters, string_format("Method \"%s->%s\" expects %i parameters. Got %i.", self.Type, Name, numParameters, #Parameters))
	
	for i=1,numParameters do
		local paramType = knownMethod[i][2]
		local parameter = Parameters[i]
		assert(type(parameter) == TypeMap[paramType], string_format("Method \"%s->%s\" expects parameter %i (%s) to be: %s. Got %s", self.Type, Name, i, knownMethod[i][1], TypeMap[paramType], type(parameter)))
	end
	
	local method = {
		Name = Name,
		Option = Option,
		Parameters = Parameters
	}
	local methodIndex = #self.Methods + 1
	self.Methods[methodIndex] = method
	return method, methodIndex
end

function SPTParser.Class:RemoveMethod(Index)
	assert(type(Index) == "number", "Arg #1 (Index) must be a number.")
	assert(Index > 0 and Index <= #self.Methods, "Arg #1 (Index) out of bounds.")
	table_remove(self.Methods, Index)
end

function SPTParser.Class:__tostring()
	assert(type(self.Type) == "string", "Class.Type must be a string.")
	assert(type(self.Name) == "string", "Class.Name must be a string.")
	local knownClass = KnownClasses[self.Type]
	assert(knownClass, string_format("Unknown class type: %s", self.Type))
	
	local data = {}
	local methods = self.Methods
	for i=1,#methods do
		local method = methods[i]
		assert(type(method.Name) == "string", "Method.Name must be a string.")
		assert(method.Option == nil or type(method.Option) == "string", "Method.Option must be a string.")
		assert(type(method.Parameters) == "table", "Method.Parameters must be a table.")
		
		local knownMethod = knownClass[method.Name]
		assert(knownMethod, string_format("Unknown method: %s->%s", self.Type, method.Name))
		local numParameters = #knownMethod
		assert(numParameters == #method.Parameters, string_format("Method \"%s->%s\" expects %i parameters. %i parameters found.", self.Type, method.Name, numParameters, #method.Parameters))
		
		local parameterFormat = {"    %s ( "}
		local parameterFormatN = 1
		for j=1,numParameters do
			local paramType = knownMethod[j][2]
			local parameter = method.Parameters[j]
			assert(type(parameter) == TypeMap[paramType], string_format("Method \"%s->%s\" expects parameter %i (%s) to be: %s. Got %s", self.Type, method.Name, j, knownMethod[j][1], TypeMap[paramType], type(parameter)))
			
			parameterFormatN = parameterFormatN + 1
			parameterFormat[parameterFormatN] = TypeFormatMap[paramType] .. " "
		end
		parameterFormatN = parameterFormatN + 1
		parameterFormat[parameterFormatN] = ")"
		
		parameterFormat = table_concat(parameterFormat)
		local methodStr = string_format(parameterFormat, method.Name, table_unpack(method.Parameters))
		if method.Option then
			methodStr = string_format("%s option %s", methodStr, method.Option)
		end
		data[i] = methodStr
	end
	
	return string_format("create %s named %s\r\n{\r\n%s\r\n}\r\n", self.Type, self.Name, table_concat(data, "\r\n"))
end