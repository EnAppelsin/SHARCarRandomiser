local args = {...}
local tbl = args[1]
if Settings.SkipFMVs then
	function tbl.SundayDrive.SkipFMVs(LoadFile, InitFile, Level, Mission, Path)
		InitFile = InitFile:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
		return LoadFile, InitFile
	end
	
	function tbl.Mission.SkipFMVs(LoadFile, InitFile, Level, Mission, Path)
		InitFile = InitFile:gsub("AddObjective%s*%(\"fmv\"%s*%);.-CloseObjective%s*%(%s*%);", "AddObjective(\"timer\");\r\nSetDurationTime(1);\r\nCloseObjective();", 1)
		return LoadFile, InitFile
	end
end