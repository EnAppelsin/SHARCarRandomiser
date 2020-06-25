if not Waypoints then return end
local filePath = "/GameData/" .. GetPath()
local level = filePath:lower():match("art/l(%d)") or filePath:lower():match("level0(%d)")
if RoadPositions["L" .. level] == nil then return false, nil end
local modified = false
local tbl = RoadPositions["L" .. level]
local P3DFile = P3D.P3DChunk:new{Raw = ReadFile(filePath)}
for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Locator) do
	local LocatorChunk = P3D.LocatorP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
	if Waypoints[P3D.CleanP3DString(LocatorChunk.Name)] then
		local RoadLength = math.random() * RoadPositions["L" .. level .. "Total"]
		local Road = nil
		for i=1,#tbl do
			RoadLength = RoadLength - tbl[i].Length
			Road = tbl[i]
			if RoadLength <= 0 then break end
		end
		local RandX = math.random()
		local RandY = math.random()
		
		local x1 = Road.BottomRight.X * RandX
		local y1 = Road.BottomRight.Y * RandX
		local z1 = Road.BottomRight.Z * RandX
		
		local x2 = Road.TopLeft.X + (Road.TopRight.X - Road.TopLeft.X) * RandX
		local y2 = Road.TopLeft.Y + (Road.TopRight.Y - Road.TopLeft.Y) * RandX
		local z2 = Road.TopLeft.Z + (Road.TopRight.Z - Road.TopLeft.Z) * RandX
		
		local x = Road.BottomLeft.X + x1 + (x2 - x1) * RandY
		local y = Road.BottomLeft.Y + y1 + (y2 - y1) * RandY
		local z = Road.BottomLeft.Z + z1 + (z2 - z1) * RandY
		
		local pos = {X = x, Y = y, Z = z}
		LocatorChunk.Position = pos
		local TriggerVolumeIDX = LocatorChunk:GetChunkIndex(P3D.Identifiers.Trigger_Volume)
		if TriggerVolumeIDX then
			local TriggerVolumeChunk = P3D.TriggerVolumeP3DChunk:new{Raw = LocatorChunk:GetChunkAtIndex(TriggerVolumeIDX)}
			TriggerVolumeChunk.HalfExtents.Y = TriggerVolumeChunk.HalfExtents.Y + 3.5
			if TriggerVolumeChunk.IsRect == 0 then
				TriggerVolumeChunk.HalfExtents.X = TriggerVolumeChunk.HalfExtents.X + 3.5
				TriggerVolumeChunk.HalfExtents.Z = TriggerVolumeChunk.HalfExtents.Z + 3.5
			end
			TriggerVolumeChunk.Matrix.M41 = pos.X
			TriggerVolumeChunk.Matrix.M42 = pos.Y
			TriggerVolumeChunk.Matrix.M43 = pos.Z
			LocatorChunk:SetChunkAtIndex(TriggerVolumeIDX, TriggerVolumeChunk:Output())				
		end
		P3DFile:SetChunkAtIndex(idx, LocatorChunk:Output())
		modified = true
	end
end
if modified then
	Output(P3DFile:Output())
end
Waypoints = nil