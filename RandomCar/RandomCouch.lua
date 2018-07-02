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

if GetSetting("RandomCouch") then
	local PedN = math.random(#RandomCharP3DPool)
	local Ped = RandomCharP3DPool[PedN]

	local Path = "/GameData/" .. GetPath();
	local Original = ReadFile(Path)
	local ReplacePath = "/GameData/art/chars/" .. Ped .. ".p3d"
	local Replace = ReadFile(ReplacePath)
	local GlobalPath = "/GameData/art/chars/global.p3d"
	local Global = ReadFile(GlobalPath)

	local Adjust = 0

	for position, length in FindSubchunks(Original, SKIN_CHUNK) do
		p3d_debug("Found a skin at " .. position)
		Original = RemoveString(Original, position - Adjust, position + length - Adjust)
		Adjust = Adjust + length
		p3d_debug("> Removed a skin")
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
	SNLength = String1ToInt(NewSkin:sub(SNIndex, SNIndex))
	local SkinSkelName, SNLength = GetP3DString(NewSkin, SNIndex)
	NewSkin = NewSkin:sub(1, SNIndex - 1) .. MOTION_ROOT_LABEL .. NewSkin:sub(SNIndex + SNLength + 1)
	local HeaderLength = String4ToInt(NewSkin:sub(5, 8))
	HeaderLength = HeaderLength - SNLength + 12
	local HeaderBytes = IntToString4(HeaderLength)
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
end