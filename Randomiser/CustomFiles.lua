Settings = GetSettings()
Paths = {}
Paths.ModPath = GetModPath()
Paths.Resources = Paths.ModPath .. "/Resources"
Paths.Lib = Paths.Resources .. "/lib"
Paths.Modules = Paths.Resources .. "/Modules"

dofile(Paths.Lib .. "/Utils.lua")
dofile(Paths.Lib .. "/P3D2.lua")
P3D.LoadChunks(Paths.Lib .. "/P3DChunks")
dofile(Paths.Lib .. "/MFKLexer.lua")

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
			CharNames[CharCount] = CompositeDrawable.Name
		end
	end
end