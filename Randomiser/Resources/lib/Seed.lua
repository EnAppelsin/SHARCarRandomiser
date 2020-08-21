Seed = {}
Seed.Spoiler = {}

Seed.MAX_LEVELS = 7
Seed.MAX_MISSIONS = 15

local MAX_ATTEMPTS = 5

-- Special Base64 Array to avoid "similar" letters
Seed._bs = { [0] =
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
   'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
   'g','h','%','j','k','&','m','n','o','p','q','r','s','t','u','v',
   'w','x','y','z','0','$','2','3','4','5','6','7','8','9','+','/',
}

-- Inverse lookup for base64
Seed._bsi = {}
for i=0,#Seed._bs do
	Seed._bsi[string.byte(Seed._bs[i])] = i
end

function Seed.Base64(s)
	return base64(s, Seed._bs):sub(1, -2)
end

function Seed.Base64dec(s)
	return base64dec(s .. "=", Seed._bs, Seed._bsi)
end

function Seed.MissionToIndex(Mission, Type)
	local MissIdx = Mission + 1
	if Type == MissionType.Race then
		MissIdx = MissIdx + 10
	elseif Type == MissionType.BonusMission then
		MissIdx = 9
	elseif Type == MissionType.GamblingRace then
		MissIdx = 15
	end
	return MissIdx
end

function Seed.MakeChoices(choice, idx1, idx2)
	local mkrand = nil
	if choice == nil then
		mkrand = function()
			return math.random(), ""
		end
	elseif type(choice) == "number" then
		mkrand = function()
			return math.random(choice), ""
		end
	elseif type(choice) == "function" then
		mkrand = choice
	else
		mkrand = function()
			local r =  math.random(#choice)
			return r, string.format("(%s)", choice[r])
		end
	end
	local tbl = { Attempt = {}, Choices = {} }
	for i1=1,idx1 do
		if idx2 == nil then 
			tbl.Choices[i1] = {}
			tbl.Attempt[i1] = 1
			for m=1,MAX_ATTEMPTS do
				local txt
				tbl.Choices[i1][m], txt = mkrand()
				Seed.AddSpoiler("[%d][%d] = %s %s", i1, m, tbl.Choices[i1][m], txt)
			end
		else
			tbl.Choices[i1] = {}
			tbl.Attempt[i1] = {}
			for i2=1,idx2 do
				tbl.Choices[i1][i2] = {}
				tbl.Attempt[i1][i2] = 1
				for m=1,MAX_ATTEMPTS do
					local txt
					tbl.Choices[i1][i2][m], txt = mkrand()
					Seed.AddSpoiler("[%d][%d][%d] = %s %s", i1, i2, m, tbl.Choices[i1][i2][m], txt)
				end
			end
		end
	end	
	return tbl
end

function Seed.GetChoice(choices, idx1, idx2)
	if idx2 == nil then
		local rv = choices.Choices[idx1][choices.Attempt[idx1]]
		choices.Attempt[idx1] = choices.Attempt[idx1] + 1
		if choices.Attempt[idx1] > MAX_ATTEMPTS then
			choices.Attempt[idx1] = 1
		end
		return rv
	else
		local rv = choices.Choices[idx1][idx2][choices.Attempt[idx1][idx2]]
		choices.Attempt[idx1][idx2] = choices.Attempt[idx1][idx2] + 1
		if choices.Attempt[idx1][idx2] > MAX_ATTEMPTS then
			choices.Attempt[idx1][idx2] = 1
		end
		return rv
	end
end

function Seed.CacheFullLevel(level_func)
	-- Pretend levels is either known or has been computed beforehand (for now it's just coded)
	local tbl = {}
	for i=1,Seed.MAX_LEVELS do
		tbl[i] = {}
		Seed.AddSpoiler("Caching level: %s", i)			
		local Path = string.format("/GameData/scripts/missions/level%02d/level.mfk", i)
		local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
		local InitFile = ReadFile(Path:gsub("level%.mfk", "leveli.mfk")):gsub("//.-([\r\n])", "%1");
		local old_DebugPrint = DebugPrint
		DebugPrint = function(msg, level)
			Seed.AddSpoiler(msg)
		end
		tbl[i].LoadFile, tbl[i].InitFile = level_func(LoadFile, InitFile, i, Path)
		DebugPrint = old_DebugPrint
	end
	return tbl
end

function Seed.ReturnFullLevel(tbl)
	return function(LoadFile, InitFile, Level, Path)
		return tbl[Level].LoadFile, tbl[Level].InitFile
	end
end

function Seed.CacheFullMission(mission_func)
	-- Pretend levels is either known or has been computed beforehand (for now it's just coded)
	local tbl = {}
	for i=1,Seed.MAX_LEVELS do
		local path = string.format("/GameData/scripts/missions/level%02d/", i)
		local files = {}
		GetFiles(files, path, {".mfk"})
		for j=1,#files do
			local Path = files[j]
			local prefix, mission = Path:match("([bsg]?[rm])(%d)l")
			if prefix == nil or mission == nil then 
				goto continue
			end
			Seed.AddSpoiler("Caching mission: %s", Path)			
			tbl[Path] = {}
			mission = tonumber(mission)
			local misstype
			if prefix == "m" then
				misstype = MissionType.Normal
			elseif prefix == "sr" then
				misstype = MissionType.Race
			elseif prefix == "bm" then
				misstype = MissionType.BonusMission
			elseif prefix == "gr" then
				misstype = MissionType.GamblingRace
			else
				error("unknown mission script type")
			end
			local LoadFile = ReadFile(Path):gsub("//.-([\r\n])", "%1");
			local InitFile = ReadFile(Path:gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
			local old_DebugPrint = DebugPrint
			DebugPrint = function(msg, level)
				Seed.AddSpoiler(msg)
			end
			tbl[Path].LoadFile, tbl[Path].InitFile = mission_func(LoadFile, InitFile, i, mission, Path, misstype)
			DebugPrint = old_DebugPrint
			::continue::
		end
	end
	return tbl
end

function Seed.ReturnFullMission(tbl)
	return function(LoadFile, InitFile, Level, Mission, Path)
		return tbl[Path].LoadFile, tbl[Path].InitFile
	end
end

function Seed.Init()
	if Settings.Seed == nil or Settings.Seed == "" then
		local number = math.random(math.maxinteger)
		Settings.Seed = Seed.Base64(string.pack("j", number))
		Seed.SeedRaw = number
		DebugPrint("Generated a new seed: " .. Settings.Seed)
	else
		if (Settings.Seed:len() > 11) then
			Alert("Your seed was longer than 11 characters, characters after this won't affect the seed or the randomness")
		end
		local raw = Seed.Base64dec(Settings.Seed)
		if raw:len() < 16 then
			raw = raw .. string.rep("\0", 16 - raw:len())
		end
		Seed.SeedRaw = string.unpack("j", raw)
	end
	DebugPrint("Initialising RNG with Seed: " .. Seed.SeedRaw)
	math.randomseed(Seed.SeedRaw)
end

function Seed.AddSpoiler(f, ...)
	Seed.Spoiler[#Seed.Spoiler + 1] = string.format(f, ...)
end

function Seed.PrintSpoiler()
	print("--- BEGIN SEED SPOILERS ---")
	print(base64(table.concat(Seed.Spoiler, "\n")))
	print("--- END SPOILERS ---")
end
