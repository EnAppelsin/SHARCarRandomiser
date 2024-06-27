--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

local P3D = P3D
assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")
assert(P3D.FrontendLanguageP3DChunk == nil, "Chunk type already loaded.")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_reverse = string.reverse
local string_unpack = string.unpack

local table_concat = table.concat
local table_move = table.move
local table_unpack = table.unpack

local utf8_char = utf8.char
local utf8_codes = utf8.codes

local assert = assert
local tostring = tostring
local type = type

local function new(self, Name, Language, Modulo, Entries)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Language) == "string" and #Language == 1, "Arg #2 (Language) must be a string with a length of 1")
	assert(type(Modulo) == "number", "Arg #3 (Modulo) must be a number")
	assert(type(Entries) == "table", "Arg #4 (Entries) must be a table")
	
	local Hashes = {}
	local Offsets = {}
	local Buffer = {}
	local BufferN = 0
	
	for i=1,#Entries do
		local entry = Entries[i]
		local name = entry.Name
		assert(type(name) == "string", "Entry.Name must be a string")
		local value = entry.Value
		assert(type(value) == "string", "Entry.Value must be a string")
		
		Offsets[i] = BufferN
		
		local hash = self:GetNameHash(name, Modulo, "<")
		Hashes[i] = hash
		
		local ucs2 = {}
		local n = 1
		for p, c in utf8_codes(value) do
			if c == 0 then break end
			ucs2[n] = c
			n = n + 1
		end
		ucs2[n] = 0
		
		table_move(ucs2, 1, n, #Buffer + 1, Buffer)
		
		BufferN = BufferN + n*2
	end
	
	local Data = {
		Endian = "<",
		Chunks = {},
		Name = Name,
		Language = Language,
		Modulo = Modulo,
		Hashes = Hashes,
		Offsets = Offsets,
		Buffer = Buffer
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendLanguageP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Language)
P3D.FrontendLanguageP3DChunk.new = new
function P3D.FrontendLanguageP3DChunk:parse(Endian, Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Endian, Contents, Pos, DataLength, self.Identifier)
	
	local numEntries, bufferSize, pos
	chunk.Name, chunk.Language, numEntries, chunk.Modulo, bufferSize, pos = string_unpack(Endian .. "s1c1III", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	
	chunk.Hashes = {string_unpack(Endian .. string_rep("I", numEntries), chunk.ValueStr, pos)}
	pos = chunk.Hashes[numEntries + 1]
	chunk.Hashes[numEntries + 1] = nil
	
	chunk.Offsets = {string_unpack(Endian .. string_rep("I", numEntries), chunk.ValueStr, pos)}
	pos = chunk.Offsets[numEntries + 1]
	chunk.Offsets[numEntries + 1] = nil
	
	chunk.Buffer = {string_unpack(Endian ..string_rep("H", (#chunk.ValueStr-pos+1) / 2), chunk.ValueStr, pos)}
	chunk.Buffer[#chunk.Buffer] = nil
	
	return chunk
end

function P3D.FrontendLanguageP3DChunk:GetNameHash(Name, Modulo, Endian)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	Modulo = Modulo or self.Modulo
	assert(type(Modulo) == "number", "Arg #2 (Modulo) must be a number")
	Endian = Endian or self.Endian
	assert(type(Endian) == "string" and (Endian == ">" or Endian == "<"), "Arg #3 (Endian) must be either \"<\" or \">\"")
	
	local Hash = 0
	local chars = {string_unpack(Endian .. string_rep("B", #Name), Name)}
	for i=1,#Name do
		local c = chars[i]
		Hash = (c + (Hash << 6)) % Modulo
	end
	return Hash
end

function P3D.FrontendLanguageP3DChunk:GetValueFromHash(Hash)
	assert(type(Hash) == "number", "Arg #1 (Hash) must be a number")
	
	local index = nil
	for i=1,#self.Hashes do
		if self.Hashes[i] == Hash then
			index = i
			break
		end
	end
	assert(index, "Failed to find entry with hash: " .. Hash)
	
	local out = {}
	local n = 0
	for i=self.Offsets[index]/2 + 1,#self.Buffer,1 do
		local s = self.Buffer[i]
		if s == 0 then break end
		n = n + 1
		out[n] = s
	end
	return utf8_char(table_unpack(out))
end

function P3D.FrontendLanguageP3DChunk:GetValueFromName(Name)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	
	local Hash = self:GetNameHash(Name)
	local success, result = pcall(P3D.FrontendLanguageP3DChunk.GetValueFromHash, self, Hash)
	if success then
		return result
	end
	error("Failed to get value with name: " .. Name .. "\n" .. result)
end

function P3D.FrontendLanguageP3DChunk:AddValue(Name, Value)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Value) == "string", "Arg #2 (Value) must be a string")
	
	local ucs2 = {}
	local n = 1
	for p,c in utf8_codes(Value) do
		if c == 0 then break end
		ucs2[n] = c
		n = n + 1
	end
	ucs2[n] = 0
	
	Value = string_pack(self.Endian .. string_rep("H", n), table_unpack(ucs2))
	self.Hashes[#self.Hashes + 1] = self:GetNameHash(Name)
	self.Offsets[#self.Offsets + 1] = #self.Buffer*2
	table_move(ucs2, 1, n, #self.Buffer + 1, self.Buffer)
end

function P3D.FrontendLanguageP3DChunk:SetValue(Name, Value)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Value) == "string", "Arg #2 (Value) must be a string")
	
	local index
	local hash = self:GetNameHash(Name)
	for i=1,#self.Hashes do
		if self.Hashes[i] == hash then
			index = i
			break
		end
	end
	if index == nil then
		return self:AddValue(Name, Value)
	end
	
	local offset = self.Offsets[index]/2
	
	local origEnd = 0
	for i=offset + 1,#self.Buffer,1 do
		local s = self.Buffer[i]
		if s == 0 then
			origEnd = i
			break
		end
	end
	
	local newBuffer = {}
	table_move(self.Buffer, 1, offset, 1, newBuffer)
	
	local ucs2 = {}
	local n = 1
	for p,c in utf8_codes(Value) do
		if c == 0 then break end
		ucs2[n] = c
		n = n + 1
	end
	ucs2[n] = 0
	table_move(ucs2, 1, n, #newBuffer + 1, newBuffer)
	local newEnd = #newBuffer
	
	table_move(self.Buffer, origEnd + 1, #self.Buffer, #newBuffer + 1, newBuffer)
	self.Buffer = newBuffer
	
	local diff = (newEnd-origEnd)*2
	for i=1,#self.Offsets do
		local offset2 = self.Offsets[i]/2
		if offset2 > offset then
			self.Offsets[i] = self.Offsets[i] + diff
		end
	end
end

function P3D.FrontendLanguageP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local entriesN = #self.Hashes
	local bufferN = #self.Buffer
	
	local values = {}
	for i=1,entriesN do
		values[i] = self.Hashes[i]
	end
	for i=1,entriesN do
		values[entriesN + i] = self.Offsets[i]
	end
	for i=1,bufferN do
		values[#values + 1] = self.Buffer[i]
	end
	
	local headerLen = 12 + #Name + 1 + 1 + 4 + 4 + 4 + entriesN * 4 + entriesN * 4 + bufferN * 2
	return string_pack(self.Endian .. "IIIs1c1III" .. string_rep("I", entriesN) .. string_rep("I", entriesN) .. string_rep("H", bufferN), self.Identifier, headerLen, headerLen + #chunkData, Name, self.Language, entriesN, self.Modulo, bufferN * 2, table_unpack(values)) .. chunkData
end