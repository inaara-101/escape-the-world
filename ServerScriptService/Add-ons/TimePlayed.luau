local dataManager = require(game.ServerScriptService:WaitForChild("Core"):WaitForChild("DataManager"))

game.Players.PlayerAdded:Connect(function(player)
	while player.Parent ~= nil do
		dataManager:UpdateTimePlayed(player, 1)
		task.wait(1.1)
	end
end)
