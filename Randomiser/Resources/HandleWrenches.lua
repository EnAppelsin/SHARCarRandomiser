local filePath = "/GameData/" .. GetPath()
local P3DFile = P3D.P3DChunk:new{Raw = ReadFile(filePath)}
local modified = false

if Settings.RandoPickupStars then
	local tmp_0 = math.random(1,#RandomPickupStarColours)
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Old_Billboard_Quad_Group) do
		local Chunk = P3D.OldBillboardQuadGroupP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
				local v = "wrench_pickupstar"
				local tmp = P3D.CleanP3DString(Chunk.Shader)
				if string.match(tmp, v) then
					print("P3D",filePath.." : "..tmp.." --> "..tmp_0)
					Chunk.Shader = RandomPickupStarColours[tmp_0]
					P3DFile:SetChunkAtIndex(idx, Chunk:Output())
					modified = true
				end
			end
	end

if modified then
	Output(P3DFile:Output())
end