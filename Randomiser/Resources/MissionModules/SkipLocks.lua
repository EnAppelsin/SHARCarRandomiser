local args = {...}
local tbl = args[1]
if Settings.SkipLocks then
	local sort = 5
	SundayDrive = {}
	if not tbl.SundayDrive[sort] then
		tbl.SundayDrive[sort] = SundayDrive
	else
		SundayDrive = tbl.SundayDrive[sort]
	end
	
	function SundayDrive.SkipLocks(LoadFile, InitFile, Level, Mission, Path)
		if InitFile:match("locked") then
			InitFile = InitFile:gsub("AddStage%s*%(\"locked\".-%s*%);(.-)CloseStage%s*%(%s*%);%s*AddStage%s*%([^\n]-%s*%);.-CloseStage%s*%(%s*%);", "AddStage();%1CloseStage();", 1);
		end
		return LoadFile, InitFile
	end
end