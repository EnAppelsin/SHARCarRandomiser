local SettingsInfo = Module("Settings Info", nil, 100)

local GameplaySettings = {
	[1 << 1] = Settings.RemoveMissionLocks,
	[1 << 2] = Settings.RemoveOutOfVehicle,
	[1 << 3] = Settings.SkipCutscenes,
	[1 << 4] = Settings.ClampHP,
	[1 << 5] = Settings.RandomLevelVehicle,
	[1 << 6] = Settings.RandomMissionVehicle,
	[1 << 7] = Settings.RandomNPCVehicles,
	[1 << 8] = Settings.RandomNPCVehiclesStats,
	[1 << 9] = Settings.RandomTraffic,
	[1 << 10] = Settings.RandomChaseVehicle,
	[1 << 11] = Settings.RandomChaseVehicleStats,
	[1 << 12] = Settings.RandomChaseAmount,
	[1 << 13] = Settings.RandomBonusVehicles,
}

local AudioVisualSettings = {
	[1 << 1] = Settings.RandomCouchCharacter,
	[1 << 2] = Settings.RandomPlayerCharacter,
	[1 << 3] = Settings.RandomPedestrians,
	[1 << 4] = Settings.RandomMissionCharacters,
	[1 << 5] = Settings.RandomDrivers,
	[1 << 6] = Settings.RandomMusic,
	[1 << 7] = Settings.RandomCarSounds,
}

local ChaosSettings = {
	[1 << 1] = Settings.RandomText,
	[1 << 2] = Settings.RandomTextCase,
	[1 << 3] = Settings.RandomMissionOrder,
	[1 << 4] = Settings.RandomNPCMissions,
}

local GameplayN = 0
local AudioVisualN = 0
local ChaosN = 0
for k, v in pairs(GameplaySettings) do
	if v then
		GameplayN = GameplayN | k
	end
end
for k, v in pairs(AudioVisualSettings) do
	if v then
		AudioVisualN = AudioVisualN | k
	end
end
for k, v in pairs(ChaosSettings) do
	if v then
		ChaosN = ChaosN | k
	end
end

local Values = string.format("%s\n%s v%s%s%s\nGameplay: %X, Audio/Visual: %X, Chaos: %X", os.date("[%Y-%m-%d]"), GetModName(), GetModVersion(), Settings.SpeedrunMode and " (speedrun)" or "", Settings.UseDebugSettings and " (debug)" or "", GameplayN, AudioVisualN, ChaosN)
if Settings.IsSeeded then
	Values = string.format("%s\nSeed: %s", Values, Settings.Seed)
	if (ChaosN & ~(1 << 3)) ~= 0 then -- Random Mission Order _is_ seeded
		Alert("Chaos randomisations are not seeded and should be disabled for consistent races")
	end
end

SettingsInfo:AddP3DHandler("art/frontend/scrooby/resource/txtbible/srr2.p3d", function(Path, P3DFile)
	local FrontendTextBible = P3DFile:GetChunk(P3D.Identifiers.Frontend_Text_Bible)
	if not FrontendTextBible then
		return false
	end
	
	for FrontendLanguage in FrontendTextBible:GetChunks(P3D.Identifiers.Frontend_Language) do
		FrontendLanguage:AddValue("RandoSettings", Values)
	end
	
	return true
end)

SettingsInfo:AddP3DHandler("art/frontend/scrooby/frontend.p3d", function(Path, P3DFile)
	local FrontendProjectChunk = P3DFile:GetChunk(P3D.Identifiers.Frontend_Project)
	if not FrontendProjectChunk then
		return false
	end
	local TVFramePageChunk = FrontendProjectChunk:GetChunk(P3D.Identifiers.Frontend_Page, false, "TVFrame.pag")
	if not TVFramePageChunk then
		return false
	end
	
	TVFramePageChunk:AddChunk(P3D.FrontendTextStyleResourceP3DChunk("font1_14", 1, "fonts\\font1_14.p3d", "Tt2001m__14"), 1)
	
	local FrontendLayer = TVFramePageChunk:GetChunk(P3D.Identifiers.Frontend_Layer)
	local MultiTextChunk = P3D.FrontendMultiTextP3DChunk:new("RandoSettings", 17, {X = 220, Y = 75}, {X = 200, Y = 18}, {X = P3D.FrontendMultiTextP3DChunk.Justifications.Centre, Y = P3D.FrontendMultiTextP3DChunk.Justifications.Top}, {A=255,R=255,G=255,B=255}, 0, 0, "font1_14", 1, {A=192,R=0,G=0,B=0}, {X = 2, Y = -2}, 0)
	local TextChunk = P3D.FrontendStringTextBibleP3DChunk:new("srr2", "RandoSettings")
	MultiTextChunk:AddChunk(TextChunk)
	FrontendLayer:AddChunk(MultiTextChunk)
	
	return true
end)

return SettingsInfo