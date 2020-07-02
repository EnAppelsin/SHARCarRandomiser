local args = {...}
local tbl = args[1]
if Settings.RandomLapCount then	
	local sort = 5
	local Mission = {}
	local SundayDrive = {}
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	
	function Mission.RandomLapCount(LoadFile, InitFile, Level, Mission, Path)
		local oLaps
		local laps = math.random(Settings.MinLapCount, math.max(Settings.MinLapCount + 1, Settings.MaxLapCount))
		InitFile = InitFile:gsub("SetRaceLaps%s*%(%s*(%d+)%s*%);", function(OrigLaps)
			oLaps = OrigLaps
			DebugPrint("Changed laps from " .. OrigLaps .. " to " .. laps)
			return "SetRaceLaps(" .. laps .. ");"
		end)
		if oLaps then
			InitFile = InitFile:gsub("SetStageTime%s*%(%s*(%d+)%s*%);", function(OrigTime)
				local PerLap = OrigTime / oLaps
				local NewTime = math.floor(PerLap * laps)
				DebugPrint("Changed race time from " .. OrigTime .. " to " .. NewTime)
				return "SetStageTime(" .. NewTime .. ");"
			end)
		end
		return LoadFile, InitFile
	end
end