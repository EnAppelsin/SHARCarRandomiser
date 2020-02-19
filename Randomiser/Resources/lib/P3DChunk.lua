local pack = string.pack
local unpack = string.unpack

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
	Data.ChunkType, Data.ValueLen, Data.DataLen = UnpackChunkHeader(Data.Raw)
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
	self.DataLen = self.DataLen - ChunkLen
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
	self.DataLen = self.DataLen + ChunkLen - OldLen
end

function P3DChunk:AddChunk(ChunkData)
	local ChunkLen = ChunkData:len()
	if ChunkLen < 12 then return end
	local ChunkID = ChunkData:sub(1, 4)
	self.ChunkTypes[#self.ChunkTypes + 1] = ChunkID
	self.Chunks[#self.Chunks] = ChunkData
	self.DataLen = self.DataLen + ChunkLen
end

function P3DChunk:Output()
	local valueStr = ""
	if self.ValueStr:len() > 12 then valueStr = self.ValueStr:sub(13) end
	return pack("<c4ii", self.ChunkType, self.ValueLen, self.DataLen) .. valueStr .. table.concat(self.Chunks)
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
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function P3DChunk:GetChunkIndexes(ChunkID)
	local i = #self.ChunkTypes
	return function()
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
	o.Name, o.Version, o.PDDIShader, o.HasTranslucency, o.VertexNeeds, o.VertexMask, o.NumParams = unpack("<s1is1iiii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.PDDIShader = idx
	idx = idx + o.PDDIShader:len() + 1
	o.ValueIndexes.HasTranslucency = idx
	idx = idx + 4
	o.ValueIndexes.VertexNeeds = idx
	idx = idx + 4
	o.ValueIndexes.VertexMask = idx
	idx = idx + 4
	o.ValueIndexes.NumParams = idx
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
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function ShaderP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
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
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.PDDIShader = NewPDDIShader
end

function ShaderP3DChunk:SetHasTranslucency(NewHasTranslucency)
	local idx = self.ValueIndexes.HasTranslucency
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewHasTranslucency)
	self.HasTranslucency = NewHasTranslucency
end

function ShaderP3DChunk:SetVertexNeeds(NewVertexNeeds)
	local idx = self.ValueIndexes.VertexNeeds
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVertexNeeds)
	self.VertexNeeds = NewVertexNeeds
end

function ShaderP3DChunk:SetVertexMask(NewVertexMask)
	local idx = self.ValueIndexes.VertexMask
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVertexMask)
	self.VertexMask = NewVertexMask
end

function ShaderP3DChunk:SetNumParams(NewNumParams)
	local idx = self.ValueIndexes.NumParams
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumParams)
	self.NumParams = NewNumParams
end

function ShaderP3DChunk:SetIntParameter(Name, Value)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(INTEGER_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = SetP3DInt4(ChunkData, 17, Value)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function ShaderP3DChunk:GetIntParameter(Name)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(INTEGER_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return GetP3DInt4(ChunkData, 17)
		end
	end
	return nil
end

function ShaderP3DChunk:SetTextureParameter(Name, Value)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	Value = MakeP3DString(Value)
	for idx in self:GetChunkIndexes(TEXTURE_PARAMETER_CHUNK) do
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

function ShaderP3DChunk:GetTextureParameter(Name)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	Value = MakeP3DString(Value)
	for idx in self:GetChunkIndexes(TEXTURE_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return GetP3DString(ChunkData, 17)
		end
	end
	return nil
end

function ShaderP3DChunk:SetColourParameter(Name, A, R, G, B)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(COLOUR_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = ChunkData:sub(1, 16) .. ARGBToString4(A, R, G, B)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function ShaderP3DChunk:GetColourParameter(Name)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(COLOUR_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return GetP3DARGB(ChunkData, 17)
		end
	end
	return nil
end

function ShaderP3DChunk:SetFloatParameter(Name, Value)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(FLOAT_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			ChunkData = SetP3DFloat(ChunkData, 17, Value)
			self:SetChunkAtIndex(idx, ChunkData)
			return
		end
	end
end

function ShaderP3DChunk:GetFloatParameter(Name)
	if Name:len() > 4 then return end
	Name = MakeP3DString(Name)
	for idx in self:GetChunkIndexes(FLOAT_PARAMETER_CHUNK) do
		local ChunkData = self:GetChunkAtIndex(idx)
		if ChunkData:sub(13, 16) == Name then
			return GetP3DFloat(ChunkData, 17)
		end
	end
	return nil
end

--Static entity chunk
StaticPhysP3DChunk = P3DChunk:newChildClass("Static Phys")
function StaticPhysP3DChunk:new(Data)
	local o = StaticPhysP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.Unknown, o.RenderOrder = unpack("<s1ii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Unknown = idx
	idx = idx + 4
	o.ValueIndexes.RenderOrder = idx
	return o
end

function StaticPhysP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function StaticPhysP3DChunk:SetUnknown(NewUnknown)
	local idx = self.ValueIndexes.Unknown
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewUnknown)
	self.Unknown = NewUnknown
end

function StaticPhysP3DChunk:SetRenderOrder(NewRenderOrder)
	local idx = self.ValueIndexes.RenderOrder
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewRenderOrder)
	self.RenderOrder = NewRenderOrder
end

--Inst stat phys chunk
InstStatPhysP3DChunk = StaticPhysP3DChunk:newChildClass("Inst Stat Phys")

--Inst stat entity chunk
InstStatEntityP3DChunk = StaticPhysP3DChunk:newChildClass("Inst Stat Entity")

--Inst stat phys chunk
DynaPhysP3DChunk = StaticPhysP3DChunk:newChildClass("Dyna Phys")

--Anim dyna phys chunk
AnimDynaPhysP3DChunk = StaticPhysP3DChunk:newChildClass("Anim Dyna Phys")

--Anim obj warpper chunk
AnimObjWrapperP3DChunk = P3DChunk:newChildClass("Anim Obj Wrapper")

--Breakable object chunk
BreakableObjectP3DChunk = P3DChunk:newChildClass("Breakable Object")
function BreakableObjectP3DChunk:new(Data)
	local o = BreakableObjectP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Index, o.Count = unpack("<ii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Index = idx
	idx = idx + 4
	o.ValueIndexes.Count = idx
	return o
end

function BreakableObjectP3DChunk:SetIndex(NewIndex)
	local idx = self.ValueIndexes.Index
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewIndex)
	self.Index = NewIndex
end

function BreakableObjectP3DChunk:SetCount(NewCount)
	local idx = self.ValueIndexes.Count
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewCount)
	self.Count = NewCount
end

--World sphere chunk
WorldSphereP3DChunk = P3DChunk:newChildClass("World Sphere")
function WorldSphereP3DChunk:new(Data)
	local o = WorldSphereP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.Unknown, o.NumMeshes, o.NumBillboardQuadGroups = unpack("<s1iii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Unknown = idx
	idx = idx + 4
	o.ValueIndexes.NumMeshes = idx
	idx = idx + 4
	o.ValueIndexes.NumBillboardQuadGroups = idx
	return o
end

function WorldSphereP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function WorldSphereP3DChunk:SetUnknown(NewUnknown)
	local idx = self.ValueIndexes.Unknown
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewUnknown)
	self.Unknown = NewUnknown
end

function WorldSphereP3DChunk:SetNumMeshes(NewNumMeshes)
	local idx = self.ValueIndexes.NumMeshes
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumMeshes)
	self.NumMeshes = NewNumMeshes
end

function WorldSphereP3DChunk:SetNumBillboardQuadGroups(NewNumBillboardQuadGroups)
	local idx = self.ValueIndexes.NumBillboardQuadGroups
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumBillboardQuadGroups)
	self.NumBillboardQuadGroups = NewNumBillboardQuadGroups
end

function WorldSphereP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	WorldSphereP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == OLD_BILLBOARD_QUAD_GROUP_CHUNK then
		self:SetNumBillboardQuadGroups(self.NumBillboardQuadGroups - 1)
	end
end

--Mesh chunk
MeshP3DChunk = P3DChunk:newChildClass("Mesh")
function MeshP3DChunk:new(Data)
	local o = MeshP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.Version, o.NumPrimitiveGroups = unpack("<s1ii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.NumPrimitiveGroups = idx
	return o
end

function MeshP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function MeshP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function MeshP3DChunk:SetNumPrimitiveGroups(NewNumPrimitiveGroups)
	local idx = self.ValueIndexes.NumPrimitiveGroups
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumPrimitiveGroups)
	self.NumPrimitiveGroups = NewNumPrimitiveGroups
end

function MeshP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	MeshP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == OLD_PRIMITIVE_GROUP_CHUNK then
		self:SetNumPrimitiveGroups(self.NumPrimitiveGroups - 1)
	end
end

--Old primitive group chunk
OldPrimitiveGroupP3DChunk = P3DChunk:newChildClass("Old Primitive Group")
function OldPrimitiveGroupP3DChunk:new(Data)
	local o = OldPrimitiveGroupP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Version, o.ShaderName, o.PrimitiveType, o.VertexType, o.NumVertices, o.NumIndices, o.NumMatrices = unpack("<is1iiiii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.ShaderName = idx
	idx = idx + o.ShaderName:len() + 1
	o.ValueIndexes.PrimitiveType = idx
	idx = idx + 4
	o.ValueIndexes.VertexType = idx
	idx = idx + 4
	o.ValueIndexes.NumVertices = idx
	idx = idx + 4
	o.ValueIndexes.NumIndices = idx
	idx = idx + 4
	o.ValueIndexes.NumMatrices = idx
	idx = idx + 4
	return o
end

function OldPrimitiveGroupP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function OldPrimitiveGroupP3DChunk:SetShaderName(NewShaderName)
	local idx = self.ValueIndexes.ShaderName
	NewShaderName = MakeP3DString(NewShaderName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewShaderName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.ShaderName = NewShaderName
end

function OldPrimitiveGroupP3DChunk:SetPrimitiveType(NewPrimitiveType)
	local idx = self.ValueIndexes.PrimitiveType
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewPrimitiveType)
	self.PrimitiveType = NewPrimitiveType
end

function OldPrimitiveGroupP3DChunk:SetVertexType(NewVertexType)
	local idx = self.ValueIndexes.VertexType
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVertexType)
	self.VertexType = NewVertexType
end

function OldPrimitiveGroupP3DChunk:SetNumVertices(NewNumVertices)
	local idx = self.ValueIndexes.NumVertices
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumVertices)
	self.NumVertices = NewNumVertices
end

function OldPrimitiveGroupP3DChunk:SetNumIndices(NewNumIndices)
	local idx = self.ValueIndexes.NumIndices
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumIndices)
	self.NumIndices = NewNumIndices
end

function OldPrimitiveGroupP3DChunk:SetVersion(NewNumMatrices)
	local idx = self.ValueIndexes.NumMatrices
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumMatrices)
	self.NumMatrices = NewNumMatrices
end

--Colour list chunk
ColourListP3DChunk = P3DChunk:newChildClass("Colour List")
function ColourListP3DChunk:new(Data)
	local o = ColourListP3DChunk.parentClass.new(self, Data)
	local idx = 13
	local NumColours = GetP3DInt4(o.ValueStr, 13)
	idx = idx + 4
	o.Colours = {}
	for i=0,NumColours - 1 do
		o.Colours[#o.Colours + 1] = unpack("c4", o.ValueStr, idx + i * 4)
	end
	return o
end

function ColourListP3DChunk:Output()
	local ColoursN = #self.Colours
	local len = 16 + ColoursN * 4
	return pack("<c4iii", self.ChunkType, len, len, ColoursN) .. table.concat(self.Colours)
end

--Position list chunk
PositionListP3DChunk = P3DChunk:newChildClass("Position List")
function PositionListP3DChunk:new(Data)
	local o = PositionListP3DChunk.parentClass.new(self, Data)
	local idx = 13
	local NumPositions = GetP3DInt4(o.ValueStr, 13)
	idx = idx + 4
	o.Positions = {}
	for i=0,NumPositions - 1 do
		local pos = {X=0,Y=0,Z=0}
		pos.X, pos.Y, pos.Z = unpack("<fff", o.ValueStr, idx + i * 12)
		o.Positions[#o.Positions + 1] = pos
	end
	return o
end

function PositionListP3DChunk:Output()
	local PositionsN = #self.Positions
	local len = 16 + PositionsN * 4
	local positions = {}
	for i=1,PositionsN do
		local pos = self.Positions[i]
		positions[#positions + 1] = Vector3ToString12(pos.X, pos.Y, pos.Z)
	end
	return pack("<c4iii", self.ChunkType, len, len, PositionsN) .. table.concat(positions)
end

--Lens flare chunk
LensFlareP3DChunk = P3DChunk:newChildClass("Lens Flare")
function LensFlareP3DChunk:new(Data)
	local o = LensFlareP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.Unknown, o.NumBillboardQuadGroups = unpack("<s1ii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Unknown = idx
	idx = idx + 4
	o.ValueIndexes.NumBillboardQuadGroups = idx
	return o
end

function LensFlareP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function LensFlareP3DChunk:SetUnknown(NewUnknown)
	local idx = self.ValueIndexes.Unknown
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewUnknown)
	self.Unknown = NewUnknown
end

function LensFlareP3DChunk:SetNumBillboardQuadGroups(NewNumBillboardQuadGroups)
	local idx = self.ValueIndexes.NumBillboardQuadGroups
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumBillboardQuadGroups)
	self.NumBillboardQuadGroups = NewNumBillboardQuadGroups
end

function LensFlareP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	LensFlareP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == OLD_BILLBOARD_QUAD_GROUP_CHUNK then
		self:SetNumBillboardQuadGroups(self.NumBillboardQuadGroups - 1)
	end
end

--Old billboard quad group chunk
OldBillboardQuadGroupP3DChunk = P3DChunk:newChildClass("Old Billboard Quad Group")
function OldBillboardQuadGroupP3DChunk:new(Data)
	local o = OldBillboardQuadGroupP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Version, o.Name, o.Shader, o.ZTest, o.ZWrite, o.Fog, o.NumQuads = unpack("<is1s1iiii", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Shader = idx
	idx = idx + o.Shader:len() + 1
	o.ValueIndexes.ZTest = idx
	idx = idx + 4
	o.ValueIndexes.ZWrite = idx
	idx = idx + 4
	o.ValueIndexes.Fog = idx
	idx = idx + 4
	o.ValueIndexes.NumQuads = idx
	return o
end

function OldBillboardQuadGroupP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function OldBillboardQuadGroupP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function OldBillboardQuadGroupP3DChunk:SetShader(NewShader)
	local idx = self.ValueIndexes.Shader
	NewShader = MakeP3DString(NewShader)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewShader)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Shader = NewShader
end

function OldBillboardQuadGroupP3DChunk:SetZTest(NewZTest)
	local idx = self.ValueIndexes.ZTest
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewZTest)
	self.ZTest = NewZTest
end

function OldBillboardQuadGroupP3DChunk:SetZWrite(NewZWrite)
	local idx = self.ValueIndexes.ZWrite
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewZWrite)
	self.ZWrite = NewZWrite
end

function OldBillboardQuadGroupP3DChunk:SetFog(NewFog)
	local idx = self.ValueIndexes.Fog
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewFog)
	self.Fog = NewFog
end

function OldBillboardQuadGroupP3DChunk:SetNumQuads(NewNumQuads)
	local idx = self.ValueIndexes.NumQuads
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumQuads)
	self.NumQuads = NewNumQuads
end

function OldBillboardQuadGroupP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	OldBillboardQuadGroupP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == OLD_BILLBOARD_QUAD_CHUNK then
		self:SetNumQuads(self.NumQuads - 1)
	end
end

--Old billboard quad chunk
OldBillboardQuadP3DChunk = P3DChunk:newChildClass("Old Billboard Quad")
function OldBillboardQuadP3DChunk:new(Data)
	local o = OldBillboardQuadP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Translation = {X=0,Y=0,Z=0}
	o.Colour = {A=0,R=0,G=0,B=0}
	o.UV1 = {X=0,Y=0}
	o.UV2 = {X=0,Y=0}
	o.UV3 = {X=0,Y=0}
	o.UV4 = {X=0,Y=0}
	o.UVOffset = {X=0,Y=0}
	o.Version, o.Name, o.BillboardMode, o.Translation.X, o.Translation.Y, o.Translation.Z, o.Colour.B, o.Colour.G, o.Colour.R, o.Colour.A, o.UV1.X, o.UV1.Y, o.UV2.X, o.UV2.Y, o.UV3.X, o.UV3.Y, o.UV4.X, o.UV4.Y, o.Width, o.Height, o.Distance, o.UVOffset.X, o.UVOffset.Y = unpack("<is1c4fffBBBBfffffffffffff", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.BillboardMode = idx
	idx = idx + 4
	o.ValueIndexes.Translation = idx
	idx = idx + 12
	o.ValueIndexes.Colour = idx
	idx = idx + 4
	o.ValueIndexes.UV1 = idx
	idx = idx + 8
	o.ValueIndexes.UV2 = idx
	idx = idx + 8
	o.ValueIndexes.UV3 = idx
	idx = idx + 8
	o.ValueIndexes.UV4 = idx
	idx = idx + 8
	o.ValueIndexes.Width = idx
	idx = idx + 4
	o.ValueIndexes.Height = idx
	idx = idx + 4
	o.ValueIndexes.Distance = idx
	idx = idx + 4
	o.ValueIndexes.UVOffset = idx
	return o
end

function OldBillboardQuadP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function OldBillboardQuadP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function OldBillboardQuadP3DChunk:SetBillboardMode(NewBillboardMode)
	if NewBillboardMode:len() > 4 then return end
	local idx = self.ValueIndexes.BillboardMode
	NewBillboardMode = MakeP3DString(NewBillboardMode)
	self.ValueStr = SetP3DFourCC(self.ValueStr, idx, NewBillboardMode)
	self.BillboardMode = NewBillboardMode
end

function OldBillboardQuadP3DChunk:SetTranslation(NewX, NewY, NewZ)
	local idx = self.ValueIndexes.Translation
	self.ValueStr = SetP3DVector3(self.ValueStr, idx, NewX, NewY, NewZ)
	self.Translation.X = NewX
	self.Translation.Y = NewY
	self.Translation.Z = NewZ
end

function OldBillboardQuadP3DChunk:SetColour(NewA, NewR, NewG, NewB)
	local idx = self.ValueIndexes.Colour
	self.ValueStr = SetP3DARGB(self.ValueStr, idx, NewA, NewR, NewG, NewB)
	self.Colour.A = NewA
	self.Colour.R = NewR
	self.Colour.G = NewG
	self.Colour.B = NewB
end

function OldBillboardQuadP3DChunk:SetUV1(NewX, NewY)
	local idx = self.ValueIndexes.UV1
	self.ValueStr = SetP3DVector2(self.ValueStr, idx, NewX, NewY)
	self.UV1.X = NewX
	self.UV1.Y = NewY
end

function OldBillboardQuadP3DChunk:SetUV2(NewX, NewY)
	local idx = self.ValueIndexes.UV2
	self.ValueStr = SetP3DVector2(self.ValueStr, idx, NewX, NewY)
	self.UV2.X = NewX
	self.UV2.Y = NewY
end

function OldBillboardQuadP3DChunk:SetUV3(NewX, NewY)
	local idx = self.ValueIndexes.UV3
	self.ValueStr = SetP3DVector2(self.ValueStr, idx, NewX, NewY)
	self.UV3.X = NewX
	self.UV3.Y = NewY
end

function OldBillboardQuadP3DChunk:SetUV4(NewX, NewY)
	local idx = self.ValueIndexes.UV4
	self.ValueStr = SetP3DVector2(self.ValueStr, idx, NewX, NewY)
	self.UV4.X = NewX
	self.UV4.Y = NewY
end

function OldBillboardQuadP3DChunk:SetWidth(NewWidth)
	local idx = self.ValueIndexes.Width
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewWidth)
	self.Width = NewWidth
end

function OldBillboardQuadP3DChunk:SetHeight(NewHeight)
	local idx = self.ValueIndexes.Height
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewHeight)
	self.Height = NewHeight
end

function OldBillboardQuadP3DChunk:SetDistance(NewDistance)
	local idx = self.ValueIndexes.Distance
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewDistance)
	self.Distance = NewDistance
end

function OldBillboardQuadP3DChunk:SetUVOffset(NewX, NewY)
	local idx = self.ValueIndexes.UVOffset
	self.ValueStr = SetP3DVector2(self.ValueStr, idx, NewX, NewY)
	self.UVOffset.X = NewX
	self.UVOffset.Y = NewY
end

--Light chunk
LightP3DChunk = P3DChunk:newChildClass("Light")
function LightP3DChunk:new(Data)
	local o = LightP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Colour = {A=0,R=0,G=0,B=0}
	o.Name, o.Version, o.Type, o.Colour.B, o.Colour.G, o.Colour.R, o.Colour.A, o.Constant, o.Linear, o.Squared, o.Enabled  = unpack("<s1iiBBBBfffi", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.Type = idx
	idx = idx + 4
	o.ValueIndexes.Colour = idx
	idx = idx + 4
	o.ValueIndexes.Constant = idx
	idx = idx + 4
	o.ValueIndexes.Linear = idx
	idx = idx + 4
	o.ValueIndexes.Squared = idx
	idx = idx + 4
	o.ValueIndexes.Enabled = idx
	return o
end

function LightP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function LightP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function LightP3DChunk:SetType(NewType)
	local idx = self.ValueIndexes.Type
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewType)
	self.Type = NewType
end

function LightP3DChunk:SetColour(NewA, NewR, NewG, NewB)
	local idx = self.ValueIndexes.Colour
	self.ValueStr = SetP3DARGB(self.ValueStr, idx, NewA, NewR, NewG, NewB)
	self.Colour.A = NewA
	self.Colour.R = NewR
	self.Colour.G = NewG
	self.Colour.B = NewB
end

function LightP3DChunk:SetConstant(NewConstant)
	local idx = self.ValueIndexes.Constant
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewConstant)
	self.Constant = NewConstant
end

function LightP3DChunk:SetLinear(NewLinear)
	local idx = self.ValueIndexes.Linear
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewLinear)
	self.Linear = NewLinear
end

function LightP3DChunk:SetSquared(NewSquared)
	local idx = self.ValueIndexes.Squared
	self.ValueStr = SetP3DFloat(self.ValueStr, idx, NewSquared)
	self.Squared = NewSquared
end

function LightP3DChunk:SetEnabled(NewEnabled)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewEnabled)
	self.Enabled = NewEnabled
end

--Skin chunk
SkinP3DChunk = P3DChunk:newChildClass("Skin")
function SkinP3DChunk:new(Data)
	local o = SkinP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.Version, o.SkeletonName, o.NumPrimitiveGroups = unpack("<s1is1i", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.Version = idx
	idx = idx + 4
	o.ValueIndexes.SkeletonName = idx
	idx = idx + o.SkeletonName:len() + 1
	o.ValueIndexes.NumPrimitiveGroups = idx
	return o
end

function SkinP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function SkinP3DChunk:SetVersion(NewVersion)
	local idx = self.ValueIndexes.Version
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewVersion)
	self.Version = NewVersion
end

function SkinP3DChunk:SetSkeletonName(NewSkeletonName)
	local idx = self.ValueIndexes.SkeletonName
	NewSkeletonName = MakeP3DString(NewSkeletonName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewSkeletonName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.SkeletonName = NewSkeletonName
end

function SkinP3DChunk:SetNumPrimitiveGroups(NewNumPrimitiveGroups)
	local idx = self.ValueIndexes.NumPrimitiveGroups
	self.ValueStr = SetP3DInt4(self.ValueStr, idx, NewNumPrimitiveGroups)
	self.NumPrimitiveGroups = NewNumPrimitiveGroups
end

function SkinP3DChunk:RemoveChunkAtIndex(idx)
	local ID = self.ChunkTypes[idx]
	SkinP3DChunk.parentClass.RemoveChunkAtIndex(self, idx)
	if ID == OLD_PRIMITIVE_GROUP_CHUNK then
		self:SetNumPrimitiveGroups(self.NumPrimitiveGroups - 1)
	end
end

--Composite drawable chunk
CompositeDrawableP3DChunk = P3DChunk:newChildClass("Composite Drawable")
function CompositeDrawableP3DChunk:new(Data)
	local o = CompositeDrawableP3DChunk.parentClass.new(self, Data)
	local idx = 13
	o.Name, o.SkeletonName = unpack("<s1s1", o.ValueStr, idx)
	o.ValueIndexes = {}
	o.ValueIndexes.Name = idx
	idx = idx + o.Name:len() + 1
	o.ValueIndexes.SkeletonName = idx
	return o
end

function CompositeDrawableP3DChunk:SetName(NewName)
	local idx = self.ValueIndexes.Name
	NewName = MakeP3DString(NewName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.Name = NewName
end

function CompositeDrawableP3DChunk:SetSkeletonName(NewSkeletonName)
	local idx = self.ValueIndexes.SkeletonName
	NewSkeletonName = MakeP3DString(NewSkeletonName)
	local newVal, Delta = SetP3DString(self.ValueStr, idx, NewSkeletonName)
	for k,v in pairs(self.ValueIndexes) do
		if v > idx then
			self.ValueIndexes[k] = v + Delta
		end
	end
	self.ValueLen = self.ValueLen + Delta
	self.DataLen = self.DataLen + Delta
	self.ValueStr = newVal
	self.SkeletonName = NewSkeletonName
end