local args = {...}
local tbl = args[1]
if Settings.RandomUFOs then
	GetRoads()
	
	local sort = 5
	local Level = {}
	if not tbl.Level[sort] then
		tbl.Level[sort] = Level
	else
		Level = tbl.Level[sort]
	end
	
	function Level.RandomUFOs(LoadFile, InitFile, Level, Path)
		UFO = nil
		for ufo in InitFile:gmatch("AddFlyingActorByLocator%s*%(%s*\"[^\n]-\"%s*,%s*\"[^\n]-\"%s*,%s*\"([^\n]-)\"") do
			UFO = ufo
		end
		if not UFO then
			LoadFile = LoadFile .. [[
LoadP3DFile("art\missions\level07\ufo.p3d");
LoadP3DFile("art\missions\level07\ufobeam.p3d");]]
			InitFile = InitFile .. [[
PreallocateActors( "spaceship", "1" );
AddFlyingActorByLocator("spaceship","Planet Express Ship","l]]
			InitFile = InitFile .. Level .. [[_spaceship","NEVER_DESPAWN");
AddBehaviour( "Planet Express Ship", "UFO_BEAM_ALWAYS_ON", "UfoBeam" );]]
			UFO = "l" .. Level .. "_spaceship"
		end
		return LoadFile, InitFile
	end
end