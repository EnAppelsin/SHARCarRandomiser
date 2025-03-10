local assert = assert
local type = type

local string_byte = string.byte
local string_find = string.find
local string_pack = string.pack
local string_rep = string.rep
local string_sub = string.sub
local string_unpack = string.unpack

RCF = {}
local RadCoreSignature = "RADCORE CEMENT LIBRARY" .. string.rep("\0", 10)
local ATGCoreSignature = "ATG CORE CEMENT LIBRARY" .. string.rep("\0", 9) -- Unused by SHAR, unsupported

local SupportedMajorVersion = 1
local SupportedMinorVersion = 2

local function radMakeCaseInsensitiveKey32(pToken, keyValue)
	keyValue = keyValue or 0
	
	local chars = {string_byte(pToken, 1, #pToken)}
	local c
	for i=1,#pToken do
		local c = chars[i]
		if c < 97 then
			c = c + 32
		end
		keyValue = ((keyValue << 5) - keyValue + c) & 0xFFFFFFFF
	end
	
	return keyValue
end

local function NullTerminate(str)
	if str == nil then return nil end
	local strLen = #str
	if strLen == 0 then return str end
	local null = string_find(str, "\0", 1, true)
	if null == nil then return str end
	return string_sub(str, 1, null-1)
end

RCF.RCFFile = setmetatable({}, {
	__call = function(self, Path)
		if Path == nil then
			local Data = {
				BigEndian = 0,
				Alignment = 2048,
				PadNetSize = 0,
				HashedFileEntriesPointer = 0,
				HashedFileEntriesPointer = 0,
				Files = {}
			}
			
			self.__index = self
			return setmetatable(Data, self)
		end
		assert(type(Path) == "string", "Arg #1 (Path) must be a string.")
		assert(Exists(Path, true, false), "Arg #1 (Path) must be a valid filepath.")
		
		local contents = ReadFile(Path)
		
		local Data = {}
		
		local signature, pos = string_unpack("<c32", contents)
		assert(signature == RadCoreSignature, "Unknown signature: " .. signature)
		
		Data.VersionMajor, Data.VersionMinor, Data.BigEndian, Data.Valid, pos = string_unpack("<BBBB", contents, pos)
		assert(Data.VersionMajor == SupportedMajorVersion, "Unsupported major version: " .. Data.VersionMajor)
		assert(Data.VersionMinor == SupportedMinorVersion, "Unsupported minor version: " .. Data.VersionMajor)
		assert(Data.Valid ~= 0, "File marked as invalid.")
		local endian = Data.BigEndian ~= 0 and ">" or "<"
		
		local headerStartPos
		Data.Alignment, Data.PadNetSize, headerStartPos, pos = string_unpack(endian .. "III", contents, pos)
		
		local numFiles, detailedFileInfoStartPos, firstFileStartPos, hashedFileEntriesPointer, pos = string_unpack(endian .. "III<I", contents, headerStartPos + 1)
		Data.HashedFileEntriesPointer = hashedFileEntriesPointer
		
		local files = {}
		local fileHashMap = {}
		Data.Files = files
		
		for i=1,numFiles do
			local file = {}
			files[i] = file
			file.Hash, file.Position, file.Size, pos = string_unpack(endian .. "III", contents, pos)
			fileHashMap[file.Hash] = i
		end
		
		local numEntries, nameEntriesPointer, pos = string_unpack(endian .. "I<I", contents, detailedFileInfoStartPos + 1)
		assert(numFiles == numEntries, "Detail file info count differs from file count.")
		Data.NameEntriesPointer = nameEntriesPointer
		
		local name, timestamp
		for i=1,numFiles do
			name, timestamp, pos = string_unpack(endian .. "s4I", contents, pos)
			name = NullTerminate(name)
			
			local file = files[fileHashMap[radMakeCaseInsensitiveKey32(name)]]
			file.Name = name
			file.Timestamp = timestamp
		end
		
		for i=1,numFiles do
			local file = files[i]
			
			file.Hash = nil
			file.Data = string_sub(contents, file.Position + 1, file.Position + file.Size)
		end
		
		self.__index = self
		return setmetatable(Data, self)
	end,
})

function RCF.RCFFile:__tostring()
	error("Writing RCF files not currently supported")
end