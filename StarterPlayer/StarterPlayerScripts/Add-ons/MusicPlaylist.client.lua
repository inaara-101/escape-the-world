local player = game.Players.LocalPlayer
local masterTracklist = require(game.ReplicatedStorage:WaitForChild("Music"):WaitForChild("Tracks"))
local currentBiome = player:WaitForChild("CurrentBiome")
local musicVolume = player:WaitForChild("MusicVolume")
local index = 1
local isPlaying = false
local biomeTracklist = {}

local music = Instance.new("Sound")
music.Name = "Music"
music.Volume = musicVolume.Value
music.Looped = false
music.Parent = game.SoundService

local function nextTrack() end

nextTrack = function()
	
	if not currentBiome or #biomeTracklist == 0 then
		return
	end
	
	local track = biomeTracklist[index]

	if not track then
		return
	end

	isPlaying = true
	music.SoundId = track.SoundId
	music:Play()
	
	music.Ended:Once(function()
		
		if not isPlaying then
			return
		end
		
		index += 1
		
		if index > #biomeTracklist then
			index = 1
		end
		
		nextTrack()
		
	end)
	
end

currentBiome:GetPropertyChangedSignal("Value"):Connect(function()
	
	index = 1
	biomeTracklist = masterTracklist[currentBiome.Value] or {}
	isPlaying = false
	
	if music.IsPlaying then
		music:Stop()
	end
	
	if #biomeTracklist > 0 then
		nextTrack()
	end
	
end)

musicVolume:GetPropertyChangedSignal("Value"):Connect(function()
	game.SoundService.Music.Volume = musicVolume.Value
end)

biomeTracklist = masterTracklist[currentBiome.Value] or {}

if #biomeTracklist > 0 then
	nextTrack()
end
