-- This file modifies a binary .p3d file to create a custom string
-- The internal string is "-" because this appears first in the 
-- hash list, this simplifies some things
local Path = "/GameData/" .. GetPath();
local Original = ReadFile(Path)

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
[0x20000]=Settings.SaveChoiceRSC
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
[0x100]=Settings.RandomPedestrians
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
[0x80]=Settings.RandomLevelMissions
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

-- Find bible
local BiblePos, BibleLen = FindSubchunk(Original, TEXT_BIBLE_CHUNK)
local Bible = Original:sub(BiblePos, BiblePos + BibleLen - 1)
local EnglishPos, EnglishLen = FindSubchunk(Bible, LANGUAGE_CHUNK)
local English = Bible:sub(EnglishPos, EnglishPos + EnglishLen - 1)

local STRING = AsciiToUTF16(os.date("[%Y-%m-%d]") .. "\nRandomiser v" .. ModVersion .. (Settings.UseDebugSettings and " (debug)" or "") .. "\n" .. string.format("Settings: Gameplay: %X, Graphics: %X, Chaos: %X", GameplayN, GraphicalN, ChaosN)) .. "\0\0"

-- Increment number of entires by 1
English = AddP3DInt4(English, 71, 1)
-- Hash for String ID "-" (yes it's "-" itself)
local STRING_ID = "\x2D\x00\x00\x00"
English = English:sub(1, 82) .. STRING_ID .. English:sub(83)
-- New number entries with our new '-' entry
local N_ENTRIES = GetP3DInt4(English, 71)

-- Set the location of the "-" string to the end of the buffer
English = English:sub(1, 82 + 4*N_ENTRIES) .. IntToString4(GetP3DInt4(English, 79)) .. English:sub(83 + 4*N_ENTRIES)
English = English .. STRING

-- Update lengths
English = AddP3DInt4(English, 5, STRING:len())
English = AddP3DInt4(English, 9, STRING:len())
English = AddP3DInt4(English, 79, STRING:len())

-- Update parent chunks
Bible = Bible:sub(1, EnglishPos - 1) .. English .. Bible:sub(EnglishPos + EnglishLen)
Bible = AddP3DInt4(Bible, 9, STRING:len())

Original = Original:sub(1, BiblePos - 1) .. Bible .. Original:sub(BiblePos + BibleLen)
Original = AddP3DInt4(Original, 9, STRING:len())

Output(Original)