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

local PedN = math.random(#RandomPedPool)
local Ped = RandomPedPool[PedN]

local Path = "/GameData/" .. GetPath();
local Original = ReadFile(Path)
local ReplacePath = "/GameData/art/chars/" .. Ped:sub(1,6) .. "_m.p3d"
local Replace = ReadFile(ReplacePath)
local GlobalPath = "/GameData/art/chars/global.p3d"
local Global = ReadFile(GlobalPath)

local Adjust = 0

-- Find the original skeleton
local SKIndex, SKLength = FindSubchunk(Original, SKELETON_CHUNK)
p3d_debug("Original Skeleton as at " .. SKIndex)

-- Load the skeleton from the replacement
local NewSkelL, Length = FindSubchunk(Replace, SKELETON_CHUNK)
p3d_debug("New skeleton as at " .. NewSkelL)
local NewSkel = Replace:sub(NewSkelL, NewSkelL + Length - 1)

-- Update the skeleton name
local OrigSkelName, SNLength = GetP3DString(NewSkel, 13)
p3d_debug("New skeleton name is " .. OrigSkelName)
NewSkel = NewSkel:sub(1, 12) .. MOTION_ROOT_LABEL .. NewSkel:sub(13 + SNLength + 1)
local HeaderLength = String4ToInt(NewSkel:sub(5, 8))
HeaderLength = HeaderLength - SNLength + 12
local HeaderBytes = IntToString4(HeaderLength)
NewSkel = NewSkel:sub(1, 4) .. HeaderBytes .. NewSkel:sub(9)
local LengthBytes = IntToString4(NewSkel:len())
NewSkel = NewSkel:sub(1, 8) .. LengthBytes .. NewSkel:sub(13)

p3d_debug("Replacing skeleton and adding skin to couch model")
Replace = Replace:sub(1, NewSkelL - 1) .. OrigSkelName .. Replace:sub(NewSkelL + Length)

p3d_debug("Patching total file length")
LengthBytes = IntToString4(Replace:len())
Replace = Replace:sub(1, 8) .. LengthBytes .. Replace:sub(13)

Output(Replace)