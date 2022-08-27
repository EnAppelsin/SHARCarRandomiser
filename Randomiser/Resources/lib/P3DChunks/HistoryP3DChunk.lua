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

local function new(self, History)
	assert(type(History) == "table", "Arg #1 (History) must be a table")
	
	local Data = {
		Chunks = {},
		History = History
	}
	
	self.__index = self
	return setmetatable(Data, self)
end

P3D.HistoryP3DChunk = P3D.P3DChunk:newChildClass(P3D.Identifiers.History)
P3D.HistoryP3DChunk.new = new
function P3D.HistoryP3DChunk:parse(Contents, Pos, DataLength)
	local chunk = self.parentClass.parse(self, Contents, Pos, DataLength, self.Identifier)
	
	local num, pos = string_unpack("<H", chunk.ValueStr)
	chunk.History = table_pack(string_unpack("<" .. string_rep("s1", num), chunk.ValueStr, pos))
	chunk.History[num + 1] = nil
	for i=1,num do
		chunk.History[i] = P3D.CleanP3DString(chunk.History[i])
	end
	
	return chunk
end

function P3D.HistoryP3DChunk:__tostring()
	local chunks = {}
	for i=1,#self.Chunks do
		chunks[i] = tostring(self.Chunks[i])
	end
	local chunkData = table_concat(chunks)
	
	local history = {}
	local historyN = #self.History
	for i=1,historyN do
		history[i] = string_pack("<s1", P3D.MakeP3DString(self.History[i]))
	end
	local historyData = table_concat(history)
	
	local headerLen = 12 + 2 + #historyData
	return string_pack("<IIIH", self.Identifier, headerLen, headerLen + #chunkData, historyN) .. historyData .. chunkData
end