local dataManager = {}

local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")
local configurations = game.ReplicatedStorage:WaitForChild("Configurations")

dataManager.Profiles = {}

remoteFunctions.GetPlayerProfileData.OnServerInvoke = function(player, target)
	
	target = game.Players:FindFirstChild(target)
	
	if not target then
		return nil
	end
	
	local profile = dataManager.Profiles[target]
	
	if not profile then
		return nil
	end
	
	return profile.Data
	
end

function dataManager:UpdateStage(player, newStage)

	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	player.leaderstats.Stage.Value = newStage
	
	if newStage > profile.Data.Stage then
		profile.Data.Stage = newStage
	end
	
	remoteEvents.UpdateStage:FireClient(player, newStage)
	remoteEvents.SendStageData:FireClient(player, profile.Data.Stage)	
		
end

function dataManager:UpdateCoins(player, amount, bought)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local multiplier, friendCount = dataManager:GetFriendBoostMultiplier(player)
	local updatedAmount
	
	bought = bought or false
	
	if bought then
		updatedAmount = math.floor(amount * multiplier)
	else
		updatedAmount = amount
	end
	
	profile.Data.Coins += updatedAmount
	player.Coins.Value = profile.Data.Coins
	remoteEvents.UpdateCoins:FireClient(player, profile.Data.Coins)
	
	if amount > 0 then
		remoteEvents.CoinsCollected:FireClient(player, updatedAmount, "rbxassetid://87834378311912")
	elseif amount < 0 then
		remoteEvents.CoinsUsed:FireClient(player, updatedAmount, "rbxassetid://87834378311912")
	else
		return
	end
	
end

function dataManager:UpdateBiome(player, newBiome)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local currentBiome = player:FindFirstChild("CurrentBiome")
	
	currentBiome.Value = newBiome
	profile.Data.CurrentBiome = newBiome
	
end

function dataManager:UpdateDeaths(player, amount)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	profile.Data.Deaths += amount
	player.Deaths.Value = profile.Data.Deaths
	
end

function dataManager:UpdateTimePlayed(player, amount)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	profile.Data.TimePlayed += amount
	player.TimePlayed.Value = profile.Data.TimePlayed
	
end

function dataManager:UpdateLoginStreak(player)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local today = os.date("!*t")
	local currentDate = today.year * 10000 + today.month * 100 + today.day
	local lastLogin = profile.Data.LastLoginDate or 0
	
	if lastLogin == currentDate then
		remoteEvents.UpdateLoginStreak:FireClient(player, profile.Data.LoginStreak)
		return
	end
	
	if lastLogin == currentDate - 1 then
		profile.Data.LoginStreak += 1
		player.LoginStreak.Value = profile.Data.LoginStreak
		remoteEvents.UpdateLoginStreak:FireClient(player, profile.Data.LoginStreak)
	else
		profile.Data.LoginStreak = 1
		player.LoginStreak.Value = profile.Data.LoginStreak
		remoteEvents.UpdateLoginStreak:FireClient(player, profile.Data.LoginStreak)
	end
	
	profile.Data.LastLoginDate = currentDate
	
end

function dataManager:UpdateFreeSkips(player, amount)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	if player.PlayerGui.UI.FreeSkips.Frame.TimeLeftBar.LockEffect.Visible == true then
		return
	end
	
	local freeSkips = player:FindFirstChild("FreeSkips")
	
	profile.Data.FreeSkips += amount
	freeSkips.Value = profile.Data.FreeSkips
	remoteEvents.UpdateFreeSkips:FireClient(player, profile.Data.FreeSkips)
	
end

function dataManager:GetFriendBoostMultiplier(player)
	
	local multiplier = 1
	local friendCount = 0
	
	for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player then
			pcall(function()
				if player:IsFriendsWith(otherPlayer.UserId) then
					friendCount += 1
				end
			end)
		end
	end
	
	multiplier += 0.2 * friendCount
	remoteEvents.UpdateFriendBoost:FireClient(player, multiplier)
	
	return multiplier, friendCount
	
end

function dataManager:UpdateMusicVolume(player, newVolume)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local musicVolume = player:FindFirstChild("MusicVolume")
	
	musicVolume.Value = newVolume
	profile.Data.MusicVolume = newVolume
	remoteEvents.UpdateMusicVolume:FireClient(player, profile.Data.MusicVolume)
	
end

function dataManager:UpdateSFXVolume(player, newVolume)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local sfxVolume = player:FindFirstChild("SFXVolume")
	
	sfxVolume.Value = newVolume
	profile.Data.SFXVolume = newVolume
	remoteEvents.UpdateSFXVolume:FireClient(player, profile.Data.SFXVolume)
	
end

function dataManager:UpdateGraphicsQuality(player, newSetting)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local graphicsQuality = player:FindFirstChild("GraphicsQuality")
	
	graphicsQuality.Value = newSetting
	profile.Data.GraphicsQuality = newSetting
	
end

function dataManager:UpdateInvincibility(player, newSetting)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local invincibility = player:FindFirstChild("Invincibility")
	
	invincibility.Value = newSetting
	profile.Data.Invincibility = newSetting
	
end

function dataManager:UpdateTrollsBought(player, amount)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	local trollsBought = player:FindFirstChild("TrollsBought")
	
	profile.Data.TrollsBought += amount
	trollsBought.Value = profile.Data.TrollsBought
	
end

return dataManager
