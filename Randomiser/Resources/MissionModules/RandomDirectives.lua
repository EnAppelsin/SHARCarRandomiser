local args = {...}
local tbl = args[1]
if Settings.RandomDirectives then
	IconP3DPool = {
		"\\char\\apu",
		"\\char\\barne",
		"\\char\\barneuni",
		"\\char\\bart",
		"\\char\\burns",
		"\\char\\carl",
		"\\char\\cbg",
		"\\char\\cletus",
		"\\char\\drhibert",
		"\\char\\drnick",
		"\\char\\frink",
		"\\char\\grampa",
		"\\char\\homer",
		"\\char\\jimbo",
		"\\char\\kearney",
		"\\char\\krusty",
		"\\char\\lenny",
		"\\char\\lisa",
		"\\char\\louie",
		"\\char\\marage",
		"\\char\\milhouse",
		"\\char\\moe",
		"\\char\\moleman",
		"\\char\\ned",
		"\\char\\nelson",
		"\\char\\otto",
		"\\char\\ralph",
		"\\char\\scaptain",
		"\\char\\sjail",
		"\\char\\skinner",
		"\\char\\smithers",
		"\\char\\snake",
		"\\char\\svt",
		"\\char\\wiggum",
		"\\location\\android",
		"\\location\\aztec",
		"\\location\\bartroom",
		"\\location\\bowlera",
		"\\location\\casino",
		"\\location\\cemetery",
		"\\location\\chum",
		"\\location\\cletushs",
		"\\location\\dmv",
		"\\location\\duff",
		"\\location\\google",
		"\\location\\grocery",
		"\\location\\hermans",
		"\\location\\hospital",
		"\\location\\itcstore",
		"\\location\\java",
		"\\location\\kburger",
		"\\location\\krustylu",
		"\\location\\kwike",
		"\\location\\lardlads",
		"\\location\\lbsc",
		"\\location\\lexicon",
		"\\location\\mansion",
		"\\location\\moehouse",
		"\\location\\moes",
		"\\location\\monorail",
		"\\location\\museum",
		"\\location\\noise",
		"\\location\\observ",
		"\\location\\parking",
		"\\location\\planethy",
		"\\location\\playgrou",
		"\\location\\police",
		"\\location\\pwrplant",
		"\\location\\retire",
		"\\location\\right",
		"\\location\\school",
		"\\location\\scream",
		"\\location\\ship",
		"\\location\\simpsons",
		"\\location\\sitnrota",
		"\\location\\spsign",
		"\\location\\squidp",
		"\\location\\stadium",
		"\\location\\taffy",
		"\\location\\townhall",
		"\\location\\trynsave",
		"\\location\\ufo",
		"\\location\\wallewea",
		"\\location\\wstation",
		"\\object\\antifung",
		"\\object\\barrel",
		"\\object\\blender",
		"\\object\\blood",
		"\\object\\boards",
		"\\object\\bonestor",
		"\\object\\buzzcola",
		"\\object\\caffeine",
		"\\object\\cardboar",
		"\\object\\chainsaw",
		"\\object\\colacrat",
		"\\object\\comic",
		"\\object\\cooler",
		"\\object\\diaper",
		"\\object\\digest",
		"\\object\\donuts",
		"\\object\\firework",
		"\\object\\firstaid",
		"\\object\\fish",
		"\\object\\flatmeat",
		"\\object\\folder",
		"\\object\\heart",
		"\\object\\icecream",
		"\\object\\inhaler",
		"\\object\\kbmeal",
		"\\object\\ketchup",
		"\\object\\key",
		"\\object\\kids",
		"\\object\\lasercra",
		"\\object\\lasergun",
		"\\object\\lasersta",
		"\\object\\lawnchr",
		"\\object\\lawnmwr",
		"\\object\\litter",
		"\\object\\lundry",
		"\\object\\map",
		"\\object\\monkey",
		"\\object\\photo",
		"\\object\\pills",
		"\\object\\powercou",
		"\\object\\race",
		"\\object\\radio",
		"\\object\\record",
		"\\object\\redhat",
		"\\object\\setelite",
		"\\object\\sock",
		"\\object\\tamacco",
		"\\object\\tomoto",
		"\\object\\tooth",
		"\\object\\tshirt",
		"\\object\\tuxedo",
		"\\vehicle\\apu_v",
		"\\vehicle\\arm_v",
		"\\vehicle\\blimo_v",
		"\\vehicle\\bsedan_v",
		"\\vehicle\\celph_v",
		"\\vehicle\\cletus_v",
		"\\vehicle\\cola_v",
		"\\vehicle\\cvan_v",
		"\\vehicle\\frink_v",
		"\\vehicle\\krusty_v",
		"\\vehicle\\milk_v",
		"\\vehicle\\skinn_v",
		"\\vehicle\\smith_v",
		"\\vehicle\\sports_v",
		"\\vehicle\\wiggu_v"
	}
	
	PresentationP3DPool = {
		"mis01_00",
		"mis01_01",
		"mis01_02",
		"mis01_03",
		"mis01_04",
		"mis01_05",
		"mis01_06",
		"mis01_07",
		"mis01_08",
		"mis02_01",
		"mis02_02",
		"mis02_03",
		"mis02_04",
		"mis02_05",
		"mis02_06",
		"mis02_07",
		"mis02_08",
		"mis03_01",
		"mis03_02",
		"mis03_03",
		"mis03_04",
		"mis03_05",
		"mis03_06",
		"mis03_07",
		"mis03_08",
		"mis04_01",
		"mis04_02",
		"mis04_03",
		"mis04_04",
		"mis04_05",
		"mis04_06",
		"mis04_07",
		"mis04_08",
		"mis05_01",
		"mis05_02",
		"mis05_03",
		"mis05_04",
		"mis05_05",
		"mis05_06",
		"mis05_07",
		"mis05_08",
		"mis06_01",
		"mis06_02",
		"mis06_03",
		"mis06_04",
		"mis06_05",
		"mis06_06",
		"mis06_07",
		"mis06_08",
		"mis07_01",
		"mis07_02",
		"mis07_03",
		"mis07_04",
		"mis07_05",
		"mis07_06",
		"mis07_07",
		"mis07_08",
		"misXX_CP",
		"misXX_CT",
		"misXX_GB",
		"misXX_HW",
		"misXX_PS",
		"misXX_TT"
	}

	function tbl.SundayDrive.RandomDirectives(LoadFile, InitFile, Level, Mission)
		iconReplace = {}
		LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\frontend\\dynaload\\images\\msnicons([^\n]-)%.p3d\"%s*", function(orig)
			local rand = GetRandomFromTbl(IconP3DPool, false)
			local origName = orig:sub(findLast(orig, "\\") + 1)
			local randName = rand:sub(findLast(rand, "\\") + 1)
			iconReplace[origName] = randName
			DebugPrint("Replacing directive icon " .. origName .. " with " .. randName)
			return "LoadP3DFile(\"art\\frontend\\dynaload\\images\\msnicons" .. rand .. ".p3d\""
		end)
		
		InitFile = InitFile:gsub("SetStageMessageIndex%s*%(%s*[+-]?%d+%s*%)", function()
			return "SetStageMessageIndex(" .. math.random(1, 273) .. ")"
		end)
		InitFile = InitFile:gsub("SetPresentationBitmap%s*%(%s*\"art/frontend/dynaload/images/.-%.p3d\"%s*%)", function()
			return "SetPresentationBitmap(\"art/frontend/dynaload/images/" .. GetRandomFromTbl(PresentationP3DPool, false) .. ".p3d\")"
		end)
		for orig,rand in pairs(iconReplace) do
			InitFile = InitFile:gsub("SetHUDIcon%s*%(%s*\"" .. orig .. "\"%s*%)", "SetHUDIcon(\"" .. rand .. "\")")
		end
		return LoadFile, InitFile
	end
	tbl.Mission.RandomDirectives = tbl.SundayDrive.RandomDirectives

	--[[function tbl.Mission.RandomDirectives(LoadFile, InitFile, Level, Mission)
		iconReplace = {}
		LoadFile = LoadFile:gsub("LoadP3DFile%s*%(%s*\"art\\frontend\\dynaload\\images\\msnicons([^\n]-)%.p3d\"%s*", function(orig)
			local rand = GetRandomFromTbl(IconP3DPool, false)
			local origName = orig:sub(findLast(orig, "\\") + 1)
			local randName = rand:sub(findLast(rand, "\\") + 1)
			iconReplace[origName] = randName
			DebugPrint("Replacing directive icon " .. origName .. " with " .. randName)
			return "LoadP3DFile(\"art\\frontend\\dynaload\\images\\msnicons" .. rand .. ".p3d\""
		end)
		
		InitFile = InitFile:gsub("SetStageMessageIndex%s*%(%s*[+-]?%d+%s*%)", function()
			return "SetStageMessageIndex(" .. math.random(1, 273) .. ")"
		end)
		InitFile = InitFile:gsub("SetPresentationBitmap%s*%(%s*\"art/frontend/dynaload/images/.-%.p3d\"%s*%)", function()
			return "SetPresentationBitmap(\"art/frontend/dynaload/images/" .. GetRandomFromTbl(PresentationP3DPool, false) .. ".p3d\")"
		end)
		for orig,rand in pairs(iconReplace) do
			InitFile = InitFile:gsub("SetHUDIcon%s*%(%s*\"" .. orig .. "\"%s*%)", "SetHUDIcon(\"" .. rand .. "\")")
		end
		return LoadFile, InitFile
	end]]--
end