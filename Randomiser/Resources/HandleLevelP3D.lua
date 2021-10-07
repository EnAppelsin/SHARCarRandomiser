local filePath = "/GameData/" .. GetPath()
local level = filePath:lower():match("art/l(%d)") or filePath:lower():match("art\\l(%d)") or filePath:lower():match("level0(%d)")
local P3DFile = P3D.P3DChunk:new{Raw = ReadFile(filePath)}
local modified = false
local tbl
if UFO and RoadPositions["L" .. level] then
	tbl = tbl or RoadPositions["L" .. level]
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

	local Z3D1Pos = {X = x, Y = y, Z = z}
	local UFOPos = {X = x, Y = y, Z = z}
	UFOPos.X = UFOPos.X - 3.3992
	UFOPos.Y = UFOPos.Y + 18.4972
	UFOPos.Z = UFOPos.Z + 3.2681

	local LocatorChunk = P3D.LocatorP3DChunk:createType0(P3D.MakeP3DString("Z3D1"), Z3D1Pos, 4)
	P3DFile:AddChunk(LocatorChunk:Output())

	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Locator) do
		LocatorChunk = P3D.LocatorP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		if UFO == P3D.CleanP3DString(LocatorChunk.Name) then
			LocatorChunk.Position = UFOPos
			local TriggerVolumeIDX = LocatorChunk:GetChunkIndex(P3D.Identifiers.Trigger_Volume)
			if TriggerVolumeIDX then
				local TriggerVolumeChunk = P3D.TriggerVolumeP3DChunk:new{Raw = LocatorChunk:GetChunkAtIndex(TriggerVolumeIDX)}
				TriggerVolumeChunk.HalfExtents.Y = TriggerVolumeChunk.HalfExtents.Y + 3.5
				if TriggerVolumeChunk.IsRect == 0 then
					TriggerVolumeChunk.HalfExtents.X = TriggerVolumeChunk.HalfExtents.X + 3.5
					TriggerVolumeChunk.HalfExtents.Z = TriggerVolumeChunk.HalfExtents.Z + 3.5
				end
				TriggerVolumeChunk.Matrix.M41 = UFOPos.X
				TriggerVolumeChunk.Matrix.M42 = UFOPos.Y
				TriggerVolumeChunk.Matrix.M43 = UFOPos.Z
				LocatorChunk:SetChunkAtIndex(TriggerVolumeIDX, TriggerVolumeChunk:Output())				
			end
			P3DFile:SetChunkAtIndex(idx, LocatorChunk:Output())
			modified = true
			break
		end
	end
	if not modified then
		LocatorChunk = P3D.LocatorP3DChunk:createType3(P3D.MakeP3DString(UFO), UFOPos, 0, 0)
		P3DFile:AddChunk(LocatorChunk:Output())
		modified = true
	end
elseif level == "7" then
	local found = false
	for idx in P3DFile:GetChunkIndexes(P3D.Identifiers.Locator) do
		local LocatorChunk = P3D.LocatorP3DChunk:new{Raw = P3DFile:GetChunkAtIndex(idx)}
		if P3D.CleanP3DString(LocatorChunk.Name) == "m2_AI_carstart" then
			LocatorChunk.Position.X = LocatorChunk.Position.X + 12
			P3DFile:SetChunkAtIndex(idx, LocatorChunk:Output())
			found = true
			break
		end
	end
	if found then
		Output(P3DFile:Output())
	end
end

if Waypoints and RoadPositions["L" .. level] then
	tbl = tbl or RoadPositions["L" .. level]
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
	Waypoints = nil
end

if modified then
	Output(P3DFile:Output())
end