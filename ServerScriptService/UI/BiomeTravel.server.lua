local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

remoteEvents.BiomeTravelRequest.OnServerEvent:Connect(function(player, target)
	
	local profile = dataManager.Profiles[player]
	
	if not profile then
		return
	end

	local maxStage = profile.Data.Stage

	if target < 1 or target > maxStage then
		return
	end

	player.leaderstats.Stage.Value = target
	
	if player.Character then
		if player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = workspace.Checkpoints:FindFirstChild(tostring(target)).Checkpoint.CFrame + Vector3.new(0, 2, 0)
			player.CurrentBiome.Value = workspace.Checkpoints:FindFirstChild(tostring(target)):GetAttribute("Biome")
		end
	end
	
	remoteEvents.BiomeTravelConfirm:FireClient(player, target)
	
end)
