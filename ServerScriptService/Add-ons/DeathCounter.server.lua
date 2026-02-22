local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		
		local humanoid = character:FindFirstChild("Humanoid")
		
		if humanoid then
			humanoid.Died:Connect(function()
				dataManager:UpdateDeaths(player, 1)
			end)
		end
		
	end)
end)
