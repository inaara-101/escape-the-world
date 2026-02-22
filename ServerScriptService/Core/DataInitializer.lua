local RunService = game:GetService("RunService")
local ProfileStore = require(game.ServerScriptService:WaitForChild("Library"):WaitForChild("ProfileStore"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")
local dataTemplate = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataTemplate"))
local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local developerProducts = require(game.ServerScriptService:WaitForChild("Add-ons"):WaitForChild("DeveloperProducts"))
local gamepasses = require(game.ServerScriptService:WaitForChild("Add-ons"):WaitForChild("Gamepasses"))
local playerStore = ProfileStore.New(RunService:IsStudio() and "Development" or "Live", dataTemplate)

local function initialize(player, profile)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = profile.Data.Stage
	stage.Parent = leaderstats
	
	local coins = Instance.new("NumberValue")
	coins.Name = "Coins"
	coins.Value = profile.Data.Coins
	coins.Parent = player
	
	local currentBiome = Instance.new("StringValue")
	currentBiome.Name = "CurrentBiome"
	currentBiome.Value = profile.Data.CurrentBiome
	currentBiome.Parent = player
	
	local deaths = Instance.new("IntValue")
	deaths.Name = "Deaths"
	deaths.Value = profile.Data.Deaths
	deaths.Parent = player
	
	local timePlayed = Instance.new("IntValue")
	timePlayed.Name = "TimePlayed"
	timePlayed.Value = profile.Data.TimePlayed
	timePlayed.Parent = player
	
	local loginStreak = Instance.new("IntValue")
	loginStreak.Name = "LoginStreak"
	loginStreak.Value = profile.Data.LoginStreak
	loginStreak.Parent = player
	
	local freeSkips = Instance.new("IntValue")
	freeSkips.Name = "FreeSkips"
	freeSkips.Value = profile.Data.FreeSkips
	freeSkips.Parent = player
	
	local musicVolume = Instance.new("NumberValue")
	musicVolume.Name = "MusicVolume"
	musicVolume.Value = profile.Data.MusicVolume
	musicVolume.Parent = player
	
	local sfxVolume = Instance.new("NumberValue")
	sfxVolume.Name = "SFXVolume"
	sfxVolume.Value = profile.Data.SFXVolume
	sfxVolume.Parent = player
	
	local graphicsQuality = Instance.new("StringValue")
	graphicsQuality.Name = "GraphicsQuality"
	graphicsQuality.Value = profile.Data.GraphicsQuality
	graphicsQuality.Parent = player
	
	local invincibility = Instance.new("BoolValue")
	invincibility.Name = "Invincibility"
	invincibility.Value = profile.Data.Invincibility
	invincibility.Parent = player
	
	local trollsBought = Instance.new("IntValue")
	trollsBought.Name = "TrollsBought"
	trollsBought.Value = profile.Data.TrollsBought
	trollsBought.Parent = player
	
	remoteEvents.UpdateStage:FireClient(player, profile.Data.Stage)
	remoteEvents.UpdateCoins:FireClient(player, profile.Data.Coins)
	remoteEvents.UpdateTimePlayed:FireClient(player, profile.Data.TimePlayed)
	remoteEvents.UpdateFreeSkips:FireClient(player, profile.Data.FreeSkips)
	remoteEvents.UpdateMusicVolume:FireClient(player, profile.Data.MusicVolume)
	remoteEvents.UpdateSFXVolume:FireClient(player, profile.Data.SFXVolume)
	remoteEvents.UpdateGraphicsQuality:FireClient(player, profile.Data.GraphicsQuality)
	remoteEvents.UpdateInvincibility:FireClient(player, profile.Data.Invincibility)
	remoteEvents.UpdateTrollsBought:FireClient(player, profile.Data.TrollsBought)
	
	dataManager:GetFriendBoostMultiplier(player)
	gamepasses:UpdateGamepassOwnership(player)
	
	if player.Character then
		
		local checkpoint = workspace.Checkpoints:FindFirstChild(tostring(stage.Value))
		local hrp = player.Character:WaitForChild("HumanoidRootPart")
		
		hrp.CFrame = CFrame.new(checkpoint.Checkpoint.Position + Vector3.new(0, 2, 0))
		
	end
	
	player.CharacterAdded:Connect(function(character)
		
		local checkpoint = workspace.Checkpoints:FindFirstChild(tostring(stage.Value))
		local hrp = player.Character:FindFirstChild("HumanoidRootPart")

		hrp.CFrame = CFrame.new(checkpoint.Checkpoint.Position + Vector3.new(0, 2, 0))
		
	end)
	
end

local function playerAdded(player)
	
	local profile = playerStore:StartSessionAsync("player" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= game.Players
		end,
	})

	if profile ~= nil then

		profile:AddUserId(player.UserId)
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			dataManager.Profiles[player] = nil
			player:Kick("Your data could not be loaded. Try rejoining.")
		end)

		if player.Parent == game.Players then
			dataManager.Profiles[player] = profile
			initialize(player, profile)
			dataManager:UpdateLoginStreak(player)
		else
			profile:EndSession()
		end

	else

		player:Kick("Your data could not be loaded. Try rejoining.")

	end
	
end

for _, player in game.Players:GetPlayers() do
	task.spawn(playerAdded, player)
end

game.Players.PlayerAdded:Connect(function(player)
	
	playerAdded(player)
	
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		dataManager:GetFriendBoostMultiplier(otherPlayer)
	end
	
end)

game.Players.PlayerRemoving:Connect(function(player)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		dataManager:GetFriendBoostMultiplier(otherPlayer)
	end
	
	profile:EndSession()
	dataManager.Profiles[player] = nil
	
end)
