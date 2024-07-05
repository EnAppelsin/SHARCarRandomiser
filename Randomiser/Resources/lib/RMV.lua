local assert = assert
local setmetatable = setmetatable
local type = type

local math_max = math.max
local string_pack = string.pack
local string_sub = string.sub
local string_unpack = string.unpack
local table_concat = table.concat

RMV = {}
local Signature = "BIKi"
local MaxFrameCount = 1000000
local MaxAudioTracks = 256

RMV.AudioFlags = {
	UseDCT = 0x1000,
	Stereo = 0x2000,
	SixteenBits = 0x4000,
}

RMV.RMVFile = setmetatable({}, {
	__call = function(self, Path)
		assert(type(Path) == "string", "Arg #1 (Path) must be a string.")
		assert(Exists(Path, true, false), "Arg #1 (Path) must be a valid filepath.")
		
		local contents = ReadFile(Path)
		local contentsLen = #contents
		assert(contentsLen > 45, "File contents too short.")
		local signature, pos = string_unpack("<c4", contents)
		assert(signature == Signature, "Unknown signature: " .. signature .. ". Expected: " .. Signature)
		
		local Data = {}
		local FileSize, NumFrames, LargestFrame, NumFrames2
		FileSize, NumFrames, LargestFrame, NumFrames2, Data.Width, Data.Height, Data.FpsDividend, Data.FpsDivider, Data.VideoFlags, Data.NumAudioTracks, pos = string_unpack("<IIIIIIIIII", contents, pos)
		assert(FileSize == contentsLen - 8, "Incorrect file size: " .. FileSize .. ". Expected: " .. contentsLen - 8)
		assert(FileSize > LargestFrame, "FileSize must be greater than largest frame.")
		assert(NumFrames <= MaxFrameCount, "Maximum number of frames is: " .. MaxFrameCount)
		assert(Data.NumAudioTracks <= MaxAudioTracks, "Maximum number if audio tracks is: " .. MaxAudioTracks)
		
		local HasAudio = Data.NumAudioTracks > 0
		local AudioTracks = {}
		Data.AudioTracks = AudioTracks
		if HasAudio then
			for i=1,Data.NumAudioTracks do
				local AudioTrack = {}
				AudioTracks[i] = AudioTrack
				
				AudioTrack.Unknown, AudioTrack.Channels, pos = string.unpack("<HH", contents, pos)
			end
			for i=1,Data.NumAudioTracks do
				local AudioTrack = AudioTracks[i]
				
				AudioTrack.SampleRate, AudioTrack.AudioFlags, pos = string.unpack("<HH", contents, pos)
				assert(AudioTrack.Channels == (AudioTrack.AudioFlags & RMV.AudioFlags.Stereo) ~= 0 and 2 or 1, "Audio channel count doesn't match stereo flag")
			end
			for i=1,Data.NumAudioTracks do
				local AudioTrack = AudioTracks[i]
				
				AudioTrack.TrackID, pos = string.unpack("<I", contents, pos)
			end
		end
		
		local FrameOffsets = {}
		local KeyFrames = {}
		local offset
		for i=1,NumFrames + 1 do
			offset, pos = string.unpack("<I", contents, pos)
			local keyFrame = offset & 1 == 1
			FrameOffsets[i] = keyFrame and offset & ~1 or offset
			KeyFrames[i] = keyFrame
		end
		
		local Frames = {}
		Data.Frames = Frames
		for i=1,NumFrames do
			local Frame = {
				KeyFrame = KeyFrames[i]
			}
			Data.Frames[i] = Frame
			
			local FrameData = string_sub(contents, FrameOffsets[i] + 1, FrameOffsets[i + 1])
			
			if HasAudio then
				local Audio = {}
				Frame.Audio = Audio
				
				local FrameDataPos = 1
				for j=1,Data.NumAudioTracks do
					local Track = {}
					Audio[j] = Track
					
					Track.Length, FrameDataPos = string_unpack("<I", FrameData, FrameDataPos)
					if Track.Length > 0 then
						Track.Samples, Track.Packet, FrameDataPos = string_unpack("<Ic" .. Track.Length - 4, FrameData, FrameDataPos)
					end
				end
				
				Frame.Packet = string_sub(FrameData, FrameDataPos)
			else
				Frame.Packet = FrameData
			end
			-- TODO: I'd love to figure out how to parse Packet data
		end
		
		self.__index = self
		return setmetatable(Data, self)
	end,
})

function RMV.RMVFile:__tostring()
	local Frames = self.Frames
	local AudioTracks = self.AudioTracks
	local FrameCount = #Frames
	local AudioCount = #AudioTracks
	assert(FrameCount <= MaxFrameCount, "Maximum number of frames is: " .. MaxFrameCount)
	assert(AudioCount <= MaxAudioTracks, "Maximum number if audio tracks is: " .. MaxAudioTracks)
	
	local Offset = 44 + AudioCount * 12 + (FrameCount + 1) * 4 -- Header + Audio data + Frame offsets
	local LargestFrame = 0
	local FrameOffsets = {Offset}
	for i=1,FrameCount do
		local Frame = Frames[i]
		
		local FrameSize = #Frame.Packet
		for j=1,AudioCount do
			FrameSize = FrameSize + 4 + Frame.Audio[j].Length
		end
		LargestFrame = math_max(LargestFrame, FrameSize)
		
		Offset = Offset + FrameSize
		FrameOffsets[i + 1] = Offset
	end
	
	local Output = {}
	local OutputN = 0
	
	OutputN = OutputN + 1
	Output[OutputN] = string_pack("<IIIIIIIII", FrameCount, LargestFrame, FrameCount, self.Width, self.Height, self.FpsDividend, self.FpsDivider, self.VideoFlags, AudioCount)
	
	if AudioCount > 0 then
		for i=1,AudioCount do
			local AudioTrack = AudioTracks[i]
			
			OutputN = OutputN + 1
			Output[OutputN] = string_pack("<HH", AudioTrack.Unknown, AudioTrack.Channels)
		end
		for i=1,AudioCount do
			local AudioTrack = AudioTracks[i]
			
			OutputN = OutputN + 1
			Output[OutputN] = string_pack("<HH", AudioTrack.SampleRate, AudioTrack.AudioFlags)
		end
		for i=1,AudioCount do
			local AudioTrack = AudioTracks[i]
			
			OutputN = OutputN + 1
			Output[OutputN] = string_pack("<I", AudioTrack.TrackID)
		end
	end
	
	for i=1,FrameCount + 1 do
		local FrameOffset = FrameOffsets[i]
		if Frames[i] and Frames[i].KeyFrame then
			FrameOffset = FrameOffset | 1
		end
		
		OutputN = OutputN + 1
		Output[OutputN] = string_pack("<I", FrameOffset)
	end
	for i=1,FrameCount do
		local Frame = Frames[i]
		
		if Frame.Audio then
			for j=1,#Frame.Audio do
				local Audio = Frame.Audio[j]
				
				OutputN = OutputN + 1
				Output[OutputN] = string_pack("<I", Audio.Length)
				if Audio.Length > 0 then
					OutputN = OutputN + 1
					Output[OutputN] = string_pack("<I", Audio.Samples)
					OutputN = OutputN + 1
					Output[OutputN] = Audio.Packet
				end
			end
		end
		
		OutputN = OutputN + 1
		Output[OutputN] = Frame.Packet
	end
	
	local Output = table_concat(Output)
	return string_pack("<c4I", Signature, #Output) .. Output
end