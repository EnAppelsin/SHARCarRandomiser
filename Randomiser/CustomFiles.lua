Settings = GetSettings()
Paths = {}
Paths.ModPath = GetModPath()
Paths.Resources = Paths.ModPath .. "/Resources"
Paths.Lib = Paths.Resources .. "/lib"

dofile(Paths.Lib .. "/Utils.lua")
dofile(Paths.Lib .. "/P3D2.lua")
P3D.LoadChunks(Paths.Lib .. "/P3DChunks")
dofile(Paths.Lib .. "/P3DUtils.lua")
dofile(Paths.Lib .. "/MFKLexer.lua")
dofile(Paths.Lib .. "/SPTParser.lua")
dofile(Paths.Lib .. "/RCF.lua")
dofile(Paths.Lib .. "/RMV.lua")

dofile(Paths.Lib .. "/ModuleLoader.lua")

CharP3DFiles = {}
CharNames = {}
CharCount = 0
GetFilesInDirectory("/GameData/art/chars", CharP3DFiles, ".p3d")

local ExcludedChars = {["npd_m"]=true,["ndr_m"]=true,["nps_m"]=true}
for i=#CharP3DFiles,1,-1 do
	local filePath = CharP3DFiles[i]
	local fileName = RemoveFileExtension(GetFileName(filePath))
	if fileName:sub(-2) ~= "_m" or ExcludedChars[fileName] then
		table.remove(CharP3DFiles, i)
	else
		local P3DFile = P3D.P3DFile(filePath)
		local CompositeDrawable = P3DFile:GetChunk(P3D.Identifiers.Composite_Drawable)
		if not CompositeDrawable then
			table.remove(CharP3DFiles, i)
		else
			CharCount = CharCount + 1
			table.insert(CharNames, 1, CompositeDrawable.Name:sub(1, -3))
		end
	end
end
print(string.format("Loaded %i characters", CharCount))

CarP3DFiles = {}
CarNames = {}
CarCount = 0
GetFilesInDirectory("/GameData/art/cars", CarP3DFiles, ".p3d")

local ExcludedCars = {["huskA"]=true,["common"]=true}
for i=#CarP3DFiles,1,-1 do
	local filePath = CarP3DFiles[i]
	local fileName = RemoveFileExtension(GetFileName(filePath))
	if ExcludedCars[fileName] then
		table.remove(CarP3DFiles, i)
	else
		local P3DFile = P3D.P3DFile(filePath)
		local CompositeDrawable = P3DFile:GetChunk(P3D.Identifiers.Composite_Drawable)
		if not CompositeDrawable then
			table.remove(CarP3DFiles, i)
		else
			CarCount = CarCount + 1
			table.insert(CarNames, 1, CompositeDrawable.Name)
		end
	end
end
print(string.format("Loaded %i cars", CarCount))

ModuleLoader.LoadModules(Paths.Resources .. "/Modules")