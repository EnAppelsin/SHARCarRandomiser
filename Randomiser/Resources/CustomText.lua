-- This file modifies a binary .p3d file to create a custom string
-- The internal string is "-" because this appears first in the 
-- hash list, this simplifies some things
local Path = "/GameData/" .. GetPath();
local Original = ReadFile(Path)

local GameplaySettings = 
{
[0x1]=SettingRandomPlayerVehicles,
[0x2]=SettingSaveChoice,
[0x4]=SettingCustomCars,
[0x8]=SettingRandomTraffic,
[0x10]=SettingRandomChase,
[0x20]=SettingRandomChaseAmount,
[0x40]=SettingRandomChaseStats,
[0x80]=SettingRandomMissionVehicles,
[0x100]=SettingRandomMissionVehiclesStats,
[0x200]=SettingDifferentCellouts,
[0x400]=SettingSaveChoiceMV,
[0x800]=SettingRandomStats,
[0x1000]=SettingSkipLocks,
[0x2000]=SettingSkipFMVs,
[0x4000]=SettingBoostHP,
}

local GraphicalSettings =
{
[0x1]=SettingRandomCouch,
[0x2]=SettingRandomMusic,
[0x4]=SettingRandomMusicCues,
[0x8]=SettingRandomDialogue,
[0x10]=SettingRandomCharacter,
[0x20]=SettingRandomMissionCharacters,
[0x40]=SettingRandomCarScale,
[0x80]=SettingRandomCarSounds,
[0x100]=SettingRandomPedestrians
}

local ChaosSettings = 
{
[0x1]=SettingRandomInteriors,
[0x2]=SettingRandomDirectives,
[0x4]=SettingRandomMissions,
[0x8]=SettingRandomItems,
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

local STRING = AsciiToUTF16(os.date("[%Y-%m-%d]") .. "\nRandomiser v" .. ModVersion .. "\n" .. string.format("Settings: Gameplay: %X, Graphics: %X, Chaos: %X", GameplayN, GraphicalN, ChaosN)) .. "\0\0"

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