local Path = "/GameData/" .. GetPath()

if Cache.Ingame then
	Output(Cache.Ingame)
	return
end

local Chunk = P3D.P3DChunk:new{Raw = ReadFile(Path)}
local ProjectIDX = Chunk:GetChunkIndex(P3D.Identifiers.Frontend_Project)
local ProjectChunk = P3D.FrontendProjectP3DChunk:new{Raw = Chunk:GetChunkAtIndex(ProjectIDX)}
local PageIDX = nil
local PageChunk = nil
for idx in ProjectChunk:GetChunkIndexes(P3D.Identifiers.Frontend_Page) do
	PageChunk = P3D.FrontendPageP3DChunk:new{Raw = ProjectChunk:GetChunkAtIndex(idx)}
	if P3D.CleanP3DString(PageChunk.Name) == "Pause.pag" then
		PageIDX = idx
		break
	end
end
if PageIDX then
	local TextStyleChunk = P3D.FrontendTextStyleResourceP3DChunk:create(P3D.MakeP3DString("font1_14"),1,P3D.MakeP3DString("fonts\\font1_14.p3d"),P3D.MakeP3DString("Tt2001m__14"))
	PageChunk:AddChunk(TextStyleChunk:Output(), 1)
	local LayerIDX = PageChunk:GetChunkIndex(P3D.Identifiers.Frontend_Layer)
	local LayerChunk = P3D.FrontendLayerP3DChunk:new{Raw = PageChunk:GetChunkAtIndex(LayerIDX)}
	local MultiTextChunk = P3D.FrontendMultiTextP3DChunk:create(P3D.MakeP3DString("RandoSettings"), 17, 220, 75, 200, 18, P3D.FrontendMultiTextP3DChunk.Justifications.Centre, P3D.FrontendMultiTextP3DChunk.Justifications.Top, {A=255,R=255,G=255,B=255}, 0, 0, P3D.MakeP3DString("font1_14"), 1, {A=192,R=0,G=0,B=0}, 2, -2, 0)
	local TextChunk = P3D.FrontendStringTextBibleP3DChunk:create("srr2", P3D.MakeP3DString("RandoSettings"))
	MultiTextChunk:AddChunk(TextChunk:Output())
	LayerChunk:AddChunk(MultiTextChunk:Output())
	PageChunk:SetChunkAtIndex(LayerIDX, LayerChunk:Output())
	ProjectChunk:SetChunkAtIndex(PageIDX, PageChunk:Output())
	Chunk:SetChunkAtIndex(ProjectIDX, ProjectChunk:Output())
	Cache.Ingame = Chunk:Output()
	Output(Cache.Ingame)
end