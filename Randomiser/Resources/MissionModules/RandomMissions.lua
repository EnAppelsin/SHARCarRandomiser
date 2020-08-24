local args = {...}
local tbl = args[1]
if Settings.RandomMissions then
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	local function Level_RandomMissions(LoadFile, InitFile, Level, Path)
		local missions = {}
		for mission in LoadFile:gmatch("AddMission%s*%(%s*\"m(%d)\"") do
			if tonumber(mission) < 8 then
				table.insert(missions, mission)
			end
		end
		LoadFile = LoadFile:gsub("AddMission%s*%(%s*\"m(%d)\"", function(orig)
			local mission = tonumber(orig)
			if mission < 8 then
				local tmp = {table.unpack(missions)}
				local exists = ExistsInTbl(tmp, orig, false)
				if exists then
					if #tmp > 1 then
						for i = #tmp, 1, -1 do
							if tmp[i] == orig then
								table.remove(tmp, i)
								break
							end
						end
					end
				end
				local newMission = GetRandomFromTbl(tmp, true)
				if exists then
					table.insert(tmp, orig)
				end
				missions = {table.unpack(tmp)}
				DebugPrint("Randomised mission " .. orig .. " to " .. newMission, 1)
				return "AddMission(\"m" .. newMission .. "\""
			else
				return "AddMission(\"m" .. orig .. "\""
			end
		end)
		return LoadFile, InitFile
	end
	
	if Settings.IsSeeded then
		Seed.AddSpoiler("-- RandomMissions --")
		Seed.RandomMissions = Seed.CacheFullLevel(Level_RandomMissions)
		Level.RandomMissions = Seed.ReturnFullLevel(Seed.RandomMissions)
	else
		Level.RandomMissions = Level_RandomMissions
	end
end