local args = {...}
local tbl = args[1]
if Settings.SkipFMVs then
	local sort = 5
	local Mission = {}
	local SundayDrive = {}
	if not tbl.Mission[sort] then
		tbl.Mission[sort] = Mission
	else
		Mission = tbl.Mission[sort]
	end
	if not tbl.SundayDrive[sort] then
		tbl.SundayDrive[sort] = SundayDrive
	else
		SundayDrive = tbl.SundayDrive[sort]
	end
	
	function SundayDrive.SkipFMVs(LoadFile, InitFile, Level, Mission, Path)
		InitFile = InitFile:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
		return LoadFile, InitFile
	end
	Mission.SkipFMVs = SundayDrive.SkipFMVs
end