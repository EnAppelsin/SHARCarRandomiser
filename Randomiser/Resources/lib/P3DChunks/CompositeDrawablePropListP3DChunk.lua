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

local function new(self)
	local Data = {
		Chunks = {},
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.CompositeDrawablePropListP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.Composite_Drawable_Prop_List)
P3D.CompositeDrawablePropListP3DChunk.new = new
function P3D.CompositeDrawablePropListP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	return chunk
end

function P3D.CompositeDrawablePropListP3DChunk:GetNumElements()
	local n = 0
	for i=1,#self.Chunks do
		if self.Chunks[i].Identifier == P3D.Identifiers.Composite_Drawable_Prop then
			n = n + 1
		end
	end
	return n
end

function P3D.CompositeDrawablePropListP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local headerLen = 12 + 4
	return string_pack("<IIII", self.Identifier, headerLen, headerLen + #chunkData, self:GetNumElements()) .. chunkData
end