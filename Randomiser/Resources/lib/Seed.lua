Seed = {}
Seed.Spoiler = {}

Seed.MAX_LEVELS = 7
Seed.MAX_MISSIONS = 15

local MAX_ATTEMPTS_MISSIONS = 5
local MAX_ATTEMPTS_LEVELS = 1

Seed.CachedLevel = {}
Seed.CachedMission = {}
Seed.CachedSDMission = {}

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

-- Always iterate modules in Seeded mode with spairs which runs in a deterministic order!
-- Otherwise the seeded is still random!
local function spairs(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

function Seed.InternalCacheModulesLevel(i) 
	Seed.AddSpoiler("Caching level: %s", i)
	local Path = string.format("/GameData/scripts/missions/level%02d/level.mfk", i)
	-- Generate structure for seeded level files
	if Seed.CachedLevel[Path] == nil then
		Seed.CachedLevel[Path] = {}
		Seed.CachedLevel[Path].Attempt = 1
		Seed.CachedLevel[Path].LoadFile = {}
		Seed.CachedLevel[Path].InitFile = {}
		Seed.CachedLevel[Path].Globals = {}
		for j=1,MAX_ATTEMPTS_LEVELS do
			Seed.CachedLevel[Path].LoadFile[j] = ReadFile(Path):gsub("//.-([\r\n])", "%1");
			Seed.CachedLevel[Path].InitFile[j] = ReadFile(Path:gsub("level%.mfk", "leveli.mfk")):gsub("//.-([\r\n])", "%1");
			Seed.CachedLevel[Path].Globals[j] = {}
		end
	end
	
	local old_DebugPrint = DebugPrint
	DebugPrint = function(msg, level)
		Seed.AddSpoiler(msg)
	end
	for j=1,MAX_ATTEMPTS_LEVELS do
		Seed.AddSpoiler("Seeding attempt #%d", j)
		for l = LevelMin,LevelMax do
			if MissionModules.Level[l] then
				for k, v in spairs(MissionModules.Level[l]) do
					Seed.AddSpoiler("Running module: " .. k)
					local globals, g2
					Seed.CachedLevel[Path].LoadFile[j], Seed.CachedLevel[Path].InitFile[j], globals = v(Seed.CachedLevel[Path].LoadFile[j],  Seed.CachedLevel[Path].InitFile[j], i, Path)
					if globals ~= nil then
						g2 = {}
						for kk, vv in pairs(globals) do
							g2[vv] = _G[vv]
						end
						Seed.CachedLevel[Path].Globals[j] = MergeTable(Seed.CachedLevel[Path].Globals[j], g2)
					end
				end
			end
		end
	end
	DebugPrint = old_DebugPrint
end

function Seed.InternalCacheModuleMission(i, Path, j, prefix, mission)
	Seed.AddSpoiler("Caching mission: %s", Path)
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
	
	-- Generate structure for seeded mission files
	if Seed.CachedMission[Path] == nil then
		Seed.CachedMission[Path] = {}
		Seed.CachedMission[Path].Attempt = 1
		Seed.CachedMission[Path].LoadFile = {}
		Seed.CachedMission[Path].InitFile = {}
		Seed.CachedMission[Path].Globals = {}
		for m=1,MAX_ATTEMPTS_MISSIONS do
			Seed.CachedMission[Path].LoadFile[m] = ReadFile(Path):gsub("//.-([\r\n])", "%1");
			Seed.CachedMission[Path].InitFile[m] = ReadFile(Path:gsub("l%.mfk", "i.mfk")):gsub("//.-([\r\n])", "%1");
			Seed.CachedMission[Path].Globals[m] = {}
		end
	end
	
	local old_DebugPrint = DebugPrint
	DebugPrint = function(msg, level)
		Seed.AddSpoiler(msg)
	end
	for m=1,MAX_ATTEMPTS_MISSIONS do
		Seed.AddSpoiler("Seeding attempt #%d", m)
		for l = MissionMin,MissionMax do
			if MissionModules.Mission[l] then
				for k, v in spairs(MissionModules.Mission[l]) do
					Seed.AddSpoiler("Running module: " .. k)
					local globals, g2
					Seed.CachedMission[Path].LoadFile[m], Seed.CachedMission[Path].InitFile[m], globals = v(Seed.CachedMission[Path].LoadFile[m],  Seed.CachedMission[Path].InitFile[m], i, mission, Path, misstype)
					if globals ~= nil then
						g2 = {}
						for kk, vv in pairs(globals) do
							g2[vv] = _G[vv]
						end
						Seed.CachedMission[Path].Globals[m] = MergeTable(Seed.CachedMission[Path].Globals[m], g2)
					end
				end
			end
		end
	end
	DebugPrint = old_DebugPrint
end

function Seed.InternalCacheModuleSDMission(i, Path, j, prefix, mission)
	Seed.AddSpoiler("Caching SD mission: %s", Path)
	mission = tonumber(mission)
	
	-- Generate structure for seeded sunday drive files
	if Seed.CachedSDMission[Path] == nil then
		Seed.CachedSDMission[Path] = {}
		Seed.CachedSDMission[Path].Attempt = 1
		Seed.CachedSDMission[Path].LoadFile = {}
		Seed.CachedSDMission[Path].InitFile = {}
		Seed.CachedSDMission[Path].Globals = {}
		for m=1,MAX_ATTEMPTS_MISSIONS do
			Seed.CachedSDMission[Path].LoadFile[m] = ReadFile(Path):gsub("//.-([\r\n])", "%1");
			Seed.CachedSDMission[Path].InitFile[m] = ReadFile(Path:gsub("sdl%.mfk", "sdi.mfk")):gsub("//.-([\r\n])", "%1");
			Seed.CachedSDMission[Path].Globals[m] = {}
		end
	end
	
	local old_DebugPrint = DebugPrint
	DebugPrint = function(msg, level)
		Seed.AddSpoiler(msg)
	end
	for m=1,MAX_ATTEMPTS_MISSIONS do
		Seed.AddSpoiler("Seeding attempt #%d", m)
		for i = SundayMin,SundayMax do
			if MissionModules.SundayDrive[l] then
				for k, v in spairs(MissionModules.SundayDrive[l]) do
					Seed.AddSpoiler("Running module: " .. k)
					local globals, g2
					Seed.CachedSDMission[Path].LoadFile[m], Seed.CachedSDMission[Path].InitFile[m], globals = v(Seed.CachedSDMission[Path].LoadFile[m],  Seed.CachedSDMission[Path].InitFile[m], i, mission, Path)
					if globals ~= nil then
						g2 = {}
						for kk, vv in pairs(globals) do
							g2[vv] = _G[vv]
						end
						Seed.CachedSDMission[Path].Globals[m] = MergeTable(Seed.CachedSDMission[Path].Globals[m], g2)
					end
				end
			end
		end
	end
	DebugPrint = old_DebugPrint
end

function Seed.CacheModulesMission() 
	for i=1,Seed.MAX_LEVELS do
		Seed.InternalCacheModulesLevel(i)
		local path = string.format("/GameData/scripts/missions/level%02d/", i)
		local files = {}
		GetFiles(files, path, {".mfk"})
		for j=1,#files do
			local Path = files[j]
			local prefix, mission = Path:match("([bsg]?[rm])(%d)l")
			if prefix ~= nil and mission ~= nil then 
				Seed.InternalCacheModuleMission(i, Path, j, prefix, mission)
			end
			mission = Path:match("m(%d)sdl")
			if mission ~= nil then
				Seed.InternalCacheModuleSDMission(i, Path, j, prefix, mission)
			end
		end
	end
end

function Seed.HandleModulesLevel(Path)
	if Seed.CachedLevel[Path] == nil then
		DebugPrint("Request for Path " .. Path .. " was not seeded, falling back to normal generation")
		return
	end
	local Attempt = Seed.CachedLevel[Path].Attempt
	
	DebugPrint("Returning cached mission for Path " .. Path .. ", Attempt is " .. Attempt)
	
	local LoadFile = Seed.CachedLevel[Path].LoadFile[Attempt]
	local InitFile = Seed.CachedLevel[Path].InitFile[Attempt]
	for kk, vv in pairs(Seed.CachedLevel[Path].Globals[Attempt]) do
		_G[vv] = Seed.CachedLevel[Path].Globals[Attempt][vv]
	end
	
	LevelInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("Level Load File:\r\n" .. LoadFile)
		DebugPrint("Level Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
	
	Attempt = Attempt + 1
	if Attempt > MAX_ATTEMPTS_LEVELS then
		Attempt = 1
	end
	Seed.CachedLevel[Path].Attempt = Attempt
end

function Seed.HandleModulesMission(Path)
	if Seed.CachedMission[Path] == nil then
		DebugPrint("Request for Path " .. Path .. " was not seeded, falling back to normal generation")
		return
	end
	local Attempt = Seed.CachedMission[Path].Attempt
	
	DebugPrint("Returning cached mission for Path " .. Path .. ", Attempt is " .. Attempt)
	
	local LoadFile = Seed.CachedMission[Path].LoadFile[Attempt]
	local InitFile = Seed.CachedMission[Path].InitFile[Attempt]
	for kk, vv in pairs(Seed.CachedMission[Path].Globals[Attempt]) do
		_G[vv] = Seed.CachedMission[Path].Globals[Attempt][vv]
	end
	
	MissionInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("Mission Load File:\r\n" .. LoadFile)
		DebugPrint("Mission Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
	
	Attempt = Attempt + 1
	if Attempt > MAX_ATTEMPTS_MISSIONS then
		Attempt = 1
	end
	Seed.CachedMission[Path].Attempt = Attempt
end

function Seed.HandleModulesSDMission(Path)
	if Seed.CachedSDMission[Path] == nil then
		DebugPrint("Request for Path " .. Path .. " was not seeded, falling back to normal generation")
		return
	end
	local Attempt = Seed.CachedSDMission[Path].Attempt
	
	DebugPrint("Returning cached mission for Path " .. Path .. ", Attempt is " .. Attempt)
	
	local LoadFile = Seed.CachedSDMission[Path].LoadFile[Attempt]
	local InitFile = Seed.CachedSDMission[Path].InitFile[Attempt]
	for kk, vv in pairs(Seed.CachedSDMission[Path].Globals[Attempt]) do
		_G[vv] = Seed.CachedSDMission[Path].Globals[Attempt][vv]
	end
	
	LastLevel = nil
	PlayerStats = nil
	SDInit = InitFile
	if Settings.DebugLevel >= 5 then
		DebugPrint("SD Load File:\r\n" .. LoadFile)
		DebugPrint("SD Init File:\r\n" .. InitFile)
	end
	Output(LoadFile)
	
	Attempt = Attempt + 1
	if Attempt > MAX_ATTEMPTS_MISSIONS then
		Attempt = 1
	end
	Seed.CachedSDMission[Path].Attempt = Attempt
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
