-- This file modifies a binary .p3d file to replace the character on the couch.
-- Lua strings are 8-bit clean, and there's no other data type for storing data
-- So it may look quite ugly, especially using Regexes on binary strings.
-- Lua explicitly supports this.

-- The most important "standard" structure is each Chunk (data type) starts with the
-- following 12 bytes
-- 4 bytes: Type identifier
-- 4 bytes: Little-endian length of chunk itself
-- 4 bytes: Little-endian length of chunk and subchunks
-- After this is the chunk name, as a 1-byte length and an ASCII string.
-- The string length seems to always be a multiple of 4
-- After this is data specific to the chunk type, and then the subchunks with the same structure
-- The file itself seems to be a "chunk" with type P3D\255, and no chunk specific data


-- Some functions for converting binary numbers in strings to Lua numbers
function String1ToInt(str)
    return str:byte(1)
end

function String4ToInt(str)
    b1, b2, b3, b4 = str:byte(1, 4)
    return b1 + (b2 * 256) + (b3 * 256 * 256) + (b4 * 256 *256*256)
end

function IntToString4(int)
    b1 = int % 256
    b2 = math.floor(int / 256) % 256
    b3 = math.floor(int / 256 / 256) % 256
    b4 = math.floor(int / 256 / 256 / 256) % 256
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

--Remove a substring from a string
function RemoveString(Str, Start, End)
    return Str:sub(1, Start - 1) .. Str:sub(End)
end

-- Uncomment to print more debug messages about the P3D file patching process
function p3d_debug(message)
    --print(message)
end

PedN = math.random(#RandomPedPool)
Ped = RandomPedPool[PedN]

local Path = "/GameData/" .. GetPath();
Original = ReadFile(Path)
local ReplacePath = "/GameData/art/chars/" .. Ped:sub(1,6) .. "_m.p3d"
Replace = ReadFile(ReplacePath)
local GlobalPath = "/GameData/art/chars/global.p3d"
Global = ReadFile(GlobalPath)

TEXTURE_CHUNK = "\000\144\001\000"
SHADER_CHUNK = "\000\016\001\000"
SKIN_CHUNK = "\001\000\001\000"
SKELETON_CHUNK = "\000\069\000\000"
COMP_DRAW_CHUNK = "\018\069\000\000"
COMP_DRAW_SKIN_SUBCHUNK = "\021\069\000\000"
COMP_DRAW_SKIN_LIST_SUBCHUNK = "\019\069\000\000"
MOTION_ROOT_LABEL = "\012Motion_Root\000"

Adjust = 0

for position, length in FindSubchunks(Original, SKIN_CHUNK) do
    p3d_debug("Found a skin at " .. position)
    Original = RemoveString(Original, position - Adjust, position + length - Adjust)
    Adjust = Adjust + length
    p3d_debug("> Removed a skin")
end

Textures = ""

for position, length in FindSubchunks(Global, TEXTURE_CHUNK) do
    Textures = Textures .. Global:sub(position, position + length - 1)
end

for position, length in FindSubchunks(Replace, TEXTURE_CHUNK) do
    Textures = Textures .. Replace:sub(position, position + length - 1)
end

Shaders = ""
ShaderList = {}

for position, length in FindSubchunks(Replace, SHADER_CHUNK) do
    local ShaderName, SNLength = GetP3DString(Replace, position + 12)
    ShaderList[ShaderName] = true
    local Shader =  Replace:sub(position, position + length - 1)
    Shader = string.gsub(Shader, "(eyeball.?)%.bmp%.0", "%1.bmp.3")
    Shaders = Shaders .. Shader
end

Adjust = 0

for position, length in FindSubchunks(Original, SHADER_CHUNK) do
    local ShaderName, SNLength = GetP3DString(Original, position + 12 - Adjust)
    if ShaderList[ShaderName] then
        p3d_debug("Removing clashing shader " .. ShaderName)
        Original = RemoveString(Original, position - Adjust, position + length - Adjust)
    end
end

-- Load the skin from the replacement
NewSkinL, Length = FindSubchunk(Replace, SKIN_CHUNK)
p3d_debug("New skin as at " .. NewSkinL)
NewSkin = Replace:sub(NewSkinL, NewSkinL + Length - 1)
NewSkinName, SNLength = GetP3DString(NewSkin, 13)
p3d_debug("> New skin name is " .. NewSkinName)
-- Update the skeleton
SNIndex = SNLength + 18
SNLength = String1ToInt(NewSkin:sub(SNIndex, SNIndex))
SkinSkelName, SNLength = GetP3DString(NewSkin, SNIndex)
NewSkin = NewSkin:sub(1, SNIndex - 1) .. MOTION_ROOT_LABEL .. NewSkin:sub(SNIndex + SNLength + 1)
HeaderLength = String4ToInt(NewSkin:sub(5, 8))
HeaderLength = HeaderLength - SNLength + 12
HeaderBytes = IntToString4(HeaderLength)
NewSkin = NewSkin:sub(1, 4) .. HeaderBytes .. NewSkin:sub(9)
LengthBytes = IntToString4(NewSkin:len())
NewSkin = NewSkin:sub(1, 8) .. LengthBytes .. NewSkin:sub(13)

-- Find the original skeleton
SKIndex, SKLength = FindSubchunk(Original, SKELETON_CHUNK)
p3d_debug("Original Skeleton as at " .. SKIndex)

-- Load the skeleton from the replacement
NewSkelL, Length = FindSubchunk(Replace, SKELETON_CHUNK)
p3d_debug("New skeleton as at " .. NewSkelL)
NewSkel = Replace:sub(NewSkelL, NewSkelL + Length - 1)

-- Update the skeleton name
OrigSkelName, SNLength = GetP3DString(NewSkel, 13)
p3d_debug("Original skeleton name is " .. OrigSkelName)
NewSkel = NewSkel:sub(1, 12) .. MOTION_ROOT_LABEL .. NewSkel:sub(13 + SNLength + 1)
HeaderLength = String4ToInt(NewSkel:sub(5, 8))
HeaderLength = HeaderLength - SNLength + 12
HeaderBytes = IntToString4(HeaderLength)
NewSkel = NewSkel:sub(1, 4) .. HeaderBytes .. NewSkel:sub(9)
LengthBytes = IntToString4(NewSkel:len())
NewSkel = NewSkel:sub(1, 8) .. LengthBytes .. NewSkel:sub(13)

p3d_debug("Replacing skeleton and adding skin to couch model")
Original = Original:sub(1, SKIndex - 1) .. Textures .. Shaders .. NewSkel .. NewSkin .. Original:sub(SKIndex + SKLength)




CDIndex, CDLength = FindSubchunk(Original, COMP_DRAW_CHUNK)
CD = Original:sub(CDIndex, CDIndex + CDLength - 1)

CDSLIndex, CDSLLength = FindSubchunk(CD, COMP_DRAW_SKIN_LIST_SUBCHUNK)
CDSL = CD:sub(CDSLIndex, CDSLIndex + CDSLLength - 1)


positions = {}
for i in FindSubchunks(CDSL, COMP_DRAW_SKIN_SUBCHUNK) do
    table.insert(positions, i)
end

Adjust = 0

for i = 1,#positions-1 do
    p3d_debug("Composite drawable skin at " .. positions[i])
    LengthStr = Original:sub(CDIndex + CDSLIndex + positions[i] + 8 - 2 - Adjust, CDIndex + CDSLIndex + positions[i] + 11 - Adjust - 2)
    Length = String4ToInt(LengthStr)
    Original = RemoveString(Original, CDIndex + CDSLIndex + positions[i] - 2 - Adjust, CDIndex + CDSLIndex + positions[i] + Length - Adjust - 2)
    Adjust = Adjust + Length
    p3d_debug("Removed the composite drawable skin")
end

-- Patch the last composite drawable skin
LastCDS = CDIndex + CDSLIndex +  positions[#positions] - Adjust - 2
CDSName, CDSLength = GetP3DString(Original, LastCDS + 12)
p3d_debug("Original comp draw skin name is " .. CDSName)
LengthByte = string.char(NewSkinName:len())

p3d_debug("> Changing name to " .. NewSkinName)
Original = Original:sub(1, LastCDS + 11) .. LengthByte .. NewSkinName .. Original:sub(LastCDS + CDSLength + 13)

HeaderLength = String4ToInt(Original:sub(LastCDS + 4, LastCDS + 7))
HeaderLength = HeaderLength - CDSLength + NewSkinName:len()
HeaderBytes = IntToString4(HeaderLength)
Original = Original:sub(1, LastCDS + 3) .. HeaderBytes .. Original:sub(LastCDS + 8)
ChunkLength = String4ToInt(Original:sub(LastCDS + 8, LastCDS + 11))
LengthBytes = IntToString4(ChunkLength - CDSLength + NewSkinName:len())
Original = Original:sub(1, LastCDS + 7) .. LengthBytes .. Original:sub(LastCDS + 12)

Adjust = Adjust + CDSLength - NewSkinName:len()

p3d_debug("Patching composite drawable skin list")
LengthBytes = IntToString4(CDSLLength - Adjust)
Original = Original:sub(1, CDIndex + CDSLIndex + 7 - 1) .. LengthBytes .. Original:sub(CDIndex + CDSLIndex + 12 - 1)
CountBytes = IntToString4(1)
Original = Original:sub(1, CDIndex + CDSLIndex + 11 - 1) .. CountBytes .. Original:sub(CDIndex + CDSLIndex + 16 - 1)

p3d_debug("Patching composite drawable length")
LengthBytes = IntToString4(CDLength - Adjust)
Original = Original:sub(1, CDIndex + 7) .. LengthBytes .. Original:sub(CDIndex + 12)

p3d_debug("Patching total file length")
LengthBytes = IntToString4(Original:len())
Original = Original:sub(1, 8) .. LengthBytes .. Original:sub(13)

print ("Couch modified with model from " .. ReplacePath)

Output(Original)