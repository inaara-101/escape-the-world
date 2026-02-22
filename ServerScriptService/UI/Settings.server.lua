local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

remoteEvents.UpdateMusicVolume.OnServerEvent:Connect(function(player, newVolume)
	newVolume = math.clamp(newVolume, 0, 1)
	dataManager:UpdateMusicVolume(player, newVolume)
end)

remoteEvents.UpdateSFXVolume.OnServerEvent:Connect(function(player, newVolume)
	newVolume = math.clamp(newVolume, 0, 1)
	dataManager:UpdateSFXVolume(player, newVolume)
end)

remoteEvents.UpdateGraphicsQuality.OnServerEvent:Connect(function(player, newSetting)
	dataManager:UpdateGraphicsQuality(player, newSetting)
end)

remoteEvents.UpdateInvincibility.OnServerEvent:Connect(function(player, newSetting)
	dataManager:UpdateInvincibility(player, newSetting)
end)
