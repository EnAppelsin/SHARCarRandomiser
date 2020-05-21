local function IsValidDialogueRSD(RSDPath)
	if not Exists(RSDPath, true, false) then return false end
	local Channels, Bits, SampleRate = string.unpack("<III", ReadFileOffset(RSDPath, 9, 12))
	return Channels == 1 and Bits == 16 and SampleRate == 24000
end
local function IsValidDialogueOGGVorbis(OGGPath)
	if not Exists(OGGPath, true, false) then return false end
	local Channels, SampleRate = string.unpack("<BI", ReadFileOffset(OGGPath, 40, 5))
	return Channels == 1 and SampleRate == 24000
end

if IsModEnabled("RandomiserDialogue") then
	if Exists("/GameData/RandomDialogue", false, true) then
		DebugPrint("Loading RandomiserDialogue")
		local extensions = {".rsd"}
		if IsHackLoaded("OggVorbisSupport") then
			table.insert(extensions, ".ogg")
		end
		--TODO: FLAC verification support
		--[[if IsHackLoaded("FLACSupport") then
			table.insert(extensions, ".flac")
		end]]
		GetFiles(RandomDialoguePool, "/GameData/RandomDialogue/", extensions, 1)
		DebugPrint("Verifying RandomiserDialogue")
		for i=#RandomDialoguePool,1,-1 do
			DebugPrint("Verifying: "..RandomDialoguePool[i], 2)
			local Path = RandomDialoguePool[i]
			local ext = GetFileExtension(Path):lower()
			if ext == ".ogg" then
				if not IsValidDialogueOGGVorbis(Path) then
					Alert("Invalid RandomiserDialogue file:\r\n" .. Path)
					table.remove(RandomDialoguePool, i)
				end
			elseif ext == ".rsd" then
				if not IsValidDialogueRSD(Path) then
					Alert("Invalid RandomiserDialogue file:\r\n" .. Path)
					table.remove(RandomDialoguePool, i)
				end
			end
		end
		DebugPrint("Loaded " .. #RandomDialoguePool .. " custom dialogue files.")
	else
		if not Confirm("RandomiserDialogue was enabled, but no RandomDialogue folder was found.\n\nTo continue loading the game press OK, to close press Cancel.") then
			os.exit()
		end
	end
elseif not IsHackLoaded("FileSystemRCFs") then
	if not Confirm("You have Random Dialogue enabled without the RandomiserDialogue framework. Random Dialogue will not work without this.\n\nTo continue loading the game press OK, to close press Cancel.") then
		os.exit()
	end
	Settings.RandomDialogue = false
end

local function LoadDialogueFromRCF(Path)
	DebugPrint("Loading RCF: " .. Path, 2)
	if not Exists(Path, true, false) then
		DebugPrint("RCF not found.", 2)
		return
	end
	local Signature = P3D.CleanP3DString(ReadFileOffset(Path, 1, 32))
	if Signature ~= "RADCORE CEMENT LIBRARY" then
		DebugPrint("Invalid signature \"" .. Signature .. "\".", 2)
		return
	end
	local VersionMajor, VersionMinor, BigEndian, NotZero = string.unpack("<bbbb", ReadFileOffset(Path, 33, 4))
	if VersionMajor ~= 1 or VersionMinor ~= 2 or NotZero == 0 then
		DebugPrint("Invalid Versioning:", 2)
		DebugPrint("    VersionMajor: " .. VersionMajor, 2)
		DebugPrint("    VersionMinor: " .. VersionMinor, 2)
		DebugPrint("    NotZero: " .. NotZero, 2)
		return
	end
	local prefix = (BigEndian ~= 0) and ">" or "<"
	local Alignment, Unknown, DirectoryPosition = string.unpack(prefix .. "III", ReadFileOffset(Path, 37, 12))
	local DataEntryCount, NameEntriesPosition, DataPosition, DataEntriesPointer = string.unpack(prefix .. "III<I", ReadFileOffset(Path, DirectoryPosition + 1, 16))
	local Data = ReadFileOffset(Path, DirectoryPosition + 17, DataEntryCount * 12)
	local pos = 1
	for i=1,DataEntryCount do
		local DataEntry = {}
		DataEntry.Hash, DataEntry.Position, DataEntry.Size, pos = string.unpack(prefix .. "III", Data, pos)
		DataEntry.Path = Path
		local Channels, Bits, SampleRate = string.unpack("<III", ReadFileOffset(Path, DataEntry.Position + 9, 12))
		if Channels == 1 and Bits == 16 and SampleRate == 24000 then
			RCFDialoguePool[#RCFDialoguePool + 1] = DataEntry
		else
			DebugPrint("Invalid RSD found", 2)
		end
	end
	DebugPrint("Loaded " .. DataEntryCount .. " RSD files.", 2)
end
LoadDialogueFromRCF("/GameData/dialog.rcf")
LoadDialogueFromRCF("/GameData/dialogs.rcf")
LoadDialogueFromRCF("/GameData/dialogf.rcf")
LoadDialogueFromRCF("/GameData/dialogg.rcf")

RandomDialoguePoolN = #RandomDialoguePool
RCFDialoguePoolN = #RCFDialoguePool
if RandomDialoguePoolN == 0 and RCFDialoguePoolN == 0 then
	if not Confirm("Random Dialogue was enabled, but no dialogue files were loaded.\n\nTo continue loading the game press OK, to close press Cancel.") then
		os.exit()
	end
	Settings.RandomDialogue = false
end