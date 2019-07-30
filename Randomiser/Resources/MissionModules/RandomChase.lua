local args = {...}
local tbl = args[1]
if Settings.RandomChase then
	function tbl.Level.RandomChase(LoadFile, InitFile, Level)
		RandomChase = GetRandomFromTbl(RandomCarPoolChase, false)
		LoadFile = LoadFile .. "\r\nLoadP3DFile(\"art\\cars\\" .. RandomChase .. ".p3d\");"
		DebugPrint("Random chase cars for level -> " .. RandomChase)
		
		if Settings.RandomChaseStats or Settings.RandomStats then
			InitFile = InitFile:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\",\"" .. RandomChase .. ".con\"", 1)
		else
			InitFile = InitFile:gsub("CreateChaseManager%s*%(%s*\"[^\n]-\"", "CreateChaseManager(\"" .. RandomChase .."\"", 1)
		end
		if Settings.RandomChaseAmount then
			local chaseAmount = math.random(1, 5)
			InitFile = InitFile:gsub("SetNumChaseCars%s*%(%s*\"[^\n]-\"", "SetNumChaseCars(\"" .. chaseAmount .."\"", 1)
			DebugPrint("Random chase amount -> " .. chaseAmount)
		end
		return LoadFile, InitFile
	end
end