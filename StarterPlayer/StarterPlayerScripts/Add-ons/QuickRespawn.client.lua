local UserInputService = game:GetService("UserInputService")
local remoteEvents = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
local player = game.Players.LocalPlayer

UserInputService.InputBegan:Connect(function(key, processed)
	if not processed then
		if key.KeyCode == Enum.KeyCode.R then
			if player.Character then
				if player.Character:FindFirstChild("Humanoid") then
					remoteEvents.QuickRespawnRequest:FireServer()
				end
			end
		end
	end
end)
