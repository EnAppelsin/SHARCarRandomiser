P3DChunk = {Raw, ChunkTypes = {}, Chunks = {}, ValueLen = 0, DataLen = 0}

function P3DChunk:__tostring()
	return self:Output()
end

function P3DChunk:new(Data)
	if Data == nil then
		Data = {}
		setmetatable(Data, self)
		self.__index = self
		return Data
	end
	Data.ChunkTypes = {}
	Data.Chunks = {}
	Data.ChunkType = Data.Raw:sub(1, 4)
	Data.ValueLen = GetP3DInt4(Data.Raw, 5)
	Data.DataLen = GetP3DInt4(Data.Raw, 9)
	Data.ValueStr = Data.Raw:sub(1, Data.ValueLen)
	local i
	for ChunkPos, ChunkLen, ChunkID in FindSubchunks(Data.Raw, nil) do
		i = #Data.ChunkTypes + 1
		Data.ChunkTypes[i] = Data.Raw:sub(ChunkPos, ChunkPos + 3)
		Data.Chunks[i] = Data.Raw:sub(ChunkPos, ChunkPos + ChunkLen - 1)
	end
	self.__index = self
	return setmetatable(Data, self)
end

function P3DChunk:newChildClass(type)
	self.__index = self
	return setmetatable({type = type or "none", parentClass = self}, self)
end

function P3DChunk:GetChunkCount()
	return #self.ChunkTypes
end

function P3DChunk:RemoveChunkAtIndex(idx)
	local ChunkLen = self.Chunks[idx]:len()
	table.remove(self.ChunkTypes, idx)
	table.remove(self.Chunks, idx)
	self.ValueStr = AddP3DInt4(self.ValueStr, 9, ChunkLen * -1)
end

function P3DChunk:GetChunkAtIndex(idx)
	return self.Chunks[idx]
end

function P3DChunk:SetChunkAtIndex(idx, ChunkData)
	if #self.ChunkTypes < idx then return end
	local ChunkLen = ChunkData:len()
	if ChunkLen < 13 then return end
	local OldLen = self.Chunks[idx]:len()
	self.ChunkTypes[idx] = ChunkData:sub(1, 4)
	self.Chunks[idx] = ChunkData
	self.ValueStr = AddP3DInt4(self.ValueStr, 9, ChunkLen - OldLen)
end

function P3DChunk:AddChunk(ChunkData)
	local ChunkLen = ChunkData:len()
	if ChunkLen < 12 then return end
	local ChunkID = ChunkData:sub(1, 4)
	self.ChunkTypes[#self.ChunkTypes + 1] = ChunkID
	self.Chunks[#self.Chunks] = ChunkData
	self.ValueStr = AddP3DInt4(self.ValueStr, 9, ChunkLen)
end

function P3DChunk:Output()
	return self.ValueStr .. table.concat(self.Chunks)
end

function P3DChunk:GetName()
	if self.ValueLen < 13 then return nil end
	local name = self.Name or GetP3DString(self.ValueStr, 13)
	self.Name = name
	return name
end

function P3DChunk:SetName(NewName)
	if self.ValueLen < 13 then return end
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, 13, NewName)
	newVal = AddP3DInt4(newVal, 9, Delta)
	self.ValueStr = newVal
	self.Name = NewName
end

function P3DChunk:GetChunkIndexes(ChunkID)
	local i = #self.ChunkTypes
	return function()
		if ChunkID:len() ~= 4 then return nil end
		while i > 0 do
			local ChunkType = self.ChunkTypes[i]
			i = i - 1
			if ChunkID == nil or ChunkType == ChunkID then
				return i + 1, ChunkType
			end
		end
		return nil
	end
end

--Shader chunk
ShaderP3DChunk = P3DChunk:newChildClass("Shader")
function ShaderP3DChunk:new(Data)
	local o = ShaderP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	o.Name = GetP3DString(o.ValueStr, idx)
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Version = idx
	o.Version = GetP3DInt4(o.ValueStr, idx)
	idx = idx + 4
	o.ValueIndexes.PDDIShader = idx
	o.PDDIShader = GetP3DString(o.ValueStr, idx)
	idx = idx + o.PDDIShader:len() + 1
	o.ValueIndexes.HasTranslucency = idx
	o.HasTranslucency = GetP3DInt4(o.ValueStr, idx)
	idx = idx + 4
	o.ValueIndexes.VertexNeeds = idx
	o.VertexNeeds = GetP3DInt4(o.ValueStr, idx)
	idx = idx + 4
	--Something something vertex mask
	return o
end

function ShaderP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	newVal = AddP3DInt4(newVal, 9, Delta)
	self.ValueStr = newVal
	self.Name = NewName
end

function ShaderP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DIn4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function ShaderP3DChunk:SetPDDIShader(NewPDDIShader)
	local idx = self.ValueIndexes.PDDIShader
	NewPDDIShader = MakeP3DString(NewPDDIShader)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewPDDIShader)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	newVal = AddP3DInt4(newVal, 9, Delta)
	self.ValueStr = newVal
	self.PDDIShader = NewPDDIShader
end

function ShaderP3DChunk:SetHasTranslucency(NewHasTranslucency)
	local idx = self.ValueIndexes.HasTranslucency
	self.ValueStr = SetP3DIn4(self.ValueStr, idx, NewHasTranslucency)
	self.HasTranslucency = NewHasTranslucency
end

function ShaderP3DChunk:SetVertexNeeds(NewVertexNeeds)
	local idx = self.ValueIndexes.VertexNeeds
	self.ValueStr = SetP3DIn4(self.ValueStr, idx, NewVertexNeeds)
	self.VertexNeeds = NewVertexNeeds
end

function ShaderP3DChunk:SetIntParameter(Name, Value)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(SHADER_INTEGER_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = SetP3DInt4(ChunkData, 17, Value)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function ShaderP3DChunk:SetTextureParameter(Name, Value)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	Value = MakeP3DString(Value)
	for idx in self:GetChunkIndexes(SHADER_TEXTURE_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			local newVal, Delta = SetP3DString(ChunkData, 17, Value)
			newVal = AddP3DInt4(newVal, 5, Delta)
			newVal = AddP3DInt4(newVal, 9, Delta)
			self:SetChunkAtIndex(idx, newVal)
			return
		end
	end
end

--TODO: Float and Colour parameters