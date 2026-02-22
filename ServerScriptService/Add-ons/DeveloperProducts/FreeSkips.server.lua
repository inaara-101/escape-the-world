local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local remoteFunctions = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Functions")

remoteEvents.FreeSkipUsed.OnServerEvent:Connect(function(player)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end
	
	dataManager:UpdateFreeSkips(player, -1)
	dataManager:UpdateStage(player, profile.Data.Stage + 1)
	task.wait()
	player.Character.HumanoidRootPart.CFrame = workspace.Checkpoints[player.leaderstats.Stage.Value].Checkpoint.CFrame + Vector3.new(0, 2, 0)
	
end)

remoteEvents.UpdateFreeSkipTimeLeft.OnServerEvent:Connect(function(player, timeLeft)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then 
		return 
	end

	local old = profile.Data.FreeSkipTimeLeft or 1800
	
	profile.Data.FreeSkipTimeLeft = timeLeft
	profile.Data.LastFreeSkipTimerUpdate = tick()

	if old > 0 and timeLeft <= 0 then
		dataManager:UpdateFreeSkips(player, 1)
		profile.Data.FreeSkipTimeLeft = 1800
	end
	
end)

remoteFunctions.GetFreeSkipTimeLeft.OnServerInvoke = function(player)

	local profile = dataManager.Profiles[player]

	if not profile then
		return 1800
	end

	return profile.Data.FreeSkipTimeLeft or 1800

end
