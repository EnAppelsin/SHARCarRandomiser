----------------------------------------------------
-- p3d.lua - Modify P3D Files in Lua
----------------------------------------------------

-- Some chunks as Lua Strings
TEXTURE_CHUNK = "\000\144\001\000"
SHADER_CHUNK = "\000\016\001\000"
ANIMATION_CHUNK = "\000\016\018\000"
ANIMATION_GROUP_CHUNK = "\002\016\018\000"
SKIN_CHUNK = "\001\000\001\000"
SKELETON_CHUNK = "\000\069\000\000"
MESH_CHUNK = "\000\000\001\000"
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

-- Some functions for converting binary numbers in strings to Lua numbers
-- All functions are little endian

function String1ToInt(str)
    return str:byte(1)
end

function String4ToInt(str)
    local b1, b2, b3, b4 = str:byte(1, 4)
    return b1 + (b2 * 256) + (b3 * 256 * 256) + (b4 * 256 *256*256)
end

function IntToString4(int)
    local b1 = int % 256
    local b2 = math.floor(int / 256) % 256
    local b3 = math.floor(int / 256 / 256) % 256
    local b4 = math.floor(int / 256 / 256 / 256) % 256
    return string.char(b1, b2, b3, b4)
end

-- Iterate a chunk to find its subchunks, because simple pattern matching can find false matches

function FindSubchunks(Chunk, ID)
    local LengthStr = Chunk:sub(5, 8)
    local Position = 1 + String4ToInt(LengthStr)
    return function()
        while Position < Chunk:len() do
            local ChunkID = Chunk:sub(Position + 0, Position + 3)
            local ChunkLength = String4ToInt(Chunk:sub(Position + 8, Position + 11))
            Position = Position + ChunkLength
            if ChunkID == ID then
                return Position - ChunkLength, ChunkLength
            end
        end
        return nil
    end
end

-- Simple use of iterator to the find the first chunk of an ID
function FindSubchunk(Chunk, ID)
    return FindSubchunks(Chunk, ID)()
end

-- Extract a string from a P3D chunk
function GetP3DString(Chunk, Offset)
    local NLength = String1ToInt(Chunk:sub(Offset, Offset))
    local Name =  Chunk:sub(Offset + 1, Offset + NLength)
    return Name, NLength
end

-- Change a string inside a P3D string
-- Returns the new P3D, the change in length for updating header data, and the original string
function SetP3DString(Chunk, Offset, NewString)
	local OrigName, OrigLength = GetP3DString(Chunk, Offset)
    local LengthByte = string.char(NewString:len())
	local New = Chunk:sub(1, Offset - 1) .. LengthByte .. NewString .. Chunk:sub(Offset + OrigLength + 1)
    local Delta = NewString:len() - OrigLength
    return New, Delta, OrigName
end

-- Get an INT4 at a specific offset from a P3D Chunk
function GetP3DInt4(Chunk, Offset)
    return String4ToInt(Chunk:sub(Offset, Offset + 3))
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

-- Replace the character model from Original with the data from Replace
function ReplaceCharacterSkinSkel(Original, Replace)
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
function MakeP3DString(str, minLen)
	local strLen = str:len()
	local diff = strLen % 4
	if diff > 0 then
		for i=1,4-diff do
			str = str .. string.char(0)
		end
	end
	if minLen then
		diff = minLen - str:len()
		if diff > 0 then
			for i=1,diff do
				str = str .. string.char(0)
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
			pos = pos +  CompressedLength
			Uncompressed, UncompressedPos = DecompressBlock(Data, Uncompressed, UncompressedPos, UncompressedBlock)
			DecompressedLength = DecompressedLength + UncompressedBlock
		end
		return Uncompressed
	else
		return File
	end
end