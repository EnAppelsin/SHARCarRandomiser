local math_min = math.min
local math_random = math.random
local string_format = string.format
local string_lower = string.lower
local string_pack = string.pack
local string_rep = string.rep
local string_sub = string.sub
local string_unpack = string.unpack
local table_concat = table.concat

local GetFileExtension = GetFileExtension

local RandomDialog = Module("Random Dialog", "RandomDialog")

local RandomDialogMode = Settings.RandomDialogMode

local RSDFiles = {}
local RSDFilesN = 0

local RSDSignature = "RSD4RADP"
local function LoadRSDsFromRCF(Path)
	local RCFFile = RCF.RCFFile(Path)
	
	local loaded = 0
	for i=1,#RCFFile.Files do
		local file = RCFFile.Files[i]
		if string_lower(GetFileExtension(file.Name)) == ".rsd" then
			local Signature, Channels, Bits, SampleRate = string_unpack("<c8III", file.Data)
			if Signature == RSDSignature and Channels == 1 and Bits == 16 and SampleRate == 24000 then
				RSDFiles[#RSDFiles + 1] = file
				file.Name = Path .. "/" .. file.Name
				loaded = loaded + 1
			else
				Alert(string_format("Invalid dialog file found.\n\nRCF File: %s\nFile name: %s\nSignature: %s\nChannels: %i\nBits: %i\nSample Rate: %i", Path, file.Name, Signature, Channels, Bits, SampleRate))
			end
		end
	end
	return loaded
end

if Settings[RandomDialog.Setting] then
	if not Settings.RandomDialogEnglish and not Settings.RandomDialogFrench and not Settings.RandomDialogGerman and not Settings.RandomDialogSpanish then
		Alert("You've chosen to enable \"Random Dialog\", with no languages selected. You must choose at least one language.")
		os.exit()
	end
	
	if Settings.RandomDialogEnglish then
		local DialogPath = "/GameData/dialog.rcf"
		if not Exists(DialogPath, true, false) then
			Alert("You've chosen to enable \"Include English\", but \"dialog.rcf\" is not present in the game directoy. This file is required for English dialog.")
			os.exit()
		end
		
		print(string_format("Loaded %i English dialog lines.", LoadRSDsFromRCF(DialogPath)))
	end
	
	if Settings.RandomDialogFrench then
		local DialogPath = "/GameData/dialogf.rcf"
		if not Exists(DialogPath, true, false) then
			Alert("You've chosen to enable \"Include French\", but \"dialogf.rcf\" is not present in the game directoy. This file is required for French dialog.")
			os.exit()
		end
		
		print(string_format("Loaded %i French dialog lines.", LoadRSDsFromRCF(DialogPath)))
	end
	
	if Settings.RandomDialogGerman then
		local DialogPath = "/GameData/dialogg.rcf"
		if not Exists(DialogPath, true, false) then
			Alert("You've chosen to enable \"Include German\", but \"dialogg.rcf\" is not present in the game directoy. This file is required for German dialog.")
			os.exit()
		end
		
		print(string_format("Loaded %i German dialog lines.", LoadRSDsFromRCF(DialogPath)))
	end
	
	if Settings.RandomDialogSpanish then
		local DialogPath = "/GameData/dialogs.rcf"
		if not Exists(DialogPath, true, false) then
			Alert("You've chosen to enable \"Include Spanish\", but \"dialogs.rcf\" is not present in the game directoy. This file is required for Spanish dialog.")
			os.exit()
		end
		
		print(string_format("Loaded %i Spanish dialog lines.", LoadRSDsFromRCF(DialogPath)))
	end
	
	RSDFilesN = #RSDFiles
	if RSDFilesN == 0 then
		Alert("You've chosen to enable \"Random Dialog\", but no dialog files were found.")
		os.exit()
	end
end

local function HandleDialog(Path, Contents)
	if RandomDialogMode == 1 or (RandomDialogMode == 3 and math.random(2) == 1) then -- Normal or 50% on Mixed
		local RSDFile = RSDFiles[math_random(RSDFilesN)]
		print("Replacing dialog \"" .. Path .. "\" with: " .. RSDFile.Name)
		return true, RSDFile.Data
	else -- Super Random or 50% on Mixed
		print("Replacing dialog \"" .. Path .. "\" with super random dialog")
		local header = string_pack("<c8III", RSDSignature, 1, 16, 24000) .. string_rep("*", 108) .. string_rep("-", 1920)
		local frameSize = 20 -- * Channels, which is 1
		
		local Output = {header}
		local OutputN = 1
		
		local OrigFrames = (#Contents - 2048) / frameSize
		
		local frameCount = 0
		while frameCount < OrigFrames do
			local RSDFile = RSDFiles[math_random(RSDFilesN)]
			local AudioData = string_sub(RSDFile.Data, 2049)
			
			local BlockCount = #AudioData / frameSize
			
			local StartBlock = math_random(BlockCount)
			local EndBlock = math_min(BlockCount, StartBlock + math_random(700, 1000))
			
			frameCount = frameCount + EndBlock - StartBlock
			
			OutputN = OutputN + 1
			Output[OutputN] = string_sub(AudioData, StartBlock * frameSize + 1, EndBlock * frameSize)
		end
		return true, table_concat(Output)
	end
	return false
end

RandomDialog:AddGenericHandler("*c_*_*_convinit*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*c_*_*_noboxconv*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*c_*_*_tutorial*.rsd", HandleDialog)

RandomDialog:AddGenericHandler("*d_aidestroy*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_air*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_answer*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_arrive*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_bcrash*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_break*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_burn*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_carway*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_damage*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_dcar*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_destroy*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_door*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_hitp*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_mcrash*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_missp*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*d_time*.rsd", HandleDialog)

RandomDialog:AddGenericHandler("*p_hitbyc*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*p_hitbyw*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*p_nhitbyc*.rsd", HandleDialog)

RandomDialog:AddGenericHandler("*v_damage*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*v_hitcar*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*v_mfail*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*v_mvic*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*v_tail*.rsd", HandleDialog)

RandomDialog:AddGenericHandler("*w_activate*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_aidestroy*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_air*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_answer*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_arrive*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_askfood*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_askride*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_bcrash*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_breakca*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_break*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_burn*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_card*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_carway*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_carbuy*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_char*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_damage*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_dcar*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_dodge*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_doorbell*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_fall*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_foodreply*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_gic*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_goc*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_greeting*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_idle*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_idlereply*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_hitbyc*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_hitp*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_longjump*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_mcrash*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_mfail*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_missa*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_missp*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_mstart*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_mvic*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_newai*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_objectw*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_passed*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_pass*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_ridereply*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_springboard*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_tail*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_time*.rsd", HandleDialog)
RandomDialog:AddGenericHandler("*w_turbo*.rsd", HandleDialog)

return RandomDialog