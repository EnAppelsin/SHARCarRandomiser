----------------------------------------------------
-- p3d.lua - Modify P3D Files in Lua
----------------------------------------------------

-- Some chunks as Lua Strings
P3D_HEADER = "P3D\255\012\000\000\000\000\000\000\000"

TEXTURE_CHUNK = "\000\144\001\000"
SHADER_CHUNK = "\000\016\001\000"
ANIMATION_CHUNK = "\000\016\018\000"
ANIMATION_GROUP_CHUNK = "\002\016\018\000"
SKIN_CHUNK = "\001\000\001\000"
SKELETON_CHUNK = "\000\069\000\000"
MESH_CHUNK = "\000\000\001\000"
MULTI_CONTROLLER_CHUNK = "\xA0\x48\x00\x00"
PARTICLE_SYSTEM_FACTORY_CHUNK = "\x00\x58\x01\x00"
PARTICLE_SYSTEM_2_CHUNK = "\x01\x58\x01\x00"
COMP_DRAW_CHUNK = "\018\069\000\000"
COMP_DRAW_SKIN_LIST_SUBCHUNK = "\019\069\000\000"
COMP_DRAW_PROP_LIST_SUBCHUNK = "\020\069\000\000"
COMP_DRAW_SKIN_SUBCHUNK = "\021\069\000\000"
OLD_FRAME_CONTROLLER_CHUNK = "\000\018\018\000"
SPRITE_CHUNK = "\005\144\001\000"
IMAGE_CHUNK = "\001\144\001\000"
IMAGE_DATA_CHUNK = "\002\144\001\000"
CAR_CAMERA_DATA_CHUNK = "\000\001\000\003"
MOTION_ROOT_LABEL = "Motion_Root\000"
TEXT_BIBLE_CHUNK = "\x0D\x80\x01\x00"
LANGUAGE_CHUNK = "\x0E\x80\x01\x00"
COLLISION_OBJECT_CHUNK = "\000\000\001\007"
PHYSICS_OBJECT_CHUNK = "\000\016\001\007"
LOCATOR_CHUNK = "\005\000\000\003"
WALL_COLLISION_CONTAINER_CHUNK = "\007\000\240\003"
STATIC_MESH_COLLISION_CHUNK = "\001\000\240\003"
STATIC_WORLD_MESH_CHUNK = "\000\000\240\003"
OLD_PRIMITIVE_GROUP_CHUNK = "\002\000\001\000"
COLOUR_LIST_CHUNK = "\008\000\001\000"

STATIC_WORLD_PROP_CHUNK = "\010\000\240\003"
BREAKABLE_WORLD_PROP_CHUNK = "\002\000\240\003"
EXPLOSION_EFFECT_TYPE_CHUNK = "\000\016\003\020"
WORLD_SPHERE_CHUNK = "\011\000\240\003"
STATIC_COLLISIONLESS_WORLD_PROP_CHUNK = "\009\000\240\003"
LENS_FLARE_CHUNK = "\x0D\x00\xF0\x03"
LIGHT_CHUNK = "\000\048\001\000"
OLD_BILLBOARD_QUAD_GROUP_CHUNK = "\002\112\001\000"
OLD_BILLBOARD_QUAD_CHUNK = "\001\112\001\000"
BREAKABLE_WORLD_PROP_CHUNK2 = "\014\000\240\003"
BREAKABLE_DRAWABLE_CHUNK = "\016\000\240\003"

TEXTURE_PARAMETER_CHUNK = "\x02\x10\x01\x00"
INTEGER_PARAMETER_CHUNK = "\x03\x10\x01\x00"
FLOAT_PARAMETER_CHUNK = "\x04\x10\x01\x00"
COLOUR_PARAMETER_CHUNK = "\x05\x10\x01\x00"

-- Some functions for converting binary numbers in strings to Lua numbers
-- All functions are little endian

local pack = string.pack
local unpack = string.unpack

function String1ToInt(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end

    return str:byte(StartPosition)
end
GetP3DInt1 = String1ToInt


function String4ToInt(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<i", str, StartPosition)
end
GetP3DInt4 = String4ToInt

function String4ToFloat(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	return unpack("<f", str, StartPosition)
end
GetP3DFloat = String4ToFloat

function String4ToARGB(str, StartPosition)
	if StartPosition == nil then StartPosition = 1 end
	
	local B, G, R, A = unpack("<BBBB", str, StartPosition)
	return A, R, G, B
end
GetP3DARGB = String4ToARGB

IntToString1 = string.char

function IntToString4(int)
	return pack("<i", int)
end

function FloatToString4(float)
	return pack("<f", float)
end

function ARGBToString4(A, R, G, B)
	return pack("<BBBB", B, G, R, A)
end

function Vector3ToString12(X, Y, Z)
	return pack("<fff", X, Y, Z)
end

function Vector2ToString8(X, Y)
	return pack("<ff", X, Y)
end

function UnpackChunkHeader(Chunk, StartPosition)
	if StartPosition == nil then StartPosition = 1 end

	return unpack("<c4ii", Chunk, StartPosition)
end

-- Iterate a chunk to find its subchunks, because simple pattern matching can find false matches

function FindSubchunks(Chunk, ID, StartPosition, EndPosition)
	if StartPosition == nil then StartPosition = 1 end
	if EndPosition == nil then EndPosition = Chunk:len() end

    local Position = StartPosition + String4ToInt(Chunk, StartPosition + 4)
    return function()
        while Position < EndPosition do
			local ChunkID, ChunkValueLength, ChunkLength = UnpackChunkHeader(Chunk, Position)
            --[[local ChunkID = Chunk:sub(Position + 0, Position + 3)
            local ChunkLength = String4ToInt(Chunk, Position + 8)]]--Lucas: Removed call to string.sub
            Position = Position + ChunkLength
            if ID == nil or ChunkID == ID then--Lucas: Yield all chunks if ID is nil
                return Position - ChunkLength, ChunkLength, ChunkID--Lucas: Yield the ChunkID as well
            end
        end
        return nil
    end
end

-- Simple use of iterator to the find the first chunk of an ID
function FindSubchunk(Chunk, ID, StartPosition, EndPosition)
    return FindSubchunks(Chunk, ID, StartPosition, EndPosition)()
end

-- Extract a string from a P3D chunk
function GetP3DString(Chunk, Offset)
    local Name = unpack("<s1", Chunk, Offset)
    return Name, Name:len()
end

-- Change a string inside a P3D string
-- Returns the new P3D, the change in length for updating header data, and the original string
function SetP3DString(Chunk, Offset, NewString)
	local OrigName, OrigLength = GetP3DString(Chunk, Offset)
	local New = Chunk:sub(1, Offset - 1) .. pack("<s1", NewString) .. Chunk:sub(Offset + OrigLength + 1)
    local Delta = NewString:len() - OrigLength
    return New, Delta, OrigName
end

-- Get FourCC
function GetP3DFourCC(Chunk, Offset)
	return unpack("<c4", Chunk, Offset)
end

function SetP3DFourCC(Chunk, Offset, NewValue)
	return Chunk:sub(1, Offset - 1) .. pack("<c4", NewValue) .. Chunk:sub(Offset + 4)
end

function SetP3DInt1(Chunk, Offset, NewValue)
    NewValue = IntToString1(NewValue)
    return Chunk:sub(1, Offset - 1) .. NewValue .. Chunk:sub(Offset + 1)
end

-- Sets an INT4 at a specific offset from a P3D Chunk
function SetP3DInt4(Chunk, Offset, NewValue)
    NewValue = IntToString4(NewValue)
    return Chunk:sub(1, Offset - 1) .. NewValue .. Chunk:sub(Offset + 4)
end

-- Add a number to an INT4 at a specific offset from a P3D Chunk
function AddP3DInt4(Chunk, Offset, Adjust)
    local New = GetP3DInt4(Chunk, Offset) + Adjust
    return SetP3DInt4(Chunk, Offset, New)
end

-- Sets a float at a specific offset from a P3D Chunk
function SetP3DFloat(Chunk, Offset, NewValue)
    NewValue = FloatToString4(NewValue)
    return Chunk:sub(1, Offset - 1) .. NewValue .. Chunk:sub(Offset + 4)
end

-- Add a number to a float at a specific offset from a P3D Chunk
function AddP3DFloat(Chunk, Offset, Adjust)
    local New = GetP3DFloat(Chunk, Offset) + Adjust
    return SetP3DFloat(Chunk, Offset, New)
end

-- Sets a 4 byte ARGB value at a specific offset from a P3D Chunk
function SetP3DARGB(Chunk, Offset, A, R, G, B)
    return Chunk:sub(1, Offset - 1) .. ARGBToString4(A, R, G, B) .. Chunk:sub(Offset + 4)
end

-- Sets a 4 byte ARGB value at a specific offset from a P3D Chunk
function SetP3DVector3(Chunk, Offset, X, Y, Z)
    return Chunk:sub(1, Offset - 1) .. Vector3ToString12(X, Y, Z) .. Chunk:sub(Offset + 12)
end

-- Sets a 4 byte ARGB value at a specific offset from a P3D Chunk
function SetP3DVector2(Chunk, Offset, X, Y)
    return Chunk:sub(1, Offset - 1) .. Vector2ToString8(X, Y) .. Chunk:sub(Offset + 8)
end

--Remove a substring from a string
function RemoveString(Str, Start, End)
    return Str:sub(1, Start - 1) .. Str:sub(End)
end

-- Transforms an ASCII string to "UTF-16" by adding an extra null byte
-- Only valid for real 7-bit ASCII 
function AsciiToUTF16(String)
	local Out = ""
	for i = 1, #String do
		Out = Out .. String:sub(i,i) .. "\0"
	end
	return Out
end

-- Uncomment to print more debug messages about the P3D file patching process
function p3d_debug(message)
    -- print(message)
end

function GetCompositeDrawableName(P3DFile)
	local ChunkPos, ChunkLen = FindSubchunk(P3DFile, COMP_DRAW_CHUNK)
	if ChunkPos then
		return FixP3DString(GetP3DString(P3DFile, ChunkPos + 12))
	end
	return nil
end

local SkinSkelCopy = {[SKIN_CHUNK] = true, [TEXTURE_CHUNK] = true, [SHADER_CHUNK] = true, [MESH_CHUNK] = true, [ANIMATION_CHUNK] = true, [OLD_FRAME_CONTROLLER_CHUNK] = true, [PARTICLE_SYSTEM_FACTORY_CHUNK] = true, [PARTICLE_SYSTEM_2_CHUNK] = true}
local SkinSkelRename = {[SKELETON_CHUNK] = true, [MULTI_CONTROLLER_CHUNK] = true, [COMP_DRAW_CHUNK] = true}
function ReplaceCharacterSkinSkel(Original, Replace)
	local Output = {}
	local OriginalStartPosition = 1
	local Renames = {}
	for ChunkPos, ChunkLen, ChunkID in FindSubchunks(Original, nil) do
		if SkinSkelCopy[ChunkID] then
			Output[#Output + 1] = Original:sub(OriginalStartPosition, ChunkPos - 1)
			OriginalStartPosition = ChunkPos + ChunkLen
		elseif SkinSkelRename[ChunkID] then
			Output[#Output + 1] = Original:sub(OriginalStartPosition, ChunkPos - 1)
			OriginalStartPosition = ChunkPos + ChunkLen
			Renames[ChunkID] = GetP3DString(Original, ChunkPos + 12)
		end
	end
	local contains = false
	for k,v in pairs(Renames) do
		if k == MULTI_CONTROLLER_CHUNK then
			contains = true
			break
		end
	end
	if not contains then Renames[MULTI_CONTROLLER_CHUNK] = Renames[SKELETON_CHUNK] end
	local Chunk, Delta
	for ChunkPos, ChunkLen, ChunkID in FindSubchunks(Replace, nil) do
		if SkinSkelCopy[ChunkID] then
			Chunk = Replace:sub(ChunkPos, ChunkPos + ChunkLen - 1)
			if ChunkID == SKIN_CHUNK then
				local NameLen = GetP3DInt1(Chunk, 13)
				Chunk, Delta = SetP3DString(Chunk, 18 + NameLen, Renames[SKELETON_CHUNK])
				Chunk = AddP3DInt4(Chunk, 5, Delta)
				Chunk = AddP3DInt4(Chunk, 9, Delta)
			end
			Output[#Output + 1] = Chunk
		elseif SkinSkelRename[ChunkID] then
			Chunk, Delta = SetP3DString(Replace:sub(ChunkPos, ChunkPos + ChunkLen - 1), 13, Renames[ChunkID])
			Chunk = AddP3DInt4(Chunk, 5, Delta)
			Chunk = AddP3DInt4(Chunk, 9, Delta)
			if ChunkID == COMP_DRAW_CHUNK then
				Chunk, Delta = SetP3DString(Chunk, 14 + Renames[ChunkID]:len(), Renames[SKELETON_CHUNK])
				Chunk = AddP3DInt4(Chunk, 5, Delta)
				Chunk = AddP3DInt4(Chunk, 9, Delta)
			end
			Output[#Output + 1] = Chunk
		end
	end
	local OutputVal = table.concat(Output)
	OutputVal = SetP3DInt4(OutputVal, 9, OutputVal:len())
	return OutputVal
end

-- Replace the character model from Original with the data from Replace
function OldReplaceCharacterSkinSkel(Original, Replace)
    -- Copy textures over
    local Textures = ""
	for position, length in FindSubchunks(Replace, TEXTURE_CHUNK) do
		Textures = Textures .. Replace:sub(position, position + length - 1)
	end

    -- Copy shaders over
	local Shaders = ""
	local ShaderList = {}
	for position, length in FindSubchunks(Replace, SHADER_CHUNK) do
		local ShaderName = GetP3DString(Replace, position + 12)
		ShaderList[ShaderName] = true
		local Shader =  Replace:sub(position, position + length - 1)
		Shaders = Shaders .. Shader
	end

    -- Remove clashing shaders
	local Adjust = 0
	for position, length in FindSubchunks(Original, SHADER_CHUNK) do
		local ShaderName = GetP3DString(Original, position + 12 - Adjust)
		if ShaderList[ShaderName] then
			p3d_debug("Removing clashing shader " .. ShaderName)
			Original = RemoveString(Original, position - Adjust, position + length - Adjust)
            Adjust = Adjust + length
		end
	end
    
    -- Find meshes
    local Meshes = ""
    for position, length in FindSubchunks(Replace, MESH_CHUNK) do
        Meshes = Meshes .. Replace:sub(position, position + length - 1)
    end
    
    -- Locate the new animation
    ANIndex, ANLength = FindSubchunk(Replace, ANIMATION_CHUNK)
    local Animation = ""
    if ANIndex ~= nil then
        p3d_debug("Replacing eyeball animation")
        Animation = Replace:sub(ANIndex, ANIndex + ANLength - 1)		
        -- Remove the original animation
        local ANIndex, ANLength = FindSubchunk(Original, ANIMATION_CHUNK)
        if ANIndex ~= nil then
            Original = RemoveString(Original, ANIndex, ANIndex + ANLength)
        end
    end
    
    -- Load new skeleton
    local SKIndex, SKLength = FindSubchunk(Replace, SKELETON_CHUNK)
    local NewSkel = Replace:sub(SKIndex, SKIndex + SKLength - 1)
    
    -- Load new skin
    local SNIndex, SNLength = FindSubchunk(Replace, SKIN_CHUNK)
    local NewSkin = Replace:sub(SNIndex, SNIndex + SNLength - 1)
    
    -- Find Original Skeleton, Remove it
    SKIndex, SKLength = FindSubchunk(Original, SKELETON_CHUNK)
    local SkelName, SkelNLength = GetP3DString(Original, SKIndex + 12)
    Original = RemoveString(Original, SKIndex, SKIndex + SKLength)
    
    -- Find Original Skin
    SNIndex, SNLength = FindSubchunk(Original, SKIN_CHUNK)
    local SkinName, SkinNLength = GetP3DString(Original, SNIndex + 12)
    
    -- Change names and update lengths
    NewSkel, SkelDelta, OSName = SetP3DString(NewSkel, 13, SkelName)
    NewSkel = AddP3DInt4(NewSkel, 5, SkelDelta)
    NewSkel = AddP3DInt4(NewSkel, 9, SkelDelta)
    NewSkin, SkinDelta, OS2Name = SetP3DString(NewSkin, 13, SkinName)
    local SkelNameIndex = SkinName:len() + 18
    NewSkin, SkinDelta2, OS3Name = SetP3DString(NewSkin, SkelNameIndex, SkelName)
    NewSkin = AddP3DInt4(NewSkin, 5, SkinDelta + SkinDelta2)
    NewSkin = AddP3DInt4(NewSkin, 9, SkinDelta + SkinDelta2)
    
    p3d_debug(OSName .. "->" .. SkelName .. OS2Name .. "->" .. SkinName .. OS3Name .. "->" .. SkelName)
    
    -- Add to original model
    Original = Original:sub(1, SNIndex - 1) .. Textures .. Shaders .. Animation .. NewSkel .. Meshes .. NewSkin .. Original:sub(SNIndex + SNLength)
    
    -- Locate the new OFC, if one exists
    local NFCIndex, NFCLength = FindSubchunk(Replace, OLD_FRAME_CONTROLLER_CHUNK)
    if NFCIndex ~= nil then
        p3d_debug("Replacing eyeball frame controller")
        -- Locate original OFC
        local OFCIndex, OFCLength = FindSubchunk(Original, OLD_FRAME_CONTROLLER_CHUNK)
        if OFCIndex ~= nil then
            -- Get new OFC   
            local NFC = Replace:sub(NFCIndex, NFCIndex + NFCLength - 1)
            -- Replace the original OFC with the new one
            Original = Original:sub(1, OFCIndex - 1) .. NFC .. Original:sub(OFCIndex + OFCLength)
        end
    end
    
    -- Locate the new comp drawable prop list
    local CDIndex, CDLength = FindSubchunk(Replace, COMP_DRAW_CHUNK)
    local CD = Replace:sub(CDIndex, CDIndex + CDLength - 1)
    local CDPIndex, CDPLength = FindSubchunk(CD, COMP_DRAW_PROP_LIST_SUBCHUNK)
    local CDP = CD:sub(CDPIndex, CDPIndex + CDPLength - 1)
    
    -- Replace the old comp drawable prop list
    local CDIndex, CDLength = FindSubchunk(Original, COMP_DRAW_CHUNK)
    local CD = Original:sub(CDIndex, CDIndex + CDLength - 1)
    local CDPIndex, CDPLength = FindSubchunk(CD, COMP_DRAW_PROP_LIST_SUBCHUNK)
    Original = Original:sub(1, CDIndex + CDPIndex - 2) .. CDP .. Original:sub(CDIndex + CDPIndex - 1 + CDPLength)
    Original = AddP3DInt4(Original, CDIndex + 8, CDP:len() - CDPLength)
    
    -- Update file length
    Original = SetP3DInt4(Original, 9, Original:len())
    return Original
end

-- Modify a car P3D to change the camera index
function SetCarCameraIndex(CarModel, Index)
    for pos, length in FindSubchunks(CarModel, CAR_CAMERA_DATA_CHUNK) do
        local cameraID = GetP3DInt4(CarModel, pos + 12)
        if cameraID > 256 then
            Index = Index + 256
        end
        CarModel = SetP3DInt4(CarModel, pos + 12, Index)
    end
    return CarModel
end

-- Remove null padding bytes from a P3D string
function FixP3DString(str)
	local strLen = str:len()
	if strLen == 0 then return str end
	local l = 0
	for i=1,strLen do
		if str:byte(i) ~= 0 then
			l = l + 1
		else
			break
		end
	end
	return str:sub(1, l)
end

-- Pad a string to make it P3D compatible (multiple of 4)
local null = string.char(0)
function MakeP3DString(str, minLen)
	local strLen = str:len()
	local diff = strLen % 4
	if diff > 0 then
		for i=1,4-diff do
			str = str .. null
		end
	end
	if minLen then
		diff = minLen - str:len()
		if diff > 0 then
			for i=1,diff do
				str = str .. null
			end
		end
	end
	return str
end

-- Replace the car in Original with the model from Replace
function ReplaceCar(Original, Replace)
	local cam = nil
	for pos, length in FindSubchunks(Replace, CAR_CAMERA_DATA_CHUNK) do
        local cameraID = GetP3DInt4(Replace, pos + 12)
        if cameraID <= 256 then
            cam = cameraID
			break
        end
    end
	if not cam then return Original end
	Original = SetCarCameraIndex(Original, cam)
	local CompIndex, CompLength = FindSubchunk(Original, COMP_DRAW_CHUNK)
    local OldName, OldCompNLength = GetP3DString(Original, CompIndex + 12)
	CompIndex, CompLength = FindSubchunk(Replace, COMP_DRAW_CHUNK)
    local NewName, CompNLength = GetP3DString(Replace, CompIndex + 12)
	local NewNameBV = MakeP3DString(FixP3DString(NewName) .. "BV")
	local Adjust = 0
	for pos, length in FindSubchunks(Original, COLLISION_OBJECT_CHUNK) do
		local name, _ = GetP3DString(Original, pos + 12 + Adjust)
		local diff = 0
		if FixP3DString(name):sub(-2) == "BV" then
			Original, diff = SetP3DString(Original, pos + 12 + Adjust, NewNameBV)
		else
			Original, diff = SetP3DString(Original, pos + 12 + Adjust, NewName)
		end
		Original = AddP3DInt4(Original, pos + 4 + Adjust, diff)
		Original = AddP3DInt4(Original, pos + 8 + Adjust, diff)
		Adjust = Adjust + diff
	end
	Adjust = 0
	for pos, length in FindSubchunks(Original, PHYSICS_OBJECT_CHUNK) do
		local name, _ = GetP3DString(Original, pos + 12 + Adjust)
		local diff = 0
		if FixP3DString(name):sub(-2) == "BV" then
			Original, diff = SetP3DString(Original, pos + 12 + Adjust, NewNameBV)
		else
			Original, diff = SetP3DString(Original, pos + 12 + Adjust, NewName)
		end
		Original = AddP3DInt4(Original, pos + 4 + Adjust, diff)
		Original = AddP3DInt4(Original, pos + 8 + Adjust, diff)
		Adjust = Adjust + diff
	end
	Adjust = 0
	for pos, length in FindSubchunks(Original, COMP_DRAW_CHUNK) do
		local name, _ = GetP3DString(Original, pos + 12 + Adjust)
		local diff = 0
		if name == OldName then
			Original, diff = SetP3DString(Original, pos + 12 + Adjust, NewName)
			Original = AddP3DInt4(Original, pos + 4 + Adjust, diff)
			Original = AddP3DInt4(Original, pos + 8 + Adjust, diff)
			Adjust = Adjust + diff
		end
	end
    Original = SetP3DInt4(Original, 9, Original:len())
    return Original
end

-- Decompress a compressed *block* within a P3D
local function DecompressBlock(Source, Destination, DestinationPos, Length)
	local Written = 0
	local SourceIndex = 1
	while (Written < Length) do
		local Unknown = String1ToInt(Source:sub(SourceIndex, SourceIndex))
		SourceIndex = SourceIndex + 1
		if (Unknown <= 15) then
			if (Unknown == 0) then
				if (String1ToInt(Source:sub(SourceIndex, SourceIndex)) == 0) then
					local Unknown2 = 0
					repeat
						SourceIndex = SourceIndex + 1
						Unknown2 = String1ToInt(Source:sub(SourceIndex, SourceIndex))
						Unknown = Unknown + 255
					until (Unknown2 ~= 0)
				end
				Unknown = Unknown + String1ToInt(Source:sub(SourceIndex, SourceIndex))
				SourceIndex = SourceIndex + 1
				Destination = Destination .. Source:sub(SourceIndex, SourceIndex + 14)
				DestinationPos = DestinationPos + 15
				SourceIndex = SourceIndex + 15
				Written = Written + 15
			end
			repeat
				Destination = Destination .. Source:sub(SourceIndex, SourceIndex)
				SourceIndex = SourceIndex + 1
				DestinationPos = DestinationPos + 1
				Written = Written + 1
				Unknown = Unknown - 1
			until (Unknown <= 0);
		else
			local Unknown2 = Unknown % 16
			if (Unknown2 == 0) then
				local Unknown3 = 15
				if (String1ToInt(Source:sub(SourceIndex, SourceIndex)) == 0) then
					local Unknown4;
					repeat
						SourceIndex = SourceIndex + 1
						Unknown4 = String1ToInt(Source:sub(SourceIndex, SourceIndex))
						Unknown3 = Unknown3 + 255;
					until (Unknown4 ~= 0)
				end
				Unknown2 = Unknown2 + String1ToInt(Source:sub(SourceIndex, SourceIndex)) + Unknown3				
				SourceIndex = SourceIndex + 1
			end
			local Unknown6 = DestinationPos - (math.floor(Unknown / 16) | (16 * String1ToInt(Source:sub(SourceIndex, SourceIndex))))
			local Unknown5 = math.floor(Unknown2 / 4);
			SourceIndex = SourceIndex + 1			
			repeat
				Destination = Destination .. Destination:sub(Unknown6, Unknown6)
				Destination = Destination .. Destination:sub(Unknown6 + 1, Unknown6 + 1)
				Destination = Destination .. Destination:sub(Unknown6 + 2, Unknown6 + 2)
				Destination = Destination .. Destination:sub(Unknown6 + 3, Unknown6 + 3)
				Unknown6 = Unknown6 + 4
				DestinationPos = DestinationPos + 4
				Unknown5 = Unknown5 - 1;
			until Unknown5 <= 0;
			local Unknown7 = Unknown2 % 4;
			while (Unknown7 > 0) do
				Destination = Destination .. Destination:sub(Unknown6, Unknown6)
				DestinationPos = DestinationPos + 1
				Unknown6 = Unknown6 + 1
				Unknown7 = Unknown7 - 1
			end
			Written = Written + Unknown2
		end
	end
	return Destination, DestinationPos
end

-- Decompress a compressed P3D, returns the original P3D if not compressed
function DecompressP3D(File)
	if File:sub(1, 4) == "P3DZ" then
		local UncompressedLength = GetP3DInt4(File, 5)
		local DecompressedLength = 0
		local pos = 9
		local Uncompressed = ""
		local UncompressedPos = 1
		while DecompressedLength < UncompressedLength do
			local CompressedLength = GetP3DInt4(File, pos)
			pos = pos + 4
			local UncompressedBlock = GetP3DInt4(File, pos)
			pos = pos + 4
			local Data = File:sub(pos, pos + CompressedLength)
			pos = pos + CompressedLength
			Uncompressed, UncompressedPos = DecompressBlock(Data, Uncompressed, UncompressedPos, UncompressedBlock)
			DecompressedLength = DecompressedLength + UncompressedBlock
		end
		return Uncompressed
	else
		return File
	end
end

local LensFlare = IsHackLoaded("LensFlare")
function BrightenModel(Original, Amount, Percentage)
	local RootChunk = P3DChunk:new{Raw = Original}
	local ROOT_CHUNKS = {STATIC_WORLD_MESH_CHUNK, STATIC_WORLD_PROP_CHUNK, BREAKABLE_WORLD_PROP_CHUNK, EXPLOSION_EFFECT_TYPE_CHUNK, WORLD_SPHERE_CHUNK, STATIC_COLLISIONLESS_WORLD_PROP_CHUNK}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == MESH_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == OLD_BILLBOARD_QUAD_GROUP_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == OLD_BILLBOARD_QUAD_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, BrightenModelProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), Amount, Percentage))
			modified = true
		elseif RootID == BREAKABLE_WORLD_PROP_CHUNK2 then
			local AnimDynaPhysChunk = AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(BREAKABLE_DRAWABLE_CHUNK) do
				local AnimObjWrapperChunk = AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(MESH_CHUNK) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_GROUP_CHUNK) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), Amount, Percentage))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == LIGHT_CHUNK then
			local LightChunk = LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			local R, G, B = BrightenRGB(LightChunk.Colour.R, LightChunk.Colour.G, LightChunk.Colour.B, Amount, Percentage)
			LightChunk:SetColour(LightChunk.Colour.A, R, G, B)
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function BrightenModelProcessRoot(Original, Amount, Percentage)
	local RootChunk = P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(MESH_CHUNK) do
		RootChunk:SetChunkAtIndex(idx, BrightenModelProcessMesh(RootChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	if LensFlare and RootChunk.ChunkType == WORLD_SPHERE_CHUNK then
		for idx in RootChunk:GetChunkIndexes(LENS_FLARE_CHUNK) do
			local LensFlareChunk = LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_GROUP_CHUNK) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(MESH_CHUNK) do
				LensFlareChunk:SetChunkAtIndex(idx2, BrightenModelProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), Amount, Percentage))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function BrightenModelProcessMesh(Original, Amount, Percentage)
	local MeshChunk = MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(OLD_PRIMITIVE_GROUP_CHUNK) do
		local OldPrimitiveGroupChunk = OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(COLOUR_LIST_CHUNK) do
			local ColourListChunk = ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				local A, R, G, B = String4ToARGB(ColourListChunk.Colours[i])
				R, G, B = BrightenRGB(R, G, B, Amount, Percentage)
				ColourListChunk.Colours[i] = ARGBToString4(A, R, G, B)
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function BrightenModelProcessOldBillboardQuadGroup(Original, Amount, Percentage)
	local OldBillboardQuadGroupChunk = OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_CHUNK) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, BrightenModelProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), Amount, Percentage))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function BrightenModelProcessOldBillboardQuad(Original, Amount, Percentage)
	local OldBillboardQuadChunk = OldBillboardQuadP3DChunk:new{Raw = Original}
	local R, G, B = BrightenRGB(OldBillboardQuadChunk.Colour.R, OldBillboardQuadChunk.Colour.G, OldBillboardQuadChunk.Colour.B, Amount, Percentage)
	OldBillboardQuadChunk:SetColour(OldBillboardQuadChunk.Colour.A, R, G, B)
	return OldBillboardQuadChunk:Output()
end

function SetModelRGB(Original, A, R, G, B)
	local RootChunk = P3DChunk:new{Raw = Original}
	local ROOT_CHUNKS = {STATIC_WORLD_MESH_CHUNK, STATIC_WORLD_PROP_CHUNK, BREAKABLE_WORLD_PROP_CHUNK, EXPLOSION_EFFECT_TYPE_CHUNK, WORLD_SPHERE_CHUNK, STATIC_COLLISIONLESS_WORLD_PROP_CHUNK}
	local modified = false
	for RootIdx, RootID in RootChunk:GetChunkIndexes(nil) do
		if ExistsInTbl(ROOT_CHUNKS, RootID) then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessRoot(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == MESH_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == OLD_BILLBOARD_QUAD_GROUP_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuadGroup(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == OLD_BILLBOARD_QUAD_CHUNK then
			RootChunk:SetChunkAtIndex(RootIdx, SetModelRGBProcessOldBillboardQuad(RootChunk:GetChunkAtIndex(RootIdx), A, R, G, B))
			modified = true
		elseif RootID == BREAKABLE_WORLD_PROP_CHUNK2 then
			local AnimDynaPhysChunk = AnimDynaPhysP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			for idx in AnimDynaPhysChunk:GetChunkIndexes(BREAKABLE_DRAWABLE_CHUNK) do
				local AnimObjWrapperChunk = AnimObjWrapperP3DChunk:new{Raw = AnimDynaPhysChunk:GetChunkAtIndex(idx)}
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(MESH_CHUNK) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
				for idx2 in AnimObjWrapperChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_GROUP_CHUNK) do
					AnimObjWrapperChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(AnimObjWrapperChunk:GetChunkAtIndex(idx2), A, R, G, B))
				end
			end
			RootChunk:SetChunkAtIndex(RootIdx, AnimDynaPhysChunk:Output())
			modified = true
		elseif RootID == LIGHT_CHUNK then
			local LightChunk = LightP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(RootIdx)}
			LightChunk:SetColour(A, R, G, B)
			RootChunk:SetChunkAtIndex(RootIdx, LightChunk:Output())
			modified = true
		end
	end
	return RootChunk:Output(), modified
end
function SetModelRGBProcessRoot(Original, A, R, G, B)
	local RootChunk = P3DChunk:new{Raw = Original}
	for idx in RootChunk:GetChunkIndexes(MESH_CHUNK) do
		RootChunk:SetChunkAtIndex(idx, SetModelRGBProcessMesh(RootChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	if LensFlare and RootChunk.ChunkType == WORLD_SPHERE_CHUNK then
		for idx in RootChunk:GetChunkIndexes(LENS_FLARE_CHUNK) do
			local LensFlareChunk = LensFlareP3DChunk:new{Raw = RootChunk:GetChunkAtIndex(idx)}
			for idx2 in LensFlareChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_GROUP_CHUNK) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessOldBillboardQuadGroup(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			for idx2 in LensFlareChunk:GetChunkIndexes(MESH_CHUNK) do
				LensFlareChunk:SetChunkAtIndex(idx2, SetModelRGBProcessMesh(LensFlareChunk:GetChunkAtIndex(idx2), A, R, G, B))
			end
			RootChunk:SetChunkAtIndex(idx, LensFlareChunk:Output())
		end
	end
	return RootChunk:Output()
end
function SetModelRGBProcessMesh(Original, A, R, G, B)
	local MeshChunk = MeshP3DChunk:new{Raw = Original}
	for idx in MeshChunk:GetChunkIndexes(OLD_PRIMITIVE_GROUP_CHUNK) do
		local OldPrimitiveGroupChunk = OldPrimitiveGroupP3DChunk:new{Raw = MeshChunk:GetChunkAtIndex(idx)}
		for idx2 in OldPrimitiveGroupChunk:GetChunkIndexes(COLOUR_LIST_CHUNK) do
			local ColourListChunk = ColourListP3DChunk:new{Raw = OldPrimitiveGroupChunk:GetChunkAtIndex(idx2)}
			for i=1,#ColourListChunk.Colours do
				ColourListChunk.Colours[i] = ARGBToString4(A, R, G, B)
			end
			OldPrimitiveGroupChunk:SetChunkAtIndex(idx2, ColourListChunk:Output())
		end
		MeshChunk:SetChunkAtIndex(idx, OldPrimitiveGroupChunk:Output())
	end
	return MeshChunk:Output()
end
function SetModelRGBProcessOldBillboardQuadGroup(Original, A, R, G, B)
	local OldBillboardQuadGroupChunk = OldBillboardQuadGroupP3DChunk:new{Raw = Original}
	for idx in OldBillboardQuadGroupChunk:GetChunkIndexes(OLD_BILLBOARD_QUAD_CHUNK) do
		OldBillboardQuadGroupChunk:SetChunkAtIndex(idx, SetModelRGBProcessOldBillboardQuad(OldBillboardQuadGroupChunk:GetChunkAtIndex(idx), A, R, G, B))
	end
	return OldBillboardQuadGroupChunk:Output()
end
function SetModelRGBProcessOldBillboardQuad(Original, A, R, G, B)
	local OldBillboardQuadChunk = OldBillboardQuadP3DChunk:new{Raw = Original}
	OldBillboardQuadChunk:SetColour(A, R, G, B)
	return OldBillboardQuadChunk:Output()
end

local min = math.min
local max = math.max
local floor = math.floor
function BrightenRGB(r, g, b, Amount, Percentage)
	if Percentage then
		b = min(255, max(0, floor(b * Amount)))
		g = min(255, max(0, floor(g * Amount)))
		r = min(255, max(0, floor(r * Amount)))
	else
		b = min(255, max(0, b + Amount))
		g = min(255, max(0, g + Amount))
		r = min(255, max(0, r + Amount))
	end
	return r, g, b
end