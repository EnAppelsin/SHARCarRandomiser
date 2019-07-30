local args = {...}
local tbl = args[1]
if Settings.RandomTraffic then
	function tbl.Level.RandomTraffic(LoadFile, InitFile, Level)
		TrafficCars = {}
		local TmpCarPool = {table.unpack(RandomCarPoolTraffic)}
		local Cars = ""
		for i = 1, math.min(5, #TmpCarPool) do
			local carName = GetRandomFromTbl(TmpCarPool, true)
			table.insert(TrafficCars, carName)
			Cars = Cars .. carName .. ", "
		end
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. carName .. ".p3d\");"
		end
		LoadFile = LoadFile:gsub("SuppressDriver%s*%(\"([^\n]-)\"%s*%);", "//SuppressDriver(\"%1\");")
		DebugPrint("Random traffic cars for level -> " .. Cars)
		
		RemovedTrafficCars = {}
		InitFile = InitFile:gsub("CreateTrafficGroup", "//CreateTrafficGroup", 1)
		InitFile = InitFile:gsub("AddTrafficModel%s*%(%s*\"(.-)\"", function(car)
			table.insert(RemovedTrafficCars, car)
			return "//AddTrafficModel(\"" .. car .. "\"" --( "minivanA"
		end)
		InitFile = InitFile:gsub("CloseTrafficGroup", "//CloseTrafficGroup", 1)
		InitFile = InitFile .. "\r\nCreateTrafficGroup( 0 );"
		for i = 1, #TrafficCars do
			local carName = TrafficCars[i]
			local amount = 1
			if i == 1 then
				if #TrafficCars == 4 then
					amount = 2
				elseif #TrafficCars == 3 then
					amount = 3
				elseif #TrafficCars == 2 then
					amount = 4
				elseif #TrafficCars == 1 then
					amount = 5
				end
			end
			InitFile = InitFile .. "\r\nAddTrafficModel( \"" .. carName .. "\"," .. amount .. " );"
		end
		InitFile = InitFile .. "\r\nCloseTrafficGroup( );"
		return LoadFile, InitFile
	end
end