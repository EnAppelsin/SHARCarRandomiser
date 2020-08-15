-- This file modifies a binary .p3d file to create a custom string
-- The internal string is "-" because this appears first in the 
-- hash list, this simplifies some things
local Path = "/GameData/" .. GetPath()

-- The game reads the SRR2 4 times at the start for some bizarre reason
-- Only shuffle things once just in case
if Cache.SRR2 ~= nil then
	Output(Cache.SRR2)
	return
end

local GameplaySettings = 
{
[0x1]=Settings.RandomPlayerVehicles,
[0x2]=Settings.SaveChoice,
[0x4]=Settings.CustomCars,
[0x8]=Settings.RandomTraffic,
[0x10]=Settings.RandomChase,
[0x20]=Settings.RandomChaseAmount,
[0x40]=Settings.RandomChaseStats,
[0x80]=Settings.RandomMissionVehicles,
[0x100]=Settings.RandomMissionVehiclesStats,
[0x200]=Settings.DifferentCellouts,
[0x400]=Settings.SaveChoiceMV,
[0x800]=Settings.RandomStats,
[0x1000]=Settings.SkipLocks,
[0x2000]=Settings.SkipFMVs,
[0x4000]=Settings.BoostHP,
[0x8000]=Settings.RemoveOutOfCar,
[0x10000]=Settings.RandomStaticCars,
[0x20000]=Settings.SaveChoiceRSC,
}

local GraphicalSettings =
{
[0x1]=Settings.RandomCouch,
[0x2]=Settings.RandomMusic,
[0x4]=Settings.RandomMusicCues,
[0x8]=Settings.RandomDialogue,
[0x10]=Settings.RandomCharacter,
[0x20]=Settings.RandomMissionCharacters,
[0x40]=Settings.RandomCarScale,
[0x80]=Settings.RandomCarSounds,
[0x100]=Settings.RandomPedestrians,
[0x200]=Settings.SuperRandomDialogue,
}

local ChaosSettings = 
{
[0x1]=Settings.RandomInteriors,
[0x2]=Settings.RandomDirectives,
[0x4]=Settings.RandomMissions,
[0x8]=Settings.RandomItems,
[0x10]=Settings.RandomItemsIncludeChars,
[0x20]=Settings.RandomItemsIncludeCars,
[0x40]=Settings.RandomBonusMissions,
[0x80]=Settings.RandomLevelMissions,
[0x100]=Settings.RandomText,
[0x100]=Settings.RandomLapCount,
[0x100]=Settings.RandomWaypoints,
[0x100]=Settings.RandomUFOs,
}

local GameplayN = 0
local GraphicalN = 0
local ChaosN = 0
for k, v in pairs(GameplaySettings) do
	if v then
		GameplayN = GameplayN + k
	end
end
for k, v in pairs(GraphicalSettings) do
	if v then
		GraphicalN = GraphicalN + k
	end
end
for k, v in pairs(ChaosSettings) do
	if v then
		ChaosN = ChaosN + k
	end
end

local Values = os.date("[%Y-%m-%d]") .. "\n" .. ModName .. " v" .. ModVersion .. (Settings.SpeedrunMode and " (speedrun)" or "").. (Settings.UseDebugSettings and " (debug)" or "") .. "\n" .. string.format("Settings: Gameplay: %X, Graphics: %X, Chaos: %X\nSeed: %s", GameplayN, GraphicalN, ChaosN, Settings.Seed, Settings.SeedRaw)

local Chunk = P3D.P3DChunk:new{Raw = ReadFile(Path)}
local BibleIdx = Chunk:GetChunkIndex(P3D.Identifiers.Frontend_Text_Bible)
if not BibleIdx then return end
local BibleChunk = P3D.FrontendTextBibleP3DChunk:new{Raw = Chunk:GetChunkAtIndex(BibleIdx)}
local RandomCase = math.random(20) == 1
if RandomCase then
	DebugPrint("Random Case Easter Egg")
end
for idx in BibleChunk:GetChunkIndexes(P3D.Identifiers.Frontend_Language) do
	local LanguageChunk = P3D.FrontendLanguageP3DChunk:new{Raw = BibleChunk:GetChunkAtIndex(idx)}
	if Settings.RandomText then
		for i=#LanguageChunk.Offsets,2,-1 do
			local j = math.random(i)
			LanguageChunk.Offsets[i], LanguageChunk.Offsets[j] = LanguageChunk.Offsets[j], LanguageChunk.Offsets[i]
		end
	end
	if RandomCase then
		local ucs2 = {}
		for i=1,#LanguageChunk.Buffer,2 do
			local s = string.unpack("<H", LanguageChunk.Buffer, i)
			local case = math.random(2)
			if case == 1 and s >= 65 and s <= 90 then
				s = s + 32
			elseif case == 2 and s >= 97 and s <= 122 then
				s = s - 32
			end
			ucs2[#ucs2 + 1] = s
		end
		LanguageChunk.Buffer = string.pack("<" .. string.rep("H", #ucs2), table.unpack(ucs2))
	end
	LanguageChunk:AddValue("RandoSettings", Values)
	BibleChunk:SetChunkAtIndex(idx, LanguageChunk:Output())
end
Chunk:SetChunkAtIndex(BibleIdx, BibleChunk:Output())
Cache.SRR2 = Chunk:Output()
Output(Cache.SRR2)