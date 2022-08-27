--[[
CREDITS:
	Proddy#7272				- Converting to Lua
	luca$ Cardellini#5473	- P3D Chunk Structure
]]

assert(P3D and P3D.ChunkClasses, "This file must be called after P3D2.lua")

local string_format = string.format
local string_pack = string.pack
local string_rep = string.rep
local string_unpack = string.unpack

local table_concat = table.concat
local table_pack = table.pack
local table_unpack = table.unpack

local assert = assert
local type = type

local function new(self, Name, Version, Resolution, Platform, PagePath, ResourcePath, ScreenPath)
	assert(type(Name) == "string", "Arg #1 (Name) must be a string")
	assert(type(Version) == "number", "Arg #2 (Version) must be a number")
	assert(type(Resolution) == "table", "Arg #3 (Resolution) must be a table")
	assert(type(Platform) == "string", "Arg #4 (Platform) must be a string")
	assert(type(PagePath) == "string", "Arg #5 (PagePath) must be a string")
	assert(type(ResourcePath) == "string", "Arg #6 (ResourcePath) must be a string")
	assert(type(ScreenPath) == "string", "Arg #7 (ScreenPath) must be a string")
	
	local Data = {
		Chunks = {},
		Name = Name,
		Version = Version,
		Resolution = Resolution,
		Platform = Platform,
		PagePath = PagePath,
		ResourcePath = ResourcePath,
		ScreenPath = ScreenPath
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.FrontendProjectP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Frontend_Project)
P3D.FrontendProjectP3DChunk.new = new
function P3D.FrontendProjectP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	chunk.Resolution = {}
	chunk.Name, chunk.Version, chunk.Resolution.X, chunk.Resolution.Y, chunk.Platform, chunk.PagePath, chunk.ResourcePath, chunk.ScreenPath = string_unpack("<s1IIIs1s1s1s1", chunk.ValueStr)
	chunk.Name = P3D.CleanP3DString(chunk.Name)
	chunk.Platform = P3D.CleanP3DString(chunk.Platform)
	chunk.PagePath = P3D.CleanP3DString(chunk.PagePath)
	chunk.ResourcePath = P3D.CleanP3DString(chunk.ResourcePath)
	chunk.ScreenPath = P3D.CleanP3DString(chunk.ScreenPath)
	
	return chunk
end

function P3D.FrontendProjectP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local Name = P3D.MakeP3DString(self.Name)
	local Platform = P3D.MakeP3DString(self.Platform)
	local PagePath = P3D.MakeP3DString(self.PagePath)
	local ResourcePath = P3D.MakeP3DString(self.ResourcePath)
	local ScreenPath = P3D.MakeP3DString(self.ScreenPath)
	
	local headerLen = 12 + #Name + 1 + 4 + 4 + 4 + #Platform + 1 + #PagePath + 1 + #ResourcePath + 1 + #ScreenPath + 1
	return string_pack("<IIIs1IIIs1s1s1s1", self.Identifier, headerLen, headerLen + #chunkData, Name, self.Version, self.Resolution.X, self.Resolution.Y, Platform, PagePath, ResourcePath, ScreenPath) .. chunkData
end