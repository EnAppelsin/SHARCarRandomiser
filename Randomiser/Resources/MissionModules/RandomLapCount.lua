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
		local laps = math.random(Settings.MinLapCount, math.max(Settings.MinLapCount + 1, Settings.MaxLapCount))
		InitFile = InitFile:gsub("SetRaceLaps%s*%(%s*(%d+)%s*%);", function(OrigLaps)
			DebugPrint("Changed laps from " .. OrigLaps .. " to " .. laps)
			return "SetRaceLaps(" .. laps .. ");"
		end)
		return LoadFile, InitFile
	end
end