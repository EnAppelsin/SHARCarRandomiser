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

if Settings.RandomCouch then
	local PedN = math.random(#RandomCharP3DPool)
	local Ped = RandomCharP3DPool[PedN]

	local Path = "/GameData/" .. GetPath();
	local Original = ReadFile(Path)
	local ReplacePath = "/GameData/art/chars/" .. Ped .. ".p3d"
	local Replace = ReadFile(ReplacePath)
	local GlobalPath = "/GameData/art/chars/global.p3d"
	local Global = ReadFile(GlobalPath)
    
    -- Easter egg?
    if math.random(1, 20) == 1 then
        local AniPos, AniLength = FindSubchunk(Original, ANIMATION_CHUNK)
        local Ani = Original:sub(AniPos, AniPos + AniLength - 1)
        local AniGroupPos, AniGroupLength = FindSubchunk(Ani, ANIMATION_GROUP_CHUNK)
        Original = RemoveString(Original, AniPos + AniGroupPos - 1, AniPos + AniGroupPos - 1 + AniGroupLength)
        Original = AddP3DInt4(Original, AniPos + 8, -AniGroupLength)
    end

	local Adjust = 0

	for position, length in FindSubchunks(Original, SKIN_CHUNK) do
		p3d_debug("Found a skin at " .. position)
		Original = RemoveString(Original, position - Adjust, position + length - Adjust)
		Adjust = Adjust + length
		DebugPrint("> Removed a skin", 5)
	end

	local Textures = ""

	for position, length in FindSubchunks(Global, TEXTURE_CHUNK) do
		Textures = Textures .. Global:sub(position, position + length - 1)
	end

	for position, length in FindSubchunks(Replace, TEXTURE_CHUNK) do
		Textures = Textures .. Replace:sub(position, position + length - 1)
	end

	local Shaders = ""
	local ShaderList = {}

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
            Adjust = Adjust + length
		end
	end

	-- Load the skin from the replacement
	local NewSkinL, Length = FindSubchunk(Replace, SKIN_CHUNK)
	p3d_debug("New skin as at " .. NewSkinL)
	local NewSkin = Replace:sub(NewSkinL, NewSkinL + Length - 1)
	local NewSkinName, SNLength = GetP3DString(NewSkin, 13)
	p3d_debug("> New skin name is " .. NewSkinName)
	-- Update the skeleton
	local SNIndex = SNLength + 18
    local Delta
    NewSkin, Delta = SetP3DString(NewSkin, SNIndex, MOTION_ROOT_LABEL)
    NewSkin = AddP3DInt4(NewSkin, 5, Delta)
    NewSkin = AddP3DInt4(NewSkin, 9, Delta)
    

	-- Find the original skeleton
	local SKIndex, SKLength = FindSubchunk(Original, SKELETON_CHUNK)
	p3d_debug("Original Skeleton as at " .. SKIndex)

	-- Load the skeleton from the replacement
	local NewSkelL, Length = FindSubchunk(Replace, SKELETON_CHUNK)
	p3d_debug("New skeleton as at " .. NewSkelL)
	local NewSkel = Replace:sub(NewSkelL, NewSkelL + Length - 1)

	-- Update the skeleton name
	local OrigSkelName, SNLength = GetP3DString(NewSkel, 13)
	p3d_debug("Original skeleton name is " .. OrigSkelName)
	NewSkel, Delta =  SetP3DString(NewSkel, 13, MOTION_ROOT_LABEL)
	NewSkel = AddP3DInt4(NewSkel, 5, Delta)
    NewSkel = AddP3DInt4(NewSkel, 9, Delta)

	DebugPrint("Replacing skeleton and adding skin to couch model", 5)
	Original = Original:sub(1, SKIndex - 1) .. Textures .. Shaders .. NewSkel .. NewSkin .. Original:sub(SKIndex + SKLength)

	local CDIndex, CDLength = FindSubchunk(Original, COMP_DRAW_CHUNK)
	local CD = Original:sub(CDIndex, CDIndex + CDLength - 1)

	local CDSLIndex, CDSLLength = FindSubchunk(CD, COMP_DRAW_SKIN_LIST_SUBCHUNK)
	local CDSL = CD:sub(CDSLIndex, CDSLIndex + CDSLLength - 1)


	local positions = {}
	for i in FindSubchunks(CDSL, COMP_DRAW_SKIN_SUBCHUNK) do
		table.insert(positions, i)
	end

	Adjust = 0

	for i = 1,#positions-1 do
		p3d_debug("Composite drawable skin at " .. positions[i])
		local LengthStr = Original:sub(CDIndex + CDSLIndex + positions[i] + 8 - 2 - Adjust, CDIndex + CDSLIndex + positions[i] + 11 - Adjust - 2)
		local Length = String4ToInt(LengthStr)
		Original = RemoveString(Original, CDIndex + CDSLIndex + positions[i] - 2 - Adjust, CDIndex + CDSLIndex + positions[i] + Length - Adjust - 2)
		Adjust = Adjust + Length
		DebugPrint("Removed the composite drawable skin", 5)
	end

	-- Patch the last composite drawable skin
	local LastCDS = CDIndex + CDSLIndex +  positions[#positions] - Adjust - 2

	p3d_debug("> Changing comp drawable name to " .. NewSkinName)
    Original, Delta = SetP3DString(Original, LastCDS + 12, NewSkinName)
    Original = AddP3DInt4(Original, LastCDS + 4, Delta)
    Original = AddP3DInt4(Original, LastCDS + 8, Delta)

	Adjust = Adjust - Delta

	DebugPrint("Patching composite drawable skin list", 5)
    Original = SetP3DInt4(Original, CDIndex + CDSLIndex + 8 - 1, CDSLLength - Adjust)
    Original = SetP3DInt4(Original, CDIndex + CDSLIndex + 12 - 1, 1)

	DebugPrint("Patching composite drawable length", 5)
    Original = SetP3DInt4(Original, CDIndex + 8, CDLength - Adjust)

	DebugPrint("Patching total file length", 5)
    Original = SetP3DInt4(Original, 9, Original:len())

	DebugPrint ("Couch modified with model from " .. ReplacePath)

	Output(Original)
end